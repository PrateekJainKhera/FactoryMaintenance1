Imports DevExpress.Web

Public Class ManageChecklists
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' No code is needed on initial page load.
    End Sub

    ' This event fires right before the detail grid tries to fetch its data.
    ' It's the perfect place to tell the data source which master row was selected.
    Protected Sub gridTasks_BeforePerformDataSelect(sender As Object, e As EventArgs)
        ' Get a reference to the detail grid that fired this event.
        Dim detailGrid As ASPxGridView = CType(sender, ASPxGridView)

        ' Store the key value (the ChecklistID) of the master row in a Session variable.
        ' The SqlDataSource for the tasks is configured to use this Session variable as its parameter.
        Session("SelectedChecklistID") = detailGrid.GetMasterRowKeyValue()
    End Sub

    ' This is an optional but helpful event to ensure the data is fresh when a new row is expanded.
    Protected Sub gridChecklists_DetailRowExpandedChanged(sender As Object, e As ASPxGridViewDetailRowEventArgs)
        If e.Expanded Then
            Dim masterGrid As ASPxGridView = CType(sender, ASPxGridView)
            ' Get the ChecklistID from the row that was just expanded.
            Dim checklistID As Object = masterGrid.GetRowValues(e.VisibleIndex, "ChecklistID")
            If checklistID IsNot Nothing Then
                Session("SelectedChecklistID") = Convert.ToInt32(checklistID)
            End If
        End If
    End Sub

End Class