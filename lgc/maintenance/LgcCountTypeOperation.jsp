<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CountTypeComInfo" class="weaver.lgc.maintenance.CountTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addtype")){
     
  	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String salesinid = Util.null2String(request.getParameter("salesinid"));
	String salescostid = Util.null2String(request.getParameter("salescostid"));
	String salestaxid = Util.null2String(request.getParameter("salestaxid"));
	String purchasetaxid = Util.null2String(request.getParameter("purchasetaxid"));
	String stockid = Util.null2String(request.getParameter("stockid"));
	String stockdiffid = Util.null2String(request.getParameter("stockdiffid"));
	String producecostid = Util.null2String(request.getParameter("producecostid"));

	String para = typename + separator + typedesc + separator + salesinid + separator + salescostid
				  + separator + salestaxid + separator + purchasetaxid + separator + stockid 
				  + separator + stockdiffid + separator + producecostid ;
	
	RecordSet.executeProc("LgcCountType_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(typename);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcCountType_Insert,"+para);
	SysMaintenanceLog.setOperateItem("47");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	CountTypeComInfo.removeCountTypeCache() ;

	response.sendRedirect("LgcCountType.jsp");
 }
else if(operation.equals("edittype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String salesinid = Util.null2String(request.getParameter("salesinid"));
	String salescostid = Util.null2String(request.getParameter("salescostid"));
	String salestaxid = Util.null2String(request.getParameter("salestaxid"));
	String purchasetaxid = Util.null2String(request.getParameter("purchasetaxid"));
	String stockid = Util.null2String(request.getParameter("stockid"));
	String stockdiffid = Util.null2String(request.getParameter("stockdiffid"));
	String producecostid = Util.null2String(request.getParameter("producecostid"));

	String para = ""+id + separator + typename + separator + typedesc + separator + salesinid 
				  + separator + salescostid + separator + salestaxid + separator + purchasetaxid
				  + separator + stockid + separator + stockdiffid + separator + producecostid ;

	RecordSet.executeProc("LgcCountType_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(typename);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcCountType_Update,"+para);
    SysMaintenanceLog.setOperateItem("47");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	CountTypeComInfo.removeCountTypeCache() ;

 	response.sendRedirect("LgcCountType.jsp");
 }
 else if(operation.equals("deletetype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcCountType_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcCountTypeEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(typename);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcCountType_Delete,"+para);
      SysMaintenanceLog.setOperateItem("47");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	CountTypeComInfo.removeCountTypeCache() ;

 	response.sendRedirect("LgcCountType.jsp");
 }
%>
