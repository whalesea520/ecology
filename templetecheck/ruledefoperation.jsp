<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD></HEAD><body></body></HTML>
<%

String names[] = request.getParameterValues("name");
String contents[] = request.getParameterValues("content");
String descs[] = request.getParameterValues("desc");
String replacecontents[] = request.getParameterValues("replacecontent");
String path  = request.getParameter("path");
String workhtmlcheck = request.getParameter("workhtmlcheck");

ArrayList<CheckUtil.Rule> rules = new ArrayList<CheckUtil.Rule>();

CheckUtil checkutil = new CheckUtil("1");
for(int i = 0; contents!=null&&i < contents.length ;i++) {
	
	String content = contents[i];
	if(content == null || "".equals(content)) {
		continue;
	}
	String replacecontent = replacecontents[i];
	String desc = descs[i];
	String name = names[i];
	if("".equals(name)) {
		name = "defined"+i;
	}
	if("".equals(desc)) {
		desc = "defined"+i;
	}
	CheckUtil.Rule rule  = checkutil.new Rule();
	
	rule.setName(checkutil.changeStr(name));
	rule.setDescription(checkutil.changeStr(desc));
	rule.setContent(checkutil.changeStr(content));
	rule.setReplacecontent(checkutil.changeStr(replacecontent));
	rule.setFlageid(checkutil.changeStr("defined"+i));
	
	rules.add(rule);
}
checkutil.saveDefRule(rules,path,workhtmlcheck);
response.sendRedirect("matchrule.jsp");

%>