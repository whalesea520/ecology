<%@page import="weaver.file.ExcelFile"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.interfaces.thread.FnaThreadResult"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
boolean isDone = true;
String infoStr = "";
String resultJson = "";
User user = HrmUserVarify.getUser(request, response);
if(user == null){
	isDone = true;
}else{
	//唯一标识
	String guid = Util.null2String(request.getParameter("guid")).trim();
	FnaThreadResult fnaThreadResult = new FnaThreadResult();
	//是否操作完成标识
	isDone = "true".equalsIgnoreCase((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_isDone"));
	//进度信息字符串
	infoStr = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_infoStr")).trim();
	//操作完成后返回数据json字符串
	resultJson = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_resultJson")).trim();
	if(isDone){
		//针对导入excel对象特殊处理，如果存在_excelFile对象，则获取对象后放入seesion中。
		ExcelFile excelFile = (ExcelFile)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_excelFile");
		if(excelFile!=null){
			session.setAttribute("FnaLoadingAjax_"+guid+"_excelFile", excelFile);
		}
		
		//如果操作完成，则在所有事项完成后，按guid移除线程信息
		fnaThreadResult.removeInfoByGuid(guid);
	}
}
//保证：操作完成后返回数据json字符串，不为空；
//实际返回json对象可能各不相同，但是，必然都包含以下两个参数，所以，默认初始化这两个参数，避免前端解析出错；
if("".equals(resultJson)){
	resultJson = "{\"flag\":false,\"msg\":\"\"}";
}
%><%="{\"flag\":"+isDone+",\"infoStr\":"+JSONObject.quote(infoStr)+",\"resultJson\":"+resultJson+"}" %>