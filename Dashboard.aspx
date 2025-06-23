<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Dashboard.aspx.vb" Inherits="FactoryMaintenance1.Dashboard" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dashboard-section { background: #fff; padding: 20px; border-radius: 5px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .dashboard-section h3 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .notification-item { border: 1px solid #ffc107; background-color: #fff3cd; padding: 10px; margin-bottom: 10px; border-radius: 4px; }
        .overdue-ticket { background-color: #f8d7da !important; font-weight: bold; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Admin Dashboard</h2>
    
    <!-- Section for Scheduled Maintenance Notifications -->
    <div class="dashboard-section">
        <h3><i class="dx-icon-clock"></i> Scheduled Maintenance Due</h3>
        
        <%-- CHANGE 1: Connected the Repeater to the new SqlDataSource below using DataSourceID --%>
        <asp:Repeater ID="rptNotifications" runat="server" DataSourceID="SqlDataSourceNotifications">
            <ItemTemplate>
                <div class="notification-item" style="display:flex; justify-content:space-between; align-items:center;">
                    <span>
                        <strong><%# Eval("MachineName") %>:</strong> <%# Eval("MaintenanceType") %> is due.
                    </span>
                    
                    <%-- CHANGE 2: Added the new "Create Ticket" button/link --%>
                    <%-- This link cleverly passes all the needed info to the CreateTicket page --%>
                    <a href='<%# "CreateTicket.aspx?MachineID=" & Eval("MachineID") & "&Type=Scheduled&Desc=" & Server.UrlEncode(Eval("MaintenanceType").ToString()) %>' 
                       class="dx-button dx-button-default" style="text-decoration: none; padding: 5px 10px;">
                        Create Ticket
                    </a>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                <%-- Corrected the binding expression to prevent casting errors --%>
                <asp:Label runat="server" Text="No pending scheduled maintenance." Visible='<%# CType(Container.Parent, Repeater).Items.Count = 0 %>'></asp:Label>
            </FooterTemplate>
        </asp:Repeater>

        <%-- CHANGE 3: Added the SqlDataSource for the Repeater --%>
        <%-- The SelectCommand now includes MachineID, which is essential for the button to work. --%>
        <asp:SqlDataSource ID="SqlDataSourceNotifications" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="SELECT M.MachineID, M.MachineName, P.MaintenanceType FROM ScheduledMaintenancePlan P JOIN Machines M ON P.MachineID = M.MachineID WHERE P.NextDueDate <= GETDATE()">
        </asp:SqlDataSource>
    </div>

    <!-- Section for Live Maintenance Tickets (This section remains unchanged from your code) -->
    <div class="dashboard-section">
        <h3><i class="dx-icon-settings"></i> Live Maintenance Status</h3>
        <dx:ASPxGridView ID="gridLiveTickets" runat="server" AutoGenerateColumns="False" 
            Width="100%" KeyFieldName="TicketID" DataSourceID="SqlDataSourceLiveTickets"
            OnHtmlRowPrepared="gridLiveTickets_HtmlRowPrepared">
            <Columns>
                <dx:GridViewDataHyperLinkColumn FieldName="TicketID" VisibleIndex="0" Caption="Ticket ID">
                    <PropertiesHyperLinkEdit NavigateUrlFormatString="~/ViewTicket.aspx?TicketID={0}" TextFormatString="{0}"></PropertiesHyperLinkEdit>
                </dx:GridViewDataHyperLinkColumn>
                <dx:GridViewDataTextColumn FieldName="FactoryName" VisibleIndex="1"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="MachineName" VisibleIndex="2"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="3"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Duration" VisibleIndex="4" Caption="Time Open"></dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="DateCreated" VisibleIndex="5" Caption="Created On"></dx:GridViewDataDateColumn>
            </Columns>
            <Settings ShowHeaderFilterButton="true" />
            <SettingsPager PageSize="10"></SettingsPager>
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceLiveTickets" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="
                SELECT 
                    T.TicketID, F.FactoryName, M.MachineName, T.Status, T.DateCreated,
                    DATEDIFF(hour, T.DateCreated, GETDATE()) AS HoursOpen,
                    CASE 
                        WHEN DATEDIFF(day, T.DateCreated, GETDATE()) > 0 THEN CAST(DATEDIFF(day, T.DateCreated, GETDATE()) AS nvarchar) + ' days'
                        ELSE CAST(DATEDIFF(hour, T.DateCreated, GETDATE()) AS nvarchar) + ' hours'
                    END AS Duration
                FROM 
                    MaintenanceTickets T 
                    JOIN Machines M ON T.MachineID = M.MachineID 
                    JOIN Factories F ON M.FactoryID = F.FactoryID 
                WHERE 
                    T.Status NOT IN ('Closed', 'Completed')
                ORDER BY 
                    T.DateCreated ASC
            ">
        </asp:SqlDataSource>
    </div>
</asp:Content>