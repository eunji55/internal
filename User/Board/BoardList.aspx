﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BoardList.aspx.cs" Inherits="Board_BoardList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="boardPage">
    <!-- header begin -->
    <header class="page-head">
        <div class="header-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">

                        <ol class="breadcrumb">
                            <li><a href="../Membership/Home.aspx">홈</a></li>
                            <li class="active">게시판</li>
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
          <div class="col-lg-12">
            <div class="row">
                <!-- 게시글 검색 -->
                <div class="col-md-2">
                    <select id="searchDiv" class="form-control">
                        <option value="searchAll">전체</option>
                        <option value="searchTitle">제목</option>
                        <option value="searchId">작성자</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <input type="text" class="form-control" id="searchWord" />
                </div>
                <div class="col-md-5">
                    <input type="button" class="btn btn-primary" id="btnSearch" value="검색" />
                </div>

                <!-- //게시글 검색 -->

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
                <!-- 게시글 목록 -->
                <div id="boardList">
                    <table class="table table-striped table-hover" id="TboardList" style="font-size:17px;">
                    </table>
                </div>
                <!-- //게시글 목록 --> 
            </section>

            <!-- 글쓰기 버튼 -->
            <div style="text-align:right;">
                <input type="button" id="btnWrite" class="btn btn-primary" value="글쓰기" />
            </div>
            <!-- // 글쓰기 버튼 -->

            <!--페이징-->
            <div class="row content-row-pagination" style="text-align:center;">
                <div class="col-md-12">
                    <ul class="pagination" id="pagingList">
                    </ul>
                </div>
            </div>
            <!--// 페이징-->
              </div>
        </div>
    </div>
</div>   
    <script type="text/javascript">
        $(document).ready(function () {

            getBoardList(1, 10);

            //검색 버튼 클릭
            $("#btnSearch").on("click", function () {
                var pageSize = $("#selectPageSize").val();

                getBoardList(1,pageSize);
            })

            //페이징 버튼 클릭
            $("#pagingList").on("click","li", function () {
                var pageNo = $(this).data("pageno");
                var pageSize = $("#selectPageSize").val();

                getBoardList(pageNo, pageSize);

            })

            //페이지 사이즈 변경
            $("#selectPageSize").change(function () {
                getBoardList(1, $(this).val());
            })

            //글쓰기 버튼
            $("#btnWrite").on("click", function () {
                location.href = "../Board/BoardWrite.aspx?categoryNo=" + $("#ContentPlaceHolder1_categoryNo").val();
            })

        });

        //게시글 목록
        function getBoardList(pageNo,pageSize) {
            var reqParam = {};

            //검색 구분
            if ($("#searchDiv").val() == "searchTitle") {

                reqParam["intSearchType"] = 2;
                var title = $("#searchWord").val();
                reqParam["strSearchWord"] = title;

            } else if ($("#searchDiv").val() == "searchId") {

                reqParam["intSearchType"] = 1;
                var userId = $("#searchWord").val();
                reqParam["strSearchWord"] = userId;

            } else if ($("#searchDiv").val() == "searchAll") {

                reqParam["intSearchType"] = 3;
                reqParam["strSearchWord"] = $("#searchWord").val();

            }

            reqParam["strMethod"] = "BoardList";
            reqParam["intPageNo"] = pageNo;
            reqParam["intPageSize"] = pageSize;
            reqParam["intCategoryNo"] = $("#ContentPlaceHolder1_categoryNo").val();

            console.log(reqParam);

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
                    console.log(data);
                    if (data.intRetVal != 0) {
                        alert("실패");
                        return;
                    }

                    fnBoardList(data, pageNo, pageSize);
                }
            })
        }

        //게시글 목록 html
        function fnBoardList(data, pageNo, pageSize) {

            var html = "";
            html += "       <thead>";
            html += "       <tr>";
            html += "           <th class='text-center' width='5%;'>#</th>";
            html += "           <th class='text-center'>제목</th>";
            html += "           <th class='text-center' width='10%;'>작성자</th>";
            html += "           <th class='text-center' width='10%;'>등록일</th>";
            html += "           <th class='text-center'>조회수</th>";
            html += "       </tr>";
            html += "       </thead>";
            html += "       <tbody>";

            for (var i = 0; i < data.objDT.length; i++) {
            
                html += "       <tr >";
                html += "           <td class='text-center'>" + ((data.intRecordCnt + 1) - data.objDT[i].ROWNUM) + "</td>";

                if (data.objDT[i].NOTICEYN == 'Y') {
                    html += "           <td onClick='boardDetail(" + data.objDT[i].BOARDNO + ")' style='cursor:pointer;'>" + "<span class='label label-warning'>공지</span> " + data.objDT[i].TITLE;
                } else {
                    html += "           <td onClick='boardDetail(" + data.objDT[i].BOARDNO + ")' style='cursor:pointer;'>" + data.objDT[i].TITLE;
                }

                if (data.objDT[i].NEWFLAG == 'Y') {
                    html += "           <span class='badge' style='background-color:#00A0DF'>New</span>";
                }

                if (data.objDT[i].COMMENTCNT != 0) {
                    html += "           <span> ["+ data.objDT[i].COMMENTCNT +"] </span>";
                }
                
                html += "           </td>";
                html += "           <td>"

                if (data.objDT[i].USERID != '<%= Session["userId"] %>') {
                    html += "<li class='dropdown'>                                           ";
                    html += "	<a data-toggle='dropdown' class='dropdown-toggle' href='#' style='color:#525252;margin-left:-7%;'>  ";
                    html += "					<span style='margin-left:6%;'>"+ data.objDT[i].USERID +"</span>         ";
                    html += "				</a>                                             ";
                    html += "	<ul class='dropdown-menu extended' style='width:30px !important;'>                                   ";
                    html += "	  <li>                                   ";
                 
                    html += "	 <a href='#' class='msgWrite' data-value='" + data.objDT[i].USERID + "' style='font-size:16px;'>쪽지보내기</a>   ";

                }else {
                    html += "					<span>" + data.objDT[i].USERID + "</span>         ";
                }

                html += "	  </li>                                                      ";
                html += "	</ul>                                                        ";
                html += "</li>                                                           ";

                html += "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].REGDATEVIEW + "</td>";
                html += "           <td class='text-center'>" + data.objDT[i].READCNT + "</td>";

                html += "       </tr>";

            }

            html += "       </tbody>";

            $("#TboardList").html(html);

            fnPagingList(data, pageNo, pageSize);


            msgWrite_click();
        }

        //게시글 상세보기
        function boardDetail(boardNo) {

            location.href = "/Board/BoardDetail.aspx?boardNo=" + boardNo + "&categoryNo=" + $("#ContentPlaceHolder1_categoryNo").val();

        }

        

        function msgWrite_click() {

            $(".msgWrite").on("click", function () {
                window.open('../Membership/MsgWrite.aspx?receiver=' + $(this).data("value"), 'window_name', 'width=500,height=350,location=no,status=no,scrollbars=yes');
            });
        }


</script>

</asp:Content>

