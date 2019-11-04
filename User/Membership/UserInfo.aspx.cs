using BOQv7Das_Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Membership_userInfo : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, 
 
        
    protected void Page_Load(object sender, EventArgs e)
    {
        int userNo = Convert.ToInt32(Session["userNo"]);

        //Check Postback status
        if (!IsPostBack)
        {
            DisplayData(userNo);
        }

        //로그인 안했을 경우 로그인 화면으로 이동
        if (!IsPostBack && HttpContext.Current.Session["userNo"] == null)
        {
            Response.Redirect("/Default.aspx");
        }
        
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 회원 정보 보기
    /// </summary>
    ///----------------------------------------------------------------------
    private void DisplayData(int userNo)
        {

            BOQv7Das_Net.IDas objDas = null;
            
            try
            {
                objDas = new BOQv7Das_Net.IDas();

                objDas.Open(DAS_HOST);
                objDas.CommandType = CommandType.StoredProcedure;
                objDas.CodePage = DAS_CODEPAGE;

                objDas.AddParam("@pi_intUserNo",    DBType.adInteger,     userNo,   0, ParameterDirection.Input);

                //프로시져 호출
                objDas.SetQuery("dbo.UP_USER_INFO_AR_LST"); //Execute Query 
                
                while(objDas.Read())
                {
                    UserID.Value    = objDas["UserId"].ToString();
                    Name.Value      = objDas["Name"].ToString();
                    Birth.Value     = objDas["Birth"].ToString();
                    Sex.Value       = objDas["Sex"].ToString();
                    Phone.Value     = objDas["Phone"].ToString();

                    Email.Value     = objDas["Email"].ToString();
                    postcode.Value = objDas["Postcode"].ToString();
                    address1.Value = objDas["Address1"].ToString();
                    address2.Value = objDas["Address2"].ToString();
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