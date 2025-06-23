<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Inventory.aspx.vb" Inherits="FactoryMaintenance1.Inventory" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage Inventory</h2>
    <div class="dashboard-section">
        <dx:ASPxGridView ID="gridInventory" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSourceInventory" KeyFieldName="InventoryID" Width="100%">
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                <dx:GridViewDataComboBoxColumn FieldName="PartID" VisibleIndex="1" Caption="Part Name">
                    <PropertiesComboBox DataSourceID="SqlDataSourceParts" TextField="PartName" ValueField="PartID"></PropertiesComboBox>
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataComboBoxColumn FieldName="FactoryID" VisibleIndex="2" Caption="Factory">
                    <PropertiesComboBox DataSourceID="SqlDataSourceFactories" TextField="FactoryName" ValueField="FactoryID"></PropertiesComboBox>
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataTextColumn FieldName="Quantity" VisibleIndex="3"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="LocationInWarehouse" VisibleIndex="4" Caption="Location"></dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="LastUpdated" ReadOnly="True" VisibleIndex="5" Caption="Last Updated"></dx:GridViewDataDateColumn>
            </Columns>
            <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
            <SettingsPager PageSize="10"></SettingsPager>
            <SettingsPopup><EditForm Width="600" /></SettingsPopup>
            <SettingsDataSecurity AllowInsert="True" AllowEdit="True" AllowDelete="True" />
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceInventory" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT * FROM [Inventory]"
            InsertCommand="INSERT INTO [Inventory] ([PartID], [FactoryID], [Quantity], [LocationInWarehouse]) VALUES (@PartID, @FactoryID, @Quantity, @LocationInWarehouse)"
            UpdateCommand="UPDATE [Inventory] SET [PartID] = @PartID, [FactoryID] = @FactoryID, [Quantity] = @Quantity, [LocationInWarehouse] = @LocationInWarehouse, [LastUpdated] = GETDATE() WHERE [InventoryID] = @InventoryID"
            DeleteCommand="DELETE FROM [Inventory] WHERE [InventoryID] = @InventoryID">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceFactories" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT [FactoryID], [FactoryName] FROM [Factories] ORDER BY [FactoryName]">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceParts" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT [PartID], [PartName] FROM [MachineParts] ORDER BY [PartName]">
        </asp:SqlDataSource>
    </div>
</asp:Content>