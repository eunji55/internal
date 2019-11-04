using BOQv7Das_Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PackageMng_PackageUpdate : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                //Define code page: UTF-8
    
    protected int packNo = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
         //Check Postback status
        if (!IsPostBack)
        {
            packNo = Convert.ToInt32(Request.QueryString["packNo"]);
            packNoVal.Value = packNo.ToString();
            DisplayData(packNo);
        }

        //로그인 안했을 경우 로그인 화면으로 이동
        if (!IsPostBack && HttpContext.Current.Session["adminNo"] == null)
        {
            Response.Redirect("/Default.aspx");
        }
    }

    private void DisplayData(int packNo)
    {
        BOQv7Das_Net.IDas objDas = null;

            try
            {
                objDas = new BOQv7Das_Net.IDas();

                objDas.Open(DAS_HOST);
                objDas.CommandType = CommandType.StoredProcedure;
                objDas.CodePage = DAS_CODEPAGE;

                objDas.AddParam("@pi_intPackNo",    DBType.adInteger,   packNo,         0,      ParameterDirection.Input);
                objDas.AddParam("@po_strPname",     DBType.adVarWChar,  DBNull.Value,   20,     ParameterDirection.Output);
                objDas.AddParam("@po_intPrice",     DBType.adInteger,   DBNull.Value,   0,      ParameterDirection.Output);

                //프로시져 호출
                objDas.SetQuery("UP_PACKAGE_DTL_UR_LST"); //Execute Query 

                string itemList = "";
                int totalP = 0;

                while(objDas.Read())
                {
                    packImageViewUpd.Src = objDas["PACKIMG"].ToString().Replace("D:\\WEBHOSTING\\ejdo\\User", "http://ejdo.payletter.com");
                    packNameUpd.Value = objDas.GetParam("@po_strPname");
                    packCntUpd.Value = objDas["CNT"].ToString();
                    packPriceUpd.Value = objDas.GetParam("@po_intPrice");
                
                    itemList += objDas["itemNo"] + ",";
                    totalP += Convert.ToInt32(objDas["ITEMPRICE"]);
                
                }

                itemListUpd.Value = itemList;
                totalPrice.Value = totalP.ToString();
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



    protected void updPack_Click(object sender, EventArgs e)
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

            if(packPriceUpd.Value.Equals("0") || packPriceUpd.Value.Equals(""))
            {
                Response.Write("<script>alert('가격을 입력해주세요.')</script>");
                return;
            }

            if (packImg.HasFile)
            {
                fileName = packImg.FileName;
                fileName = @"D:\WEBHOSTING\ejdo\User\ItemImg" + @"\" + fileName;

                packImg.SaveAs(fileName);

            }else
            {
                fileName = packImageViewUpd.Src;
            }

            string itemList = Request.Form["itemCheckbox"] + ",";

            objDas.AddParam("@pi_intPackNo",        DBType.adInteger,       packNoVal.Value,        0,              ParameterDirection.Input);
            objDas.AddParam("@pi_strName",          DBType.adVarWChar,      packNameUpd.Value,      20,             ParameterDirection.Input);
            objDas.AddParam("@pi_intCnt",           DBType.adInteger,       packCntUpd.Value,       0,              ParameterDirection.Input);
            objDas.AddParam("@pi_intPrice",         DBType.adInteger,       packPriceUpd.Value,     0,              ParameterDirection.Input);
            objDas.AddParam("@pi_strItemList",      DBType.adVarChar,       itemList,               300,            ParameterDirection.Input);
            objDas.AddParam("@pi_strPackImg",       DBType.adVarWChar,      fileName,               100,            ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,           0,              ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,           256,            ParameterDirection.Output);

            objDas.SetQuery("dbo.UP_PACKAGE_TX_UPD"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
            }
            
            Response.Write("<script>alert('수정되었습니다.')</script>");
            Response.Write("<script>location.href='../PackageMng/PackageList.aspx'</script>");

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