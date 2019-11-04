<%@ WebHandler Language="C#" Class="HomeHandler" %>

using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;
using System.Net;
using System.Web.UI;

public class HomeHandler : IHttpHandler {

    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8

    public void ProcessRequest (HttpContext context) {
        ReqParam     objReqParam   = null;
        ResParam     objResParam   = null;

        int          intRetVal     = 0;
        string       strErrMsg     = string.Empty;
        string       strJsonResult = string.Empty;
        string       strReqParam   = string.Empty;

        try
        {
            context.Response.ContentType     = "text/json";
            context.Response.ContentEncoding = Encoding.UTF8;
            objReqParam                      = new ReqParam();
            objResParam                      = new ResParam();

            //Json 형태 요청 param Object로 변환
            strReqParam = new StreamReader(context.Request.InputStream).ReadToEnd();
            objReqParam = JsonConvert.DeserializeObject<ReqParam>(strReqParam);

            getChargeList(objReqParam, out objResParam, out strErrMsg);

        }
        catch
        {
        }
        finally
        {
            objResParam.intRetVal = intRetVal;
            objResParam.strErrMsg = strErrMsg;

            // JSON 결과 리턴
            strJsonResult = JsonConvert.SerializeObject(objResParam);
            context.Response.Write(strJsonResult);

            objReqParam = null;
            objResParam = null;
        }

        return;
    }


    private int getChargeList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
    {
        int    intRetVal     = 0;

        BOQv7Das_Net.IDas objDas = null;

        objResParam = null;
        strErrMsg   = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage    = DAS_CODEPAGE;

            objDas.AddParam("@po_intOrderCnt",         DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intPurchaseCnt",         DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intDaySales",         DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_test"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
                return intRetVal;
            }

            objResParam = new ResParam();
            objResParam.objDT     = objDas.objDT;

            objResParam.intOrderCnt = Convert.ToInt32(objDas.GetParam("@po_intOrderCnt"));
            objResParam.intPurchaseCnt = Convert.ToInt32(objDas.GetParam("@po_intPurchaseCnt"));
            objResParam.intDaySales = Convert.ToInt32(objDas.GetParam("@po_intDaySales"));


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

    ///----------------------------------------------------------------------
    /// <summary>
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqParam
    {
        public string   strMethod           { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 응답 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ResParam
    {
        public DataTable objDT          { get; set; }
        public int intRetVal            { get; set; }
        public string strErrMsg         { get; set; }
        public int intOrderCnt          { get; set; }
        public int intPurchaseCnt       { get; set; }
        public int intDaySales { get; set; }

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}