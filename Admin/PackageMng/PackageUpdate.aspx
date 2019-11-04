<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PackageUpdate.aspx.cs" Inherits="PackageMng_PackageUpdate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        .header-wrapper-inner{
            background-image: url("/img/GB0A1287.jpg");
        }


    </style>
    <section id="main-content">
      <section class="wrapper">
            <div class="row">
                
                <section class="panel">
                
                <div class="form-horizontal">
                <div class="panel-body">
                    
                <input type="hidden" id="packNoVal" runat="server" />
                <input type="hidden" id="totalPrice" runat="server" />

                <div class="form-group">
                    <label for="packName" class="control-label col-lg-2" style="padding-top:0px;">패키지명<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <input type="text" class="form-control" id="packNameUpd" runat="server"/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="packName" class="control-label col-lg-2" style="padding-top:0px;">횟수<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <input type="text" class="form-control" id="packCntUpd" runat="server"/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="packPrice" class="control-label col-lg-2" style="padding-top:0px;">가격<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <input type="text" class="form-control" id="packPriceUpd" runat="server" />
                    </div>
                </div>


                <div class="form-group">
                    <label for="itemListUpd" class="control-label col-lg-2" style="padding-top:0px;">상품선택<span class="required">*</span></label>
                    
                    <input type="hidden" id="itemListUpd" runat="server"/>
                    <div class="col-md-8" id="itemCheckboxList" >
                        <table class="table itemCheckboxtListAdd">

                        </table>
                    </div></div>
                   
                    <div class="form-group">
                    <label for="searchId" class="control-label col-lg-2" style="padding-top:0px;">예상가격<span class="required">*</span></label>
                        <div class="col-md-8">
                        
                           <input type="text" id="totalPriceUpd" style="border:none; background-color:white;" disabled/> * <input type="text" id="week" style="border:none; background-color:white;" disabled/>주
                            = <input type="text" id="expectedPrice" style="border:none; background-color:white;" value="0" disabled/> 원
                        </div>
                    </div>

                <div class="form-group">
                    <label for="packImg" class="control-label col-lg-2" style="padding-top:0px;">상품이미지<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <img id="packImageViewUpd" runat="server" src="#" style="max-height:500px; max-width:1000px;"/>
                        <asp:FileUpload ID="packImg" runat="server" accept=".png,.jpg,.jpeg,.gif" onchange="imgPreview(this)"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-lg-offset-2 col-lg-10" style="text-align:right;">
                        <asp:Button ID="Button1" class="btn btn-primary" runat="server" onclick="updPack_Click" Text="등록" />
                    </div>
                </div>

                  </div></div></section>
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

             $("#totalPriceUpd").val(fnAddComma(<%= totalPrice.Value %>));
             $("#week").val($("#<%=packCntUpd.ClientID%>").val() / 5);
             $("#expectedPrice").val($("#totalPriceUpd").val());

             $("#<%=packCntUpd.ClientID%>").keyup(function () {
                 $("#week").val($("#<%=packCntUpd.ClientID%>").val() / 5);

                 var ex = fnRmvComma($("#totalPriceUpd").val()) * $("#week").val();
                 $("#expectedPrice").val(fnAddComma(ex));

             });

             $("#<%=packPriceUpd.ClientID%>").keyup(function () {
                 $("#<%=packPriceUpd.ClientID%>").val(fnAddComma(fnRmvComma($("#<%=packPriceUpd.ClientID%>").val())));
             });
         });
        //업로드 이미지 미리보기
        function imgPreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $("#<%=packImageViewUpd.ClientID%>").attr('src', e.target.result);
                    $("#<%=packImageViewUpd.ClientID%>").removeAttr("hidden");
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
             
             var itemArr = ($("#<%=itemListUpd.ClientID%>").val()).split(",");
             for (var i = 0; i <= itemArr.length; i++) {
                 $('input:checkbox[name="itemCheckbox"][value="' + itemArr[i] + '"]').attr("checked", true);
             }

             if($("input:checkbox[name=itemCheckbox]:not(:checked)")){
                 $("input:checkbox[name=itemCheckbox]:not(:checked)").attr("disabled", "disabled");
             }

             var totalPrice = <%= totalPrice.Value %>;

             $('input:checkbox[name="itemCheckbox"]').change(function () {
                 if($(this).is(':checked')){
                     totalPrice += Number(fnRmvComma($(this).parent().siblings(".itemPrice").text()));
                 } else if (!($(this).is(':checked'))) {
                     totalPrice -= Number(fnRmvComma($(this).parent().siblings(".itemPrice").text()));
                 }

                 $("#totalPriceUpd").val(fnAddComma(totalPrice));
                 var ex = fnRmvComma($("#totalPriceUpd").val()) * $("#week").val();
                 $("#expectedPrice").val(fnAddComma(ex));


             });

             //상품 다섯개만 선택 가능
             $("input:checkbox[name=itemCheckbox]").change(function () {
                 var cnt = $("input:checkbox[name=itemCheckbox]:checked").length;
                 if (cnt == 5) {
                     $("input:checkbox[name=itemCheckbox]:not(:checked)").attr("disabled", "disabled");
                 } else {
                     $("input:checkbox[name=itemCheckbox]:not(:checked)").removeAttr("disabled");
                 }
             });
         }

    </script>

</asp:Content>

