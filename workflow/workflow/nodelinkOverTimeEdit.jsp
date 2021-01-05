<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="/workflow/request/CommonUtils.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="OverTimeInfo" class="weaver.workflow.node.NodeOverTimeInfo" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id")).trim();
	String isAssign = Util.null2String(request.getParameter("isAssign"));
	String operate = "";
	String haspasstime = "1";
	String linkid = "";
	String workflowid = "";
	int selectnodepass = 1;
	int nodepasshour = 0;
	int nodepassminute = 0;
	String datefield = "";
	String timefield = "";
	
	String remindname = "";
	String remindtype = "";
	int remindhour = 0;
	int remindminute = 0;
	String repeatremind = "";
	int repeathour = 0;
	int repeatminute = 0;
	String FlowRemind = "";
	String MsgRemind = "";
	String MailRemind = "";
	String ChatsRemind = "";
	String InfoCentreRemind = "";
	int CustomWorkflowid = 0;
	String isnodeoperator = "";
	String iscreater = "";
	String ismanager = "";
	String isother = "";
	String remindobjectids = "";
	
	if("".equals(id)) {
		operate = "add";
		linkid = Util.null2String(request.getParameter("linkid"));
		workflowid = Util.null2String(request.getParameter("workflowid"));
		selectnodepass = Util.getIntValue(request.getParameter("selectnodepass"), 1);
		nodepasshour = Util.getIntValue(request.getParameter("nodepasshour"), 0);
		nodepassminute = Util.getIntValue(request.getParameter("nodepassminute"), 0);
		datefield = Util.null2String(request.getParameter("datefield"));
		timefield = Util.null2String(request.getParameter("timefield"));
		
		rs.executeSql("select count(id) count from workflow_nodelinkOverTime where linkid=" + linkid);
		rs.next();
		remindname = SystemEnv.getHtmlLabelName(15148, user.getLanguage()) + (Util.getIntValue(rs.getString("count"), 0) + 1);
		
	}else {
		operate = "edit";
		rs.executeSql("select * from workflow_nodelinkOverTime where id=" + id);
		if(rs.next()) {
			linkid = Util.null2String(rs.getString("linkid"));
			workflowid = Util.null2String(rs.getString("workflowid"));
			remindname = Util.null2String(rs.getString("remindname"));
			remindtype = Util.null2String(rs.getString("remindtype"));
			remindhour = Util.getIntValue(rs.getString("remindhour"), 0);
			remindminute = Util.getIntValue(rs.getString("remindminute"), 0);
			repeatremind = Util.null2String(rs.getString("repeatremind"));
			repeathour = Util.getIntValue(rs.getString("repeathour"), 0);
			repeatminute = Util.getIntValue(rs.getString("repeatminute"), 0);
			FlowRemind = Util.null2String(rs.getString("FlowRemind"));
			MsgRemind = Util.null2String(rs.getString("MsgRemind"));
			MailRemind = Util.null2String(rs.getString("MailRemind"));
			ChatsRemind = Util.null2String(rs.getString("ChatsRemind"));
			InfoCentreRemind = Util.null2String(rs.getString("InfoCentreRemind"));
			CustomWorkflowid = Util.getIntValue(rs.getString("CustomWorkflowid"), 0);
			isnodeoperator = Util.null2String(rs.getString("isnodeoperator"));
			iscreater = Util.null2String(rs.getString("iscreater"));
			ismanager = Util.null2String(rs.getString("ismanager"));
			isother = Util.null2String(rs.getString("isother"));
			remindobjectids = Util.null2String(rs.getString("remindobjectids"));
		}
	}
	
	rs.executeSql("select * from workflow_nodelink where id=" + linkid);
	if(rs.next()) { // 如果之前设置了超时时间，则取之前设置的超时时间
		int selectnodepass_rs = Util.getIntValue(rs.getString("selectnodepass"), 1);
		int nodepasshour_rs = Util.getIntValue(rs.getString("nodepasshour"), 0);
		int nodepassminute_rs = Util.getIntValue(rs.getString("nodepassminute"), 0);
		String datefield_rs = Util.null2String(rs.getString("datefield")).trim();
		String timefield_rs = Util.null2String(rs.getString("timefield")).trim();
		
		if((selectnodepass_rs == 1 && (nodepasshour_rs > 0 || nodepassminute_rs > 0)) || (selectnodepass_rs == 2 && !"".equals(datefield_rs))) {
			selectnodepass = selectnodepass_rs;
			nodepasshour = nodepasshour_rs;
			nodepassminute = nodepassminute_rs;
			datefield = datefield_rs;
			timefield = timefield_rs;
		}else {
			haspasstime = "0";
		}
	}
	String remindobjectnames = OverTimeInfo.getResourceNameByResouceid(remindobjectids);
	
	String titlename = "";
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/xpSpin_wev8.css">
<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>
<style>
.shortw {
	width: 60px !important;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ", javascript:doSave(), _self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" onclick="doSave()" />
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<form id="overTimeSetForm" action="/workflow/workflow/nodelinkOverTimeOperate.jsp" method="post">
		<wea:layout type="2col">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>">
				<wea:item><%=SystemEnv.getHtmlLabelName(125613, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="text" name="remindname" id="remindname" class="Inputstyle" value="<%=remindname %>" maxlength="2000" onchange='checkinput("remindname", "remindnameSpan")' />
					<span id='remindnameSpan'></span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(785, user.getLanguage()) %></wea:item>
				<wea:item>
					<select name="remindtype" id="remindtype" onchange="changeRemindType()">
						<option value="0" <% if("0".equals(remindtype)) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(125615, user.getLanguage()) %></option>
						<option value="1" <% if("1".equals(remindtype)) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(125616, user.getLanguage()) %></option>
					</select>&nbsp;&nbsp;
					<input type="text" name="remindhour" id="remindhour" maxlength="3" class="shortw" value="<% if(remindhour > 0) { %><%=remindhour %><% } %>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);checkremindhour();if(this.value < 0) {this.value = "";}' />
					<%=SystemEnv.getHtmlLabelName(391, user.getLanguage()) %>&nbsp;&nbsp;
					<input type="text" name="remindminute" id="remindminute" maxlength="2" class="shortw spin height" value="<%=remindminute %>" onkeypress="ItemCount_KeyPress()" onblur="checkremindhour()" onchange="checkremindhour()" min="0" max="59" />
					<%=SystemEnv.getHtmlLabelName(15049, user.getLanguage()) %>
					<span id="remindTypeSpan" style="color: red; display: none; margin-left: 20px;"><%=SystemEnv.getHtmlLabelName(32453, user.getLanguage()) %></span>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(125672, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="checkbox" name="repeatremind" id="repeatremind" value="1" tzCheckbox="true" onclick="clickRepeatRemind(this, 'repeatAttributes')" <% if("1".equals(repeatremind)) { %> checked="checked" <% } %> /> 
				</wea:item>
				<%
					String repeatAttributes = "{'samePair':'repeatAttributes', 'display':'none'}";
					if("1".equals(repeatremind)) {
						repeatAttributes = "{'samePair':'repeatAttributes', 'display':''}";
					}
				%>
				<wea:item attributes="<%=repeatAttributes %>"><%=SystemEnv.getHtmlLabelName(125614, user.getLanguage()) %></wea:item>
				<wea:item attributes="<%=repeatAttributes %>">
					<input type="text" name="repeathour" id="repeathour" maxlength="3" class="shortw" value="<% if(repeathour > 0) { %><%=repeathour %><% } %>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);checkremindhour();if(this.value < 0) {this.value = "";}' />
					<%=SystemEnv.getHtmlLabelName(391, user.getLanguage()) %>&nbsp;&nbsp;
					<input type="text" name="repeatminute" id="repeatminute" maxlength="2" class="shortw spin height" value="<%=repeatminute %>" onkeypress="ItemCount_KeyPress()" onblur="checkremindhour()" onchange="checkremindhour()" min="0" max="59" />
					<%=SystemEnv.getHtmlLabelName(15049, user.getLanguage()) %> 
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(18713, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="checkbox" name="lowRemind" id="FlowRemind" value="1" <% if("1".equals(FlowRemind)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(32455, user.getLanguage()) %>&nbsp;&nbsp;
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(125949, user.getLanguage()) %>">
						<img src="/images/tooltip_wev8.png" align="absMiddle" />
					</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="MsgRemind" id="MsgRemind" value="1" <% if("1".equals(MsgRemind)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(17586, user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="MailRemind" id="MailRemind" value="1" <% if("1".equals(MailRemind)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(18845, user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="ChatsRemind" id="ChatsRemind" value="1" <% if("1".equals(ChatsRemind)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(126016, user.getLanguage()) %>
				</wea:item>
				<wea:item></wea:item>
				<wea:item>
					<span style="float: left;">
						<input type="checkbox" name="InfoCentreRemind" id="InfoCentreRemind" value="1" onclick="clickMustInput('InfoCentreRemind')" <% if("1".equals(InfoCentreRemind)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(32666, user.getLanguage()) %>&nbsp;&nbsp;
					</span>
					<brow:browser name="CustomWorkflowid" viewType="0" hasBrowser="true" hasAdd="false"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1"
						_callback="callbackMeth" isMustInput="2" isSingle="true" hasInput="true"
						linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid="
						completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0" width="200px" browserValue='<%=String.valueOf(CustomWorkflowid) %>' browserSpanValue='<%=WorkflowComInfo.getWorkflowname("" + CustomWorkflowid) %>' />
					<span style="margin-left: 15px;">
						<input type="hidden" name="InfoCentreRemind_old" id="InfoCentreRemind_old" value="<%=InfoCentreRemind %>" />
						<input type="hidden" name="CustomWorkflowid_old" id="CustomWorkflowid_old" value="<%=CustomWorkflowid %>" />
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(21845, user.getLanguage()) %>" class="e8_btn_top middle" style="border:1px solid #aecef1 !important;" onclick="clickAssign();" />
					</span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15793, user.getLanguage()) %></wea:item>
				<wea:item>
					<input type="checkbox" name="isnodeoperator" id="isnodeoperator" value="1" <% if("1".equals(isnodeoperator)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(18676, user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="iscreater" id="iscreater" value="1" <% if("1".equals(iscreater)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(882, user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="ismanager" id="ismanager" value="1" <% if("1".equals(ismanager)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(18677, user.getLanguage()) %>
				</wea:item>
				<wea:item></wea:item>
				<wea:item>
					<span style="float: left;">
						<input type="checkbox" name="isother" id="isother" value="1" onclick="clickMustInput('isother')" <% if("1".equals(isother)) { %> checked="checked" <% } %> /><%=SystemEnv.getHtmlLabelName(18846, user.getLanguage()) %>&nbsp;&nbsp;
					</span>
					<brow:browser name="remindobjectids" viewType="0" hasBrowser="true" hasAdd="false"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
						_callback="callbackMeth" isMustInput="2" isSingle="false" hasInput="true"
						completeUrl="/data.jsp" width="200px" browserValue='<%=remindobjectids %>' browserSpanValue='<%=remindobjectnames %>' />
				</wea:item>
			</wea:group>
		</wea:layout>	
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="<% if("1".equals(isAssign)) { %>parent.reloadWindow()<% }else { %>parent.closeDialog()<% } %>" />
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script type="text/javascript">
function changeRemindType() {
	var remindType = jQuery("#remindtype").val();
	if(remindType == 1) {
		jQuery("#remindTypeSpan").hide();
	}else {
		jQuery("#remindTypeSpan").show();
	}
}

function clickRepeatRemind(obj, trnames) {
    if(obj.checked) {
    	showEle(trnames);
    }else {
    	hideEle(trnames);
    }
}

function checkremindhour() {
	var remindtype = jQuery("#remindtype").val();
	if(remindtype == 0) { // 只验证超时前
		var rehour = jQuery("#remindhour").val();
		rehour = rehour == "" ? 0 : parseInt(rehour, 10);
		
		var nodehour = "<%=nodepasshour %>";
		nodehour = nodehour == "" ? 0 : parseInt(nodehour, 10);
		
		if(rehour < 0) {
			rehour = 0;
		}
		if(nodehour < 0) {
			nodehour = 0;
		}
		
		var selectnodetype = "<%=selectnodepass %>";
		
		if(rehour > nodehour && selectnodetype != '2') {
			jQuery("#remindhour").val("");
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18854, user.getLanguage()) %>");
			jQuery("#remindhour").focus();
			return false;
		}else {
			if(rehour == nodehour && parseInt(jQuery("#remindminute").val(), 10) > parseInt("<%=nodepassminute %>", 10) && selectnodetype != '2') {
				jQuery("#remindminute").val("<%=nodepassminute %>");
				jQuery("#remindminute").focus();
				return false;
			}
		}
	}
	return true;
}

function callbackMeth(event, datas, name, paras) {
	if(datas.id != "") {
		setChecked(name, true);
	}else {
		setChecked(name, false);
	}
}

function setChecked(name, checked) {
	var obj;
	if(name == "CustomWorkflowid") {
		obj = jQuery("#InfoCentreRemind");
		obj.attr("checked", checked);
		clickMustInput("InfoCentreRemind");
	}else if(name == "remindobjectids") {
		obj = jQuery("#isother");
		obj.attr("checked", checked);
		clickMustInput("isother");
	}
	if(obj) {
		if(checked) {
			obj.next().addClass("jNiceChecked");
		}else {
			obj.next().removeClass("jNiceChecked");
		}
	}
}

function doSave(isAssign) {
	if(check_form(overTimeSetForm, "remindname")) {
		var remindhour = jQuery("#remindhour").val();
		remindhour = remindhour == "" ? 0 : parseInt(remindhour, 10);
		if(remindhour < 0) {
			remindhour = 0;
		}
		var remindminute = jQuery("#remindminute").val();
		remindminute = remindminute == "" ? 0 : parseInt(remindminute, 10);
		if(remindminute < 0) {
			remindminute = 0;
		}
		if(remindhour == 0 && remindminute == 0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125669, user.getLanguage()) %>");
			return false;
		}

		var repeatremind = jQuery("#repeatremind").attr("checked") ? 1 : 0;
		var repeathour = jQuery("#repeathour").val();
		repeathour = repeathour == "" ? 0 : parseInt(repeathour, 10);
		if(repeathour < 0) {
			repeathour = 0;
		}
		var repeatminute = jQuery("#repeatminute").val();
		repeatminute = repeatminute == "" ? 0 : parseInt(repeatminute, 10);
		if(repeatminute < 0) {
			repeatminute = 0;
		}
		if(repeatremind == 1) { // 验证重复提醒周期
			if(repeathour == 0 && repeatminute == 0) {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125670, user.getLanguage()) %>");
				return false;
			}
		}else {
			repeathour = 0;
			repeatminute = 0;
		}
		
		var FlowRemind = jQuery("#FlowRemind").attr("checked") ? 1 : 0;
		var MsgRemind = jQuery("#MsgRemind").attr("checked") ? 1 : 0;
		var MailRemind = jQuery("#MailRemind").attr("checked") ? 1 : 0;
		var ChatsRemind = jQuery("#ChatsRemind").attr("checked") ? 1 : 0;
		var InfoCentreRemind = jQuery("#InfoCentreRemind").attr("checked") ? 1 : 0;
		var CustomWorkflowid = jQuery("#CustomWorkflowid").val();
		var CustomWorkflowid_old = jQuery("#CustomWorkflowid_old").val();
		if((FlowRemind == 0 && MsgRemind == 0 && MailRemind == 0 && ChatsRemind == 0 && InfoCentreRemind == 0)) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18867, user.getLanguage()) %>");
			return false;
		}
		if((InfoCentreRemind == 1 && CustomWorkflowid == 0)) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125883, user.getLanguage()) %>");
			return false;
		}
		if(InfoCentreRemind == 0) {
			CustomWorkflowid = 0;
		}

		var isnodeoperator = jQuery("#isnodeoperator").attr("checked") ? 1 : 0;
		var iscreater = jQuery("#iscreater").attr("checked") ? 1 : 0;
		var ismanager = jQuery("#ismanager").attr("checked") ? 1 : 0;
		var isother = jQuery("#isother").attr("checked") ? 1 : 0;
		var remindobjectid = jQuery("#remindobjectids").val();
		if((isnodeoperator == 0 && iscreater == 0 && ismanager == 0 && isother == 0)) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18868, user.getLanguage()) %>");
			return false;
		}
		if(isother == 1 && remindobjectid == "") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125884, user.getLanguage()) %>");
			return false;
		}
		if(isother == 0) {
			remindobjectid = "";
		}

		var remindtype = jQuery("#remindtype").val();
		if(remindtype == 1 || (remindtype == 0 && checkremindhour())) {
			enableAllmenu();
			var _data = "id=<%=id %>"+
			"&operate=<%=operate %>"+
			"&haspasstime=<%=haspasstime %>"+
			"&linkid=<%=linkid %>"+
			"&workflowid=<%=workflowid %>"+
			"&selectnodepass=<%=selectnodepass %>"+
			"&nodepasshour=<%=nodepasshour %>"+
			"&nodepassminute=<%=nodepassminute %>"+
			"&datefield=<%=datefield %>"+
			"&timefield=<%=timefield %>"+
			"&remindname="+jQuery("#remindname").val()+
			"&remindtype="+remindtype+
			"&remindhour="+remindhour+
			"&remindminute="+remindminute+
			"&repeatremind="+repeatremind+
			"&repeathour="+repeathour+
			"&repeatminute="+repeatminute+
			"&FlowRemind="+FlowRemind+
			"&MsgRemind="+MsgRemind+
			"&MailRemind="+MailRemind+
			"&ChatsRemind="+ChatsRemind+
			"&InfoCentreRemind="+InfoCentreRemind+
			"&CustomWorkflowid="+CustomWorkflowid+
			"&CustomWorkflowid_old="+CustomWorkflowid_old+
			"&isnodeoperator="+isnodeoperator+
			"&iscreater="+iscreater+
			"&ismanager="+ismanager+
			"&isother="+isother+
			"&remindobjectids="+remindobjectid;
			jQuery.ajax({
				type: "POST",
				url: "/workflow/workflow/nodelinkOverTimeOperate.jsp",
				data: _data,
				async: false,
				success: function(data) {
					if(1 == isAssign) { // 点击赋值设置进入
						location.href = "/workflow/workflow/nodelinkOverTimeEdit.jsp?isAssign=1&id=" + data;
					}else {
					parent.reloadWindow();
					}
				}
			});
		}
		return false;
	}
	return false;
}

function clickAssign() {
	setChecked("CustomWorkflowid", true);
	var CustomWorkflowid = jQuery("#CustomWorkflowid").val();
	if(CustomWorkflowid <= 0) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125883, user.getLanguage()) %>");
		return;
	}
	if(CustomWorkflowid != jQuery("#CustomWorkflowid_old").val() || jQuery("#InfoCentreRemind_old").val() != 1) {
		if(!doSave(1)) {
			return;
		}
	}

	var url = "/workflow/workflow/nodelinkOverTimeEditField.jsp?id=<%=id %>";
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21845, user.getLanguage()) %>";
	dialog.Width = 700;
	dialog.Height = 650;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}

jQuery(document).ready(function() {
	jQuery(".spin").each(function() {
		var $this = jQuery(this);
		var min = $this.attr("min");
		var max = $this.attr("max");
		$this.spin({
			max : max,
			min : min
		});
		$this.blur(function() {
			var value = $this.val();
			if(isNaN(value)) {
				$this.val(0);
			}else {
				value = parseInt(value, 10);
				if(value > 59) {
					$this.val(59);
				}else if(value < 0) {
					$this.val(0);
				}else {
					$this.val(value); 
				}
				if($this.val() == 'NaN') {
					$this.val(0);
				}
			}
		});
	});
	changeRemindType();
	clickMustInput("InfoCentreRemind");
	clickMustInput("isother");
	<% if("1".equals(isAssign)) { %>
		clickAssign();
	<% } %>
});

function clickMustInput(name) {
	var span = "";
	if(name == "InfoCentreRemind") {
		span = "CustomWorkflowidspanimg";
	}else if(name == "isother") {
		span = "remindobjectidsspanimg";
	}

	if(span != "") {
		if(jQuery("#" + name).attr("checked")) {
			jQuery("#" + span).show();
		}else {
			jQuery("#" + span).hide();
		}
	}
}
</script>
</html>
