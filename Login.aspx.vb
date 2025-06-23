Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Security.Cryptography
Imports System.Text
Imports System.Web.Security

Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        Dim username As String = txtUsername.Text
        Dim enteredPassword As String = txtPassword.Text
        Dim passwordHash As String = HashPassword(enteredPassword)

        Dim constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString
        Using con As New SqlConnection(constr)
            ' Use parameters to prevent SQL Injection
            Dim query As String = "SELECT UserID, PasswordHash, Role FROM Users WHERE Username = @Username"
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@Username", username)
                con.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()

                If reader.Read() Then
                    Dim storedHash As String = reader("PasswordHash").ToString()
                    If storedHash.Equals(passwordHash) Then
                        ' Passwords match - successful login
                        Dim userId As Integer = Convert.ToInt32(reader("UserID"))
                        Dim role As String = reader("Role").ToString()

                        ' Store user info in session for easy access
                        Session("UserID") = userId
                        Session("Username") = username
                        Session("Role") = role

                        ' Use Forms Authentication to set the auth cookie and redirect
                        FormsAuthentication.RedirectFromLoginPage(username, False)

                    Else
                        ' Password incorrect
                        ShowError("Invalid username or password.")
                    End If
                Else
                    ' User not found
                    ShowError("Invalid username or password.")
                End If

                reader.Close()
                con.Close()
            End Using
        End Using
    End Sub

    ' This function MUST be identical to the one in Register.aspx.vb
    Private Function HashPassword(password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = sha256.ComputeHash(Encoding.UTF8.GetBytes(password))
            Dim builder As New StringBuilder()
            For i As Integer = 0 To bytes.Length - 1
                builder.Append(bytes(i).ToString("x2"))
            Next
            Return builder.ToString()
        End Using
    End Function

    Private Sub ShowError(message As String)
        lblError.Text = message
        lblError.ClientVisible = True
    End Sub
End Class