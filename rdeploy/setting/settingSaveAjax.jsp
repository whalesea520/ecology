<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.hrm.User,weaver.hrm.HrmUserVarify,weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet" %>
<%@page import="org.json.JSONObject" %>

<%
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)
	    return;
	JSONObject obj = new JSONObject();
	String opType = request.getParameter("opType");
	RecordSet rs = new RecordSet();
    boolean b = false;
	
	if("mainSave".equals(opType)){
	    String id = Util.null2String(request.getParameter("id")); 
	    String isOpen = Util.null2String(request.getParameter("isOpen"));
	    String synctime = Util.null2String(request.getParameter("synctime"));
	    if(!isOpen.isEmpty()){
	        b = rs.executeSql("update RdeploySyncSettingMain set isOpen='" + isOpen + "' where id='" + id + "'");
	    }else if(!synctime.isEmpty()){
	        b = rs.executeSql("update RdeploySyncSettingMain set synctime='" + synctime + "' where id='" + id + "'");
	    }
	}else if("pathSave".equals(opType)){
	    String id = Util.null2String(request.getParameter("id"));
	    String categoryid = request.getParameter("categoryid");
	    String localPath = request.getParameter("localPath");
	    String computerName = Util.null2String(request.getParameter("hostname"));
		System.out.println(computerName);
	    String guid = Util.null2String(request.getParameter("guid"));
	    if(!id.isEmpty()){
	        b = rs.executeSql("update RdeploySyncSetting set " +
	                "computerName='" + computerName +
	                "',localPath='" + localPath +
	                "',categoryid='" + categoryid + 
	                "' where id='" + id + "'");
	    }else{
		    String mid = request.getParameter("mid");
		    b = rs.executeSql("insert into RdeploySyncSetting(mid,computerName,localPath,categoryid,isUse,guid,loginid) " +
		            " values('" + mid + "','" + computerName + "','" + localPath + "','" + categoryid + "',1,'" + guid + "','" + user.getLoginid() + "')");
	    }
	}else if("delete".equals(opType)){
	    String ids = request.getParameter("ids");
	    b = rs.executeSql("delete RdeploySyncSetting where " + (ids.indexOf(",") == -1 ? ("id='" + ids + "'") : ("id in(" + ids + ")")));
	}else if("use".equals(opType)){
	    String id = request.getParameter("id");
	    String isuse = request.getParameter("isuse");
	    b = rs.executeSql("update RdeploySyncSetting set isuse='" + isuse + "' where id='" + id + "'");
	}
	
	
    if(b){
    	obj.put("flag","1");
    }else{
    	obj.put("flag","0");
    }
    out.println(obj.toString());
%>
