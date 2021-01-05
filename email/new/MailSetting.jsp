
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<%
String target = Util.null2String(request.getParameter("target"));
rs.execute("select innerMail , outterMail from MailConfigureInfo");
int innerMail = 1;
int outterMail = 1;
while(rs.next()){
	innerMail = rs.getInt("innerMail");
	outterMail = rs.getInt("outterMail");
}
%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

</head>

<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						<%if(outterMail == 1){%>
							<li <%if("".equals(target)){%> class="current"<%}%>>
								<a href="" target="tabcontentframe" _datetype="mailAccount"><%=SystemEnv.getHtmlLabelName(31349, user.getLanguage())%></a>
							</li>
						<%} %>
						<li>
							<a href="" target="tabcontentframe" _datetype="mailSetting"><%=SystemEnv.getHtmlLabelName(81340,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="mailTemplate"><%=SystemEnv.getHtmlLabelName(17857,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="mailSign"><%=SystemEnv.getHtmlLabelName(24267,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="mailRule"><%=SystemEnv.getHtmlLabelName(19828,user.getLanguage()) %></a>
						</li>
						<li <%if("label".equals(target)){%> class="current"<%}%>>
							<a href="" target="tabcontentframe" _datetype="labelManage"><%=SystemEnv.getHtmlLabelName(81342,user.getLanguage()) %></a>
						</li>
						<li <%if("folder".equals(target)){%> class="current"<%}%>>
							<a href="" target="tabcontentframe" _datetype="folderManage"><%=SystemEnv.getHtmlLabelName(81343,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="mailAutoRespond"><%=SystemEnv.getHtmlLabelName(32161,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="mailblacklist"><%=SystemEnv.getHtmlLabelName(31859,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(25433,user.getLanguage()) %></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		<div class="tab_box"><div>
		<iframe src="" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>	
</body>

<script type="text/javascript">
	
   $(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("mail")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(24751,user.getLanguage())%>"
		});
		attachUrl();
  });
  
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("mailAccount" == datetype){
			$(this).attr("href","/email/MailAccount.jsp?"+new Date().getTime());
		}
		if("mailSetting" == datetype){
			$(this).attr("href","/email/MailSetting.jsp?"+new Date().getTime());
		}
		if("mailTemplate" == datetype){
			$(this).attr("href","/email/MailTemplate.jsp?"+new Date().getTime());
		}
		if("mailSign" == datetype){
			$(this).attr("href","/email/MailSign.jsp?"+new Date().getTime());
		}
		if("mailRule" == datetype){
			$(this).attr("href","/email/MailRule.jsp?"+new Date().getTime());
		}
		if("labelManage" == datetype){
			$(this).attr("href","/email/new/LabelManage.jsp?"+new Date().getTime());
		}
		if("folderManage" == datetype){
			$(this).attr("href","/email/new/FolderManage.jsp?"+new Date().getTime());
		}
		if("mailAutoRespond" == datetype){
			$(this).attr("href","/email/new/MailAutoRespond.jsp?"+new Date().getTime());
		}
		if("mailblacklist" == datetype) {
			$(this).attr("href","/email/new/MailBlacklist.jsp?"+new Date().getTime());
		}
		
	});
	
	if("folder"=="<%=target%>"){
		 <%if(outterMail == 1){%>
       		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(6)").attr("href"));
   		 <%}else{%>
			$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(5)").attr("href"));
         <%}%>
		return;
	}
	
	if("label"=="<%=target%>"){
		 <%if(outterMail == 1){%>
			$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(5)").attr("href"));
     	 <%}else{%>
       		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(4)").attr("href"));
     	 <%}%>
		return;
	}
	
	if(""=="<%=target%>"){
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
		return;
	}
	
	
}

</script>
</html>

