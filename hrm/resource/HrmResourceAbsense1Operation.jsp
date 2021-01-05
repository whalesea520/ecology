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
	String absensetype = Util.fromScreen(request.getParameter("absensetype"),user.getLanguage());
	String absenseday = Util.fromScreen(request.getParameter("absenseday"),user.getLanguage());
    if(absenseday.equals("")){
        absenseday="0";
    }

 if(operation.equals("add")){
	String para = "";
	
	para  = "0";
	para += separator+resourceid;
	para += separator+"";
    para += separator+datefrom;
    para += separator+"";
	para += separator+dateto;
	para += separator+"";
	para += separator+absenseday;
	para += separator+"0";
	para += separator+absensetype;
	para += separator+"1";

    RecordSet.executeProc("HrmAbsense1_Insert",para);
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
	response.sendRedirect("HrmResourceAbsense1.jsp?resourceid="+resourceid);
 } //end 
  else if(operation.equals("edit")){
	String absense1id = Util.null2String(request.getParameter("absense1id"));

	String para = "";

	para += absense1id;
	para += separator+"0";
    para += separator+resourceid;
	para += separator+"";
    para += separator+datefrom;
    para += separator+"";
	para += separator+dateto;
	para += separator+"";
	para += separator+absenseday;
	para += separator+"0";
	para += separator+absensetype;
	para += separator+"1";
	
	RecordSet.executeProc("HrmAbsense1_Update",para);
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
	response.sendRedirect("HrmResourceAbsense1.jsp?resourceid="+resourceid);
 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int absense1id = Util.getIntValue(request.getParameter("absense1id"));

	String para = ""+absense1id;

	RecordSet.executeProc("HrmAbsense1_Delete",para);
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
      response.sendRedirect("HrmResourceAbsense1.jsp?resourceid="+resourceid);
}
%>