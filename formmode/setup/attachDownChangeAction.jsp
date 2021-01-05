
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.dao.BaseDao"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/formmode/pub_init.jsp"%>
<%
response.reset();
out.clear();
String action = Util.null2String(request.getParameter("action"));
RecordSet rs = new RecordSet();
if(action.equalsIgnoreCase("saveForm")){
	try{
		int customid = Util.getIntValue(request.getParameter("customid"));
		int fieldid = Util.getIntValue(request.getParameter("fieldid"));
		String data = Util.null2String(request.getParameter("data"));
		rs.executeSql("delete from customfieldshowchange where customid="+customid+" and fieldid="+fieldid);
		data = URLDecoder.decode(data, "UTF-8");
		JSONArray dataArr = JSONArray.fromObject(data);
		for(int i = 0; i < dataArr.size(); i++){
			JSONObject jsonObject = (JSONObject)dataArr.get(i);
			int singlevalue = Util.getIntValue(Util.null2String(jsonObject.get("singlevalue")), 0);
			int morevalue = Util.getIntValue(Util.null2String(jsonObject.get("morevalue")), 0);
			rs.executeSql("insert into customfieldshowchange(customid,fieldid,singlevalue,morevalue)"+ " values("+customid+","+fieldid+","+singlevalue+","+morevalue+")");
		}
		out.print("1");
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("0");		
	}
}else if(action.equalsIgnoreCase("clearForm")){
	try{
		int customid = Util.getIntValue(request.getParameter("customid"));
		int fieldid = Util.getIntValue(request.getParameter("fieldid"));
		rs.executeSql("delete from customfieldshowchange where customid="+customid+" and fieldid="+fieldid);
		out.print("1");
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("0");		
	}
}
out.flush();
out.close();
%>