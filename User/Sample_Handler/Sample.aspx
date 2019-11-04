<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Sample.aspx.cs" Inherits="Sample" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    
<script type="text/javascript" src="../bootflat-admin/js/jquery-1.10.1.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $("#btnList").on("click", function () {
            var reqParam = {};
            reqParam["strMethod"]   = "List";

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/Sample_Handler/Handler/SampleHandler.ashx",
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

                    fnList(data);
                }
            })
        })

        $("#btnDetail").on("click", function () {
            var userNo = $("#txtUserNo").val();
            if (userNo == "") {
                alert("번호 입력 필요");
                return;
            }

            var reqParam = {};
            reqParam["strMethod"] = "Detail";
            reqParam["intUserNo"] = userNo;

            console.log(reqParam);

            $.ajax({
                type: "POST",
                data: JSON.stringify(reqParam),
                url: "/Sample_Handler/Handler/SampleHandler.ashx",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                error: function (request, status, error) {
                    alert("Ajax Error - code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                success: function (data) {
                    console.log(data)
                    if (data.intRetVal != 0)
                    {
                        alert("실패");
                        return;
                    }

                    fnList(data);
                }
            })
        })
    });

    function fnList(data) {
        var html = "";
        html += "<div>";
        html += "   <table border='1'>";
        html += "       <tr>";
        html += "           <td>번호</td>";
        html += "           <td>아이디</td>";
        html += "           <td>이름</td>";
        html += "       </tr>";

        for (var i = 0; i < data.objDT.length; i++) {

            html += "       <tr>";
            html += "           <td>" + data.objDT[i].USERNO + "</td>";
            html += "           <td>" + data.objDT[i].USERID + "</td>";
            html += "           <td>" + data.objDT[i].USERNAME + "</td>";
            html += "       </tr>";
        }

        html += "   </table>";
        html += "</div>";

        $("#divHtml").html(html);
    }
</script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <input type="button" id="btnList"   value="조회" />
        <input type="button" id="btnDetail" value="상세조회" /><input type="text" id="txtUserNo" />
    
        <div id="divHtml"></div>
    </div>
    </form>
</body>
</html>
