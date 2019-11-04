<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="UserList.aspx.cs" Inherits="UserMng_UserList" %>

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

                <div class="col-md-2">
                    <select id="searchType" class="form-control">
                        <option value="0">전체</option>
                        <option value="1">정상</option>
                        <option value="2">비활성</option>
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
                <!-- 사용자 목록 -->
                <div id="userList">
                    <table class="table table-striped table-hover" id="TUserList" style="font-size:17px;">
                    </table>
                </div>
                <!-- //사용자 목록 --> 
            </section>

            <!-- 등록 버튼 -->
            <div style="text-align:right;">
                <input type="button" id="btnAdd" class="btn btn-primary btnUserW" value="등록"/>
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

          <input type="hidden" id="userNoVal" />

          <!-- 등록 모달 -->
            <div  role="dialog" id="addUserModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">회원 등록</h4>
                        </div>
                        <input type="hidden" id="idCheckVal" value="1"/> 
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                                <div class="form-group">
                            <label class="col-md-3 control-label" for="UserID">아이디<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text"  class="form-control" id="UserID" name="UserID" maxlength="20" required/>
                                <p class="help-block" id="idValidCheck"></p>
                            </div>
                            <input type="button" class="btn btn-primary" id="userIdCheck" value="중복확인" />
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="UserPw">비밀번호<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="password" class="form-control" id="UserPw" name="UserPw" maxlength="20" required/>
                                <p class="help-block" id="pwValidCheck"></p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="Name">이름<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text" class="form-control" id="Name" name="Name" required/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="Birth">생년월일<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="date" class="form-control" id="Birth" required/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="Sex">성별<span class="required">*</span></label>
                            <div class="col-md-6">
                                <select id="Sex" class="form-control" required>
                                    <option value="M">남자</option>
                                    <option value="F">여자</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="Phone">연락처<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text" class="form-control" id="Phone" placeholder="-없이 입력하세요" required/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="Email">이메일</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control" id="Email" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="postcode">주소</label>
                            <div class="col-md-6">
                                <%--<input type="text" class="form-control" id="Address" />--%>
                                <input type="text" class="form-control" id="postcode" placeholder="우편번호">
                                <input type="button" class="btn btn-primary" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
                                <input type="text" class="form-control" id="address1" placeholder="주소">
                                <input type="text" class="form-control" id="address2" placeholder="상세주소">
                            </div>
                        </div>

                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnAddUser" value="등록" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 등록 모달 -->

          <!-- 상세보기 모달 -->
            <div  role="dialog" id="userDtlModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title" id="userModalTitle">회원 상세보기</h4>
                        </div>
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                                <div class="form-group">
                            <label class="col-md-3 control-label" for="UserIDDetail">아이디<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text"  class="form-control" id="UserIDDetail" name="UserIDDetail" style="cursor:text;" disabled required/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="NameDetail">이름<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text" class="form-control userDtl" id="NameDetail" name="NameDetail" style="cursor:text;" disabled required/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="BirthDetail">생년월일<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="date" class="form-control userDtl" id="BirthDetail" style="cursor:text;" disabled required/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="SexDetail">성별<span class="required">*</span></label>
                            <div class="col-md-6">
                                <select id="SexDetail" class="form-control userDtl" style="cursor:text;" disabled required>
                                    <option value="M">남자</option>
                                    <option value="F">여자</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="PhoneDetail">연락처<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text" class="form-control userDtl" id="PhoneDetail" placeholder="-없이 입력하세요" style="cursor:text;" disabled required/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="EmailDetail">이메일</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control userDtl" id="EmailDetail" style="cursor:text;" disabled />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="StatusDetail">상태<span class="required">*</span></label>
                            <div class="col-md-6">
                                <select id="StatusDetail" class="form-control userDtl" style="cursor:text;" disabled required>
                                    <option value="1">정상</option>
                                    <option value="2">비활성</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="AddressDetail">주소<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text" class="form-control forUpd" id="PostcodeDetail" style='cursor:text;' disabled> 
                                <input type="text" class="form-control forUpd" id="Address1Detail" style='cursor:text;' disabled>
                                <input type="text" class="form-control forUpd" id="Address2Detail" style='cursor:text;' disabled>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="CashDetail">보유캐시</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control" id="CashDetail" style="cursor:text;" disabled />
                            </div>
                            <input type="button" class="btn btn-default btnCash" id="cashIns" value="지급" />
                            <input type="button" class="btn btn-default btnCash" id="cashDel" value="회수" />
                        </div>

                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10" style="text-align:right;">
                                        <input type="button" class="btn btn-primary btnUserW"  style="float:right;" id="btnUpdUser" value="수정" />
                                    </div>
                                    <div class="col-md-offset-2 col-md-10" style="text-align:right;">
                                        <input type="button" class="btn btn-primary"  style="float:right; display:none;" id="btnUpdate" value="확인" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 상세보기 모달 -->
        </section>
  </section>

 <script type="text/javascript">
     $(document).ready(function () {

         var authRange = document.getElementById('ContentPlaceHolder1_authRangeVal').value;

         getUserList(1, 10, authRange);

         idCheck();
         addUser();
         validCheck();

         $("#UserID").on("keyup", function () {
             $("#idCheckVal").val("1");
         });

         $('#addUserModal').on('hidden.bs.modal', function (e) {
             console.log('modal close');
             $("#form1")[0].reset();
         });

         //검색 버튼 클릭
         $("#btnSearch").on("click", function () {
             var pageSize = $("#selectPageSize").val();

             getUserList(1, pageSize, authRange);
         })

         //페이징 버튼 클릭
         $("#pagingList").on("click", "li", function () {
             var pageNo = $(this).data("pageno");
             var pageSize = $("#selectPageSize").val();

             getUserList(pageNo, pageSize, authRange);

         })

         $("#btnList").on("click", function () {
             location.reload();
         })

         //페이지 사이즈 변경
         $("#selectPageSize").change(function () {
             getUserList(1, $(this).val(), authRange);
         })

         $("#btnAdd").on("click", function () {
             $("#addUserModal").modal();

             });

             
         $('#userDtlModal').on('hidden.bs.modal', function (e) {
             $("#btnUpdate").attr("style", "float:right; display:none");
             $("#btnUpdUser").attr("style", "float:right; display:");
         })

         updUser();
         authHideBtn(authRange);
     });
     

    //사용자 목록
    function getUserList(pageNo, pageSize, authRange) {
        var reqParam = {};

        reqParam["strMethod"] = "UserList";
        reqParam["intPageNo"] = pageNo;
        reqParam["intPageSize"] = pageSize;

        reqParam["strSearchId"] = $("#searchId").val();
        reqParam["intSearchType"] = $("#searchType").val();

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
                if (data.intRetVal != 0) {
                    alert("실패");
                    return;
                }

                fnUserList(data, pageNo, pageSize, authRange);
            }
        })
    }

    //사용자 목록 html
    function fnUserList(data, pageNo, pageSize, authRange) {

        var html = "";
        html += "       <thead>";
        html += "       <tr>";
        html += "           <th class='text-center' width='10%;'>#</th>";
        html += "           <th class='text-center' width='20%;'>아이디</th>";
        html += "           <th class='text-center' width='20%;'>이름</th>";
        html += "           <th class='text-center' width='15%;'>가입일</th>";
        html += "           <th class='text-center' width='15%;'>상태</th>";
        html += "       </tr>";
        html += "       </thead>";
        html += "       <tbody>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr >";
            html += "           <td class='text-center'>" + data.objDT[i].ROWNUM + "</td>";

            html += "           <td class='text-center' onClick='userDetail(" + data.objDT[i].USERNO + ")' style='cursor:pointer;'>" + data.objDT[i].USERID;

            html += "           <td class='text-center'>" + data.objDT[i].NAME + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].STATUS + "</td>";

            html += "       </tr>";

        }

        html += "       </tbody>";

        $("#TUserList").html(html);

        fnPagingList(data, pageNo, pageSize);
    }

    //상세보기
    function userDetail(userNo) {
        $(".btnCash").show();
        $(".userDtl").attr("disabled", true);
        $("#userModalTitle").text("회원 상세보기");
         
        var reqParam = {};

        reqParam["strMethod"] = "UserDetail";
        reqParam["intUserNo"] = userNo;

        $("#userNoVal").val(userNo);

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
                if (data.intRetVal != 0) {
                    alert("실패");
                    return;
                }

                $("#UserIDDetail").val(data.objDT[0].USERID);
                $("#NameDetail").val(data.objDT[0].NAME);
                $("#BirthDetail").val(data.objDT[0].BIRTH);
                $("#SexDetail").val(data.objDT[0].SEX);
                $("#PhoneDetail").val(data.objDT[0].PHONE);

                $("#EmailDetail").val(data.objDT[0].EMAIL);
                $("#StatusDetail").val(data.objDT[0].STATUS);
                $("#PostcodeDetail").val(data.objDT[0].POSTCODE);
                $("#Address1Detail").val(data.objDT[0].ADDRESS1);
                $("#Address2Detail").val(data.objDT[0].ADDRESS2);

                $("#CashDetail").val(fnAddComma(data.objDT[0].TOTALCASH));

                $("#userDtlModal").modal();


            }
        })

        cashMng(userNo);

    }

    function updUser() {

        //수정 버튼 클릭 시 수정 모달로
        $("#btnUpdUser").on("click", function () {
            $(".btnCash").hide();
            $(".userDtl").attr("disabled", false);
            $("#userModalTitle").text("회원 정보 수정");
            $("#NameDetail").focus();

            $("#btnUpdUser").attr("style", "float:right; display:none");
            $("#btnUpdate").attr("style", "float:right; display:");

        });
     
        //정보 입력 후 수정버튼 클릭
        $("#btnUpdate").on("click", function () {
            var rePhone = /^[0-9]{10,11}$/;
            var reEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/;

            var reqParam = {};
            reqParam["strMethod"] = "UserUpd";
            reqParam["intUserNo"] = $("#userNoVal").val();

            reqParam["strName"] = $("#NameDetail").val();
            reqParam["strBirth"] = $("#BirthDetail").val();
            reqParam["strSex"] = $("#SexDetail").val();
            reqParam["strPhone"] = $("#PhoneDetail").val();
            reqParam["strEmail"] = $("#EmailDetail").val();
            reqParam["intStatus"] = $("#StatusDetail").val();

            if ($("#NameDetail").val() == "") {
                alert("이름을 입력하세요");
                return;
            }

            if ((/\s/g).test($("#NameDetail").val())) {
                alert("이름에 공백을 입력할 수 없습니다");
                return;
            }

            if ($("#BirthDetail").val() == "") {
                alert("생년월일을 입력하세요");
                return;
            }

            if (!rePhone.test($("#PhoneDetail").val()) || $("#PhoneDetail").val() == "") {
                alert("연락처 형식을 확인하세요");
                return;
            }

            if ($("#EmailDetail").val() != "" && !reEmail.test($("#EmailDetail").val())) {
                alert("이메일 형식을 확인하세요");
                return;
            }

            if (false == confirm("수정 하시겠습니까?")) {
                return;
            }

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
                    if (data.intRetVal != 0) {
                        alert("실패");
                        return;
                    }

                    alert("수정 되었습니다.");
                    location.reload();
                }
            })
        });
    }

    //아이디 중복확인
    function idCheck(){
        $("#userIdCheck").on("click", function () {
            var reqParam = {};

            reqParam["strMethod"] = "UserIdCheck";
            reqParam["strUserId"] = $("#UserID").val();

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
                    var reId = /^(?=.*[a-zA-Z])[a-zA-Z0-9].{5,20}$/;
                    var UserID = $("#UserID").val();

                    if (!reId.test(UserID) || UserID.match(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
                        alert("아이디 형식을 확인하세요");
                        return;
                    }

                    if (data.intCheckVal == 0) {
                        alert("사용할 수 있는 아이디 입니다.");
                        $("#idCheckVal").val(0);
                    } else {
                        alert("이미 존재하는 아이디 입니다.");
                    }

                }
            })
        })
    }

    //사용자 등록
    function addUser() {
        $("#btnAddUser").on("click", function () {
            var reqParam = {};

            //영문자, 숫자 포함 6-20자 (최소 1개 영문자 필수)
            var reId = /^(?=.*[a-zA-Z])[a-zA-Z0-9].{5,20}$/;
            //영문자, 숫자, 특수문자 포함 형태의 8~20자
            var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
            var rePhone = /^[0-9]{10,11}$/;
            var reEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/;

            var UserID = $("#UserID").val();
            var UserPw = $("#UserPw").val();
            var Name = $("#Name").val();
            var Birth = $("#Birth").val();
            var Sex = $("#Sex").val();
            var Phone = $("#Phone").val();
            var Email = $("#Email").val();


            if ($("#idCheckVal").val() != 0) {
                alert("아이디 중복확인 하세요");
                return;
            }

            if (!rePw.test(UserPw)) {
                alert("비밀번호 형식을 확인하세요");
                return;
            }

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

            if (!rePhone.test(Phone) || Phone == "") {
                alert("연락처 형식을 확인하세요");
                return;
            }

            if (Email != "" && !reEmail.test(Email)) {
                alert("이메일 형식을 확인하세요");
                return;
            }

            reqParam["strMethod"] = "UserIns";
            reqParam["strUserId"] = UserID;
            reqParam["strUserPw"] = UserPw;
            reqParam["strName"] = Name;
            reqParam["strBirth"] = Birth;
            reqParam["strSex"] = Sex;
            reqParam["strPhone"] = Phone;
            reqParam["strEmail"] = Email;
            reqParam["strPostcode"] = $("#postcode").val();
            reqParam["strAddress1"] = $("#address1").val();
            reqParam["strAddress2"] = $("#address2").val();

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
                    alert("등록 되었습니다.");

                    location.reload();
                }
            })
        });
    }

    //권한 버튼 제어
    function authHideBtn(authRange) {

        if (authRange == 'R') {

            //$(".btnUserW").attr('style', 'cursor:not-allowed');
            $(".btnUserW").attr('disabled', 'disabled');
        }

    }

     //실시간 유효성 검사
    function validCheck() {
        $("#UserID").on("keyup", function () {

            var reId = /^(?=.*[a-zA-Z])[a-zA-Z0-9].{5,20}$/;
            var UserID = $("#UserID").val();

            if (!reId.test(UserID) || UserID.match(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
                $("#idValidCheck").text("숫자와 최소 1개의 영문자 포함 6-20자");
                $("#idValidCheck").attr("style", "color:#00a0df;")
            } else {
                $("#idValidCheck").text("");
            }
        });

        $("#UserPw").on("keyup", function () {

            var rePw = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;;
            var UserPw = $("#UserPw").val();

            if (!rePw.test(UserPw)) {
                $("#pwValidCheck").text("영문자, 숫자, 특수문자(!@#$%^&+=) 각각 하나 이상 포함 최소 8자~최대 20자");
                $("#pwValidCheck").attr("style", "color:#00a0df;");
            } else {
                $("#pwValidCheck").text("");
            }
        });

        $("#UserPwCheck").on("keyup", function () {

            if ($("#UserPw").val() != $("#UserPwCheck").val()) {
                $("#pwCheckValidCheck").text("일치하지 않습니다");
                $("#pwCheckValidCheck").attr("style", "color:#00a0df;");
            } else {
                $("#pwCheckValidCheck").text("");
            }
        });
    }

    function cashMng(userNo) {
        $("#cashIns").on("click", function () {
            window.open('../UserMng/CashMng.aspx?type=1&userNo=' + userNo, 'newWindow1', 'width=500,height=350,location=no,status=no,scrollbars=yes');
            
        });

        $("#cashDel").on("click", function () {
            window.open('../UserMng/CashMng.aspx?type=2&userNo=' + userNo + '&balance=' + fnRmvComma($('#CashDetail').val()), 'newWindow1', 'width=500,height=350,location=no,status=no,scrollbars=yes');
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

                document.getElementById('postcode').value = data.zonecode;
                document.getElementById('address1').value = fullAddr;

                document.getElementById('address2').focus();
            }
        }).open();
    }

    function fnAfterCachMng(userNo) {
        userDetail(userNo);
    }

</script>
</asp:Content>

