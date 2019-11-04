<%@ WebHandler Language="C#" Class="MembershipHandler" %>

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

public class MembershipHandler : IHttpHandler, IRequiresSessionState {

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

            strReqParam = new StreamReader(context.Request.InputStream).ReadToEnd();
            objReqParam = JsonConvert.DeserializeObject<ReqParam>(strReqParam);

            if (objReqParam.strMethod.Equals("LogIn"))
            {
                objResParam = loginCheck(objReqParam);

                if(objResParam.intCheckVal == 0)
                {
                    context.Session["userNo"] = objResParam.intUserNo;
                    context.Session["userId"] = objReqParam.strUserId;
                    context.Session["userPw"] = objReqParam.strUserPw;

                    context.Session.Timeout = 120;
                }

                return;
            }
            else if (objReqParam.strMethod.Equals("Register"))
            {
                intRetVal = userRegister(objReqParam, out strErrMsg);
                return;
            }
            else if (objReqParam.strMethod.Equals("UserInfoGet"))
            {
                intRetVal = userInfoGet(objReqParam, out objResParam, out strErrMsg);
                return;
            }
            else if (objReqParam.strMethod.Equals("UserInfoUpd"))
            {
                intRetVal = userInfoUpd(objReqParam, out strErrMsg);
                return;
            }
            else if (objReqParam.strMethod.Equals("LogOut"))
            {
                context.Session.Abandon();
                return;
            }
            else if (objReqParam.strMethod.Equals("UserIdCheck"))
            {
                objResParam = userIdCheck(objReqParam);

                return;
            }
            else if (objReqParam.strMethod.Equals("UserPwUpd"))
            {
                intRetVal = userPwUpd(objReqParam, out strErrMsg);
                context.Session["userPw"] = objReqParam.strUserPw;
                return;
            }
            else if (objReqParam.strMethod.Equals("MsgList"))
            {
                intRetVal = getMsgList(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("MsgSend"))
            {
                intRetVal = msgSend(objReqParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("MsgDetail"))
            {
                intRetVal = getMsgDetail(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("MsgDel"))
            {
                intRetVal = msgDel(objReqParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("ChargeList"))
            {
                intRetVal = getChargeList(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else if (objReqParam.strMethod.Equals("PurchaseList"))
            {
                intRetVal = getPurchaseList(objReqParam, out objResParam, out strErrMsg);

                return;
            }
            else
            {
                intRetVal = 99999;
                strErrMsg = "잘못된 메소드";
                return;
            }

        }
        catch (Exception ex)
        {
            objResParam.intRetVal = 999;
            objResParam.strErrMsg = string.Format("{0}\n{1}", ex.Message, ex.Source);
        }
        finally
        {
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
    /// 로그인 체크
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

            objDas.AddParam("@pi_strUserId",         DBType.adVarChar,      objReqParam.strUserId,          20,        ParameterDirection.Input);
            objDas.AddParam("@pi_strUserPw",         DBType.adVarChar,      objReqParam.strUserPw,          40,        ParameterDirection.Input);
            objDas.AddParam("@po_intUserNo",         DBType.adInteger,      DBNull.Value,                   0,         ParameterDirection.Output);
            objDas.AddParam("@po_intStatus",         DBType.adInteger,      DBNull.Value,                   0,         ParameterDirection.Output);
            objDas.AddParam("@po_intCheckVal",       DBType.adInteger,      DBNull.Value,                   0,         ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_LOGIN_NT_CHK"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                objResParam.intRetVal = objDas.LastErrorCode;
                objResParam.strErrMsg = objDas.LastErrorMessage;
                return objResParam;
            }

            objResParam.intRetVal = 0;
            objResParam.strErrMsg = "OK";
            objResParam.intUserNo = Convert.ToInt16(objDas.GetParam("@po_intUserNo"));
            objResParam.intStatus = Convert.ToInt16(objDas.GetParam("@po_intStatus"));
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
    /// 회원가입
    /// </summary>
    ///----------------------------------------------------------------------
    private int userRegister(ReqParam objReqParam, out string strErrMsg)
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
            objDas.AddParam("@pi_strPostcode",  DBType.adVarChar,       objReqParam.strPostcode,     10,         ParameterDirection.Input);
            objDas.AddParam("@pi_strAddress1",  DBType.adVarWChar,      objReqParam.strAddress1,     50,         ParameterDirection.Input);
            objDas.AddParam("@pi_strAddress2",  DBType.adVarWChar,      objReqParam.strAddress2,     50,         ParameterDirection.Input);

            objDas.AddParam("@po_intRetVal",    DBType.adInteger,       DBNull.Value,               0,          ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",       DBType.adVarChar,       DBNull.Value,               256,        ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_TX_INS"); //Execute Query 

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
    /// 회원정보 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int userInfoGet(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intUserNo",    DBType.adInteger,       objReqParam.intUserNo,      0,     ParameterDirection.Input);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_INFO_AR_LST"); //Execute Query 

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
    /// 회원정보 수정
    /// </summary>
    ///----------------------------------------------------------------------
    private int userInfoUpd(ReqParam objReqParam, out string strErrMsg)
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



            objDas.AddParam("@pi_intUserNo",        DBType.adInteger,       objReqParam.intUserNo,          0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strName",          DBType.adVarWChar,      objReqParam.strName,            20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strBirth",         DBType.adVarChar,       objReqParam.strBirth,           20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strSex",           DBType.adChar,          objReqParam.strSex,             1,          ParameterDirection.Input);
            objDas.AddParam("@pi_strPhone",         DBType.adVarChar,       objReqParam.strPhone,           15,         ParameterDirection.Input);

            objDas.AddParam("@pi_strEmail",         DBType.adVarChar,       objReqParam.strEmail,           40,         ParameterDirection.Input);
            objDas.AddParam("@pi_strPostcode",      DBType.adVarChar,       objReqParam.strPostcode,        10,          ParameterDirection.Input);
            objDas.AddParam("@pi_strAddress1",      DBType.adVarWChar,      objReqParam.strAddress1,        50,         ParameterDirection.Input);
            objDas.AddParam("@pi_strAddress2",      DBType.adVarWChar,      objReqParam.strAddress2,        50,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,          ParameterDirection.Output);

            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,                   256,          ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_INFO_TX_UPD"); //Execute Query 

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
    /// 비밀번호 변경
    /// </summary>
    ///----------------------------------------------------------------------
    private int userPwUpd(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intUserNo",        DBType.adInteger,       objReqParam.intUserNo,          0,          ParameterDirection.Input);
            objDas.AddParam("@pi_strUserPw",        DBType.adVarChar,       objReqParam.strUserPw,          40,         ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,          ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,                   256,          ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_USER_PW_TX_UPD"); //Execute Query 

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
    /// 쪽지 리스트 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getMsgList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intInOutType",     DBType.adInteger,       objReqParam.intInOutType,        0,      ParameterDirection.Input);
            objDas.AddParam("@pi_strUserId",        DBType.adVarChar,       objReqParam.strUserId,          20,     ParameterDirection.Input);
            objDas.AddParam("@pi_intPageSize",      DBType.adInteger,       objReqParam.intPageSize,        5,      ParameterDirection.Input);
            objDas.AddParam("@pi_intPageNo",        DBType.adInteger,       objReqParam.intPageNo,          0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_MSG_UR_LST"); //Execute Query 

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
    /// 쪽지보내기
    /// </summary>
    ///----------------------------------------------------------------------
    private int msgSend(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_strSender",        DBType.adVarChar,       objReqParam.strSender,          20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strReceiver",      DBType.adVarChar,       objReqParam.strReceiver,        20,         ParameterDirection.Input);
            objDas.AddParam("@pi_strTitle",         DBType.adVarWChar,      objReqParam.strTitle,           50,         ParameterDirection.Input);
            objDas.AddParam("@pi_strContent",       DBType.adVarWChar,      objReqParam.strContent,         255,        ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,          ParameterDirection.Output);

            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,                   256,        ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_MSG_TX_INS"); //Execute Query 

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
    /// 쪽지 보기
    /// </summary>
    ///----------------------------------------------------------------------
    private int getMsgDetail(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intMsgNo",        DBType.adInteger,       objReqParam.intMsgNo,          0,      ParameterDirection.Input);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_MSG_DTL_UR_LST"); //Execute Query 

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
    /// 쪽지 삭제
    /// </summary>
    ///----------------------------------------------------------------------
    private int msgDel(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intInOutType", DBType.adInteger,   objReqParam.intInOutType,   0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intMsgNo",     DBType.adInteger,   objReqParam.intMsgNo,       0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",    DBType.adInteger,   DBNull.Value,               0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",       DBType.adVarChar,   DBNull.Value,               256,    ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_MSG_TX_DEL"); //Execute Query 

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
    /// 결제 목록 조회
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
            objDas.AddParam("@pi_strSearchFromDate",    DBType.adDate,          objReqParam.strSearchFromDate,  0,      ParameterDirection.Input);
            objDas.AddParam("@pi_strSearchToDate",      DBType.adDate,          objReqParam.strSearchToDate,    0,      ParameterDirection.Input);
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
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqParam
    {
        public int       intUserNo          { get; set; }
        public string    strUserId          { get; set; }
        public string    strUserPw          { get; set; }
        public string    strMethod          { get; set; }

        public string    strName            { get; set; }
        public string    strBirth           { get; set; }
        public string    strSex             { get; set; }
        public string    strPhone           { get; set; }
        public string    strEmail           { get; set; }

        public string    strPostcode        { get; set; }
        public string    strAddress1        { get; set; }
        public string    strAddress2        { get; set; }
        public string    strReceiver        { get; set; }
        public string    strSender          { get; set; }

        public string    strTitle           { get; set; }
        public string    strContent         { get; set; }
        public int       intMsgNo           { get; set; }
        public int      intPageSize         { get; set; }
        public int      intPageNo           { get; set; }

        public int      intInOutType        { get; set; }
        public string   strSearchFromDate   { get; set; }
        public string   strSearchToDate     { get; set; }
        public int      intType             { get; set; }
        public int      intStatus           { get; set; }



    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 응답 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ResParam
    {
        public DataTable objDT          { get; set; }
        public int       intRetVal      { get; set; }
        public string    strErrMsg      { get; set; }
        public int       intCheckVal    { get; set; }
        public int       intUserNo      { get; set; }

        public int       intStatus      { get; set; }
        public int       intRecordCnt   { get; set; }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}