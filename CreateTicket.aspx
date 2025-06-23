<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="CreateTicket.aspx.vb" Inherits="FactoryMaintenance1.CreateTicket" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Create New Maintenance Ticket</h2>

    <div class="dashboard-section" style="max-width: 800px;">
        <dx:ASPxFormLayout ID="formLayoutTicket" runat="server" Width="100%">
            <Items>
                <dx:LayoutItem Caption="Machine with Issue" HelpText="Select the machine that requires maintenance.">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxComboBox ID="cmbMachine" runat="server" Width="100%" ValueType="System.Int32" TextField="MachineName" ValueField="MachineID" DataSourceID="SqlDataSourceMachines">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="True" ErrorText="Please select a machine." />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

                <dx:LayoutItem Caption="Problem Description" HelpText="Describe the issue in detail. What happened? What are the symptoms?">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxMemo ID="memoProblemDescription" runat="server" Height="150px" Width="100%">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="True" ErrorText="A problem description is required." />
                                </ValidationSettings>
                            </dx:ASPxMemo>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                
                <dx:LayoutItem ShowCaption="False">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxButton ID="btnSubmitTicket" runat="server" Text="Submit Ticket" OnClick="btnSubmitTicket_Click" UseSubmitBehavior="false"></dx:ASPxButton>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
            </Items>
        </dx:ASPxFormLayout>
        
        <br />
        <dx:ASPxLabel ID="lblStatusMessage" runat="server" ClientVisible="false" Font-Bold="true"></dx:ASPxLabel>

    </div>
    
    <asp:SqlDataSource ID="SqlDataSourceMachines" runat="server"
        ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
        SelectCommand="SELECT MachineID, MachineName + ' (' + MachineTag + ')' AS MachineName FROM Machines ORDER BY MachineName">
    </asp:SqlDataSource>
</asp:Content>
