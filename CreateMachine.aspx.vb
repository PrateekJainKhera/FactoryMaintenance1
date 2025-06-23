Imports System.Configuration
Imports System.Data.SqlClient
Imports DevExpress.Web

Partial Class CreateMachine
    Inherits System.Web.UI.Page

    Protected Sub btnCreateMachine_Click(sender As Object, e As EventArgs)
        If Not ASPxEdit.AreEditorsValid(Me) Then
            Return
        End If

        Dim constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString
        Dim query As String = "INSERT INTO Machines (MachineName, MachineTag, FactoryID, LocationInFactory, InstallDate) VALUES (@MachineName, @MachineTag, @FactoryID, @LocationInFactory, @InstallDate)"

        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@MachineName", txtMachineName.Text)
                cmd.Parameters.AddWithValue("@MachineTag", txtMachineTag.Text)
                cmd.Parameters.AddWithValue("@FactoryID", cmbFactory.Value)
                cmd.Parameters.AddWithValue("@LocationInFactory", txtLocationInFactory.Text)

                ' Handle if date is not selected to avoid errors
                If dateInstall.Value IsNot Nothing Then
                    cmd.Parameters.AddWithValue("@InstallDate", dateInstall.Value)
                Else
                    cmd.Parameters.AddWithValue("@InstallDate", DBNull.Value)
                End If

                Try
                    con.Open()
                    cmd.ExecuteNonQuery()
                    lblStatusMessage.Text = "Success! New machine has been added. You can add another or navigate away."
                    lblStatusMessage.ForeColor = System.Drawing.Color.Green
                    ClearForm() ' Clear the form for a new entry
                Catch ex As Exception
                    ' Check for a unique constraint violation on MachineTag, which is a common error
                    If ex.Message.Contains("UNIQUE KEY constraint") Then
                        lblStatusMessage.Text = "Error: A machine with this Tag/Code already exists. Please use a unique tag."
                    Else
                        lblStatusMessage.Text = "An error occurred: " & ex.Message
                    End If
                    lblStatusMessage.ForeColor = System.Drawing.Color.Red
                Finally
                    lblStatusMessage.ClientVisible = True
                    con.Close()
                End Try
            End Using
        End Using
    End Sub

    Private Sub ClearForm()
        txtMachineName.Text = ""
        txtMachineTag.Text = ""
        cmbFactory.Value = Nothing
        txtLocationInFactory.Text = ""
        dateInstall.Value = Nothing
    End Sub

End Class