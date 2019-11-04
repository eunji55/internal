<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ChargeDetail.aspx.cs" Inherits="UserMng_PurchaseDetail" %>

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
                                    <th style="width:150px;">충전번호</th>
                                    <td id="chargeNoDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">사용자ID</th>
                                    <td id="userIdDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">금액</th>
                                    <td id="amountDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">지급관리자ID</th>
                                    <td id="adminIdDetail"></td>
                                </tr>
                                 <tr>
                                    <th style="width:150px;">충전일시</th>
                                    <td id="regDateDetail"></td>
                                </tr>
                                 <tr>
                                    <th style="width:150px;">결제수단</th>
                                    <td id="methodDetail"></td>
                                </tr>
                                 <tr>
                                    <th style="width:150px;">취소금액</th>
                                    <td id="cnlAmountDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">잔액</th>
                                    <td id="balanceDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">상태</th>
                                    <td id="statusDetail"></td>
                                </tr>
                                <tr>
                                    <th style="width:150px;">내역</th>
                                    <td><table class="table" id="TChargeDetail" style="font-size:17px;"></table></td>
                                </tr>
                            </tbody>
                        </table>
                       </div>
                    <!-- //구매상세 --> 
                </section>
            </div>
            </div>
        </section>
    </section> 

    <input type="text" id="chargeNoVal" runat="server" />


<script type="text/javascript">
    $(document).ready(function () {
        
        getChargeDetail($("#<%=chargeNoVal.ClientID%>").val());
    })

    function getChargeDetail(chargeNo) {
        
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
                alert("일시적 통신 오류");
            },
            success: function (data) {
                console.log(data);

                if (data.intRetVal != 0) {
                    alert("실패");
                    return;
                }

                var adminId = "";

                if (data.strAdminId == "") {
                    adminId = "-";
                } else {
                    adminId = data.strAdminId
                }

                var dt = new Date(data.strRegDate);
                var test = dt.getHours() < 12 ? " 오전 " : " 오후 "
                
                dt = dt.getFullYear() + "-" + dt.getMonth() + "-" + dt.getDate() +test + dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();
                
                $("#chargeNoDetail").text($("#<%=chargeNoVal.ClientID%>").val());
                $("#userIdDetail").text(data.strUserId);
                $("#amountDetail").text(fnAddComma(data.intAmount));
                $("#adminIdDetail").text(adminId);
                //$("#regDateDetail").text(data.strRegDate);
                $("#regDateDetail").text(dt);
                $("#methodDetail").text(data.strMethod);
                $("#cnlAmountDetail").text(fnAddComma(data.intCnlAmount));
                $("#balanceDetail").text(fnAddComma(data.intBalance));

                var status = "";
                if(data.intStatus == 1){status = "성공";}
                else if(data.intStatus == 2){status = "사용완료";}
                else {status = "취소";}

                $("#statusDetail").text(status);

                fnChargeDetail(data);

            }
        })
    }

    //목록 html
    function fnChargeDetail(data) {

        var html = "";

        html += "       <thead>";
        html += "       <tr>";
        html += "           <th class='text-center'>구매번호</th>"
        html += "           <th class='text-right'>금액</th>";
        html += "           <th class='text-center'>구매패키지번호</th>"
        html += "           <th class='text-center'>ID</th>"
        html += "           <th class='text-center'>유형</th>"
        html += "           <th class='text-center'>사용일시</th>"
        html += "       </tr>";
        html += "       </thead>";
        html += "       <tbody>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr >";
            html += "           <td class='text-center'>" + data.objDT[i].PURCHASENO + "</td>";
            html += "           <td class='text-right'>" + fnAddComma(data.objDT[i].AMOUNT) + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].PACKNO + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].USERID + "</td>";
            
            if (data.objDT[i].TYPE == 1){
                html += "           <td class='text-center'>" + '지급' + "</td>";
            }else if (data.objDT[i].TYPE == 2){
                html += "           <td class='text-center'>" + '회수' + "</td>";
            }else if (data.objDT[i].USERID == data.strUserId){
                html += "           <td class='text-center'>" + '사용' + "</td>";
            }else {
                html += "           <td class='text-center'>" + '-' + "</td>";
            }
            
            html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";
            html += "       </tr>";

        }

        html += "       </tbody>";

        $("#TChargeDetail").html(html);

    }
</script>
</asp:Content>

