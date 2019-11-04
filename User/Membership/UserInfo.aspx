<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="UserInfo.aspx.cs" Inherits="Membership_userInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="membershipPage">    
    <form id="formUserInfo" runat="server">
<!-- header begin -->
    <header class="page-head">
        <div class="header-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">

                        <ol class="breadcrumb">
                            <li><a href="../Membership/Home.aspx">홈</a></li>
                            <li class="active">내정보</li>
                        </ol> <!-- end of /.breadcrumb -->

                    </div>
                </div>
            </div> <!-- /.container -->
        </div> <!-- /.header-wrapper -->
    </header> <!-- /.page-head (header end) -->
    <br /><br />

<div class="main-content">
      <div class="container">
        <div class="col-lg-offset-1 col-lg-10">
        <div class="row">
            <section class="panel">
              <div class="panel-body">

                <div class="form form-horizontal" id="userInfo">

                <div class="form-group">
                    <label class="col-md-3 control-label" for="UserID">아이디</label>
                    <div class="col-md-6">
                        <input type="text"  class="form-control" id="UserID" name="UserID" runat="server" style='cursor:text;' disabled />
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label" for="Name">이름</label>
                    <div class="col-md-6">
                        <input type="text" class="form-control forUpd" id="Name" name="Name" runat="server" style='cursor:text;' disabled />
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label" for="Birth">생년월일</label>
                    <div class="col-md-6">
                        <input type="date" class="form-control forUpd" id="Birth" runat="server" style='cursor:text;' disabled />
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label" for="Sex">성별</label>
                    <div class="col-md-6">
                        <select id="Sex" class="form-control forUpd" runat="server" style='cursor:text;' disabled >
                            <option value="M">남자</option>
                            <option value="F">여자</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label" for="Phone">연락처</label>
                    <div class="col-md-6">
                        <input type="text" class="form-control forUpd" id="Phone" runat="server" style='cursor:text;' disabled />
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label" for="Email">이메일</label>
                    <div class="col-md-6">
                        <input type="text" class="form-control forUpd" id="Email" runat="server" style='cursor:text;' disabled />
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label" for="postcode">주소</label>
                    <div class="col-md-6">
                        <input type="text" class="form-control forUpd" id="postcode" runat="server" style='cursor:text;' disabled> 
                        <input type="button" class="btn btn-primary forUpd" onclick="execDaumPostcode()" value="우편번호 찾기" disabled><br>
                        <input type="text" class="form-control forUpd" id="address1" runat="server" style='cursor:text;' disabled>
                        <input type="text" class="form-control forUpd" id="address2" runat="server" style='cursor:text;' disabled>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-md-offset-2 col-md-10 btnUpd" style="text-align:right;">
                        <input type="button" class="btn btn-primary" id="btnInfoUpd" value="수정" />
                        <input type="button" class="btn btn-primary" id="btnPwUpd" value="비밀번호 변경" />
                    </div>
                </div>
            
                </div>
              </div>
           </section>
          </div>
        </div>

        <!-- 비밀번호 변경 모달 -->
            <div  role="dialog" id="updPwModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">비밀번호 변경</h4>
                        </div>
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">

                                 <div class="form-group">
                                    <label class="col-md-3 control-label" for="UserCurrPw">현재 비밀번호<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="password" class="form-control" id="UserCurrPw" name="UserCurrPw" required/>
                                    </div>
                                </div>

                                <div class="form-group">
                                <label class="col-md-3 control-label" for="UserPwUpd">변경할 비밀번호<span class="required">*</span></label>
                                <div class="col-md-6">
                                        <input type="password" class="form-control" id="UserPwUpd" name="UserPwUpd" required/>
                                        <p class="help-block" id ="pwValidCheck"></p>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="UserPwUpdCheck">비밀번호 확인<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="password" class="form-control" id="UserPwUpdCheck" name="UserPwUpdCheck" required/>
                                        <p class="help-block" id ="pwCheckValidCheck"></p>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnUpdPw" value="변경" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 비밀번호 변경 모달 -->
    </div>
</div> 
       </form>     
</div>     
 <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
 <script type="text/javascript">
     $(document).ready(function () {

         btnPwUpdClick();
         updatePw();
         validCheck();

         $('#updPwModal').on('hidden.bs.modal', function (e) {
             console.log('modal close');
             $("#formUserInfo")[0].reset();
         });

         //수정하기 버튼
         $("#btnInfoUpd").on("click", function () {
             $(".forUpd").removeAttr("disabled");

             $("#ContentPlaceHolder1_UserPw").val($("#ContentPlaceHolder1_Password1").val());

             var html = "";
             html += "       <input type='button' class='btn btn-primary' id='btnUpd' value='수정' />";
             html += "       <input type='button' class='btn btn-primary' id='btnCancel' value='취소' />";

             $(".btnUpd").html(html);

             //수정 등록 버튼
             $("#btnUpd").on("click", function () {

                 //유효성검사
                 
                 var rePhone = /^[0-9]{10,11}$/;
                 var reEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/;

                 var Name = document.getElementById('ContentPlaceHolder1_Name').value;
                 var Birth = document.getElementById('ContentPlaceHolder1_Birth').value;
                 var Sex = document.getElementById('ContentPlaceHolder1_Sex').value;
                 var Phone = document.getElementById('ContentPlaceHolder1_Phone').value;
                 var Email = document.getElementById('ContentPlaceHolder1_Email').value;

                 if (Name == "") {
                     alert("이름을 입력하세요");
                     return;
                 }

                 if ((/\s/g).test(Name)) {
                     alert("이름에 공백을 입력할 수 없습니다");
                     return;
                 }

                 if (Birth == "") {
                     alert("생년월일을 입력하세요");
                     return;
                 }

                 if (!rePhone.test(Phone)) {
                     alert("연락처 형식을 확인하세요");
                     return;
                 }

                 if (Email != "" && !reEmail.test(Email)) {
                     alert("이메일 형식을 확인하세요");
                     return;
                 }


                 var reqParam = {};

                 reqParam["strMethod"] = "UserInfoUpd";
                 reqParam["intUserNo"] = <%= Session["userNo"] %>;
                 reqParam["strName"] = Name;
                 reqParam["strBirth"] = Birth;
                 reqParam["strSex"] = Sex;

                 reqParam["strPhone"] = Phone;
                 reqParam["strEmail"] = Email;
                 reqParam["strPostcode"] = document.getElementById('ContentPlaceHolder1_postcode').value;
                 reqParam["strAddress1"] = document.getElementById('ContentPlaceHolder1_address1').value;
                 reqParam["strAddress2"] = document.getElementById('ContentPlaceHolder1_address2').value;

                 console.log(reqParam);

                 if (false == confirm("수정 하시겠습니까?")){
                     location.reload();
                     return;
                 }

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
                         alert("수정 되었습니다.");
                         location.reload();
                     }
                 })
             });

             //수정 취소 버튼
             $("#btnCancel").on("click", function () {
                 location.reload();
             });

         });

     });

     function btnPwUpdClick(){
         $("#btnPwUpd").on("click",function(){
             $("#updPwModal").modal();
         });
     }

     //비밀번호 변경
     function updatePw(){

         $("#btnUpdPw").on("click", function () {

             //영문자, 숫자, 특수문자 포함 형태의 8~20자
             var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
             var pw = "<%=Session["UserPw"]%>";

             if (pw != $("#UserCurrPw").val()){
                 alert("현재 비밀번호가 틀립니다");
                 return;
             }

             if ($("#UserCurrPw").val() == $("#UserPwUpd").val()) {
                 alert("현재 비밀번호와 다른 비밀번호를 입력하세요");
                 return;
             }

             if (!rePw.test($("#UserPwUpd").val())) {
                 alert("비밀번호 형식을 확인하세요");
                 return;
             }

             if ($("#UserPwUpd").val() != $("#UserPwUpdCheck").val()) {
                 alert("비밀번호 확인 다시 입력하세요");
                 return;
             }

             
             var reqParam = {};
             reqParam["strMethod"] = "UserPwUpd";
             reqParam["intUserNo"] = <%= Session["userNo"] %>;
             reqParam["strUserPw"] = $("#UserPwUpd").val();

             console.log(reqParam);

             if (false == confirm("변경 하시겠습니까?")){
                 location.reload();
                 return;
             }

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
                     alert("비밀번호가 변경 되었습니다.");
                     location.reload();
                 }
             })


         });

     }

     function validCheck() {

         $("#UserPwUpd").on("keyup", function () {

             var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;;
             var UserPwUpd = $("#UserPwUpd").val();

             if (!rePw.test(UserPwUpd)) {
                 $("#pwValidCheck").text("영문자, 숫자, 특수문자(!@#$%^&+=) 각각 하나 이상 포함 최소 8자~최대 20자");
                 $("#pwValidCheck").attr("style", "color:#00a0df;");
             } else {
                 $("#pwValidCheck").text("");
             }

         });

         $("#UserPwUpdCheck").on("keyup", function () {

             if ($("#UserPwUpd").val() != $("#UserPwUpdCheck").val()) {
                 $("#pwCheckValidCheck").text("일치하지 않습니다");
                 $("#pwCheckValidCheck").attr("style", "color:#00a0df;");
             } else {
                 $("#pwCheckValidCheck").text("");
             }
         });
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

