<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="BudgetModuleComInfo" class="weaver.fna.maintenance.BudgetModuleComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FnaBudgetModuleAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addbudgetmodule")){
     
  	String budgetname = Util.fromScreen(request.getParameter("budgetname"),user.getLanguage());
	String budgetdesc = Util.fromScreen(request.getParameter("budgetdesc"),user.getLanguage());
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsidfrom = Util.null2String(request.getParameter("periodsidfrom"));
	String periodsidto = Util.null2String(request.getParameter("periodsidto"));
	if(Util.getIntValue(periodsidfrom) > Util.getIntValue(periodsidto)) {
		String tmpperiodsid = periodsidfrom ;
		periodsidfrom = periodsidto  ;
		periodsidto = tmpperiodsid ;
	}

	String para = budgetname + separator + budgetdesc + separator + fnayear + separator + periodsidfrom + separator + periodsidto ;
	RecordSet.executeProc("FnaBudgetModule_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(budgetname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("FnaBudgetModule_Insert,"+para);
	SysMaintenanceLog.setOperateItem("38");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	BudgetModuleComInfo.removeBudgetModuleCache();
	response.sendRedirect("FnaBudgetModule.jsp");
 }
else if(operation.equals("editbudgetmodule")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String budgetname = Util.fromScreen(request.getParameter("budgetname"),user.getLanguage());
	String budgetdesc = Util.fromScreen(request.getParameter("budgetdesc"),user.getLanguage());
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsidfrom = Util.null2String(request.getParameter("periodsidfrom"));
	String periodsidto = Util.null2String(request.getParameter("periodsidto"));
	if(Util.getIntValue(periodsidfrom) > Util.getIntValue(periodsidto)) {
		String tmpperiodsid = periodsidfrom ;
		periodsidfrom = periodsidto  ;
		periodsidto = tmpperiodsid ;
	}

	String para = ""+id + separator + budgetname + separator + budgetdesc + separator + fnayear + separator + periodsidfrom + separator + periodsidto ;
	
	RecordSet.executeProc("FnaBudgetModule_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(budgetname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaBudgetModule_Update,"+para);
    SysMaintenanceLog.setOperateItem("38");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
	BudgetModuleComInfo.removeBudgetModuleCache();
 	response.sendRedirect("FnaBudgetModule.jsp");
 }
 else if(operation.equals("deletebudgetmodule")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String budgetname = Util.fromScreen(request.getParameter("budgetname"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("FnaBudgetModule_Delete",para);
	if(!RecordSet.next()){
		response.sendRedirect("FnaBudgetModuleEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(budgetname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("FnaBudgetModule_Delete,"+para);
      SysMaintenanceLog.setOperateItem("38");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	
	BudgetModuleComInfo.removeBudgetModuleCache();
 	response.sendRedirect("FnaBudgetModule.jsp");
 }

%>
