<%@ WebHandler Language="C#" Class="CategoryHandler" %>

using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;

public class CategoryHandler : IHttpHandler {
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8

    public void ProcessRequest (HttpContext context)
    {
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

            if (objReqParam.strMethod.Equals("CategoryList"))
            {

                intRetVal = getCategoryList(objReqParam,out objResParam, out strErrMsg);
                return;

            } else if (objReqParam.strMethod.Equals("CategoryNameCheck"))
            {
                objResParam = categoryNameCheck(objReqParam);
                return;

            } else if (objReqParam.strMethod.Equals("CategoryIns"))
            {
                intRetVal = categoryIns(objReqParam,out strErrMsg);
                return;

            } else if (objReqParam.strMethod.Equals("CategoryDetail"))
            {
                intRetVal = getCategoryDetail(objReqParam,out objResParam, out strErrMsg);
                return;
            } else if (objReqParam.strMethod.Equals("CategoryUpd"))
            {
                intRetVal = categoryUpd(objReqParam, out strErrMsg);
                return;
            } else if (objReqParam.strMethod.Equals("CategoryDel"))
            {
                intRetVal = categoryDel(objReqParam, out strErrMsg);
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
    /// 카테고리 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getCategoryList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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
            objDas.SetQuery("dbo.UP_CATEGORY_AR_LST"); //Execute Query 

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
    /// 카테고리명 중복 체크
    /// </summary>
    ///----------------------------------------------------------------------
    private ResParam categoryNameCheck(ReqParam objReqParam)
    {

        ResParam          objResParam    = null;
        BOQv7Das_Net.IDas objDas         = null;

        try
        {
            objResParam = new ResParam();
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage    = DAS_CODEPAGE;

            objDas.AddParam("@pi_strCategoryName",      DBType.adVarWChar,      objReqParam.strCategoryName,    20,        ParameterDirection.Input);
            objDas.AddParam("@po_intCheckVal",          DBType.adInteger,       DBNull.Value,                   0,         ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_CATEGORY_NAME_NT_CHK"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                objResParam.intRetVal = objDas.LastErrorCode;
                objResParam.strErrMsg = objDas.LastErrorMessage;
                return objResParam;
            }

            objResParam.intRetVal = 0;
            objResParam.strErrMsg = "OK";
            objResParam.intCheckVal = Convert.ToInt32(objDas.GetParam("@po_intCheckVal"));

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

        return objResParam;
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 카테고리 등록
    /// </summary>
    ///----------------------------------------------------------------------
    private int categoryIns(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_strCategoryName",      DBType.adVarWChar,       objReqParam.strCategoryName,    20,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,        DBNull.Value,                   0,          ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",               DBType.adVarChar,        DBNull.Value,                   256,        ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_CATEGORY_TX_INS"); //Execute Query 

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
    /// 상세보기
    /// </summary>
    ///----------------------------------------------------------------------
    private int getCategoryDetail(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intCategoryNo",        DBType.adInteger,       objReqParam.intCategoryNo,          0,      ParameterDirection.Input);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_CATEGORY_DTL_AR_LST"); //Execute Query 

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
    /// 카테고리 수정
    /// </summary>
    ///----------------------------------------------------------------------
    private int categoryUpd(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intCategoryNo",        DBType.adInteger,       objReqParam.intCategoryNo,          0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strCategoryName",      DBType.adVarWChar,      objReqParam.strCategoryName,        20,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,       DBNull.Value,                       0,          ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",               DBType.adVarChar,       DBNull.Value,                       256,        ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_CATEGORY_TX_UPD"); //Execute Query 

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
    /// 카테고리 삭제
    /// </summary>
    ///----------------------------------------------------------------------
    private int categoryDel(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intCategoryNo",        DBType.adInteger,       objReqParam.intCategoryNo,          0,          ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,       DBNull.Value,                       0,          ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",               DBType.adVarChar,       DBNull.Value,                       256,        ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_CATEGORY_TX_DEL"); //Execute Query 

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
        public string   strCategoryName { get; set; }
        public int      intCategoryNo   { get; set; }


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
        public int intCheckVal { get; set; }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}