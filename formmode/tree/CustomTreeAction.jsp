<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operation = Util.null2String(request.getParameter("operation"));
if(operation.equals("getTreeNodeByField")){//根据字段获取树形节点id
	int fieldid = Util.getIntValue(request.getParameter("fieldid"));
	int paraid = Util.getIntValue(request.getParameter("paraid"));
	String sql = "select a.fielddbtype from workflow_billfield a where a.id="+fieldid+" and  a.fieldhtmltype=3  and a.type in (256,257)";
	rs.executeSql(sql);
	String fielddbtype = "";
	int istreefield = 0;
	JSONArray jsonArray = new JSONArray();
	if(rs.next()){
		fielddbtype = rs.getString("fielddbtype");
		istreefield = 1;
		sql = "select id,nodename from mode_customtreedetail a where mainid="+fielddbtype+" order by a.dataorder";
		rs.executeSql(sql);
		while(rs.next()){
			String tempid = rs.getString("id");
			String tempname = rs.getString("nodename");
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("id",tempid);
			jsonObject.put("name",tempname);
			jsonArray.add(jsonObject);
		}
	}
	
	String treenodeid = "";
	rs.executeQuery("select treenodeid from  modedatainputfield where id = ? ",paraid);
	if(rs.next()) {
		treenodeid = Util.null2String(rs.getString("treenodeid"));
	}
	
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("istreefield",istreefield);
	jsonObj.put("treenodeid", treenodeid);
	jsonObj.put("dataArray",jsonArray);
	response.getWriter().write(jsonObj.toString());
	return;
}

%>

