<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PurchaseDetail.aspx.cs" Inherits="UserMng_PurchaseDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
     <section id="main-content">
         <section class="wrapper">
            <div class="col-lg-12">
            <div class="row">
                <section class="panel">
                   <div class="panel-body">
                    <!-- 구매상세 -->
                        <table class="table" style="font-size:20px; font-weight:normal;">
                            <tbody>
                                <tr>
                                    <th style="width:150px;">구매번호</th>
                                    <td id="purchaseNoDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">구매일시</th>
                                    <td id="regDateDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">상태</th>
                                    <td id="statusDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">주문번호</th>
                                    <td id="orderNoDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">금액</th>
                                    <td id="amountDetail"></td>
                                </tr>
                                 <tr>
                                    <th style="width:150px;">수령시작일</th>
                                    <td id="dateRecvStartDetail"></td>
                                </tr>
                                 <tr>
                                    <th style="width:150px;">수령완료일</th>
                                    <td id="dateRecvFinDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">주소</th>
                                    <td id="addressDetail"></td>
                                </tr>

                                <tr>
                                    <th style="width:150px;">적립금현황</th>
                                    <td>
                                        <table class="table" id="TPurchasePoint" style="font-size:17px;">
                                            <thead>
                                                 <tr>
                                                    <th class='text-center' width='40%'>적립금번호</th>
                                                    <th class='text-center' width='30%'>금액</th>
                                                    <th class='text-center' width='30%'>잔액</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                                <tr>
                                                    <td class='text-center' id="intChargeNo"></td>
                                                    <td class='text-center' id="intAmount"></td>
                                                    <td class='text-center' id="intBalance"></td>
                                                </tr>
                                            
                                        </table>
                                    </td>
                                    
                                </tr>

                                <tr>
                                    <th style="width:150px;">사용금액</th>
                                    <td><table class="table" id="TPurchaseDetail" style="font-size:17px;"></table></td>
                                </tr>

                                <tr>
                                    <th style="width:150px;" id="cnlAmount">예상취소금액</th>
                                    <td>
                                        <table class="table" id="TCancelDetail" style="font-size:17px;">
                                            <thead>
                                                <tr>
                                                    <th class='text-center' width='40%'>실금액</th>
                                                    <th class='text-center' width='30%'>캐시</th>
                                                    <th class='text-center' width='30%'>적립금</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr >
                                                    <td class='text-center' id="intCnlChargeAmount"></td>
                                                    <td class='text-center' id="intCnlCashAmount"></td>
                                                    <td class='text-center' id="intCnlBonus"></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>

                            </tbody>
                        </table>
                       
                      
                       </div>
                    <!-- //구매상세 --> 
                </section>
            </div>
            </div>
         <div id="btnCancleDiv" class="col-lg-12" style="text-align:right;">
        </div>
             
        </section>
    </section> 

    <input type="hidden" id="purchaseNoVal" runat="server" />


<script type="text/javascript">
    $(document).ready(function () {
        
        getPurchaseDetail($("#<%=purchaseNoVal.ClientID%>").val());
    })

    function getPurchaseDetail(purchaseNo) {
        
        var reqParam = {};

        reqParam["strMethod"] = "PurchaseDetail";
        reqParam["intPurchaseNo"] = purchaseNo;

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

                $("#purchaseNoDetail").text(data.objDT[0].PURCHASENO);
                $("#regDateDetail").text(data.objDT[0].REGDATE);
                $("#statusDetail").text(data.objDT[0].STATUS);
                $("#orderNoDetail").text(data.objDT[0].ORDERNO);
                $("#amountDetail").text(fnAddComma(data.objDT[0].AMOUNT));
                $("#dateRecvStartDetail").text(data.objDT[0].DATE_RECV_START);
                $("#dateRecvFinDetail").text(data.objDT[0].DATE_RECV_FIN);
                $("#addressDetail").text(data.objDT[0].ADDRESS);

                $("#intChargeNo").text(data.intChargeNo);
                $("#intAmount").text(fnAddComma(data.intAmount));
                $("#intBalance").text(fnAddComma(data.intBalance));

                $("#intCnlChargeAmount").text(fnAddComma(data.intCnlChargeAmount));
                $("#intCnlCashAmount").text(fnAddComma(data.intCnlCashAmount));
                $("#intCnlBonus").text(fnAddComma(data.intCnlBonus));

                $("#cnlAmount").append("("+data.objDT[0].CANCELABLEWEEK + "주치)");

                fnPurchaseDetail(data);

                if ($("#statusDetail").text() == '구매완료' && (getFormatDate(new Date()) < $("#dateRecvFinDetail").text()) == true) {
                    $("#btnCancleDiv").html("<input type='button' name='btnCancel' class='btn btn-lg btn-default' onclick='btnCancel_Click()' value='구매취소'/>");
                }


            }
        })
    }

    //목록 html
    function fnPurchaseDetail(data) {

        var html = "";

        html += "       <thead>";
        html += "       <tr>";
        html += "           <th class='text-center' width='40%'>충전번호</th>";
        html += "           <th class='text-center' width='30%'>사용금액</th>"
        html += "           <th class='text-center' width='30%'>타입</th>"
        html += "       </tr>";
        html += "       </thead>";
        html += "       <tbody>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr >";
            html += "           <td class='text-center'>" + data.objDT[i].CHARGENO + "</td>";
            html += "           <td class='text-center'>" + fnAddComma(data.objDT[i].AMOUNT2) + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].TYPE + "</td>";
            html += "       </tr>";

        }

        html += "       </tbody>";

        $("#TPurchaseDetail").html(html);

    }

    function btnCancel_Click() {
        var reqParam = {};

        reqParam["strMethod"] = "CancelPurchase";
        reqParam["intPurchaseNo"] = $("#<%=purchaseNoVal.ClientID%>").val();
        reqParam["intCnlChargeAmount"] = Number(fnRmvComma($("#intCnlChargeAmount").text()));
        reqParam["intCnlCashAmount"] = Number(fnRmvComma($("#intCnlCashAmount").text()));
        reqParam["intCnlBonus"] = Number(fnRmvComma($("#intCnlBonus").text()));
       
        if (false == confirm("구매취소 하시겠습니까?")) {
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
                console.log(JSON.stringify(error));
                alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            },
            success: function (data) {
                console.log(data);
                alert("구매 취소 되었습니다");
                location.reload();
            }
        })
    }

    function dateDiff(sDate, eDate) {
        var date1 = sDate instanceof Date ? sDate : new Date(sDate);
        var date2 = eDate instanceof Date ? eDate : new Date(eDate);

        date1 = new Date(sDate.getFullYear(), sDate.getMonth() + 1, sDate.getDate());
        date2 = new Date(date2.getFullYear(), date2.getMonth() + 1, date2.getDate());
 
        var diff = Math.abs(date2.getTime() - date1.getTime());
        diff = Math.ceil(diff / (1000 * 3600 * 24));
 
        return diff;
    }
</script>
</asp:Content>

