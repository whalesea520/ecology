<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String inprepid = Util.null2String(request.getParameter("inprepid"));
String itemtypeid = Util.null2String(request.getParameter("itemtypeid"));
//String dsporder = Util.null2String(request.getParameter("dsporder"));
double dsporder = Util.getDoubleValue(request.getParameter("dsporder"),0);
String itemtypename = Util.fromScreen(request.getParameter("itemtypename"),user.getLanguage());
String itemtypedesc = Util.fromScreen(request.getParameter("itemtypedesc"),user.getLanguage());
if(operation.equals("add")){
	
    char separator = Util.getSeparator() ;

	String para = inprepid + separator + itemtypename
		+ separator + itemtypedesc + separator + dsporder ;
	RecordSet.executeProc("T_InputReportItemtype_Insert",para);
	
 	response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
 }
 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;

    String para = ""+itemtypeid + separator + itemtypename + separator + itemtypedesc + separator + dsporder ;
	RecordSet.executeProc("T_InputReportItemtype_Update",para);
	
 	response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
 }
else if(operation.equals("delete")){

	RecordSet.executeSql("select 1 from T_InputReportItem  where inprepId="+inprepid+" and itemTypeId= "+itemtypeid);
    if(RecordSet.next()){
 	    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid+"&hasReportItem=1");
	}else{
		char separator = Util.getSeparator() ;
	    String para = "" + itemtypeid;
	    RecordSet.executeProc("T_InputReportItemtype_Delete",para);
 	    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
	}


 }
%>
