<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="weaver.general.Util" %>
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
    <link rel="stylesheet" href="/mobile/plugin/shxiv/hfwh/css/lightbox.css">
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
    <!--搜索-->
    <!--<div class="m-search">
        <input class="text" type="text" name="" value="" placeholder="IP" />
    </div>-->
    <!--//搜索-->

    <div class="m-hd">
        <div class="m-breadcrumb">
            <i class="ico-line"></i><a href="javascript:void(0)"> 图库收藏</a>
        </div>
    </div>


    <!--图片列表-->
    <div class="m-searchlist" id="tcList">

    </div>
    <!--//图片列表-->
</div>


<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/swiper.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/lightbox.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/script.js"></script>

</body>
<script type="text/javascript">
    var userId="<%=resourceId%>";
    var isSc="1";
    jQuery(document).ready(function(){
        getTcList();
    });

    function getTcList() {
        jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/ScTkMsg.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                if(data!=null&&data!=""){
                    var htm = "<ul>";
                    for(var j = 0; j<data.length; j++){
                        htm+="<li>"+
                            "<div class='item'>"+
                            "<div class='img'>"+
                            "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTp.jsp?tcId="+data[j].tcId+"&name="+data[j].ipName+"&tcIp="+data[j].tcIp+"&fileId="+data[j].fmId+"&tcName="+data[j].tcName+"&pdf="+data[j].pdfId+"&isSc="+isSc+"'>"+
                            "<img src='/weaver/weaver.file.FileDownloadDontLogin?fileid="+data[j].fmId+"'/>"+
                                /*"<i class='icon-big'></i>"+*/
                            "</a></div>"+
                            "<div class='txt'>"+
                            "<div class='txt-l'>"+data[j].tcName+"</div>"+
                            "<div class='txt-r'>"+
                            "<i class='icon-down' onclick='download("+data[j].pdfId+","+data[j].tcId+","+data[j].tcIp+")'></i>"+
                            "<i class='icon-del' onclick='delSc("+data[j].tcId+")'></i>"+
                            "</div></div></div></li>";
                    }
                    htm+="</ul>";
                    jQuery("#tcList").html(htm);
                }
            }
        });
    }

    function download(pdfId,tcId,tcIp) {
        /*jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/CheckTc.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId+"&tcId="+tcId+"&tcIp="+tcIp,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                if(data){
                    window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+pdfId);
                }else{
                    window.top.alert("下载数量已用完，请升级后再操作。");
                }
            }
        });*/
        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+pdfId);
    }

    function delSc(tcId) {
        jQuery.ajax({
         url : "/mobile/plugin/shxiv/hfwh/servlet/DeleteSc.jsp",
         type : "post",
         processData : false,
         async: false,
         data : "userId="+userId+"&tcId="+tcId,
         dataType: "json",
         error:function (XMLHttpRequest, textStatus, errorThrown) {

         } ,
         success:function (data, textStatus) {
             location.reload();
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