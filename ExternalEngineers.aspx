<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ExternalEngineers.aspx.vb" Inherits="FactoryMaintenance1.ExternalEngineers" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage External Engineers & Experts</h2>
    <div class="dashboard-section">
        <dx:ASPxGridView ID="gridExternalEngineers" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSourceEngineers" KeyFieldName="EngineerID" Width="100%">
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                <dx:GridViewDataTextColumn FieldName="FullName" VisibleIndex="1" Caption="Name"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Company" VisibleIndex="2"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ContactPhone" VisibleIndex="3" Caption="Phone"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ContactEmail" VisibleIndex="4" Caption="Email"></dx:GridViewDataTextColumn>
                <dx:GridViewDataMemoColumn FieldName="Expertise" VisibleIndex="5"></dx:GridViewDataMemoColumn>
                <dx:GridViewDataMemoColumn FieldName="Notes" VisibleIndex="6" Caption="Notes (e.g., Past Work)">
                    <EditFormSettings Caption="Notes (e.g., Solved motor issue on PUN-GRD-01)" />
                </dx:GridViewDataMemoColumn>
            </Columns>
            <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
            <SettingsPopup>
                <EditForm Width="700" />
            </SettingsPopup>
            <SettingsDataSecurity AllowInsert="True" AllowEdit="True" AllowDelete="True" />
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceEngineers" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT * FROM [ExternalEngineers]"
            InsertCommand="INSERT INTO [ExternalEngineers] ([FullName], [Company], [ContactPhone], [ContactEmail], [Expertise], [Notes]) VALUES (@FullName, @Company, @ContactPhone, @ContactEmail, @Expertise, @Notes)"
            UpdateCommand="UPDATE [ExternalEngineers] SET [FullName] = @FullName, [Company] = @Company, [ContactPhone] = @ContactPhone, [ContactEmail] = @ContactEmail, [Expertise] = @Expertise, [Notes] = @Notes WHERE [EngineerID] = @EngineerID"
            DeleteCommand="DELETE FROM [ExternalEngineers] WHERE [EngineerID] = @EngineerID">
        </asp:SqlDataSource>
    </div>
</asp:Content>