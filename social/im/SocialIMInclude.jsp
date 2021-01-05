<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.social.service.SocialIMService" %>
<%@page import="weaver.social.im.SocialImLogin" %>
<%
    User user = HrmUserVarify.getUser(request, response);
    String userid = "" + user.getUID();
    SocialIMService.rootPath = application.getRealPath("/");
//    是否使用emessage4
    boolean isE4 = SocialIMService.checkE4Version();
//    是否启用了emessage web版本
    boolean isUseWeb = SocialIMService.isUseWebEmessage();
//    是否允许使用emessage
    boolean isAccessLogin = SocialImLogin.checkForbitLogin(userid);
    String websessionkey = java.util.UUID.randomUUID().toString().trim();

    if (!isE4 || !isUseWeb) {
        return;
    }
    if (!isAccessLogin) {
        return;
    }
    int checkLicense = SocialImLogin.checkLience();
    if (checkLicense == 0) {
        return;  // 没启用不显示
    } else if (checkLicense == 1) { // 授权正常，在人数正常，且pc不在线--》显示

%>
<style>
    .IMbg {
        position: absolute;
        opacity: 0.4;
        width: 100%;
        height: 100%;
        background-color: rgb(51, 51, 51);
        z-index: 1001
    }
    #immsgdiv {
        height: 40px;
        background: url('/social/images/im_msg.png') #4ba9df no-repeat 15px center;
        padding-left: 40px;
        padding-right: 10px;
        position: absolute;
        right: 0px;
        bottom: 45px;
        z-index: 1000;
        color: #fff;
        line-height: 40px;
        cursor: pointer;
    }
</style>

<script>
    /*
    * 判断浏览器版本
    * */
    function IEVersion() {
        var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
        var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1; //判断是否IE<11浏览器
       // var isEdge = userAgent.indexOf("Edge") > -1 && !isIE; //判断是否IE的Edge浏览器
        var isIE11 = userAgent.indexOf('Trident') > -1 && userAgent.indexOf("rv:11.0") > -1;
        if (isIE) {
            var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
            reIE.test(userAgent);
            var fIEVersion = parseFloat(RegExp["$1"]);
            if (fIEVersion == 7) {
                return 7;
            } else if (fIEVersion == 8) {
                return 8;
            } else if (fIEVersion == 9) {
                return 9;
            } else if (fIEVersion == 10) {
                return 10;
            } else {
                return 6;//IE版本<=7
            }
        } else if (isIE11) {
            return 11; //IE11
        } else {
            return -1;//不是ie浏览器
        }
    }

    var versionNO = IEVersion();
    //禁止IE9以下浏览器访问，并提示安装IE8
    if (versionNO >= 10 || versionNO < 0) {
        //初始化中间区域高度
        jQuery.ajax({
            url: "/social/im/ServerStatus.jsp?p=CheckpcOnline",
            type: "post",
            dataType: "json",
            contentType: "application/x-www-form-urlencoded; charset=utf-8",
            success: function (isonline) {
                if (typeof isonline == 'string') {
                    isonline = parseInt($.trim(isonline));
                } else {
                    isonline = !!isonline;
                }
                if (!isonline) {
                    $("#socialIMFrm").load(function () {
                        initIMBox();
                    });
                    $("#socialIMFrm").attr("src", "/social/im/SocialIMMain.jsp?from=main&websessionkey=<%=websessionkey%>");
                    //设置web登录状态
                    $.get('/social/im/ServerStatus.jsp?p=webLogin&websessionkey=<%=websessionkey%>');
                } else {
                    $("#IMbg").remove();
                    $("#immsgdiv").remove();
                    $("#addressdiv").remove();
                }
            }
        });
    }
    var IMCarousel = null, ChatUtil = null;

    function initIMBox() {
        // 刷新或关闭页面时，退出IM
        window.onbeforeunload = function () {
            $.get('/social/im/ServerStatus.jsp?p=logout&websessionkey=<%=websessionkey%>');
        };
        if (!IMCarousel)
            IMCarousel = $('#socialIMFrm')[0].contentWindow.IMCarousel;
        if (!ChatUtil)
            ChatUtil = $('#socialIMFrm')[0].contentWindow.ChatUtil;
        //展示浮动框
        $("#immsgdiv").show();
    }
/*
* 点击浮动框时间  flag: 1 显示  0 隐藏
* */
    function showIMdiv(flag) {
        var imRightdiv = $("#socialIMFrm").contents().find(".imRightdiv");
        var imLeftdiv = $("#socialIMFrm").contents().find(".imLeftdiv");
        var imCenterdiv = $("#socialIMFrm").contents().find(".imCenterdiv");
        var imSlideDiv = $("#socialIMFrm").contents().find(".imSlideDiv");
        var recenttab = $("#socialIMFrm").contents().find(".imToptab .tabitem:first");
        var _thiswin = $("#socialIMFrm")[0].contentWindow;
        var leftMenuScrollbar = $("#ascrail" + ($("#leftMenu").attr("tabindex") - 5000 + 2000)); //左侧菜单滚动条，会产生遮盖
        var recentListdiv = $("#socialIMFrm").contents().find("#recentListdiv");

        if (flag == 1) {
            //使socialIMMain.jsp为聚焦状态，消息提醒bug 1203 by wyw
            if (_thiswin.IMUtil)
                _thiswin.IMUtil.cache.isWindowFocus = 1;
            $("#IMbg").show();
            $("#addressdiv").show();
            $("#immsgdiv").hide();
            leftMenuScrollbar.hide();//隐藏左侧菜单滚动条

            imRightdiv.animate({
                'width': '281px',
                'height': '600px'
            }, 400, function () {
                if (imCenterdiv.find(".chatWin").length > 0) {
                    imCenterdiv.show();
                }
                if (imLeftdiv.find(".chatIMTabItem").length > 0) {
                    imLeftdiv.show();
                    //以下代码会引起bug，事实上showIMChatpanel中的click方法是异步的，
                    //这里的代码在尚未进入handler前被调用，这样会导致点击通知跳转到窗口时左边的tab页会被还原为上次隐藏前的状态 1127 by wyw
                    var chatIMTabActiveItem = $("#socialIMFrm").contents().find(".chatIMTabActiveItem");
                    if (chatIMTabActiveItem.length > 0) {
                        chatIMTabActiveItem.click();
                    }
                }
                var unreadMsgCount = Number($("#unreadMsgCount").html());
                if (unreadMsgCount > 0) {
                    recenttab.click();
                }
                if (recentListdiv.perfectScrollbar) {
                    recentListdiv.perfectScrollbar("update");
                }
            })

        } else {
            if (_thiswin.IMUtil)
                _thiswin.IMUtil.cache.isWindowFocus = 0;
            imLeftdiv.hide();
            imCenterdiv.hide();
            imSlideDiv.css({
                "display": "none",
                "width": "0px"
            });

            $("#IMbg").hide();
            imRightdiv.animate({
                'width': '0px',
                'height': '0px'
            }, 400, function () {
                $("#addressdiv").hide();
                $("#immsgdiv").show();
                leftMenuScrollbar.show();//显示左侧菜单滚动条
            })
        }
    }
</script>
<div id="IMbg" class="IMbg" style="display:none;" onclick="showIMdiv(0)"></div>
<div id="addressdiv" style="display:none;position:absolute;width:963px;height:600px;z-index:1002;right:0px;bottom:0px">
    <iframe name="socialIMFrm" id="socialIMFrm" scrolling="no" border="0"
            style="width:963px;height:600px;border:0px;"></iframe>
</div>
<div id="immsgdiv" style="display:none;" onclick="showIMdiv(1)">
                        <span id="unreadMsgSpan" style="display:none;">
                            <%=SystemEnv.getHtmlLabelName(126880, user.getLanguage())%>(<span
                                id="unreadMsgCount">0</span>)
                        </span><!-- 您有新的消息 -->
</div>

<%
} else {  //授权不正常或超过最大人数--》给出灰色并提示
%>
   <!-- <div id="immsgdiv" style="background-color: #ccc;" onclick="javascript:top.Dialog.alert('<%=SocialImLogin.getCheckLienceMsg(checkLicense, 7) %>');"></div>-->
<%
    }
%>