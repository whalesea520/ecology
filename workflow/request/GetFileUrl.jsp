<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

String recordId = Util.null2String(request.getParameter("recordId")).trim();
rs.executeQuery("SELECT IMAGEFILEID FROM Workflow_FormSignRemark WHERE requestLogId = ?", recordId);
String imageFileId = "";
if(rs.next()) {
	imageFileId = Util.null2String(rs.getString("IMAGEFILEID")).trim();
}
JSONArray resultArray = new JSONArray();
JSONObject json = new JSONObject();
json.put("imageFileId",imageFileId);
resultArray.add(json);
out.print(resultArray.toString());

%>