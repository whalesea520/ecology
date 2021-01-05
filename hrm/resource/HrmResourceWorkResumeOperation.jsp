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
	String company = Util.fromScreen(request.getParameter("company"),user.getLanguage());
	String companystyle = Util.null2String(request.getParameter("companystyle"));
	String jobtitle = Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
	String workdesc = Util.fromScreen(request.getParameter("workdesc"),user.getLanguage());
	String leavereason = Util.fromScreen(request.getParameter("leavereason"),user.getLanguage());

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
	para += separator+company;
	para += separator+companystyle;
	para += separator+jobtitle;
	para += separator+workdesc;
	para += separator+leavereason;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+createtime;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmWorkResume_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("68");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("HrmWorkResume_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

if (!(applyid.equals(""))){
	response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
	}
else{
	response.sendRedirect("HrmResourceWorkResume.jsp?resourceid="+resourceid);
}
 } //end 
  else if(operation.equals("edit")){
	String workresumeid = Util.null2String(request.getParameter("workresumeid"));

	String para = "";

	para += workresumeid;
	para += separator+resourceid;
	para += separator+startdate;
	para += separator+enddate;
	para += separator+company;
	para += separator+companystyle;
	para += separator+jobtitle;
	para += separator+workdesc;
	para += separator+leavereason;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmWorkResume_Update",para);
	RecordSet.next();

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(workresumeid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmWorkResume_Update,"+para);
	SysMaintenanceLog.setOperateItem("68");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	if (!(applyid.equals(""))){
		response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
	}
	else{
		response.sendRedirect("HrmResourceWorkResume.jsp?resourceid="+resourceid);
	}
 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int workresumeid = Util.getIntValue(request.getParameter("workresumeid"));

	String para = ""+workresumeid;

	RecordSet.executeProc("HrmWorkResume_Delete",para);
	RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(workresumeid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmWorkResume_Delete,"+para);
      SysMaintenanceLog.setOperateItem("68");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	if (!(applyid.equals(""))){
		response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
		}
	else{
		response.sendRedirect("HrmResourceWorkResume.jsp?resourceid="+resourceid);
	}
}
%>
