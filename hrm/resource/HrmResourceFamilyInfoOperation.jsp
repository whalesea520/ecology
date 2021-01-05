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
	String member = Util.fromScreen(request.getParameter("member"),user.getLanguage());
	String title = Util.fromScreen(request.getParameter("title"),user.getLanguage());
	String company = Util.fromScreen(request.getParameter("company"),user.getLanguage());
	String jobtitle = Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
	String address = Util.fromScreen(request.getParameter("address"),user.getLanguage());

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
	para += separator+member;
	para += separator+title;
	para += separator+company;
	para += separator+jobtitle;
	para += separator+address;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+createtime;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmFamilyInfo_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("70");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("HrmFamilyInfo_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("HrmResourceFamilyInfo.jsp?resourceid="+resourceid);
 } //end 
  else if(operation.equals("edit")){
	String familyinfoid = Util.null2String(request.getParameter("familyinfoid"));

	String para = "";

	para += familyinfoid;
	para += separator+resourceid;
	para += separator+member;
	para += separator+title;
	para += separator+company;
	para += separator+jobtitle;
	para += separator+address;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmFamilyInfo_Update",para);
	RecordSet.next();

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(familyinfoid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmFamilyInfo_Update,"+para);
	SysMaintenanceLog.setOperateItem("70");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("HrmResourceFamilyInfo.jsp?resourceid="+resourceid);
 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int familyinfoid = Util.getIntValue(request.getParameter("familyinfoid"));

	String para = ""+familyinfoid;
	String resourceid = Util.null2String(request.getParameter("resourceid"));

	RecordSet.executeProc("HrmFamilyInfo_Delete",para);
	RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(familyinfoid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmFamilyInfo_Delete,"+para);
      SysMaintenanceLog.setOperateItem("70");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	response.sendRedirect("HrmResourceFamilyInfo.jsp?resourceid="+resourceid);
 }
%>
