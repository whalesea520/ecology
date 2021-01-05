<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>
<%@ page import="java.util.Map,java.util.HashMap,java.util.List,java.util.ArrayList" %>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser(request,response);
	String fileid = Util.null2String(request.getParameter("fileid"));
	String tosharerid = Util.null2String(request.getParameter("tosharerid"));
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	String filetype = Util.null2String(request.getParameter("filetype"));
	String msgid = Util.null2String(request.getParameter("msgid"));
	
	JSONObject obj = new JSONObject();
	Calendar today = Calendar.getInstance();
    String mdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
            + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
            + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
    String mtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
            + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
	
	
	RecordSet rs = new RecordSet();
	 String insertSql = "insert into Networkfileshare (fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) VALUES "+
						" ('"+fileid+"','"+user.getUID()+"','"+tosharerid+"','"+mdate+"','"+mtime+"','"+sharetype+"','"+(filetype.equals("pdoc") ? 1 : 2 )+"','" + msgid + "')";
	 rs.executeSql(insertSql);
	obj.put("flag","1");
	out.println(obj.toString());
%>
