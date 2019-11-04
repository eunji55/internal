<%@ WebHandler Language="C#" Class="BoardHandler" %>

using BOQv7Das_Net;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.IO;


public class BoardHandler : IHttpHandler
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

            //Json 형태 요청 param Object로 변환
            strReqParam = new StreamReader(context.Request.InputStream).ReadToEnd();
            objReqParam = JsonConvert.DeserializeObject<ReqParam>(strReqParam);

            if (objReqParam.strMethod.Equals("BoardList"))
            {
                //DB 조회
                intRetVal = getBoardList(objReqParam, out objResParam, out strErrMsg);
                return;
            }
            else if (objReqParam.strMethod.Equals("boardIns")){

                intRetVal = boardIns(objReqParam, out strErrMsg);
                return;
            }
            else if (objReqParam.strMethod.Equals("BoardUpd"))
            {
                intRetVal = boardUpd(objReqParam, out strErrMsg);
                return;
            }
            else if (objReqParam.strMethod.Equals("BoardDel"))
            {
                intRetVal = boardDel(objReqParam, out strErrMsg);
                return;
            }
            else if (objReqParam.strMethod.Equals("CategoryList"))
            {
                intRetVal = getCategoryList(objReqParam, out objResParam, out strErrMsg);
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
    /// 게시판 목록 조회
    /// </summary>
    ///----------------------------------------------------------------------
    private int getBoardList(ReqParam objReqParam, out ResParam objResParam, out string strErrMsg)
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
            objDas.AddParam("@pi_strSearchWord",    DBType.adVarWChar,      objReqParam.strSearchWord,      50,     ParameterDirection.Input);
            objDas.AddParam("@pi_intCategoryNo",    DBType.adInteger,       objReqParam.intCategoryNo,      0,     ParameterDirection.Input);
            objDas.AddParam("@pi_intPageSize",      DBType.adInteger,       objReqParam.intPageSize,        0,      ParameterDirection.Input);
            objDas.AddParam("@pi_intPageNo",        DBType.adInteger,       objReqParam.intPageNo,          0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,       DBNull.Value,                   0,      ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_BOARD_AR_LST"); //Execute Query 

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
    /// 게시글 등록
    /// </summary>
    ///----------------------------------------------------------------------
    private int boardIns(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intUserNo",        DBType.adInteger,       objReqParam.intUserNo,      0,      ParameterDirection.Input);
            objDas.AddParam("@pi_strTitle",         DBType.adVarWChar,      objReqParam.strTitle,       50,     ParameterDirection.Input);
            objDas.AddParam("@pi_strContent",       DBType.adVarWChar,      objReqParam.strContent,     100000,    ParameterDirection.Input);
            objDas.AddParam("@pi_intCategoryNo",    DBType.adInteger,       objReqParam.intCategoryNo,      0,  ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,               0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,               256,    ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_BOARD_TX_INS"); //Execute Query 

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
    /// 게시글 수정
    /// </summary>
    ///----------------------------------------------------------------------
    private int boardUpd(ReqParam objReqParam, out string strErrMsg)
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
            objDas.AddParam("@pi_strTitle",         DBType.adVarWChar,      objReqParam.strTitle,       50,     ParameterDirection.Input);
            objDas.AddParam("@pi_strContent",       DBType.adVarWChar,      objReqParam.strContent,     256,    ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,               0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,               256,    ParameterDirection.Output);

            //프로시져 호출
            objDas.SetQuery("dbo.UP_BOARD_TX_UPD"); //Execute Query 

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
    /// 게시글 삭제
    /// </summary>
    ///----------------------------------------------------------------------
    private int boardDel(ReqParam objReqParam, out string strErrMsg)
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

            objDas.AddParam("@pi_intBoardNo",   DBType.adInteger,   objReqParam.intBoardNo,     0,      ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",    DBType.adInteger,   DBNull.Value,               0,      ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",       DBType.adVarChar,   DBNull.Value,               256,    ParameterDirection.Output);


            //프로시져 호출
            objDas.SetQuery("dbo.UP_BOARD_TX_DEL"); //Execute Query 

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
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class ReqParam
    {
        public string   strMethod       { get; set; }
        public string   intBoardNo      { get; set; }
        public string   intUserNo       { get; set; }
        public string   strTitle        { get; set; }
        public string   strContent      { get; set; }

        public int      intPageNo       { get; set; }
        public int      intPageSize     { get; set; }
        public int      intSearchType   { get; set; }
        public string   strSearchWord   { get; set; }
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

    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}