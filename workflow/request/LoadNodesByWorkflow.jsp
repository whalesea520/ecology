
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
  	if(user == null) {
      	response.sendRedirect("/login/Login.jsp");
      	return;
 	}

	String workflowid = request.getParameter("workflowid");
	if(workflowid != null && !workflowid.trim().equals("")){
			rs.execute("select f.nodeid, n.nodename from workflow_flownode f left join workflow_nodebase n on f.nodeid=n.id where f.workflowid="+workflowid+" order by f.nodetype, f.nodeid");

		while(rs.next()){
			out.println("<option value='"+Util.getIntValue(rs.getString(1), 0)+"'>"
			+Util.null2String(rs.getString(2))
			+"</option>");
		}
	}
%>