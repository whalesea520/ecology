
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList,java.text.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="DateUtil" class="weaver.general.DateUtil" scope="page"/>
<%
int userid=user.getUID();     
String logintype = user.getLogintype(); 
String multirequestid = Util.null2String(request.getParameter("multirequestid"));

String sql_tmp = "update workflow_requestbase set ismultiprint=1 where requestid in ("+multirequestid+"0)";
rs.executeSql(sql_tmp);

%>