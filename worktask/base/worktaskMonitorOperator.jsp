
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String sql = "";
String method = Util.null2String(request.getParameter("method"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
if("savemonitor".equals(method)){   
	String userids = Util.null2String(request.getParameter("monitor"));
	String monitortype = Util.null2String(request.getParameter("monitortype"));
    if(!"".equals(userids)){
		String tempStrs[] = Util.TokenizerString2(userids,",");
		for(int j=0; j<tempStrs.length; j++){
			int monitor = Util.getIntValue(tempStrs[j], 0);
			if(monitor != 0){
				sql = "select * from worktask_monitor where taskid="+wtid+" and monitor="+monitor;
				rs.execute(sql);
				if(rs.next()){
					sql = "update worktask_monitor set monitortype="+monitortype+" where taskid="+wtid+" and monitor="+monitor;
				}else{
					sql = "insert into worktask_monitor (taskid, monitor, monitortype) values ("+wtid+", "+monitor+", "+monitortype+")";
				}
				//System.out.println("sql = " + sql);
				rs.execute(sql);
			}
		}
    }
    response.sendRedirect("WorkTaskMonitorAdd.jsp?isclose=1&wtid="+wtid);
    return;
	
}else if("delmonitor".equals(method)){
	
	String ids = Util.null2String(request.getParameter("ids"));	
	if(!"".equals(ids))
		rs.executeSql("delete from worktask_monitor where id in("+ids+"0)");
}


%>