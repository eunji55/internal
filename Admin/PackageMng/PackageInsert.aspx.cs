using BOQv7Das_Net;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PackageMng_PackageInsert : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, http://ko.wikipedia.org/wiki/%EC%BD%94%EB%93%9C_%ED%8E%98%EC%9D%B4%EC%A7%80
    
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    
    protected void addItem_Click(object sender, EventArgs e)
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

            if(packPrice.Value.Equals("0") || packPrice.Value.Equals(""))
            {
                Response.Write("<script>alert('가격을 입력해주세요.')</script>");
                return;
            }

            if (packImg.HasFile)
            {
                fileName = packImg.FileName;
                fileName = @"D:\WEBHOSTING\ejdo\User\ItemImg" + @"\" + fileName;

                packImg.SaveAs(fileName);
            }

            string itemList = Request.Form["itemCheckbox"] + ",";
            
            objDas.AddParam("@pi_strItemName",      DBType.adVarWChar,      packName.Value,          20,             ParameterDirection.Input);
            objDas.AddParam("@pi_intPrice",         DBType.adInteger,       packPrice.Value,          0,             ParameterDirection.Input);
            objDas.AddParam("@pi_intCnt",           DBType.adInteger,       packCnt.Value,          0,              ParameterDirection.Input);
            objDas.AddParam("@pi_strItemList",      DBType.adVarChar,       itemList,               300,            ParameterDirection.Input);
            objDas.AddParam("@pi_strPackImg",       DBType.adVarWChar,      fileName,               100,            ParameterDirection.Input);
            objDas.AddParam("@po_intRetVal",        DBType.adInteger,       DBNull.Value,           0,              ParameterDirection.Output);
            objDas.AddParam("@po_strMsg",           DBType.adVarChar,       DBNull.Value,           256,            ParameterDirection.Output);

            objDas.SetQuery("dbo.UP_PACKAGE_TX_INS"); //Execute Query 

            if (!objDas.LastErrorCode.Equals(0))
            {
                intRetVal = objDas.LastErrorCode;
                strErrMsg    = objDas.LastErrorMessage;
            }

            Response.Write("<script>alert('등록되었습니다.')</script>");
            Response.Write("<script>location.href='../PackageMng/PackageList.aspx'</script>");

        }catch
        {
            Response.Write("<script>alert('등록 실패 하였습니다.')</script>");

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