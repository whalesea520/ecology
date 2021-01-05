<%@ page import="weaver.general.Util,java.io.*,weaver.file.ExcelFile" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.ConfigOperation" %>
<%@ page import="java.io.File,weaver.conn.RecordSet" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
ConfigOperation configOperation  =  new ConfigOperation();
String method = Util.null2String(request.getParameter("method"));


if(method.equals("save")){
	String mainId = Util.null2String(request.getParameter("mainId"));
	if(!mainId.equals("")){
		if(request.getParameterValues("id") != null){
			String requisiteArray = request.getParameter("requisiteArray");
			String[] ids = request.getParameterValues("id");
			String[] attrvalues = request.getParameterValues("attrvalue");
			String[] attrnotes = request.getParameterValues("attrnotes");
			String[] xpaths =  request.getParameterValues("xpath");
			String[] requisites =requisiteArray.split(",");
			configOperation.saveXml(mainId,ids,attrvalues,xpaths,attrnotes,requisites);
		}else{
			configOperation.deleteXmlDetail(mainId);
		}
	}
	response.sendRedirect("ConfigXml.jsp?id=" + mainId+"&successful=1");
}



if("checkxmlvalue".equals(method)) {
	String checkvalue = Util.null2String(request.getParameter("checkvalue"));
		boolean pass = configOperation.checkXmlValue(checkvalue);
		if(pass) {
			out.print("{\"status\":\"ok\"}");
		} else {
			out.print("{\"status\":\"no\"}");
		}
}
%>