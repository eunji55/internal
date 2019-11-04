﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Board_BoardList : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, http://ko.wikipedia.org/wiki/%EC%BD%94%EB%93%9C_%ED%8E%98%EC%9D%B4%EC%A7%80
    protected int cateNo = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        cateNo = Convert.ToInt32(Request.QueryString["categoryNo"]);
        categoryNo.Value = cateNo.ToString();

        //로그인 안했을 경우 로그인 화면으로 이동
        if (!IsPostBack && HttpContext.Current.Session["adminNo"] == null)
        {
            Response.Redirect("/Default.aspx");
        }


    }
    
}