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
	String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
	String jobtitle = Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
	String joblevel = Util.fromScreen(request.getParameter("joblevel"),user.getLanguage());

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
	para += separator+departmentid;
	para += separator+jobtitle;
	para += separator+joblevel;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+createtime;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmWorkResumeIn_Insert",para);
	RecordSet.next() ;
/*	int	id = RecordSet.getInt(1);

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
	response.sendRedirect("HrmResourceWorkResumeIn.jsp?resourceid="+resourceid);
 } //end 
  else if(operation.equals("edit")){
	String workresumeinid = Util.null2String(request.getParameter("workresumeinid"));

	String para = "";

	para += workresumeinid;
	para += separator+resourceid;
	para += separator+datefrom;
	para += separator+dateto;
	para += separator+departmentid;
	para += separator+jobtitle;
	para += separator+joblevel;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmWorkResumeIn_Update",para);
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
	response.sendRedirect("HrmResourceWorkResumeIn.jsp?resourceid="+resourceid);
 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int workresumeinid = Util.getIntValue(request.getParameter("workresumeinid"));

	String para = ""+workresumeinid;

	RecordSet.executeProc("HrmWorkResumeIn_Delete",para);
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
      response.sendRedirect("HrmResourceWorkResumeIn.jsp?resourceid="+resourceid);
}
%>
