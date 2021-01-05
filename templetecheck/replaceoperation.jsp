<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.MatchUtil" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String tabtype = request.getParameter("tabtype");
String ruleid = request.getParameter("ruleid");
String ishtml = request.getParameter("ishtml");
String isall = request.getParameter("isall");
String filepath = request.getParameter("filepath");
String type = request.getParameter("type");
String pageid = request.getParameter("pageid");

boolean res = false;
MatchUtil match = new MatchUtil();
if("1".equals(isall)) {//单文件全部替换
	//res = match.replaceContent(tabtype,ruleid,ishtml);
	if("1".equals(type)) {
		res = match.replaceContent_MobileMode(tabtype,pageid,ishtml,isall);
	} else {
		res = match.replaceContent(tabtype,filepath,ishtml,isall);
	}
	
} else if("0".equals(isall)){//单个结果替换
	if("1".equals(type)) {
		res = match.replaceContentWithPageid(tabtype,ruleid,ishtml,pageid);
	} else {
		res = match.replaceContentWithPath(tabtype,ruleid,ishtml,filepath);
	}
	
} else if("2".equals(isall)){//多结果批量替换
	if("1".equals(type)) {
		res = match.replaceContentWithPageid(tabtype,ruleid,ishtml,pageid);
	} else {
		res = match.replaceContentWithPath(tabtype,ruleid,ishtml,filepath);
	}
	
} else {//所有文件一次性替换
	if("1".equals(type)) {
		res = match.replaceContent_MobileMode(tabtype,"",ishtml,isall);
	} else {
		res = match.replaceContent(tabtype,"",ishtml,isall);
	}
	
}

if(res) {
	out.print("{\"status\":\"ok\"}");
} else {
	out.print("{\"status\":\"no\"}");
}

%>