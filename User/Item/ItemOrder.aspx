<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ItemOrder.aspx.cs" Inherits="Item_ItemOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<style type="text/css">
    body {
		font-family: 'Varela Round', sans-serif;
	}

	.modal-confirm {		
		color: #636363;
		width: 325px;
	}
	.modal-confirm .modal-content {
		padding: 20px;
		border-radius: 5px;
		border: none;
	}
	.modal-confirm .modal-header {
		border-bottom: none;   
        position: relative;
	}
	.modal-confirm h4 {
		text-align: center;
		font-size: 26px;
		margin: 30px 0 -15px;
	}
	.modal-confirm .form-control, .modal-confirm .btn {
		min-height: 40px;
		border-radius: 3px; 
	}
	.modal-confirm .close {
        position: absolute;
		top: -5px;
		right: -5px;
	}	
	.modal-confirm .modal-footer {
		border: none;
		text-align: center;
		border-radius: 5px;
		font-size: 13px;
	}	
	.modal-confirm .icon-box {
		color: #fff;		
		position: absolute;
		margin: 0 auto;
		left: 0;
		right: 0;
		top: -70px;
		width: 95px;
		height: 95px;
		border-radius: 50%;
		z-index: 9;
		background: #82ce34;
		padding: 15px;
		text-align: center;
		box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.1);
	}
	.modal-confirm .icon-box i {
		font-size: 58px;
		position: relative;
		top: 3px;
	}
	.modal-confirm.modal-dialog {
		margin-top: 80px;
	}
    .modal-confirm .btn {
        color: #fff;
        border-radius: 4px;
		background: #82ce34;
		text-decoration: none;
		transition: all 0.4s;
        line-height: normal;
        border: none;
    }
	.modal-confirm .btn:hover, .modal-confirm .btn:focus {
		background: #6fb32b;
		outline: none;
	}
	.trigger-btn {
		display: inline-block;
		margin: 100px auto;
	}

    
</style>
    
<div id="saladPage">
    <form id="formItemOrder" name="formItemOrder" runat="server">
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
      <div class="container">
        <div class="col-lg-offset-1 col-lg-10"> 
            <main class="col-md-12" >

            <section class="panel">

                <div class="row">
                    <%-- 상품정보 상품이미지, 상품명, 금액, 수령시작일, 수령완료일(?) --%>
                    <h3>상품 정보</h3><hr />
                    <input type="hidden" id="packNoVal" name="packNoVal" runat="server" />
                    <div>
                        <div class="col-md-4" style="display: block;">
                            <img id="packImg" runat="server" style="max-width:200px;"/>
                        </div>
                        <aside class="col-md-8">
                            <table class="table" border="0" style="font-size:20px; font-weight:normal;">
                                <tbody>
                                    <tr>
                                        <th style="border:0px">패키지명</th>
                                        <td id="packName" runat="server" style="border:0px"></td>
                                    </tr>
                                    <tr>
                                        <th style="border:0px">가격</th>
                                        <td id="packPrice" runat="server" style="border:0px"></td>
                                    </tr>
                                    <tr>
                                        <th style="border:0px">수령시작일</th>
                                        <td id="recvStartDate" runat="server" style="border:0px"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </aside>

                    </div>
                </div>

                <div class="row">
                    <%-- 주문정보 이름,주소,전화 --%>
                    <h3>주문자 정보</h3>
                    <hr />
                    <div class="orderInfo">
                        <div class="form-group">
                            <label class="control-label col-lg-2" style="padding-top:0px;">이름<span class="required">*</span></label>
                            <div class="col-lg-10">
                                <input class="form-control" id="userName" name="userName" runat="server"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-lg-2" style="padding-top:0px;" for="postcode">주소<span class="required">*</span></label>
                            <div class="col-lg-10">
                                <div style="height: 50px;"><input type="text" class="form-control" id="postcode" runat="server" style='cursor:text;width: 150px;display: inline;'> 
                                <input type="button" class="btn btn-primary forUpd" onclick="execDaumPostcode()" value="우편번호 찾기" style='height: 100%;margin-bottom: 5px;display: inline;margin-left: -4px;'><br></div>
                                <input type="text" class="form-control" id="address1" runat="server" style='cursor:text;'>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-2" style="padding-top:0px;" for="address2">상세주소<span class="required">*</span></label>
                            <div class="col-lg-10">
                                <input type="text" class="form-control" id="address2" runat="server" style='cursor:text;'>
                            </div>
                        </div>

                        <div class="form-group">

                            <label class="control-label col-lg-2" style="padding-top:0px;">연락처<span class="required">*</span></label>
                            <div class="col-lg-10">
                                <input class="form-control" id="phone" name="phone" runat="server"/>
                            </div>
                        </div>
                    </div>
                </div>

                    <br/><br />

                <div class="row">
                    <%-- 결제 예정금액 (캐시 쓸건지) --%>
                    <h3>결제 정보</h3>
                    <hr />
                    <div class="chargeInfo">
                        <div class="form-group">
                            <label class="control-label col-lg-2" style="padding-top:0px;">보유캐시</label>
                            <div class="col-lg-10">
                                <input class="form-control" id="totalCash" name="totalCash" runat="server" readonly style="border:none; background-color:white"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-2" style="padding-top:0px;">사용캐시</label>
                            <div class="col-lg-10">
                                <input class="form-control" id="cashAmount" name="cashAmount" value="0" autocomplete="off"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-lg-2" style="padding-top:0px;">결제할 금액</label>
                            <div class="col-lg-10">
                                <input class="form-control" id="chargeAmount" name="chargeAmount" readonly style="border:none; background-color:white"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-lg-2" style="padding-top:0px;">예상 적립캐시<br />(결제금액의 5%)</label>
                            <div class="col-lg-10">
                                <input class="form-control" id="bonusAmount" name="chargeAmount" readonly style="border:none; background-color:white"/>
                            </div>
                        </div>
                    </div>
                </div>

                <input type="hidden" id="cashAmountVal" name="cashAmountVal" />
                <input type="hidden" id="chargeAmountVal" name="chargeAmountVal" />

                <br /><br />
                <div class="row">
                    <%-- 결제수단 --%>
                    <h3>결제수단 선택</h3>
                    <hr />
                    <div class="form-group">
                        <label class="control-label col-lg-2" style="padding-top:0px;">결제수단</label>
                        <div class="col-lg-10">
                            <div class="col-sm-2" style="font-size:17px;">
                                <i class="fa fa-credit-card"> 카드
                                    <input type="radio" name="method" value="creditcard"/>
                                </i>
                            </div>
                            <div class="col-sm-2" style="font-size:17px;">
                                <i class="fa fa-mobile"> 휴대폰
                                    <input type="radio" name="method" value="mobile"/>
                                </i>
                            </div>
                        </div>
                    </div>
                </div> 
                <input type="hidden" id="pgCode" name="pgCode"/>
                <input type="hidden" id="dateRecvStart" name="dateRecvStart" />

                <div class="form-group" style="text-align:right;">
                    <div class="col-lg-12">
                        <asp:Button type="button" runat="server" class="btn btn-primary" id="btnPay" OnClick="btnPay_Click" OnClientClick="return fnCheck();" Text="결제" />
                    </div>
                </div>

            </section>
           </main>

         </div>

          
<!-- Modal HTML -->
<div id="orderSuccess" class="modal fade">
	<div class="modal-dialog modal-confirm">
		<div class="modal-content">
			<div class="modal-header">
				<div class="icon-box">
					<i class="fa fa-thumbs-o-up"></i>
				</div>				
				<h4 class="modal-title">구매성공!</h4>	
			</div>
			<div class="modal-body">
				<p class="text-center">구매목록에서 내역을 확인하세요</p>
			</div>
			<div class="modal-footer">
				<button class="btn btn-success btn-block" data-dismiss="modal">구매목록</button>
			</div>
		</div>
	</div>
</div>     


          </div>
        </div>
      </form>
     </div>
 <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script type="text/javascript">
        
        $(document).ready(function () {
            $("#<%= packPrice.ClientID %>").text(fnAddComma($("#<%= packPrice.ClientID %>").text()));
            $("#<%= totalCash.ClientID %>").val(fnAddComma($("#<%= totalCash.ClientID %>").val()));


            $("#chargeAmount").val($("#<%= packPrice.ClientID %>").text());
            $("#dateRecvStart").val($("#<%=recvStartDate.ClientID%>").text());

            $("#cashAmount").keyup(function () {
                $("#cashAmount").val(fnRmvComma($("#cashAmount").val()));
                $("#cashAmount").val(fnAddComma($("#cashAmount").val()));

                var cashAmount = parseInt(fnRmvComma($("#cashAmount").val()));

                if (isNaN(cashAmount)) {
                    cashAmount = 0;
                }

                var totalCash = parseInt(fnRmvComma($("#<%= totalCash.ClientID %>").val()));
                var packPrice = parseInt(fnRmvComma($("#<%= packPrice.ClientID %>").text()));

                if (cashAmount > totalCash) {
                    alert("보유캐시가 부족합니다.");
                    $("#cashAmount").val(0);
                    $("#chargeAmount").val(packPrice);

                    return;
                }

                var ca = packPrice - cashAmount;

                $("#chargeAmount").val(fnAddComma(ca));
                $("#bonusAmount").val(fnAddComma(fnRmvComma($("#chargeAmount").val()) * 0.05));
            });

            $('input:radio[name="method"]').change(function () {
                $("#pgCode").val($(this).val());
            });

            $('#orderSuccess').on('hidden.bs.modal', function (e) {
                location.href = "../Membership/PurchaseList.aspx";
            });

            $("#bonusAmount").val(fnAddComma(fnRmvComma($("#chargeAmount").val()) * 0.05));

            
        })

        function fnCheck() {

            var totalCash = 0;

            var reqParam = {};
            reqParam["strMethod"] = "UserInfoGet";
            reqParam["intUserNo"] = "<%=Session["userNo"]%>";

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
                    totalCash = data.objDT[0].TOTALCASH
                }
            })

            if ( $("#<%= totalCash.ClientID %>").val() < $("#cashAmount").val()) {
                alert("캐시 잔액이 부족합니다");
                return false;
            }

            if ($("#<%=postcode.ClientID%>").val() == "" || $("#<%=address1.ClientID%>").val() == "" || $("#<%=address2.ClientID%>").val() == ""){
                alert("주소를 입력하세요");
                return false;
            }
          
            if ($("#chargeAmount").val() != "0" && $("#pgCode").val() == "") {
                alert("결제수단을 선택하세요");
                return false;
            } 

            $("#cashAmountVal").val(fnRmvComma($("#cashAmount").val()));
            $("#chargeAmountVal").val(fnRmvComma($("#chargeAmount").val()));

            return true;
        }



        function fnOrderSuccess(){
            $("#orderSuccess").modal();
        }

        //우편번호
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function (data) {

                    var fullAddr = '';
                    var extraAddr = '';

                    if (data.userSelectedType === 'R') {
                        fullAddr = data.roadAddress;

                    } else {
                        fullAddr = data.jibunAddress;
                    }

                    if (data.userSelectedType === 'R') {
                        if (data.bname !== '') {
                            extraAddr += data.bname;
                        }
                        if (data.buildingName !== '') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                    }

                    document.getElementById('ContentPlaceHolder1_postcode').value = data.zonecode;
                    document.getElementById('ContentPlaceHolder1_address1').value = fullAddr;

                    document.getElementById('ContentPlaceHolder1_address2').value = "";
                    document.getElementById('ContentPlaceHolder1_address2').focus();
                }
            }).open();
        }
    </script>
</asp:Content>

