<%@ page language="java" pageEncoding="utf-8"%>

<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.Map,java.util.HashMap,java.util.List,java.util.ArrayList" %>


<%
    String delimageids = Util.null2String(request.getParameter("delimageids"));
	JSONObject obj = new JSONObject();
	String allfileids="";
	int imagefileid=0;
	RecordSet rs = new RecordSet();
	String uploadfile_uid = Util.null2String(request.getParameter("uploadfile_uid"));
	String sql = "select imagefileid from DocImageFile where id in (select id from DocImageFile where  imagefileid in ("+delimageids+") and isextfile=1)";
	rs.execute(sql);
	while(rs.next()){
		imagefileid=Util.getIntValue(rs.getString("imagefileid"),-1);
		if(imagefileid<=0){
			continue;
		}
		allfileids+=","+imagefileid;
	}
	if(allfileids.startsWith(",")){
		allfileids=allfileids.substring(1);
	}
	obj.put("delimageids",allfileids);
	out.println(obj.toString());
	
%>

