<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
	<head>
<% 
%>
	<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet"/>
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
	<script language="javascript" src="/js/ecology8/docs/docExt_wev8.js"></script>
	<script type="text/javascript">
		function onBtnSearchClick(){
			jQuery("#searchfrm").submit();
		}
		function reloadPage(){
			window.location.reload();
		}

		
	</script>
	</head>
<%
String pageSize = "10";
int id = Util.getIntValue(request.getParameter("id"),0);
boolean hasRight = false;
boolean hasSubManageRight = false;
WfRightManager am = new WfRightManager();
String  operateString = "";
String sqlWhere = "";
String tabletype="none";
String tableString = "";
String intanceid = "subPermission";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);


/* 以下通过结合旧类型的edit权限和新类型的CREATEDIR权限来设定是否可以编辑 */
hasSubManageRight = am.hasPermission(id, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (HrmUserVarify.checkUserRight("WorkflowManage:All", user) || !hasSubManageRight) {
    hasRight = true;
}

%>

<%
   int operationcode = WfRightManager.OPERATION_CREATEDIR;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="onPermissionDelShare<%=operationcode%>();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>


<%
	String pkColSqlStr = "CONVERT(VARCHAR, CASE WHEN (permissiontype=2) then roleid ELSE userid END)+'_'+CONVERT(VARCHAR, permissiontype)+";
	if("oracle".equalsIgnoreCase(rs.getDBType())){
		pkColSqlStr = "to_char(CASE WHEN (permissiontype=2) then roleid ELSE userid END)||'_'||to_char(permissiontype)||";
	}

	String backfields = " * ";
	String sqlform=" from (select distinct "
			+" seclevel,departmentid,roleid,rolelevel,usertype,permissiontype,operationcode,userid,subcompanyid, "
			+" case when (permissiontype=2) then roleid else userid end sysadmin,"+pkColSqlStr+"'' pkcol "
			+" from wfAccessControlList) t ";
	sqlWhere = "";
	if(hasRight){
	 	tabletype = "checkbox";
	}
	tableString=""+
	   "<table pageId=\""+PageIdConst.WF_WORKFLOW_WFRIGHTEDIT+"\" instanceid=\""+intanceid+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WFRIGHTEDIT,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\""+backfields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" sqlorderby=\"permissiontype,sysadmin\"  sqlprimarykey=\"pkcol\" sqlsortway=\"asc\"  sqlisdistinct=\"true\" />"+
	   "<head>"							 
			 + "<col width='30%' text='"+SystemEnv.getHtmlLabelNames("81651", user.getLanguage())+"' column='pkcol' orderkey='pkcol'"
			 +	" otherpara='column:permissiontype+column:sysadmin+column:dataOrder+"+user.getLanguage()+"' "
			 +	" transmethod='weaver.splitepage.transform.SptmForHR.getWorkflowids' />"

			 + "<col width=\"20%\" transmethod=\"weaver.general.KnowledgeTransMethod.getPermissionType\" text=\""+SystemEnv.getHtmlLabelName(32382,user.getLanguage())+"\" column=\"permissiontype\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"permissiontype\"/>"
			 + "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPermissionDesc\" column=\"permissiontype\" otherpara=\""+user.getLanguage()+"+column:secLevel+column:departmentid+column:roleid+column:roleLevel+column:usertype+column:userid+column:subcompanyid\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"/>"+
	   "</head>"+
	   "<operates>"+
			"<operate href=\"javascript:doEdit();\" otherpara='column:pkcol' text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+//编辑
			"<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"1\"/>"+//删除
		"</operates>"+
	   "</table>";
	   
%> 
	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
	<input type="hidden" name="operation">
	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_WORKFLOW_WFRIGHTEDIT %>"/>
<script>
function doEdit(id, pkcol){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/wfRightAdd.jsp?id="+pkcol;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33808, user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
	
function doDel(id){
	var mainids = id;
   
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){ 
    	window.location = "/workflow/workflow/wfRightOperation.jsp?operationcode=<%=operationcode%>&method=delete&mainids="+mainids+"&wftypeid=<%=id%>";
    });
}

function openDialog(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/wfRightAdd.jsp?wftypeid=<%=id%>&operationcode=<%=operationcode%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33808, user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function chkPermissionAllClick<%=operationcode%>(obj){
    var chks = document.getElementsByName("chkPermissionShareId<%=operationcode%>");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}

function onPermissionDelShare<%=operationcode%>(){
	var mainids = "";
    mainids = _xtable_CheckedCheckboxId();
    if(!mainids)
    {
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26178,user.getLanguage())%>");  
    	return;
    }
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){ 
    	window.location = "/workflow/workflow/wfRightOperation.jsp?operationcode=<%=operationcode%>&method=delete&mainids="+mainids+"&wftypeid=<%=id%>";
    });
}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY></HTML>
