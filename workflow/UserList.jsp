
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script>
		function addUser(){
			var url="/workflow/UserEdit.jsp?type=add";
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			var url = url;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(84070,user.getLanguage())%>";
			dialog.Width = 600;
			dialog.Height = 400;
			dialog.URL = url;
			dialog.show();
		}
		
		function editUser(keyid){
			var url="/workflow/UserEdit.jsp?keyid="+keyid;
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			var url = url;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(84573,user.getLanguage())%>";
			dialog.Width = 600;
			dialog.Height = 400;
			dialog.URL = url;
			dialog.show();
		}
		
		function delRecord(keyid){
			$.ajax({ 
		        type: "GET",
		        url: "/workflow/UserOperation.jsp?src=del&keyid="+keyid,
		        success:function(){
		        	window.location.reload();
		        }
	        });
		}
	</script>
</head>
<%
String backfields="keyid,name,usertype,userids";
String sqlWhere="";
String fromSql=" workflow_userref ";
String orderby=" keyid "; 
String tableString =" <table instanceid=\"workflow_userref\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WEBSERVICEPERMISSION,user.getUID())+"\" >"+
	"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"keyid\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
	"			<head>"+
	"				<col width=\"20%\"  text=\"IP\" column=\"name\" orderkey=\"name\" transmethod=\"\"  />"+
	"				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"usertype\" transmethod=\"weaver.workflow.workflow.WfUserRef.transUserType\"  />"+
	"				<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(84276,user.getLanguage())+"\" column=\"userids\" transmethod=\"weaver.workflow.workflow.WfUserRef.transNames\" otherpara=\"column:usertype\"  />"+
	"			</head>"+
	"     <operates width=\"8%\">" +
	"          <operate href=\"javascript:editUser()\" linkkey=\"keyid\" linkvaluecolumn=\"keyid\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>" +
	"          <operate href=\"javascript:delRecord();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" index=\"1\"/>" +
	"     </operates>" +
	" </table>";
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addUser(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84574,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td></td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:addUser();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_WEBSERVICEPERMISSION %>"/>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</body>
</html>
