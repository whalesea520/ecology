<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OfsManager" class="weaver.ofs.manager.OfsManager" scope="page" />
<jsp:useBean id="OfsTodoDataService" class="weaver.ofs.service.OfsTodoDataService" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
//FileUpload fu = new FileUpload(request);
String isDialog = Util.null2String(request.getParameter("isdialog"));//返回类型
String backto = Util.null2String(request.getParameter("backto"));//返回类型
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String sysid = Util.fromScreen(request.getParameter("sysid"),user.getLanguage());

char separator = Util.getSeparator() ;
if(operation.equals("delete")){
	List ids = Util.TokenizerString(id,",");
	if(null!=ids&&ids.size()>0)	{
		for(int i = 0;i<ids.size();i++){
			String tempid = Util.null2String((String)ids.get(i));
			if(!"".equals(tempid)){
			    SysMaintenanceLog.resetParameter();
			    SysMaintenanceLog.setRelatedId(Util.getIntValue(tempid));
			    SysMaintenanceLog.setRelatedName(OfsManager.getOfsTodoDataOneBean(Util.getIntValue(tempid)).getRequestname());
			    SysMaintenanceLog.setOperateType("3");
			    SysMaintenanceLog.setOperateDesc("Ofs_todo_data_delete,"+tempid);
			    SysMaintenanceLog.setOperateItem("168");
			    SysMaintenanceLog.setOperateUserid(user.getUID());
			    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			    SysMaintenanceLog.setSysLogInfo();
			    OfsTodoDataService.delete(Util.getIntValue(tempid));
			}
		}
	}
} 
if("1".equals(isDialog))
    response.sendRedirect("/integration/ofs/OfsWorkflowToDodataList.jsp?backto="+backto+"&operation="+operation+"&sysid="+sysid);
else
response.sendRedirect("/integration/ofs/OfsToDodataList.jsp?backto="+backto+"&operation="+operation+"&sysid="+sysid);
%>