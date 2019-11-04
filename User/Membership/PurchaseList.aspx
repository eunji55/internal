<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PurchaseList.aspx.cs" Inherits="Membership_PurchaseList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="membershipPage">
    <!-- header begin -->
    <header class="page-head">
        <div class="header-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">

                        <ol class="breadcrumb">
                            <li><a href="../Membership/Home.aspx">홈</a></li>
                            <li class="active">구매목록</li>
                        </ol> <!-- end of /.breadcrumb -->

                    </div>
                </div>
            </div> <!-- /.container -->
        </div> <!-- /.header-wrapper -->
    </header> <!-- /.page-head (header end) -->

    <br /><br />

    <div class="main-content">
      <div class="container">
          <div class="col-lg-12">
            <div class="row">
                <!--  검색 -->
                <div class="col-md-3">
                    <input type="date" class="form-control" id="searchFromDate" style="height:50px;"/>
                </div>
                <div class="col-md-3">
                    <input type="date" class="form-control" id="searchToDate" style="height:50px;"/>
                </div>
                <div class="col-md-2">
                    <input type="button" class="btn btn-primary" id="btnSearch" value="검색" />
                </div>
                <!-- // 검색 -->

                <div class="col-md-2">
                    <select id="selectStatus" class="form-control">
                        <option value="0">전체</option>
                        <option value="1">구매완료</option>
                        <option value="2">취소</option>
                    </select>
                </div>

                <!-- 페이지 크기 -->
                <div class="col-md-2">
                    <select id="selectPageSize" class="form-control">
                        <option value="10">10</option>
                        <option value="30">30</option>
                        <option value="100">100</option>
                    </select>
                </div>
                <!-- //페이지 크기 -->
                
            </div><br />
            
          <section class="panel">
                <!-- 게시글 목록 -->
                <div id="PurchaseList">
                    <table class="table table-striped table-hover" id="TPurchaseList" style="font-size:17px;">
                    </table>
                </div>
                <!-- //게시글 목록 --> 
            </section>

            <!--페이징-->
            <div class="row content-row-pagination" style="text-align:center;">
                <div class="col-md-12">
                    <ul class="pagination" id="pagingList">
                    </ul>
                </div>
            </div>
            <!--// 페이징-->
              </div>
        </div>
    </div>
</div> 
<script type="text/javascript">
    $(document).ready(function () {
        getDefaultSearchDate();
        getPurchaseList(1, 10);

            //검색 버튼 클릭
            $("#btnSearch").on("click", function () {
                var pageSize = $("#selectPageSize").val();

                getPurchaseList(1, pageSize);
            })

            //페이징 버튼 클릭
            $("#pagingList").on("click","li", function () {
                var pageNo = $(this).data("pageno");
                var pageSize = $("#selectPageSize").val();

                getPurchaseList(pageNo, pageSize);

            })

            //페이지 사이즈 변경
            $("#selectPageSize").change(function () {
                getPurchaseList(1, $(this).val());
            })

            //상태 검색
            $("#selectStatus").change(function () {
                getPurchaseList(1, 10);
            })
        });

        //게시글 목록
        function getPurchaseList(pageNo, pageSize) {
            var reqParam = {};

            if ($("#searchFromDate").val() > $("#searchToDate").val()) {
                var fromDate = $("#searchFromDate").val();
                $("#searchFromDate").val($("#searchToDate").val());
                $("#searchToDate").val(fromDate);
            }

            reqParam["strMethod"] = "PurchaseList";
            reqParam["strUserId"] = "<%=Session["userId"]%>";
            reqParam["strSearchFromDate"] = $("#searchFromDate").val();
            reqParam["strSearchToDate"] = $("#searchToDate").val();
            reqParam["intStatus"] = $("#selectStatus").val();
            reqParam["intPageNo"] = pageNo;
            reqParam["intPageSize"] = pageSize;

            if ($("#searchFromDate").val() == "" || $("#searchToDate").val() == "") {
                alert("검색일자를 입력하세요");
                return;
            }

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/Membership/MembershipHandler.ashx",
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

                    fnPurchaseList(data, pageNo, pageSize);
                }
            })
        }

    //게시글 목록 html
    function fnPurchaseList(data, pageNo, pageSize) {

            var html = "";
            html += "       <thead>";
            html += "       <tr>";
            html += "           <th class='text-center' width='10%'>#</th>";
            html += "           <th class='text-center' width='12%'>패키지명</th>";
            html += "           <th class='text-center' width='10%'>금액</th>";
            html += "           <th class='text-center' width='15%'>수령시작일</th>";
            html += "           <th class='text-center'>주소</th>";
            html += "           <th class='text-center' width='20%'>구매일</th>";
            html += "           <th class='text-center' width='10%'>상태</th>";
            html += "       </tr>";
            html += "       </thead>";
            html += "       <tbody>";

            for (var i = 0; i < data.objDT.length; i++) {
            
                html += "       <tr >";
                html += "           <td class='text-center'>" + data.objDT[i].ROWNUM + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].PACKNAME + "</td>";
                html += "           <td class='text-right'>" + fnAddComma(data.objDT[i].AMOUNT) + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].DATE_RECV_START + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].ADDRESS + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";


                if (data.objDT[i].STATUS == '취소') {
                    html += "           <td class='text-center' style='color:red;'>" + data.objDT[i].STATUS + "</td>";
                } else {
                    html += "           <td class='text-center'>" + data.objDT[i].STATUS + "</td>";
                }

                html += "       </tr>";

            }

            html += "       </tbody>";

            $("#TPurchaseList").html(html);

            fnPagingList(data, pageNo, pageSize);

    }

</script>

</asp:Content>

