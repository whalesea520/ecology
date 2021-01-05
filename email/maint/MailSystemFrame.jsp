
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />

<html>
<head>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

</head>
<%
if(! HrmUserVarify.checkUserRight("email:sysSetting", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
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
                            <!-- 基本设置 -->
							<a href="" target="tabcontentframe" _datetype="enabled"><%=SystemEnv.getHtmlLabelName(130187, user.getLanguage())%></a>
						</li>
                        <li>
                            <!-- 附件设置 -->
                            <a href="" target="tabcontentframe" _datetype="attachment"><%=SystemEnv.getHtmlLabelName(23796, user.getLanguage())%></a>
                        </li>
						<li>
                            <!-- 群发参数设置 -->
							<a href="" target="tabcontentframe" _datetype="system"><%=SystemEnv.getHtmlLabelName(130188, user.getLanguage())%></a>
						</li>
                        <li>
                            <!-- 群发邮件日志 -->
                            <a href="" target="tabcontentframe" _datetype="remindLogList"><%=SystemEnv.getHtmlLabelName(130189, user.getLanguage())%></a>
                        </li>
						<li>
                            <!-- 提醒设置 -->
							<a href="" target="tabcontentframe" _datetype="remind"><%=SystemEnv.getHtmlLabelName(21946, user.getLanguage())%></a>
						</li>
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
			mouldID:"<%= MouldIDConst.getID("mail")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(15037,user.getLanguage())%>"
		});
		attachUrl();
	});
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("enabled" == datetype){
			$(this).attr("href","/email/maint/MailEnabledStatus.jsp?"+new Date().getTime());
		}
		
		if("system" == datetype){
			$(this).attr("href","/email/maint/MailSystemSet.jsp?"+new Date().getTime());
		}
        if(datetype == 'remindLogList') {
            $(this).attr("href","/email/maint/MailRemindLogList.jsp?"+new Date().getTime());
        }
		
		if("attachment" == datetype){
			$(this).attr("href","/email/maint/MailAttachment.jsp?"+new Date().getTime());
		}
		if("remind" == datetype){
			$(this).attr("href","/email/maint/MailRemindList.jsp?"+new Date().getTime());
		}
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
}

</script>
</html>

