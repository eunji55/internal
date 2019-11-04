<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MsgWrite.aspx.cs" Inherits="Membership_MsgWrite" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    
  <!-- Bootstrap CSS -->
  <link href="../css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="../css/bootstrap-theme.css" rel="stylesheet">
  <!-- font icon -->
  <link href="../css/elegant-icons-style.css" rel="stylesheet" />
  <link href="../css/font-awesome.min.css" rel="stylesheet" />
</head>
<body>
    <div class="col-sm-4" style="padding-top: 15px;"> 
        <input type="hidden" id="receiver" runat="server" />

        <form id="form2" class="form-horizontal" runat="server">

    <div class="row">
        
        <div class="col-md-4 bg-white ">
             <h4><i class="icon_mail_alt"></i> 쪽지 보내기</h4>
            <input type="hidden" id="msgNo" />
            <table class="table">
                <tbody>
                    <tr>
                        <td colspan="1" rowspan="2">
                            <input type="text"  class="form-control" id="title" name="title" placeholder="제목을 입력하세요" />

                        </td>    
                    </tr>
                    <tr>
                    </tr>
                    <tr>
                    <td colspan="2">
                        <div class="detail">
                           <textarea class="form-control" id="content" name="content" placeholder="내용을 입력하세요" rows="5" style="resize:none;"></textarea>
                        </div>
                    </td>
                    </tr>
                </tbody>
            </table>

            <hr style="border:0; height:1px; background: #ccc;"/>
            <div style="text-align:right;">
                <input type="button" id="sendMsg" class="btn btn-info" value="보내기" />
            </div>
        </div>
    </div>


        </form>
    </div>


<!-- javascripts -->
  <script src="../js/jquery.js"></script>
  <script src="../js/jquery-ui-1.10.4.min.js"></script>
  <script src="../js/jquery-1.8.3.min.js"></script>
  <!-- bootstrap -->
  <script src="../js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {

        $("#sendMsg").on("click", function () {
            var reqParam = {};
           
            reqParam["strMethod"] = "MsgSend";
            reqParam["strSender"] = "<%= Session["userId"] %>";
            reqParam["strReceiver"] = $("#receiver").val();
            reqParam["strTitle"] = $("#title").val();
            reqParam["strContent"] = $("#content").val();

            console.log(reqParam);

            if ($("#title").val() == "") {
                alert("제목을 입력하세요");
                return;
            }

            if ($("#content").val() == "") {
                alert("내용을 입력하세요");
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
                    console.log(data)

                    alert("전송 되었습니다.");
                    window.close();
                }
            })
        });

    })

</script>

</body>
</html>

