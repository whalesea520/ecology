<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>
<jsp:useBean id="HrmSubordinateUtil" class="weaver.hrm.tools.HrmSubordinateUtil" scope="page" />
<%
String id=Util.null2String(request.getParameter("id"));
int isfirst=Util.getIntValue(request.getParameter("isfirst"), 1);

String treeStr = "";
if(!id.equals("")){
    treeStr = HrmSubordinateUtil.getSubordinateTreeList(id,isfirst);
}

out.print(treeStr);
%>