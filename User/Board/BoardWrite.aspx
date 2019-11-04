<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BoardWrite.aspx.cs" Inherits="Board_BoardWrite" %>

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
                            <li class="active">글쓰기</li>
                        </ol> <!-- end of /.breadcrumb -->

                    </div>
                </div>
            </div> <!-- /.container -->
        </div> <!-- /.header-wrapper -->
    </header> <!-- /.page-head (header end) -->
    
     <input type="hidden" id="categoryNo" runat="server" />

    <div class="main-content">
      <div class="container">
        <div class="row">
            <section class="panel">
                
                <div class="form-horizontal" style="font-size:150%;">
              <div class="panel-body">

                    <div class="form-group">
                      <label for="cname" class="control-label col-lg-2" style="padding-top:0px;">제목<span class="required">*</span></label>
                      <div class="col-lg-8">
                        <input class="form-control" id="txtTitle" name="txtTitle" type="text" maxlength="50" style="height:40px; font-size:17px;" required="required" />
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="ccomment" class="control-label col-lg-2" style="padding-top:0px;">내용<span class="required">*</span></label>
                      <div class="col-lg-8">
                        <textarea class="form-control" rows="20" id="txtContent" name="txtContent" required="required" style="resize: none; font-size:17px;"></textarea>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="col-lg-offset-2 col-lg-10" style="text-align:right;">
                        <input type="button" class="btn btn-primary" id="btnBoardIns" value="등록">
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

        $("#btnBoardIns").on("click",function(){

            if($("#txtTitle").val() == "" || $("#txtTitle").val().replace(/(\s*)/g,"") == "" ){
                alert("제목을 입력하세요");
                return;
            }

            if($("#txtContent").val() == "" || $("#txtContent").val().replace(/(\s*)/g,"") == "" ){
                alert("내용을 입력하세요");
                return;
            }

            var content = $("#txtContent").val();
            
            var reqParam = {};
           
            reqParam["strMethod"] = "boardIns";
            reqParam["intUserNo"] = <%= Session["userNo"] %>;
            reqParam["strTitle"] = $("#txtTitle").val();
            reqParam["intCategoryNo"] = $("#ContentPlaceHolder1_categoryNo").val();
            reqParam["strContent"] = content;

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

                    alert("글이 등록되었습니다.");

                    location.href = "/Board/BoardList.aspx?categoryNo=" + $("#ContentPlaceHolder1_categoryNo").val();
                }
            })
            
        });

        $("#txtTitle").keyup(function(){
            if($(this).val().length > $(this).attr('maxlength')){
                alert("제목을 50자를 넘을 수 없습니다.");
                $(this).val($(this).val().substr(0, $(this).attr('maxlength')));

            }
        })
        
    });

</script>
</asp:Content>

