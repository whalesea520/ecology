
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page
	import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser(request, response);
	if (user == null)
		return;

	RecordSet rs = new RecordSet();
	String strSql="select id,infoname,pid,ordernum1 from hpinfo where isuse='1' and subcompanyid >0  order by ordernum1";
	rs.executeSql(strSql);
	StringBuffer treeStr = new StringBuffer();
	treeStr.append("[");
	int id = 0;
	String infoname="";
	int pid =0;
	int ordernum = 0;
	while (rs.next()) {
		JSONObject json = new JSONObject();
		id = Util.getIntValue(rs.getString("id"),0);
		infoname = Util.null2String(rs.getString("infoname"));
		pid = Util.getIntValue(rs.getString("pid"),0);
		ordernum = Util.getIntValue(rs.getString("ordernum1"),0);
		json.put("id", id);
		json.put("pId", pid);
		json.put("name", infoname);
		json.put("ordernum",ordernum);
		treeStr.append(json.toString());
		treeStr.append(",");
	}
	if (treeStr.length() == 1) {
		out.print("[]");
	} else {
		//System.out.println(treeStr.toString().substring(0, treeStr.toString().length() - 1) + "]");
		out.print(treeStr.toString().substring(0, treeStr.toString().length() - 1) + "]");
	}
%>