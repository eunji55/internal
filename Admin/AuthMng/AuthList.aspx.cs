﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AuthMng_AuthList : System.Web.UI.Page
{
    private string DAS_HOST = "10.10.120.20:33333";  //Define DAS Host
    private int DAS_CODEPAGE = 65001;                 //Define code page: UTF-8, http://ko.wikipedia.org/wiki/%EC%BD%94%EB%93%9C_%ED%8E%98%EC%9D%B4%EC%A7%80
    protected string authRange = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        authRange = Request.Form["authRangeVal"];
        
        authRangeVal.Value = authRange.ToString();
        
    }
}