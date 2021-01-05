<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

String resourceid = Util.null2String(request.getParameter("resourceid"));
String applyid = Util.null2String(request.getParameter("applyid"));	
/*judge whether an applyid or a resourceid*/
 if (resourceid.equals("")){
	 resourceid = applyid;
 }

if(operation.equals("add")||operation.equals("edit")){ 
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String school = Util.fromScreen(request.getParameter("school"),user.getLanguage());
	String speciality = Util.fromScreen(request.getParameter("speciality"),user.getLanguage());
	String educationlevel = Util.null2String(request.getParameter("educationlevel"));
	String studydesc = Util.fromScreen(request.getParameter("studydesc"),user.getLanguage());

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
	para += separator+startdate;
	para += separator+enddate;
	para += separator+school;
	para += separator+speciality;
	para += separator+educationlevel;
	para += separator+studydesc;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+createtime;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmEducationInfo_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("69");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("HrmEducationInfo_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();
	out.print(applyid);
if (!(applyid.equals(""))){
	response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
	}
else{
	response.sendRedirect("HrmResourceEducationInfo.jsp?resourceid="+resourceid);
}

 } //end 
  else if(operation.equals("edit")){
	String educationinfoid = Util.null2String(request.getParameter("educationinfoid"));

	String para = "";

	para += educationinfoid;
	para += separator+resourceid;
	para += separator+startdate;
	para += separator+enddate;
	para += separator+school;
	para += separator+speciality;
	para += separator+educationlevel;
	para += separator+studydesc;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmEducationInfo_Update",para);
	RecordSet.next();

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(educationinfoid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmEducationInfo_Update,"+para);
	SysMaintenanceLog.setOperateItem("69");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

if (!(applyid.equals(""))){
	response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
}
else{
	response.sendRedirect("HrmResourceEducationInfo.jsp?resourceid="+resourceid);
}

 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int educationinfoid = Util.getIntValue(request.getParameter("educationinfoid"));

	String para = ""+educationinfoid;

	RecordSet.executeProc("HrmEducationInfo_Delete",para);
	RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(educationinfoid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmEducationInfo_Delete,"+para);
      SysMaintenanceLog.setOperateItem("69");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	if (!(applyid.equals(""))){
		response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
		}
	else{
		response.sendRedirect("HrmResourceEducationInfo.jsp?resourceid="+resourceid);
	}  
 }
%>
