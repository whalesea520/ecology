<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.workflow.workflow.*"%>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wFManager" class="weaver.workflow.workflow.WFManager" scope="page" />
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	boolean haspermission = new WfRightManager().hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int menuType = Util.getIntValue(request.getParameter("menuType"), -1);
	String src = Util.null2String(request.getParameter("src"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	int enable = Util.getIntValue(request.getParameter("enable"), 0);
	String newName = Util.null2String(request.getParameter("newName"));
	String newName7 = Util.processBody(newName, "7");
	String newName8 = Util.processBody(newName, "8");
	String newName9 = Util.processBody(newName, "9");
	
	String nodename = "";
	String customMessage = "";
	int fieldid = 0;
	String usecustomsender = "";
	
	if("save".equals(src)) {
		customMessage = Util.null2String(request.getParameter("customMessage"));
		fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
		if(1 == menuType) { // 新建短信
			usecustomsender = Util.null2String(request.getParameter("usecustomsender"));
		}
		String sql = "";
		if(id > 0) {
			sql = "update workflow_nodeCustomNewMenu set customMessage='" + Util.toHtml100(customMessage) + "', fieldid=" + fieldid + ", usecustomsender='" + usecustomsender + "', enable=" + enable + ", newName7='" + Util.toHtml100(newName7) + "', newName8='" + Util.toHtml100(newName8) + "', newName9='" + Util.toHtml100(newName9) + "' where id=" + id;
		}else {
			sql = "insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, customMessage, fieldid, usecustomsender) values(" + wfid + ", " + nodeid + ", " + menuType + ", " + enable + ", '" + Util.toHtml100(newName7) + "', '" + Util.toHtml100(newName8) + "', '" + Util.toHtml100(newName9) + "', '" + Util.toHtml100(customMessage) + "', " + fieldid + ", '" + usecustomsender + "') ";
		}
		rs.executeSql(sql);
	}else {
		newName7 = Util.null2String(request.getParameter("newName7"));
		boolean enableMultiLang = Util.isEnableMultiLang();
		newName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{newName7, newName8, newName9}) : newName7;
		
		rs.executeSql("select * from workflow_nodeCustomNewMenu where id=" + id);
		if(rs.next()) {
			customMessage = Util.null2String(rs.getString("customMessage"));
			fieldid = Util.getIntValue(rs.getString("fieldid"), 0);
			if(1 == menuType) { // 新建短信
				usecustomsender = Util.null2String(rs.getString("usecustomsender"));
			}
		}
		rs.executeSql("select * from workflow_nodebase where id=" + nodeid);
		if(rs.next()) {
			nodename = Util.null2String(rs.getString("nodename"));
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
	if("save" == src) {
		var parentWin = parent.getParentWindow(window);
		parentWin.onShowBackButtonNameBrowserCallback();
	}
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
	<FORM NAME="SearchForm" id=SearchForm STYLE="margin-bottom: 0" action="showButtonNameDetail.jsp" method="post">
		<input type="hidden" name="wfid" value="<%=wfid %>" />
		<input type="hidden" name="nodeid" value="<%=nodeid %>" />
		<input type="hidden" name="id" value="<%=id %>" />
		<input type="hidden" name="menuType" value="<%=menuType %>" />
		<input type="hidden" name="enable" value="<%=enable %>" />
		<input type="hidden" name="newName" value="<%=newName %>" />
		<input type="hidden" name="src" value="save" />
		<wea:layout type="2col">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>">
				<wea:item><%=SystemEnv.getHtmlLabelName(18908, user.getLanguage()) %></wea:item>
				<wea:item>
					<INPUT class=InputStyle maxLength=40 size=40 name="customMessage" value="<%=customMessage %>" />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(21740, user.getLanguage()) %></wea:item>
				<wea:item>
					<select name="fieldid">
						<option></option>
						<%
							wFManager.setWfid(wfid);
							wFManager.getWfInfo();
							String isbill = wFManager.getIsBill();
							int formid = wFManager.getFormid();
							
							String sql = "";
							if("0".equals(isbill)) {
								sql = "select workflow_formfield.fieldid id, workflow_fieldlable.fieldlable fieldlabel from workflow_formfield,workflow_fieldlable where workflow_formfield.fieldid=workflow_fieldlable.fieldid and workflow_fieldlable.formid=workflow_formfield.formid  and workflow_fieldlable.formid=" + formid + " and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and langurageid=" + user.getLanguage();
							}else {
								sql = "select id,fieldlabel from workflow_billfield where viewtype=0 and billid=" + formid;
							}
							rs.execute(sql);
							while(rs.next()) {
								int fieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
								String fieldlabel = "0".equals(isbill) ? Util.null2String(rs.getString("fieldlabel")) : SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"), user.getLanguage());
						%>
								<option value="<%=fieldid_tmp %>" <% if(fieldid_tmp == fieldid) { %> selected="selected" <% } %>><%=fieldlabel %></option>
						<%	} %>
					</select>
				</wea:item>
				<% if(1 == menuType) { // 新建短信 %>
					<wea:item><%=SystemEnv.getHtmlLabelName(21897, user.getLanguage()) %></wea:item>
					<wea:item>
						<input type="checkbox" name="usecustomsender" value="1" tzCheckbox="true" <% if("1".equals(usecustomsender)) { %> checked="checked" <% } %> />
					</wea:item>
				<% }else if(2 == menuType) { // 新建微信 %>
					<wea:item>
						<B><%=SystemEnv.getHtmlLabelName(85, user.getLanguage()) %>：</B><%=SystemEnv.getHtmlLabelName(32868, user.getLanguage()) %>
					</wea:item>
				<% } %>
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
