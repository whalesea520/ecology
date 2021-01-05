<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

int ccmaincategoryid = Util.getIntValue(request.getParameter("ccmaincategoryid"));
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String ccsubcategoryname = Util.fromScreen(request.getParameter("ccsubcategoryname"),user.getLanguage());
String ccsubcategorydesc = Util.fromScreen(request.getParameter("ccsubcategorydesc"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = ccsubcategoryname + separator + ccsubcategorydesc + separator + ccmaincategoryid;
	RecordSet.executeProc("HrmCostcenterSubCategory_I",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(ccsubcategoryname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmCostcenterSubCategory_I,"+para);
      SysMaintenanceLog.setOperateItem("19");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CostcenterSubComInfo.removeCompanyCache();
 	response.sendRedirect("HrmCostcenterSubCategory.jsp");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + ccsubcategoryname + separator + ccsubcategorydesc + separator + ccmaincategoryid;
	RecordSet.executeProc("HrmCostcenterSubCategory_U",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(ccsubcategoryname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCostcenterSubCategory_U,"+para);
      SysMaintenanceLog.setOperateItem("19");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		CostcenterSubComInfo.removeCompanyCache();
 	response.sendRedirect("HrmCostcenterMainCategoryEdit.jsp?id="+ccmaincategoryid);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	String sql = "select count(id) from HrmCostcenter where ccsubcategory1 = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmCostcenterSubCategoryEdit.jsp?id="+id+"&msgid=20");
	}else{		
	RecordSet.executeProc("HrmCostcenterSubCategory_D",para);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(ccsubcategoryname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCostcenterSubCategory_D,"+para);
      SysMaintenanceLog.setOperateItem("19");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CostcenterSubComInfo.removeCompanyCache();
 	response.sendRedirect("HrmCostcenterSubCategory.jsp?");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">