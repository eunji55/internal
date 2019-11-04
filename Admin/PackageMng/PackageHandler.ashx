<%@ WebHandler Language="C#" Class="PackageHandler" %>

using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;

public class PackageHandler : IHttpHandler {


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

            if (objReqParam.strMethod.Equals("PackageList"))
            {
                intRetVal = getPackageList(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("PackageIns"))
            {
                intRetVal = packageIns(objReqParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("PackageDetail"))
            {
                intRetVal = getPackageDetail(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("PackageDel"))
            {
                intRetVal = packageDel(objReqParam, out strErrMsg);

                return;
            }

            else
            {
                intRetVal = 99999;
                strErrMsg = "잘못된 메소드";
                return;
            }
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

    ///----------------------------------------------------------------------
    /// <summary>
    /// 패키지 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getPackageList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            //프로시져 호출
            objDas.SetQuery("dbo.UP_PACKAGE_UR_LST"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
                return intRetVal;
            }

            objResParam = new ResParam();
            objResParam.objDT     = objDas.objDT;
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
    /// 패키지 등록
    /// </summary>
    ///----------------------------------------------------------------------
    private int packageIns(ReqParam objReqParam, out string strErrMsg)
    {

        int    intRetVal     = 0;
        BOQv7Das_Net.IDas objDas = null;

        strErrMsg   = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage    = DAS_CODEPAGE;

            objDas.AddParam("@pi_strName",              DBType.adVarWChar,      objReqParam.strName,                20,          ParameterDirection.Input);
            objDas.AddParam("@pi_intPrice",             DBType.adInteger,       objReqParam.intPrice,               0,           ParameterDirection.Input);
            objDas.AddParam("@pi_strItemList",          DBType.adVarChar,       objReqParam.strItemList,            300,         ParameterDirection.Input);
            objDas.AddParam("@pi_strPackImg",           DBType.adVarWChar,      null,                               100,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,       DBNull.Value,                       0,           ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",               DBType.adVarChar,       DBNull.Value,                       256,         ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_PACKAGE_TX_INS"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
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

    ///----------------------------------------------------------------------
    /// <summary>
    /// 패키지 상세 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getPackageDetail(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intPackNo",        DBType.adInteger,       objReqParam.intPackNo,      0,      ParameterDirection.Input);
            objDas.AddParam("@po_strPname",         DBType.adVarWChar,      DBNull.Value,               20,     ParameterDirection.Output);
            objDas.AddParam("@po_intPrice",         DBType.adInteger,       DBNull.Value,               0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_PACKAGE_DTL_UR_LST"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
                return intRetVal;
            }

            objResParam = new ResParam();
            objResParam.strPname = objDas.GetParam("@po_strPname");
            objResParam.intPrice = Convert.ToInt32(objDas.GetParam("@po_intPrice"));
            objResParam.objDT     = objDas.objDT;
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
    /// 패키지 삭제
    /// </summary>
    ///----------------------------------------------------------------------
    private int packageDel(ReqParam objReqParam, out string strErrMsg)
    {

        int    intRetVal     = 0;
        BOQv7Das_Net.IDas objDas = null;

        strErrMsg   = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage    = DAS_CODEPAGE;

            objDas.AddParam("@pi_intPackNo",            DBType.adInteger,      objReqParam.intPackNo,               0,           ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,       DBNull.Value,                       0,           ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",               DBType.adVarChar,       DBNull.Value,                       256,         ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_PACKAGE_TX_DEL"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
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

    ///----------------------------------------------------------------------
    /// <summary>
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqParam
    {
        public string   strMethod       { get; set; }
        public int      intPageNo       { get; set; }
        public int      intPageSize     { get; set; }
        public int      intSearchType   { get; set; }
        public string   strSearchId     { get; set; }

        public int      intItemNo       { get; set; }
        public string   strName         { get; set; }
        public int      intPrice        { get; set; }
        public string   strItemList     { get; set; }
        public int      intPackNo       { get; set; }


    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 응답 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ResParam
    {
        public DataTable objDT          { get; set; }
        public int       intRecordCnt   { get; set; }
        public int       intRetVal      { get; set; }
        public string    strErrMsg      { get; set; }
        public string    strPname       { get; set; }
        public int       intPrice       { get; set; }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}