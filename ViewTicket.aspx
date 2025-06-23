<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ViewTicket.aspx.vb" Inherits="FactoryMaintenance1.ViewTicket" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfTicketID" runat="server" />

    <%-- SECTION 1: MAIN TICKET DETAILS --%>
    <div class="dashboard-section">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <h2 style="margin-top: 0;">Ticket Details - #<asp:Label ID="lblTicketID" runat="server"></asp:Label></h2>
            <div>
                <strong>Status: </strong>
                <asp:Label ID="lblCurrentStatus" runat="server" Font-Bold="true" Font-Size="Large"></asp:Label>
            </div>
        </div>
        <dx:ASPxFormLayout ID="formLayoutDetails" runat="server" Width="100%" ColumnCount="2">
            <Items>
                <dx:LayoutItem Caption="Machine"><dx:ASPxLabel ID="lblMachine" runat="server"></dx:ASPxLabel></dx:LayoutItem>
                <dx:LayoutItem Caption="Factory"><dx:ASPxLabel ID="lblFactory" runat="server"></dx:ASPxLabel></dx:LayoutItem>
                <dx:LayoutItem Caption="Created On"><dx:ASPxLabel ID="lblCreatedOn" runat="server"></dx:ASPxLabel></dx:LayoutItem>
                <dx:LayoutItem Caption="Created By"><dx:ASPxLabel ID="lblCreatedBy" runat="server"></dx:ASPxLabel></dx:LayoutItem>
                <dx:LayoutItem Caption="Problem Description" ColSpan="2">
                    <dx:ASPxMemo ID="memoProblem" runat="server" ReadOnly="true" Height="80px" Width="100%"></dx:ASPxMemo>
                </dx:LayoutItem>
                <%-- NEW: Label to clearly show who is currently assigned --%>
                <dx:LayoutItem Caption="Currently Assigned To" ColSpan="2">
                    <dx:ASPxLabel ID="lblAssignedTo" runat="server" Font-Bold="true" Text="Unassigned"></dx:ASPxLabel>
                </dx:LayoutItem>
            </Items>
        </dx:ASPxFormLayout>
    </div>

    <%-- SECTION 2: ACTIONS PANEL --%>
    <div class="dashboard-section">
        <h3>Ticket Actions</h3>
        <dx:ASPxPageControl ID="pageControlActions" runat="server" ActiveTabIndex="0" Width="100%">
            <TabPages>
                <dx:TabPage Text="Update Status & Assignment">
                    <ContentCollection>
                        <dx:ContentControl>
                            <dx:ASPxFormLayout ID="formLayoutActions" runat="server" ColumnCount="2">
                                <Items>
                                    <dx:LayoutItem Caption="New Status">
                                        <dx:ASPxComboBox ID="cmbStatus" runat="server" Width="100%">
                                            <Items>
                                                <dx:ListEditItem Text="New" Value="New" />
                                                <dx:ListEditItem Text="Assigned" Value="Assigned" />
                                                <dx:ListEditItem Text="In Progress" Value="In Progress" />
                                                <dx:ListEditItem Text="Awaiting Parts" Value="Awaiting Parts" />
                                                <dx:ListEditItem Text="Sent for Repair" Value="Sent for Repair" />
                                                <dx:ListEditItem Text="Escalated to External" Value="Escalated to External" />
                                                <dx:ListEditItem Text="Completed" Value="Completed" />
                                                <dx:ListEditItem Text="Closed" Value="Closed" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem><dx:ASPxButton ID="btnUpdateStatus" runat="server" Text="Update Status" OnClick="btnUpdateStatus_Click" /></dx:LayoutItem>
                                    
                                    <%-- This panel will be hidden for non-managers --%>
                                    <asp:Panel ID="pnlAssignmentControls" runat="server" CssClass="full-width-panel">
                                        <dx:LayoutGroup Caption="Manager Actions" ColSpan="2" GroupBoxDecoration="Box">
                                            <Items>
                                                <dx:LayoutItem Caption="Assign to Technician">
                                                    <dx:ASPxComboBox ID="cmbTechnician" runat="server" Width="100%" DataSourceID="SqlDataSourceTechnicians" TextField="FullName" ValueField="TechnicianID" NullText="[Select an Internal Technician]"></dx:ASPxComboBox>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem><dx:ASPxButton ID="btnAssign" runat="server" Text="Assign Ticket" OnClick="btnAssign_Click" /></dx:LayoutItem>
                                                <dx:LayoutItem Caption="Assign to External Expert">
                                                    <dx:ASPxComboBox ID="cmbExternalEngineer" runat="server" Width="100%" DataSourceID="SqlDataSourceExternalEngineers" TextField="FullName" ValueField="EngineerID" NullText="[Select an External Expert]"></dx:ASPxComboBox>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem><dx:ASPxButton ID="btnAssignExternal" runat="server" Text="Assign External Expert" OnClick="btnAssignExternal_Click" /></dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup>
                                    </asp:Panel>
                                </Items>
                            </dx:ASPxFormLayout>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="Add Part Used from Inventory">
                    <ContentCollection>
                        <dx:ContentControl>
                             <dx:ASPxFormLayout ID="formLayoutParts" runat="server" ColumnCount="3">
                                <Items>
                                    <dx:LayoutItem Caption="Select Part"><dx:ASPxComboBox ID="cmbParts" runat="server" Width="100%" DataSourceID="SqlDataSourceInventoryParts" TextField="PartName" ValueField="PartID" NullText="[Select a part...]"></dx:ASPxComboBox></dx:LayoutItem>
                                    <dx:LayoutItem Caption="Quantity Used"><dx:ASPxSpinEdit ID="spinQuantity" runat="server" Number="1" MinValue="1" Width="100%"></dx:ASPxSpinEdit></dx:LayoutItem>
                                    <dx:LayoutItem><dx:ASPxButton ID="btnAddPart" runat="server" Text="Add Part" OnClick="btnAddPart_Click" /></dx:LayoutItem>
                                </Items>
                            </dx:ASPxFormLayout>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="Request New Part">
                    <ContentCollection>
                        <dx:ContentControl>
                            <p>If a required part is not in inventory, create a procurement request here.</p>
                            <dx:ASPxFormLayout ID="formLayoutProcurement" runat="server" ColumnCount="2">
                                <Items>
                                    <dx:LayoutItem Caption="Part Name Needed"><dx:ASPxTextBox ID="txtPartNameNeeded" runat="server" Width="100%"></dx:ASPxTextBox></dx:LayoutItem>
                                    <dx:LayoutItem Caption="Part Number (if known)"><dx:ASPxTextBox ID="txtPartNumberNeeded" runat="server" Width="100%"></dx:ASPxTextBox></dx:LayoutItem>
                                    <dx:LayoutItem Caption="Quantity Needed"><dx:ASPxSpinEdit ID="spinQuantityNeeded" runat="server" Number="1" MinValue="1" Width="100%"></dx:ASPxSpinEdit></dx:LayoutItem>
                                    <dx:LayoutItem Caption="Suggested Supplier">
                                        <dx:ASPxComboBox ID="cmbSuggestedSupplier" runat="server" DataSourceID="SqlDataSourceSuppliers" TextField="SupplierName" ValueField="SupplierID" NullText="[Optional]" Width="100%"></dx:ASPxComboBox>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Notes for Procurement Team" ColSpan="2"><dx:ASPxMemo ID="memoRequestNotes" runat="server" Height="60px" Width="100%"></dx:ASPxMemo></dx:LayoutItem>
                                    <dx:LayoutItem><dx:ASPxButton ID="btnSubmitRequest" runat="server" Text="Submit Procurement Request" OnClick="btnSubmitRequest_Click" /></dx:LayoutItem>
                                </Items>
                            </dx:ASPxFormLayout>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="Find Previous Solutions">
                    <ContentCollection>
                        <dx:ContentControl>
                            <p>Search past tickets for similar issues to find experienced technicians or required parts.</p>
                            <dx:ASPxButton ID="btnFindSimilar" runat="server" Text="Find Similar Issues" OnClick="btnFindSimilar_Click" />
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
            </TabPages>
        </dx:ASPxPageControl>
        <dx:ASPxLabel ID="lblActionStatus" runat="server" ClientVisible="false" Font-Bold="true" CssClass="dx-vam" />
    </div>

    <%-- MAINTENANCE CHECKLIST SECTION --%>
    <div class="dashboard-section">
        <h3>Maintenance Checklist</h3>
        <asp:Panel ID="pnlAttachChecklist" runat="server">
            <dx:ASPxFormLayout ID="formLayoutChecklist" runat="server" ColumnCount="2" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Select a Checklist Template"><dx:ASPxComboBox ID="cmbChecklists" runat="server" DataSourceID="SqlDataSourceMasterChecklists" TextField="ChecklistName" ValueField="ChecklistID" Width="100%" NullText="[Select a checklist to attach to this ticket...]"></dx:ASPxComboBox></dx:LayoutItem>
                    <dx:LayoutItem><dx:ASPxButton ID="btnAttachChecklist" runat="server" Text="Attach Checklist" OnClick="btnAttachChecklist_Click" /></dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
        </asp:Panel>
        <asp:Panel ID="pnlActiveChecklist" runat="server" Visible="false">
            <h4>Checklist: <asp:Label ID="lblChecklistName" runat="server" Font-Bold="true"></asp:Label></h4>
            <dx:ASPxGridView ID="gridChecklistTasks" runat="server" Width="100%" KeyFieldName="TicketChecklistTaskID" OnRowUpdating="gridChecklistTasks_RowUpdating" OnCellEditorInitialize="gridChecklistTasks_CellEditorInitialize">
                <Columns>
                    <dx:GridViewCommandColumn ShowEditButton="true" VisibleIndex="0" Caption=" " Width="60px"></dx:GridViewCommandColumn>
                    <dx:GridViewDataCheckColumn FieldName="IsCompleted" Caption="Done" VisibleIndex="1" Width="70px"></dx:GridViewDataCheckColumn>
                    <dx:GridViewDataTextColumn FieldName="TaskDescription" Caption="Task" VisibleIndex="2"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataMemoColumn FieldName="Notes" VisibleIndex="3"></dx:GridViewDataMemoColumn>
                    <dx:GridViewDataTextColumn FieldName="FullName" Caption="Completed By" ReadOnly="True" VisibleIndex="4"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataDateColumn FieldName="CompletionDate" Caption="Completed On" ReadOnly="True" VisibleIndex="5"></dx:GridViewDataDateColumn>
                </Columns>
                <SettingsEditing Mode="Inline" />
            </dx:ASPxGridView>
        </asp:Panel>
    </div>

    <%-- LOGS & PARTS USED GRIDS --%>
    <div style="display:flex; gap: 20px;">
        <div class="dashboard-section" style="flex:1;">
            <h3>Activity Log</h3>
            <dx:ASPxGridView ID="gridLogs" runat="server" Width="100%" KeyFieldName="LogID">
                <Columns>
                    <dx:GridViewDataDateColumn FieldName="LogDate" Caption="Date" SortOrder="Descending" Width="150px"></dx:GridViewDataDateColumn>
                    <dx:GridViewDataTextColumn FieldName="LogText" Caption="Entry"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="FullName" Caption="By User"></dx:GridViewDataTextColumn>
                </Columns>
            </dx:ASPxGridView>
            <div style="margin-top: 15px;">
                <dx:ASPxMemo ID="memoNewLog" runat="server" Width="100%" Height="60px" NullText="Enter new log entry here..."></dx:ASPxMemo>
                <dx:ASPxButton ID="btnAddLog" runat="server" Text="Add Log Entry" OnClick="btnAddLog_Click" style="margin-top: 5px;"></dx:ASPxButton>
            </div>
        </div>
        <div class="dashboard-section" style="flex:1;">
            <h3>Parts Used on this Ticket</h3>
            <dx:ASPxGridView ID="gridPartsUsed" runat="server" Width="100%" KeyFieldName="TicketPartID">
                 <Columns>
                    <dx:GridViewDataTextColumn FieldName="PartName" Caption="Part Name"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="QuantityUsed" Caption="Quantity"></dx:GridViewDataTextColumn>
                </Columns>
            </dx:ASPxGridView>
        </div>
    </div>
    
    <%-- POPUP FOR SIMILAR ISSUES --%>
    <dx:ASPxPopupControl ID="popupSimilarIssues" runat="server" ClientInstanceName="popupSimilarIssues" HeaderText="Similar Past Issues" CloseAction="CloseButton" Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="800px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxGridView ID="gridSimilarIssues" runat="server" AutoGenerateColumns="False" Width="100%" KeyFieldName="TicketID">
                    <Columns>
                        <dx:GridViewDataHyperLinkColumn FieldName="TicketID" Caption="Past Ticket ID" VisibleIndex="0"><PropertiesHyperLinkEdit NavigateUrlFormatString="~/ViewTicket.aspx?TicketID={0}" TextFormatString="View Ticket #{0}" Target="_blank"></PropertiesHyperLinkEdit></dx:GridViewDataHyperLinkColumn>
                        <dx:GridViewDataTextColumn FieldName="ProblemDescription" Caption="Problem" VisibleIndex="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="AssignedTo" Caption="Solved By" VisibleIndex="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="DateCompleted" Caption="Date Solved" VisibleIndex="3"></dx:GridViewDataDateColumn>
                    </Columns>
                    <Settings ShowFilterRow="True" />
                </dx:ASPxGridView>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <%-- DATA SOURCES --%>
    <asp:SqlDataSource ID="SqlDataSourceTechnicians" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>" SelectCommand="SELECT T.TechnicianID, U.FullName FROM Technicians T JOIN Users U ON T.UserID = U.UserID ORDER BY U.FullName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceInventoryParts" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>" SelectCommand="SELECT p.PartID, p.PartName + ' (' + CAST(i.Quantity AS nvarchar) + ' in stock)' AS PartName FROM MachineParts p JOIN Inventory i ON p.PartID = i.PartID WHERE i.Quantity > 0 ORDER BY p.PartName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceExternalEngineers" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>" SelectCommand="SELECT EngineerID, FullName + ' (' + Expertise + ')' AS FullName FROM ExternalEngineers ORDER BY FullName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceMasterChecklists" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>" SelectCommand="SELECT ChecklistID, ChecklistName FROM Checklists ORDER BY ChecklistName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceSuppliers" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>" SelectCommand="SELECT SupplierID, SupplierName FROM Suppliers ORDER BY SupplierName"></asp:SqlDataSource>
</asp:Content>