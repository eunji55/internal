
using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;
using System.Net;
using System.Web.UI;

public partial class Item_ItemOrder : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8
    private int packNo = 0;
    private int userNo = 0;

    private string pgcode = "";
    private int amount = 0;
    private int chargeAmount = 0;
    private int cashAmount = 0;
    private string product_name = "";
    private string dateRecvStart = "";
    private string address = "";

    private string orderNo = "";
    private int userTotalCash = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            packNoVal.Value = Request.Form["ctl00$ContentPlaceHolder1$packNoVal"];
            recvStartDate.InnerText = Request.Form["recvStartDate"];
        }

        packNo = Convert.ToInt32(packNoVal.Value);
        userNo = Convert.ToInt32(Page.Session["userNo"]);

        address = Request.Form["ctl00$ContentPlaceHolder1$postcode"]+" " +Request.Form["ctl00$ContentPlaceHolder1$address1"]+" "+Request.Form["ctl00$ContentPlaceHolder1$address2"];


        getPackageDetail(packNo);
        userInfoGet(userNo);
        
            
    }
    
    ///----------------------------------------------------------------------
    /// <summary>
    /// 패키지 상세 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private void getPackageDetail(int packNo)
    {
        BOQv7Das_Net.IDas objDas = null;
        
        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage    = DAS_CODEPAGE;

            objDas.AddParam("@pi_intPackNo",        DBType.adInteger,       packNo,      0,      ParameterDirection.Input);
            objDas.AddParam("@po_strPname",         DBType.adVarWChar,      DBNull.Value,               20,     ParameterDirection.Output);
            objDas.AddParam("@po_intPrice",         DBType.adInteger,       DBNull.Value,               0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_PACKAGE_DTL_UR_LST"); //Execute Query 

            DataRow row = objDas.objDT.Rows[0];
            packImg.Src = row["PACKIMG"].ToString().Replace("D:\\WEBHOSTING\\ejdo\\User", "");
            packName.InnerText = objDas.GetParam("@po_strPname");
            packPrice.InnerText = objDas.GetParam("@po_intPrice");
            product_name = objDas.GetParam("@po_strPname"); 
            amount = Convert.ToInt32(objDas.GetParam("@po_intPrice"));


        }
        catch
        {
        }
        finally
        {
            //Close
            if (objDas != null)
            {
                objDas.Close();
                objDas = null;
            }
        }
    }

     ///----------------------------------------------------------------------
    /// <summary>
    /// 회원정보 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private void userInfoGet(int userNo)
    {
        BOQv7Das_Net.IDas objDas = null;
        
        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage    = DAS_CODEPAGE;

            objDas.AddParam("@pi_intUserNo",    DBType.adInteger,       userNo,      0,     ParameterDirection.Input);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_INFO_AR_LST"); //Execute Query 

            DataTable dt = objDas.objDT;
            DataRow dr = dt.Rows[0];

            userName.Value = dr["NAME"].ToString();
            postcode.Value = dr["POSTCODE"].ToString();
            address1.Value = dr["ADDRESS1"].ToString();
            address2.Value = dr["ADDRESS2"].ToString();
            phone.Value = dr["PHONE"].ToString();

            totalCash.Value = dr["TOTALCASH"].ToString();
            userTotalCash = Convert.ToInt32(dr["TOTALCASH"]);
        }
        catch
        {
        }
        finally
        {
            //Close
            if (objDas != null)
            {
                objDas.Close();
                objDas = null;
            }
        }
    }



    protected void btnPay_Click(object sender, EventArgs e)
    {
        

        pgcode = Request["pgCode"];
        dateRecvStart = Request.Form["dateRecvStart"];
        chargeAmount = Convert.ToInt32(Request["chargeAmountVal"]);
        cashAmount = Convert.ToInt32(Request["cashAmountVal"]);
        
        if (userTotalCash < cashAmount)
        {
            Response.Write("<script>alert('구매 실패');</script>");
            Response.Write("<script>location.href='../Item/ItemList.aspx';</script>");
            return;
        }
        else
        {

            int    intRetVal     = 0;
            BOQv7Das_Net.IDas objDas = null;

            string strErrMsg   = string.Empty;

            try { 

                objDas = new BOQv7Das_Net.IDas();

                objDas.Open(DAS_HOST);
                objDas.CommandType = CommandType.StoredProcedure;
                objDas.CodePage = DAS_CODEPAGE;

                objDas.AddParam("@pi_strUserId",        DBType.adVarChar,      Page.Session["userId"],  20,             ParameterDirection.Input);
                objDas.AddParam("@pi_intPackNo",        DBType.adInteger,      packNo,                  0,              ParameterDirection.Input);
                objDas.AddParam("@pi_intChargeAmount",  DBType.adInteger,      chargeAmount,            0,              ParameterDirection.Input);
                objDas.AddParam("@pi_intCashAmount",    DBType.adInteger,      cashAmount,              0,              ParameterDirection.Input);
                objDas.AddParam("@pi_strDateRecvStart", DBType.adDate,         dateRecvStart,           0,              ParameterDirection.Input);
                objDas.AddParam("@pi_strAddress",       DBType.adVarWChar,     address,                 100,            ParameterDirection.Input);
                objDas.AddParam("@pi_strMethod",        DBType.adVarChar,      pgcode,                  20,             ParameterDirection.Input);

                objDas.AddParam("@po_intOrderNo",       DBType.adBigInt,        0,                      0,              ParameterDirection.Output);
                objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,           0,              ParameterDirection.Output);
                objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,           256,            ParameterDirection.Output);


                objDas.SetQuery("dbo.UP_ORDER_TX_INS"); //Execute Query 

                if (!objDas.LastErrorCode.Equals(0))
                {
                    intRetVal = objDas.LastErrorCode;
                    strErrMsg    = objDas.LastErrorMessage;
                }
            
                orderNo = objDas.GetParam("@po_intOrderNo");

                if (chargeAmount > 0)
                {
                    sendPayment(orderNo);
                }else
                {
                    orderSuccess(orderNo);
                    int cpRetVal = chargePurchase(orderNo);

                    if(cpRetVal == 0)
                    {
                        Response.Write("<script>fnOrderSuccess();</script>");
                        Response.Write("<script>location.href='../Membership/PurchaseList.aspx';</script>");
                        
                    }
                }

            }
            catch
            {

            }finally
            {
                //Close
                if (objDas != null)
                {
                    objDas.Close();
                    objDas = null;
                }

            }
        }

    }

    protected void sendPayment(string orderNo)
    {
        
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://testpgapi.payletter.com/v1.0/payments/request");
        request.Method = "POST";
        request.ContentType = "application/json";
        request.Headers.Add("Authorization","PLKEY NUQyQ0RGNTBEODQ5NTg4OTc1MEQyNTdCRjY5NTRFNjg=");
        
        using (var sw = new StreamWriter(request.GetRequestStream()))
        {
            string json = "{\"pgcode\" : \"" + pgcode + "\"," +
                            "\"user_id\":\"" + Page.Session["userId"] + "\"," +
                            "\"client_id\":\"testintern\"," +
                            "\"amount\":" + chargeAmount + "," +
                            "\"product_name\":\"" + product_name + "\"," +
                            "\"order_no\":\"" + orderNo + "\"," +
                            "\"autopay_flag\":\"N\"," +
                            "\"custom_parameter\":\"" + cashAmount.ToString() + "\"," +
                            "\"return_url\":\"http://ejdo.payletter.com/Payment/OrderReturn.aspx\"," +
                            "\"callback_url\":\"http://ejdo.payletter.com/Payment/Noti.aspx\"," +
                            "\"cancel_url\":\"http://ejdo.payletter.com/Payment/OrderCancel.aspx\"}"; 

            sw.Write(json);
            sw.Flush();
            sw.Close();


        }

        var response = (HttpWebResponse)request.GetResponse();
        using (var streamReader = new StreamReader(response.GetResponseStream()))
        {
            var result = streamReader.ReadToEnd();
            int a = result.IndexOf("online_url") + 13;
            int b = result.Length - 1;
            result = result.Substring(a, 87);

            Response.Write("<script type='text/javascript'> window.open('" + result + "', 'popPayment', 'height = 600, width = 400, status = yes, toolbar = no, menubar = no, location = no');</script>");
        }
    }

    private void orderSuccess(string orderNo)
    {
        int intRetVal = 0;
        BOQv7Das_Net.IDas objDas = null;

        string strErrMsg = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;
            

            objDas.AddParam("@pi_intOrderNo", DBType.adBigInt, Convert.ToInt64(orderNo), 0, ParameterDirection.Input);
            objDas.AddParam("@pi_intStatus", DBType.adVarChar, 2, 0, ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
            objDas.AddParam("@po_strMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);

            objDas.SetQuery("dbo.UP_ORDER_TX_UPD"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
            }

            intRetVal = Convert.ToInt32(objDas.GetParam("@po_intRetVal"));
            strErrMsg = objDas.GetParam("@po_strMsg");
            

        }
        catch (Exception ex)
        {
            Response.Write("{\"code\":1, \"message\":\"" + ex.Message + "\"}");

        }
        finally
        {

        }
    }

    private int chargePurchase(string orderNo)
    {
        int intRetVal = 0;
        BOQv7Das_Net.IDas objDas = null;

        string strErrMsg = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;
            
            objDas.AddParam("@pi_intOrderNo", DBType.adBigInt, Convert.ToInt64(orderNo), 0, ParameterDirection.Input);
            objDas.AddParam("@pi_strUserId", DBType.adVarChar, Page.Session["userId"], 20, ParameterDirection.Input);
            objDas.AddParam("@pi_intAmount", DBType.adInteger, amount, 0, ParameterDirection.Input);
            objDas.AddParam("@pi_intChargeAmount", DBType.adInteger, chargeAmount, 0, ParameterDirection.Input);
            objDas.AddParam("@pi_intCashAmount", DBType.adInteger, cashAmount, 0, ParameterDirection.Input);

            objDas.AddParam("@pi_strTId", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
            objDas.AddParam("@po_strMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_CHARGE_PURCHASE_TX_INS"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
                return intRetVal;
            }
            

        }
        catch
        {
        }
        finally
        {
            //Close
            if (objDas != null)
            {
                objDas.Close();
                objDas = null;
            }
        }

        return intRetVal;
    }

}