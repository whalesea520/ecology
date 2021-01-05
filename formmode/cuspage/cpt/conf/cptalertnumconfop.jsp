<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
if(!HrmUserVarify.checkUserRight("Cpt4Mode:AlarmSettings", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
JSONObject obj=new JSONObject();
String method = Util.null2String (request.getParameter("method"));

if("dosave".equalsIgnoreCase(method)){
	String alarm_lownum=Util.null2String (request.getParameter("alarm_lownum"));
	JSONArray arr1= JSONArray.fromObject(alarm_lownum);
	if(arr1!=null&&arr1.size()>0){
		for(int i=0;i<arr1.size();i++){
			JSONObject jsonObject=(JSONObject)arr1.get(i);
			String sql="update uf_cptcapital set alarm_lownum="+Util.getDoubleValue(jsonObject.getString("alertnum"),0.0 )+" where id="+Util.getIntValue( jsonObject.getString("cptid"),0);
			rs.executeSql(sql);
		}
	}

	String alarm_highnum=Util.null2String (request.getParameter("alarm_highnum"));
	JSONArray arr2= JSONArray.fromObject(alarm_highnum);
	if(arr2!=null&&arr2.size()>0){
		for(int i=0;i<arr2.size();i++){
			JSONObject jsonObject=(JSONObject)arr2.get(i);
			String sql="update uf_cptcapital set alarm_highnum="+Util.getDoubleValue(jsonObject.getString("alertnum"),0.0 )+" where id="+Util.getIntValue( jsonObject.getString("cptid"),0);
			rs.executeSql(sql);
		}
	}

	String alarm_dulldays=Util.null2String (request.getParameter("alarm_dulldays"));
	JSONArray arr3= JSONArray.fromObject(alarm_dulldays);
	if(arr3!=null&&arr3.size()>0){
		for(int i=0;i<arr3.size();i++){
			JSONObject jsonObject=(JSONObject)arr3.get(i);
			String sql="update uf_cptcapital set alarm_dulldays="+Util.getDoubleValue(jsonObject.getString("alertnum"),0.0 )+" where id="+Util.getIntValue( jsonObject.getString("cptid"),0);
			rs.executeSql(sql);
		}
	}

}else if("alertnumbatchset".equalsIgnoreCase(method)){
	double alarm_lownum=Util.getDoubleValue(request.getParameter("alarm_lownum"),0.0);
	double alarm_highnum=Util.getDoubleValue(request.getParameter("alarm_highnum"),0.0);
	double alarm_dulldays=Util.getDoubleValue(request.getParameter("alarm_dulldays"),0.0);
	String ids=Util.null2String (request.getParameter("ids"));
	if(!"".equals( ids)){
		if(ids.startsWith(",")){
			ids=ids.substring(1);
		}
		if(ids.endsWith(",")){
			ids=ids.substring(0,ids.length()-1);
		}
		String sql="update uf_cptcapital set alarm_lownum="+alarm_lownum+",alarm_highnum="+alarm_highnum+",alarm_dulldays="+alarm_dulldays+" where id in ("+ids+") ";
		rs.executeSql(sql);
	}
}


out.println(obj.toString());
%>