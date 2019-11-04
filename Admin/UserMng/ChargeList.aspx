<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ChargeList.aspx.cs" Inherits="UserMng_ChargeList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <section id="main-content">
      <section class="wrapper">
            <div class="row">
                <input type="hidden" id="chargeType" runat="server"/>

                <!--  검색 -->
                <div class="col-md-2">
                    <input type="date" class="form-control" id="searchFromDate" />
                </div>
                <div class="col-md-2">
                    <input type="date" class="form-control" id="searchToDate" />
                </div> 
                <div class="col-md-2">
                    <input type="text" class="form-control" id="searchId" placeholder="아이디 검색"/>
                </div>
                <div class="col-md-2">
                    <input type="button" class="btn btn-primary" id="btnSearch" value="검색" />
                </div>
                <!-- // 검색 -->

                <div class="col-md-2">
                    <select id="selectStatus" class="form-control">
                        <option value="0">전체</option>
                        <option value="1">정상</option>
                        <option value="2">사용완료</option>
                        <option value="3">취소</option>
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
                
           <br /><br /><br />
            
          <section class="panel">
                <!-- 게시글 목록 -->
                <div id="chargeList">
                    <table class="table table-striped table-hover" id="TchargeList" style="font-size:17px;">
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
          </section>
         </section>

<script type="text/javascript">
    $(document).ready(function () {
        getDefaultSearchDate();
        var cancelData = {};

        getChargeList(1, 10);

        //검색 버튼 클릭
        $("#btnSearch").on("click", function () {
            var pageSize = $("#selectPageSize").val();

            getChargeList(1,pageSize);
        })

        //페이징 버튼 클릭
        $("#pagingList").on("click","li", function () {
            var pageNo = $(this).data("pageno");
            var pageSize = $("#selectPageSize").val();

            getChargeList(pageNo, pageSize);

        })

        //페이지 사이즈 변경
        $("#selectPageSize").change(function () {
            getChargeList(1, $(this).val());
        })

        //타입 변경
        $("#selectStatus").change(function () {
            getChargeList(1,10);
        })

        });

        //게시글 목록
        function getChargeList(pageNo,pageSize) {
            var reqParam = {};

            if ($("#searchFromDate").val() > $("#searchToDate").val()) {
                var fromDate = $("#searchFromDate").val();
                $("#searchFromDate").val($("#searchToDate").val());
                $("#searchToDate").val(fromDate);
            }

            reqParam["strMethod"] = "ChargeList";
            reqParam["strUserId"] = $("#searchId").val();
            reqParam["strSearchFromDate"] = $("#searchFromDate").val();
            reqParam["strSearchToDate"] = $("#searchToDate").val();
            reqParam["intType"] = 0;
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
                url: "/UserMng/UserHandler.ashx",
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

                    fnChargeList(data, pageNo, pageSize, $("#<%=chargeType.ClientID%>").val());
                }
            })
        }

        //목록 html (type:1 - 실금액 결제, type:2 - 캐시)
        function fnChargeList(data, pageNo, pageSize, type) {

            var html = "";
            html += "       <thead>";
            html += "       <tr>";
            html += "           <th class='text-center' width='5%'>#</th>";
            html += "           <th class='text-center' width='14%'>충전번호</th>";
            html += "           <th class='text-center' width='10%'>사용자</th>";
            html += "           <th class='text-right' width='10%'>금액</th>";
            html += "           <th class='text-right' width='10%'>잔액</th>";
            html += "           <th class='text-center' width='13%'>결제수단</th>";
            html += "           <th class='text-center' width='18%'>결제일시</th>";
            html += "           <th class='text-center' width='10%'>상태</th>";
            html += "           <th class='text-center' width='8%'>관리</th>";

            html += "       </tr>";
            html += "       </thead>";
            html += "       <tbody>";

            for (var i = 0; i < data.objDT.length; i++) {
            
                html += "       <tr >";
                html += "           <td class='text-center'>" + data.objDT[i].ROWNUM + "</td>";
                html += "           <td class='text-center' onClick='chargeDetail(" + data.objDT[i].CHARGENO + ")' style='cursor:pointer;'>" + data.objDT[i].CHARGENO + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].USERID + "</td>";
                html += "           <td class='text-right'>" + fnAddComma(data.objDT[i].AMOUNT) + "</td>";
                html += "           <td class='text-right'>" + fnAddComma(data.objDT[i].BALANCE) + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].METHOD + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";

                if (data.objDT[i].STATUS == '취소') {
                    html += "           <td class='text-center' style='color:red;'>" + data.objDT[i].STATUS + "</td>";
                } else {
                    html += "           <td class='text-center'>" + data.objDT[i].STATUS + "</td>";
                }

                html += "           <td class='text-center' data-userno='" + data.objDT[i].USERNO + "' data-cnoval='" + data.objDT[i].CHARGENO + "' data-balance='" + data.objDT[i].BALANCE + "'>";
                
                if (data.objDT[i].TYPE == 2 && data.objDT[i].BALANCE > 0) {
                    html += "<input type='button' class='btn btn-default btnCash' value='회수' />";
                }

                html += "           </td>";

                html += "       </tr>";

            }

            html += "       </tbody>";

            $("#TchargeList").html(html);

            fnPagingList(data, pageNo, pageSize);

            $(".btnCash").on("click", function () {

                window.open('../UserMng/CashMng.aspx?type=2&userNo=' + $(this).closest("td").data("userno") + '&chargeNo=' + $(this).closest("td").data("cnoval") + '&balance=' + $(this).closest("td").data("balance"), 'newWindow1', 'width=500,height=350,location=no,status=no,scrollbars=no');
            });

        }

        function btnCancel_Click(chargeNo) {

            var reqParam = {};

            reqParam["strMethod"] = "ChargeDetail";
            reqParam["intChargeNo"] = chargeNo;
            
            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/UserMng/UserHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    console.log(data);
                }
            })
        }

        function fnAfterCachMng(userNo) {
            getChargeList(1, 10);
        }

        function chargeDetail(chargeNo) {
            location.href = "../UserMng/ChargeDetail.aspx?chargeNo=" + chargeNo;
        }

</script>
</asp:Content>

