<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ItemList.aspx.cs" Inherits="ItemMng_ItemList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!--main content start-->

    <section id="main-content">
      <section class="wrapper">
            <div class="row">

            <div class="col-md-3">
                <input type="text" class="form-control" id="searchId" />
            </div>
            <div class="col-md-5">
                <input type="button" class="btn btn-primary" id="btnSearch" value="검색" />
            </div>
            
            <br /><br />
            <section class="panel">
                <!-- 상품 목록 -->
                <div id="itemList">
                    <table class="table table-striped table-hover" id="TItemList" style="font-size:17px;">
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
      </section>
    </section>

<script type="text/javascript">
    $(document).ready(function () {
        getItemList(1, 10);

        $("#btnAdd").on("click", function () {
            location.href = "../ItemMng/ItemInsert.aspx";
        });

        $("#btnSearch").on("click", function () {
            getItemList(1, 10);
        });
    });

    //상품 목록
    function getItemList(pageNo, pageSize) {
        var reqParam = {};

        reqParam["strMethod"] = "ItemList";
        reqParam["intPageNo"] = pageNo;
        reqParam["intPageSize"] = pageSize;

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
                alert("1.Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            },
            success: function (data) {
                console.log(data);
                if (data.intRetVal != 0) {
                    alert("실패");
                    return;
                }

                fnItemList(data, pageNo, pageSize);
            }
        })
    }

    //상품 목록 html
    function fnItemList(data, pageNo, pageSize) {

        var html = "";
        html += "       <thead>";
        html += "       <tr>";
        html += "           <th class='text-center' width='10%;'>#</th>";
        html += "           <th class='text-center' width='10%;'>이미지</th>";
        html += "           <th class='text-center' width='20%;'>상품명</th>";
        html += "           <th class='text-center' width='20%;'>가격</th>";
        html += "           <th class='text-center' width='15%;'>등록일</th>";
        html += "           <th class='text-center' width='15%;'>관리</th>";
        html += "       </tr>";
        html += "       </thead>";
        html += "       <tbody>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr >";
            html += "           <td class='text-center'>" + data.objDT[i].ROWNUM + "</td>";
            html += "           <td class='text-center'><img width='50px' height='50px' src='" + (data.objDT[i].ITEMIMG).toString().replace("D:\\WEBHOSTING\\ejdo\\User", "http://ejdo.payletter.com") + "'></td>";
            html += "           <td class='text-center'>" + data.objDT[i].ITEMNAME + "</td>";
            html += "           <td class='text-center'>" + fnAddComma(data.objDT[i].PRICE) + "</td>";
            html += "           <td class='text-center'>" + data.objDT[i].REGDATE + "</td>";
            html += "           <td class='text-center'> <input type='button' class='btn btn-default btnUpd' onclick='btnUpd_click(" + data.objDT[i].ITEMNO + ")' value='수정' /> <input type='button' class='btn btn-default' onclick='btnDel_click(" + data.objDT[i].ITEMNO + ")' value='삭제' /> </td>";

            html += "       </tr>";

        }

        html += "       </tbody>";

        $("#TItemList").html(html);

    }

    //수정
    function btnUpd_click(itemNo) {
        location.href = "../ItemMng/ItemUpdate.aspx?itemNo=" + itemNo;
    }

    //삭제
    function btnDel_click(itemNo) {
        
        var reqParam = {};

        reqParam["strMethod"] = "ItemDel";
        reqParam["intItemNo"] = itemNo;

        console.log(reqParam);

        if (false == confirm("삭제 하시겠습니까?"))
            return;

        $.ajax({
            type: "POST",
            data: JSON.stringify(reqParam),
            url: "/ItemMng/ItemHandler.ashx",
            dataType: "JSON",
            contentType: "application/json; charset=utf-8",
            error: function (request, status, error) {
                alert("2.Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            },
            success: function (data) {
                console.log(data);
                if (data.intRetVal != 0) {
                    alert("실패");
                    return;
                }

                alert("삭제 되었습니다.");
                getItemList(1,10);

            }
        })
    }

</script>
</asp:Content>

