<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    User user = HrmUserVarify.getUser (request , response) ;
    int resourceId = user.getUID();//当前用户的id
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String name= Util.null2String(fu.getParameter("name"));
%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>红纺文化</title>
    <link rel="stylesheet" href="/mobile/plugin/shxiv/hfwh/css/qietu.css">
    <link rel="stylesheet" href="/mobile/plugin/shxiv/hfwh/css/swiper.min.css">
    <link rel="stylesheet" href="/mobile/plugin/shxiv/hfwh/css/style.css">
</head>
<body>
<!--头部-->
<div class="header">
    <div class="header-logo">
        <a href="#"><img src="/mobile/plugin/shxiv/hfwh/imgs/logo.png"/></a>
    </div>
    <div class="header-nav">
        <ul>
            <li class="header-nav-item"><a href="javascript:void(0)" onclick="openSy()" style="font-size: 20px;">首页</a></li>
            <li class="header-nav-item"><a href="javascript:void(0)" onclick="openTk()" style="font-size: 20px;">图库</a></li>
            <li class="header-nav-item"><a href="javascript:void(0)" onclick="openSc()" style="font-size: 20px;">图库收藏</a></li>
        </ul>
        <div class="icon-mima" onclick="openMm()"></div>
        <div class="icon-quit" onclick="window.location='/login/Logout.jsp'"></div>
    </div>
</div>
<!--//头部-->

<div class="wrapper m-wrapper">
    <div class="m-hd">
        <div class="m-breadcrumb" id="headXs">
            <%--<i class="ico-line"></i> <span class="big">paulfrank</span>--%>
        </div>
    </div>


    <!--选择-->
    <div class="m-choose" id="xsId">
        <!--<ul>
            <li>
                <a href="tkb.html">
                    <div class="img">
                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img15.jpg"/>
                    </div>
                    <div class="txt">线   上</div>
                </a>
            </li>
            <li>
                <a href="tkb.html">
                    <div class="img">
                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img16.jpg"/>
                    </div>
                    <div class="txt">线   下</div>
                </a>
            </li>
        </ul>-->
    </div>
    <!--//选择-->
</div>


<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/swiper.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/script.js"></script>

</body>
<script type="text/javascript">

    let userId="<%=resourceId%>";
    let name="<%=name%>";
    jQuery(document).ready(function(){
        /*parseURL(window.location.href);*/
        getHtml();
        getMsg();
    });

    function getHtml(){
        console.log(userId);
        console.log(name);
        let head="";
        head+="<i class='ico-line'></i> <span class='big'><a href='/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp'>"+name+"</span>";
        jQuery("#headXs").html(head);
    }

    /*function parseURL(url){
        var url = url.split("?")[1];
        var para = url.split("&");
        var len = para.length;
        var res = {};
        var arr = [];
        for(var i=0;i<len;i++){
            arr = para.split("=");
            res[arr[0]] = arr[1];
        }
        return res;
    }*/

    function getMsg() {
        jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/XsxMsg.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId+"&name="+name,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                console.log(data);
                if(data!==null&&data!==""){
                    let htm = "<ul>";
                    if(data==0){
                        htm+="<li>"+
                            "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxs.jsp?name="+name+"&xs="+data+"&zt=0'>"+
                            "<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img15.jpg'/></div>"+
                            "<div class='txt'>线   上</div></a></li>";
                    }
                    if(data==1){
                        htm+="<li>"+
                            "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxx.jsp?name="+name+"&xs="+data+"&zt=1'>"+
                            "<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img16.jpg'/></div>"+
                            "<div class='txt'>线   下</div></a></li>";
                    }
                    if(data==2){
                        htm+="<li>"+
                            "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxs.jsp?name="+name+"&xs="+data+"&zt=0'>"+
                            "<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img15.jpg'/></div>"+
                            "<div class='txt'>线   上</div></a></li>";

                        htm+="<li>"+
                            "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxx.jsp?name="+name+"&xs="+data+"&zt=1'>"+
                            "<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img16.jpg'/></div>"+
                            "<div class='txt'>线   下</div></a></li>";
                    }

                    htm+="</ul>";
                    jQuery("#xsId").html(htm);
                }
            }
        });

    }


    function openSy() {
        window.location.href="/docs/news/NewsDsp.jsp";
    }

    function openTk() {
        window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp";
    }

    function openSc() {
        window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainSc.jsp";
    }

    function openMm() {
        window.location.href="/CRM/data/ManagerUpdatePassword.jsp?type=customer&crmid="+userId;
    }

</script>
</html>




