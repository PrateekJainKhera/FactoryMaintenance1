Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports DevExpress.Web
Imports DevExpress.Web.Data

Public Class ViewTicket
    Inherits System.Web.UI.Page

    Private ticketId As Integer = 0
    Private ReadOnly constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Security checks
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If

        If Not Integer.TryParse(Request.QueryString("TicketID"), ticketId) Then
            formLayoutDetails.Visible = False
            ShowActionMessage("Error: A valid Ticket ID was not provided.", System.Drawing.Color.Red)
            Return
        End If

        hfTicketID.Value = ticketId

        If Not IsPostBack Then
            LoadAllTicketData()
            LoadChecklistData()
            SetUserPermissions() ' Apply role-based visibility
        End If
    End Sub

#Region "Main Data Loading Methods"

    Private Sub LoadAllTicketData()
        LoadTicketDetails()
        LoadTicketLogs()
        LoadPartsUsed()
    End Sub

    Private Sub LoadTicketDetails()
        ' Updated query to also fetch the name of the assigned person
        Dim query As String = "SELECT T.Status, T.ProblemDescription, T.DateCreated, M.MachineName, F.FactoryName, U.FullName AS CreatedBy, " &
                              "COALESCE(InternalUser.FullName, ExternalEng.FullName, 'Unassigned') AS AssignedTo " &
                              "FROM MaintenanceTickets T " &
                              "JOIN Machines M ON T.MachineID = M.MachineID " &
                              "JOIN Factories F ON M.FactoryID = F.FactoryID " &
                              "JOIN Users U ON T.CreatedByUserID = U.UserID " &
                              "LEFT JOIN Technicians InternalTech ON T.AssignedToTechnicianID = InternalTech.TechnicianID " &
                              "LEFT JOIN Users InternalUser ON InternalTech.UserID = InternalUser.UserID " &
                              "LEFT JOIN ExternalEngineers ExternalEng ON T.AssignedToExternalEngineerID = ExternalEng.EngineerID " &
                              "WHERE T.TicketID = @TicketID"

        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@TicketID", ticketId)
                con.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    lblTicketID.Text = ticketId.ToString()
                    lblCurrentStatus.Text = reader("Status").ToString()
                    lblMachine.Text = reader("MachineName").ToString()
                    lblFactory.Text = reader("FactoryName").ToString()
                    lblCreatedOn.Text = Convert.ToDateTime(reader("DateCreated")).ToString("g")
                    lblCreatedBy.Text = reader("CreatedBy").ToString()
                    memoProblem.Text = reader("ProblemDescription").ToString()
                    cmbStatus.Value = reader("Status").ToString()
                    lblAssignedTo.Text = reader("AssignedTo").ToString()
                Else
                    formLayoutDetails.Visible = False
                    ShowActionMessage("Error: Ticket not found.", System.Drawing.Color.Red)
                End If
            End Using
        End Using
    End Sub

    Private Sub LoadTicketLogs()
        Dim query As String = "SELECT L.LogDate, L.LogText, U.FullName FROM TicketLogs L JOIN Users U ON L.UserID = U.UserID WHERE L.TicketID = @TicketID ORDER BY L.LogDate DESC"
        Using dt As New DataTable()
            Using sda As New SqlDataAdapter(query, New SqlConnection(constr))
                sda.SelectCommand.Parameters.AddWithValue("@TicketID", ticketId)
                sda.Fill(dt)
                gridLogs.DataSource = dt
                gridLogs.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadPartsUsed()
        Dim query As String = "SELECT T.TicketPartID, P.PartName, T.QuantityUsed FROM TicketPartsUsed T JOIN MachineParts P ON T.PartID = P.PartID WHERE T.TicketID = @TicketID"
        Using dt As New DataTable()
            Using sda As New SqlDataAdapter(query, New SqlConnection(constr))
                sda.SelectCommand.Parameters.AddWithValue("@TicketID", ticketId)
                sda.Fill(dt)
                gridPartsUsed.DataSource = dt
                gridPartsUsed.DataBind()
            End Using
        End Using
    End Sub

    Private Sub AddLogEntry(logText As String)
        Dim currentUserId As Integer = Convert.ToInt32(Session("UserID"))
        Dim query As String = "INSERT INTO TicketLogs (TicketID, LogText, UserID) VALUES (@TicketID, @LogText, @UserID)"
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@TicketID", ticketId)
                cmd.Parameters.AddWithValue("@LogText", logText)
                cmd.Parameters.AddWithValue("@UserID", currentUserId)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        LoadTicketLogs()
    End Sub

#End Region

#Region "User Permissions"

    Private Sub SetUserPermissions()
        If Session("Role") Is Nothing Then Return
        Dim userRole As String = Session("Role").ToString()

        ' Only Admins or Managers can see the assignment panel.
        If userRole.Equals("Admin", StringComparison.OrdinalIgnoreCase) OrElse userRole.Equals("Manager", StringComparison.OrdinalIgnoreCase) Then
            pnlAssignmentControls.Visible = True
        Else
            pnlAssignmentControls.Visible = False
        End If
    End Sub

#End Region

#Region "Event Handlers for Ticket Actions"

    Protected Sub btnUpdateStatus_Click(sender As Object, e As EventArgs)
        Dim newStatus As String = cmbStatus.Value.ToString()
        Dim query As String = "UPDATE MaintenanceTickets SET Status = @Status WHERE TicketID = @TicketID"
        If newStatus = "Completed" Or newStatus = "Closed" Then
            query = "UPDATE MaintenanceTickets SET Status = @Status, DateCompleted = GETDATE() WHERE TicketID = @TicketID"
        End If
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@Status", newStatus)
                cmd.Parameters.AddWithValue("@TicketID", ticketId)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        AddLogEntry($"Status changed to '{newStatus}' by {Session("Username")}.")
        ShowActionMessage("Status updated successfully.", System.Drawing.Color.Green)
        LoadTicketDetails()
    End Sub

    Protected Sub btnAssign_Click(sender As Object, e As EventArgs)
        If cmbTechnician.Value Is Nothing Then
            ShowActionMessage("Please select a technician to assign.", System.Drawing.Color.Red)
            Return
        End If
        Dim technicianId As Integer = Convert.ToInt32(cmbTechnician.Value)
        Dim query As String = "UPDATE MaintenanceTickets SET AssignedToTechnicianID = @TechnicianID, AssignedToExternalEngineerID = NULL, Status = 'Assigned' WHERE TicketID = @TicketID"
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@TechnicianID", technicianId)
                cmd.Parameters.AddWithValue("@TicketID", ticketId)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        AddLogEntry($"Ticket assigned to internal technician '{cmbTechnician.Text}' by {Session("Username")}.")
        ShowActionMessage("Ticket assigned successfully.", System.Drawing.Color.Green)
        LoadTicketDetails()
    End Sub

    Protected Sub btnAssignExternal_Click(sender As Object, e As EventArgs)
        If cmbExternalEngineer.Value Is Nothing Then
            ShowActionMessage("Please select an external expert to assign.", System.Drawing.Color.Red)
            Return
        End If
        Dim externalEngineerId As Integer = Convert.ToInt32(cmbExternalEngineer.Value)
        Dim query As String = "UPDATE MaintenanceTickets SET AssignedToExternalEngineerID = @EngineerID, AssignedToTechnicianID = NULL, Status = 'Escalated to External' WHERE TicketID = @TicketID"
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@EngineerID", externalEngineerId)
                cmd.Parameters.AddWithValue("@TicketID", ticketId)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        AddLogEntry($"Problem escalated and assigned to external expert '{cmbExternalEngineer.Text}' by {Session("Username")}.")
        ShowActionMessage("Ticket successfully escalated to external expert.", System.Drawing.Color.Green)
        LoadTicketDetails()
    End Sub

    Protected Sub btnAddLog_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(memoNewLog.Text) Then Return
        AddLogEntry(memoNewLog.Text)
        memoNewLog.Text = ""
    End Sub

    Protected Sub btnAddPart_Click(sender As Object, e As EventArgs)
        If cmbParts.Value Is Nothing Or spinQuantity.Value Is Nothing Then
            ShowActionMessage("Please select a part and specify the quantity.", System.Drawing.Color.Red)
            Return
        End If
        Dim partId As Integer = Convert.ToInt32(cmbParts.Value)
        Dim quantityUsed As Integer = Convert.ToInt32(spinQuantity.Value)
        Using con As New SqlConnection(constr)
            con.Open()
            Dim transaction As SqlTransaction = con.BeginTransaction()
            Try
                Dim updateCmd As New SqlCommand("UPDATE Inventory SET Quantity = Quantity - @QuantityUsed WHERE PartID = @PartID", con, transaction)
                updateCmd.Parameters.AddWithValue("@QuantityUsed", quantityUsed)
                updateCmd.Parameters.AddWithValue("@PartID", partId)
                updateCmd.ExecuteNonQuery()
                Dim insertCmd As New SqlCommand("INSERT INTO TicketPartsUsed (TicketID, PartID, QuantityUsed) VALUES (@TicketID, @PartID, @QuantityUsed)", con, transaction)
                insertCmd.Parameters.AddWithValue("@TicketID", ticketId)
                insertCmd.Parameters.AddWithValue("@PartID", partId)
                insertCmd.Parameters.AddWithValue("@QuantityUsed", quantityUsed)
                insertCmd.ExecuteNonQuery()
                transaction.Commit()
                AddLogEntry($"{quantityUsed} x '{cmbParts.Text.Split("(")(0).Trim()}' used for this ticket.")
                ShowActionMessage("Part added successfully.", System.Drawing.Color.Green)
                LoadPartsUsed()
                cmbParts.DataBind()
            Catch ex As Exception
                transaction.Rollback()
                ShowActionMessage("Error adding part: " & ex.Message, System.Drawing.Color.Red)
            End Try
        End Using
    End Sub

    Protected Sub btnFindSimilar_Click(sender As Object, e As EventArgs)
        Dim currentProblem As String = memoProblem.Text
        Dim keywords As String() = currentProblem.Split(New Char() {" "c}, StringSplitOptions.RemoveEmptyEntries)
        If keywords.Length = 0 Then
            ShowActionMessage("Current problem description is empty. Cannot search.", System.Drawing.Color.Red)
            Return
        End If
        Dim queryBuilder As New System.Text.StringBuilder()
        queryBuilder.AppendLine("SELECT TOP 20 T.TicketID, T.ProblemDescription, T.DateCompleted, ")
        queryBuilder.AppendLine("COALESCE(InternalUser.FullName, ExternalEng.FullName, 'Unassigned') AS AssignedTo ")
        queryBuilder.AppendLine("FROM MaintenanceTickets T ")
        queryBuilder.AppendLine("LEFT JOIN Technicians InternalTech ON T.AssignedToTechnicianID = InternalTech.TechnicianID ")
        queryBuilder.AppendLine("LEFT JOIN Users InternalUser ON InternalTech.UserID = InternalUser.UserID ")
        queryBuilder.AppendLine("LEFT JOIN ExternalEngineers ExternalEng ON T.AssignedToExternalEngineerID = ExternalEng.EngineerID ")
        queryBuilder.AppendLine("WHERE T.Status = 'Closed' AND T.TicketID <> @CurrentTicketID AND (")
        For i As Integer = 0 To keywords.Length - 1
            queryBuilder.AppendFormat("T.ProblemDescription LIKE @Keyword{0}", i)
            If i < keywords.Length - 1 Then
                queryBuilder.Append(" OR ")
            End If
        Next
        queryBuilder.AppendLine(")")
        queryBuilder.AppendLine("ORDER BY T.DateCompleted DESC")
        Dim dt As New DataTable()
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(queryBuilder.ToString(), con)
                cmd.Parameters.AddWithValue("@CurrentTicketID", ticketId)
                For i As Integer = 0 To keywords.Length - 1
                    cmd.Parameters.AddWithValue(String.Format("@Keyword{0}", i), "%" & keywords(i) & "%")
                Next
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using
        gridSimilarIssues.DataSource = dt
        gridSimilarIssues.DataBind()
        popupSimilarIssues.ShowOnPageLoad = True
    End Sub

    Protected Sub btnSubmitRequest_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtPartNameNeeded.Text) Then
            ShowActionMessage("Part Name is required for a procurement request.", System.Drawing.Color.Red)
            Return
        End If
        Dim query As String = "INSERT INTO ProcurementRequests (ForTicketID, PartName, PartNumber, QuantityNeeded, SuggestedSupplierID, RequestNotes, RequestStatus, RequestedByUserID) " & "VALUES (@ForTicketID, @PartName, @PartNumber, @QuantityNeeded, @SuggestedSupplierID, @RequestNotes, @RequestStatus, @RequestedByUserID)"
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@ForTicketID", ticketId)
                cmd.Parameters.AddWithValue("@PartName", txtPartNameNeeded.Text)
                cmd.Parameters.AddWithValue("@PartNumber", If(String.IsNullOrWhiteSpace(txtPartNumberNeeded.Text), DBNull.Value, txtPartNumberNeeded.Text))
                cmd.Parameters.AddWithValue("@QuantityNeeded", Convert.ToInt32(spinQuantityNeeded.Value))
                cmd.Parameters.AddWithValue("@SuggestedSupplierID", If(cmbSuggestedSupplier.Value Is Nothing, DBNull.Value, cmbSuggestedSupplier.Value))
                cmd.Parameters.AddWithValue("@RequestNotes", memoRequestNotes.Text)
                cmd.Parameters.AddWithValue("@RequestStatus", "Pending")
                cmd.Parameters.AddWithValue("@RequestedByUserID", Convert.ToInt32(Session("UserID")))
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        AddLogEntry($"Procurement request created for part: {txtPartNameNeeded.Text} (Qty: {spinQuantityNeeded.Value}).")
        ShowActionMessage("Procurement request submitted successfully!", System.Drawing.Color.Green)
        txtPartNameNeeded.Text = ""
        txtPartNumberNeeded.Text = ""
        spinQuantityNeeded.Value = 1
        cmbSuggestedSupplier.Value = Nothing
        memoRequestNotes.Text = ""
    End Sub

#End Region

#Region "Event Handlers for Checklists"
    Private Sub LoadChecklistData()
        Dim ticketChecklistId As Integer = 0
        Dim masterChecklistName As String = ""
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand("SELECT tc.TicketChecklistID, c.ChecklistName FROM TicketChecklists tc JOIN Checklists c ON tc.ChecklistID = c.ChecklistID WHERE tc.TicketID = @TicketID", con)
                cmd.Parameters.AddWithValue("@TicketID", ticketId)
                con.Open()
                Dim reader = cmd.ExecuteReader()
                If reader.Read() Then
                    ticketChecklistId = Convert.ToInt32(reader("TicketChecklistID"))
                    masterChecklistName = reader("ChecklistName").ToString()
                End If
            End Using
        End Using
        If ticketChecklistId > 0 Then
            pnlAttachChecklist.Visible = False
            pnlActiveChecklist.Visible = True
            lblChecklistName.Text = masterChecklistName
            Using dt As New DataTable()
                Dim query As String = "SELECT t.*, u.FullName FROM TicketChecklistTasks t LEFT JOIN Users u ON t.CompletedByUserID = u.UserID WHERE t.TicketChecklistID = @TicketChecklistID ORDER BY t.TicketChecklistTaskID"
                Using sda As New SqlDataAdapter(query, New SqlConnection(constr))
                    sda.SelectCommand.Parameters.AddWithValue("@TicketChecklistID", ticketChecklistId)
                    sda.Fill(dt)
                    gridChecklistTasks.DataSource = dt
                    gridChecklistTasks.DataBind()
                End Using
            End Using
        Else
            pnlAttachChecklist.Visible = True
            pnlActiveChecklist.Visible = False
        End If
    End Sub

    Protected Sub btnAttachChecklist_Click(sender As Object, e As EventArgs)
        If cmbChecklists.Value Is Nothing Then
            ShowActionMessage("Please select a checklist to attach.", System.Drawing.Color.Red)
            Return
        End If
        Dim masterChecklistId As Integer = Convert.ToInt32(cmbChecklists.Value)
        Using con As New SqlConnection(constr)
            con.Open()
            Dim transaction As SqlTransaction = con.BeginTransaction()
            Try
                Dim cmd As New SqlCommand("INSERT INTO TicketChecklists (TicketID, ChecklistID) VALUES (@TicketID, @ChecklistID); SELECT SCOPE_IDENTITY();", con, transaction)
                cmd.Parameters.AddWithValue("@TicketID", ticketId)
                cmd.Parameters.AddWithValue("@ChecklistID", masterChecklistId)
                Dim newTicketChecklistId As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                cmd.CommandText = "INSERT INTO TicketChecklistTasks (TicketChecklistID, TaskDescription) SELECT @TicketChecklistID, TaskDescription FROM ChecklistTasks WHERE ChecklistID = @MasterChecklistID"
                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("@TicketChecklistID", newTicketChecklistId)
                cmd.Parameters.AddWithValue("@MasterChecklistID", masterChecklistId)
                cmd.ExecuteNonQuery()
                transaction.Commit()
                AddLogEntry($"Checklist '{cmbChecklists.Text}' was attached to this ticket.")
            Catch ex As Exception
                transaction.Rollback()
                ShowActionMessage("Error attaching checklist: " & ex.Message, System.Drawing.Color.Red)
                Return
            End Try
        End Using
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub gridChecklistTasks_RowUpdating(sender As Object, e As ASPxDataUpdatingEventArgs)
        Dim taskId As Integer = Convert.ToInt32(e.Keys("TicketChecklistTaskID"))
        Dim isCompleted As Boolean = Convert.ToBoolean(e.NewValues("IsCompleted"))
        Dim notes As String = If(e.NewValues("Notes") IsNot Nothing, e.NewValues("Notes").ToString(), "")
        Dim query As String = "UPDATE TicketChecklistTasks SET IsCompleted = @IsCompleted, Notes = @Notes, CompletionDate = @CompletionDate, CompletedByUserID = @UserID WHERE TicketChecklistTaskID = @TaskID"
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@TaskID", taskId)
                cmd.Parameters.AddWithValue("@IsCompleted", isCompleted)
                cmd.Parameters.AddWithValue("@Notes", notes)
                cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session("UserID")))
                cmd.Parameters.AddWithValue("@CompletionDate", If(isCompleted, DateTime.Now, DBNull.Value))
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        e.Cancel = True
        gridChecklistTasks.CancelEdit()
        LoadChecklistData()
    End Sub

    Protected Sub gridChecklistTasks_CellEditorInitialize(sender As Object, e As ASPxGridViewEditorEventArgs)
        If e.Column.FieldName = "TaskDescription" Then
            e.Editor.ReadOnly = True
        End If
    End Sub
#End Region

#Region "Helper Methods"
    Private Sub ShowActionMessage(message As String, color As System.Drawing.Color)
        lblActionStatus.Text = message
        lblActionStatus.ForeColor = color
        lblActionStatus.ClientVisible = True
    End Sub
#End Region

End Class