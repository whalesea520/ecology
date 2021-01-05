
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());
String moveindate = Util.fromScreen(request.getParameter("moveindate"),user.getLanguage());
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:MoveIn", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

    para = capitalid;
    para +=separator+moveindate;
    para +=separator+capitalnum;
    para +=separator+userequest;
    para +=separator+remark;

    RecordSet.executeProc("CptUseLogMoveIn_Insert",para);

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">