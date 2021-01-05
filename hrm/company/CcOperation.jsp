<%@ page import="weaver.general.Util" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CostCenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String costcentermark = Util.fromScreen(request.getParameter("costcentermark"),user.getLanguage());
String costcentername = Util.fromScreen(request.getParameter("costcentername"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String ccsubcategory1 = Util.fromScreen(request.getParameter("ccsubcategory1"),user.getLanguage());

if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmCostCenterAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
        char separator = Util.getSeparator() ;  	
	String para = costcentermark + separator + costcentername + separator + 
			departmentid + separator + ccsubcategory1;         
    
	RecordSet.executeProc("HrmCostCenter_Insert",para);
	
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);	
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(costcentername);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Insert,"+para);
      SysMaintenanceLog.setOperateItem("20");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CostCenterComInfo.removeCompanyCache();
	response.sendRedirect("HrmCostCenterDsp.jsp?id="+id);
 }
 
 else if(operation.equals("edit")){
 	if(!HrmUserVarify.checkUserRight("HrmCostCenterEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	int id = Util.getIntValue(request.getParameter("id"),0);
        char separator = Util.getSeparator() ;  	
	String para = ""+id+separator+costcentermark + separator + costcentername + separator + 
			departmentid + separator + ccsubcategory1; 
	out.println(para);		
	out.println(RecordSet.executeProc("HrmCostCenter_Update",para));
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(costcentername);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCostCenter_Update,"+para);
      SysMaintenanceLog.setOperateItem("20");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CostCenterComInfo.removeCompanyCache();
	response.sendRedirect("HrmCostCenterDsp.jsp?id="+id);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmCostCenterEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	int id = Util.getIntValue(request.getParameter("id"),0);
        char separator = Util.getSeparator() ;  	
	String para = ""+id;
	
	String sql = "select count(id) from HrmResource where costcenterid = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmCostcenterEdit.jsp?id="+id+"&msgid=20");
	}else{		
	RecordSet.executeProc("HrmCostCenter_Delete",para);
	}		
		
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(costcentername);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCostCenter_Delete,"+para);
      SysMaintenanceLog.setOperateItem("20");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CostCenterComInfo.removeCompanyCache();
	response.sendRedirect("HrmCostcenter.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">