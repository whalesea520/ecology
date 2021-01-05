
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String handoverdate = Util.fromScreen(request.getParameter("handoverdate"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String costcenterid = Util.fromScreen(request.getParameter("costcenterid"),user.getLanguage());
String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String location = Util.fromScreen(request.getParameter("location"),user.getLanguage());
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:HandOver", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

    para = capitalid;
    para +=separator+handoverdate;
    para +=separator+departmentid;
    para +=separator+resourceid;
    para +=separator+"1";
    para +=separator+location;
    para +=separator+userequest;
    para +=separator+"";
    para +=separator+"0";
    para +=separator+"2";
    para +=separator+remark;
    para +=separator+costcenterid;

    RecordSet.executeProc("CptUseLogHandOver_Insert",para);

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">