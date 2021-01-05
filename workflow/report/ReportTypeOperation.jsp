<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String dialog = Util.null2String(request.getParameter("dialog"));
if(operation.equals("reporttypeadd")){

  	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typeorder = "" + Util.getIntValue(request.getParameter("typeorder"),0);  
	String isfrom = Util.null2String(request.getParameter("isfrom"));
	String para = typename + separator + typedesc + separator + typeorder ; 
		
	RecordSet.executeProc("Workflow_ReportType_Insert",para);

    ReportTypeComInfo.removeReportTypeCache() ;

	if("1".equals(dialog) && !"1".equals(isfrom)){
		response.sendRedirect("ReportTypeAdd.jsp?isclose=1");
	}else if("1".equals(dialog) && "1".equals(isfrom)){
		response.sendRedirect("ReportTypeAdd.jsp?isclose=1&isfrom=2&typename="+typename);
	}else{
		response.sendRedirect("ReportTypeManageTab.jsp");
	}
	
 }
else if(operation.equals("reporttypeedit")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typeorder = "" + Util.getIntValue(request.getParameter("typeorder"),0);  
	

	String para = ""+id + separator + typename + separator + typedesc + separator + typeorder ; 

	RecordSet.executeProc("Workflow_ReportType_Update",para);

    ReportTypeComInfo.removeReportTypeCache() ;
	if("1".equals(dialog)){
		response.sendRedirect("ReportTypeEdit.jsp?isclose=1&id="+id);
	}else{
		response.sendRedirect("ReportTypeManageTab.jsp");
	}
 }
 else if(operation.equals("reporttypedelete")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	
    RecordSet.executeProc("Workflow_ReportType_Delete",para);
	
    if(RecordSet.next() && RecordSet.getString(1).equals("0") ) {
		response.sendRedirect("ReportTypeEdit.jsp?id="+id+"&msgid=20"); //Modify by 杨国生 2004-10-15 For TD1208
	}
	else {
        ReportTypeComInfo.removeReportTypeCache() ;
		response.sendRedirect("ReportTypeManageTab.jsp");
    }
 } 
 else if(operation.equals("reporttypedeletes")){
  	String typeids = Util.null2String(request.getParameter("typeids"));
  	String sql = "delete from Workflow_ReportType where id in("+typeids.substring(0,typeids.length()-1)+")";
	RecordSet.executeSql(sql);
    ReportTypeComInfo.removeReportTypeCache() ;
	response.sendRedirect("ReportTypeManageTab.jsp");

 }
%>