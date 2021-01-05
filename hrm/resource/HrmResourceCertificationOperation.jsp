<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

String resourceid = Util.null2String(request.getParameter("resourceid"));

if(operation.equals("add")||operation.equals("edit")){ 
	String datefrom = Util.null2String(request.getParameter("datefrom"));
	String dateto = Util.null2String(request.getParameter("dateto"));
	String certname = Util.fromScreen(request.getParameter("certname"),user.getLanguage());
	String awardfrom = Util.fromScreen(request.getParameter("awardfrom"),user.getLanguage());

	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	Calendar now = Calendar.getInstance();
	String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

	String createrid = ""+user.getUID();
	String createdate = currentdate ;
	String createtime = currenttime ;
	String lastmodid = ""+user.getUID();
	String lastmoddate = currentdate ;
	String lastmodtime = currenttime ;



 if(operation.equals("add")){
	String para = "";
	
	para  = resourceid;
	para += separator+datefrom;
	para += separator+dateto;
	para += separator+certname;
	para += separator+awardfrom;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+createtime;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmCertification_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
/*
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("68");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("HrmWorkResume_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();
*/
	response.sendRedirect("HrmResourceCertification.jsp?resourceid="+resourceid);
 } //end 
  else if(operation.equals("edit")){
	String certificationid = Util.null2String(request.getParameter("certificationid"));

	String para = "";

	para += certificationid;
	para += separator+resourceid;
	para += separator+datefrom;
	para += separator+dateto;
	para += separator+certname;
	para += separator+awardfrom;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmCertification_Update",para);
	RecordSet.next();
/*
    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(workresumeid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmWorkResume_Update,"+para);
	SysMaintenanceLog.setOperateItem("68");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
*/
	response.sendRedirect("HrmResourceCertification.jsp?resourceid="+resourceid);
 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int certificationid = Util.getIntValue(request.getParameter("certificationid"));

	String para = ""+certificationid;

	RecordSet.executeProc("HrmCertification_Delete",para);
	RecordSet.next();
/*
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(workresumeid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmWorkResume_Delete,"+para);
      SysMaintenanceLog.setOperateItem("68");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
*/
      response.sendRedirect("HrmResourceCertification.jsp?resourceid="+resourceid);
}
%>
