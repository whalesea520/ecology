
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	String method=Util.null2String(request.getParameter("method"));
	int rdiSele = Util.getIntValue(request.getParameter("rdiSele"),-1);

	if("save".equals(method)){
		String strSql="delete hpuserselect where userid="+user.getUID();
			rs.executeSql(strSql);	
			//System.out.println(strSql);
			strSql="insert into hpuserselect (userid,infoid) values ("+user.getUID()+","+rdiSele+")";
			rs.executeSql(strSql);	
			//System.out.println(strSql);		
	    response.sendRedirect("HomepageSele.jsp?subCompanyId="+subCompanyId);
	}

%>