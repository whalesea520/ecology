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
	String language = Util.fromScreen(request.getParameter("language"),user.getLanguage());
	String level = Util.null2String(request.getParameter("level"));
	String memo = Util.fromScreen(request.getParameter("memo"),user.getLanguage());
	
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
	para += separator+language;
	para += separator+level;
	para += separator+memo;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+createtime;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmLanguageAbility_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("71");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("HrmLanguageAbility_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

if (!(applyid.equals(""))){
	response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
	}
else{
	response.sendRedirect("HrmResourceLanguageAbility.jsp?resourceid="+resourceid);
}
 } //end 
  else if(operation.equals("edit")){
	String languageabilityid = Util.null2String(request.getParameter("languageabilityid"));

	String para = "";

	para += languageabilityid;
	para += separator+resourceid;
	para += separator+language;
	para += separator+level;
	para += separator+memo;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+lastmodtime;
	
	RecordSet.executeProc("HrmLanguageAbility_Update",para);
	RecordSet.next();

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(languageabilityid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmLanguageAbility_Update,"+para);
	SysMaintenanceLog.setOperateItem("71");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();


if (!(applyid.equals(""))){
	response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
}
else{
	response.sendRedirect("HrmResourceLanguageAbility.jsp?resourceid="+resourceid);
}
 }///end if 
}//end if 
 else if(operation.equals("delete")){
  	int languageabilityid = Util.getIntValue(request.getParameter("languageabilityid"));

	String para = ""+languageabilityid;

	RecordSet.executeProc("HrmLanguageAbility_Delete",para);
	RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(languageabilityid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmLanguageAbility_Delete,"+para);
      SysMaintenanceLog.setOperateItem("71");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	if (!(applyid.equals(""))){
		response.sendRedirect("../career/HrmCareerApplyAdd2.jsp?applyid="+applyid);
		}
	else{
		response.sendRedirect("HrmResourceLanguageAbility.jsp?resourceid="+resourceid);
	}  
 }
%>