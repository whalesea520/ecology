<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    User user = HrmUserVarify.getUser (request , response) ;
    int resourceId = user.getUID();//当前用户的id
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
            <li class="header-nav-item"><a  href="/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp" style="font-size: 20px;">图库</a></li>
            <li class="header-nav-item"><a href="javascript:void(0)" onclick="openSc()" style="font-size: 20px;">图库收藏</a></li>
        </ul>
        <div class="icon-mima" onclick="openMm()"></div>
        <div class="icon-quit" onclick="window.location='/login/Logout.jsp'"></div>
    </div>
</div>
<!--//头部-->

<div class="wrapper">
    <!--搜索-->
    <div class="m-search">
        <i class="icon-search"></i>
        <input id="selectIp" class="text" type="text" value="" placeholder="IP" />
    </div>
    <!--//搜索-->

    <!--列表-->
    <div class="h-list" id="IpList">
        <!--<ul>
            <li>
                <a href="xsx.html?name=paulfrank">
                    <div class="img"><img src="/mobile/plugin/shxiv/hfwh/imgs/img1.jpg"/></div>
                    <p class="txt">paulfrank</p>
                </a>
            </li>
            <li>
                <a href="xsx.html">
                    <div class="img"><img src="/mobile/plugin/shxiv/hfwh/imgs/img2.jpg"/></div>
                    <p class="txt">paulfrank</p>
                </a>
            </li>
            <li>
                <a href="xsx.html">
                    <div class="img"><img src="/mobile/plugin/shxiv/hfwh/imgs/img3.jpg"/></div>
                    <p class="txt">paulfrank</p>
                </a>
            </li>
            <li>
                <a href="xsx.html">
                    <div class="img"><img src="/mobile/plugin/shxiv/hfwh/imgs/img4.jpg"/></div>
                    <p class="txt">paulfrank</p>
                </a>
            </li>
            <li>
                <a href="xsx.html">
                    <div class="img"><img src="/mobile/plugin/shxiv/hfwh/imgs/img5.jpg"/></div>
                    <p class="txt">paulfrank</p>
                </a>
            </li>
            <li>
                <a href="xsx.html">
                    <div class="img"><img src="/mobile/plugin/shxiv/hfwh/imgs/img6.jpg"/></div>
                    <p class="txt">paulfrank</p>
                </a>
            </li>
        </ul>-->
    </div>
    <!--//列表-->
</div>


<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/swiper.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/script.js"></script>

<script type="text/javascript">

    let userId="<%=resourceId%>";
    let name="";
    jQuery(document).ready(function(){
        //getCookie();
        /*var userId=document.cookie.loginidweaver;
         console.log(userId);*/
        console.log(userId);
        getMsg(name);
    });

    jQuery(function(){
        jQuery("#selectIp").bind('input propertychange', function() {
            let IPName = jQuery("#selectIp").val();
            if(IPName!=null&&IPName!=""){
                getMsg(IPName);
            }
        });

    });

    function getMsg(name) {
        jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/MainMsg.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId+"&name="+name,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                if(data!=null&&data!=""){
                    let htm = "<ul>";
                    for(let j = 0; j<data.length; j++){
                        const IP=data[j].ipName;
                        const img = "/mobile/plugin/shxiv/hfwh/imgs/" + IP + ".jpg";
                        htm+="<li>"+
                            "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainXs.jsp?name="+IP+"'>"+
                            "<div class='img'><img src='"+img+"'/></div>"+
                            "<p class='txt'>"+IP+"</p></a></li>";
                    }
                    htm+="</ul>";
                    jQuery("#IpList").html(htm);
                }
            }
        });

    }

    /*function getCookie(){
        try{
            let cookieData = new String(document.cookie);
            const cookieHeader = "loginidweaver=";
            let cookieStart = cookieData.indexOf(cookieHeader) + cookieHeader.length;
            let cookieEnd = cookieData.indexOf(";", cookieStart);
            if(cookieEnd==-1){
                cookieEnd = cookieData.length;
            }
            if(cookieData.indexOf(cookieHeader)!=-1){
                userId = cookieData.substring(cookieStart, cookieEnd);
            }
        }catch(e){}
    }*/

    function openSy() {
        window.location.href="/docs/news/NewsDsp.jsp";
    }

    function openSc() {
        window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainSc.jsp";
    }

    function openMm() {
        window.location.href="/CRM/data/ManagerUpdatePassword.jsp?type=customer&crmid="+userId;
    }

</script>


</body>
</html>





