<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ExpensefeeTypeComInfo" class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("FnaExpensefeeTypeAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String operation = Util.null2String(request.getParameter("operation"));
char flag = Util.getSeparator() ;

if(operation.equals("add")){
  	String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
	String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());
	String para = name+flag+remark;
	RecordSet.executeProc("FnaExpensefeeType_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("FnaExpensefeeType_Insert,"+para);
	SysMaintenanceLog.setOperateItem("78");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	
	String standardfee=Util.fromScreen(request.getParameter("standardfee"),user.getLanguage());
	if(!standardfee.equals("")){
	    para=""+id+flag+"-1"+flag+standardfee;
	    RecordSet.executeProc("FnaExpensefeeRules_Insert",para);
	}
	int nodesnum=Util.getIntValue(request.getParameter("nodesnum"),0);
	for(int i=0;i<nodesnum;i++){
	    String resourceid=Util.fromScreen(request.getParameter("resourceid_"+i),user.getLanguage());
	    if(resourceid.equals(""))   continue;
	    String tmpstandardfee=Util.fromScreen(request.getParameter("rules_"+i),user.getLanguage());
	    para=""+id+flag+resourceid+flag+tmpstandardfee;
	    RecordSet.executeProc("FnaExpensefeeRules_Insert",para);
	}
 }
else if(operation.equals("edit")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
	String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());
	String para = ""+id + flag + name + flag + remark ;
	RecordSet.executeProc("FnaExpensefeeType_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaExpensefeeType_Update,"+para);
    SysMaintenanceLog.setOperateItem("78");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    
    RecordSet.executeProc("FnaExpensefeeRules_DByFeeid",""+id);
    String standardfee=Util.fromScreen(request.getParameter("standardfee"),user.getLanguage());
	if(!standardfee.equals("")){
	    para=""+id+flag+"-1"+flag+standardfee;
	    RecordSet.executeProc("FnaExpensefeeRules_Insert",para);
	}
	int nodesnum=Util.getIntValue(request.getParameter("nodesnum"),0);
	for(int i=0;i<nodesnum;i++){
	    String resourceid=Util.fromScreen(request.getParameter("resourceid_"+i),user.getLanguage());
	    if(resourceid.equals(""))   continue;
	    String tmpstandardfee=Util.fromScreen(request.getParameter("rules_"+i),user.getLanguage());
	    para=""+id+flag+resourceid+flag+tmpstandardfee;
	    RecordSet.executeProc("FnaExpensefeeRules_Insert",para);
	}
	
 }
 else if(operation.equals("delete")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
	RecordSet.executeProc("FnaExpensefeeType_Delete",""+id);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("3");
	SysMaintenanceLog.setOperateDesc("FnaExpensefeeType_Delete,"+id);
	SysMaintenanceLog.setOperateItem("78");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
 }
 ExpensefeeTypeComInfo.removeCurrencyCache();
 response.sendRedirect("FnaExpensefeeType.jsp");
%>
