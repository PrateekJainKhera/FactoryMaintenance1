Public Class Machines
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnGoToCreate_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/CreateMachine.aspx")
    End Sub

End Class