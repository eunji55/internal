<%@ WebHandler Language="C#" Class="UserHandler" %>

using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;
using System.Net;
using System.Web.UI;

public class UserHandler : IHttpHandler
{

    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8

    public Int64 purchaseNo = 0;
    public string pgcode = "";
    public string userId = "";
    public string tid = "";
    public int amount = 0;
    public int cnlAmount = 0;

    public int cnlChargeAmount = 0;
    public int cnlCashAmount = 0;
    public int cnlBonus = 0;

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

            Log(objReqParam.strMethod);

            if (objReqParam.strMethod.Equals("UserList"))
            {
                //DB 조회
                intRetVal = getUserList(objReqParam, out objResParam, out strErrMsg);

                return;

            }
            else if (objReqParam.strMethod.Equals("UserIdCheck"))
            {
                objResParam = userIdCheck(objReqParam);

                return;
            }
            else if(objReqParam.strMethod.Equals("UserIns"))
            {
                intRetVal = userIns(objReqParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("UserDetail"))
            {
                intRetVal = getUserDetail(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("UserUpd"))
            {
                intRetVal = userUpd(objReqParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("ChargeList"))
            {
                intRetVal = getChargeList(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("ChargeDetail"))
            {
                intRetVal = getChargeDetail(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("PurchaseList"))
            {
                intRetVal = getPurchaseList(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("PurchaseDetail"))
            {
                intRetVal = getPurchaseDetail(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("CancelPurchase"))
            {
                int intCnlType = getPurchaseDetail(objReqParam, out objResParam, out strErrMsg);

                if (intCnlType == 0)
                {
                    cancelPurchase();
                }
                else
                {
                    //플래그에 따라 전체인지 부분인지 if
                    cancelPayment(intCnlType);
                }

                return;
            }
            else{
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
        }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 사용자 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getUserList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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
            objDas.SetQuery("dbo.UP_ADMIN_USER_AR_LST"); //Execute Query 

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
    /// 아이디 중복 체크
    /// </summary>
    ///----------------------------------------------------------------------
    private ResParam userIdCheck(ReqParam objReqParam)
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

            objDas.AddParam("@pi_strUserId",         DBType.adVarChar,      objReqParam.strUserId,          20,        ParameterDirection.Input);
            objDas.AddParam("@po_intCheckVal",       DBType.adInteger,      DBNull.Value,                   0,         ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_ID_NT_CHK"); //Execute Query 

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
    /// 사용자 등록
    /// </summary>
    ///----------------------------------------------------------------------
    private int userIns(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_strUserId",    DBType.adVarChar,       objReqParam.strUserId,      20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strUserPw",    DBType.adVarChar,       objReqParam.strUserPw,      40,         ParameterDirection.Input);
            objDas.AddParam("@pi_strName",      DBType.adVarWChar,      objReqParam.strName,        20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strBirth",     DBType.adVarChar,       objReqParam.strBirth,       20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strSex",       DBType.adChar,          objReqParam.strSex,         1,          ParameterDirection.Input);

            objDas.AddParam("@pi_strPhone",     DBType.adVarChar,       objReqParam.strPhone,       15,         ParameterDirection.Input);
            objDas.AddParam("@pi_strEmail",     DBType.adVarChar,       objReqParam.strEmail,       40,         ParameterDirection.Input);
            objDas.AddParam("@pi_strPostcode",  DBType.adVarChar,       objReqParam.strPostcode,    10,         ParameterDirection.Input);
            objDas.AddParam("@pi_strAddress1",  DBType.adVarWChar,      objReqParam.strAddress1,    50,         ParameterDirection.Input);
            objDas.AddParam("@pi_strAddress2",  DBType.adVarWChar,      objReqParam.strAddress2,    50,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",    DBType.adInteger,       DBNull.Value,                0,         ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",       DBType.adVarChar,       DBNull.Value,               256,        ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_USER_TX_INS"); //Execute Query 

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
    /// 사용자 상세보기
    /// </summary>
    ///----------------------------------------------------------------------
    private int getUserDetail(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intUserNo",        DBType.adInteger,       objReqParam.intUserNo,          0,      ParameterDirection.Input);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_USER_DTL_AR_LST"); //Execute Query 

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
    /// 사용자 수정
    /// </summary>
    ///----------------------------------------------------------------------
    private int userUpd(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intUserNo",    DBType.adVarChar,       objReqParam.intUserNo,       0,         ParameterDirection.Input);
            objDas.AddParam("@pi_strName",      DBType.adVarWChar,      objReqParam.strName,        20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strBirth",     DBType.adVarChar,       objReqParam.strBirth,       20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strSex",       DBType.adChar,          objReqParam.strSex,         1,          ParameterDirection.Input);

            objDas.AddParam("@pi_strPhone",     DBType.adVarChar,       objReqParam.strPhone,       15,         ParameterDirection.Input);
            objDas.AddParam("@pi_strEmail",     DBType.adVarChar,       objReqParam.strEmail,       40,         ParameterDirection.Input);
            objDas.AddParam("@pi_intStatus",    DBType.adInteger,       objReqParam.intStatus,       0,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",    DBType.adInteger,       DBNull.Value,                0,         ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",       DBType.adVarChar,       DBNull.Value,               256,        ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_ADMIN_USER_TX_UPD"); //Execute Query 

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
    /// 충전 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
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

            objDas.AddParam("@pi_strUserId",            DBType.adVarChar,       objReqParam.strUserId,          20,     ParameterDirection.Input);
            objDas.AddParam("@pi_strSearchFromDate",    DBType.adDate,          objReqParam.strSearchFromDate,  0,      ParameterDirection.Input);
            objDas.AddParam("@pi_strSearchToDate",      DBType.adDate,          objReqParam.strSearchToDate,    0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intType",              DBType.adInteger,       objReqParam.intType,            0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intStatus",            DBType.adInteger,       objReqParam.intStatus,          0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intPageSize",          DBType.adInteger,       objReqParam.intPageSize,        5,      ParameterDirection.Input);
            objDas.AddParam("@pi_intPageNo",            DBType.adInteger,       objReqParam.intPageNo,          0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_CHARGE_AR_LST"); //Execute Query 

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
    /// 충전 상세 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getChargeDetail(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
    {
        int intRetVal = 0;

        BOQv7Das_Net.IDas objDas = null;

        objResParam = null;
        strErrMsg = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;

            objDas.AddParam("@pi_intChargeNo",      DBType.adBigInt,        objReqParam.intChargeNo,        0,      ParameterDirection.Input);
            objDas.AddParam("@po_strUserId",        DBType.adVarChar,       DBNull.Value,                   20,     ParameterDirection.Output);
            objDas.AddParam("@po_intAmount",        DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intType",          DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_strAdminId",       DBType.adVarChar,       DBNull.Value,                   20,     ParameterDirection.Output);

            objDas.AddParam("@po_strRegDate",       DBType.adVarChar,       DBNull.Value,                   100,      ParameterDirection.Output);
            objDas.AddParam("@po_strMethod",        DBType.adVarChar,       DBNull.Value,                   20,     ParameterDirection.Output);
            objDas.AddParam("@po_intCnlAmount",     DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intBalance",       DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intStatus",        DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,                   256,    ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_CHARGE_DTL_AR_LST"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
                return intRetVal;
            }

            objResParam = new ResParam();

            objResParam.strUserId    = objDas.GetParam("@po_strUserId");
            objResParam.intAmount    = Convert.ToInt32(objDas.GetParam("@po_intAmount"));
            objResParam.intType      = Convert.ToInt32(objDas.GetParam("@po_intType"));
            objResParam.strAdminId   = objDas.GetParam("@po_strAdminId");

            objResParam.strRegDate   = objDas.GetParam("@po_strRegDate");
            objResParam.strMethod    = objDas.GetParam("@po_strMethod");
            objResParam.intCnlAmount = Convert.ToInt32(objDas.GetParam("@po_intCnlAmount"));
            objResParam.intBalance   = Convert.ToInt32(objDas.GetParam("@po_intBalance"));
            objResParam.intStatus    = Convert.ToInt32(objDas.GetParam("@po_intStatus"));

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
    /// 구매 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getPurchaseList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_strUserId",            DBType.adVarChar,       objReqParam.strUserId,          20,     ParameterDirection.Input);
            objDas.AddParam("@pi_strSearchFromDate",    DBType.adVarChar,       objReqParam.strSearchFromDate,  100,    ParameterDirection.Input);
            objDas.AddParam("@pi_strSearchToDate",      DBType.adVarChar,       objReqParam.strSearchToDate,    100,    ParameterDirection.Input);
            objDas.AddParam("@pi_intStatus",            DBType.adInteger,       objReqParam.intStatus,          0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intPageSize",          DBType.adInteger,       objReqParam.intPageSize,        5,      ParameterDirection.Input);
            objDas.AddParam("@pi_intPageNo",            DBType.adInteger,       objReqParam.intPageNo,          0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_PURCHASE_AR_LST"); //Execute Query 

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
    /// 구매 상세 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getPurchaseDetail(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
    {
        int intRetVal = 0;
        int intCnlType = 0;

        BOQv7Das_Net.IDas objDas = null;

        objResParam = null;
        strErrMsg = string.Empty;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;

            objDas.AddParam("@pi_intPurchaseNo",        DBType.adBigInt,        objReqParam.intPurchaseNo,      0,      ParameterDirection.Input);
            objDas.AddParam("@po_intChargeNo",          DBType.adBigInt,        DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intAmount",            DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intBalance",           DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intStatus",            DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            objDas.AddParam("@po_intCnlChargeAmount",   DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intCnlCashAmount",     DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intCnlBonus",          DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",               DBType.adVarChar,       DBNull.Value,                   256,    ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_PURCHASE_DTL_AR_LST"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
                return intRetVal;
            }

            objResParam = new ResParam();

            objResParam.intChargeNo         = Convert.ToInt64(objDas.GetParam("@po_intChargeNo"));
            objResParam.intAmount           = Convert.ToInt32(objDas.GetParam("@po_intAmount"));
            objResParam.intBalance          = Convert.ToInt32(objDas.GetParam("@po_intBalance"));
            objResParam.intStatus           = Convert.ToInt32(objDas.GetParam("@po_intStatus"));
            objResParam.intCnlChargeAmount = Convert.ToInt32(objDas.GetParam("@po_intCnlChargeAmount"));
            objResParam.intCnlCashAmount   = Convert.ToInt32(objDas.GetParam("@po_intCnlCashAmount"));
            objResParam.intCnlBonus        = Convert.ToInt32(objDas.GetParam("@po_intCnlBonus"));

            cnlChargeAmount = Convert.ToInt32(objDas.GetParam("@po_intCnlChargeAmount"));
            cnlCashAmount   = Convert.ToInt32(objDas.GetParam("@po_intCnlCashAmount"));
            cnlBonus        = Convert.ToInt32(objDas.GetParam("@po_intCnlBonus"));



            objResParam.objDT     = objDas.objDT;
            purchaseNo = objReqParam.intPurchaseNo;

            foreach (DataRow row in objDas.objDT.Rows)
            {
                userId = row["USERID"].ToString();

                if (Convert.ToInt16(row["TYPE2"]).Equals(1))
                {
                    amount = Convert.ToInt32(row["AMOUNT"]);
                    cnlAmount = Convert.ToInt32(row["AMOUNT2"]); //취소할 금액
                    tid = row["TID"].ToString();
                    pgcode = row["METHOD"].ToString();
                }

                //취소 실금액 없을때
                if (cnlAmount == 0)
                {
                    intCnlType = 0;
                }
                //amount2가 cnlChargeAmount랑 같으면 전체취소
                else if (cnlAmount == cnlChargeAmount)
                {
                    intCnlType = 1;
                }
                else
                {
                    intCnlType = 2;
                }
            }

            Log(objDas.GetParam("@po_intChargeNo").ToString());

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

        return intCnlType;
    }



    ///----------------------------------------------------------------------
    /// <summary>
    /// PG 결제 취소
    /// </summary>
    ///----------------------------------------------------------------------
    private int cancelPayment(int intCnlType)
    {
        int returnVal = 0;
        string url = "";

        if(intCnlType == 1) //전체취소
        {
            url = "https://testpgapi.payletter.com/v1.0/payments/cancel";
        }
        else if(intCnlType == 2) //부분취소
        {
            url = "https://testpgapi.payletter.com/v1.0/payments/cancel/partial";
        }

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

        request.Method = "POST";
        request.ContentType = "application/json";
        request.Headers.Add("Authorization", "PLKEY NUQyQ0RGNTBEODQ5NTg4OTc1MEQyNTdCRjY5NTRFNjg=");

        using (var sw = new StreamWriter(request.GetRequestStream()))
        {
            string json = "{\"pgcode\" : \"" + pgcode + "\"," +
                            "\"user_id\":\"" + userId + "\"," +
                            "\"client_id\":\"testintern\"," +
                            "\"amount\":" + cnlChargeAmount + "," +
                            "\"tid\":\"" + tid + "\"," +
                            "\"ip_addr\":\"127.0.0.1\"}";

            sw.Write(json);
            sw.Flush();
            sw.Close();

            Log(json);
        }

        var response = (HttpWebResponse)request.GetResponse();
        using (var streamReader = new StreamReader(response.GetResponseStream()))
        {
            var result = streamReader.ReadToEnd();

            jsonVal jv = new jsonVal();
            jv = JsonConvert.DeserializeObject<jsonVal>(result);

            if ((jv.code).Equals(null))
            {
                returnVal = jv.code;
                return returnVal;
            }else {

                cancelPurchase();
            }
        }

        return returnVal;
    }


    ///----------------------------------------------------------------------
    /// <summary>
    /// 결제 취소
    /// </summary>
    ///----------------------------------------------------------------------
    private int cancelPurchase()
    {
        int intRetVal = 0;
        string strErrMsg = string.Empty;

        BOQv7Das_Net.IDas objDas = null;

        try
        {
            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;

            objDas.AddParam("@pi_intPurchaseNo",        DBType.adBigInt,        purchaseNo,                 0,      ParameterDirection.Input);
            objDas.AddParam("@pi_strUserId",            DBType.adVarChar,       userId,                     20,     ParameterDirection.Input);
            objDas.AddParam("@pi_intCnlChargeAmount",   DBType.adInteger,       cnlChargeAmount,            0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intCnlCashAmount",     DBType.adInteger,       cnlCashAmount,              0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intCnlBonus",          DBType.adInteger,       cnlBonus,                   0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",            DBType.adInteger,       DBNull.Value,               0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",               DBType.adVarChar,       DBNull.Value,               256,    ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_PURCHASE_TX_CNL"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
                return intRetVal;
            }

            intRetVal = Convert.ToInt32(objDas.GetParam("@po_intRetVal"));

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
        public string   tid           { get; set; }
        public string   cid           { get; set; }
        public int      amount        { get; set; }
        public string   cancel_date   { get; set; }
        public int      code          { get; set; }
        public string   message       { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqParam
    {
        public string   strMethod           { get; set; }
        public int      intPageNo           { get; set; }
        public int      intPageSize         { get; set; }

        public int      intSearchType       { get; set; }
        public string   strSearchId         { get; set; }

        public string   strUserId           { get; set; }
        public string   strUserPw           { get; set; }
        public int      intUserNo           { get; set; }
        public string   strName             { get; set; }
        public string   strBirth            { get; set; }

        public string   strSex              { get; set; }
        public string   strPhone            { get; set; }
        public string   strEmail            { get; set; }
        public string   strPostcode         { get; set; }
        public string   strAddress1         { get; set; }

        public string   strAddress2         { get; set; }
        public int      intStatus           { get; set; }
        public string   strSearchFromDate   { get; set; }
        public string   strSearchToDate     { get; set; }
        public int      intType             { get; set; }

        public Int64    intChargeNo         { get; set; }
        public Int64    intPurchaseNo       { get; set; }
        public string   strTid              { get; set; }
        public int      intAmount           { get; set; }
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
        public string    strUserId      { get; set; }
        public int       intAmount      { get; set; }
        public int       intType        { get; set; }
        public string    strAdminId     { get; set; }

        public string    strRegDate     { get; set; }
        public string    strMethod      { get; set; }
        public int       intCnlAmount   { get; set; }
        public int       intBalance     { get; set; }
        public int       intStatus      { get; set; }

        public Int64     intChargeNo         { get; set; }
        public int       intCnlChargeAmount      { get; set; }
        public int       intCnlCashAmount      { get; set; }
        public int       intCnlBonus      { get; set; }
    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}