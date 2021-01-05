
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());
String moveoutdate = Util.fromScreen(request.getParameter("moveoutdate"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String costcenterid = Util.fromScreen(request.getParameter("costcenterid"),user.getLanguage());
String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String location = Util.fromScreen(request.getParameter("location"),user.getLanguage());
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:MoveOut", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

    para = capitalid;
    para +=separator+moveoutdate;
    para +=separator+departmentid;
    para +=separator+resourceid;
    para +=separator+capitalnum;
    para +=separator+location;
    para +=separator+userequest;
    para +=separator+"";
    para +=separator+"0";
    para +=separator+"1";
    para +=separator+remark;
    para +=separator+costcenterid;

    RecordSet.executeProc("CptUseLogMoveOut_Insert",para);
    RecordSet.next();
    String rtvalue = RecordSet.getString(1);
    //数量错误
    if(rtvalue.equals("-1")){
        response.sendRedirect("CptCapitalMoveOut.jsp?capitalid="+capitalid+"&msgid=1");
    }

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">