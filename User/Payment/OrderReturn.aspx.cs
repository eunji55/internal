using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BOQv7Das_Net;
using System.Text;
using System.Data;
using Newtonsoft.Json;
using System.IO;
using System.Web.SessionState;

public partial class Item_OrderReturn : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8
    private int userNo = 0;
    private string tid = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        userNo = Convert.ToInt32(Session["userNo"]);


        if (Request.Form["code"] == "0")
        {
            userInfoGet(userNo);
        }
        else
        {
            Server.Transfer("../Item/ItemList.aspx", true);
        }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 회원정보 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private void userInfoGet(int userNo)
    {
        int intRetVal = 0;

        BOQv7Das_Net.IDas objDas = null;

        ResParam objResParam = null;
        string strErrMsg = string.Empty;

        int totalCash = 0;

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
            }

            objResParam = new ResParam();
            objResParam.objDT = objDas.objDT;
            DataRow row = objDas.objDT.Rows[0];
            totalCash = Convert.ToInt32(row["TOTALCASH"]);

            amount.Value = totalCash.ToString();


            Response.Write("<script>window.opener.fnOrderSuccess();</script>");
            Response.Write("<script>window.close();</script>");



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
    /// 응답 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ResParam
    {
        public DataTable objDT { get; set; }
        public int intRetVal { get; set; }
        public string strErrMsg { get; set; }
    }

}