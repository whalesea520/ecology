<%@ page import="weaver.general.Util,java.io.*,weaver.file.ExcelFile"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.templetecheck.ConfigOperation"%>
<%@ page import="java.io.File,weaver.conn.RecordSet"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session" />

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%

ConfigOperation configOperation  =  new ConfigOperation();
String mainId = Util.null2String(request.getParameter("mainId"));
if(!mainId.equals("")){
	if(request.getParameterValues("id") != null){
		String requisiteArray = request.getParameter("requisiteArray");
		String[] ids = request.getParameterValues("id");
		String[] attrnames = request.getParameterValues("attrname");
		String[] attrvalues = request.getParameterValues("attrvalue");
		String[] attrnotes = request.getParameterValues("attrnotes");
		String[] requisites =requisiteArray.split(",");
		configOperation.saveProperties(mainId,ids,attrnames,attrvalues,attrnotes,requisites);
	}else{
		configOperation.deletePropDetail(mainId);
	}
}

response.sendRedirect("ConfigProperties.jsp?id=" + mainId+"&successful=1");
%>