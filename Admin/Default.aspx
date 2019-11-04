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
          <input type="text" class="form-control" placeholder="Username"  id="logInAdminId" autofocus>
        </div>
        <div class="input-group">
          <span class="input-group-addon"><i class="icon_key_alt"></i></span>
          <input type="password" class="form-control" id="logInAdminPw" placeholder="Password">
        </div>
        <input type="button" class="btn btn-primary btn-lg btn-block" id="logInBtn" value="로그인"/>
      </div>
    </form>
  </div>
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


<script type="text/javascript">
    $(document).ready(function () {


        $("#logInBtn").on("click", function () {
            logIn();
        });

        $("#logInAdminPw").keypress(function (key) {
            if (key.which == 13) {
                logIn();
            }
        });
    });

        function logIn() {
            var reqParam = {};
            reqParam["strMethod"] = "LogIn";
            reqParam["strAdminId"] = $("#logInAdminId").val();
            reqParam["strAdminPw"] = $("#logInAdminPw").val();

            console.log(reqParam);

            $.ajax({
                type: "POST",
                url: "/AdminMng/AdminHandler.ashx",
                data: JSON.stringify(reqParam),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (result) {

                    console.log(result);

                    if (result.intCheckVal == 0) {

                        alert("환영합니다");
                        location.href = "../Home.aspx";
                    } else {
                        alert("아이디와 비밀번호가 일치하지 않습니다.");
                    }

                }
            });
        }

        
    </script>


</html>
