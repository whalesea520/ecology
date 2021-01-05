<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser(request, response);
if(null == user || !HrmUserVarify.checkUserRight("SRDoc:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String method=Util.null2String(request.getParameter("method"));
if(method.equals("getSubcompanyid")){
	 int superiorUnitId = Util.getIntValue(request.getParameter("superiorUnitId"),0);
	 int subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(""+superiorUnitId), 0);
	 String	subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
	 JSONObject json = new JSONObject();
	 json.put("subcompanyid",subcompanyid);
	 json.put("subcompanyname",subcompanyname);
	 out.print(json.toString());
 }
%>
