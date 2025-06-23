<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ViewAllTickets.aspx.vb" Inherits="FactoryMaintenance1.ViewAllTickets" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%-- Style block for the visual status badges --%>
    <style>
        .status-badge {
            padding: 3px 8px;
            border-radius: 10px;
            color: white;
            font-weight: bold;
            font-size: 12px;
            text-align: center;
            display: inline-block;
            min-width: 90px;
        }
        .status-new { background-color: #007bff; }
        .status-assigned { background-color: #ffc107; color: black; }
        .status-inprogress { background-color: #fd7e14; }
        .status-awaitingparts { background-color: #6f42c1; }
        .status-completed { background-color: #28a745; }
        .status-closed { background-color: #6c757d; }
    </style>

    <h2>All Maintenance Tickets</h2>
    <div class="dashboard-section">
        <dx:ASPxGridView ID="gridAllTickets" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceAllTickets" KeyFieldName="TicketID" Width="100%">
            <Columns>
                <dx:GridViewDataHyperLinkColumn FieldName="TicketID" VisibleIndex="0" Caption="Ticket ID">
                    <PropertiesHyperLinkEdit NavigateUrlFormatString="~/ViewTicket.aspx?TicketID={0}" TextFormatString="{0}"></PropertiesHyperLinkEdit>
                </dx:GridViewDataHyperLinkColumn>
                <dx:GridViewDataTextColumn FieldName="FactoryName" VisibleIndex="1"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="MachineName" VisibleIndex="2"></dx:GridViewDataTextColumn>
                
                <%-- Status column with a DataItemTemplate for visual badges --%>
                <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="3">
                    <DataItemTemplate>
                        <div class='status-badge status-<%# Eval("Status").ToString().Replace(" ", "").ToLower() %>'>
                            <%# Eval("Status") %>
                        </div>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>

                <%-- "Assigned To" column to show the responsible person/group --%>
                <dx:GridViewDataTextColumn FieldName="AssignedTo" VisibleIndex="4" Caption="Assigned To"></dx:GridViewDataTextColumn>
                
                <dx:GridViewDataDateColumn FieldName="DateCreated" VisibleIndex="5" Caption="Created On" SortOrder="Descending"></dx:GridViewDataDateColumn>
                <dx:GridViewDataDateColumn FieldName="DateCompleted" VisibleIndex="6" Caption="Completed On"></dx:GridViewDataDateColumn>
            </Columns>
            <Settings ShowFilterRow="True" />
            <SettingsPager PageSize="20"></SettingsPager>
        </dx:ASPxGridView>

        <%-- Updated and robust SQL query to get all necessary information --%>
        <asp:SqlDataSource ID="SqlDataSourceAllTickets" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="
                SELECT 
                    T.TicketID, 
                    F.FactoryName, 
                    M.MachineName, 
                    T.Status, 
                    T.DateCreated, 
                    T.DateCompleted,
                    COALESCE(InternalUser.FullName, ExternalEng.FullName, 'Unassigned') AS AssignedTo
                FROM 
                    MaintenanceTickets T 
                    JOIN Machines M ON T.MachineID = M.MachineID 
                    JOIN Factories F ON M.FactoryID = F.FactoryID
                    LEFT JOIN Technicians InternalTech ON T.AssignedToTechnicianID = InternalTech.TechnicianID
                    LEFT JOIN Users InternalUser ON InternalTech.UserID = InternalUser.UserID
                    LEFT JOIN ExternalEngineers ExternalEng ON T.AssignedToExternalEngineerID = ExternalEng.EngineerID
                ORDER BY 
                    T.DateCreated DESC
            ">
        </asp:SqlDataSource>
    </div>
</asp:Content> 