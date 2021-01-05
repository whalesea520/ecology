<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

if(operation.equals("add")||operation.equals("edit")){ 
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String trainstartdate = Util.null2String(request.getParameter("trainstartdate"));
	String trainenddate = Util.null2String(request.getParameter("trainenddate"));
	String traintype = Util.null2String(request.getParameter("traintype"));
	String trainrecord = Util.fromScreen(request.getParameter("trainrecord"),user.getLanguage());
	String trainhour = Util.fromScreen(request.getParameter("trainhour"),user.getLanguage());
	String trainunit = Util.fromScreen(request.getParameter("trainunit"),user.getLanguage());

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
	para += separator+trainstartdate;
	para += separator+trainenddate;
	para += separator+traintype;
	para += separator+trainrecord;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+createtime;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	para += separator+trainhour;
	para += separator+trainunit;
	
	RecordSet.executeProc("HrmTrainRecord_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("71");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("HrmTrainRecord_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("HrmResourceTrainRecord.jsp?resourceid="+resourceid);
 } //end 
  else if(operation.equals("edit")){
	String trainrecordid = Util.null2String(request.getParameter("trainrecordid"));

	String para = "";

	para += trainrecordid;
	para += separator+resourceid;
	para += separator+trainstartdate;
	para += separator+trainenddate;
	para += separator+traintype;
	para += separator+trainrecord;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	para += separator+trainhour;
	para += separator+trainunit;
	
	RecordSet.executeProc("HrmTrainRecord_Update",para);
	RecordSet.next();

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(trainrecordid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmTrainRecord_Update,"+para);
	SysMaintenanceLog.setOperateItem("71");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("HrmResourceTrainRecord.jsp?resourceid="+resourceid);
 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int trainrecordid = Util.getIntValue(request.getParameter("trainrecordid"));

	String para = ""+trainrecordid;
	String resourceid = Util.null2String(request.getParameter("resourceid"));

	RecordSet.executeProc("HrmTrainRecord_Delete",para);
	RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(trainrecordid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmTrainRecord_Delete,"+para);
      SysMaintenanceLog.setOperateItem("71");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	response.sendRedirect("HrmResourceTrainRecord.jsp?resourceid="+resourceid);
 }
%>
