
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<%
String src = Util.null2String(request.getParameter("src"));
String tabid = Util.null2String(request.getParameter("tabid"));
String typeid = Util.null2String(request.getParameter("typeid"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
String hasRightSub = Util.null2String(request.getParameter("hasRightSub"));

if (tabid.equals("")) tabid = "0";

String check_per = Util.null2String(request.getParameter("selectedids"));
if(check_per.equals(",")) {
	check_per = "";
}
if(check_per.equals("")) {
	check_per = Util.null2String(request.getParameter("systemIds"));
}

int perpage = Util.getIntValue(request.getParameter("pageSize"), 10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
String id = null;
StringTokenizer st = new StringTokenizer(check_per, ",");
if(src.equalsIgnoreCase("dest")) {//右侧已选择列表的sql条件	
	if(st != null){
		while(st.hasMoreTokens()){
			id = st.nextToken();
			String tmp_lastname = WorkflowComInfo.getWorkflowname(id);
			String tmp_typename = WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(id));
			JSONObject tmp = new JSONObject();
			tmp.put("id", id);
			tmp.put("workflowname", tmp_lastname);
			tmp.put("typename", tmp_typename);
			jsonArr.add(tmp);
		}
	}

	int totalPage = jsonArr.size();
	if(totalPage % perpage > 0 || totalPage == 0){
		totalPage++;
	}

	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
} else {//左侧待选择列表的sql条件
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

	String sqlfrom = "workflow_base,workflow_type";

	//屏蔽已选路径
	String excludeId = Util.null2String(request.getParameter("excludeId"));
	if(excludeId.length() == 0) excludeId = check_per;
	if (sqlwhere.isEmpty()) {
		sqlwhere += " workflow_base.workflowtype=workflow_type.id AND workflow_base.isvalid='1' AND (workflow_base.istemplate IS NULL OR workflow_base.istemplate<>'1')";
	} else {
		sqlwhere += " AND workflow_base.workflowtype=workflow_type.id AND workflow_base.isvalid='1' AND (workflow_base.istemplate IS NULL OR workflow_base.istemplate<>'1')";
	}
	if(excludeId.length() > 0) {
		sqlwhere += " AND workflow_base.id NOT IN (" + excludeId + ")";
	}
	if (!"".equals(typeid) && !"0".equals(typeid)) {
		sqlwhere += " AND workflow_base.workflowtype=" + typeid + "";
	}
	if ("1".equals(tabid) && !"".equals(workflowname)) {
		sqlwhere += " AND workflow_base.workflowname LIKE '%" + workflowname + "%'";
	}
	
	if(!"".equals(hasRightSub)){
	    sqlwhere +=" AND workflow_base.subcompanyid in ("+hasRightSub+")";
	}
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" workflow_base.id as id, workflowname, typename ");
	spp.setSqlFrom(sqlfrom);
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy("typename, workflowname");
	spp.setPrimaryKey("workflow_base.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	int RecordSetCounts = spu.getRecordCount();
	int totalPage = RecordSetCounts/perpage;
	if(totalPage % perpage > 0 || totalPage == 0) {
		totalPage++;
	}

	rs = spu.getCurrentPageRs(pagenum, perpage);

	while(rs.next()) {
		JSONObject tmp = new JSONObject();
		tmp.put("id", rs.getString("id"));
		tmp.put("workflowname", rs.getString("workflowname"));
		tmp.put("typename", rs.getString("typename"));
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("totalPage", totalPage);
	json.put("mapList", jsonArr.toString());
	out.println(json.toString());
}
%>	