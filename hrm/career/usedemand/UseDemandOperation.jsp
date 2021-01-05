<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-09 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
  	int userid = user.getUID();
  	Calendar todaycal = Calendar.getInstance ();
  	String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
  
  	String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  	String jobtitle = Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
  	int status = Util.getIntValue(request.getParameter("status"),0);
	String _status = Util.null2String(request.getParameter("_status"));
  	String demandnum = Util.fromScreen(request.getParameter("demandnum"),user.getLanguage());
  	String demandkind = Util.fromScreen(request.getParameter("demandkind"),user.getLanguage());
  	String leastedulevel = Util.fromScreen(request.getParameter("leastedulevel"),user.getLanguage());
  	String date = Util.fromScreen(request.getParameter("date"),user.getLanguage());
  	String otherrequest = Util.fromScreen(request.getParameter("otherrequest"),user.getLanguage());
  	int createkind = Util.getIntValue(request.getParameter("createkind"),1);
  	String department = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
  	String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  	String sql = "";
  	String para = "";
  	char separator = Util.getSeparator() ; 
  
  	if(operation.equals("save")){
    	para = 
    		jobtitle     + separator+ demandnum + separator+ demandkind   + separator+ 
           	leastedulevel+ separator+ date  	+ separator+ otherrequest + separator+
           	userid       + separator+ today 	+ separator+ createkind   + separator+ department;

	    rs.executeProc("HrmUseDemand_Insert",para);
		rs.executeSql("select MAX(id) from HrmUseDemand");
	    int _id = Util.getIntValue(id);
		if(rs.next()){
			_id = rs.getInt(1);
		}
	    SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(_id);
	    SysMaintenanceLog.setRelatedName(JobTitlesComInfo.getJobTitlesname(jobtitle));
	    SysMaintenanceLog.setOperateType("1");
	    SysMaintenanceLog.setOperateDesc("HrmUseDemand_Insert"+para);
	    SysMaintenanceLog.setOperateItem("69");
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();
	      
	    response.sendRedirect("HrmUseDemandAdd.jsp?isclose=1&_status="+_status);
	}else if(operation.equals("edit")){
	    para = jobtitle +separator+ status +separator+ demandnum + separator+demandkind + separator+leastedulevel+separator+date+separator+ otherrequest+separator+id+ separator+ department;    
	    rs.executeProc("HrmUseDemand_Update",para);
	    
	    SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	    SysMaintenanceLog.setRelatedName(JobTitlesComInfo.getJobTitlesname(jobtitle));
	    SysMaintenanceLog.setOperateType("2");
	    SysMaintenanceLog.setOperateDesc("HrmUseDemand_Update"+para);
	    SysMaintenanceLog.setOperateItem("69");
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();
		
	    response.sendRedirect("HrmUseDemandEdit.jsp?id="+id+"&isclose=1&_status="+_status);
  	}else if(operation.equals("delete")){
	    para = ""+id;    
	    rs.executeProc("HrmUseDemand_Delete",para);
	    response.sendRedirect("HrmUseDemand.jsp");
	    
	    SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	    SysMaintenanceLog.setRelatedName(JobTitlesComInfo.getJobTitlesname(jobtitle));
	    SysMaintenanceLog.setOperateType("3");
	    SysMaintenanceLog.setOperateDesc("HrmUseDemand_Insert"+para);
	    SysMaintenanceLog.setOperateItem("69");
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();
	}else if(operation.equals("close")){
	    para = ""+id;    
	    rs.executeProc("HrmUseDemand_Close",para);
	    response.sendRedirect("HrmUseDemandEdit.jsp?id="+id);
	}
%>