<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="weaver.formmode.browser.FormModeBrowserUtil"%>
<%@ include file="/formmode/pub_init.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	PrintWriter writer = response.getWriter();
	ArrayList<Map<String,String>> modeDetailLabelNameList = new ArrayList<Map<String,String>>();
	int modedetailno = 0;
	String sql = "select * from workflow_base where id = '"+workflowid+"'";
	rs.executeSql(sql);
	rs.next();
	String formid = Util.null2String(rs.getString("formid"));
	//主表名称
	sql = "select tablename from workflow_bill where id='"+formid+"'";
	rs.executeSql(sql);
	rs.next();
	String maintablename = Util.null2String(rs.getString("tablename"));
	String tempdetailtable = "";
	boolean isdetail = false;
	sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = '" + formid + "' order by viewtype asc,detailtable asc,id asc";
	rs.executeSql(sql);
	while(rs.next()){
		String viewtype = Util.null2String(rs.getString("viewtype"));
		String detailtable = Util.null2String(rs.getString("detailtable"));
		if(viewtype.equals("1")&&!tempdetailtable.equals(detailtable)){
			isdetail = true;
			modedetailno = Util.getIntValue(detailtable.replace(maintablename+"_dt", ""));
			tempdetailtable = detailtable;
			Map map = new HashMap();
			map.put("name",SystemEnv.getHtmlLabelName(17463,user.getLanguage())+""+modedetailno);//明细
			map.put("value","detail"+modedetailno);
			modeDetailLabelNameList.add(map);
		}
	}
	JSONArray array = new JSONArray();
	JSONObject object2 = new JSONObject();
	object2.put("name",SystemEnv.getHtmlLabelName(21778,user.getLanguage()));//主表
	object2.put("value","maintable");
	array.add(object2);
	for(Map detailtable : modeDetailLabelNameList){
		String name = Util.null2String(detailtable.get("name").toString());
		String value = Util.null2String(detailtable.get("value").toString());
		JSONObject object3 = new JSONObject();
		object3.put("name",name);
		object3.put("value",value);
		array.add(object3);
	}
	writer.print(array.toString());
	return;
%>