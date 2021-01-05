<%@page import="weaver.general.Util"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String cptid = request.getParameter("cptid");
rs.executeSql("select capitalnum,frozennum from cptcapital where id="+cptid);
if (rs.next()) {
	double capitalnum = Util.getDoubleValue(rs.getString("capitalnum"),0.0);
	double frozennum = Util.getDoubleValue(rs.getString("frozennum"),0.0);
	out.println(capitalnum-frozennum);
} else {
	out.println("0.0");
}
%>