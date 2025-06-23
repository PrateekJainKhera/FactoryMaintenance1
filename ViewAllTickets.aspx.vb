' Add this Imports statement at the top to be safe, though not strictly needed for this page's code.
Imports DevExpress.Web

Public Class ViewAllTickets
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' No server-side code is required on page load for this grid to function.
        ' Data binding is handled automatically by the DataSourceID property on the ASPxGridView.
    End Sub

End Class