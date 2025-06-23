<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="CreateTechnician.aspx.vb" Inherits="FactoryMaintenance1.CreateTechnician" %>


<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Create Technician Profile</h2>
    <p>Select a user and add their technical specialization to designate them as a maintenance technician.</p>
    
    <div style="margin-bottom: 20px;">
        <dx:ASPxButton ID="btnBackToGrid" runat="server" Text="< Back to Technician List" NavigateUrl="~/Technicians.aspx" Theme="Moderno" RenderMode="Link"></dx:ASPxButton>
    </div>

    <div class="dashboard-section" style="max-width: 800px;">
        <dx:ASPxFormLayout ID="formLayoutTechnician" runat="server" Width="100%">
            <Items>
                <dx:LayoutItem Caption="Select User to Promote" HelpText="Only users who are not already technicians are shown.">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxComboBox ID="cmbUser" runat="server" DataSourceID="SqlDataSourceUsers" TextField="FullName" ValueField="UserID" Width="100%">
                                 <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="True" ErrorText="You must select a user." />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

                <dx:LayoutItem Caption="Specialization" HelpText="e.g., Electrical, Mechanical, Bearings, PLC Programming">
                     <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxTextBox ID="txtSpecialization" runat="server" Width="100%">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="True" ErrorText="Specialization is required." />
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

                <dx:LayoutItem ShowCaption="False">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxButton ID="btnCreateTechnician" runat="server" Text="Create Technician Profile" OnClick="btnCreateTechnician_Click"></dx:ASPxButton>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>
            </Items>
        </dx:ASPxFormLayout>
        <br />
        <dx:ASPxLabel ID="lblStatusMessage" runat="server" ClientVisible="false" Font-Bold="true"></dx:ASPxLabel>
    </div>

    <%-- This data source cleverly selects only users who are NOT already in the Technicians table. --%>
    <asp:SqlDataSource ID="SqlDataSourceUsers" runat="server"
        ConnectionString="<%$ ConnectionStrings:FactoryDB_ConnectionString %>"
        SelectCommand="SELECT UserID, FullName + ' (' + Username + ')' AS FullName FROM Users WHERE UserID NOT IN (SELECT UserID FROM Technicians) ORDER BY FullName">
    </asp:SqlDataSource>
</asp:Content>