
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operation = Util.null2String(request.getParameter("operation"));
String sql = "";
if(operation.equals("saveremark")){//保存树描述
	String optype = Util.null2String(request.getParameter("optype"));
	String inputtext = Util.fromScreen(Util.null2String(request.getParameter("inputtext")),user.getLanguage());
	String mainid = Util.null2String(request.getParameter("mainid"));
	String rowid = Util.null2String(request.getParameter("rowid"));
	String _id = "";
	boolean result = false;
	if("add".equals(optype)){
		sql="insert into CustomTreeRemark(mainid,remark,orders) values ('"+mainid+"','"+inputtext+"','"+rowid+"')";
		rs.executeSql(sql);
		sql = "select max(id) as id from CustomTreeRemark";
		rs.executeSql(sql);
		if(rs.next()){
			_id = rs.getString("id");
			result = true;
		}
	}else if("edit".equals(optype)){
		_id = Util.null2String(request.getParameter("id"));
		sql = "update CustomTreeRemark set orders = '"+rowid+"',remark='"+inputtext+"' where id='"+_id+"' and mainid='"+mainid+"'";
		if(rs.execute(sql))
		result = true;
	}
	java.io.PrintWriter writer = response.getWriter();
	JSONArray array = new JSONArray();
	if(result){
		JSONObject object2 = new JSONObject();
		object2.put("id",_id.toString().trim());
		object2.put("msg","yes");
		array.add(object2);
	}else{
		JSONObject object2 = new JSONObject();
		object2.put("id","");
		object2.put("msg","no");
		array.add(object2);
	}
	writer.print(array.toString());
}else if(operation.equals("delremark")){//删除树描述
	java.io.PrintWriter writer = response.getWriter();
	JSONArray array = new JSONArray();
	String _id = Util.null2String(request.getParameter("id"));
	String mainid = Util.null2String(request.getParameter("mainid"));
	sql = "delete from CustomTreeRemark where id='"+_id+"' and mainid='"+mainid+"'";
	if(rs.execute(sql)){
		JSONObject object2 = new JSONObject();
		object2.put("msg","yes");
		array.add(object2);
	}else{
		JSONObject object2 = new JSONObject();
		object2.put("msg","no");
		array.add(object2);
	}
	writer.print(array.toString());
}else{
FileUpload fu = new FileUpload(request);
operation = Util.null2String(fu.getParameter("operation"));
String treename = InterfaceTransmethod.toHtmlForMode(fu.getParameter("treename"));
String treedesc = InterfaceTransmethod.toHtmlForMode(fu.getParameter("treedesc"));
String rootname = InterfaceTransmethod.toHtmlForMode(fu.getParameter("rootname"));
String rooticon = Util.null2String(fu.uploadFiles("rooticon"));
String oldrooticon = Util.null2String(fu.getParameter("oldrooticon"));
String defaultaddress = InterfaceTransmethod.toHtmlForMode(fu.getParameter("defaultaddress"));
String expandfirstnode = InterfaceTransmethod.toHtmlForMode(fu.getParameter("expandfirstnode"));
int id = Util.getIntValue(Util.null2String(fu.getParameter("id")),0);
String currentdate = weaver.general.TimeUtil.getCurrentDateString();
String currenttime = weaver.general.TimeUtil.getOnlyCurrentTimeString();
if(rooticon.equals("")){
	rooticon = oldrooticon;
}
int creater = user.getUID();
if (operation.equals("save")) {
	sql = "insert into mode_customtree(treename,treedesc,creater,createdate,createtime,rootname,rooticon,defaultaddress,expandfirstnode)"+
	" values ('"+treename+"','"+treedesc+"','"+creater+"','"+currentdate+"','"+currenttime+"','"+rootname+"','"+rooticon+"','"+defaultaddress+"','"+expandfirstnode+"')";
	rs.executeSql(sql);
	
	sql = "select max(id) id from mode_customtree where creater = " + creater + " and treename = '"+treename+"'";
	rs.executeSql(sql);
	while(rs.next()){
		id = rs.getInt("id");
	}
	response.sendRedirect("/formmode/tree/CustomTreeView.jsp?id="+id);
}else if (operation.equals("edit")) {
	sql = "update mode_customtree set";
	sql += " treename = '"+treename+"',";
	sql += " treedesc = '"+treedesc+"',";
	sql += " rootname = '"+rootname+"',";
	sql += " defaultaddress = '"+defaultaddress+"',";
	sql += " expandfirstnode = '"+expandfirstnode+"',";
	sql += " rooticon = '"+rooticon+"'";
	sql += " where id = " + id;
	rs.executeSql(sql);
	response.sendRedirect("/formmode/tree/CustomTreeView.jsp?id="+id);
}else if (operation.equals("del")) {
	sql = "delete from mode_customtree ";
	sql += " where id = " + id;
	rs.executeSql(sql);
	response.sendRedirect("/formmode/tree/CustomTreeList.jsp");	
}
}
%>