<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addcomponent")){

	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String componentid = Util.null2String(request.getParameter("componentid"));
	String componentmark = Util.fromScreen(request.getParameter("componentmark"),user.getLanguage());
	String selbank = Util.null2String(request.getParameter("selbank"));
	String salarysum = Util.null2String(request.getParameter("salarysum"));
	String canedit = Util.null2String(request.getParameter("canedit"));
	String currencyid = Util.null2String(request.getParameter("currencyid"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());
	
	String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

	if(!HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add",user,departmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String createid = ""+user.getUID();
	Calendar today = Calendar.getInstance();
	String createdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String para = resourceid + separator + componentid + separator + componentmark + separator + selbank + separator + salarysum + separator + canedit + separator + currencyid + separator + startdate + separator + enddate + separator + remark + separator + createid + separator + createdate;
	
	RecordSet.executeProc("HrmResourceComponent_Insert",para);
	response.sendRedirect("HrmResourceComponent.jsp?resourceid="+resourceid);
 }
else if(operation.equals("editcomponent")){

	String id = Util.null2String(request.getParameter("id"));
  	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String componentid = Util.null2String(request.getParameter("componentid"));
	String componentmark = Util.fromScreen(request.getParameter("componentmark"),user.getLanguage());
	String selbank = Util.null2String(request.getParameter("selbank"));
	String salarysum = Util.null2String(request.getParameter("salarysum"));
	String canedit = Util.null2String(request.getParameter("canedit"));
	String currencyid = Util.null2String(request.getParameter("currencyid"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());
	
	String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

	if(!HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Edit",user,departmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String lastmoderid = ""+user.getUID();
	Calendar today = Calendar.getInstance();
	String lastmoddate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String para = id + separator + resourceid + separator + componentid + separator + componentmark + separator + selbank + separator + salarysum + separator + canedit + separator + currencyid + separator + startdate + separator + enddate + separator + remark + separator + lastmoderid + separator + lastmoddate;
	
	RecordSet.executeProc("HrmResourceComponent_Update",para);
	response.sendRedirect("HrmResourceComponent.jsp?resourceid="+resourceid);  

 }
 else if(operation.equals("deletecomponent")){ 
  	int id = Util.getIntValue(request.getParameter("id"));
	String componenttype = Util.null2String(request.getParameter("oldcomponenttype"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

	if(!HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Delete",user,departmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String para = ""+id;
	RecordSet.executeProc("HrmResourceComponent_Delete",para);
	
 	response.sendRedirect("HrmResourceComponent.jsp?resourceid="+resourceid);
 }

%>
