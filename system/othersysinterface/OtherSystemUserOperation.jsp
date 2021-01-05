<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
  String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  String loginid = Util.fromScreen(request.getParameter("loginid"),user.getLanguage());  
  String password = Util.fromScreen(request.getParameter("password"),user.getLanguage());  
  
  String operation  = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  String sql = "";
  String para = "";
  char separator = Util.getSeparator() ; 
  
  if(operation.equals("add")){
      para = id +separator+ loginid+separator+"1"+separator+password;
      rs.executeProc("Ycuser_Insert",para);
      rs.next();
      int flag = rs.getInt(1);    
      if(flag == 1 ){
          response.sendRedirect("OtherSystemUserAdd.jsp?errmsg=1&id="+id);
          return;
      }
        
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("Ycuser_Insert,"+para);
      SysMaintenanceLog.setOperateItem("84");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
          
      response.sendRedirect("OtherSystemUser.jsp");
      return;
  }
  
  if(operation.equals("edit")){
      para = id +separator+ loginid+separator+"1"+separator+password;
      rs.executeProc("Ycuser_Update",para);
      rs.next();
      int flag = rs.getInt(1);    
      if(flag == 1 ){
          response.sendRedirect("OtherSystemUserEdit.jsp?errmsg=1&id="+id);
          return;
      }
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("Ycuser_Update,"+para);
      SysMaintenanceLog.setOperateItem("84");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
          
      response.sendRedirect("OtherSystemUser.jsp");
      return;
  }
  
  if(operation.equals("delete")){
      para = ""+id;     
      rs.executeProc("Ycuser_Delete",para);
        
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("Ycuser_Delete,"+para);
      SysMaintenanceLog.setOperateItem("84");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      response.sendRedirect("OtherSystemUser.jsp");
      return;
  }
%>