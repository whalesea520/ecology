<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addinfo")){

	
  	String infoname = Util.fromScreen(request.getParameter("infoname"),user.getLanguage());
	String inforemark = Util.fromScreen(request.getParameter("inforemark"),user.getLanguage());
	String infotype = Util.null2String(request.getParameter("infotype"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String docid = Util.null2String(request.getParameter("docid"));
	String seclevel = Util.null2String(request.getParameter("seclevel"));

	String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

	if(!HrmUserVarify.checkUserRight("HrmResourceOtherInfoAdd:Add",user,departmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String createid = ""+user.getUID();
	Calendar today = Calendar.getInstance();
	String createdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


	String para = resourceid + separator + infoname + separator + startdate + separator + enddate + separator + docid + separator + inforemark + separator + infotype + separator + seclevel + separator + createid + separator + createdate ;
	
	RecordSet.executeProc("HrmResourceOtherInfo_Insert",para);
	response.sendRedirect("HrmResourceOtherInfoView.jsp?infotype="+infotype+"&resourceid="+resourceid);
 }
else if(operation.equals("editinfo")){

	
  	String infoname = Util.fromScreen(request.getParameter("infoname"),user.getLanguage());
	String inforemark = Util.fromScreen(request.getParameter("inforemark"),user.getLanguage());
	String infotype = Util.null2String(request.getParameter("infotype"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String id = Util.null2String(request.getParameter("id"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String docid = Util.null2String(request.getParameter("docid"));
	String seclevel = Util.null2String(request.getParameter("seclevel"));

	String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

	if(!HrmUserVarify.checkUserRight("HrmResourceOtherInfoEdit:Edit",user,departmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String lastmoderid = ""+user.getUID();
	Calendar today = Calendar.getInstance();
	String lastmoddate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


	String para = id + separator + infoname + separator + startdate + separator + enddate + separator + docid + separator + inforemark + separator + infotype + separator + seclevel + separator + lastmoderid + separator + lastmoddate ;
	
	RecordSet.executeProc("HrmResourceOtherInfo_Update",para);
	response.sendRedirect("HrmResourceOtherInfoView.jsp?infotype="+infotype+"&resourceid="+resourceid);
 }
 else if(operation.equals("deleteinfo")){ 
  	int id = Util.getIntValue(request.getParameter("id"));
	String infotype = Util.null2String(request.getParameter("oldinfotype"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

	if(!HrmUserVarify.checkUserRight("HrmResourceOtherInfoEdit:Delete",user,departmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String para = ""+id;
	RecordSet.executeProc("HrmResourceOtherInfo_Delete",para);
	
 	response.sendRedirect("HrmResourceOtherInfoView.jsp?infotype="+infotype+"&resourceid="+resourceid);
 }

%>
