<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PackageInsert.aspx.cs" Inherits="PackageMng_PackageInsert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section id="main-content">
      <section class="wrapper">
            <div class="row">
                
                <section class="panel">
                
                <div class="form-horizontal">
                <div class="panel-body">


                <div class="form-group">
                    <label for="packName" class="control-label col-lg-2" style="padding-top:0px;">패키지명<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <input type="text" class="form-control" id="packName" runat="server"/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="packName" class="control-label col-lg-2" style="padding-top:0px;">횟수<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <input type="text" class="form-control" id="packCnt" runat="server"/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="packPrice" class="control-label col-lg-2" style="padding-top:0px;">가격<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <input type="text" class="form-control" id="packPrice" runat="server" />
                    </div>
                </div>


                <div class="form-group">
                    <label for="itemCheckboxList" class="control-label col-lg-2" style="padding-top:0px;">상품 5개 선택<span class="required">*</span></label>
                    
                    <div class="form-group">
                        <div class="col-md-8" id="itemCheckboxList">
                            <table class="table itemCheckboxtListAdd">

                            </table>
                        </div>
                    </div>

                    
                    <div class="form-group">
                    <label for="searchId" class="control-label col-lg-2" style="padding-top:0px;">예상가격<span class="required">*</span></label>
                        <div class="col-md-8">
                        
                           <input type="text" id="totalPrice" style="border:none; background-color:white;" value="0" disabled/> * <input type="text" id="week" style="border:none; background-color:white;" disabled/>주
                            = <input type="text" id="expectedPrice" style="border:none; background-color:white;" value="0" disabled/> 원
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="packImg" class="control-label col-lg-2" style="padding-top:0px;">상품이미지<span class="required">*</span></label>
                        <div class="col-lg-8">
                            <img id="packImage" runat="server" src="#" style="max-height:500px; max-width:1000px;" hidden/>
                            <asp:FileUpload ID="packImg" runat="server" accept=".png,.jpg,.jpeg,.gif" onchange="imgPreview(this)"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-lg-offset-2 col-lg-10" style="text-align:right;">
                            <asp:Button ID="Button1" class="btn btn-primary" runat="server" onclick="addItem_Click" OnClientClick="return fnCheck();" Text="등록" />
                        </div>
                    </div>

                  </div>
                    
                
                </div></section>
             </div>
      </section>
    </section>

     <script type="text/javascript">
         $(document).ready(function () {
             getItemList();

             $("#packImg").change(function () {
                 imgPreview(this);
             });

             $("#btnSearch").on("click", function () {
                 getItemList();
             });

             $("#<%=packCnt.ClientID%>").keyup(function () {
                 $("#week").val($("#<%=packCnt.ClientID%>").val() / 5);
             });

             $("#<%=packPrice.ClientID%>").keyup(function () {
                 $("#<%=packPrice.ClientID%>").val(fnAddComma(fnRmvComma($("#<%=packPrice.ClientID%>").val())));
             });

         });
        //업로드 이미지 미리보기
        function imgPreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $("#<%=packImage.ClientID%>").attr('src', e.target.result);
                    $("#<%=packImage.ClientID%>").removeAttr("hidden");
                }

                reader.readAsDataURL(input.files[0]);

            }
        }

         // 상품 목록
         function getItemList() {
             var reqParam = {};

             reqParam["strMethod"] = "ItemList";
             reqParam["intPageNo"] = 1;
             reqParam["intPageSize"] = 100;

             reqParam["strSearchId"] = $("#searchId").val();
             reqParam["intSearchType"] = 0;

             console.log(reqParam);

             $.ajax({
                 type: "POST",
                 data: JSON.stringify(reqParam),
                 url: "/ItemMng/ItemHandler.ashx",
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

                     itemCheckboxtList(data);

                 }
             })
         }

         //상품목록  html
         function itemCheckboxtList(data) {

             var html = "";
             html += "       <thead>";
             html += "       <tr>";
             html += "           <th class='text-center' width='10%;'>선택</th>";
             html += "           <th class='text-center' width='20%;'>상품명</th>";
             html += "           <th class='text-center' width='20%;'>가격</th>";
             html += "       </tr>";
             html += "       </thead>";
             html += "       <tbody>";

             for (var i = 0; i < data.objDT.length; i++) {

                 html += "       <tr >";
                 html += "           <td class='text-center'><input type='checkbox' class='itemCheckbox' name='itemCheckbox' value='" + data.objDT[i].ITEMNO + "'></td>";
                 html += "           <td class='text-center'>" + data.objDT[i].ITEMNAME + "</td>";
                 html += "           <td class='text-center itemPrice'>" + fnAddComma(data.objDT[i].PRICE) + "</td>";

                 html += "       </tr>";

             }

             html += "       </tbody>";

             $('.itemCheckboxtListAdd').html(html);


             var totalPrice = 0;

             //상품 다섯개만 선택 가능
             $("input:checkbox[name=itemCheckbox]").change(function () {
                 var cnt = $("input:checkbox[name=itemCheckbox]:checked").length;
                 if (cnt == 5) {
                     $("input:checkbox[name=itemCheckbox]:not(:checked)").attr("disabled", "disabled");
                 } else {
                     $("input:checkbox[name=itemCheckbox]:not(:checked)").removeAttr("disabled");
                 }
             });

             $('input:checkbox[name="itemCheckbox"]').change(function () {
                 if($(this).is(':checked')){
                     totalPrice += Number(fnRmvComma($(this).parent().siblings(".itemPrice").text()));
                 } else if (!($(this).is(':checked'))) {
                     totalPrice -= Number(fnRmvComma($(this).parent().siblings(".itemPrice").text()));
                 }

                 $("#totalPrice").val(fnAddComma(totalPrice));
                 var ex = fnRmvComma($("#totalPrice").val()) * $("#week").val();
                 $("#expectedPrice").val(fnAddComma(ex));
             });
         }

         function fnCheck() {
             if ($("#<%= packName.ClientID %>").val() == "") {
                 alert("패키지명을 입력하세요");
                 return false;
             }

             if ($("#<%= packCnt.ClientID %>").val() == "") {
                 alert("횟수을 입력하세요");
                 return false;
             }

             if ($("#<%= packPrice.ClientID %>").val() == "") {
                 alert("가격을 입력하세요");
                 return false;
             }

             var cnt = $("input:checkbox[name=itemCheckbox]:checked").length;

             if (cnt != 5) {
                 alert("상품을 5개 선택하세요");
                 return false;
             }

              if ($("#<%= packImg.ClientID %>").val() == "") {
                 alert("상품이미지를 등록하세요");
                 return false;
             }


             return true;
         }
    </script>
</asp:Content>

