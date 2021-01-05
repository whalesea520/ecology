
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.text.*" %>
<%@ page import="org.apache.commons.lang.time.DateFormatUtils" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="meetingService" class="weaver.mobile.plugin.ecology.service.MeetingService" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
if(true){
	request.getRequestDispatcher("/mobile/plugin/5/detail.jsp").forward(request, response); 
	return;
}
User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;

int id = Util.getIntValue((String)request.getParameter("id"));
int detailid = Util.getIntValue(request.getParameter("detailid"));
int module = Util.getIntValue(request.getParameter("module"));
int scope = Util.getIntValue(request.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = StringEscapeUtils.escapeHtml(URLDecoder.decode(titleurl,"UTF-8"));
titleurl = StringEscapeUtils.escapeHtml(URLEncoder.encode(titleurl, "UTF-8"));

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

String date = Util.null2String((String)request.getParameter("date"));
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
Date selectDate = null;
try {selectDate = dateFormat.parse(date);} catch (Exception e) {selectDate = new Date();}
date = DateFormatUtils.format(selectDate,"yyyy-MM-dd");

int requestid = Util.getIntValue((String)request.getParameter("requestid"));
String fromWF = Util.null2String((String)request.getParameter("fromWF"));
fromWF = "true".equals(fromWF) ? "true" : "";
int fromRequestid = Util.getIntValue(request.getParameter("fromRequestid"), 0);

Map meeting = meetingService.getMeeting(id, user);
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
		var fromWF = "<%=fromWF%>";
		if(fromWF == "true"){
			location = '/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&module=<%=module%>&scope=<%=scope%>&fromRequestid=<%=fromRequestid%>';
			return 1;
		}else{
			location = "/mobile/plugin/5/list.jsp?module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>&date=<%=date%>";
			return "0";
		}
	}
	
	function doBack() {
		var fromWF = "<%=fromWF%>";
		if(fromWF == "true"){
			location = '/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&module=<%=module%>&scope=<%=scope%>&fromRequestid=<%=fromRequestid%>';
			return 1;
		} else {
			var result = doLeftButton();
			if(result==null||result=="BACK"){
				location = "/home.do";
			}
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

<%if(meeting==null || meeting.size()<=0) {%>
	<div style="width:100%;height:280px;"><div style="padding:10px;"><%=SystemEnv.getHtmlLabelName(127908,user.getLanguage())%></div></div>
<%} else {
	String meetingstatus = "";
	int meetingstatusId = Util.getIntValue((String)meeting.get("meetingstatus"));
	switch(meetingstatusId) {
		case 0:
			meetingstatus = SystemEnv.getHtmlLabelName(220,user.getLanguage());
			break;
		case 1:
			meetingstatus = SystemEnv.getHtmlLabelName(2242,user.getLanguage());
			break;
		case 2:
			meetingstatus = SystemEnv.getHtmlLabelName(225,user.getLanguage());
			break;
		case 3:
			meetingstatus = SystemEnv.getHtmlLabelName(1010,user.getLanguage());
			break;
		default:
			meetingstatus = "";
	}
%>

	<div style="width:100%;height:40px;line-height:40px;text-align:center;font-size:16pt;color:#FFF;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;background: -moz-linear-gradient(top, #6CC2F8, #289CD9);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#6CC2F8', endColorstr='#289CD9');background: -webkit-gradient(linear, left top, left bottom, from(#6CC2F8), to(#289CD9));">
	<%=meeting.get("name") %>
	</div>
	
	<div style="width:100%;background:#F7F7F7;">
	
		<div style="height:30px;line-height:30px;padding-left:6px;padding-top:5px;">
		<%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%>:<%=meeting.get("caller") %>
		</div>
		
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%>:<%=meeting.get("address") %>
		</div>
		
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(20392,user.getLanguage())%>:<%=meeting.get("customizeAddress") %>
		</div>
	
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>:<%=meetingstatus %></span>
		</div>
		
		<%-- 参会人员可能较多，18像素高度可能会超出占用下边的开始和结束时间。 --%>
		<div style="line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>:<%=meeting.get("othermemberstr") %>
		</div>
		
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(83901,user.getLanguage())%>:<%=meeting.get("begindate") %> <%=meeting.get("begintime") %>
		</div>
		
		<div style="height:18px;line-height:18px;padding-left:6px;">
		<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>:<%=meeting.get("enddate") %> <%=meeting.get("endtime") %>
		</div>
	
	</div>
	
	<div style="width:100%;color:#000;word-break:break-all;background: -moz-linear-gradient(top, #EAEAEA, #FCFCFC);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#EAEAEA', endColorstr='#FCFCFC');background: -webkit-gradient(linear, left top, left bottom, from(#EAEAEA), to(#FCFCFC));">
		<div style="padding: 10px;">
		<%=meeting.get("decision") %>&nbsp;
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