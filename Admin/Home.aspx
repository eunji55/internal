<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section id="main-content">
      <section class="wrapper">
        <!--overview start-->
        <div class="row">
          <div class="col-lg-12">
            <div class="col-lg-6 col-md-3 col-sm-12 col-xs-12">
            <div class="info-box brown-bg">
              <i class="fa fa-shopping-cart"></i>
              <div class="count">구매 : <span id="purchaseCnt"></span> 건</div>
            </div>
            <!--/.info-box-->
          </div>
          <!--/.col-->

          <div class="col-lg-6 col-md-3 col-sm-12 col-xs-12">
            <div class="info-box dark-bg">
              <i class="fa fa-thumbs-o-up"></i>
              <div class="count">일매출 : <span id="intDaySales"></span> 원</div>
            </div>
            <!--/.info-box-->
          </div>
          <!--/.col-->
              <br /><br /><br /><br /><br /><br /><br /><br />
            <div id="chart_div" class="col-lg-10"></div>                
           </div>
        </div>
      </section>
    </section>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        
       
    })


    google.charts.load('current', { packages: ['corechart'] });
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {

        $.ajax({
            type: "POST",
            url: "/HomeHandler.ashx",
            dataType: "JSON",
            contentType: "application/json; charset=utf-8",
            error: function (request, status, error) {
                alert("일시적 통신 오류");
            },
            success: function (data1) {
                console.log(data1);
                
                // Create the data table.
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Topping');
                data.addColumn('number', 'Slices');

                for (var i = 0; i < data1.objDT.length; i++) {
                    data.addRows([[data1.objDT[i].packname, Number(data1.objDT[i].sold)]]);
                }

                // Set chart options
                var options = {
                    'title': '패키지 판매 비율',
                    'width': 950,
                    'height': 500,
                    'fontSize': 20
                };

                var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
                chart.draw(data, options);

                $("#purchaseCnt").text(data1.intPurchaseCnt);
                $("#intDaySales").text(fnAddComma(data1.intDaySales));
            }

         

        })


    }
</script>
</asp:Content>

