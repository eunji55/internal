<%@ WebHandler Language="C#" Class="CommentHandler" %>

using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;

public class CommentHandler : IHttpHandler
{
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

            if (objReqParam.strMethod.Equals("CommentList"))
            {
                intRetVal = getCommentList(objReqParam, out objResParam, out strErrMsg);
                return;
            } else if (objReqParam.strMethod.Equals("CommentIns"))
            {
                intRetVal = commentIns(objReqParam, out strErrMsg);
                return;
            } else if (objReqParam.strMethod.Equals("CommentUpd"))
            {
                intRetVal = commentUpd(objReqParam, out strErrMsg);
                return;
            } else if (objReqParam.strMethod.Equals("CommentDel"))
            {
                intRetVal = commentDel(objReqParam, out strErrMsg);
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
    /// 댓글 리스트 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getCommentList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intBoardNo",    DBType.adInteger,       objReqParam.intBoardNo,      0,     ParameterDirection.Input);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_COMMENT_UR_LST"); //Execute Query 

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
    /// 댓글 등록
    /// </summary>
    ///----------------------------------------------------------------------
    private int commentIns(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intBoardNo",       DBType.adInteger,       objReqParam.intBoardNo,     0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intUserNo",        DBType.adInteger,       objReqParam.intUserNo,      0,      ParameterDirection.Input);
            objDas.AddParam("@pi_strContent",       DBType.adVarWChar,      objReqParam.strContent,     256,    ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,               0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarWChar,      DBNull.Value,               256,    ParameterDirection.Output);
                
            //프로시져 호출
            objDas.SetQuery("dbo.UP_COMMENT_TX_INS"); //Execute Query 

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
    /// 댓글 수정
    /// </summary>
    ///----------------------------------------------------------------------
    private int commentUpd(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intCommentNo",     DBType.adInteger,       objReqParam.intCommentNo,       0,      ParameterDirection.Input);
            objDas.AddParam("@pi_strContent",       DBType.adVarWChar,      objReqParam.strContent,         256,    ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarWChar,      DBNull.Value,                   256,    ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_COMMENT_TX_UPD"); //Execute Query 

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
    /// 댓글 삭제
    /// </summary>
    ///----------------------------------------------------------------------
    private int commentDel(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intCommentNo",     DBType.adInteger,       objReqParam.intCommentNo,       0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarWChar,      DBNull.Value,                   256,    ParameterDirection.Output);
                
            //프로시져 호출
            objDas.SetQuery("dbo.UP_COMMENT_TX_DEL"); //Execute Query 

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
        public string   intBoardNo      { get; set; }
        public int      intUserNo       { get; set; }
        public string   strContent      { get; set; }
        public int      intCommentNo    { get; set; }

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

    }

    public bool IsReusable
    {
        get {
            return false;
        }
    }

}