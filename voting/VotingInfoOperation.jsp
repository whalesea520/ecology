
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
//调查id
String votingid = Util.null2String(request.getParameter("votingid"));
String method = Util.null2String(request.getParameter("method"));

if (method.equals("getVotingInfo")) {
    String data = "{";
    RecordSet.executeSql("select * from voting where id="+votingid);
    while(RecordSet.next()){
    	data+= "\"forcevote\":\""+RecordSet.getString("forcevote")+"\"";
    }
    data += "}";
    out.print(data);
    return;
}

%>

