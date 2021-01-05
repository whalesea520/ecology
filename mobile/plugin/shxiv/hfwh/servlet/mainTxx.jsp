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
    String xs= Util.null2String(fu.getParameter("xs"));
    String zt= Util.null2String(fu.getParameter("zt"));
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
        <div class="m-breadcrumb" id="headId">
            <%--<i class="ico-line"></i> <a href="#"><span class="big"><%=name%></span></a> <i class="ico-line"></i> <a href="#">线下</a>--%>
        </div>
        <div class="m-type">
            <dl>
                <dt>筛选</dt>
                <dd><a href="#">被授权品类</a></dd>
                <dd><a href="#">IP</a></dd>
                <dd><a href="#">年龄段</a></dd>
                <dd><a href="#">风格</a></dd>
            </dl>
        </div>
    </div>

    <!--图片滚动列表-->
    <div class="m-imgroll-wrap">
        <div class="m-imgroll" >
            <div class="m-imgroll-hd">
                <span class="tit">当季图库</span>
                <a class="more" href="${pageContext.request.contextPath}/mobile/plugin/shxiv/hfwh/servlet/mainTcList.jsp?more=1&name=<%=name%>&xs=<%=xs%>&tkName=当季图库&zt=1">更多</a>
            </div>
            <div class="m-imgroll-bd " id="firstList">

            </div>

        </div>
        <div class="m-imgroll">
            <div class="m-imgroll-hd">
                <span class="tit">经典图库</span>
                <a class="more" href="${pageContext.request.contextPath}/mobile/plugin/shxiv/hfwh/servlet/mainTcList.jsp?more=2&name=<%=name%>&xs=<%=xs%>&tkName=经典图库&zt=1">更多</a>
            </div>
            <div class="m-imgroll-bd " id="secondList">

            </div>

        </div>

        <div class="m-imgroll" >
            <div class="m-imgroll-hd">
                <span class="tit">往季图库</span>
                <a class="more" href="${pageContext.request.contextPath}/mobile/plugin/shxiv/hfwh/servlet/mainTcList.jsp?more=3&name=<%=name%>&xs=<%=xs%>&tkName=往季图库&zt=1">更多</a>
            </div>
            <div class="m-imgroll-bd " id="thirdList">

            </div>

        </div>

        <div class="m-imgroll">
            <div class="m-imgroll-hd">
                <span class="tit">主推图库</span>
                <a class="more" href="${pageContext.request.contextPath}/mobile/plugin/shxiv/hfwh/servlet/mainTcList.jsp?more=4&name=<%=name%>&xs=<%=xs%>&tkName=主推图库&zt=1">更多</a>
            </div>
            <div class="m-imgroll-bd " id="fourList">

            </div>

        </div>

    </div>

    <!--//图片滚动列表-->
</div>


<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/swiper.min.js"></script>
<script type="text/javascript" src="/mobile/plugin/shxiv/hfwh/js/script.js"></script>
<script  type="text/javascript">
    var swiper = new Swiper('.swiper-container', {
        slidesPerView: '4',
        spaceBetween: 20,
        navigation: {
            nextEl: '.swiper-button-next',
        },
    });

    let userId="<%=resourceId%>";
    let name="<%=name%>";
    let xs="<%=xs%>";
    let zt="<%=zt%>";
    jQuery(document).ready(function(){
        getHtml();
        getMsg();
    });

    function getHtml(){
        let head="";
        head+="<i class='ico-line'></i> <a href='/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp'><span class='big'>"+name+"</span></a><i class='ico-line'></i><a href='/mobile/plugin/shxiv/hfwh/servlet/mainXs.jsp?name="+name+"'>线下</a>";
        jQuery("#headId").html(head);
    }

    function getMsg() {
        var arr = [1,2,3,4];
        for ( var i = 0; i <arr.length; i++){
            var tt=arr[i];
            /*alert(tt);*/
            jQuery.ajax({
                url : "/mobile/plugin/shxiv/hfwh/servlet/XsTkMsg.jsp",
                type : "post",
                processData : false,
                async: false,
                data : "userId="+userId+"&name="+name+"&xs="+xs+"&tkb="+tt+"&zt="+zt,
                dataType: "json",
                error:function (XMLHttpRequest, textStatus, errorThrown) {

                } ,
                success:function (data, textStatus) {
                    if(data!=null&&data!=""){
                        let htm ="<div class='m-imgroll-hd'>";
                        htm +="<div class='m-searchlist'>"+
                            "<ul>";
                        let leng=data.length;
                        if(leng>5){
                            leng=5;
                        }
                        for(let j = 0;j<leng;j++){
                            htm+="<li>"+
                                "<div class='item'>"+
                                "<div class='img'>"+
                                "<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTp.jsp?tcId="+data[j].tcId+"&name="+name+"&tcIp="+data[j].tcIp+"&fileId="+data[j].fmId+"&tcName="+data[j].tcName+"&pdf="+data[j].pdfId+"&isSc="+data[j].isSc+"'>"+
                                "<img src='/weaver/weaver.file.FileDownloadDontLogin?fileid="+data[j].fmId+"'/>"+
                                "<!--<i class='icon-big'></i>--></a></div>"+
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
                        htm += "</ul>"+
                                /*"<div class='swiper-button-next'></div>"+*/
                            "</div></div>";
                        if(tt==1){
                            jQuery("#firstList").html(htm);
                        }

                        if(tt==2){
                            jQuery("#secondList").html(htm);
                        }

                        if(tt==3){
                            jQuery("#thirdList").html(htm);
                        }

                        if(tt==4){
                            jQuery("#fourList").html(htm);
                        }
                    }
                }
            });
        }
    }

    function download(pdfId,tcId,tcIp) {
        window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+pdfId);
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
                /!*if(data){
                    window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+pdfId);
                }else{
                    window.top.alert("下载数量已用完，请升级后再操作。");
                }*!/
                window.open("/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid="+pdfId);
            }
        });*/
    }

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
</body>
</html>



