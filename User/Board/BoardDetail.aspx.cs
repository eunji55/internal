using BOQv7Das_Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Board_BoardDetail : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, http://ko.wikipedia.org/wiki/%EC%BD%94%EB%93%9C_%ED%8E%98%EC%9D%B4%EC%A7%80
    protected int boardNo = 0;
    protected int cateNo = 0;
        
    protected void Page_Load(object sender, EventArgs e)
    {   
        boardNo = Convert.ToInt32(Request.QueryString["boardNo"]);
        cateNo = Convert.ToInt32(Request.QueryString["categoryNo"]);
        categoryNo.Value = cateNo.ToString();

        //Check Postback status
        if (!IsPostBack)
        {
            getBoardDetail(boardNo);
        }

        //로그인 안했을 경우 로그인 화면으로 이동
        if (!IsPostBack && HttpContext.Current.Session["userNo"] == null)
        {
            Response.Redirect("/Default.aspx");
        }

    }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 게시글 조회
        /// </summary>
        ///----------------------------------------------------------------------
        private void getBoardDetail(int boardNo)
        {

            BOQv7Das_Net.IDas objDas = null;

            try
            {
                objDas = new BOQv7Das_Net.IDas();

                objDas.Open(DAS_HOST);
                objDas.CommandType = CommandType.StoredProcedure;
                objDas.CodePage = DAS_CODEPAGE;

                objDas.AddParam("@pi_intBoardNo",   DBType.adInteger,   boardNo,        0,  ParameterDirection.Input);
                objDas.AddParam("@po_intRetVal",    DBType.adInteger,   DBNull.Value,   0,  ParameterDirection.Output);
                objDas.AddParam("@po_strMsg",       DBType.adVarChar,   DBNull.Value,   256,  ParameterDirection.Output);

                //프로시져 호출
                objDas.SetQuery("UP_BOARD_DTL_AR_LST"); //Execute Query 
                
                while(objDas.Read())
                {
                    titleDetail.Value = objDas["TITLE"].ToString();
                    userIdDetail.Value = objDas["USERID"].ToString();
                    regDateDetail.Value = objDas["REGDATE"].ToString();
                    contentDetail.Value = objDas["CONTENT"].ToString();
                    userNoDetail.Value = objDas["USERNO"].ToString();
                
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
            return;
        }
   
        
}