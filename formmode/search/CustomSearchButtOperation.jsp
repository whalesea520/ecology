<%@page import="weaver.formmode.service.CustomSearchButtService"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String id = Util.null2String(request.getParameter("id"));
String operation = Util.null2String(request.getParameter("operation"));
CustomSearchButtService customSearchButtService = new CustomSearchButtService();
Map<String,	Object> dataMap = new HashMap<String,Object>();
dataMap.put("id", id);
int objid = Util.getIntValue(request.getParameter("objid"),0);
dataMap.put("objid", objid);
dataMap.put("buttonname", Util.null2String(request.getParameter("buttonname")));
dataMap.put("hreftype", Util.getIntValue(request.getParameter("hreftype"),1));
dataMap.put("hreftargetOpenWay", Util.getIntValue(request.getParameter("hreftargetOpenWay"),1));
dataMap.put("hreftargetParid", Util.null2String(request.getParameter("hreftargetParid")));
dataMap.put("hreftargetParval", Util.null2String(request.getParameter("hreftargetParval")));
dataMap.put("hreftarget", Util.null2String(request.getParameter("hreftarget")));
dataMap.put("jsmethodname", Util.null2String(request.getParameter("jsmethodname")));
dataMap.put("jsParameter", Util.null2String(request.getParameter("jsParameter")));
dataMap.put("jsmethodbody", Util.null2String(request.getParameter("jsmethodbody")));
dataMap.put("interfacePath", Util.null2String(request.getParameter("interfacePath")));
dataMap.put("isshow", Util.getIntValue(request.getParameter("isshow"),0));
dataMap.put("describe", Util.null2String(request.getParameter("describe")));
dataMap.put("showorder", Util.getDoubleValue(request.getParameter("showorder"),0));
if("create".equals(operation)){
	id = customSearchButtService.saveOrUpdateCustomButton(dataMap);
	String url = "/formmode/search/CustomSearchButtonAdd.jsp?objid="+objid+"&id="+id;
	out.print("<script>window.location.href='"+url+"';</script>");
}else if("delete".equals(operation)){
	customSearchButtService.deleteCustomButton(id);
	response.sendRedirect("/formmode/search/CustomSearchButton.jsp?id="+objid);
}else if("checkMethodName".equals(operation)){
	String methodName = Util.null2String(request.getParameter("methodName"));
	String sql = "select * from mode_customSearchButton where objid="+objid+" and jsmethodname like '%"+methodName+"%'";
	if(!StringHelper.isEmpty(id)){
		sql+=" and id!="+id;
	}
	rs.executeSql(sql);
	if(rs.getCounts()>0){
		out.print("true");
	}
}
%>
