<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Suppliers.aspx.vb" Inherits="FactoryMaintenance1.Suppliers" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage Suppliers</h2>
    <div class="dashboard-section">
        <dx:ASPxGridView ID="gridSuppliers" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceSuppliers" KeyFieldName="SupplierID" Width="100%">
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                <dx:GridViewDataTextColumn FieldName="SupplierID" ReadOnly="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="SupplierName" VisibleIndex="2"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ContactPerson" VisibleIndex="3"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Phone" VisibleIndex="4"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Email" VisibleIndex="5"></dx:GridViewDataTextColumn>
            </Columns>
            <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
            <SettingsDataSecurity AllowInsert="True" AllowEdit="True" AllowDelete="True" />
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceSuppliers" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT * FROM [Suppliers]"
            InsertCommand="INSERT INTO [Suppliers] ([SupplierName], [ContactPerson], [Phone], [Email]) VALUES (@SupplierName, @ContactPerson, @Phone, @Email)"
            UpdateCommand="UPDATE [Suppliers] SET [SupplierName] = @SupplierName, [ContactPerson] = @ContactPerson, [Phone] = @Phone, [Email] = @Email WHERE [SupplierID] = @SupplierID"
            DeleteCommand="DELETE FROM [Suppliers] WHERE [SupplierID] = @SupplierID">
        </asp:SqlDataSource>
    </div>
</asp:Content>
