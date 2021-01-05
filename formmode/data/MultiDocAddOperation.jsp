<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<%
String adddocfieldid=Util.null2String(request.getParameter("adddocfieldid"));
String docid=Util.null2String(request.getParameter("docid"));
String docsubject="";
rs.executeQuery("select docsubject from docdetail where id=?",docid);
while(rs.next()){
	docsubject=Util.null2String(rs.getString("docsubject"));
}
%>
<script type="text/javascript">
var dilog=parent.getDialog(window);
dilog.currentWindow.onNewDocCallBack("<%=docid%>","<%=adddocfieldid%>","<%=docsubject%>");
dilog.close();
</script>
</body>
</html>