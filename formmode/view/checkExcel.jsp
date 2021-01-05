
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.formmode.excel.ExpExcelUtil"%>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
out.clear();
User user = HrmUserVarify.getUser (request , response) ;
String optype = Util.null2String(request.getParameter("optype"));
JSONObject result = new JSONObject();
if("exp".equals(optype)){
	String msg = ExpExcelUtil.checkCanExpExcel(user);
	result.put("msg",msg);
	response.getWriter().write(result.toString());
	return;
}else if("imp".equals(optype)){
	String msg = ExpExcelUtil.checkCanImpExcel(user);
	result.put("msg",msg);
	response.getWriter().write(result.toString());
	return;
}
%>
