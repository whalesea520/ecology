
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());
String instockdate = Util.fromScreen(request.getParameter("instockdate"),user.getLanguage());
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:InStock", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

    para = capitalid;
    para +=separator+instockdate;
    para +=separator+capitalnum;
    para +=separator+userequest;
    para +=separator+remark;

    RecordSet.executeProc("CptUseLogInStock2_Insert",para);

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">