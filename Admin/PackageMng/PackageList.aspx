<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PackageList.aspx.cs" Inherits="PackageMng_PackageList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!--main content start-->
    <section id="main-content">
      <section class="wrapper">
            <div class="row">

            <section class="panel">
                <!-- 상품 목록 -->
                <div id="packageList">
                    <table class="table table-striped table-hover" id="TPackageList" style="font-size:17px;">
                    </table>
                </div>
                <!-- //상품 목록 --> 
            </section>

            <!-- 등록 버튼 -->
            <div style="text-align:right;">
                <input type="button" id="btnAdd" class="btn btn-primary" value="등록"/>
            </div>
            <!-- //등록 버튼 -->
            </div>

          <!-- 등록 모달 -->
            <div  role="dialog" id="addPackageModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">패키지 등록</h4>
                        </div>
                        <input type="hidden" id="packNameCheckVal" value="1"/> 
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                            <div class="form-group">
                                <label class="col-md-3 control-label" for="packName">패키지명<span class="required">*</span></label>
                                <div class="col-md-6">
                                    <input type="text"  class="form-control" id="packName" name="AuthType" maxlength="30" required/>
                                </div>
                                <input type="button" class="btn btn-primary" id="PackNameCheck" value="중복확인" />
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label" for="packPrice">가격<span class="required">*</span></label>
                                <div class="col-md-6">
                                    <input type="text"  class="form-control" id="packPrice" name="packPrice" maxlength="30" required/>
                                </div>
                            </div>

                            <!--상품 checkbox -->
                            <div class="form-group">
                                <label class="col-md-3 control-label" for="Item">상품 <span class="required">*</span></label><br />
                                <div  class="col-md-9">
                                    <table class="table itemCheckboxtListAdd">


                                    </table>

                                </div>
                            </div>
                            <!-- //상품 checkbox -->
                        
                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnAddPackage" value="등록" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 등록 모달 -->

          <!-- 수정 모달 -->
            <div  role="dialog" id="updPackageModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">패키지 등록</h4>
                        </div>
                        <input type="hidden" id="updPackNameCheckVal" value="1"/> 
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                            <div class="form-group">
                                <label class="col-md-3 control-label" for="packName">패키지명<span class="required">*</span></label>
                                <div class="col-md-6">
                                    <input type="text"  class="form-control" id="updPackName" name="AuthType" maxlength="30" required/>
                                </div>
                                <input type="button" class="btn btn-primary" id="updPackNameCheck" value="중복확인" />
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label" for="packPrice">가격<span class="required">*</span></label>
                                <div class="col-md-6">
                                    <input type="text"  class="form-control" id="updPackPrice" name="packPrice" maxlength="30" required/>
                                </div>
                            </div>

                            <!--상품 checkbox -->
                            <div class="form-group">
                                <label class="col-md-3 control-label" for="Item">상품 <span class="required">*</span></label><br />
                                <div  class="col-md-9">
                                    <table class="table itemCheckboxtListAdd">


                                    </table>

                                </div>
                            </div>
                            <!-- //상품 checkbox -->
                        
                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnUpdPackage" value="수정" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 수정 모달 -->

      </section>
    </section>

<script type="text/javascript">
    $(document).ready(function () {
        getPackageList(1, 10);
        getItemList();

        $('#addPackageModal').on('hidden.bs.modal', function (e) {
            $("input:checkbox[name=itemCheckbox]").removeAttr("disabled");
            console.log('modal close');
            $("#form1")[0].reset();
        });

        
        $('#updPackageModal').on('hidden.bs.modal', function (e) {
            $("input:checkbox[name=itemCheckbox]").removeAttr("disabled");
            console.log('modal close');
            $("#form1")[0].reset();
        });

        $("#btnAdd").on("click", function () {
            location.href = "../PackageMng/PackageInsert.aspx";
        });

    });

    //패키지 목록
    function getPackageList() {
        var reqParam = {};

        reqParam["strMethod"] = "PackageList";

        console.log(reqParam);

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/PackageMng/PackageHandler.ashx",
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

                fnPackageList(data);
            }
        })
    }

    //패키지 목록 html
    function fnPackageList(data) {

        var html = "";
        html += "       <thead>";
        html += "       <tr>";
        html += "           <th class='text-center' width='10%;'>#</th>";
        html += "           <th class='text-center' width='10%;'>이미지</th>";
        html += "           <th class='text-center' width='20%;'>패키지명</th>";
        html += "           <th class='text-center' width='20%;'>가격</th>";
        html += "           <th class='text-center' width='15%;'>등록일</th>";
        html += "       </tr>";
        html += "       </thead>";
        html += "       <tbody>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr >";
            html += "           <td class='text-center'>" + data.objDT[i].ROWNUM + "</td>";
            html += "           <td class='text-center'><img width='50px' height='50px' src='" + (data.objDT[i].PACKIMG).toString().replace("D:\\WEBHOSTING\\ejdo\\User", "http://ejdo.payletter.com") + "'></td>";
            html += "           <td class='text-center'>" + data.objDT[i].NAME;
            html += "           <td class='text-center'>" + fnAddComma(data.objDT[i].PRICE) + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";
            html += "           <td class='text-center'> <input type='button' class='btn btn-default btnUpd' onclick='btnUpd_click(" + data.objDT[i].PACKNO + ")' value='수정' /> <input type='button' class='btn btn-default' onclick='btnDel_click(" + data.objDT[i].PACKNO + ")' value='삭제' /> </td>";
            html += "       </tr>";

        }

        html += "       </tbody>";

        $("#TPackageList").html(html);

    }

    // 상품 목록
    function getItemList() {
        var reqParam = {};

        reqParam["strMethod"] = "ItemList";
        reqParam["intPageNo"] = 1;
        reqParam["intPageSize"] = 100;

        reqParam["strSearchId"] = "";
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

    //상품목록 체크박스 html
    function itemCheckboxtList(data) {

        var html1 = '';

        html1 += "<tr>";

        for (var i = 0; i < data.objDT.length; i++) {

            if (i > 0 && i % 5 == 0) {
                html1 += "</tr><tr>"
            }

            html1 += "  <td><input type='checkbox' name='itemCheckbox' value='" + data.objDT[i].ITEMNO + "'/>"+ data.objDT[i].ITEMNAME + "</td>";

        }

        html1 += "</tr>";

        $('.itemCheckboxtListAdd').html(html1);

    }

    //패키지 등록
    function btnAdd_click() {
        $("#btnAdd").on("click", function () {
            $('input:checkbox[name="itemCheckbox"]').attr("checked", false);

            $("#addPackageModal").modal();

            

            $("#btnAddPackage").on("click", function () {

                var itemList = "";

                $('input:checkbox[name=itemCheckbox]').each(function () {
                
                    if ($(this).is(':checked')) {
                        itemList += $(this).val() + ",";
                    }

                });

                reqParam = {};
                reqParam["strMethod"] = "PackageIns";
                reqParam["strName"] = $("#packName").val();
                reqParam["intPrice"] = $("#packPrice").val();
                reqParam["strItemList"] = itemList.toString();

                console.log(reqParam);

                $.ajax({
                    type: "POST",
                    data: JSON.stringify(reqParam),
                    url: "/PackageMng/PackageHandler.ashx",
                    dataType: "JSON",
                    contentType: "application/json; charset=utf-8",
                    error: function (request, status, error) {
                        alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                    },
                    success: function (data) {
                        console.log(data);
                        alert("등록 되었습니다.");
                        location.reload();
                    }
                })

            });
        }); 
    }

    //수정
    function btnUpd_click(packNo) {

        location.href = '../PackageMng/PackageUpdate.aspx?packNo=' + packNo;
        
    }

    //삭제
    function btnDel_click(packageNo) {
        
        var reqParam = {};

        reqParam["strMethod"] = "PackageDel";
        reqParam["intPackNo"] = packageNo;

        console.log(reqParam);

        if (false == confirm("삭제 하시겠습니까?"))
            return;

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/PackageMng/PackageHandler.ashx",
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

                alert("삭제 되었습니다.");
                getPackageList(1, 10);

            }
        })
    }

</script>
</asp:Content>

