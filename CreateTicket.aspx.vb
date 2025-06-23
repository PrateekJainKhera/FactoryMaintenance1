Imports System.Configuration
Imports System.Data.SqlClient
Imports DevExpress.Web

Partial Class CreateTicket
    Inherits System.Web.UI.Page

    Protected Sub btnSubmitTicket_Click(sender As Object, e As EventArgs)
        ' Validate the form controls first
        If Not ASPxEdit.AreEditorsValid(Me) Then
            Return
        End If

        ' Get values from the form
        Dim machineId As Integer = Convert.ToInt32(cmbMachine.Value)
        Dim problemDescription As String = memoProblemDescription.Text
        Dim createdByUserId As Integer = Convert.ToInt32(Session("UserID"))

        ' Prepare SQL command to insert the new ticket
        Dim constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString
        Dim query As String = "INSERT INTO MaintenanceTickets (MachineID, TicketType, ProblemDescription, Status, CreatedByUserID, DateCreated) " &
                              "VALUES (@MachineID, @TicketType, @ProblemDescription, @Status, @CreatedByUserID, @DateCreated); SELECT SCOPE_IDENTITY();"

        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                ' Use parameters to prevent SQL Injection
                cmd.Parameters.AddWithValue("@MachineID", machineId)
                cmd.Parameters.AddWithValue("@TicketType", "Sudden") 'This is a reactive maintenance ticket
                cmd.Parameters.AddWithValue("@ProblemDescription", problemDescription)
                cmd.Parameters.AddWithValue("@Status", "New") 'All new tickets start with this status
                cmd.Parameters.AddWithValue("@CreatedByUserID", createdByUserId)
                cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now)

                Try
                    con.Open()
                    ' Execute the command and get the new Ticket ID
                    Dim newTicketId As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    con.Close()

                    ' Show a success message
                    lblStatusMessage.Text = $"Success! New ticket #{newTicketId} has been created."
                    lblStatusMessage.ForeColor = System.Drawing.Color.Green
                    lblStatusMessage.ClientVisible = True

                    ' Clear the form for the next entry
                    cmbMachine.Value = Nothing
                    memoProblemDescription.Text = ""

                Catch ex As Exception
                    ' Show an error message
                    lblStatusMessage.Text = "Error: Could not create the ticket. " & ex.Message
                    lblStatusMessage.ForeColor = System.Drawing.Color.Red
                    lblStatusMessage.ClientVisible = True
                End Try
            End Using
        End Using
    End Sub


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if a MachineID was passed in the URL from the dashboard
            If Request.QueryString("MachineID") IsNot Nothing Then
                Try
                    ' Pre-select the machine in the dropdown
                    Dim machineId As String = Request.QueryString("MachineID")
                    cmbMachine.Value = Convert.ToInt32(machineId)

                    ' Pre-fill the problem description
                    If Request.QueryString("Desc") IsNot Nothing Then
                        memoProblemDescription.Text = "Scheduled Maintenance: " & Request.QueryString("Desc")
                    End If

                    ' You could also set the Ticket Type here if you add that field to the form
                Catch ex As Exception
                    ' Handle potential errors if the MachineID is invalid
                    ' For now, we can just ignore it and let the user select manually
                End Try
            End If
        End If
    End Sub
End Class