using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Item_Callback : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, http://ko.wikipedia.org/wiki/%EC%BD%94%EB%93%9C_%ED%8E%98%EC%9D%B4%EC%A7%80
    
    protected void Page_Load(object sender, EventArgs e)
    {
        int    intRetVal     = 0;
        BOQv7Das_Net.IDas objDas = null;

        string strErrMsg   = string.Empty;
        string json = "";

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;

            Stream req = Request.InputStream;
            req.Seek(0, System.IO.SeekOrigin.Begin);
            json = new StreamReader(req).ReadToEnd();

            Log(json);

            jsonVal jv = new jsonVal();

            jv = JsonConvert.DeserializeObject<jsonVal>(json);
            
            objDas.AddParam("@pi_intOrderNo",       DBType.adBigInt,        Convert.ToInt64(jv.order_no),   0,              ParameterDirection.Input);
            objDas.AddParam("@pi_intStatus",        DBType.adVarChar,       2,                              0,              ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,              ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,                   256,            ParameterDirection.Output);

            objDas.SetQuery("dbo.UP_ORDER_TX_UPD"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
            }
            
            intRetVal = Convert.ToInt32(objDas.GetParam("@po_intRetVal"));
            strErrMsg = objDas.GetParam("@po_strMsg");
           
            if (intRetVal.Equals(0))
            {
                chargePurchase(jv);
            }

            
        }
        catch(Exception ex)
        {
            Response.Write("{\"code\":1, \"message\":\""+ex.Message+"\"}");

        }
        finally
        {
            
        }
    }
    
    private int chargePurchase(jsonVal jv)
    {
        int    intRetVal     = 0;
        BOQv7Das_Net.IDas objDas = null;

        string strErrMsg   = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage    = DAS_CODEPAGE;

            int cashCharge = Convert.ToInt32(jv.custom_parameter);
            int amount = cashCharge + jv.amount;

            objDas.AddParam("@pi_intOrderNo",       DBType.adBigInt,    Convert.ToInt64(jv.order_no),       0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strUserId",        DBType.adVarChar,   jv.user_id,                         20,         ParameterDirection.Input);
            objDas.AddParam("@pi_intAmount",        DBType.adInteger,   amount,                             0,          ParameterDirection.Input);
            objDas.AddParam("@pi_intChargeAmount",  DBType.adInteger,   jv.amount,                          0,          ParameterDirection.Input);
            objDas.AddParam("@pi_intCashAmount",    DBType.adInteger,   cashCharge,                         0,          ParameterDirection.Input);

            objDas.AddParam("@pi_strTId",           DBType.adVarChar,   jv.tid,                             256,        ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                       0,          ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,   DBNull.Value,                       256,        ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_CHARGE_PURCHASE_TX_INS"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
                return intRetVal;
            }
            
            Response.Write("{\"code\":0, \"message\":\""+ jv.order_no + "," + jv.custom_parameter +","+ jv.amount +"\"}");

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

    public class jsonVal
    {
        public string code { get; set; }                         
        public string message { get; set; }                      
        public string user_id { get; set; }                      
        public string order_no { get; set; }                     
        public string service_name { get; set; }                 
        public string product_name { get; set; }                 
        public string custom_parameter { get; set; }             
        public string tid { get; set; }                          
        public string cid { get; set; }                          
        public int amount { get; set; }                          
        public string pay_info { get; set; }                     
        public string pgcode { get; set; }                       
        public string billkey { get; set; }                      
        public string domestic_flag { get; set; }                
        public string transaction_date { get; set; }             
        public string install_month { get; set; }                
        public string card_info { get; set; }                    
        public string payhash { get; set; }
    }


    /// ms까지 시간을 구하는 함수
    public string GetDateTime()
    {
        DateTime NowDate = DateTime.Now;
        return NowDate.ToString("yyyy-MM-dd HH:mm:ss") + ":" + NowDate.Millisecond.ToString("000");
    }


    /// 로그 기록
    /// 로그내용
    public void Log(string str)
    {
        string FilePath = @"D:\WEBHOSTING\ejdo\Logs\Log" + DateTime.Today.ToString("yyyyMMdd") + ".log";
        string DirPath = @"D:\WEBHOSTING\ejdo\Logs";
        string temp;

        DirectoryInfo di = new DirectoryInfo(DirPath);
        FileInfo fi = new FileInfo(FilePath);

        try
        {
            if (di.Exists != true) Directory.CreateDirectory(DirPath);

            if (fi.Exists != true)
            {
                using (StreamWriter sw = new StreamWriter(FilePath))
                {
                    temp = string.Format("[{0}] : {1}", GetDateTime(), str);
                    sw.WriteLine(temp);
                    sw.Close();
                }
            }
            else
            {
                using (StreamWriter sw = File.AppendText(FilePath))
                {
                    temp = string.Format("[{0}] : {1}", GetDateTime(), str);
                    sw.WriteLine(temp);
                    sw.Close();
                }
            }
        }
        catch (Exception e)
        {
            Response.Write(e.Message);
        }
    }
}