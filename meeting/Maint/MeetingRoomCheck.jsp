
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
 <%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><%
User user = HrmUserVarify.getUser(request, response);
String checkType = Util.null2String(request.getParameter("checkType"));
String ids = Util.null2String(request.getParameter("ids"));
//删除校验：被使用过的会议室不能删除
if("delete".equals(checkType)){
	JSONObject jsn = new JSONObject();
	jsn.put("id", "0");
	jsn.put("msg", "0");
	String[] idsArr = ids.split(",");
	String conflictIds = "";
	for(int i=0;i<idsArr.length;i++){
		if(!(idsArr[i].trim()).equals("")){
			if(RecordSet.getDBType().equals("oracle")){
			RecordSet.executeSql("select count(0) count from meeting where ','||address||','  like  '%,"+idsArr[i]+",%'");
			}else if("mysql".equalsIgnoreCase(RecordSet.getDBType())){
				RecordSet.executeSql("select count(0) count from meeting where concat(',' , address , ',') like  '%,"+idsArr[i]+",%'");
			}else{
				RecordSet.executeSql("select count(0) count from meeting where ','+address+','  like  '%,"+idsArr[i]+",%'");
			}
			RecordSet.next();
			if(RecordSet.getInt("count") > 0){
				conflictIds += idsArr[i]+",";
			}
		}
	}
	if(!conflictIds.equals("")){
		RecordSet.executeSql("select name from MeetingRoom where id in (" + conflictIds.substring(0, conflictIds.length() - 1)+")");
		String names = "";
		while(RecordSet.next()){
			names += RecordSet.getString("name")+",";
			//out.print("{\'id\':\'1\',msg:\'会议室:["+names.substring(0,names.length() - 1)+"已经被使用过，无法删除！\'}");
		} 
		if(!names.equals("")){
			jsn.put("id", "1");
			jsn.put("msg", SystemEnv.getHtmlLabelName(780,user.getLanguage()) +":["+names.substring(0,names.length() - 1)+"]"+ SystemEnv.getHtmlLabelName(81869,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(83850,user.getLanguage())+"！");
		}
	}
		out.print(jsn.toString());
		//out.print("\'id\':\'0\',msg:\'0\'");
} else {
		String roomname = request.getParameter("roomname");
		if(roomname!=null&&!"".equals(roomname)){
			roomname = Util.null2String(java.net.URLDecoder.decode(roomname,"UTF-8"));  //获得操作页面MeetingRoom_left.jsp传过来的参数 name		
			String id = Util.null2String(request.getParameter("id"));
			if (id != null && !"".equals(id))
					RecordSet.executeSql("select * from MeetingRoom where name='"+roomname+"' and id != " + id);  //修改状态时有id传入进行过滤
			else
				  RecordSet.executeSql("select * from MeetingRoom where name='"+roomname+"'");
			
			if (RecordSet.next()){
					out.print("exist--");
			} else {
			    out.print("unfind--");
			}
		}
}
%>