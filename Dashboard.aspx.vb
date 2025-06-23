Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports DevExpress.Web

Public Class Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
        ' No other code is needed here. Binding is now automatic.
    End Sub

    ' The BindNotifications() sub is no longer needed and has been removed.

    ' This event handler correctly colors the rows of overdue tickets in the grid.
    Protected Sub gridLiveTickets_HtmlRowPrepared(sender As Object, e As ASPxGridViewTableRowEventArgs)
        If e.RowType <> GridViewRowType.Data Then
            Return
        End If

        Dim hoursOpen As Integer = Convert.ToInt32(e.GetValue("HoursOpen"))

        ' Set a threshold. Any ticket open for more than 24 hours is overdue.
        If hoursOpen > 24 Then
            e.Row.CssClass = "overdue-ticket"
        End If
    End Sub

End Class