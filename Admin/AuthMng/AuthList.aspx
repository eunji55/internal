<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="AuthList.aspx.cs" Inherits="AuthMng_AuthList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!--main content start-->
    <section id="main-content">
        <section class="wrapper">

            <input type="hidden" name="authRangeVal" id="authRangeVal" runat="server"/>

                <section class="panel">
                <!-- 권한 목록 -->
                <div id="authList">
                    <table class="table table-striped table-hover" id="TAuthList" style="font-size:17px;">
                    </table>
                </div>
                <!-- //권한 목록 --> 
            </section>

            <!-- 등록 버튼 -->
            <div style="text-align:right;">
                <input type="button" id="btnAdd" class="btn btn-primary btnAuthW" value="등록"/>
            </div>
            <!-- //등록 버튼 -->
            


            <input type="hidden" id="authNoVal"/> 
          <!-- 등록 모달 -->
            <div  role="dialog" id="addAuthModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">권한 등록</h4>
                        </div>
                        <input type="hidden" id="authTypeCheckVal" value="1"/> 
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                                <div class="form-group">
                            <label class="col-md-3 control-label" for="AuthType">권한유형<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text"  class="form-control" id="AuthType" name="AuthType" maxlength="30" required/>
                            </div>
                            <input type="button" class="btn btn-primary" id="AuthTypeCheck" value="중복확인" />
                        </div>

                        <!--권한 checkbox -->
                        <div class="form-group">
                            <label class="col-md-3 control-label" for="Name">권한 <span class="required">*</span></label><br />
                            <div  class="col-md-9">
                                <table class="table menuCheckboxtListAdd">


                                </table>

                            </div>
                        </div>
                        <!-- //권한 checkbox -->
                        
                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnAddAuth" value="등록" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- // 등록 모달 -->


            <!-- 수정 모달 -->
            <div  role="dialog" id="updAuthModal" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                        <button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
                        <h4 class="modal-title">권한 수정</h4>
                        </div>
                        <div class="modal-body">
                            <p style="text-align:right;"><span class="required">*</span>는 필수값 입니다.</p> <br />
                            <div class="form form-horizontal">
                                <div class="form-group">
                            <label class="col-md-3 control-label" for="updAuthType">권한유형<span class="required">*</span></label>
                            <div class="col-md-6">
                                <input type="text"  class="form-control" id="updAuthType" maxlength="30" name="updAuthType" required/>
                            </div>
                                <input type="button" class="btn btn-primary" id="AuthTypeCheck2" value="중복확인" />
                        </div>


                        <!--권한 checkbox -->
                        <div class="form-group">
                            <label class="col-md-3 control-label" for="Name">권한 <span class="required">*</span></label><br />
                            <div  class="col-md-9">
                                <table class="table menuCheckboxtListAdd">


                                </table>

                            </div>
                        </div>
                        <!-- //권한 checkbox -->
                        
                                <div class="form-group">
                                    <div class="col-md-offset-2 col-md-10 btn-group">
                                        <input type="button" class="btn btn-primary"  style="float:right;" id="btnUpdAuth" value="수정" />
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

        var authRange = document.getElementById('ContentPlaceHolder1_authRangeVal').value;

        getAuthList(1, 100, authRange);

        getMenuList();

        updAuth();

        authTypeCheck();

        $("#AuthType").on("keyup", function () {
            $("#authTypeCheckVal").val("1");
        });

        $("#updAuthType").on("keyup", function () {
            $("#authTypeCheckVal").val("1");
        });

        $('#addAuthModal').on('hidden.bs.modal', function (e) {
            console.log('modal close');
            $("#form1")[0].reset();
        });

        $('#updAuthModal').on('hidden.bs.modal', function (e) {
            console.log('modal close');
            $("#form1")[0].reset();
        });


        $("#btnAdd").on("click", function () {
            $("#addAuthModal").modal();

        });

        //권한 등록
        $("#btnAddAuth").on("click", function () {
            if ($("#authTypeCheckVal").val() != 0) {
                alert("중복확인 하세요");
                return;
            }

            var reqParam = {};

            reqParam["strMethod"] = "AuthIns";
            reqParam["strAuthType"] = $("#AuthType").val();
            reqParam["strMenuNoList"] = "";
            reqParam["strAuthRangeList"] = "";

            $('input[class="authCheckbox"]').each(function () {
                if ($(this).is(':checked')) {

                    reqParam["strMenuNoList"] += ($(this).closest("td").data("value")) + ",";
                    reqParam["strAuthRangeList"] += ($(this).val()) + ",";
                }
            })

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/AuthMng/AuthHandler.ashx",
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
        authHideBtn(authRange);
    });

    //권한 목록
    function getAuthList(pageNo, pageSize, authRange) {
        var reqParam = {};

        reqParam["strMethod"] = "AuthList";
        reqParam["intPageNo"] = pageNo;
        reqParam["intPageSize"] = pageSize;

        console.log(reqParam);

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/AuthMng/AuthHandler.ashx",
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

                fnAuthList(data, pageNo, pageSize, authRange);
            }
        })
    }

    //권한 목록 html
    function fnAuthList(data, pageNo, pageSize, authRange) {

        var html = "";
        html += "       <thead>";
        html += "       <tr>";
        html += "           <th class='text-center' width='5%;'>번호</th>";
        html += "           <th class='text-center' width='20%;'>권한유형</th>";
        html += "           <th class='text-center' width='15%;'>등록일</th>";
        html += "           <th class='text-center' width='15%;'>관리</th>";
        html += "       </tr>";
        html += "       </thead>";
        html += "       <tbody>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr >";
            html += "           <td class='text-center'>" + (i+1) + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].AUTHTYPE + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";
            html += "           <td class='text-center'> <input type='button' class='btn btn-default btnUpd btnAuthW' onclick='btnUpd_click(" + data.objDT[i].AUTHNO + ")' value='수정' /> </td>";
            html += "       </tr>";

        }

        html += "       </tbody>";

        $("#TAuthList").html(html);
        authHideBtn(authRange);
       
    }

    // 메뉴 목록
    function getMenuList() {
        var reqParam = {};
        
        reqParam["strMethod"] = "MenuList";
        
        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/AuthMng/AuthHandler.ashx",
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

                menuCheckboxtList(data);

            }
        })
    }

    function menuCheckboxtList(data) {

        var html1 = '';
        
        html1 += "		<thead>                                                                           ";
        html1 += "			<tr>                                                                          ";
        html1 += "				<th>메뉴</th>                                                             ";
        html1 += "				<th>없음</th>                                                             ";
        html1 += "				<th>읽기</th>                                                             ";
        html1 += "				<th>읽기쓰기</th>                                                             ";
        html1 += "			</tr>                                                                         ";
        html1 += "		</thead>                                                                          ";
        html1 += "		<tbody>                                                                           ";

        for (var i = 0; i < data.objDT.length; i++) {
              
            html1 += "<tr>                                                                          ";
            html1 += "  <td class='authInsTd' id='" + data.objDT[i].MENUNO + "'>" + data.objDT[i].MENUNAME + "</td>                      ";

            html1 += "  <td class='authInsTd' data-value='" + data.objDT[i].MENUNO + "' > ";
            html1 += "      <input type='radio' class='authCheckbox' name='authCheckbox" + i + "' value='N' required='required'>  </td> ";

            html1 += "  <td class='authInsTd' data-value='" + data.objDT[i].MENUNO + "' > ";
            html1 += "      <input type='radio' class='authCheckbox' name='authCheckbox" + i + "' value='R'>  </td> ";

            html1 += "  <td class='authInsTd' data-value='" + data.objDT[i].MENUNO + "' > ";
            html1 += "      <input type='radio' class='authCheckbox' name='authCheckbox" + i + "' value='W'>  </td> ";
            html1 += "</tr>                                                                         ";
            
        }


        html1 += "		</tbody>                                                                          ";

        $('.menuCheckboxtListAdd').html(html1);
        $(".authCheckbox").first().prop("checked", true);
    }

    //수정버튼 클릭
    function btnUpd_click(authNo) {
        $('input:radio[class="authCheckbox"]').attr("checked", false);

        var reqParam = {};

        reqParam["strMethod"] = "AuthDetail";
        reqParam["intAuthNo"] = authNo;

        $("#authNoVal").val(authNo);
        
        console.log(reqParam);

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/AuthMng/AuthHandler.ashx",
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

                $("#updAuthType").val(data.objDT[0].AUTHTYPE);

                $('input:radio[value="N"]').attr("checked", true);
                for (var i = 0; i < data.objDT.length; i++) {
                   
                    $('input:radio[name="authCheckbox' + i + '"][value="' + data.objDT[i].AUTHRANGE + '"]').attr("checked", true);

                }

                $("#updAuthModal").modal();

            }
        })

    }

    function updAuth() {
        $("#btnUpdAuth").on("click", function () {

            if ($("#authTypeCheckVal").val() != 0) {
                alert("중복확인 하세요");
                return;
            }

            var reqParam = {};

            reqParam["strMethod"] = "AuthUpd";
            reqParam["intAuthNo"] = $("#authNoVal").val();
            reqParam["strAuthType"] = $("#updAuthType").val();
            reqParam["strMenuNoList"] = "";
            reqParam["strAuthRangeList"] = "";

            $('input[class="authCheckbox"]').each(function () {
                if ($(this).is(':checked')) {

                    if ($(this).val() != 'N') {
                        reqParam["strMenuNoList"] += ($(this).closest("td").data("value")) + ",";
                        reqParam["strAuthRangeList"] += ($(this).val()) + ",";
                    }
                }
            })

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/AuthMng/AuthHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    console.log(data);
                    alert("수정 되었습니다.");
                    location.reload();
                }
            })


        })
    }

    //권한유형 중복확인
    function authTypeCheck() {
        var reqParam = {};

        $("#AuthTypeCheck").on("click", function () {
           

            reqParam["strMethod"] = "AuthTypeCheck";
            reqParam["strAuthType"] = $("#AuthType").val();

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/AuthMng/AuthHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    if ($("#AuthType").val() == "" || $("#AuthType").val().replace(/(\s*)/g, "") == "") {
                        alert("권한유형을 입력하세요");
                        return;
                    }

                    if (data.intCheckVal == 0) {
                        alert("사용할 수 있는 권한유형 입니다.");
                        $("#authTypeCheckVal").val(0);
                    } else {
                        alert("이미 존재하는 권한유형 입니다.");
                    }

                }
            })
        })

        $("#AuthTypeCheck2").on("click", function () {
            reqParam["strMethod"] = "AuthTypeCheck";
            reqParam["strAuthType"] = $("#updAuthType").val();

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/AuthMng/AuthHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    if ($("#updAuthType").val() == "" || $("#updAuthType").val().replace(/(\s*)/g, "") == "") {
                        alert("권한유형을 입력하세요");
                        return;
                    }

                    if (data.intCheckVal == 0) {
                        alert("사용할 수 있는 권한유형 입니다.");
                        $("#authTypeCheckVal").val(0);
                    } else {
                        alert("이미 존재하는 권한유형 입니다.");
                    }

                }
            })
        })

    }

   


    function authHideBtn(authRange) {

        if (authRange == 'R') {

            $(".btnAuthW").attr('style', 'cursor:not-allowed');
            $(".btnAuthW").attr('disabled', 'disabled');
        }

    }


</script>
</asp:Content>

