<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.*,org.json.*" %>
<%@ page import="weaver.hrm.*" %>


<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	int seccategory = Util.getIntValue(request.getParameter("seccategory"));
	String checkSQL = "select count(1) from CHECKIN_USER_SECCATEGORY where userid = "+user.getUID()+"";
	rs.executeSql(checkSQL);
    if (rs.next()) {
        if (rs.getInt(1) > 0) {
            String updateSQL = "update CHECKIN_USER_SECCATEGORY set seccategory = "+seccategory+" where userid = "+user.getUID()+"";
        	rs.execute(updateSQL);
        }
        else
        {
            String updateSQL = "insert into CHECKIN_USER_SECCATEGORY values("+user.getUID()+","+seccategory+")";
        	rs.execute(updateSQL);
        }
    }
	

%>