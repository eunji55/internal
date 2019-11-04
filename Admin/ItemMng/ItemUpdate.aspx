<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ItemUpdate.aspx.cs" Inherits="ItemMng_ItemUpd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section id="main-content">
      <section class="wrapper">
            <div class="row">
                
                <section class="panel">
                
                <div class="form-horizontal">
                <div class="panel-body">

                <input type="hidden" id="itemNoVal" runat="server" />

                <div class="form-group">
                    <label for="itemName" class="control-label col-lg-2" style="padding-top:0px;">상품명<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <asp:TextBox CssClass="form-control" ID="itemNameUpd" runat="server"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="itemName" class="control-label col-lg-2" style="padding-top:0px;">가격<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <asp:TextBox CssClass="form-control" ID="itemPriceUpd" runat="server"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="itemDetail" class="control-label col-lg-2" style="padding-top:0px;">상품설명<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <textarea class="form-control" rows="15" runat="server" ID="itemDetailUpd"></textarea>
                    </div>
                </div>

                <div class="form-group">
                    <label for="itemImg" class="control-label col-lg-2" style="padding-top:0px;">상품이미지<span class="required">*</span></label>
                    <div class="col-lg-8">
                        <img id="itemImageViewUpd" runat="server" src="#" style="max-height:500px; max-width:1000px;"/>
                        <asp:FileUpload ID="itemImgUpd" runat="server" accept=".png,.jpg,.jpeg,.gif" onchange="imgPreview(this)"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-lg-offset-2 col-lg-10" style="text-align:right;">
                        <asp:Button ID="Button1" class="btn btn-primary" runat="server" onclick="updItem_Click" Text="등록" />
                    </div>
                </div>


                  </div></div></section>
             </div>
      </section>
    </section>

    <script type="text/javascript">
        
        $(document).ready(function () {
            $("#itemImgUpd").change(function () {
                imgPreview(this);
            });


        });

        //업로드 이미지 미리보기
        function imgPreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $("#<%=itemImageViewUpd.ClientID%>").attr('src', e.target.result);
                    $("#<%=itemImageViewUpd.ClientID%>").removeAttr("hidden");
                }

                reader.readAsDataURL(input.files[0]);
            }
        }
      
    </script>
</asp:Content>

