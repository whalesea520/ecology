<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="PaymentTypeComInfo" class="weaver.lgc.maintenance.PaymentTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addtype")){
     
  	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String paymentid = Util.null2String(request.getParameter("paymentid"));
	

	String para = typename + separator + typedesc + separator + paymentid ;
	
	RecordSet.executeProc("LgcPaymentType_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(typename);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcPaymentType_Insert,"+para);
	SysMaintenanceLog.setOperateItem("48");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	PaymentTypeComInfo.removePaymentTypeCache() ;
	response.sendRedirect("LgcPaymentType.jsp");
 }
else if(operation.equals("edittype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String paymentid = Util.null2String(request.getParameter("paymentid"));
	

	String para = ""+id + separator + typename + separator + typedesc + separator + paymentid ;

	RecordSet.executeProc("LgcPaymentType_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(typename);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcPaymentType_Update,"+para);
    SysMaintenanceLog.setOperateItem("48");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	PaymentTypeComInfo.removePaymentTypeCache() ;

 	response.sendRedirect("LgcPaymentType.jsp");
 }
 else if(operation.equals("deletetype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcPaymentType_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcPaymentTypeEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(typename);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcPaymentType_Delete,"+para);
      SysMaintenanceLog.setOperateItem("48");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	PaymentTypeComInfo.removePaymentTypeCache() ;

 	response.sendRedirect("LgcPaymentType.jsp");
 }
%>
