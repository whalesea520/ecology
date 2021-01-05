<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int wfid = Util.getIntValue(Util.null2String(request.getParameter("wfid")), 0);
	String mainOnly = Util.null2String(request.getParameter("mainOnly")); // 1-只显示主表字段和系统字段
	String fieldname = Util.null2String(request.getParameter("fieldname"));
	int tabletype = Util.getIntValue(Util.null2String(request.getParameter("tabletype")), -2);
	
	int formid = 0;
    String isbill = "";
    rs.executeSql("select * from workflow_base where id=" + wfid);
    while(rs.next()) {
    	formid = Util.getIntValue(Util.null2String(rs.getString("formid")), 0);
    	isbill = Util.null2String(rs.getString("isbill"));
    }
	
    int detailcount = 0;
    if(!"1".equals(mainOnly)) {
		String detailcountsql = "select groupid from workflow_formfield where isdetail = '1' and formid=" + formid + " group by groupid order by groupid";
		if("1".equals(isbill)) {
			detailcountsql = "select tablename from workflow_billdetailtable where billid=" + formid + " order by orderid ";
		}
		rs.executeSql(detailcountsql);
		detailcount = rs.getCounts();
    }
%>
<HTML>
<HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onSubmit(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:onClose(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:onClear(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(261, user.getLanguage()) %>" />
</jsp:include>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" onclick="onSubmit();" />
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<FORM NAME="SearchForm" action="nodelinkOverTimeEditFieldBrowser.jsp" method="post">
		<input type="hidden" id="wfid" name="wfid" value="<%=wfid %>" />
		<input type="hidden" id="mainOnly" name="mainOnly" value="<%=mainOnly %>" />
		<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage()) %>">
				<wea:item><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="text" name="fieldname" value="<%=fieldname %>" />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(686, user.getLanguage()) %></wea:item>
				<wea:item>
					<select id="tabletype" name="tabletype">
						<option value="-2" <% if(tabletype == -2) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
						<option value="-1" <% if(tabletype == -1) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(28415, user.getLanguage()) %></option>
						<option value="0" <% if(tabletype == 0) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(18549, user.getLanguage()) %></option>
						<% for(int i = 1; i <= detailcount; i++) { %>
							<option value="<%=i %>" <% if(tabletype == i) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(17463, user.getLanguage()) + i + SystemEnv.getHtmlLabelName(261, user.getLanguage()) %></option>
						<% } %>
					</select>
				</wea:item>
			</wea:group>
		</wea:layout>
		<%
			String tableString = "<table pageId=\"" + PageIdConst.WF_WORKFLOW_FIELDBROWSER_OT + "\" datasource=\"weaver.workflow.workflow.NodelinkOverTimeUtil.getWorkflowOTTriggerField\" "
				+ " sourceparams=\"formid:" + formid + "+isbill:" + isbill + "+fieldname:" + fieldname + "+tabletype:" + tabletype + "+mainOnly:" + mainOnly + "\" "
				+ " instanceid=\"nodelinkOverTimeEditFieldTable\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_FIELDBROWSER_OT, user.getUID()) + "\" tabletype=\"none\">"
				+ "<sql backfields=\"*\" sqlform=\"tmptable\" sqlorderby=\"id\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqldistinct=\"true\" />"
				+ "<head>"
				+ "<col width=\"50%\" text=\"" + SystemEnv.getHtmlLabelName(15456, user.getLanguage()) + "\" column=\"fieldname\" />"
				+ "<col width=\"50%\" text=\"" + SystemEnv.getHtmlLabelName(686, user.getLanguage()) + "\" column=\"tabletypeStr\" />"
				+ "<col width=\"0%\" text=\"\" column=\"fieldid\" hide=\"true\" />"
				+ "<col width=\"0%\" text=\"\" column=\"groupStr\" hide=\"true\" />"
				+ "</head>"
				+ "</table>";
		%>
		<wea:SplitPageTag tableString="<%=tableString %>" isShowTopInfo="false" mode="run" />
		<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.WF_WORKFLOW_FIELDBROWSER_OT %>" />
	</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage()) %>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();" />
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onClose();" />
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
jQuery(document).ready(function() {
	resizeDialog(document);
});

function afterDoWhenLoaded(){
	hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click", function() {
		var children = jQuery(this).children();
		var returnjson = {
			id : jQuery(children[3]).text(),
			name : jQuery(children[1]).text() + jQuery(children[4]).text()
		};
		if(dialog) {
			dialog.callback(returnjson);
		}else {
			//window.parent.returnValue = returnjson;
			//window.parent.close();
		}
	});
}

function onClear() {
	var returnjson = {id:"", name:""};
	if(dialog) {
	    dialog.callback(returnjson);
	}else {
	    //window.parent.returnValue  = returnjson;
	    //window.parent.close();
	}
}

function onSubmit() {
	SearchForm.submit();
}

function onClose() {
	if(dialog) {
		dialog.close();
	}else {
		//window.parent.close() ;
	}	
}
</script>
</HTML>
