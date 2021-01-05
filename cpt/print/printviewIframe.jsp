<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrintUtil" class="weaver.cpt.util.PrintUtil" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
%>
<html>
<head>
<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
<style>
.Line {
	 BACKGROUND-COLOR: #F3F2F2 !important ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}
</style>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
</head>
<body onload="doPrint()">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_top}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div>
<%
String multirequestid = Util.null2String(request.getParameter("customerids"));
String contents="";
int mouldid=-1;
RecordSet.executeSql("select mouldtext from CPT_PRINT_Mould where id="+mouldid);
if (RecordSet.next()) {
    contents=RecordSet.getString("mouldtext");
}
out.println(PrintUtil.parse(contents,user,multirequestid,request));
%>
</div>
</body>
</html>
<script type="text/javascript">
function doPrint() {
	window.print();
}
function onReturn() {
	location.href="/cpt/capital/CapitalBlankTab.jsp?url=/cpt/print/printview.jsp?customerids=<%=multirequestid%>";
}
</script>