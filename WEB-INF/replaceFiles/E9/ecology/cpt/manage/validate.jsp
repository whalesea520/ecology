<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

User user = HrmUserVarify.getUser(request, response);
if(user==null) {
	return;
}
String sourcestring = request.getParameter("sourcestring");
String capitalid = request.getParameter("capitalid");

if ("validateNum".equals(sourcestring)) { //校验数量不能小于冻结数量
	String capitalnum = request.getParameter("capitalnum");
	rs.executeSql("select frozennum from cptcapital where id="+Util.getIntValue(capitalid));
	rs.next();
	String frozennum = rs.getString("frozennum");
	if (!"".equals(capitalnum) && Util.getDoubleValue(capitalnum, 0.0) < Util.getDoubleValue(frozennum, 0.0)) {
		out.println("" + Util.getDoubleValue(frozennum, 0.0));
	}
}

%>