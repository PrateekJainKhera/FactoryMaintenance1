<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Machines.aspx.vb" Inherits="FactoryMaintenance1.Machines" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage Machines</h2>
    <div style="margin-bottom: 20px;">
    
        <dx:ASPxButton ID="btnGoToCreate" runat="server"
            Text="Add New Machine"
            AutoPostBack="true"
            OnClick="btnGoToCreate_Click"
            Theme="Moderno">
        </dx:ASPxButton>
</div>
    <div class="dashboard-section">
        <dx:ASPxGridView ID="gridMachines" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSourceMachines" KeyFieldName="MachineID" Width="100%">
            <Columns>
                <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0"></dx:GridViewCommandColumn>                <dx:GridViewDataTextColumn FieldName="MachineID" ReadOnly="True" VisibleIndex="1" Caption="ID"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="MachineName" VisibleIndex="2"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="MachineTag" VisibleIndex="3" Caption="Tag/Code"></dx:GridViewDataTextColumn>
                <dx:GridViewDataComboBoxColumn FieldName="FactoryID" VisibleIndex="4" Caption="Factory">
                    <PropertiesComboBox DataSourceID="SqlDataSourceFactories" TextField="FactoryName" ValueField="FactoryID"></PropertiesComboBox>
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataTextColumn FieldName="LocationInFactory" VisibleIndex="5" Caption="Location"></dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="InstallDate" VisibleIndex="6" Caption="Install Date"></dx:GridViewDataDateColumn>
            </Columns>
            <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
            <SettingsPager PageSize="10"></SettingsPager>
            <SettingsPopup>
                <EditForm Width="600" />
            </SettingsPopup>
            <SettingsDataSecurity AllowInsert="True" AllowEdit="True" AllowDelete="True" />
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceMachines" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT * FROM [Machines]"
            InsertCommand="INSERT INTO [Machines] ([MachineName], [MachineTag], [FactoryID], [LocationInFactory], [InstallDate]) VALUES (@MachineName, @MachineTag, @FactoryID, @LocationInFactory, @InstallDate)"
            UpdateCommand="UPDATE [Machines] SET [MachineName] = @MachineName, [MachineTag] = @MachineTag, [FactoryID] = @FactoryID, [LocationInFactory] = @LocationInFactory, [InstallDate] = @InstallDate WHERE [MachineID] = @MachineID"
            DeleteCommand="DELETE FROM [Machines] WHERE [MachineID] = @MachineID">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceFactories" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT [FactoryID], [FactoryName] FROM [Factories] ORDER BY [FactoryName]">
        </asp:SqlDataSource>
    </div>
</asp:Content>