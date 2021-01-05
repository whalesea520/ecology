
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

	int userid = user.getUID();
	String wfid = Util.null2String(request.getParameter("wfid"));
	if(wfid.equals("")){
		return;
	}
	//查询点击流程所有的版本数据
	String wfids = WorkflowVersion.getVersionStringByWfid(wfid);
	if ("".equals(wfids)) {
	    wfids = wfid;
	}
	//所有版本点击的总次数
	int count = 0;
	rs.execute("select COUNT(1) as count from WorkflowUseCount where wfid in (" + wfid + ") and userid="+userid);
	//
	if (rs.next()) {
	    count = rs.getInt(1);
	}
	
    rs.execute("select 1 from WorkflowUseCount where wfid in (" + wfid + ") and userid="+userid);
    if (rs.getCounts() == 0) {
        rs.execute("insert into WorkflowUseCount (wfid,userid,count) values("+wfid+","+userid+", 1)");
    } else if (rs.getCounts() == 1) {
        rs.execute("update WorkflowUseCount set count=count+1 where wfid="+wfid+" and userid="+userid);
    } else {
        rs.executeUpdate("delete from WorkflowUseCount where wfid in (" + wfids + ") and userid="+userid);
        rs.execute("insert into WorkflowUseCount (wfid,userid,count) values("+wfid+","+userid+"," + (count + 1)  + ")");
    }
%>
