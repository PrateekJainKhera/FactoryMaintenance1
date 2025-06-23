<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="SchedulePlanner.aspx.vb" Inherits="FactoryMaintenance1.SchedulePlanner" %>


<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler" TagPrefix="dxwschs" %>
<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Maintenance Schedule Planner</h2>
    <p>Use this calendar to schedule recurring maintenance tasks for machines. Right-click on a date to create a new plan.</p>

    <div class="dashboard-section">
        <%-- The Scheduler control provides the visual calendar interface --%>
        <dxwschs:ASPxScheduler ID="ASPxScheduler1" runat="server" 
            AppointmentDataSourceID="SqlDataSourcePlans"
            Width="100%"
            Start="<%# Date.Today %>">
            <Storage>
                <Appointments>
                    <%-- This is the critical part: It maps database columns to scheduler properties --%>
                    <Mappings 
                        AppointmentId="PlanID"
                        Start="NextDueDate"
                        Subject="MaintenanceType" 
                        Description="Frequency"
                        ResourceId="MachineID"
                        />
                </Appointments>
                <Resources>
                    <%-- This maps the Machines table to "Resources" so each machine gets its own column in Day/Week view --%>
                     <Mappings 
                        ResourceId="MachineID"
                        Caption="MachineName"
                        />
                </Resources>
            </Storage>
            <Views>
                <DayView Enabled="true" />
                <WorkWeekView Enabled="true" />
                <WeekView Enabled="false" />
                <MonthView Enabled="true" />
                <TimelineView Enabled="true" />
            </Views>
        </dxwschs:ASPxScheduler>
    </div>

    <%-- Data Source for the scheduled plans (appointments) --%>
    <asp:SqlDataSource ID="SqlDataSourcePlans" runat="server"
        ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
        SelectCommand="SELECT PlanID, MachineID, MaintenanceType, Frequency, NextDueDate FROM ScheduledMaintenancePlan"
        InsertCommand="INSERT INTO ScheduledMaintenancePlan(MachineID, MaintenanceType, Frequency, NextDueDate) VALUES (@MachineID, @MaintenanceType, @Frequency, @NextDueDate)"
        UpdateCommand="UPDATE ScheduledMaintenancePlan SET MachineID = @MachineID, MaintenanceType = @MaintenanceType, Frequency = @Frequency, NextDueDate = @NextDueDate WHERE PlanID = @PlanID"
        DeleteCommand="DELETE FROM ScheduledMaintenancePlan WHERE PlanID = @PlanID">
        <InsertParameters>
            <asp:Parameter Name="MachineID" Type="Int32" />
            <asp:Parameter Name="MaintenanceType" Type="String" />
            <asp:Parameter Name="Frequency" Type="String" />
            <asp:Parameter Name="NextDueDate" Type="DateTime" />
        </InsertParameters>
    </asp:SqlDataSource>

    <%-- Data Source for the machines (resources) --%>
    <asp:SqlDataSource ID="SqlDataSourceMachines" runat="server"
        ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
        SelectCommand="SELECT MachineID, MachineName FROM Machines">
    </asp:SqlDataSource>

</asp:Content>