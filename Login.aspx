<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="FactoryMaintenance1.Login" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/23.2.3/css/dx.light.css" />
    <style> body { display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; } .login-panel { padding: 40px; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 350px; } </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-panel">
            <h2>Factory Login</h2>
            <dx:ASPxTextBox ID="txtUsername" runat="server" Width="100%" NullText="Username"></dx:ASPxTextBox>
            <br /><br />
            <dx:ASPxTextBox ID="txtPassword" runat="server" Width="100%" Password="True" NullText="Password"></dx:ASPxTextBox>
            <br /><br />
            <dx:ASPxButton ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" Width="100%"></dx:ASPxButton>
            <br />
            <dx:ASPxLabel ID="lblError" runat="server" ForeColor="Red" ClientVisible="false"></dx:ASPxLabel>
            <br />
            <div style="text-align:center; margin-top:10px;">
                <a href="Register.aspx">Create a new account</a>
            </div>
        </div>
    </form>
</body>
</html>
