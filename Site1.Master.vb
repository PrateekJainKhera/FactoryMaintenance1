Public Class Site1
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ' Check if the user is authenticated
            If Context.User.Identity.IsAuthenticated Then
                lblUser.Text = "Welcome, " & Context.User.Identity.Name
                lnkLogout.Visible = True
            Else
                lblUser.Visible = False
                lnkLogout.Visible = False
            End If
        End If
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        FormsAuthentication.SignOut()
        Session.Abandon()
        Response.Redirect("~/Login.aspx")
    End Sub

End Class