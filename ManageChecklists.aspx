<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ManageChecklists.aspx.vb" Inherits="FactoryMaintenance1.ManageChecklists" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Manage Maintenance Checklists</h2>
    <p>Create and manage the standard task lists for your maintenance procedures. Expand a row to see its tasks.</p>

    <div class="dashboard-section">
        <%-- MASTER GRID: Shows the main checklists --%>
        <dx:ASPxGridView ID="gridChecklists" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSourceChecklists" KeyFieldName="ChecklistID" Width="100%"
            OnDetailRowExpandedChanged="gridChecklists_DetailRowExpandedChanged">
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                <dx:GridViewDataTextColumn FieldName="ChecklistID" ReadOnly="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ChecklistName" VisibleIndex="2"></dx:GridViewDataTextColumn>

                <%-- =============================================== --%>
                <%--                  THIS IS THE FIX                --%>
                <%-- =============================================== --%>
                <dx:GridViewDataMemoColumn FieldName="Description" VisibleIndex="3">
                    <EditItemTemplate>
                        <dx:ASPxMemo ID="memoDescription" runat="server" Text='<%# Bind("Description") %>' 
                            Width="100%" Height="80px">
                        </dx:ASPxMemo>
                    </EditItemTemplate>
                </dx:GridViewDataMemoColumn>

            </Columns>
            <SettingsDetail ShowDetailRow="True" />
            <Templates>
                <DetailRow>
                    <h4>Tasks for: <%# Eval("ChecklistName") %></h4>
                    <%-- DETAIL GRID: Shows the tasks for the selected checklist --%>
                    <dx:ASPxGridView ID="gridTasks" runat="server" AutoGenerateColumns="False" 
                        DataSourceID="SqlDataSourceTasks" KeyFieldName="TaskID" Width="100%"
                        OnBeforePerformDataSelect="gridTasks_BeforePerformDataSelect">
                        <Columns>
                            <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="TaskID" ReadOnly="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="TaskDescription" Caption="Task Description" VisibleIndex="2"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="DisplayOrder" Caption="Order" VisibleIndex="3"></dx:GridViewDataSpinEditColumn>
                        </Columns>
                        <SettingsEditing Mode="PopupEditForm" />
                        <SettingsDataSecurity AllowInsert="True" AllowEdit="True" AllowDelete="True" />
                    </dx:ASPxGridView>
                </DetailRow>
            </Templates>
            <SettingsEditing Mode="PopupEditForm" />
            <SettingsDataSecurity AllowInsert="True" AllowEdit="True" AllowDelete="True" />
            <SettingsPopup>
                <EditForm Width="600" />
            </SettingsPopup>
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceChecklists" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT [ChecklistID], [ChecklistName], [Description] FROM [Checklists]"
            InsertCommand="INSERT INTO [Checklists] ([ChecklistName], [Description]) VALUES (@ChecklistName, @Description)"
            UpdateCommand="UPDATE [Checklists] SET [ChecklistName] = @ChecklistName, [Description] = @Description WHERE [ChecklistID] = @ChecklistID"
            DeleteCommand="DELETE FROM [Checklists] WHERE [ChecklistID] = @ChecklistID">
        </asp:SqlDataSource>
        
        <asp:SqlDataSource ID="SqlDataSourceTasks" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT [TaskID], [ChecklistID], [TaskDescription], [DisplayOrder] FROM [ChecklistTasks] WHERE ([ChecklistID] = @ChecklistID) ORDER BY [DisplayOrder]"
            DeleteCommand="DELETE FROM [ChecklistTasks] WHERE [TaskID] = @TaskID"
            InsertCommand="INSERT INTO [ChecklistTasks] ([ChecklistID], [TaskDescription], [DisplayOrder]) VALUES (@ChecklistID, @TaskDescription, @DisplayOrder)"
            UpdateCommand="UPDATE [ChecklistTasks] SET [TaskDescription] = @TaskDescription, [DisplayOrder] = @DisplayOrder WHERE [TaskID] = @TaskID">
            <SelectParameters>
                <asp:SessionParameter Name="ChecklistID" SessionField="SelectedChecklistID" Type="Int32" />
            </SelectParameters>
            <InsertParameters>
                <asp:SessionParameter Name="ChecklistID" SessionField="SelectedChecklistID" Type="Int32" />
            </InsertParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>