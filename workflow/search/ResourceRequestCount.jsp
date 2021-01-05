<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.workflow.search.WorkflowRequestUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WrokflowOverTimeTimer" class="weaver.system.WrokflowOverTimeTimer" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<script language="javascript">
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}
try{
   	parent.window.taskCallBack(2); 
}catch(e){}
</script>
<%
boolean isfromtab =Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
int requestid =Util.getIntValue((String)session.getAttribute("requestidForAllBill"),0);
String resourceid= Util.null2String(request.getParameter("resourceid"));
int fromAdvancedMenu =Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent =Util.null2String(request.getParameter("selectedContent"));
String menuType = Util.null2String(request.getParameter("menuType"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);

WorkflowRequestUtil WRequestUtil = new WorkflowRequestUtil();
   int flowAll = WRequestUtil.getRequestCount(user,isfromtab,requestid,
			resourceid, fromAdvancedMenu, selectedContent,menuType, infoId);
%>

<body>
<%
out.print(flowAll);
//response.getWriter().write(flowAll);
%>

</body>
</html>

