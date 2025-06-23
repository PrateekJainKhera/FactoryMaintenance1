<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Register.aspx.vb" Inherits="FactoryMaintenance1.Register" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Register</title>
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/23.2.3/css/dx.light.css" />
    <style> body { display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; } .login-panel { padding: 40px; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 350px; } </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-panel">
            <h2>Create Account</h2>
            <dx:ASPxFormLayout ID="formLayout" runat="server" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Full Name">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox ID="txtFullName" runat="server" Width="100%"></dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Username">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox ID="txtUsername" runat="server" Width="100%"></dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Password">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox ID="txtPassword" runat="server" Width="100%" Password="True"></dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Home Factory">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxComboBox ID="cmbFactory" runat="server" ValueType="System.Int32" TextField="FactoryName" ValueField="FactoryID" Width="100%"></dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
            <br />
            <dx:ASPxButton ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" Width="100%"></dx:ASPxButton>
            <br />
            <dx:ASPxLabel ID="lblError" runat="server" ForeColor="Red" ClientVisible="false"></dx:ASPxLabel>
            <br />
            <div style="text-align:center; margin-top:10px;">
                <a href="Login.aspx">Already have an account? Login</a>
            </div>
        </div>
    </form>
</body>
</html>
