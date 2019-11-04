<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BoardDetail.aspx.cs" Inherits="Board_BoardDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <style>
        .numberCircle {
    width: 40px;
    border-radius: 50%;
    text-align: center;
    font-size: 25px;
    border: 2px solid #00B9AD;
    background-color: #00B9AD;
    color : white;
    text-align:center;
    }

    </style>
<div id="boardPage">
    <!-- header begin -->
    <header class="page-head">
        <div class="header-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">

                        <ol class="breadcrumb">
                            <li><a href="../Membership/Home.aspx">홈</a></li>
                            <li class="active">게시글</li>
                        </ol> <!-- end of /.breadcrumb -->

                    </div>
                </div>
            </div> <!-- /.container -->
        </div> <!-- /.header-wrapper -->
    </header> <!-- /.page-head (header end) -->

    <br /><br />
     <input type="hidden" id="categoryNo" runat="server" />
    <div class="main-content">
      <div class="container">
        <div class="col-lg-offset-1 col-lg-10">
        <div class="row">
          <div class="col-lg-12">
            <section class="panel">
                
              <div class="panel-body">
            <input type="hidden" id="userNoDetail" runat="server" />

             <table class="table">
                <tbody>
                    <tr>
                        <td colspan="1" rowspan="2">
                            <input type="text" id="titleDetail" class="form-control" name="titleDetail" runat="server" 
                                style='height:auto; cursor:text; font-weight:700; font-size:xx-large; background-color:white; color:#525252; border:none;' disabled >
                           
                            <input type="text" id="userIdDetail" class="" name="userIdDetail" runat="server" 
                                style='cursor:text; color:#b64c4c; background-color:white; border:none; margin-left:1%; margin-top:0.7%; width:7% ;border:none;' disabled>
                        
                            <input type="text" id="regDateDetail" class="" name="regDateDetail" runat="server" 
                                style='cursor:text; background-color:white; border:none; width:20%; text-align:left;' disabled>

                        </td>    
                    </tr>
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                    <td colspan="2">
                        <div class="detail">
                            <textarea id="contentDetail" class="form-control" name="contentDetail" runat="server" style='cursor:text; color:#525252; background-color:white; height:400px; font-size:large; border:none; resize:none;' disabled />
                        </div>
                    </td>
                    </tr>
                </tbody>
            </table>
            <hr style="border:0; height:1px; background: #ccc;"/>
            <!-- 글쓴이일 경우 글수정삭제 버튼 활성화 -->
            <% if (Session["userNo"].ToString().Equals(userNoDetail.Value) && Session["userId"].ToString().Equals(userIdDetail.Value)) { %> 
                <div style="text-align:right;">
                   <input type="button" class="btn btn-primary" id="btnUpdate" value="수정">
                   <button class="btn btn-danger" id="btnDelete">삭제</button>   
                </div>
            <% }%>

            <br /><br />

            <!-- 댓글 -->
            <div class="comments">
                <div class="row">
                    <div class="col-md-12">
	                    <h3>댓글</h3>
                        <hr />

	                    <div id="commentList" style="font-size:14px;">
	  

	                    </div>
                    </div>
                    <div class="col-md-12">
                        <textarea rows="3" class="form-control" id="commentContent" maxlength="256"></textarea>
                        <br />
                        <div style="text-align:right;" >
                            <input type="button" class="btn btn-primary" id="addComment" value="댓글등록" />
                        </div>
                    </div>
                </div>
            </div>
            <!--//댓글-->
            </div>
            </section>
          </div>
        </div>
        </div>
    </div> 
</div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        
        var boardNo = "<%= boardNo %>";
        getCommentList(boardNo);

        //글 수정
        $("#btnUpdate").on("click", function () {
            var boardNo = "<%= boardNo %>";

            window.location.href = "/Board/BoardUpd.aspx?boardNo=" + boardNo+"&categoryNo=" + $("#ContentPlaceHolder1_categoryNo").val();
        });

        //글 삭제
        $("#btnDelete").on("click", function () {
            var boardNo = "<%= boardNo %>";

            var reqParam = {};
            reqParam["strMethod"] = "BoardDel";
            reqParam["intBoardNo"] = boardNo;

            console.log(reqParam);

            if (false == confirm("삭제 하시겠습니까?"))
                return;

            location.href = "/Board/BoardList.aspx";

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/Board/BoardHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("일시적 통신 오류");
                },
                success: function (data) {
                    console.log(data)
                    if (data.intRetVal != 0) {
                        alert("실패");
                        return;
                    }

                    alert("글이 삭제되었습니다.");

                    location.href = "/Board/BoardList.aspx?categoryNo=" + $("#ContentPlaceHolder1_categoryNo").val();
                }
            })
        });

        //댓글등록
        $("#addComment").on("click", function () {
            var reqParam = {};
            
            if($("#commentContent").val() == ""){
                alert("댓글내용을 입력하세요");
                return;
            }

            reqParam["strMethod"] = "CommentIns";
            reqParam["intBoardNo"] = boardNo;
            reqParam["intUserNo"] = <%= Session["userNo"] %>;
            reqParam["strContent"] = $("#commentContent").val();

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/Board/CommentHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("일시적 통신 오류");
                },
                success: function (data) {
                    console.log(data);
                    alert("댓글이 등록되었습니다.");

                    location.reload();
                }
            })
        });


    });

    //댓글 목록
    function getCommentList(boardNo) {
        var reqParam = {};

        reqParam["strMethod"] = "CommentList";
        reqParam["intBoardNo"] = boardNo;

        console.log(reqParam);

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/Board/CommentHandler.ashx",
            dataType: "JSON",
            contentType: "application/json; charset=utf-8",
            error: function (request, status, error) {
                alert("일시적 통신 오류");
            },
            success: function (data) {
                console.log(data);
                fnCommentList(data);
            }
        })
    }

    //댓글 목록 html
    function fnCommentList(data) {

        var html = "";
        
        for (var i = 0; i < data.objDT.length; i++) {


			html += "<div class='well'>                                                                                                 ";
			html += "	<div class='row'>                                                                                               ";
			html += "		<div class='col-md-1'>                                                                                      ";
			html += "			<a class='img-responsive center-block' alt='first-comment'><div class='numberCircle'>"+ ((data.objDT[i].USERID).substring(0,1)).toUpperCase() +"</div></a>";
			html += "		</div>                                                                                                      ";
			html += "		<div class='col-md-10'>                                                                                     ";
			html += "			<p class='comment-info'>                                                                                ";
			html += "				<strong>" + data.objDT[i].USERID + "</strong> <span>" + data.objDT[i].REGDATE + "</span>            ";
			html += "			</p>                                                                                                    ";
			html += "			<p class='cContentAll' id='cContent"+ data.objDT[i].COMMENTNO +"'> " + data.objDT[i].CONTENT + " </p>   ";
							
						
						
						
			html += "	  <div class='beforeUpd' id='beforeUpd"+data.objDT[i].COMMENTNO+"' style='text-align:right;'>                      ";

            //댓글쓴이일 경우 수정삭제버튼 활성화
            if( (data.objDT[i].USERNO) == "<%=Session["UserNo"]%>" ){
                html += "        <input type='button' class='btn btn-sm btn-default' onclick='commentUpd_click("+ data.objDT[i].COMMENTNO +")' value='수정' />   ";
	            html += "		 <input type='button' class='btn btn-sm btn-default' onclick='commentDel_click(" + data.objDT[i].COMMENTNO + ")' value='삭제' />    ";
            }
            html += "	  </div>                      ";
			
			
            html += "<div class='forUpd' id='forUpd"+ data.objDT[i].COMMENTNO +"' style='text-align:right;'>";
            html += "	  </div>                                        ";
			
						
						
						
			html += "		</div>  ";
			html += "	</div>      ";
			html += "</div>         ";
			
			
			//if 부모no 가 data.objDT[i].COMMENTNO 면 여기 달기 .
            if( data.objDT[i].PCOMMENTNO == data.objDT[i].COMMENTNO ){
                
                html += " 	<p class='cContentAll' id='cContent"+ data.objDT[i].COMMENTNO +"'> " + data.objDT[i].CONTENT + " </p>";
            }
            

        }

        $("#commentList").html(html);
    }
    
    
    //댓글 수정 클릭 시 textarea에 값 넘겨주고 focus
    function commentUpd_click(commentNo) {
        $(".cContentAll").show();

        //기존 바뀌었었던 버튼,textarea 원상복구
        $(".updBtn").hide();
        $(".beforeUpd").show();
        $(".contentAll").remove();

        var cId = "cContent"+commentNo;
        $("#"+cId).hide();

        var html = "";

        //댓글내용 textarea에 띄워주고 수정버튼 생성
        html += "<textarea rows='3' class='form-control contentAll' id='commentContent' maxlength='256'>"+document.getElementById(cId).innerHTML+"</textarea>";
        html += "      <input type='button' class='btn btn-sm btn-default updBtn' onClick='commentUpd("+ commentNo +")' value='수정' />   ";
        $("#forUpd"+commentNo).html(html);

        $("#beforeUpd"+commentNo).hide(); //원래 수정삭제버튼 숨기기
    }

    //댓글 수정 - 수정
    function commentUpd(commentNo){
        var reqParam = {};
        
        if($("#commentContent").val() == ""){
            alert("댓글내용을 입력하세요");
            return;
        }

        reqParam["strMethod"] = "CommentUpd";
        reqParam["intCommentNo"] = commentNo;
        reqParam["strContent"] = $("#commentContent").val();

        console.log(reqParam);

        if (false == confirm("수정 하시겠습니까?")){
            location.reload();
            return;
        }

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/Board/CommentHandler.ashx",
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
    }

    //댓글 삭제
    function commentDel_click(commentNo) {

        var reqParam = {};

        reqParam["strMethod"] = "CommentDel";
        reqParam["intCommentNo"] = commentNo;

        if (false == confirm("삭제 하시겠습니까?"))
            return;

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/Board/CommentHandler.ashx",
            dataType: "JSON",
            contentType: "application/json; charset=utf-8",
            error: function (request, status, error) {
                alert("일시적 통신 오류");
            },
            success: function (data) {
                console.log(data);
                
                alert("삭제되었습니다.");

                location.reload();
            }
        })
    }


</script>
</asp:Content>

