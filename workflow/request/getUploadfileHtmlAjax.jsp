<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.workflow.field.FileElement"%>
<%@page import="java.util.Hashtable"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.checkUser(request,response);
if(user == null){
	return;
}
String fieldvalue = Util.null2String(request.getParameter("fieldvalue"));
int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
int isbill = Util.getIntValue(Util.null2String(request.getParameter("isbill")),0);
int requestid = Util.getIntValue(Util.null2String(request.getParameter("requestid")),0);
int fieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
int derecorderindex = Util.getIntValue(Util.null2String(request.getParameter("derecorderindex")),0);
int ismand = Util.getIntValue(Util.null2String(request.getParameter("ismand")),0);
int type = Util.getIntValue(Util.null2String(request.getParameter("type")),0);
int linknum = Util.getIntValue(Util.null2String(request.getParameter("linknum")),0);
String sql = "";
if(!fieldvalue.equals("")){
	String inputStr = "";
	FileElement fileElement = new FileElement();
    Hashtable ret_hs = fileElement.getHtmlElementNewString(workflowid,isbill,requestid,fieldid,derecorderindex,ismand,type,fieldvalue,user,linknum);
    inputStr = Util.null2String(ret_hs.get("inputStr"));  
    out.print(inputStr);
}
		
%>