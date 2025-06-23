<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Technicians.aspx.vb" Inherits="FactoryMaintenance1.Technicians" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage Technicians</h2>

    <div style="margin-bottom: 20px;">
        <dx:ASPxButton ID="btnGoToCreate" runat="server"
            Text="Create New Technician Profile"
            AutoPostBack="true"
            OnClick="btnGoToCreate_Click"
            Theme="Moderno">
        </dx:ASPxButton>
    </div>

    <div class="dashboard-section">
        <dx:ASPxGridView ID="gridTechnicians" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceTechnicians" KeyFieldName="TechnicianID" Width="100%">
            <Columns>
                <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                <dx:GridViewDataTextColumn FieldName="TechnicianID" ReadOnly="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="FullName" ReadOnly="True" VisibleIndex="2" Caption="Name"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Username" ReadOnly="True" VisibleIndex="3"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Specialization" VisibleIndex="4"></dx:GridViewDataTextColumn>
            </Columns>
            <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
            <SettingsDataSecurity AllowEdit="True" AllowDelete="True" />
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceTechnicians" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT T.TechnicianID, U.FullName, U.Username, T.Specialization FROM Technicians T JOIN Users U ON T.UserID = U.UserID"
            UpdateCommand="UPDATE Technicians SET Specialization = @Specialization WHERE TechnicianID = @TechnicianID"
            DeleteCommand="DELETE FROM Technicians WHERE TechnicianID = @TechnicianID"></asp:SqlDataSource>
    </div>
</asp:Content>