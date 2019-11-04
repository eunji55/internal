<%@ WebHandler Language="C#" Class="AdminHandler" %>


using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;
using System.Web.SessionState;

public class AdminHandler : IHttpHandler, IRequiresSessionState
{

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

            if (objReqParam.strMethod.Equals("LogIn"))
            {
                objResParam = loginCheck(objReqParam);

                if(objResParam.intCheckVal == 0)
                {
                    context.Session["adminId"] = objReqParam.strAdminId;
                    context.Session["adminPw"] = objReqParam.strAdminPw;
                    context.Session["adminNo"] = objResParam.intAdminNo;
                    context.Session["authNo"] = objResParam.intAuthNo;

                    context.Session.Timeout = 120;
                }

                return;
            }
            else if (objReqParam.strMethod.Equals("LogOut"))
            {
                context.Session.Abandon();
                return;
            }
            else if (objReqParam.strMethod.Equals("AdminList"))
            {
                //DB 조회
                intRetVal = getAdminList(objReqParam, out objResParam, out strErrMsg);

                return;

            }
            else if (objReqParam.strMethod.Equals("AdminIns"))
            {
                intRetVal = adminIns(objReqParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("AdminIdCheck"))
            {
                objResParam = adminIdCheck(objReqParam);

                return;
            }
            else if (objReqParam.strMethod.Equals("AdminDetail"))
            {
                intRetVal = getAdminDetail(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("AdminUpd"))
            {
                intRetVal = adminUpd(objReqParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("AuthMenuList"))
            {
                intRetVal = getAuthMenuList(objReqParam, out objResParam, out strErrMsg);

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
    /// 관리자 로그인 체크
    /// </summary>
    ///----------------------------------------------------------------------
    private ResParam loginCheck(ReqParam objReqParam)
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

            objDas.AddParam("@pi_strAdminId",         DBType.adVarChar,      objReqParam.strAdminId,            20,        ParameterDirection.Input);
            objDas.AddParam("@pi_strAdminPw",         DBType.adVarChar,      objReqParam.strAdminPw,            40,        ParameterDirection.Input);
            objDas.AddParam("@po_intAdminNo",         DBType.adInteger,      DBNull.Value,                      0,         ParameterDirection.Output);
            objDas.AddParam("@po_intAuthNo",          DBType.adInteger,      DBNull.Value,                      0,         ParameterDirection.Output);
            objDas.AddParam("@po_intCheckVal",        DBType.adInteger,      DBNull.Value,                      0,         ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_LOGIN_NT_CHK"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                objResParam.intRetVal = objDas.LastErrorCode;
                objResParam.strErrMsg = objDas.LastErrorMessage;
                return objResParam;
            }

            objResParam.intRetVal = 0;
            objResParam.strErrMsg = "OK";
            objResParam.intAdminNo = Convert.ToInt16(objDas.GetParam("@po_intAdminNo"));
            objResParam.intAuthNo = Convert.ToInt16(objDas.GetParam("@po_intAuthNo"));
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
    /// 관리자 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getAdminList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intSearchType",    DBType.adInteger,       objReqParam.intSearchType,      0,     ParameterDirection.Input);
            objDas.AddParam("@pi_strSearchId",      DBType.adVarWChar,      objReqParam.strSearchId,        20,     ParameterDirection.Input);
            objDas.AddParam("@pi_intPageSize",      DBType.adInteger,       objReqParam.intPageSize,        0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intPageNo",        DBType.adInteger,       objReqParam.intPageNo,          0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_AR_LST"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
                return intRetVal;
            }

            objResParam = new ResParam();
            objResParam.intRecordCnt = Convert.ToInt32(objDas.GetParam("@po_intRecordCnt"));
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
    /// 관리자 등록
    /// </summary>
    ///----------------------------------------------------------------------
    private int adminIns(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_strAdminId",   DBType.adVarChar,       objReqParam.strAdminId,         20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strAdminPw",   DBType.adVarChar,       objReqParam.strAdminPw,         40,         ParameterDirection.Input);
            objDas.AddParam("@pi_intAuthNo",    DBType.adInteger,       objReqParam.intAuthNo,          0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strName",      DBType.adVarWChar,       objReqParam.strName,            20,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",    DBType.adInteger,       DBNull.Value,                   0,          ParameterDirection.Output);

            objDas.AddParam("@po_strMsg",       DBType.adVarChar,       DBNull.Value,                   256,        ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_TX_INS"); //Execute Query 

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
    /// 아이디 중복 체크
    /// </summary>
    ///----------------------------------------------------------------------
    private ResParam adminIdCheck(ReqParam objReqParam)
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

            objDas.AddParam("@pi_strAdminId",         DBType.adVarChar,      objReqParam.strAdminId,          20,        ParameterDirection.Input);
            objDas.AddParam("@po_intCheckVal",       DBType.adInteger,      DBNull.Value,                   0,         ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_ID_NT_CHK"); //Execute Query 

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
    /// 상세보기
    /// </summary>
    ///----------------------------------------------------------------------
    private int getAdminDetail(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intAdminNo",        DBType.adInteger,       objReqParam.intAdminNo,          0,      ParameterDirection.Input);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_DTL_AR_LST"); //Execute Query 

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
    /// 관리자 수정
    /// </summary>
    ///----------------------------------------------------------------------
    private int adminUpd(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intAdminNo",        DBType.adInteger,       objReqParam.intAdminNo,          0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strAdminPw",        DBType.adVarChar,       objReqParam.strAdminPw,          40,         ParameterDirection.Input);
            objDas.AddParam("@pi_strName",          DBType.adVarWChar,      objReqParam.strName,            20,         ParameterDirection.Input);
            objDas.AddParam("@pi_intAuthNo",         DBType.adInteger,       objReqParam.intAuthNo,           0,         ParameterDirection.Input);

            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,          ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,                   256,          ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_TX_UPD"); //Execute Query 

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
    /// 관리자 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getAuthMenuList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intAuthNo",    DBType.adInteger,       objReqParam.intAuthNo,      0,     ParameterDirection.Input);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_AUTH_AR_LST"); //Execute Query 

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

        public int      intAdminNo      { get; set; }
        public string   strAdminId      { get; set; }
        public string   strAdminPw      { get; set; }
        public int      intAuthNo       { get; set; }
        public string   strName         { get; set; }
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
        public int       intCheckVal    { get; set; }

        public int       intAdminNo     { get; set; }
        public int       intAuthNo      { get; set; }
    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}