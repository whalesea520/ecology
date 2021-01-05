
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.commons.lang.time.DateFormatUtils" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="scheduleService" class="weaver.mobile.plugin.ecology.service.ScheduleService" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;

int id = Util.getIntValue((String)request.getParameter("id"));
int detailid = Util.getIntValue((String)request.getParameter("detailid"));
int module = Util.getIntValue((String)request.getParameter("module"));
int scope = Util.getIntValue((String)request.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = StringEscapeUtils.escapeHtml(URLDecoder.decode(titleurl,"UTF-8"));
titleurl = StringEscapeUtils.escapeHtml(URLEncoder.encode(titleurl, "UTF-8"));

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
fromES = "true".equals(fromES) ? "true" : "";
//标记是从微搜模块进入end
String date = Util.null2String((String)request.getParameter("date"));
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
Date selectDate = null;
try {selectDate = dateFormat.parse(date);} catch (Exception e) {selectDate = new Date();}
date = DateFormatUtils.format(selectDate,"yyyy-MM-dd");

Map schedule = scheduleService.getSchedule(id, user);
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><%=title %></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<script type="text/javascript">
	function doLeftButton() {
		var fromES="<%=fromES%>";
		if(fromES=="true"){
			location = "/mobile/plugin/fullsearch/list.jsp?module=<%=module%>&scope=<%=scope%>&fromES=true";
		}else{
			location = "/mobile/plugin/4/list.jsp?module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>&date=<%=date%>";
		}
		return "0";
	}
	function doBack() {
		var result = doLeftButton();
		if(result==null||result=="BACK"){
			location = "/home.do";
		}
	}
	</script>
</head>
<body>

<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
			<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;"><%=title %></div>
		
	</div>

	<div style="">

<%if(schedule==null || schedule.size()<=0) {%>
	<div style="width:100%;height:200px;"><div style="padding:10px;"><%=SystemEnv.getHtmlLabelName(127911,user.getLanguage())%></div></div>
<%} else {
	String urgentLevel = "";
	int urgentLevelId = Util.getIntValue((String)schedule.get("urgentLevel"));
	switch(urgentLevelId) {
		case 1:
			urgentLevel = SystemEnv.getHtmlLabelName(154,user.getLanguage());
			break;
		case 2:
			urgentLevel = SystemEnv.getHtmlLabelName(15533,user.getLanguage());
			break;
		case 3:
			urgentLevel = SystemEnv.getHtmlLabelName(2087,user.getLanguage());
			break;
		default:
			urgentLevel = "";
	}
%>

	<div style="width:100%;height:40px;line-height:40px;text-align:center;font-size:16pt;color:#FFF;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;background: -moz-linear-gradient(top, #6CC2F8, #289CD9);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#6CC2F8', endColorstr='#289CD9');background: -webkit-gradient(linear, left top, left bottom, from(#6CC2F8), to(#289CD9));">
	<%=schedule.get("name") %>
	</div>
	
	<div style="width:100%;background:#F7F7F7;">
	
		<div style="height:30px;line-height:30px;padding-left:6px;padding-top:5px;">
		<%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%>:<%=schedule.get("creater") %>
		</div>
		
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>:<%=urgentLevel %>
		</div>
	
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>:<%=schedule.get("createdate") %> <%=schedule.get("createtime") %>
		</div>
		
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%>:<%=schedule.get("begindate") %> <%=schedule.get("begintime") %>
		</div>
		
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>:<%=schedule.get("enddate") %> <%=schedule.get("endtime") %>
		</div>
	
	</div>
	
	<div style="width:100%;color:#000;word-break:break-all;background: -moz-linear-gradient(top, #EAEAEA, #FCFCFC);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#EAEAEA', endColorstr='#FCFCFC');background: -webkit-gradient(linear, left top, left bottom, from(#EAEAEA), to(#FCFCFC));">
		<div style="padding: 10px;">
		<%=schedule.get("description") %>&nbsp;
		</div>
	</div>
<% } %>

</div>

</div>

<input type="hidden" id="date" name="date" value="<%=date%>">

<div id="loading"><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></div>
<div id="loadingmask" class="ui-widget-overlay"></div>

<script type="text/javascript">
$(document).ready(function() {
	
	$( "#loading" ).hide();
	$( "#loadingmask" ).hide();
	
});
</script>

</body>
</html>