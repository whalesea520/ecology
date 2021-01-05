<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    User user = HrmUserVarify.getUser (request , response) ;
    int resourceId = user.getUID();//当前用户的id
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String more= Util.null2String(fu.getParameter("more"));
    String xs= Util.null2String(fu.getParameter("xs"));
    String name= Util.null2String(fu.getParameter("name"));
    String tkName= Util.null2String(fu.getParameter("tkName"));
    String zt= Util.null2String(fu.getParameter("zt"));
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
        <div class="m-breadcrumb" id="tpp">
            <i class="ico-line"></i> <a href="#"><span class="big"><%=name%></span></a> <i class="ico-line"></i> <a href="#">线上</a><i class="ico-line"></i><a href="javascript:void(0)" onclick="openTx()"> <%=tkName%></a>
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
    let userId="<%=resourceId%>";
    let more="<%=more%>";
    let name="<%=name%>";
    let xs="<%=xs%>";
    let zt="<%=zt%>";
    jQuery(document).ready(function(){
        getTpp();
        getTcList();
    });
    function getTpp() {
        let htm1 ="";
        if(zt==0){
            htm1 = "<i class='ico-line'></i> <a href='/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp'><span class='big'><%=name%></span></a> <i class='ico-line'></i> <a href='/mobile/plugin/shxiv/hfwh/servlet/mainXs.jsp?name="+name+"'>线上</a><i class='ico-line'></i><a href='javascript:void(0)' onclick='openTx()'> <%=tkName%></a>";
        }else{
            htm1 = "<i class='ico-line'></i> <a href='/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp'><span class='big'><%=name%></span></a> <i class='ico-line'></i> <a href='/mobile/plugin/shxiv/hfwh/servlet/mainXs.jsp?name="+name+"'>线下</a><i class='ico-line'></i><a href='javascript:void(0)' onclick='openTx()'> <%=tkName%></a>";
        }

        jQuery("#tpp").html(htm1);
    }

    function getTcList() {
        jQuery.ajax({
            url : "/mobile/plugin/shxiv/hfwh/servlet/XsTkMsg.jsp",
            type : "post",
            processData : false,
            async: false,
            data : "userId="+userId+"&name="+name+"&xs="+xs+"&tkb="+more+"&zt="+zt,
            dataType: "json",
            error:function (XMLHttpRequest, textStatus, errorThrown) {

            } ,
            success:function (data, textStatus) {
                if(data!=null&&data!=""){
                    let htm = "<ul>";
                    for(let j = 0; j<data.length; j++){
                        htm+="<li>"+
                            "<div class='item'>"+
                            "<div class='img'>"+
                            "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTp.jsp?tcId="+data[j].tcId+"&name="+name+"&tcIp="+data[j].tcIp+"&fileId="+data[j].fmId+"&tcName="+data[j].tcName+"&tcBm="+data[j].tcBm+"&pdf="+data[j].pdfId+"&isSc="+data[j].isSc+"'>"+
                            "<img src='/weaver/weaver.file.FileDownloadDontLogin?fileid="+data[j].fmId+"'/>"+
                            /*"<i class='icon-big'></i>"+*/
                            "</a></div>"+
                            /*"<div class='txt'>"+
                            "<div class='txt-l'>"+data[j].tcName+"</div></div>"+*/
                            "<div class='txt'>"+
                            "<div class='txt-r'>"+
                            "<i class='icon-down' onclick='download("+data[j].pdfId+","+data[j].tcId+","+data[j].tcIp+")'></i>";
                        if(data[j].isSc==1){
                            htm+= "<i class='icon-del' onclick='delSc("+data[j].tcId+")'></i>";
                        }else{
                            htm+= "<i class='icon-love' onclick='addSc("+data[j].tcId+")'></i>";
                        }
                        htm+=" </div></div>" +
                            "<p style='font-size:11px;margin:10px auto;'>编号："+data[j].tcBm+"</p>"+
                            "<p style='font-size:11px;margin:10px auto;'>名称："+data[j].tcName+"</p>"+
                            "</div></li>";
                    }
                    htm+="</ul>";
                    jQuery("#tcList").html(htm);
                }
            }
        });
    }

    function addSc(tcId) {
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
                location.reload();
            }
        });
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

    function download(pdfId,tcId,tcIp) {
        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+pdfId);
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

    function openTx() {
        if(zt==0){
            window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainTxs.jsp?name="+name+"&xs="+xs+"&zt=0";
        }else{
            window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainTxx.jsp?name="+name+"&xs="+xs+"&zt=1";
        }

    }
</script>
</html>




