
<%@page import="weaver.formmode.data.ModeDataInterface"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
 %>
<%

int pageexpandid = Util.getIntValue(request.getParameter("pageexpandid"),0);
int modeid = Util.getIntValue(request.getParameter("modeid"),-1);
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int isbill = 1;
String billid = Util.null2String(request.getParameter("billid"));
ModeDataInterface modeDataInterface = new ModeDataInterface(billid,modeid);
modeDataInterface.setPageexpandid(pageexpandid);
modeDataInterface.setUser(user);
modeDataInterface.execute();
%>
<%=true%>
