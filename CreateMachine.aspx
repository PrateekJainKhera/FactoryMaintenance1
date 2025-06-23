<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="CreateMachine.aspx.vb" Inherits="FactoryMaintenance1.CreateMachine" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Add a New Machine</h2>

    <div style="margin-bottom: 20px;">
        <dx:ASPxButton ID="btnBackToGrid" runat="server" Text="< Back to Machine List" NavigateUrl="~/Machines.aspx" Theme="Moderno" RenderMode="Link"></dx:ASPxButton>
    </div>

    <div class="dashboard-section" style="max-width: 800px;">
        <dx:ASPxFormLayout ID="formLayoutMachine" runat="server" Width="100%">
            <Items>
                <dx:LayoutItem Caption="Machine Name">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxTextBox ID="txtMachineName" runat="server" Width="100%">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" SetFocusOnError="True">
                                    <RequiredField IsRequired="True" ErrorText="Machine Name is required." />
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

                <dx:LayoutItem Caption="Machine Tag/Code" HelpText="A unique identifier for the machine (e.g., PUN-GRD-01).">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxTextBox ID="txtMachineTag" runat="server" Width="100%">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="True" ErrorText="Machine Tag is required." />
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

                <dx:LayoutItem Caption="Factory Location">
                     <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxComboBox ID="cmbFactory" runat="server" DataSourceID="SqlDataSourceFactories" ValueField="FactoryID" TextField="FactoryName" Width="100%">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="True" ErrorText="Please select a factory." />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

                <dx:LayoutItem Caption="Location in Factory" HelpText="e.g., 'Floor 1, Section A'">
                     <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxTextBox ID="txtLocationInFactory" runat="server" Width="100%"></dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

                <dx:LayoutItem Caption="Installation Date">
                     <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxDateEdit ID="dateInstall" runat="server" Width="100%"></dx:ASPxDateEdit>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
                
                <dx:LayoutItem ShowCaption="False">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxButton ID="btnCreateMachine" runat="server" Text="Save New Machine" OnClick="btnCreateMachine_Click" UseSubmitBehavior="False"></dx:ASPxButton>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
            </Items>
        </dx:ASPxFormLayout>
        
        <br />
        <dx:ASPxLabel ID="lblStatusMessage" runat="server" ClientVisible="false" Font-Bold="true"></dx:ASPxLabel>

    </div>

    <asp:SqlDataSource ID="SqlDataSourceFactories" runat="server"
        ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
        SelectCommand="SELECT [FactoryID], [FactoryName] FROM [Factories] ORDER BY [FactoryName]">
    </asp:SqlDataSource>

</asp:Content>