<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.workflow.workflow.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
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
	
	String isOpenWorkflowReturnNode = GCONST.getWorkflowReturnNode(); // 是否启用流程退回时可选退回节点功能
	
	String isrejectremind = "0";
	String ischangrejectnode = "0";
	int isselectrejectnode = 0;
	String isSubmitDirectNode = "";
	String rejectableNodes = "";
	String rejectableNodesSpan = "";
	
	if("save".equals(src)) {
		isrejectremind = Util.null2String(request.getParameter("isrejectremind"));
		if("1".equals(isrejectremind)) {
			ischangrejectnode = Util.null2String(request.getParameter("ischangrejectnode"));
		}
		isselectrejectnode = Util.getIntValue(request.getParameter("isselectrejectnode"), 0);
		if(2 == isselectrejectnode) {
			rejectableNodes = Util.null2String(request.getParameter("rejectableNodes")).trim();
		}
		isSubmitDirectNode = Util.null2String(request.getParameter("isSubmitDirectNode"));
		String sql = "update workflow_flownode set isrejectremind='" + isrejectremind + "', ischangrejectnode='" + ischangrejectnode + "', isselectrejectnode=" + isselectrejectnode + ", isSubmitDirectNode='" + isSubmitDirectNode + "', rejectableNodes='" + rejectableNodes + "' where workflowid=" + wfid + " and nodeid=" + nodeid;
		rs.executeSql(sql);
	}else {
		HashMap nodeNameMap = new HashMap();
		rs.executeSql("select b.nodename, a.* from workflow_flownode a, workflow_nodebase b where a.nodeid = b.id and a.workflowid=" + wfid + " order by a.nodeid ");
		while(rs.next()) {
			int id = Util.getIntValue(rs.getString("nodeid"), 0);
			if(id > 0) {
				String name = Util.null2String(rs.getString("nodename"));
				nodeNameMap.put("" + id, name);
				if(id == nodeid) {
					isrejectremind = Util.null2String(rs.getString("isrejectremind"));
					ischangrejectnode = Util.null2String(rs.getString("ischangrejectnode"));
					isselectrejectnode = Util.getIntValue(rs.getString("isselectrejectnode"), 0);
					isSubmitDirectNode = Util.null2String(rs.getString("isSubmitDirectNode"));
					rejectableNodes = Util.null2String(rs.getString("rejectableNodes")).trim();
				}
			}
		}
		if(!"1".equals(isOpenWorkflowReturnNode)) {
			isselectrejectnode = 0;
			rejectableNodes = "";
		}else {
			if(!"".equals(rejectableNodes)) {
				String[] rejectableNodesArr = rejectableNodes.split(",");
				for(int i = 0; i < rejectableNodesArr.length; i++) {
					String id = rejectableNodesArr[i];
					if(!"".equals(id)) {
						String name = Util.null2String(nodeNameMap.get(id));
						if(!"".equals(name)) {
							rejectableNodesSpan += "," + name;
						}
					}
				}
				if(!"".equals(rejectableNodesSpan)) {
					rejectableNodesSpan = rejectableNodesSpan.substring(1);
				}
			}
		}
		nodename = Util.null2String(nodeNameMap.get("" + nodeid));
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
	<FORM NAME="SearchForm" id=SearchForm STYLE="margin-bottom: 0" action="showButtonNameReject.jsp" method="post">
		<input type="hidden" name="wfid" value="<%=wfid %>" />
		<input type="hidden" name="nodeid" value="<%=nodeid %>" />
		<input type="hidden" name="src" value="save" />
		<wea:layout type="2col">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>">
				<wea:item><%=SystemEnv.getHtmlLabelName(126457, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="checkbox" name="isrejectremind" tzCheckbox="true" value="1" <% if("1".equals(isrejectremind)) { %> checked="checked" <% } %> onclick="rejectremindChange(this, 'ischangrejectnode', 'changRejectNodeSpan')" />
					<span id="changRejectNodeSpan" style="<% if(!"1".equals(isrejectremind)) { %> display: none; <% } %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="ischangrejectnode" id="ischangrejectnode" value="1" <% if("1".equals(isrejectremind) && "1".equals(ischangrejectnode)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(31498, user.getLanguage()) %>	
					</span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(82298, user.getLanguage()) %></wea:item>
				<wea:item>
					<select name="isselectrejectnode" id="isselectrejectnode" onchange="changeRejectMode(this)">
						<option value="0" <% if(0 == isselectrejectnode) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(126466, user.getLanguage()) %></option>
						<% if("1".equals(isOpenWorkflowReturnNode)) { %>
							<option value="1" <% if(1 == isselectrejectnode) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(82300, user.getLanguage()) %></option>
							<option value="2" <% if(2 == isselectrejectnode) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(126468, user.getLanguage()) %></option>
						<% } %>
					</select>
				</wea:item>
				<%
					String rejectableNodesShow = 2 == isselectrejectnode ? "{'samePair':'rejectableNodesShow','display':''}" : "{'samePair':'rejectableNodesShow','display':'none'}";
					String rejectbrowserurl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp?workflowId=" + wfid + "&printNodes=";
					String rejectbrowsercompleteurl ="/data.jsp?type=workflowNodeBrowser&wfid=" + wfid;
				%>
				<wea:item attributes="<%=rejectableNodesShow %>"><%=SystemEnv.getHtmlLabelName(26437, user.getLanguage()) %></wea:item>
				<wea:item attributes="<%=rejectableNodesShow %>">
					<brow:browser name="rejectableNodes" viewType="0" hasBrowser="true" hasAdd="false"
						browserUrl="<%=rejectbrowserurl %>" isMustInput="2" isSingle="false" hasInput="true"
						completeUrl="<%=rejectbrowsercompleteurl %>" width="200px" browserValue="<%=rejectableNodes %>" browserSpanValue="<%=rejectableNodesSpan %>" />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(126458, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="checkbox" name="isSubmitDirectNode" tzCheckbox="true" value="1" <% if("1".equals(isSubmitDirectNode)) { %> checked="checked" <% } %> />
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
	if(jQuery("#isselectrejectnode").val() == "2") {
		if(!check_form(SearchForm, "rejectableNodes")) {
			parent.getDialog(parent).alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
			return;
		}
	}
	document.SearchForm.submit();
}

function rejectremindChange(obj, inputName, spanName) {
	if(obj.checked) {
		jQuery("#" + spanName).show();
	}else {
		jQuery("#" + spanName).hide();
		jQuery("#" + inputName).attr("checked", "").next().removeClass("jNiceChecked");
	}
}

function changeRejectMode(obj) {
	if(obj.value == 2) {
		showEle("rejectableNodesShow");
	}else {
		hideEle("rejectableNodesShow");
	}
}
</script>
</html>
