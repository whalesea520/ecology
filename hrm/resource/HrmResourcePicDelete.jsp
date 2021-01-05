<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="fieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="detailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%
out.clear();
char separator = Util.getSeparator() ;
String id = Util.null2String(request.getParameter("id")) ;
String oldresourceimageid= Util.null2String(request.getParameter("oldresourceimageid"));
String firstname = Util.fromScreen3(request.getParameter("firstname"),user.getLanguage());
String lastname = Util.fromScreen3(request.getParameter("lastname"),user.getLanguage());
rs.executeProc("HrmResource_UpdatePic",id+separator+oldresourceimageid);

SysMaintenanceLog.resetParameter();
SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
SysMaintenanceLog.setRelatedName(firstname+" "+lastname);
SysMaintenanceLog.setOperateItem("29");
SysMaintenanceLog.setOperateUserid(user.getUID());
SysMaintenanceLog.setClientAddress(Util.getIpAddr(request));
SysMaintenanceLog.setOperateType("2");
SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePic,"+id+separator+oldresourceimageid);
SysMaintenanceLog.setSysLogInfo();

//if(view.equals("contactinfo")){
//	response.sendRedirect("HrmResourceContactEdit.jsp?id="+id+"&isView="+isView+"&isfromtab="+isfromtab);
//}else{
//	response.sendRedirect("HrmResourceBasicEdit.jsp?id="+id+"&isView="+isView+"&isfromtab="+isfromtab); 
//}
return ;

%>