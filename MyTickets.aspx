<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="MyTickets.aspx.vb" Inherits="FactoryMaintenance1.MyTickets" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Assigned Maintenance Tickets</h2>
    <p>This page shows all open tickets currently assigned to you.</p>
    <div class="dashboard-section">
        <dx:ASPxGridView ID="gridMyTickets" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceMyTickets" KeyFieldName="TicketID" Width="100%">
            <Columns>
                <dx:GridViewDataHyperLinkColumn FieldName="TicketID" VisibleIndex="0" Caption="Ticket ID">
                    <PropertiesHyperLinkEdit NavigateUrlFormatString="~/ViewTicket.aspx?TicketID={0}" TextFormatString="View Ticket #{0}"></PropertiesHyperLinkEdit>
                </dx:GridViewDataHyperLinkColumn>
                <dx:GridViewDataTextColumn FieldName="FactoryName" VisibleIndex="1"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="MachineName" VisibleIndex="2"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="3"></dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="DateCreated" VisibleIndex="4" Caption="Created On" SortOrder="Descending"></dx:GridViewDataDateColumn>
            </Columns>
            <Settings ShowFilterRow="True" />
            <SettingsPager PageSize="20"></SettingsPager>
        </dx:ASPxGridView>

        <asp:SqlDataSource ID="SqlDataSourceMyTickets" runat="server"
            ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
            SelectCommand="
                SELECT 
                    T.TicketID, 
                    F.FactoryName, 
                    M.MachineName, 
                    T.Status, 
                    T.DateCreated 
                FROM 
                    MaintenanceTickets T 
                    JOIN Machines M ON T.MachineID = M.MachineID 
                    JOIN Factories F ON M.FactoryID = F.FactoryID 
                    JOIN Technicians Tech ON T.AssignedToTechnicianID = Tech.TechnicianID
                WHERE 
                    Tech.UserID = @UserID AND T.Status NOT IN ('Closed', 'Completed')
                ORDER BY 
                    T.DateCreated DESC">
            <SelectParameters>
                <%-- This parameter gets its value from the logged-in user's Session --%>
                <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>