Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Security.Cryptography
Imports System.Text

Partial Class Register
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindFactories()
        End If
    End Sub

    Private Sub BindFactories()
        Dim constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand("SELECT FactoryID, FactoryName FROM Factories ORDER BY FactoryName", con)
                con.Open()
                cmbFactory.DataSource = cmd.ExecuteReader()
                cmbFactory.DataBind()
                con.Close()
            End Using
        End Using
    End Sub

    Protected Sub btnRegister_Click(sender As Object, e As EventArgs)
        ' Simple Validation
        If String.IsNullOrWhiteSpace(txtUsername.Text) OrElse String.IsNullOrWhiteSpace(txtPassword.Text) OrElse String.IsNullOrWhiteSpace(txtFullName.Text) OrElse cmbFactory.Value Is Nothing Then
            ShowError("All fields are required.")
            Return
        End If

        Dim username As String = txtUsername.Text
        Dim passwordHash As String = HashPassword(txtPassword.Text)
        Dim fullName As String = txtFullName.Text
        Dim factoryId As Integer = Convert.ToInt32(cmbFactory.Value)
        ' Default role for new users. You can make this more complex later.
        Dim role As String = "Engineer"

        Dim constr As String = ConfigurationManager.ConnectionStrings("FactoryDB_ConnectionString").ConnectionString
        Using con As New SqlConnection(constr)
            ' Check if username already exists
            Using checkCmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Username = @Username", con)
                checkCmd.Parameters.AddWithValue("@Username", username)
                con.Open()
                Dim userExists As Integer = CInt(checkCmd.ExecuteScalar())
                If userExists > 0 Then
                    ShowError("Username already exists. Please choose another.")
                    Return
                End If
                con.Close()
            End Using

            ' Insert new user
            Using cmd As New SqlCommand("INSERT INTO Users (Username, PasswordHash, FullName, Role, FactoryID) VALUES (@Username, @PasswordHash, @FullName, @Role, @FactoryID)", con)
                cmd.Parameters.AddWithValue("@Username", username)
                cmd.Parameters.AddWithValue("@PasswordHash", passwordHash)
                cmd.Parameters.AddWithValue("@FullName", fullName)
                cmd.Parameters.AddWithValue("@Role", role)
                cmd.Parameters.AddWithValue("@FactoryID", factoryId)

                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
            End Using
        End Using

        Response.Redirect("Login.aspx?status=registered")
    End Sub

    ' IMPORTANT: Never store passwords in plain text!
    ' This function creates a SHA256 hash of the password.
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