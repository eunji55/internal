using BOQv7Das_Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Board_BoardUpd : System.Web.UI.Page
{
     
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, http://ko.wikipedia.org/wiki/%EC%BD%94%EB%93%9C_%ED%8E%98%EC%9D%B4%EC%A7%80
    protected int boardNo = 0;
    protected int cateNo = 0;
        
    protected void Page_Load(object sender, EventArgs e)
    {
        cateNo = Convert.ToInt32(Request.QueryString["categoryNo"]);
        categoryNo.Value = cateNo.ToString();

        //Check Postback status
        if (!IsPostBack)
        {
            boardNo = Convert.ToInt32(Request.QueryString["boardNo"]);
            DisplayData(boardNo);
        }

        //로그인 안했을 경우 로그인 화면으로 이동
        if (!IsPostBack && HttpContext.Current.Session["adminNo"] == null)
        {
            Response.Redirect("/Default.aspx");
        }

    }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 게시글 조회
        /// </summary>
        ///----------------------------------------------------------------------
        private void DisplayData(int boardNo)
        {

            BOQv7Das_Net.IDas objDas = null;

            try
            {
                objDas = new BOQv7Das_Net.IDas();

                objDas.Open(DAS_HOST);
                objDas.CommandType = CommandType.StoredProcedure;
                objDas.CodePage = DAS_CODEPAGE;

                objDas.AddParam("@pi_intBoardNo", DBType.adInteger, boardNo, 0, ParameterDirection.Input);

                //프로시져 호출
                objDas.SetQuery("UP_BOARD_DTL_AR_LST"); //Execute Query 

                while (objDas.Read())
                {
                    titleUpd.Value = objDas["Title"].ToString();
                    contentUpd.Value = objDas["Content"].ToString();
                    if (objDas["NOTICEYN"].ToString().Equals("Y"))
                    {
                        noticeYN.Checked = true;
                    }
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