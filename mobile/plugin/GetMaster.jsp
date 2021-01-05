
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="weaver.file.*" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%
FileUpload fu = new FileUpload(request);
String userid = ""+Util.getIntValue(fu.getParameter("userid"),-1);
String type = Util.null2String(fu.getParameter("type"));

Map result = new HashMap();

if("master".equalsIgnoreCase(type)) {
	result.put("master",0);
	RecordSet rs = new RecordSet();
	String sql = "select belongto from HrmResource where id=" + userid;
	rs.executeSql(sql);
	//rs.executeQuery("select belongto from HrmResource where id=?", userid);
	if (rs.next()) {
		String belongto = rs.getString("belongto");
		if (NumberUtils.toInt(belongto, -1)>0) {
			result.put("master",belongto);
		}
	}
} else if("switch".equalsIgnoreCase(type)) {
	result.put("flag",0);
	RecordSet rs = new RecordSet();
	String sql = "select keyvalue from  Social_Pc_ClientSettings where keytitle ='multiAccountMsg'";
	rs.executeSql(sql);
	if (rs.next()) {
		String keyvalue = rs.getString("keyvalue");
		int flag = Util.getIntValue(rs.getString("keyvalue"), 0);
		result.put("flag",flag);
	}
} else if("change".equalsIgnoreCase(type)) {
	
}

if(result!=null) {
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo.toString());
}
%>