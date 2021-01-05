<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String provincename = Util.fromScreen(request.getParameter("provincename"),user.getLanguage());
String provincedesc = Util.fromScreen(request.getParameter("provincedesc"),user.getLanguage());
String countryid = Util.fromScreen(request.getParameter("countryid"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = provincename + separator + provincedesc + separator + countryid ;
	RecordSet.executeProc("HrmProvince_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(provincename);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmProvince_Insert,"+para);
      SysMaintenanceLog.setOperateItem("74");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	ProvinceComInfo.removeProvinceCache();
 	response.sendRedirect("HrmProvinceAdd.jsp?isclose=1");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmProvinceEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + provincename + separator + provincedesc + separator +countryid ;
	RecordSet.executeProc("HrmProvince_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(provincename);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmProvince_Update,"+para);
      SysMaintenanceLog.setOperateItem("74");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		ProvinceComInfo.removeProvinceCache();
 	response.sendRedirect("HrmProvinceEdit.jsp?isclose=1");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmProvinceEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeProc("HrmProvince_Delete",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(ProvinceComInfo.getProvincename(String.valueOf(id)));
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmProvince_Delete,"+para);
      SysMaintenanceLog.setOperateItem("74");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	ProvinceComInfo.removeProvinceCache();
 	response.sendRedirect("HrmProvince.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">