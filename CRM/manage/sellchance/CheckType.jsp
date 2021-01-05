
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
        String customerId = Util.null2String(request.getParameter("customerId"));
		String sellchanceId = Util.null2String(request.getParameter("sellchanceId"));
		String sql = "";
		if(sellchanceId.equals("")){
			sql = "select id from CRM_SellChance where selltype=1 and endtatusid=0 and customerid="+customerId;
			rs.executeSql(sql);
			if(rs.next()){
				out.print("false");
			}
		}else{
			sql = "select id from CRM_SellChance where selltype=1 and endtatusid=0 and customerid="+customerId+" and id <> "+sellchanceId;
			rs.executeSql(sql);
			if(rs.next()){
				out.print("false");
			}
		}
		return;
%>