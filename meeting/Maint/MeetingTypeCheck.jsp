
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><%
User user = HrmUserVarify.getUser(request, response);
String checkType = Util.null2String(request.getParameter("checkType"));
//删除校验：被使用过的会议室不能删除
if("delete".equals(checkType)){
	
	String ids = Util.null2String(request.getParameter("ids"));
	RecordSet.executeSql("select distinct r.name from Meeting m, Meeting_Type r where r.id = m.meetingtype and m.meetingtype in (" + ids.substring(0, ids.length() - 1)+")");
	String names = "";
	if(RecordSet.next()){
		names += RecordSet.getString("name")+",";
		while(RecordSet.next()){
			names += RecordSet.getString("name")+",";
		}
		JSONObject jsn = new JSONObject();
		jsn.put("id", "1");
		jsn.put("msg", SystemEnv.getHtmlLabelName(2104,user.getLanguage()) +":["+names.substring(0,names.length() - 1)+SystemEnv.getHtmlLabelName(81869,user.getLanguage()) +"，"+SystemEnv.getHtmlLabelName(83850,user.getLanguage()) +"！");
		out.print(jsn.toString());
		//out.print("{\'id\':\'1\',msg:\'会议室:["+names.substring(0,names.length() - 1)+"已经被使用过，无法删除！\'}");
	} else {
		JSONObject jsn = new JSONObject();
		jsn.put("id", "0");
		jsn.put("msg", "0");
		out.print(jsn.toString());
		//out.print("\'id\':\'0\',msg:\'0\'");
	}
} else {
	String roomtypename = request.getParameter("tname");
	if(roomtypename!=null&&!"".equals(roomtypename)){
		roomtypename = Util.null2String(java.net.URLDecoder.decode(roomtypename,"UTF-8"));  //获得操作页面MeetingType_left.jsp传过来的参数 name
		String id = Util.null2String(request.getParameter("id"));
		
		if (id != null && !"".equals(id))
				RecordSet.executeSql("select * from meeting_type where name='"+roomtypename+"' and id != " + id); //修改状态时有id传入进行过滤
		else
			  RecordSet.executeSql("select * from meeting_type where name='"+roomtypename+"'");
			  	  
		if (RecordSet.next()){
				out.print("exist--");
		} else {
		    out.print("unfind--");
		}
	}
	 
}
%>