
<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="AdminList.aspx.cs" Inherits="Admin_AdminList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!--main content start-->
    <section id="main-content">
      <section class="wrapper">
            <div class="row">

                <input type="hidden" id="authRangeVal" runat="server" />

                <!-- 관리자 검색 -->
                <div class="col-md-2">
                    <input type="text" class="form-control" placeholder="아이디검색" id="searchId" />
                </div>

                <!-- todo -->
                <div class="col-md-2">
                    <select id="searchType" class="form-control">
                        <option value="0">전체</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <input type="button" class="btn btn-primary" id="btnSearch" value="조회" />
                    <input type="button" class="btn btn-primary" id="btnList" value="목록" style="margin-left:2%;"/>
                </div>

                <!-- //관리자 검색 -->

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
                <!-- 관리자 목록 -->
                <div id="adminList">
                    <table class="table table-striped table-hover" id="TAdminList" style="font-size:17px;">
                    </table>
                </div>
                <!-- //관리자 목록 --> 
            </section>

            <!-- 등록 버튼 -->
            <div style="text-align:right;">
                <input type="button" id="btnAdd" class="btn btn-primary btnAdminW" value="등록"/>
            </div>
            <!-- //등록 버튼 -->

            <!--페이징-->
            <div class="row content-row-pagination" style="text-align:center;">
                <div class="col-md-12">
                    <ul class="pagination" id="pagingList">
                    </ul>
                </div>
            </div>
            <!--// 페이징-->

          <input type="hidden" id="adminNoVal" />

            <!-- 등록 모달 -->
            <div  role="dialog" id="addAdminModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">관리자 등록</h4>
                        </div>
                        <input type="hidden" id="idCheckVal" value="1"/> 
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="AdminID">아이디<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="text"  class="form-control id" id="AdminID" name="AdminID" maxlength="20" required />
                                        <p class="help-block idValCheck"></p>
                                    </div>
                                    <input type="button" class="btn btn-primary" id="AdminIdCheck" value="중복확인" />
                                </div>

                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="AdminPw">비밀번호<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="password" class="form-control pw" id="AdminPw" name="AdminPw" maxlength="20" required />
                                        <p class="help-block pwValCheck"></p>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="AdminPwCheck">비밀번호 확인<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="password" class="form-control pwCheck" id="AdminPwCheck" name="AdminPwCheck" maxlength="20" required />
                                        <p class="help-block pwCheckValCheck"></p>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="AuthType">권한유형<span class="required">*</span></label>
                                    <div class="col-md-6 ">
                                        <select id="AuthType" class="form-control authSelectList" required >
                                            
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="Name">이름<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" id="Name" name="Name" required />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnAddAdmin" value="등록" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 등록 모달 -->

          <!-- 수정 모달 -->
            <div  role="dialog" id="updAdminModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">관리자 수정</h4>
                        </div>
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="updAdminID">아이디<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="text"  class="form-control" id="updAdminID" name="updAdminID"  style='cursor:text;' disabled />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="updAdminPw">비밀번호<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="password" class="form-control" id="updAdminPw" name="updAdminPw" maxlength="20" required />
                                        <p class="help-block pwValCheckUpd"></p>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="updName">이름<span class="required">*</span></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" id="updName" name="updName" required />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-3 control-label" for="updAuthType">권한유형<span class="required">*</span></label>
                                    <div class="col-md-6 ">
                                        <select id="updAuthType" class="form-control authSelectList" required >
                                            
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnUpdAdmin" value="수정" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 수정 모달 -->

        </section>
  </section>

 <script type="text/javascript">
     $(document).ready(function () {

         var authRange = document.getElementById('ContentPlaceHolder1_authRangeVal').value;

         getAdminList(1, 10, authRange);

         idCheck();
         addAdmin();
         updAdmin();
         getAuthList();
         validCheck();

         $("#AdminID").on("keyup", function () {
             $("#idCheckVal").val("1");
         });

         $('#addAdminModal').on('hidden.bs.modal', function (e) {
             console.log('modal close');
             $("#form1")[0].reset();
         });

         $('#updAdminModal').on('hidden.bs.modal', function (e) {
             console.log('modal close');
             $("#form1")[0].reset();
         });


         //검색 버튼 클릭
         $("#btnSearch").on("click", function () {
             var pageSize = $("#selectPageSize").val();

             getAdminList(1, pageSize, authRange);
         })

         $("#btnList").on("click", function () {
             location.reload();
         })

         //페이징 버튼 클릭
         $("#pagingList").on("click", "li", function () {
             var pageNo = $(this).data("pageno");
             var pageSize = $("#selectPageSize").val();

             getAdminList(pageNo, pageSize, authRange);

         })

         //페이지 사이즈 변경
         $("#selectPageSize").change(function () {
             getAdminList(1, $(this).val(), authRange);
         })

         //등록버튼 클릭
         $("#btnAdd").on("click", function () {
             $("#addAdminModal").modal();
        });

         authHideBtn(authRange);

     });

        //관리자 목록
        function getAdminList(pageNo, pageSize, authRange) {
             var reqParam = {};

             reqParam["strMethod"] = "AdminList";
             reqParam["intPageNo"] = pageNo;
             reqParam["intPageSize"] = pageSize;
             
             reqParam["strSearchId"] = $("#searchId").val();
             reqParam["intSearchType"] = $("#searchType").val();

             console.log(reqParam);

             $.ajax({
                 type: "POST",
                 data: JSON.stringify(reqParam),
                 url: "/AdminMng/AdminHandler.ashx",
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

                     fnAdminList(data, pageNo, pageSize, authRange);
                 }
             })
         }

        //관리자 목록 html
        function fnAdminList(data, pageNo, pageSize, authRange) {

             var html = "";
             html += "       <thead>";
             html += "       <tr>";
             html += "           <th class='text-center' width='10%;'>#</th>";
             html += "           <th class='text-center' width='30%;'>권한유형</th>";
             html += "           <th class='text-center' width='20%;'>아이디</th>";
             html += "           <th class='text-center' width='15%;'>이름</th>";
             html += "           <th class='text-center' width='15%;'>등록일</th>";
             html += "           <th class='text-center' width='10%;'>관리</th>";
             html += "       </tr>";
             html += "       </thead>";
             html += "       <tbody>";

             for (var i = 0; i < data.objDT.length; i++) {

                 html += "       <tr >";
                 html += "           <td class='text-center'>" + data.objDT[i].ROWNUM + "</td>";
                 html += "           <td class='text-center'>" + data.objDT[i].AUTHTYPE + "</td>";
                 html += "           <td class='text-center'>" + data.objDT[i].ADMINID + "</td>";
                 html += "           <td class='text-center'>" + data.objDT[i].NAME + "</td>";
                 html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";
                 html += "           <td class='text-center'> <input type='button' class='btn btn-default btnUpd btnAdminW' onclick='btnUpd_click(" + data.objDT[i].ADMINNO + ")' value='수정' /> </td>";

                 html += "       </tr>";

             }

             html += "       </tbody>";

             $("#TAdminList").html(html);

             fnPagingList(data, pageNo, pageSize);
             authHideBtn(authRange);

         }

        //수정버튼 클릭
        function btnUpd_click(adminNo) {
             var reqParam = {};

             reqParam["strMethod"] = "AdminDetail";
             reqParam["intAdminNo"] = adminNo;
             $("#adminNoVal").val(adminNo);

             console.log(reqParam);

             $.ajax({
                 type: "POST",
                 data: JSON.stringify(reqParam),
                 url: "/AdminMng/AdminHandler.ashx",
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

                     $("#updAdminID").val(data.objDT[0].ADMINID);
                     $("#updAdminPw").val(data.objDT[0].ADMINPW);
                     $("#updName").val(data.objDT[0].NAME);
                     $("#updAuthType").val(data.objDT[0].AUTHNO);

                     $("#updAdminModal").modal();

                 }
             })

         }

        //관리자 정보 수정
        function updAdmin() {
             $("#btnUpdAdmin").on("click", function () {
                 var reqParam = {};
                 
                 var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;

                 if (!rePw.test($("#updAdminPw").val())) {
                     alert("비밀번호 형식을 확인하세요");
                     return;
                 }

                 if ($("#updName").val() == "") {
                     alert("이름을 입력하세요");
                     return;
                 }

                 if ((/\s/g).test($("#updName").val())) {
                     alert("이름에 공백을 입력할 수 없습니다");
                     return;
                 }

                 reqParam["strMethod"] = "AdminUpd";
                 reqParam["intAdminNo"] = $("#adminNoVal").val();
                 reqParam["strAdminPw"] = $("#updAdminPw").val();
                 reqParam["strName"] = $("#updName").val();
                 reqParam["intAuthNo"] = $("#updAuthType").val();

                 //todo
                 if (false == confirm("수정 하시겠습니까?")) return;

                 $.ajax({
                     type: "POST",
                     data: JSON.stringify(reqParam),
                     url: "/AdminMng/AdminHandler.ashx",
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

                         alert("수정 되었습니다.");
                         location.reload();
                     }
                 })


             })
         }

        //아이디 중복확인
        function idCheck() {
             $("#AdminIdCheck").on("click", function () {
                 var reqParam = {};

                 reqParam["strMethod"] = "AdminIdCheck";
                 reqParam["strAdminId"] = $("#AdminID").val();

                 console.log(reqParam);

                 $.ajax({
                     type: "POST",
                     data: JSON.stringify(reqParam),
                     url: "/AdminMng/AdminHandler.ashx",
                     dataType: "JSON",
                     contentType: "application/json; charset=utf-8",
                     error: function (request, status, error) {
                         alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                     },
                     success: function (data) {
                         var reId = /^(?=.*[a-zA-Z])[a-zA-Z0-9].{5,20}$/;
                         var UserID = $("#AdminID").val();

                         if (!reId.test(UserID) || UserID.match(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
                             alert("아이디 형식을 확인하세요");
                             return;
                         }

                         if (data.intCheckVal == 0) {
                             alert("사용할 수 있는 아이디 입니다.");
                             $("#idCheckVal").val("0");
                         } else {
                             alert("이미 존재하는 아이디 입니다.");
                         }

                     }
                 })
             })
         }

        //등록
        function addAdmin() {
             $("#btnAddAdmin").on("click", function () {
                 var reqParam = {};

                 if ($("#idCheckVal").val() != 0) {
                     alert("아이디 중복확인 하세요");
                     return;
                 }
                 
                 //비번 유효성검사
                 var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;

                 if (!rePw.test($("#AdminPw").val())) {
                     alert("비밀번호 형식을 확인하세요");
                     return;
                 }

                 if ($("#AdminPw").val() != $("#AdminPwCheck").val()) {
                     alert("비밀번호 확인 다시 입력");
                     return;
                 }

                 if ($("#Name").val() == "") {
                     alert("이름을 입력하세요");
                     return;
                 }

                 if ((/\s/g).test($("#Name").val())) {
                     alert("이름에 공백을 입력할 수 없습니다");
                     return;
                 }


                 reqParam["strMethod"] = "AdminIns";
                 reqParam["strAdminId"] = $("#AdminID").val();
                 reqParam["strAdminPw"] = $("#AdminPw").val();
                 reqParam["intAuthNo"] = $("#AuthType").val();
                 reqParam["strName"] = $("#Name").val();

                 console.log(reqParam);

                 if (false == confirm("등록 하시겠습니까?")) {
                     return;
                 }

                 $.ajax({
                     type: "POST",
                     data: JSON.stringify(reqParam),
                     url: "/AdminMng/AdminHandler.ashx",
                     dataType: "JSON",
                     contentType: "application/json; charset=utf-8",
                     error: function (request, status, error) {
                         alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                     },
                     success: function (data) {
                         console.log(data);
                         alert("등록 되었습니다.");
                         location.reload();
                     }
                 })

             })

         }

        //권한 selectbox
        function getAuthList() {
             var reqParam = {};

             reqParam["strMethod"] = "AuthList";
             reqParam["intPageNo"] = 1;
             reqParam["intPageSize"] = 10;

             console.log(reqParam);

             $.ajax({
                 type: "POST",
                 data: JSON.stringify(reqParam),
                 url: "/AuthMng/AuthHandler.ashx",
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

                     fnAuthList(data);

                 }
             })

         }

        //권한 목록 html
        function fnAuthList(data) {

            var html = "";

            for (var i = 0; i < data.objDT.length; i++) {

                html += "   <option value='"+data.objDT[i].AUTHNO+"'>"+data.objDT[i].AUTHTYPE+"</option>     ";
            }

            $(".authSelectList").html(html);

            $("#searchType").append(html);
         }

        //권한 버튼 제어
        function authHideBtn(authRange) {

             if (authRange == 'R') {

                 $(".btnAdminW").attr('style', 'cursor:not-allowed');
                 $(".btnAdminW").attr('disabled', 'disabled');
             }

         }

        //실시간 유효성 검사
        function validCheck() {
             $(".id").on("keyup", function () {

                 var reId = /^(?=.*[a-zA-Z])[a-zA-Z0-9].{5,20}$/;
                 var ID = $(".id").val();

                 if (!reId.test(ID) || ID.match(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
                     $(".idValCheck").text("숫자와 최소 1개의 영문자 포함 6-20자");
                     $(".idValCheck").attr("style", "color:#00a0df;")
                 } else {
                     $(".idValCheck").text("");
                 }
             });

             $(".pw").on("keyup", function () {

                 var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;;
                 var UserPwUpd = $(".pw").val();

                 if (!rePw.test(UserPwUpd)) {
                     $(".pwValCheck").text("영문자, 숫자, 특수문자(!@#$%^&+=) 각각 하나 이상 포함 최소 8자~최대 20자");
                     $(".pwValCheck").attr("style", "color:#00a0df;");

                 } else {
                     $(".pwValCheck").text("");
                 }

             });

             $(".pwCheck").on("keyup", function () {

                 if ($(".pw").val() != $(".pwCheck").val()) {
                     $(".pwCheckValCheck").text("일치하지 않습니다");
                     $(".pwCheckValCheck").attr("style", "color:#00a0df;");
                 } else {
                     $(".pwCheckValCheck").text("");
                 }
             });

             $("#updAdminPw").on("keyup", function () {

                 var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;;
                 var UserPwUpd = $("#updAdminPw").val();

                 if (!rePw.test(UserPwUpd)) {
                     $(".pwValCheckUpd").text("영문자, 숫자, 특수문자(!@#$%^&+=) 각각 하나 이상 포함 최소 8자~최대 20자");
                     $(".pwValCheckUpd").attr("style", "color:#00a0df;");

                 } else {
                     $(".pwValCheckUpd").text("");
                 }

             });
         }


 </script>
</asp:Content>

