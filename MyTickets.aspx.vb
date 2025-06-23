Public Class MyTickets
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Security check to ensure a user is logged in
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

End Class