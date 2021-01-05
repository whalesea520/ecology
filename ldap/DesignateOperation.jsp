<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.ldap.LdapUtil"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="weaver.general.Util"%>
</head>
<%
//PrintWriter writer  = null;
//writer = response.getWriter();
String ids = Util.null2String(request.getParameter("ids"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String operation  = Util.null2String(request.getParameter("operation"));
if("department".equals(operation)) {
	boolean res = false;
	if("".equals(departmentid)) {
		res = rs.executeSql("update HrmResourceTemp set departmentid= NULL,subcompanyid1 = NULL "+
		" where id in ("+ids+")");
	} else {
		res = rs.executeSql("update HrmResourceTemp set departmentid='"+departmentid+"',"+
		"subcompanyid1=(SELECT t2.subcompanyid1 from HrmDepartment t2 where id="+departmentid+") where id in ("+ids+")");
	}
	if(res) {
		out.print("success");
	} else {
		out.print("error");
	}
	
} else if("userSyn".equals(operation)) {
	ids = ids.substring(0, ids.length() - 1);
	LdapUtil ldap = LdapUtil.getInstance();
	String res = ldap.addUser2HrmResource(ids);
	out.print(res);
}

 %>
</html>