<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CashMng.aspx.cs" Inherits="UserMng_CashMng" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    
  <!-- Bootstrap CSS -->
  <link href="../css/bootstrap.min.css" rel="stylesheet"/>
  <!-- bootstrap theme -->
  <link href="../css/bootstrap-theme.css" rel="stylesheet"/>
  <!--external css-->
  <!-- font icon -->
  <link href="../css/elegant-icons-style.css" rel="stylesheet" />
  <link href="../css/font-awesome.css" rel="stylesheet" />
  <!-- Custom styles -->
  <link href="../css/style.css" rel="stylesheet"/>
  <link href="../css/style-responsive.css" rel="stylesheet" />

     <!-- javascripts -->
    <script src="../js/jquery.js"></script>
    <script src="../js/jquery-ui-1.10.4.min.js"></script>
    <script src="../js/jquery-1.8.3.min.js"></script>
    <!-- bootstrap -->
    <script src="../js/bootstrap.min.js"></script>
    <!-- nice scroll -->
    <script src="../js/jquery.scrollTo.min.js"></script>
    <script src="../js/jquery.nicescroll.js" type="text/javascript"></script>
    <!--custome script for all page-->
    <script src="../js/scripts.js"></script>
</head>


<body>
    <form id="form2" runat="server">
    <div class="col-sm-4" style="padding-top: 15px;"> 
        <input type="hidden" id="typeVal" runat="server" />
        <input type="hidden" id="userNoVal" runat="server" />
        <input type="hidden" id="userIdVal" runat="server" />

        <div class="row">
            <div class="col-md-4 bg-white ">
                 <% if ((typeVal.Value).Equals("1")) { %>
                    <h4>캐시 지급</h4>
                <%} else if  ((typeVal.Value).Equals("2")) { %>
                    <h4>캐시 회수</h4>
                <%} %>
                <hr />

            <div class="form-group">
                <label for="amount" class="control-label col-lg-2" style="padding-top:0px;">금액</label>
                <div class="col-lg-8">
                    <asp:TextBox CssClass="form-control" ID="amount" autocomplete="off" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="form-group">
                <label for="detail" class="control-label col-lg-2" style="padding-top:0px;">설명</label>
                <div class="col-lg-8">
                    <asp:TextBox CssClass="form-control" ID="detail" autocomplete="off" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="col-md-6" style="text-align:right">
                <% if ((typeVal.Value).Equals("1")) { %>
                    <asp:Button ID="Button2" class="btn btn-primary" runat="server" onclick="btnIns_Click" Text="지급"  />
                <%} else if  ((typeVal.Value).Equals("2")) { %>
                    <asp:Button ID="Button1" class="btn btn-primary" runat="server" onclick="btnCnl_Click" Text="회수" />
                <%} %>
            </div>
        </div>
        </div>
    </div>
    </form>
</body>

<script type="text/javascript">
    $(document).ready(function () {
        $("#<%=amount.ClientID%>").keyup(function () {
            $("#<%=amount.ClientID%>").val(fnRmvComma($("#<%=amount.ClientID%>").val()));
            $("#<%=amount.ClientID%>").val(fnAddComma($("#<%=amount.ClientID%>").val()));
        });
    });

    function fnAddComma(data) {
        return Number(data).toLocaleString('en').split(".")[0];
    }

    function fnRmvComma(data) {
        data = String(data);
        return data.replace(/[^\d]+/g, '');
    }
</script>
</html>

