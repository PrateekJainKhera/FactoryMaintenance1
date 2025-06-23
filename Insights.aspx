<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Insights.aspx.vb" Inherits="FactoryMaintenance1.Insights" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- DEVEXTREME REQUIRES JQUERY - Site.Master already has it, but it's good to be aware --%>
    <%-- DEVEXTREME CDN - Make sure this is present, perhaps in your Site.Master head or here. --%>
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/23.2.3/css/dx.light.css" />
    <script type="text/javascript" src="https://cdn3.devexpress.com/jslib/23.2.3/js/dx.all.js"></script>

    <h2>Maintenance Insights & Reports (DevExtreme)</h2>
    <p>This report analyzes all completed maintenance tickets to show downtime and impact.</p>

    <%-- ROW FOR KEY PERFORMANCE INDICATORS (KPIs) - These are still driven by server-side labels --%>
    <div style="display: flex; gap: 20px; margin-bottom: 20px;">
        <div class="dashboard-section" style="flex: 1; text-align: center;">
            <h3>Total Production Downtime</h3>
            <asp:Label ID="lblTotalDowntime" runat="server" Font-Size="XX-Large" ForeColor="#d9534f" Text="0 Hours"></asp:Label>
        </div>
        <div class="dashboard-section" style="flex: 1; text-align: center;">
            <h3>Estimated Financial Impact</h3>
            <asp:Label ID="lblFinancialLoss" runat="server" Font-Size="XX-Large" ForeColor="#d9534f" Text="₹ 0"></asp:Label>
        </div>
    </div>

    <%-- ROW FOR CHARTS - These are now simple div placeholders --%>
    <div style="display: flex; gap: 20px;">
        <div class="dashboard-section" style="flex: 2;">
            <h3>Downtime by Machine (Hours)</h3>
            <div id="chartDowntimeByMachine" style="height: 400px; width: 100%;"></div>
        </div>
        <div class="dashboard-section" style="flex: 1;">
            <h3>Maintenance Types</h3>
            <div id="chartTicketTypes" style="height: 400px; width: 100%;"></div>
        </div>
    </div>

    <%-- JAVASCRIPT BLOCK to initialize the charts --%>
    <script type="text/javascript">
        // This runs when the page is ready
        $(function () {

            // AJAX call to get data for the bar chart
            $.ajax({
                type: "POST",
                url: "Insights.aspx/GetDowntimeData", // Calls the WebMethod in our code-behind
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    // response.d is how ASP.NET wraps the JSON data
                    const chartData = JSON.parse(response.d); 
                    
                    $("#chartDowntimeByMachine").dxChart({
                        dataSource: chartData,
                        series: {
                            argumentField: "MachineName",
                            valueField: "TotalDowntime",
                            name: "Downtime",
                            type: "bar",
                            color: "#007bff"
                        },
                        legend: {
                            visible: false
                        },
                        argumentAxis: {
                            label: {
                                overlappingBehavior: 'stagger'
                            }
                        }
                    });
                }
            });

            // AJAX call to get data for the pie chart
            $.ajax({
                type: "POST",
                url: "Insights.aspx/GetTicketTypeData",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const chartData = JSON.parse(response.d);

                    $("#chartTicketTypes").dxPieChart({
                        dataSource: chartData,
                        series: [{
                            argumentField: "TicketType",
                            valueField: "TicketCount",
                            label: {
                                visible: true,
                                format: "percentage",  // THIS IS THE FIX!
                                connector: {
                                    visible: true
                                },
                                // Optional: Customize the text pattern
                                customizeText: function (point) {
                                    // This shows both the argument (e.g., "Sudden") and its percentage
                                    return point.argumentText + ": " + point.percentText;
                                }
                            }
                        }],
                        title: "Maintenance Types",
                        legend: {
                            horizontalAlignment: "center",
                            verticalAlignment: "bottom"
                        }
                    });
                }
            });
        });
    </script>
</asp:Content>