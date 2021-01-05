<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.workflow.workflow.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	boolean haspermission = new WfRightManager().hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String src = Util.null2String(request.getParameter("src"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	String nodename = "";
	
	String IsBeForwardModify = "";
	
	if("save".equals(src)) {
		IsBeForwardModify = Util.null2String(request.getParameter("IsBeForwardModify"));
		String sql = "update workflow_flownode set IsBeForwardModify='" + IsBeForwardModify + "' where workflowid=" + wfid;
		if(!"1".equals(Util.null2String(request.getParameter("sync")))) { // 是否同步到所有节点
			sql += " and nodeid=" + nodeid;
		}
		rs.executeSql(sql);
	}else {
		rs.executeSql("select b.nodename, a.* from workflow_flownode a, workflow_nodebase b where a.nodeid = b.id and a.workflowid=" + wfid + " and a.nodeid=" + nodeid + " order by a.nodeid ");
		if(rs.next()) {
			nodename = Util.null2String(rs.getString("nodename"));
			IsBeForwardModify = Util.null2String(rs.getString("IsBeForwardModify"));
		}
	}
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
function closeWindow(src) {
	var dialog = parent.getDialog(window);
	dialog.close();
}
<% if("save".equals(src)) { %>
closeWindow("save");
<% } %>
</script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ", javascript:onSave(), _self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=nodename %>" />
</jsp:include>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top" onclick="onSave();" />
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<FORM NAME="SearchForm" id=SearchForm STYLE="margin-bottom: 0" action="showButtonNameTakingOp.jsp" method="post">
		<input type="hidden" name="wfid" value="<%=wfid %>" />
		<input type="hidden" name="nodeid" value="<%=nodeid %>" />
		<input type="hidden" name="src" value="save" />
		<wea:layout type="2col">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(126633, user.getLanguage()) %>">
				<wea:item><%=SystemEnv.getHtmlLabelName(21738, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="checkbox" name="sync" id="sync" value="1" />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(126634, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="checkbox" name="IsBeForwardModify" tzCheckbox="true" value="1" <% if("1".equals(IsBeForwardModify)) { %> checked="checked" <% } %> />
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="closeWindow('')">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</body>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});

function onSave() {
	document.SearchForm.submit();
}
</script>
</html>
