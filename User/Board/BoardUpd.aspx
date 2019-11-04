<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BoardUpd.aspx.cs" Inherits="Board_BoardUpd" %>

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
                            <li class="active">글수정</li>
                        </ol> <!-- end of /.breadcrumb -->

                    </div>
                </div>
            </div> <!-- /.container -->
        </div> <!-- /.header-wrapper -->
    </header> <!-- /.page-head (header end) -->

    <div class="main-content">
      <div class="container">
        <div class="row">
            <section class="panel">
               <div class="form-horizontal" style="font-size:150%;">
                <div class="panel-body">

                    <input type="hidden" id="categoryNo" runat="server" />

                    <div class="form-group">
                      <label for="cname" class="control-label col-lg-2" style="padding-top:0px;">제목<span class="required">*</span></label>
                      <div class="col-lg-8">
                        <input class="form-control" id="titleUpd" name="txtTitle" type="text" maxlength="50" runat="server" style="height:40px; font-size:17px;" required="required" />
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="ccomment" class="control-label col-lg-2" style="padding-top:0px;">내용<span class="required">*</span></label>
                      <div class="col-lg-8">
                        <textarea class="form-control" rows="20" id="contentUpd" name="txtContent" runat="server" style="resize: none; font-size:17px;" required="required" ></textarea>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="col-lg-offset-2 col-lg-10" style="text-align:right;">
                        <button class="btn btn-primary" id="btnUpdate">수정</button>
                          <button class="btn btn-danger" onclick="history.back()">취소</button>
                      </div>
                    </div>
                </div>

              </div>
            </section>
          </div>
    </div>
</div>
</div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnUpdate").on("click", function () {
                var boardNo = "<%= boardNo %>";

                var reqParam = {};
                reqParam["strMethod"] = "BoardUpd";
                reqParam["intBoardNo"] = boardNo;
                reqParam["strTitle"] = $("#ContentPlaceHolder1_titleUpd").val();
                reqParam["strContent"] = $("#ContentPlaceHolder1_contentUpd").val();

                console.log(reqParam);


                if ($("#ContentPlaceHolder1_titleUpd").val() == "" || $("#ContentPlaceHolder1_titleUpd").val().replace(/(\s*)/g, "") == "") {
                    alert("제목을 입력하세요");
                    return;
                }

                if ($("#ContentPlaceHolder1_contentUpd").val() == "" || $("#ContentPlaceHolder1_contentUpd").val().replace(/(\s*)/g, "") == "") {
                    alert("내용을 입력하세요");
                    return;
                }


                if (false == confirm("수정 하시겠습니까?"))
                    return;
                
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

                        alert("글이 수정되었습니다.");

                        location.href = "/Board/BoardList.aspx?categoryNo=" + $("#ContentPlaceHolder1_categoryNo").val();
                    }
                })
                

               
            });
        });

    </script>
</asp:Content>

