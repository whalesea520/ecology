<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    User user = HrmUserVarify.getUser (request , response) ;
    int resourceId = user.getUID();//当前用户的id
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String tcId= Util.null2String(fu.getParameter("tcId"));
    String tcIp= Util.null2String(fu.getParameter("tcIp"));
    String name= Util.null2String(fu.getParameter("name"));
    String tcName= Util.null2String(fu.getParameter("tcName"));
    String tcBm= Util.null2String(fu.getParameter("tcBm"));
    String fileId= Util.null2String(fu.getParameter("fileId"));
    String pdfId= Util.null2String(fu.getParameter("pdf"));
    String isSc= Util.null2String(fu.getParameter("isSc"));
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

<div class="wrapper m-wrapper m-wrapper1">
    <!--搜索-->
    <!--<div class="m-search">
        <input class="text" type="text" name="" value="" placeholder="IP" />
    </div>-->
    <!--//搜索-->
    <div class="m-hd">
        <div class="m-breadcrumb">
            <i class="ico-line"></i><a href="javascript:void(0)" onclick="openTc()"> 返回</a>
        </div>
    </div>


    <div class="m-imginfo">
        <div class="m-imginfo-l">
            <div class="img">
                <a href="/weaver/weaver.file.FileDownloadDontLogin?fileid=<%=fileId%>" data-lightbox="example-1">
                    <img src="/weaver/weaver.file.FileDownloadDontLogin?fileid=<%=fileId%>"/>
                    <i class="icon-love "></i></a>
            </div>
        </div>

        <div class="m-imginfo-r">
            <%--&lt;%&ndash;<div class="tit">编码：<%=tcBm%></div>--%>
            <div class="tit"></div>
            <div class="desc">
                <p>编码：<%=tcBm%></p>
                <p>名称：<%=tcName%></p>
                <p>年份：2019年</p>
                <p>品牌：<%=name%></p>
                <p>格式：PDF  文件大小约：50MB</p>
            </div>
            <div class="btns">
                <%--<a class="btn" href="javascript:void(0)" onclick=""><i class="icon-love"></i>收藏该图册</a>--%>
                <div class="btn" id="scId"></div>
                <div class="btn btn-red"><i class="icon-down" onclick="download()"></i>下载图册</div>
                <%--<a class="btn btn-red" href="javascript:void(0)" onclick="download()"><i class="icon-down" onclick="download()"></i>下载图册</a>--%>
            </div>
        </div>
    </div>
    <!--图片列表-->
    <div class="m-imglist" id="tpList">

    </div>
    <!--//图片列表-->
</div>



<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/swiper.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/lightbox.min.js" ></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/script.js"></script>

</body>
<script type="text/javascript">
    var userId="<%=resourceId%>";
    var name="<%=name%>";
    var tcId="<%=tcId%>";
    var tcIp="<%=tcIp%>";
    var pdfId="<%=pdfId%>";
    var isSc="<%=isSc%>";
    var tcName="<%=tcName%>";
    var fId="<%=fileId%>";
    jQuery(document).ready(function(){
        getMsg();

    });

    function getMsg() {
        var scHtml="";
        if(isSc==1){
            scHtml="<i class='icon-del' onclick='delSc()'></i>收藏该图册"
        }else{
            scHtml="<i class='icon-love' onclick='addSc()'></i>收藏该图册"
        }
        jQuery("#scId").html(scHtml);

        jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/TpMsg.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId+"&tcId="+tcId,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                if(data!=null&&data!=""){
                    var htm = "<ul>";
                    for(var j = 0; j<data.length; j++){
                        const IP=data[j].ipName;
                        const img = "/mobile/plugin/shxiv/hfwh/imgs/" + IP + ".jpg";
                        htm+="<li>"+
                            "<a href='/weaver/weaver.file.FileDownloadDontLogin?fileid="+data[j].mfmId+"' data-lightbox='img-1'>"+
                            "<img src='/weaver/weaver.file.FileDownloadDontLogin?fileid="+data[j].mfmId+"'/></a>"+
                            "<div class='down'>"+
                            "<div class='down-l'>下载</div>"+
                            "<div class='down-r'>";
                        if(data[j].ai>0){
                            htm+="<a href='javascript:void(0)' onclick='downAi(\""+data[j].ai+"\",\""+data[j].tcBm+ "\",\""+data[j].tcName+ "\")'>AI</a>";
                        }
                        if(data[j].psd>0){
                            htm+="<a href='javascript:void(0)' onclick='downAi(\""+data[j].psd+"\",\""+data[j].tcBm+ "\",\""+data[j].tcName+ "\")'>PSD</a>";
                        }
                        if(data[j].jpg>0){
                            htm+="<a href='javascript:void(0)' onclick='downAi(\""+data[j].jpg+"\",\""+data[j].tcBm+ "\",\""+data[j].tcName+ "\")'>JPG</a>";
                        }
                        if(data[j].png>0){
                            htm+="<a href='javascript:void(0)' onclick='downAi(\""+data[j].png+"\",\""+data[j].tcBm+ "\",\""+data[j].tcName+ "\")'>PNG</a>";
                        }
                        if(data[j].eps>0){
                            htm+="<a href='javascript:void(0)' onclick='downAi(\""+data[j].eps+"\",\""+data[j].tcBm+ "\",\""+data[j].tcName+ "\")'>EPS</a>";
                        }
                        htm+="</div></div>" +
                            "<p style='font-size:11px;margin:10px auto;'>编号："+data[j].tcBm+"</p>"+
                            "<p style='font-size:11px;margin:10px auto;'>名称："+data[j].tcName+"</p></li>";
                    }
                    htm+="</ul>";
                    jQuery("#tpList").html(htm);
                }
            }
        });
    }

    function download() {
        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+pdfId);
    }

    function downAi(fileId,tpbm,tpmc) {

        jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/CheckTc.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId+"&tcId="+tcId+"&tcIp="+tcIp+"&tpbm="+tpbm+"&tpmc="+tpmc,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                if(data){
                    if(fileId!=null&&fileId!=""){
                        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+fileId);
                    }
                }else{
                    window.top.alert("下载数量已用完，请升级后再操作。");
                }
            }
        });
    }

    /*function downPsd(fileId) {
        jQuery.ajax({
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
                    if(fileId!=null&&fileId!=""){
                        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+fileId);
                    }
                }else{
                    window.top.alert("下载数量已用完，请升级后再操作。");
                }
            }
        });
    }

    function downJpg(fileId) {
        jQuery.ajax({
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
                    if(fileId!=null&&fileId!=""){
                        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+fileId);
                    }
                }else{
                    window.top.alert("下载数量已用完，请升级后再操作。");
                }
            }
        });
    }

    function downPng(fileId) {
        jQuery.ajax({
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
                    if(fileId!=null&&fileId!=""){
                        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+fileId);
                    }
                }else{
                    window.top.alert("下载数量已用完，请升级后再操作。");
                }
            }
        });
    }*/

    function addSc() {
        jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/AddSc.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId+"&tcId="+tcId,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                location.replace("/mobile/plugin/shxiv/hfwh/servlet/mainTp.jsp?tcId="+tcId+"&name="+name+"&tcIp="+tcIp+"&tcName="+tcName+"&pdf="+pdfId+"&fileId="+fId+"&isSc=1");
            }
        });
    }

    function delSc() {
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
                location.replace("/mobile/plugin/shxiv/hfwh/servlet/mainTp.jsp?tcId="+tcId+"&name="+name+"&tcIp="+tcIp+"&tcName="+tcName+"&pdf="+pdfId+"&fileId="+fId+"&isSc=0");
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
    function openTc() {
        history.go(-1);
    }
</script>
</html>





