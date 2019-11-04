<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Membership_Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <style>
        
    #header {
        background: url(../assets/img/GB0A1287.jpg) no-repeat center center;
        background-attachment: fixed;
        background-size: cover;
        display: table;
        height: calc(100vh - 72px);
        width: 100%;
        position: relative;
        z-index: 1;
        overflow-x: hidden;
    }

    .header-wrapper .header-wrapper-inner .welcome-speech h1 {
	    color: white;
        font-size: 45px;
        font-weight: bold;
        letter-spacing: 6px;
        margin-bottom: 12px;
        margin-top: 0;
        text-transform: uppercase;
    }

    .header-wrapper .header-wrapper-inner .welcome-speech p {
	    color: white;
        font-size: 20px;
        font-weight: 900;
        letter-spacing: 3px;
        margin-bottom: 4.2em;
    }

    </style>

     <div class="main-content">
        <!-- header start -->
            <header id="header" class="header-wrapper home-parallax home-fade">
                <div class="header-overlay"></div>
                <div class="header-wrapper-inner">
                    <div class="container"> <%--style="background-color:rgba(255, 255, 255,0.2); border-color:black; padding-bottom: 3%; width: 30%;">--%>
                        
                        <div class="welcome-speech">
                            <h1>샐러드 정기배송</h1>
                            <p>매주 신선한 샐러드를 문 앞에서 만나요</p>
                            <a href="../Item/ItemList.aspx" class="btn btn-lg btn-white">
                                메뉴보기
                            </a>
                        </div><!-- /.intro -->
                        
                    </div><!-- /.container -->

                </div><!-- /.header-wrapper-inner -->
            </header>
            <!-- /#header -->
         </div>
</asp:Content>

