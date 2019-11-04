<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ItemList.aspx.cs" Inherits="Item_ItemList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div id="saladPage">
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



            <div class="main-content">

                <!--  begin portfolio section  -->
                <section class="bg-light-gray">
                    <div class="container">

                        <div class="headline text-center">
                            <div class="row">
                                <div class="col-md-6 col-md-offset-3">
                                    <h2 class="section-title">정기배송</h2>
                                    <p class="section-sub-title">
                                        한 번 결제로 편하게 받아보세요
                                    </p> <!-- /.section-sub-title -->
                                </div>
                            </div>
                        </div> <!-- /.headline -->

                        <div class="portfolio-item-list">
                            <div class="row">
                                <div id="packageList">

                                </div>
                            </div>
                        </div> <!-- end of portfolio-item-list -->
                    </div>
                </section> 
                <!--   end of portfolio section  -->

            </div> <!-- end of /.main-content -->
</div>
    <script type="text/javascript">
        $(document).ready(function () {

            getPackageList();

        });


        //상품 목록
        function getPackageList() {
            var reqParam = {};

            reqParam["strMethod"] = "PackageList";

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/Item/ItemHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    console.log(data);
                    if (data.intRetVal != 0) {
                        alert("실패");
                        return;
                    }

                    fnPackageList(data);
                }
            })
        }

        //상품 목록 html
        function fnPackageList(data) {

            html = "";

            for (var i = 0; i < data.objDT.length; i++) {
            
                html += "<div class='col-md-4 col-sm-6' style='width:25%'>                                                                                 ";
                html += "	<div class='portfolio-item'>                                                                                ";
                html += "		<div class='item-image' data-packno='" + data.objDT[i].PACKNO + "'>                ";
                html += "			<a href='#'>                                                                                        ";
                html += "				<img src='" + (data.objDT[i].PACKIMG).toString().replace("D:\\WEBHOSTING\\ejdo\\User", "") + "' class='img-responsive center-block' alt='portfolio 1'>  ";
                html += "				<div><span style='left: 35%;'><i style='font-size:25px;font-weight: bold; font-style: normal;'>구매하기</i></span></div>                                              ";
                html += "			</a>                                                                                                ";
                html += "		</div>                                                                                                  ";
                html += "                                                                                                                ";
                html += "		<div class='item-description'>                                                                          ";
                html += "			<div class='row'>                                                                                   ";
                html += "				<div class='col-xs-12'>                                                                          ";
                html += "					<span class='item-name' style='font-size: 25px;'>" + data.objDT[i].NAME + "</span>  ";
                html += "					<span style='font-size: 15px; color: darkslategray; text-align: -webkit-right; '><strike>" + fnAddComma(data.objDT[i].BEFOREPRICE) + "원</strike> -> " + fnAddComma(data.objDT[i].PRICE) + "원 </span>                         ";
                html += "				</div>                                                                                          ";
                html += "			</div>                                                                                              ";
                html += "		</div> <!-- end of /.item-description -->                                                               ";
                html += "	</div> <!-- end of /.portfolio-item -->                                                                     ";
                html += "</div>                                                                                                          ";

            }

            $("#packageList").html(html);
            hover();
            item_click();
        }

        function item_click() {
            $(".item-image").on("click", function () {
                location.href = "/Item/ItemDetail.aspx?packNo=" + $(this).data("packno");

            });
        }

        function hover(){
            $('.portfolio-item > .item-image').each(function () {
                $(this).hoverdir({
                    hoverDelay: 75
                });
            });
        }

    </script>
</asp:Content>

