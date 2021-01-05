<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String dialog = Util.null2String(request.getParameter("dialog"));
char separator = Util.getSeparator() ;

if(operation.equals("querytypeadd")){
  	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typenamemark = Util.fromScreen3(request.getParameter("typenamemark"),user.getLanguage());
	String showorder = "" + Util.getDoubleValue(request.getParameter("showorder"),0);

	String para = typename + separator + typenamemark + separator + showorder ;


	RecordSet.executeProc("Workflow_QueryType_Insert",para);
	if("1".equals(dialog)){
		response.sendRedirect("CustomQueryTypeAdd.jsp?isclose=1");
	}else{
		response.sendRedirect("CustomQueryTypeTab.jsp");
	}	
 }
else if(operation.equals("querytypeedit")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typenamemark = Util.fromScreen3(request.getParameter("typenamemark"),user.getLanguage());
	String showorder = "" + Util.getDoubleValue(request.getParameter("showorder"),0);

	String para = ""+id + separator + typename + separator + typenamemark + separator + showorder ; 

	RecordSet.executeProc("Workflow_QueryType_Update",para);
	if("1".equals(dialog)){
		response.sendRedirect("CustomQueryTypeEdit.jsp?isclose=1&id="+id);
	}else{
		response.sendRedirect("CustomQueryTypeTab.jsp");
	}	
 }
 else if(operation.equals("querytypedelete")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;

    RecordSet.executeProc("Workflow_QueryType_Delete",para);

    if(RecordSet.next() && RecordSet.getString(1).equals("0") ) {
		response.sendRedirect("CustomQueryTypeEdit.jsp?id="+id+"&msgid=20");
	}
	else {
		response.sendRedirect("CustomQueryTypeTab.jsp");
    }
 } else if(operation.equals("querytypedeletes")){
  	String typeids = Util.null2String(request.getParameter("typeids"));
  	String sql = "delete from workflow_customQuerytype where id in("+typeids.substring(0,typeids.length()-1)+")";
 	RecordSet.executeSql(sql);
 	response.sendRedirect("CustomQueryTypeTab.jsp");
 }
%>