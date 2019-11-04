<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BoardList.aspx.cs" Inherits="Board_BoardList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <section id="main-content">
      <section class="wrapper">
            <div class="row">

                <br /><br /><br /><br />
                <input type="hidden" id="categoryNo" runat="server" />
                
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
        </section>
    </section>
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

                if(data.objDT[i].NOTICEYN == 'Y'){
                    html += "           <td onClick='boardDetail(" + data.objDT[i].BOARDNO + ")' style='cursor:pointer;'>" + "<span class='label label-warning'>공지</span> " + data.objDT[i].TITLE;
                } else {
                    html += "           <td onClick='boardDetail(" + data.objDT[i].BOARDNO + ")' style='cursor:pointer;'>" + data.objDT[i].TITLE;
                }

                if (data.objDT[i].NEWFLAG == 'Y') {
                    html += "           <span class='badge badge-primary'>New</span>";
                }

                if (data.objDT[i].COMMENTCNT != 0) {
                    html += "           <span> ["+ data.objDT[i].COMMENTCNT +"] </span>";
                }
                
                html += "           </td>";
                html += "           <td>"
                html += "					<span>" + data.objDT[i].USERID + "</span>         ";
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

        }


        //게시글 상세보기
        function boardDetail(boardNo) {

            location.href = "/Board/BoardDetail.aspx?boardNo=" + boardNo + "&categoryNo=" + $("#ContentPlaceHolder1_categoryNo").val();

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


</script>

</asp:Content>

