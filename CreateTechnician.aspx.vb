Imports System.Data.SqlClient
Imports System.Configuration
Imports DevExpress.Web

Public Class CreateTechnician
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnCreateTechnician_Click(sender As Object, e As EventArgs)
        If Not ASPxEdit.AreEditorsValid(Me) Then
            Return
        End If

        Dim userId As Integer = Convert.ToInt32(cmbUser.Value)
        Dim specialization As String = txtSpecialization.Text

        Dim constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString
        Dim query As String = "INSERT INTO Technicians (UserID, Specialization) VALUES (@UserID, @Specialization)"

        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@UserID", userId)
                cmd.Parameters.AddWithValue("@Specialization", specialization)
                Try
                    con.Open()
                    cmd.ExecuteNonQuery()
                    lblStatusMessage.Text = "Success! User has been designated as a technician."
                    lblStatusMessage.ForeColor = System.Drawing.Color.Green

                    ' Refresh the dropdown to remove the user who was just added
                    cmbUser.DataBind()
                    txtSpecialization.Text = ""
                Catch ex As Exception
                    lblStatusMessage.Text = "An error occurred: " & ex.Message
                    lblStatusMessage.ForeColor = System.Drawing.Color.Red
                Finally
                    lblStatusMessage.ClientVisible = True
                End Try
            End Using
        End Using
    End Sub
End Class