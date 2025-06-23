Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.Services ' Required for [WebMethod]
Imports Newtonsoft.Json     ' Required for serializing data to JSON

Partial Class Insights
    Inherits System.Web.UI.Page

    Const LossPerHourRate As Decimal = 13333333 ' Example Rate

    Private Shared ReadOnly constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString

    ' This method still runs normally to load the top KPIs
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadKPIs()
        End If
    End Sub

    Private Sub LoadKPIs()
        Dim totalDowntimeHours As Integer = 0
        Dim query As String = "SELECT SUM(DATEDIFF(hour, DateCreated, DateCompleted)) FROM MaintenanceTickets WHERE Status = 'Closed' AND DateCompleted IS NOT NULL"
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                con.Open()
                Dim result = cmd.ExecuteScalar()
                If result IsNot DBNull.Value Then
                    totalDowntimeHours = Convert.ToInt32(result)
                End If
            End Using
        End Using
        lblTotalDowntime.Text = $"{totalDowntimeHours:N0} Hours"
        Dim financialLoss As Decimal = totalDowntimeHours * LossPerHourRate
        lblFinancialLoss.Text = $"₹ {financialLoss:N0}"
    End Sub

    ' --- WEB METHODS TO PROVIDE DATA TO DEVEXTREME CHARTS ---

    <WebMethod()>
    Public Shared Function GetDowntimeData() As String
        Dim query As String = "SELECT M.MachineName, SUM(DATEDIFF(hour, T.DateCreated, T.DateCompleted)) AS TotalDowntime " &
                              "FROM MaintenanceTickets T JOIN Machines M ON T.MachineID = M.MachineID " &
                              "WHERE T.Status = 'Closed' AND T.DateCompleted IS NOT NULL " &
                              "GROUP BY M.MachineName " &
                              "HAVING SUM(DATEDIFF(hour, T.DateCreated, T.DateCompleted)) > 0 " &
                              "ORDER BY TotalDowntime DESC"

        Dim dt As New DataTable()
        Using con As New SqlConnection(constr)
            Using sda As New SqlDataAdapter(query, con)
                sda.Fill(dt)
            End Using
        End Using
        ' Serialize the DataTable to a JSON string and return it
        Return JsonConvert.SerializeObject(dt)
    End Function

    <WebMethod()>
    Public Shared Function GetTicketTypeData() As String
        Dim query As String = "SELECT TicketType, COUNT(*) AS TicketCount FROM MaintenanceTickets GROUP BY TicketType"
        Dim dt As New DataTable()
        Using con As New SqlConnection(constr)
            Using sda As New SqlDataAdapter(query, con)
                sda.Fill(dt)
            End Using
        End Using
        ' Serialize the DataTable to a JSON string and return it
        Return JsonConvert.SerializeObject(dt)
    End Function

End Class