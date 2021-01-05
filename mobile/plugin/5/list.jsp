
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.commons.lang.time.DateFormatUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="meetingService" class="weaver.mobile.plugin.ecology.service.MeetingService" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;

String detailid = Util.null2String((String)request.getParameter("detailid"));
int module = Util.getIntValue((String)request.getParameter("module"));
int scope = Util.getIntValue((String)request.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = StringEscapeUtils.escapeHtml(URLDecoder.decode(titleurl,"UTF-8"));
titleurl = StringEscapeUtils.escapeHtml(URLEncoder.encode(titleurl, "UTF-8"));

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

int pageIndex = Util.getIntValue((String)request.getParameter("pageIndex"), 1);
int pageSize = Util.getIntValue((String)request.getParameter("pageSize"), 10);

String date = Util.null2String((String)request.getParameter("date"));

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
Date selectDate = null;
try {selectDate = dateFormat.parse(date);} catch (Exception e) {selectDate = new Date();}
date = DateFormatUtils.format(selectDate,"yyyy-MM-dd");

List conditionList = new ArrayList();
String conditions = "";
String tmpconditions = "";

tmpconditions = "";
if(StringUtils.isNotEmpty(date)){
	tmpconditions += "meeting.begindate >= " + "'" + date + "'";
}
if(StringUtils.isNotEmpty(date)){
	if(StringUtils.isNotEmpty(tmpconditions)) tmpconditions += " and ";
	tmpconditions += "meeting.begindate <= " + "'" + date + "'";
}
if(StringUtils.isNotEmpty(tmpconditions)) conditions += "(" + tmpconditions + ")";

tmpconditions = "";
if(StringUtils.isNotEmpty(date)){
	tmpconditions += "meeting.enddate >= " + "'" + date + "'";
}
if(StringUtils.isNotEmpty(date)){
	if(StringUtils.isNotEmpty(tmpconditions)) tmpconditions += " and ";
	tmpconditions += "meeting.enddate <= " + "'" + date + "'";
}
if(StringUtils.isNotEmpty(tmpconditions)) conditions += " or " + "(" + tmpconditions + ")";

tmpconditions = "";
if(StringUtils.isNotEmpty(date)){
	tmpconditions += "meeting.begindate <= " + "'" + date + "'"; 
}		
if(StringUtils.isNotEmpty(date)){
	if(StringUtils.isNotEmpty(tmpconditions)) tmpconditions += " and ";
	tmpconditions += "meeting.enddate >= " + "'" + date + "'";
}
if(StringUtils.isNotEmpty(tmpconditions)) conditions += " or " + "(" + tmpconditions + ")";

tmpconditions = "(meeting.enddate is null or meeting.enddate = ''" + ")";
if(StringUtils.isNotEmpty(date)){
	tmpconditions += " and ";
	tmpconditions += "meeting.begindate <= " + "'" + date + "'";
}
if(StringUtils.isNotEmpty(tmpconditions)) conditions += " or " + "(" + tmpconditions + ")";

if(StringUtils.isNotEmpty(conditions)) conditionList.add("("+conditions+")");

Map pages = meetingService.getMeetingList(conditionList, pageIndex, pageSize, user);

int count = Util.getIntValue((String)pages.get("count"), 0);
int pageCount = Util.getIntValue((String)pages.get("pagecount"), 0);
String ishavepre = Util.null2String((String)pages.get("ishavepre"));
String ishavenext = Util.null2String((String)pages.get("ishavenext"));

List list = (List)pages.get("list");

int prePage = "1".equals(ishavepre) ? pageIndex-1 : 1;
int nextPage = "1".equals(ishavenext) ? pageIndex+1 : pageIndex;
%>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><%=title %> : <%=date %></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	</head>
	<script type="text/javascript">
	function doLeftButton() {
		location = "/mobile/plugin/5/select.jsp?&module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>&date=<%=date%>";
		return "0";
	}
	function doBack() {
		var result = doLeftButton();
		if(result==null||result=="BACK"){
			location = "/home.do";
		}
	}
	</script>
<body>

<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
			<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;"><%=title %></div>
		
	</div>
	
	<div style="position:relative;">
		<div style="width:100%;border-top:solid 1px #FFFFFF;border-bottom:solid 1px #D2D2D2;background: -moz-linear-gradient(top, #E9E9E9, #FDFDFD);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E9E9E9', endColorstr='#FDFDFD');background: -webkit-gradient(linear, left top, left bottom, from(#E9E9E9), to(#FDFDFD));">
			<div style="padding-left:10px;height:25px;color:#0081CC;font-size:14pt;line-height:25px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>:<%=date %></div>
		</div>
	<% if(count==0) { %>
		<div style="width:100%;"><div style="padding:15px;color:#333333;"><%=SystemEnv.getHtmlLabelName(125652,user.getLanguage())%></div></div>
	<% } else { %>
		<% for(int i=0; i<list.size(); i++) { 
			Map meeting = (Map)list.get(i);
			%>
			<a href="/mobile/plugin/5/view.jsp?id=<%=meeting.get("id") %>&pageIndex=<%=pageIndex %>&date=<%=date%>&index=<%=(pageIndex-1)*pageSize+i+1%>&module=<%=module%>&scope=<%=scope %>&title=<%=titleurl%>">
			<div style="width:100%;border-top:solid 1px #FFFFFF;border-bottom:solid 1px #D2D2D2;background: -moz-linear-gradient(top, #E9E9E9, #FDFDFD);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E9E9E9', endColorstr='#FDFDFD');background: -webkit-gradient(linear, left top, left bottom, from(#E9E9E9), to(#FDFDFD));">
				<div style="padding-left:10px;height:10px;"></div>
				<div style="padding-left:10px;height:25px;color:#0081CC;font-size:14pt;line-height:25px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;"><%=meeting.get("name") %></div>
				<div style="padding-left:10px;height:18px;color:#A3A3A3;font-size:9pt;line-height:18px;"><%=meeting.get("caller") %>&nbsp;<%=meeting.get("createdate") %></div>
				<div style="padding-left:10px;height:18px;color:#000000;font-size:10pt;line-height:18px;"><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%>:<%=meeting.get("begindate") %> <%=meeting.get("begintime") %></div>
				<div style="padding-left:10px;height:18px;color:#000000;font-size:10pt;line-height:18px;"><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>:<%=meeting.get("enddate") %> <%=meeting.get("endtime") %></div>
				<div style="padding-left:10px;height:10px;"></div>
			</div>
			</a>
		<%} %>
	<% } %>

	<% if(pageCount>1) { %>
	<div style="width:100%;height:30px;line-height:30px;background: -moz-linear-gradient(top, #FEFEFE, #E7E7E7);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FEFEFE', endColorstr='#E7E7E7');background: -webkit-gradient(linear, left top, left bottom, from(#FEFEFE), to(#E7E7E7));">
		<div style="float:left;">
		<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><%=pageIndex %><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><%=pageCount %><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>
		</div>
		<div style="float:right;">
		<a href="/mobile/plugin/5/list.jsp?pageIndex=1&date=<%=date%>&module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>" title="First Page"><strong>&lt;&lt;</strong> <%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%></a>
		<a href="/mobile/plugin/5/list.jsp?pageIndex=<%=prePage %>&date=<%=date%>&module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>" title="Prev Page"><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></a>
		<a href="/mobile/plugin/5/list.jsp?pageIndex=<%=nextPage %>&date=<%=date%>&module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>" title="Next Page"><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></a>
		<a href="/mobile/plugin/5/list.jsp?pageIndex=<%=pageCount %>&date=<%=date%>&module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>" title="Last Page"><%=SystemEnv.getHtmlLabelName(34191,user.getLanguage())%> <strong>&gt;&gt;</strong></a>
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