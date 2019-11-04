<%@ WebHandler Language="C#" Class="SampleHandler" %>

using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;

public class SampleHandler : IHttpHandler
{

    public void ProcessRequest (HttpContext objContext)
    {
        HttpRequest  pl_objRequest    = null;
        HttpResponse pl_objResponse   = null;
        ReqParam     pl_objReqParam   = null;
        ResParam     pl_objResParam   = null;

        int          pl_intRetVal     = 0;
        string       pl_strErrMsg     = string.Empty;
        string       pl_strJsonResult = string.Empty;
        string       pl_strReqParam   = string.Empty;


        try
        {
            objContext.Response.ContentType     = "text/json";
            objContext.Response.ContentEncoding = Encoding.UTF8;
            pl_objRequest                       = objContext.Request;
            pl_objResponse                      = objContext.Response;
            pl_objReqParam                      = new ReqParam();
            pl_objResParam                      = new ResParam();

            /*
            using (StreamReader objSR = new StreamReader(pl_objRequest.InputStream))
            {
                pl_strReqParam = objSR.ReadToEnd();
                pl_objReqParam = JsonConvert.DeserializeObject<ReqParam>(pl_strReqParam);
            }
            */

            pl_strReqParam = new StreamReader(pl_objRequest.InputStream).ReadToEnd();
            pl_objReqParam = JsonConvert.DeserializeObject<ReqParam>(pl_strReqParam);

            if (pl_objReqParam.strMethod.Equals("List"))
            {
                //DB 조회
                pl_intRetVal = DisplayData(pl_objReqParam, out pl_objResParam, out pl_strErrMsg);
                return;
            }
            else if (pl_objReqParam.strMethod.Equals("Detail"))
            {
                //DB 조회
                pl_intRetVal = DisplayData(pl_objReqParam, out pl_objResParam, out pl_strErrMsg);
                return;
            }
            else
            {
                pl_intRetVal = 99999;
                pl_strErrMsg = "잘못된 메소드";
                return;
            }
        }
        catch
        {
        }
        finally
        {
            pl_objResParam.intRetVal = pl_intRetVal;
            pl_objResParam.strErrMsg = pl_strErrMsg;

            // JSON 결과 리턴
            pl_strJsonResult = JsonConvert.SerializeObject(pl_objResParam);
            pl_objResponse.Write(pl_strJsonResult);

            pl_objReqParam = null;
            pl_objRequest  = null;
            pl_objResponse = null;
            pl_objResParam = null;
        }

        return;
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 리스트 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int DisplayData(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
    {
        int    pl_intRetVal     = 0;
        int    pl_intPageNo     = 1;
        int    pl_intPageSize   = 20;

        BOQv7Das_Net.IDas pl_objDas = null;

        objResParam = null;
        strErrMsg   = string.Empty;

        try
        {
            pl_objDas = new BOQv7Das_Net.IDas();

            pl_objDas.Open("10.10.120.20:33333");
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage    = 65001;

            pl_objDas.AddParam("@pi_intUserNo",    DBType.adInteger,  objReqParam.intUserNo,    0,  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strUserID",    DBType.adVarChar,  DBNull.Value,             50, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strUserName",  DBType.adVarWChar, DBNull.Value,             50, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intPageSize",  DBType.adInteger,  pl_intPageSize,           0,  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intPageNo",    DBType.adInteger,  pl_intPageNo,             0,  ParameterDirection.Input);

            pl_objDas.AddParam("@po_intRecordCnt", DBType.adInteger,  DBNull.Value,             0,  ParameterDirection.Output);

            //프로시져 호출
            pl_objDas.SetQuery("dbo.UP_USER_UR_LST"); //Execute Query 

            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }

            objResParam = new ResParam();
            objResParam.intRecodeCnt = Convert.ToInt32(pl_objDas.GetParam("@po_intRecordCnt"));
            objResParam.objDT     = pl_objDas.objDT;
        }
        catch
        {
        }
        finally
        {
            //Close
            if (pl_objDas != null)
            {
                pl_objDas.Close();
                pl_objDas = null;
            }
        }

        return pl_intRetVal;
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqParam
    {
        public string    strMethod      { get; set; }
        public int       intUserNo      { get; set; }
        public string    strUserId      { get; set; }
        public string    strUserName    { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 응답 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ResParam
    {
        public DataTable objDT          { get; set; }
        public int       intRecodeCnt   { get; set; }
        public int       intRetVal      { get; set; }
        public string    strErrMsg      { get; set; }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}