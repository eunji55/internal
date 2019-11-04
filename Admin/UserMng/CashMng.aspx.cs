using BOQv7Das_Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserMng_CashMng : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, http://ko.wikipedia.org/wiki/%EC%BD%94%EB%93%9C_%ED%8E%98%EC%9D%B4%EC%A7%80
    
    private int type = 0;
    private int userNo = 0;
    private string userId = "";
    private Int64 chargeNo = 0;
    private int balance = 0;

    ReqParam objReqParam = null;
    ResParam objResParam = null;

    int intRetVal = 0;
    string strErrMsg = string.Empty;
    string strJsonResult = string.Empty;
    string strReqParam = string.Empty;


    protected void Page_Load(object sender, EventArgs e)
    {
        type = Convert.ToInt32(Request.QueryString["type"]);
        typeVal.Value = type.ToString();

        if(!chargeNo.Equals(null)) {
            chargeNo = Convert.ToInt64(Request.QueryString["chargeNo"]);
        }

        userNo = Convert.ToInt32(Request.QueryString["userNo"]);
        userNoVal.Value = userNo.ToString();
        userId = userInfoGet(userNo);
        balance = Convert.ToInt32(Request.QueryString["balance"]);
       

    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 회원정보 조회
    /// </summary>
    ///----------------------------------------------------------------------
    protected string userInfoGet(int userNo)
    {
        string userId = "";

        BOQv7Das_Net.IDas objDas = null;

        objResParam = null;
        strErrMsg = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;

            objDas.AddParam("@pi_intUserNo", DBType.adInteger, userNo, 0, ParameterDirection.Input);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_INFO_AR_LST"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
                return strErrMsg;
            }

            DataTable dt = objDas.objDT;
            DataRow row = dt.Rows[0];

            userId = row["userId"].ToString();
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

        return userId;
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 캐시 지급
    /// </summary>
    ///----------------------------------------------------------------------
    protected void btnIns_Click(object sender, EventArgs e)
    {
        int    intRetVal     = 0;
        BOQv7Das_Net.IDas objDas = null;

        string strErrMsg   = string.Empty;

        
        try {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;


            objDas.AddParam("@pi_intOrderNo",       DBType.adInteger,       0,                              0,              ParameterDirection.Input);
            objDas.AddParam("@pi_strUserId",        DBType.adVarChar,       userId,                         20,             ParameterDirection.Input);
            objDas.AddParam("@pi_intAmount",        DBType.adInteger,       Convert.ToInt32((amount.Text).Replace(",", "")),   0,              ParameterDirection.Input);
            objDas.AddParam("@pi_strTId",           DBType.adVarWChar,      detail.Text,                    256,            ParameterDirection.Input);
            objDas.AddParam("@pi_strAdminId",       DBType.adVarChar,       Session["adminId"],             20,             ParameterDirection.Input);

            objDas.AddParam("@pi_intOriginChargeNo",DBType.adInteger,       0,                              0,              ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,              ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,                   256,            ParameterDirection.Output);
            

            objDas.SetQuery("dbo.UP_CHARGE_NT_INS"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
            }

            Response.Write("<script>alert('지급되었습니다.');</script>");
            Response.Write("<script>window.opener.fnAfterCachMng('" + userNo + "');</script>");
            Response.Write("<script>window.close();</script>");

        }
        catch
        {
            Response.Write("<script>alert('지급 실패 하였습니다.')</script>");

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

    ///----------------------------------------------------------------------
    /// <summary>
    /// 캐시 회수
    /// </summary>
    ///----------------------------------------------------------------------
    protected void btnCnl_Click(object sender, EventArgs e)
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

            if( balance < Convert.ToInt32((amount.Text).Replace(",", ""))) { 
                Response.Write("<script>alert('캐시가 부족합니다.');</script>");
                return;
            }

            objDas.AddParam("@pi_intChargeNo",          DBType.adBigInt,        chargeNo,                       0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strUserId",            DBType.adVarChar,       userId,                         20,         ParameterDirection.Input);
            objDas.AddParam("@pi_intAmount",            DBType.adInteger,       Convert.ToInt32((amount.Text).Replace(",", "")),   0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strAdminId",           DBType.adVarChar,       Session["adminId"],             20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strMemoDetail",        DBType.adVarWChar,      detail.Text,                    20,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,       DBNull.Value,                   0,          ParameterDirection.Output);

            objDas.AddParam("@po_strMsg",               DBType.adVarChar,       DBNull.Value,                   256,        ParameterDirection.Output);
            
            objDas.SetQuery("dbo.UP_CHARGE_NT_CNL"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
            }

            Response.Write("<script>alert('회수되었습니다.');</script>");
            Response.Write("<script>window.opener.fnAfterCachMng('" + userNo.ToString() + "');</script>");
            Response.Write("<script>window.close();</script>");

        }
        catch
        {
            Response.Write("<script>alert('회수 실패 하였습니다.')</script>");

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
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqParam
    {
        public int intUserNo { get; set; }


    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 응답 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ResParam
    {
        public DataTable objDT { get; set; }
        public int intRetVal { get; set; }
        public string strErrMsg { get; set; }
        public int intCheckVal { get; set; }
        public int intUserNo { get; set; }

        public int intStatus { get; set; }
        public int intRecordCnt { get; set; }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}