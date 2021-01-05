
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%
String url = Util.null2String(request.getParameter("url"));
String isbill = Util.null2String(request.getParameter("isbill"));
String id = Util.null2String(request.getParameter("id"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String linkid = Util.null2String(request.getParameter("linkid"));
String wfid = Util.null2String(request.getParameter("wfid"));
String requestid = Util.null2String(request.getParameter("requestid"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
// modify by sean for TD3074
String fromBillManagement = Util.null2String(request.getParameter("fromBillManagement"));
String formid = Util.null2String(request.getParameter("formid"));

if(!isbill.equals(""))
	url += "&isbill="+isbill;
if(!id.equals(""))
	url += "&id="+id;
if(!nodeid.equals(""))
	url += "&nodeid="+nodeid;
if(!linkid.equals(""))
	url += "&linkid="+linkid;
	
// modify by sean for TD3074	
if(!fromBillManagement.equals(""))
	url += "&fromBillManagement="+fromBillManagement;
if(!formid.equals(""))
	url += "&formid="+formid;	
if(!wfid.equals(""))
	url += "&wfid="+wfid;	
if(!requestid.equals(""))
	url += "&requestid="+requestid;	
if(!workflowid.equals(""))
	url += "&workflowid="+workflowid;	


%>
<html>

<head>
</head>

<frameset rows="2,98%" framespacing="0" border="0" frameborder="0" >
  <frame name="contents" target="main"  marginwidth="0" marginheight="0" scrolling="auto" noresize >
  <frame name="main" marginwidth="0" marginheight="0" scrolling="auto" src="<%=url%>">
  <noframes>
  <body>
  <p><%=SystemEnv.getHtmlLabelName(15614,user.getLanguage())%></p>

  </body>
  </noframes>
</frameset>

</html>