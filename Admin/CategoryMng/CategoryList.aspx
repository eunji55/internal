<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CategoryList.aspx.cs" Inherits="CategoryMng_CategoryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!--main content start-->
    <section id="main-content">
      <section class="wrapper">
            <div class="row">

                <section class="panel">
                    <!--  카테고리 목록 -->
                    <div id="categoryList">
                        <table class="table table-striped table-hover" id="TCategoryList" style="font-size:17px;">
                        </table>
                    </div>
                    <!-- //카테고리 목록 --> 
                </section>

                <!-- 등록 버튼 -->
                <div style="text-align:right;">
                    <input type="button" id="btnAdd" class="btn btn-primary" value="등록"/>
                </div>
                <!-- //등록 버튼 -->

                <input type="hidden" id="categoryNoVal"/> 
                <!-- 등록 모달 -->
                <div  role="dialog" id="addCategoryModal" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                            <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                            <h4 class="modal-title">카테고리 등록</h4>
                            </div>
                            <input type="hidden" id="categoryNameCheckVal" value="1"/> 
                            <div class="modal-body">
                                <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                                <div class="form form-horizontal">
                                    <div class="form-group">
                                <label class="col-md-3 control-label" for="CategoryName">카테고리명<span class="required">*</span></label>
                                <div class="col-md-6">
                                    <input type="text"  class="form-control" id="CategoryName" name="CategoryName" maxlength="20" required/>
                                </div>
                                <input type="button" class="btn btn-primary" id="CategoryNameCheck" value="중복확인" />
                            </div>

                       
                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnAddCategory" value="등록" />
                                    </div>
                                </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- // 등록 모달 -->

                <!-- 수정 모달 -->
                <div  role="dialog" id="updCategoryModal" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                            <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                            <h4 class="modal-title">카테고리 등록</h4>
                            </div>
                            <div class="modal-body">
                                <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                                <div class="form form-horizontal">
                                    <div class="form-group">
                                <label class="col-md-3 control-label" for="updCategoryName">카테고리명<span class="required">*</span></label>
                                <div class="col-md-6">
                                    <input type="text"  class="form-control" id="updCategoryName" name="CategoryName" maxlength="20" required/>
                                </div>
                                <input type="button" class="btn btn-primary" id="CategoryNameCheck2" value="중복확인" />
                            </div>

                       
                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnUpdCategory" value="수정" />
                                    </div>
                                </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- // 수정 모달 -->

            </div>
        </section>
  </section>
<script type="text/javascript">
    $(document).ready(function () {
        getCategoryList();
        addCategory();
        updCategory();
        categoryNameCheck();

        $('#addCategoryModal').on('hidden.bs.modal', function (e) {
            console.log('modal close');
            $("#form1")[0].reset();
        });

        $('#updCategoryModal').on('hidden.bs.modal', function (e) {
            console.log('modal close');
            $("#form1")[0].reset();
        });

        $("#CategoryName").on("keyup", function () {
            $("#categoryNameCheckVal").val("1");
        });

        $("#updCategoryName").on("keyup", function () {
            $("#categoryNameCheckVal").val("1");
        });

    });

    //카테고리 목록
    function getCategoryList() {
        var reqParam = {};

        reqParam["strMethod"] = "CategoryList";

        console.log(reqParam);

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/CategoryMng/CategoryHandler.ashx",
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

                fnCategoryList(data);
            }
        })
    }

    //카테고리 목록 html
    function fnCategoryList(data) {

        var html = "";
        html += "       <thead>";
        html += "       <tr>";
        html += "           <th class='text-center' width='10%;'>#</th>";
        html += "           <th class='text-center' width='20%;'>카테고리명</th>";
        html += "           <th class='text-center' width='15%;'>등록일</th>";
        html += "           <th class='text-center' width='15%;'>관리</th>";
        html += "       </tr>";
        html += "       </thead>";
        html += "       <tbody>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr >";
            html += "           <td class='text-center'>" + (i+1) + "</td>";
            html += "           <td class='text-center' onClick='goBoard(" + data.objDT[i].CATEGORYNO + ")' style='cursor:pointer;'>" + data.objDT[i].CATEGORYNAME + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";
            html += "           <td class='text-center'> <input type='button' class='btn btn-default btnUpd' onclick='btnUpd_click(" + data.objDT[i].CATEGORYNO + ")' value='수정' /> <input type='button' class='btn btn-default' onclick='btnDel_click(" + data.objDT[i].CATEGORYNO + ")' value='삭제' /> </td>";
            html += "       </tr>";

        }

        html += "       </tbody>";

        $("#TCategoryList").html(html);

    }

    function goBoard(categoryNo) {
        location.href = "../Board/BoardList.aspx?categoryNo=" + categoryNo;
    }

    //카테고리명 중복확인
    function categoryNameCheck() {
        $("#CategoryNameCheck").on("click", function () {
            var reqParam = {};
            reqParam["strMethod"] = "CategoryNameCheck";
            reqParam["strCategoryName"] = $("#CategoryName").val();

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/CategoryMng/CategoryHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    if ($("#CategoryName").val() == "" || $("#CategoryName").val().replace(/(\s*)/g, "") == "") {
                        alert("카테고리명을 입력하세요");
                        return;
                    }

                    if (data.intCheckVal == 0) {
                        alert("사용할 수 있는 카테고리명 입니다.");
                        $("#categoryNameCheckVal").val(0);
                    } else {
                        alert("이미 존재하는 카테고리명 입니다.");
                    }

                }
            })
        });

        $("#CategoryNameCheck2").on("click", function () {
            var reqParam = {};
            reqParam["strMethod"] = "CategoryNameCheck";
            reqParam["strCategoryName"] = $("#updCategoryName").val();

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/CategoryMng/CategoryHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    if ($("#updCategoryName").val() == "" || $("#updCategoryName").val().replace(/(\s*)/g, "") == "") {
                        alert("카테고리명을 입력하세요");
                        return;
                    }

                    if (data.intCheckVal == 0) {
                        alert("사용할 수 있는 카테고리명 입니다.");
                        $("#categoryNameCheckVal").val(0);
                    } else {
                        alert("이미 존재하는 카테고리명 입니다.");
                    }

                }
            })

        });

    }

    //카테고리 등록
    function addCategory() {
        $("#btnAdd").on("click", function () {
            $("#addCategoryModal").modal();

            btnAddCategory();
        });
    }

    function btnAddCategory() {
        $("#btnAddCategory").on("click", function () {

            if ($("#CategoryName").val() == "" || $("#CategoryName").val().replace(/(\s*)/g, "") == "") {
                alert("카테고리명을 입력하세요");
                return;
            }

            if ($("#categoryNameCheckVal").val() != 0) {
                alert("중복확인 하세요");
                return;
            }

            var reqParam = {};

            reqParam["strMethod"] = "CategoryIns";
            reqParam["strCategoryName"] = $("#CategoryName").val();

            console.log(reqParam);

            if (false == confirm("등록 하시겠습니까?"))
                return;

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/CategoryMng/CategoryHandler.ashx",
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

                    alert("등록 되었습니다.");
                    $("#addCategoryModal").modal('hide');
                    getCategoryList();
                }
            })


        })
    }

        //관리-수정 버튼 클릭시 상세보기
        function btnUpd_click(categoryNo) {
            $("#updCategoryModal").modal();

            var reqParam = {};

            reqParam["strMethod"] = "CategoryDetail";
            reqParam["intCategoryNo"] = categoryNo;

            $("#categoryNoVal").val(categoryNo);

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/CategoryMng/CategoryHandler.ashx",
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

                    $("#updCategoryName").val(data.objDT[0].CATEGORYNAME);

                }
            })

        }

        function updCategory() {
        
            $("#btnUpdCategory").on("click", function () {

                if ($("#updCategoryName").val() == "" || $("#updCategoryName").val().replace(/(\s*)/g, "") == "") {
                    alert("카테고리명을 입력하세요");
                    return;
                }

                if ($("#categoryNameCheckVal").val() != 0) {
                    alert("중복확인 하세요");
                    return;
                }

                var reqParam = {};

                reqParam["strMethod"] = "CategoryUpd";
                reqParam["intCategoryNo"] = $("#categoryNoVal").val();
                reqParam["strCategoryName"] = $("#updCategoryName").val();

                console.log(reqParam);

                if (false == confirm("수정 하시겠습니까?"))
                    return;

                $.ajax({
                    type: "POST",
                    data: JSON.stringify(reqParam),
                    url: "/CategoryMng/CategoryHandler.ashx",
                    dataType: "JSON",
                    contentType: "application/json; charset=utf-8",
                    error: function (request, status, error) {
                        alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                    },
                    success: function (data) {
                        console.log(data);
                        alert("수정 되었습니다.");
                        $("#updCategoryModal").modal('hide');
                        getCategoryList();
                    }
                })


            })
        }

        function btnDel_click(categoryNo) {
            var reqParam = {};

            reqParam["strMethod"] = "CategoryDel";
            reqParam["intCategoryNo"] = categoryNo;
        
            console.log(reqParam);

            if (false == confirm("삭제 하시겠습니까?"))
                return;

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/CategoryMng/CategoryHandler.ashx",
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
                    getCategoryList();

                }
            })
        }


</script>

</asp:Content>

