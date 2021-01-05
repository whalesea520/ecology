
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");
	String ids = Util.null2String(request.getParameter("ids"));
	String[] idArr = ids.split(",");
	String names = "";
	for(int i = 0; i < idArr.length; i++) {
		String sql = "select name from datashowset a where id="+idArr[i];
		rs.executeSql(sql);
		if(rs.next()) {
			names = names + rs.getString("name") + ",";
		}
	}
	out.print(""+names);
 %>

