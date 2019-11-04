<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ItemDetail.aspx.cs" Inherits="Item_ItemDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        th,td {
        padding: 10px;
      }
    </style>

<div id="saladPage">
    <form id="formItemDetail" name="formItemDetail" method="post" action="ItemOrder.aspx">
    <!-- header begin -->
    <header class="page-head">
        <div class="header-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">

                        <ol class="breadcrumb">
                            <li><a href="../Membership/Home.aspx">홈</a></li>
                            <li class="active">샐러드</li>
                        </ol> <!-- end of /.breadcrumb -->

                    </div>
                </div>
            </div> <!-- /.container -->
        </div> <!-- /.header-wrapper -->
    </header> <!-- /.page-head (header end) -->
        
    <input type="hidden" id="packNoVal" runat="server" />

    <div class="main-content">
      <div class="container">
        <br /><br /><br />
        <div class="col-lg-12">
        <div class="row">
        <div class="col-md-6" style="display: block;">
            <img id="packImg"  style="max-height:500px;">
        </div>

        
        <aside class="col-md-6">

            <h4></h4>
            <div class="row">
                <h2 id="packName" style="font-weight:bold; letter-spacing: 5px;"></h2>
                <hr />  
                
                <table  class="col-md-12" border="0" style="font-size:20px; font-weight:normal;">
                    <tbody>
                        <tr>
                            <th style="width:150px;">가격</th>
                            <td id="packPrice"></td>
                        </tr>
                        <tr>
                            <th>배송정보</th>
                            <td>주문일 기준 3일 후부터 수령 가능합니다. <br />토,일요일 수령 불가</td>
                        </tr>
                        <tr>
                            <th>수령일선택</th>
                            <td><input class="form-control" id="recvStartDate" name="recvStartDate" style="height:40px; font-size:17px;" autocomplete="off"/></td>
                        </tr>
                    </tbody>
                </table>
            </div><hr />
            <div style="text-align:end;">
                <input type="submit" class="btn btn-lg btn-black" id="btnOrder" style="height:70px; width:100%;" value="주문"/>
            </div>
        </aside>
    </div>
    <br /><br /><br /><br /><br />
    <h2>포함 상품</h2>
        <!-- 상품 목록 -->
        <div class="author">
        <div class="row">
            <div class="col-md-8" id="itemList">
            </div>
        </div>
        </div>
        <!-- //상품 목록 --> 
          </div>
        </div>
      </div> 
    </form>
</div>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />  
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>  
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>  
<script type="text/javascript">
    $(document).ready(function () {
        
        display();

        $("#recvStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            beforeShowDay: $.datepicker.noWeekends ,
            minDate: 3
        });

        $('#formItemDetail').on('submit', function () {
            if ($("#recvStartDate").val() == "") {
                alert("수령일을 선택하세요");
                return false;

            }
        });

    })

    function display() {
        var reqParam = {};

        reqParam["strMethod"] = "PackageDetail";
        reqParam["intPackNo"] = $("#<%= packNoVal.ClientID%>").val();

        console.log(reqParam);

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/Item/ItemHandler.ashx",
            dataType: "JSON",
            contentType: "application/json; charset=utf-8",
            error: function (request, status, error) {
                alert("일시적 통신 오류");
            },
            success: function (data) {
                console.log(data);

                if (data.intRetVal != 0) {
                    alert("실패");
                    return;
                }

                $("#packName").text(data.strPname);
                $("#packPrice").text(fnAddComma(data.intPrice));
                $("#packImg").attr('src', (data.objDT[0].PACKIMG).toString().replace("D:\\WEBHOSTING\\ejdo\\User", ""));

                fnItemList(data);
            }
        })
    }

    //상품 목록 html
        function fnItemList(data) {

            var html = "";

            for (var i = 0; i < data.objDT.length; i++) {
                html += "<div class='about-author'>                                                                                   ";
                html += "	<div class='row'>                                                                                         ";
                html += "		<div class='col-md-3'>                                                                                ";
                html += "			<img src='" + (data.objDT[i].ITEMIMG).toString().replace("D:\\WEBHOSTING\\ejdo\\User", "") + "' class='img-responsive center-block' alt='author'> ";
                html += "		</div>                                                                                                ";
                html += "		<div class='col-md-9'>                                                                                ";
                html += "			<h3 style='margin: 15px 0px 10px 0px;'>                                                                                               ";
                html += "				<strong>" + data.objDT[i].ITEMNAME + "</strong>                                                                 ";
                html += "			</h4>                                                                                              ";
                html += "			<textarea  style='cursor:text; color:#525252; background-color:white; height:150px; width:800px; font-size:large; border:none; resize:none;' disabled >" + data.objDT[i].DETAIL + "</textarea>";
                html += "		</div>                                                                                                ";
                html += "	</div>                                                                                                    ";
                html += "</div>";

            }


            $("#itemList").html(html);
        }
</script>
</asp:Content>

