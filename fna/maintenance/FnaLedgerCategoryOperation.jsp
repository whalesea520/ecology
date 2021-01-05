<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="LedgerCategoryComInfo" class="weaver.fna.maintenance.LedgerCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FnaLedgerCategoryAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addcategory")){
     
  	String categorydesc = Util.fromScreen(request.getParameter("categorydesc"),user.getLanguage());
	String categoryname = Util.fromScreen(request.getParameter("categoryname"),user.getLanguage());
	String para = categoryname + separator + categorydesc ;
	RecordSet.executeProc("FnaLedgerCategory_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(categoryname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("FnaLedgerCategory_Insert,"+para);
	SysMaintenanceLog.setOperateItem("35");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	LedgerCategoryComInfo.removeLedgerCategoryCache() ;

	response.sendRedirect("FnaLedgerCategory.jsp");
 }
else if(operation.equals("editcategory")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String categorydesc = Util.fromScreen(request.getParameter("categorydesc"),user.getLanguage());
	String categoryname = Util.fromScreen(request.getParameter("categoryname"),user.getLanguage());
	String para = ""+id + separator + categoryname + separator + categorydesc ;
	RecordSet.executeProc("FnaLedgerCategory_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(categoryname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaLedgerCategory_Update,"+para);
    SysMaintenanceLog.setOperateItem("35");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	LedgerCategoryComInfo.removeLedgerCategoryCache() ;

 	response.sendRedirect("FnaLedgerCategory.jsp");
 }
 else if(operation.equals("deletecategory")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String categoryname = Util.fromScreen(request.getParameter("categoryname"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("FnaLedgerCategory_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("20")){
		response.sendRedirect("FnaLedgerCategoryEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(categoryname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("FnaLedgerCategory_Delete,"+para);
      SysMaintenanceLog.setOperateItem("35");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	LedgerCategoryComInfo.removeLedgerCategoryCache() ;

 	response.sendRedirect("FnaLedgerCategory.jsp");
 }
%>
