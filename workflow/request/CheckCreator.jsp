<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.JSONObject" %>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int createtype = Util.getIntValue(request.getParameter("creatertype"));
	int createrid = Util.getIntValue(request.getParameter("createrid"));
	String workflowid = request.getParameter("workflowid");
	
	User user = User.getUser(createrid,createtype-1);
	if(user == null){
	    user = new User();
	    user.setUid(createrid);
	    user.setLogintype(createtype+"");
	}
	
	String sqlWhere = shareManager.getWfShareSqlWhere(user,"t");
	rs.execute("select * from ShareInnerWfCreate t where " +  sqlWhere + "and t.workflowid = " +workflowid);
	JSONObject result = new JSONObject();
    result.put("hasCreatePermission",rs.getCounts());
    out.println(result.toString());
%>