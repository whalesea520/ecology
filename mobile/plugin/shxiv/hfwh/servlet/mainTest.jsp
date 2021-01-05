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
        <div class="icon-quit" onclick="window.location='/login/Logout.jsp'"></div>
    </div>
</div>
<!--//头部-->

<div class="wrapper m-wrapper">
    <!--搜索-->
    <!--<div class="m-search m-search-1">
        <input class="text" type="text" name="" value="" placeholder="IP" />
    </div>-->
    <!--//搜索-->

    <div class="m-hd">
        <div class="m-breadcrumb">
            <i class="ico-line"></i> <a href="#"><span class="big">paulfrank</span></a> <i class="ico-line"></i> <a href="#">线上</a>
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
        <div class="m-imgroll">
            <div class="m-imgroll-hd">
                <span class="tit">去年核心</span>
                <a class="more" href="${pageContext.request.contextPath}/mobile/plugin/shxiv/hfwh/servlet/mainTcList.jsp?more=1&name=<%=name%>&xs=<%=xs%>&tkName=当季图库&zt=0">更多</a>
            </div>
            <div class="m-imgroll-bd ">
                <div class="swiper-container">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                    </ul>
                    <div class="swiper-button-next"></div><!--右箭头-->
                </div>
            </div>
        </div>
        <div class="m-imgroll">
            <div class="m-imgroll-hd">
                <span class="tit">去年季节</span>
                <a class="more" href="${pageContext.request.contextPath}/mobile/plugin/shxiv/hfwh/servlet/mainTcList.jsp?more=1&name=<%=name%>&xs=<%=xs%>&tkName=当季图库&zt=0">更多</a>
            </div>
            <div class="m-imgroll-bd ">
                <div class="swiper-container">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                    </ul>
                    <div class="swiper-button-next"></div><!--右箭头-->
                </div>
            </div>
        </div>

        <div class="m-imgroll">
            <div class="m-imgroll-hd">
                <span class="tit">当年核心</span>
                <a class="more" href="${pageContext.request.contextPath}/mobile/plugin/shxiv/hfwh/servlet/mainTcList.jsp?more=1&name=<%=name%>&xs=<%=xs%>&tkName=当季图库&zt=0">更多</a>
            </div>
            <div class="m-imgroll-bd ">
                <div class="swiper-container">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                    </ul>
                    <div class="swiper-button-next"></div><!--右箭头-->
                </div>
            </div>
        </div>

        <div class="m-imgroll">
            <div class="m-imgroll-hd">
                <span class="tit">当年季节</span>
                <a class="more" href="scb.html">更多</a>
            </div>
            <div class="m-imgroll-bd ">
                <div class="swiper-container">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big" ></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                        <li class="swiper-slide">
                            <div class="item">
                                <a href="tkd.html">
                                    <div class="img">
                                        <img src="/mobile/plugin/shxiv/hfwh/imgs/img7.jpg"/>
                                        <i class="icon-big"></i>
                                    </div>
                                    <div class="txt">
                                        <div class="txt-l">
                                            PF 图册名称
                                        </div>
                                        <div class="txt-r">
                                            <i class="icon-down"></i>
                                            <i class="icon-love"></i>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </li>
                    </ul>
                    <div class="swiper-button-next"></div><!--右箭头-->
                </div>
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

    function openSy() {
        window.location.href="/docs/news/NewsDsp.jsp";
    }

    function openTk() {
        window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp";
    }

    function openSc() {
        window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainSc.jsp";
    }
</script>
</body>
</html>


