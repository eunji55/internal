using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Membership_MsgWrite : System.Web.UI.Page
{
    

    protected void Page_Load(object sender, EventArgs e)
    {
        receiver.Value = Request.QueryString["receiver"];
        
    }
}