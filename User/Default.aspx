<%@ Page Title="Home Page" Language="C#"  AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <title></title>
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
      <link rel="shortcut icon" href="img/favicon.png">

  <!-- Bootstrap CSS -->
  <link href="../css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="../css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="../css/elegant-icons-style.css" rel="stylesheet" />
  <link href="../css/font-awesome.css" rel="stylesheet" />
  <!-- Custom styles -->
  <link href="../css/style.css" rel="stylesheet">
  <link href="../css/style-responsive.css" rel="stylesheet" />

</head>

<body class="login-img3-body">

  <div class="container">

    <form class="login-form">
      <div class="login-wrap">
        <p class="login-img"><i class="icon_lock_alt"></i></p>
        <div class="input-group">
          <span class="input-group-addon"><i class="icon_profile"></i></span>
          <input type="text" class="form-control" placeholder="Username"  id="logInUserId" autofocus>
        </div>
        <div class="input-group">
          <span class="input-group-addon"><i class="icon_key_alt"></i></span>
          <input type="password" class="form-control" id="logInUserPw" placeholder="Password">
        </div>
        <input type="button" class="btn btn-primary btn-lg btn-block" id="logInBtn" value="로그인"/>
        <input type="button" class="btn btn-info btn-lg btn-block" id="registerBtn" value="회원가입"/>
      </div>
    </form>
  </div>

    <form class="form-validate form-horizontal " id="registerForm">
    <!-- 회원가입 모달 -->
    <div  role="dialog" id="registerModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                <h4 class="modal-title">회원가입</h4>
                </div>
                <div class="modal-body">
                    <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                    <div class="form form-horizontal">
                        <input type="hidden" id="idCheckVal" value="1"/>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="UserID">아이디<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text"  class="form-control" id="UserID" name="UserID" maxlength="20" required/>
                                <p class="help-block" id ="idValidCheck"></p>
                            </div>
                            <input type="button" class="btn btn-primary" id="userIdCheck" value="중복확인" />
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="UserPw">비밀번호<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="password" class="form-control" id="UserPw" name="UserPw" maxlength="20" required/>
                                <p class="help-block" id ="pwValidCheck"></p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="UserPwCheck">비밀번호 확인<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="password" class="form-control" id="UserPwCheck" name="UserPwCheck" maxlength="20" required/>
                                <p class="help-block" id ="pwCheckValidCheck"></p>
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
                                <input type="text" class="form-control" id="postcode" placeholder="우편번호">
                                <input type="button" class="btn btn-primary" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
                                <input type="text" class="form-control" id="address1" placeholder="주소">
                                <input type="text" class="form-control" id="address2" placeholder="상세주소">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-offset-2 col-md-10 btn-group">
                                <input type="button" class="btn btn-primary"  style="float:right;" id="btnRegister" value="가입" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
        </form>
</body>
    <!-- javascripts -->
  <script src="../js/jquery.js"></script>
  <script src="../js/jquery-ui-1.10.4.min.js"></script>
  <script src="../js/jquery-1.8.3.min.js"></script>
  <!-- bootstrap -->
  <script src="../js/bootstrap.min.js"></script>
  <!-- nice scroll -->
  <script src="../js/jquery.scrollTo.min.js"></script>
  <script src="../js/jquery.nicescroll.js" type="text/javascript"></script>
  <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>


<script type="text/javascript">
    $(document).ready(function () {

        idCheck();
        register();

        validCheck();

        $("#UserID").on("keyup", function () {
            $("#idCheckVal").val("1");
        });

        $('#registerModal').on('hidden.bs.modal', function (e) {
            console.log('modal close');
            $("#registerForm")[0].reset();
        });

        //회원가입 모달
        $("#registerBtn").on("click", function () {
            $("#registerModal").modal();
        });

        $("#logInBtn").on("click", function () {
            logIn();
        });

        $("#logInUserPw").keypress(function (key) {
            if (key.which == 13) {
                logIn();
            }
        });
    });

        //로그인
    function logIn() {
        var reqParam = {};
        reqParam["strMethod"] = "LogIn";
        reqParam["strUserId"] = $("#logInUserId").val();
        reqParam["strUserPw"] = $("#logInUserPw").val();

        console.log(reqParam);

        $.ajax({
            type: "POST",
            url: "/Membership/MembershipHandler.ashx",
            data: JSON.stringify(reqParam),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            error: function (request, status, error) {
                alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            },
            success: function (result) {

                console.log(result);

                if (result.intStatus == 2) {
                    alert("비활성화된 계정입니다.");
                    return;
                }

                if (result.intCheckVal == 0) {

                    alert("환영합니다");
                    location.href = "../Membership/Home.aspx";
                }
                else {
                    alert("아이디와 비밀번호가 일치하지 않습니다.");
                }

            }
        });
    }

        //아이디 중복확인
    function idCheck() {
        $("#userIdCheck").on("click", function () {
            var reqParam = {};

            reqParam["strMethod"] = "UserIdCheck";
            reqParam["strUserId"] = $("#UserID").val();

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/Membership/MembershipHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                       
                    if (data.intCheckVal == 0) {
                        var reId = /^(?=.*[a-zA-Z])[a-zA-Z0-9].{5,20}$/;
                        var UserID = $("#UserID").val();

                        if (!reId.test(UserID) || UserID.match(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
                            alert("아이디 형식을 확인하세요");
                            return;
                        }

                        alert("사용할 수 있는 아이디 입니다.");
                        $("#idCheckVal").val(0);
                    } else {
                        alert("이미 존재하는 아이디 입니다.");
                    }

                }
            })

        });
    }

        //회원가입
    function register() {
        $("#btnRegister").on("click", function () {
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

            if (!reId.test(UserID) || UserID.match(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*")) {
                alert("아이디 형식을 확인하세요");
                return;
            }

            if ($("#idCheckVal").val() != 0) {
                alert("아이디 중복확인 하세요");
                return;
            }

            if (!rePw.test(UserPw)) {
                alert("비밀번호 형식을 확인하세요");
                return;
            }

            if (UserPw != $("#UserPwCheck").val()) {
                alert("비밀번호 확인 다시 입력하세요");
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

            if (!rePhone.test(Phone) || Phone=="") {
                alert("연락처 형식을 확인하세요");
                return;
            }

            if (Email != "" && !reEmail.test(Email)) {
                alert("이메일 형식을 확인하세요");
                return;
            }

            reqParam["strMethod"] = "Register";
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
                url: "/Membership/MembershipHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    console.log(data);
                    alert("회원가입 되었습니다.");

                    location.reload();
                }
            })
        });
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
</script>


</html>
