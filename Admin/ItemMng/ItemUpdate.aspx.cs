using BOQv7Das_Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ItemMng_ItemUpd : System.Web.UI.Page
{
   
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8
    protected int itemNo = 0;
        
    protected void Page_Load(object sender, EventArgs e)
    {
        

        //Check Postback status
        if (!IsPostBack)
        {
            itemNo = Convert.ToInt32(Request.QueryString["itemNo"]);
            itemNoVal.Value = itemNo.ToString();
            DisplayData(itemNo);
        }

        //로그인 안했을 경우 로그인 화면으로 이동
        if (!IsPostBack && HttpContext.Current.Session["adminNo"] == null)
        {
            Response.Redirect("/Default.aspx");
        }

    }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 상품 조회
        /// </summary>
        ///----------------------------------------------------------------------
        private void DisplayData(int itemNo)
        {

            BOQv7Das_Net.IDas objDas = null;

            try
            {
                objDas = new BOQv7Das_Net.IDas();

                objDas.Open(DAS_HOST);
                objDas.CommandType = CommandType.StoredProcedure;
                objDas.CodePage = DAS_CODEPAGE;

                objDas.AddParam("@pi_intitemNo", DBType.adInteger, itemNo, 0, ParameterDirection.Input);

                //프로시져 호출
                objDas.SetQuery("UP_ITEM_DTL_AR_LST"); //Execute Query 
                
                while(objDas.Read())
                {
                    itemImageViewUpd.Src = objDas["ITEMIMG"].ToString().Replace("D:\\WEBHOSTING\\ejdo\\User", "http://ejdo.payletter.com");
                    itemNameUpd.Text = objDas["ITEMNAME"].ToString();
                    itemPriceUpd.Text = objDas["PRICE"].ToString();
                    itemDetailUpd.InnerText = objDas["DETAIL"].ToString();
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

    //수정
    protected void updItem_Click(object sender, EventArgs e)
    {
        int    intRetVal     = 0;
        BOQv7Das_Net.IDas objDas = null;

        string strErrMsg   = string.Empty;
        String fileName = "";

        try { 

            objDas = new BOQv7Das_Net.IDas();

            objDas.Open(DAS_HOST);
            objDas.CommandType = CommandType.StoredProcedure;
            objDas.CodePage = DAS_CODEPAGE;

            if (itemImgUpd.HasFile)
            {
                fileName = itemImgUpd.FileName;
                fileName = @"D:\WEBHOSTING\ejdo\User\ItemImg" + @"\" + fileName;

                itemImgUpd.SaveAs(fileName);

            }else
            {
                fileName = itemImageViewUpd.Src;
            }
            
            objDas.AddParam("@pi_intItemNo",        DBType.adInteger,       itemNoVal.Value,            0,              ParameterDirection.Input);
            objDas.AddParam("@pi_strItemName",      DBType.adVarWChar,      itemNameUpd.Text,           20,             ParameterDirection.Input);
            objDas.AddParam("@pi_intPrice",         DBType.adInteger,       itemPriceUpd.Text,          0,             ParameterDirection.Input);
            objDas.AddParam("@pi_strDetail",        DBType.adVarWChar,      itemDetailUpd.InnerText,    100000,         ParameterDirection.Input);
            objDas.AddParam("@pi_strItemImg",       DBType.adVarWChar,      fileName,                   100,            ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,               0,              ParameterDirection.Output);

            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,               256,            ParameterDirection.Output);

            objDas.SetQuery("dbo.UP_ITEM_TX_UPD"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg = objDas.LastErrorMessage;
            }

            Response.Write("<script>alert('수정 되었습니다.')</script>");
            Response.Write("<script>location.href='../ItemMng/ItemList.aspx'</script>");

        }catch
        {
            Response.Write("<script>alert('수정 실패 하였습니다.')</script>");

        }finally
        {
            //Close
            if (objDas != null)
            {
                objDas.Close();
                objDas = null;
            }
        }
        
    }
    
}