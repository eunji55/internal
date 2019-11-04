<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MsgBox.aspx.cs" Inherits="Membership_MsgBox" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
        <!-- Bootstrap CSS -->
        <link href="../css/bootstrap.min.css" rel="stylesheet">
        <!-- bootstrap theme -->
        <link href="../css/bootstrap-theme.css" rel="stylesheet">
        <link href="../css/font-awesome.css" rel="stylesheet">
        <link href="../css/msg.css" rel="stylesheet">
        <link href="../css/elegant-icons-style.css" rel="stylesheet">
</head>
<body>
    <form id="form1" runat="server">


    <div class="container bootstrap snippet">

    <div class="row">
		<div class="col-md-4 bg-white ">
            <div class="row border-bottom padding-sm" style="height: 40px; margin-left:0px; margin-right:0px;">
            	<div>
                    <span style="font-size: 25px;"><i class="icon_mail_alt"></i>  쪽지함</span>
                    <select id="inoutType" class="form-control" style="width:30%;float: right;">
                        <option value="2">받은 쪽지</option>
                        <option value="1">보낸 쪽지</option>
                    </select>
                </div> <hr />

                <!-- 받은 쪽지 -->
                <div  id="msgList">
                <ul class="friend-list">
                   
                </ul> 

                    <!--페이징-->
                    <div class="row content-row-pagination" style="text-align:center;">
                        <div class="col-md-12">
                            <ul class="pagination" id="pagingList">
                            </ul>
                        </div>
                    </div>
                    <!--// 페이징-->
                </div>
                <!-- //받은 쪽지 -->

                <!-- 쪽지 내용 -->
                <div class="row" id="msgDetail" style="display:none;">
                    <div class="col-md-4 bg-white ">
                        <input type="hidden" id="msgNo" />
                        <table class="table">
                            <tbody>
                                <tr>
                                    <td colspan="1" rowspan="2">
                                        <input type="text" id="titleDetail" class="form-control" name="titleDetail" runat="server" 
                                            style='height:auto; cursor:text; font-weight:700; font-size:large; background-color:white; color:#525252; border:none;' disabled="disabled" />
                           
                                        <input type="text" id="userIdDetail" class="" name="userIdDetail" runat="server" 
                                            style='cursor:text; color:#b64c4c; background-color:white; border:none; margin-left:2%; margin-top:0.7%; width:10% ;border:none;' disabled="disabled"/>
                        
                                        <input type="text" id="regDateDetail" class="" name="regDateDetail" runat="server" 
                                            style='cursor:text; background-color:white; border:none; width:30%; text-align:left;' disabled="disabled"/>

                                    </td>    
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                <td colspan="2">
                                    <div class="detail">
                                        <textarea id="contentDetail" class="form-control" name="contentDetail" runat="server" style='cursor:text; color:#525252; background-color:white; height:200px; font-size:large; border:none; resize:none;' disabled="disabled" />
                                    </div>
                                </td>
                                </tr>
                            </tbody>
                        </table>

                        <hr style="border:0; height:1px; background: #ccc;"/>
                        <div style="text-align:right;" id="btnMsg">
                            
                            <input type="button" class="btn btn-info" id="btnReply" onclick="msgReply()" value="답장" />
                            <input type="button" class="btn btn-primary" id="backToList" value="목록" />
                            <input type="button" class="btn btn-danger" onclick="btnDelete_click()" value="삭제" />
                        </div>
                    </div>
                </div>
                <!-- //쪽지 내용 -->
            </div>
        </div>
    </div>
</div>



    </form>


<!-- javascripts -->
  <script src="../js/jquery.js"></script>
  <script src="../js/jquery-ui-1.10.4.min.js"></script>
  <script src="../js/jquery-1.8.3.min.js"></script>
  <!-- bootstrap -->
  <script src="../js/bootstrap.min.js"></script>
  <!-- nice scroll -->
  <script src="../js/jquery.scrollTo.min.js"></script>
  <script src="../js/jquery.nicescroll.js" type="text/javascript"></script>
  <!-- jquery validate js -->
  <script type="text/javascript" src="js/jquery.validate.min.js"></script>
  <script type="text/javascript">
      $(document).ready(function () {
         window.document.body.style.background = "white";
          getMsgList(1, 5, $("#inoutType").val());

        //페이징 버튼 클릭
        $("#pagingList").on("click", "li", function () {
            var pageNo = $(this).data("pageno");
            var pageSize = 5;

            getMsgList(pageNo, pageSize, 2);

        })

          //페이징 버튼 클릭
        $("#inoutType").change(function () {

            var pageNo = 1;
            var pageSize = 5;
            var inoutType = $(this).val();

            getMsgList(pageNo, pageSize, inoutType);

        })


    })

    //쪽지 목록
      function getMsgList(pageNo, pageSize, inoutType) {
        var reqParam = {};

        reqParam["strMethod"] = "MsgList";

        if ($("#inoutType").val() == '2' ){
            reqParam["intInOutType"] = 2; //받은 쪽지
        } else if ($("#inoutType").val() == '1') {
            reqParam["intInOutType"] = 1; //보낸 쪽지
        }

        reqParam["strUserId"] = "<%= Session["userId"] %>";
        reqParam["intPageNo"] = pageNo;
        reqParam["intPageSize"] = pageSize;

        console.log(reqParam);

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
                console.log(data.intRecordCnt);
                if (data.intRetVal != 0) {
                    alert("실패");
                    return;
                }

                fnMsgList(data, pageNo, pageSize);

                $("#totalCnt").val(data.intRecordCnt);
            }
        })
    }

    
      //쪽지 목록 html
    function fnMsgList(data, pageNo, pageSize) {

        var html = "";
        for (var i = 0; i < data.objDT.length; i++) {
                html += "<li>                                          ";
                html += "	<a href='#' class='clearfix' onClick='msgDetail(" + data.objDT[i].MSGNO + ")'>                                          ";
                html += "		<div class='friend-name' style='font-size:15px;'>	                                       ";
                html += "			<strong>" + data.objDT[i].TITLE + "</strong>                                      ";
                html += "		</div>                                                             ";

                if (data.objDT[i].SENDER != '<%= Session["userId"] %>'){
                    html += "		<div class='last-message' style='color:#b64c4c;'>보낸사람: " + data.objDT[i].SENDER + "</div>   ";
                } else {
                    html += "		<div class='last-message' style='color:#b64c4c;'>받는사람: " + data.objDT[i].RECEIVER + "</div>   ";
                }

                html += "		<small class='time' style='color:grey; font-size:13px;'>" + data.objDT[i].DATE_SENT + "</small>                    ";

                if (data.objDT[i].SENDER != '<%= Session["userId"] %>' && data.objDT[i].RECV_READ == 'N') {
                    html += "		<small class='chat-alert label label-danger'>읽지않음</small>             ";
                }

                html += "	</a>                                                                   ";
                html += "</li>                                                                     ";
           
        }

        $(".friend-list").html(html);

        fnPagingList(data, pageNo, pageSize);

    }

    //페이징
    function fnPagingList(data, pageNo, pageSize) {

        var pagingHtml = "";
        pagingHtml += "        <li class='paging' data-pageno='1'><a href='#'><<</a></li>    ";

        var maxPageNo = parseInt((data.intRecordCnt - 1) / pageSize) + 1;

        for (var i = 1; i <= maxPageNo ; i++) {

            if (pageNo == i) {
                pagingHtml += "        <li class='paging active' data-pageno='" + i + "'><a href='#'>" + i + "</a></li>              ";
            }
            else {
                pagingHtml += "        <li class='paging' data-pageno='" + i + "'><a href='#'>" + i + "</a></li>              ";
            }

        }

        pagingHtml += "        <li class='paging' data-pageno='" + maxPageNo + "'><a href='#'>>></a></li>                           ";

        $("#pagingList").html(pagingHtml);


    }

    //쪽지 상세보기
    function msgDetail(msgNo) {
         var reqParam = {};
           
        reqParam["strMethod"] = "MsgDetail";
        reqParam["intMsgNo"] = msgNo;

        console.log(reqParam);

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

                $("#titleDetail").val(data.objDT[0].TITLE);
                $("#userIdDetail").val(data.objDT[0].SENDER);
                $("#regDateDetail").val(data.objDT[0].DATE_SENT);
                $("#contentDetail").val(data.objDT[0].CONTENT);
                $("#msgNo").val(data.objDT[0].MSGNO);

                $("#msgList").hide();
                $("#msgDetail").show();

                if ($("#inoutType").val() == '1') {
                    $("#btnReply").hide();
                }

                $("#backToList").on("click", function () {
                    location.reload();
                })

            }
        })
    }

    //쪽지 삭제
    function btnDelete_click() {
            reqParam = {};

            reqParam["strMethod"] = "MsgDel";
            reqParam["intInOutType"] = $("#inoutType").val();
            reqParam["intMsgNo"] = $("#msgNo").val();

            console.log(reqParam);
            if (false == confirm("삭제 하시겠습니까?")) {
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

                    getMsgList(1, 5);

                    $("#msgDetail").hide();
                    $("#msgList").show();

                }
            })
    }

    //답장하기
    function msgReply() {

        window.open('../Membership/MsgWrite.aspx?receiver=' + $("#userIdDetail").val() , 'newWindow', 'width=500,height=350,location=no,status=no,scrollbars=yes');
        
    }
    
</script>
</body>
</html>
