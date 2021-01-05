<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%
if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
Boolean isOpenWinDepartManage = SocialIMService.isOpenWinDepartManage();

%>
<html>
    <head>
        <link type="text/css" href="/css/Weaver_wev8.css" rel="stylesheet" />

        <link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
        <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
        <link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
        
        <link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
        <link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
        <script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
        
        <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
        <script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
        
        <link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
    </head>
    <body scroll="no">
        <div class="e8_box demo2">
            <div class="e8_boxhead">
                <div class="div_e8_xtree" id="div_e8_xtree"></div>
                <div class="e8_tablogo" id="e8_tablogo"></div>
                <div class="e8_ultab">
                    <div class="e8_navtab" id="e8_navtab">
                        <span id="objName"></span>
                    </div>
                    <div>
    					<ul class="tab_menu">
    						<li class="current">
    							<a href="SocialUserRightGroupChat.jsp" target="tabcontentframe" datetype="groupchat"><%=SystemEnv.getHtmlLabelName(127160, user.getLanguage())%></a>
    						</li>
                            <li>
                                <a href="SocialSysBroadcastList.jsp" target="tabcontentframe" datetype="groupchat"><%=SystemEnv.getHtmlLabelName(127159, user.getLanguage())%></a>
                            </li>
                            <li>
                                <a href="SocialForbitLogin.jsp" target="tabcontentframe" datetype="groupchat"><%=SystemEnv.getHtmlLabelName(129831, user.getLanguage())%></a>
                            </li>
                            <% if(isOpenWinDepartManage){%>
                            <li>
                                <a href="SocialAllowNewWindow.jsp" target="tabcontentframe" datetype="groupchat"><%=SystemEnv.getHtmlLabelName(131351, user.getLanguage())%></a>
                            </li>  
                            <% }%>                   
    					</ul>
                        <div id="rightBox" class="e8_rightBox"></div>
                    </div>
                </div>
            </div>

            <div class="tab_box">
                <iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
            <div>
        </div>
    </body>

    <script type="text/javascript">
    	$(document).ready(function(){
    	    $('.e8_box').Tabs({
    			getLine : 1,
    			iframe : "tabcontentframe",
    			mouldID : "<%=MouldIDConst.getID("social")%>",
    			staticOnLoad : true,
    			objName : "<%=SystemEnv.getHtmlLabelName(126732, user.getLanguage())%>"   //用户权限设置
    		});
    		attachUrl();
    	});
        
    	function attachUrl(){
    		$("[name='tabcontentframe']").attr("src","SocialUserRightGroupChat.jsp?"+new Date().getTime());
    	}
    </script>
</html>
