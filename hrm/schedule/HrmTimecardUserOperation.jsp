<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
  String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  String usercode = Util.fromScreen(request.getParameter("usercode"),user.getLanguage());  
  int flag = 1 ;
  char separator = Util.getSeparator() ; 
  
  
  String para = id +separator+ usercode ;
  rs.executeProc("HrmTimecardUser_Update",para);
  if(rs.next()) flag = Util.getIntValue(rs.getString(1),1) ;  
  if(flag == -1 ){
      response.sendRedirect("HrmTimecardUserEdit.jsp?errmsg=1&id="+id+"&usercode="+usercode);
      return;
  }      
  response.sendRedirect("HrmTimecardUser.jsp");
%>