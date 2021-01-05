<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CostcenterMainComInfo" class="weaver.hrm.company.CostcenterMainComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

int id = Util.getIntValue(request.getParameter("id"));
String ccmaincategoryname = Util.fromScreen(request.getParameter("ccmaincategoryname"),user.getLanguage());
String ccmaincategorydesc = Util.fromScreen(request.getParameter("ccmaincategorydesc"),user.getLanguage());

char separator = Util.getSeparator() ;
  	
	String para = ""+id + separator + ccmaincategoryname+separator+ccmaincategorydesc;
	out.println(para);
	out.println(RecordSet.executeProc("HrmCostcenterMainCategory_U",para));
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(ccmaincategoryname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCompany_Update,"+para);
      SysMaintenanceLog.setOperateItem("18");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      
  	

	CostcenterMainComInfo.removeCostcenterMainCache();
 	response.sendRedirect("HrmCostcenterMainCategory.jsp");
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">