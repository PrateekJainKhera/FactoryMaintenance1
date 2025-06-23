Imports DevExpress.Web.ASPxScheduler

Partial Class SchedulePlanner
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ASPxScheduler1.Storage.Resources.DataSource = SqlDataSourceMachines
        ASPxScheduler1.DataBind()
    End Sub

End Class