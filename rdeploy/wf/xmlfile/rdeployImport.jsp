
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*,javax.servlet.jsp.JspWriter" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowDataService" class="weaver.workflow.imports.services.WorkflowDataService" scope="page" />

<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();

if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String xmlfilepath="";
String type = "1";
String filename = "2.xml";
int index = filename.indexOf(".");
String orderid = filename.substring(0, index);
try
{
	xmlfilepath = GCONST.getRootPath()+"rdeploy/wf/xmlfile"+File.separatorChar+filename ;
	//System.out.println("xmlfilepath : "+xmlfilepath);
	File oldfile = new File(xmlfilepath);
	//if(oldfile.exists())
	//{
	//	oldfile.delete();
	//}
}
catch(Exception e){}
WorkflowDataService.setRemoteAddr("127.0.0.1");
WorkflowDataService.setUser(user);
WorkflowDataService.setType(type);

WorkflowDataService.importWorkflowByXml(xmlfilepath);

String workflowid = WorkflowDataService.getWorkflowid();
String formid = WorkflowDataService.getFormid();
String isbill = WorkflowDataService.getIsbill();
RecordSet.execute("INSERT INTO Workflow_Initialization values("+workflowid+","+orderid+")");

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>  
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelweb_tw_wev8.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelweb_wev8.js"></script>
<%} %>
<script language=javascript>
</script>
</head>
<BODY onload="displayExcel();">
<div>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33659,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    <input type="button" value="查看工作流程基础数据" class="e8_btn_top" onclick="viewWfBaseData();"/>
		    <script>
		    	function viewWfBaseData(){
		    		window.open("/system/basedata/basedata_workflow.jsp?wfid=<%=workflowid %>","_blank");
		    	}
		    </script>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context="导入结果">
		<wea:item>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
</BODY>
</HTML>