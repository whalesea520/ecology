
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.conn.*"%>
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
FileUpload fu = new FileUpload(request);

String pluginCode = Util.null2String(fu.getParameter("pluginCode"));

int hrmorder = 0;
int isShowTerminal = 1;
int wfscope = 0;
int hrmbtnshow = 1;
StringBuffer wfids = new StringBuffer();
StringBuffer wfnames = new StringBuffer();
int hrmorgbtnshow = 0;
int allPeopleshow = 0;
int mysubordinateshow = 0;
int sameDepartment = 0;
int commonGroup = 0;
int groupChat = 0;
int UntreatedFirst = 0;
int isUsingCA = 0;
String caServerAddress = "";
int caUsageMode = 0;
int androidsign = 0;
int iossign = 0;
String androidkey = "";
String ioskey = "";
String iosWpskey = "";
int encryptpassword = 0;

RecordSet rs = new RecordSet();
rs.executeSql("select * from mobileProperty");
while(rs.next()){
	String name = rs.getString("name");
	String propValue = rs.getString("propValue");
	
	if("hrmorder".equals(name)) hrmorder = Util.getIntValue(propValue, 0);
	if("isShowTerminal".equals(name)) isShowTerminal = Util.getIntValue(propValue, 0);
	if("wfscope".equals(name)) wfscope = Util.getIntValue(propValue, 0);
	if("wfid".equals(name)) {
		int wfid = Util.getIntValue(propValue, 0);
		if(wfid > 0) {
			wfids.append(","+wfid);
			wfnames.append(","+workflowComInfo.getWorkflowname(""+wfid));
		}
	}
	if("hrmorgbtnshow".equals(name)) hrmorgbtnshow = Util.getIntValue(propValue, 0);
	if("allPeopleshow".equals(name)) allPeopleshow = Util.getIntValue(propValue, 0);
	if("sameDepartment".equals(name)) sameDepartment = Util.getIntValue(propValue, 0);
	if("commonGroup".equals(name)) commonGroup = Util.getIntValue(propValue, 0);
	if("groupChat".equals(name)) groupChat = Util.getIntValue(propValue, 0);
	if("mysubordinateshow".equals(name)) mysubordinateshow = Util.getIntValue(propValue, 0);
	if("UntreatedFirst".equals(name)) UntreatedFirst = Util.getIntValue(propValue, 0);
	if("isUsingCA".equals(name)) isUsingCA = Util.getIntValue(propValue, 0);
	if("caServerAddress".equals(name)) caServerAddress = propValue;
	if("caUsageMode".equals(name)) caUsageMode = Util.getIntValue(propValue, 0);
	if("androidsign".equals(name)) androidsign = Util.getIntValue(propValue, 0);
	if("iossign".equals(name)) iossign = Util.getIntValue(propValue, 0);
	if("androidkey".equals(name)) androidkey = propValue;
	if("ioskey".equals(name)) ioskey = propValue;
	if("iosWpskey".equals(name)) iosWpskey = propValue;
	if("encryptpassword".equals(name)) encryptpassword = Util.getIntValue(propValue, 0);
}

if(wfids.length() > 0) wfids.deleteCharAt(0);
if(wfnames.length() > 0) wfnames.deleteCharAt(0);
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
	<title>插件设置</title>
	<style>
		*{
			font-size:12px;
			font-family:"微软雅黑";
		}
		
		table td{
			background-color:#FFFFFF;
			font-size: 12px;
			color: #707070;
			height:24px;
			padding:5px;
			border-bottom: solid 1px #E9ECF3;
		}

		input[type=submit] {
			color: #FFFFFF;
			background-color: #3F8EF1;
			border-radius: 3px;
			border: none;
			padding: 0 19px;
			cursor: pointer;
			height: 33px;
			line-height: 33px;
			outline: none;
		}

		div#wfbtn {
			background-image: url('/mobile/plugin/images/setting_wev8.png');
			background-repeat: no-repeat;
			width: 32px;
			height: 32px;
			cursor: pointer;
			float:left;
			margin:0 2px;
		}

		div#wfbtn:hover {
			background-image: url('/mobile/plugin/images/setting-hover_wev8.png');
			background-repeat: no-repeat;
		}

		div#hrmorgbtn {
			background-image: url('/mobile/plugin/images/setting_wev8.png');
			background-repeat: no-repeat;
			width: 32px;
			height: 32px;
			cursor: pointer;
			float:left;
			margin:0 2px;
		}

		div#hrmorgbtn:hover {
			background-image: url('/mobile/plugin/images/setting-hover_wev8.png');
			background-repeat: no-repeat;
		}
		div#androidsignbtn {
			background-image: url('/mobile/plugin/images/setting_wev8.png');
			background-repeat: no-repeat;
			width: 32px;
			height: 32px;
			cursor: pointer;
			float:left;
			margin:0 2px;
		}
		div#iossignbtn {
			background-image: url('/mobile/plugin/images/setting_wev8.png');
			background-repeat: no-repeat;
			width: 32px;
			height: 32px;
			cursor: pointer;
			float:left;
			margin:0 2px;
		}
	</style>
	<script>
		var childWindow = void 0;
		$(document).ready(function() {
			$("#wfscope").change(function() {
				var type = $(this).val();
				if(type==0) {
					$("#wfbtn").hide();
					$("#wfname").hide();
				} else {
					$("#wfbtn").show();
					$("#wfname").show();
				}
			});

			$("#wfbtn").click(function() {
				if (childWindow) {
					childWindow.close();
					childWindow = void 0;
				};
				childWindow = window.open("/mobile/plugin/browser/AttrWorkflowBrowser.jsp?pluginCode=<%=pluginCode %>", "", "width=560px,height=580px,resizable=no,scroll=no,status=no,top=" + (window.screen.availHeight - 580)/2 + ",left=" + (window.screen.availWidth - 560)/2);
			});

			$("#hrmorgbtn").click(function() {
				if (childWindow) {
					childWindow.close();
					childWindow = void 0;
				};
				childWindow = window.open("/manager/userOrgAuthList.do", "", "width=560px,height=580px,resizable=no,scroll=no,status=no,top=" + (window.screen.availHeight - 580)/2 + ",left=" + (window.screen.availWidth - 560)/2);
			});
			$("#androidsignbtn").click(function() {
				if (childWindow) {
					childWindow.close();
					childWindow = void 0;
				};
				childWindow = window.open("/manager/mobileSign.do", "", "width=560px,height=580px,resizable=no,scroll=no,status=no,top=" + (window.screen.availHeight - 580)/2 + ",left=" + (window.screen.availWidth - 560)/2);
			});
			$("#iossignbtn").click(function() {
				if (childWindow) {
					childWindow.close();
					childWindow = void 0;
				};
				childWindow = window.open("/manager/mobileSign.do", "", "width=560px,height=580px,resizable=no,scroll=no,status=no,top=" + (window.screen.availHeight - 580)/2 + ",left=" + (window.screen.availWidth - 560)/2);
			});
			$("#hrmorgbtnshow").change(function() {
				var type = $(this).val();
				if(type==2) {
					$("#hrmorgbtn").show();
					$("#hrmorgname").show();
				} else {
					$("#hrmorgbtn").hide();
					$("#hrmorgname").hide();
				}
			});
			$("#androidsign").change(function() {
				var type = $(this).val();
				if(type==2) {
					$("#androidkey").show();
					$("#androidsignbtn").show();
				} else {
					$("#androidkey").hide();
					$("#androidsignbtn").hide();
				}
			});
			$("#iossign").change(function() {
				var type = $(this).val();
				if(type==1) {
					$("#iosWpskey").show();
					$("#ioskeySpan").show();
					$("#iosWpskeySpan").show();
					$("#ioskey").show();
					$("#iossignbtn").show();
				} else {
					$("#iosWpskey").hide();
					$("#ioskeySpan").hide();
					$("#iosWpskeySpan").hide();
					$("#ioskey").hide();
					$("#iossignbtn").hide();
				}
			});
			$("#isUsingCA").change(function() {
				var useCa = $(this).val();
				if(useCa==1) {
					$("#isUsingCA1").show();
					$("#isUsingCA2").show();
					$("#isUsingCA3").show();
				} else {
					$("#isUsingCA1").hide();
					$("#isUsingCA2").hide();
					$("#isUsingCA3").hide();
				}
			});
			var isca = $("#isUsingCA").val();
			if(isca == 1){
				$("#isUsingCA1").show();
				$("#isUsingCA2").show();
				$("#isUsingCA3").show();
			}
		});
		function checkform(){
			var isuca = $("#isUsingCA").val();
			if(isuca == 1){
				var casadd = $("#caServerAddress").val();
				if(casadd == ""){
					alert ("CA服务器地址为空，请填写完整！" + $("#caServerAddress").val());
					$("#caServerAddress").focus();
					return false;
				}
			}
			return true;
		}
	</script>
</head>
<body class="page">
	<form id="attrForm" action="/mobile/plugin/attrOprate.jsp?pluginCode=<%=pluginCode %>" method="post" onsubmit="return checkform();">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20%">
					<label>人员显示顺序</label>
				</td>
				<td>
					<select name="hrmorder">
						<option value="0"<%if(hrmorder==0){%> selected<%}%>>人力资源显示顺序</option>
						<option value="1"<%if(hrmorder==1){%> selected<%}%>>人员姓氏首字母</option>
						<option value="2"<%if(hrmorder==2){%> selected<%}%>>人员ID</option>
					</select>
				</td>
				<td width="20%">
					<label>浏览人员时是否显示同部门</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="sameDepartment"  id="sameDepartment">
							<option value="0"<%if(sameDepartment==0){%> selected<%}%>>显示</option>
							<option value="1"<%if(sameDepartment==1){%> selected<%}%>>不显示</option>
						</select>
					</div>
				</td>
		  	</tr>
		  	<tr>
				<td width="20%" style="vertical-align: top;padding-top: 14px;">
					<label>新建流程可用范围</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select id="wfscope" name="wfscope">
							<option value="0"<%if(wfscope==0){%> selected<%}%>>全部</option>
							<option value="1"<%if(wfscope==1){%> selected<%}%>>选择</option>
							<option value="2"<%if(wfscope==2){%> selected<%}%>>排除选择</option>
						</select>
					</div>
					<div id="wfbtn" title="设置"<%if(wfscope==0){%> style="display:none"<%}%>>
					</div>
					<div id="wfname" style="padding-left: 115px;padding-top: 8px;<%if(wfscope==0){%>display:none<%}%>"><%=wfnames%></div>
					<input type="hidden" id="wfids" name="wfids" value="<%=wfids%>">
				</td>
				<td width="20%">
					<label>浏览人员时是否显示所有人</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="allPeopleshow"  id="allPeopleshow">
							<option value="0"<%if(allPeopleshow==0){%> selected<%}%>>显示</option>
							<option value="1"<%if(allPeopleshow==1){%> selected<%}%>>不显示</option>
						</select>
					</div>
				</td>
		  	</tr>
			<tr>
				<td width="20%">
					<label>人力资源浏览优先显示项(客户端)</label>
				</td>
				<td>
					<select name="hrmbtnshow">
						<option value="0"<%if(hrmbtnshow==0){%> selected<%}%>>所有人</option>
						<option value="1"<%if(hrmbtnshow==1){%> selected<%}%>>常用组</option>
						<option value="2"<%if(hrmbtnshow==2){%> selected<%}%>>组织架构</option>
					</select>
				</td>
				<td width="20%">
					<label>浏览人员时是否显示组织</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="hrmorgbtnshow"  id="hrmorgbtnshow">
							<option value="0"<%if(hrmorgbtnshow==0){%> selected<%}%>>显示</option>
							<option value="1"<%if(hrmorgbtnshow==1){%> selected<%}%>>不显示</option>
							<option value="2"<%if(hrmorgbtnshow==2){%> selected<%}%>>指定范围人员可见</option>
						</select>
					</div>
					<div id="hrmorgbtn" title="设置">
				</td>
			</tr>
			<tr>
				<td width="20%">
					<label>客户端流程消息列表优先显示</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="UntreatedFirst"  id="UntreatedFirst">
							<option value="0"<%if(UntreatedFirst==0){%> selected<%}%>>全部</option>
							<option value="1"<%if(UntreatedFirst==1){%> selected<%}%>>未处理</option>
						</select>
					</div>
				</td>
				<td width="20%">
					<label>浏览人员时是否显示我的下属</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="mysubordinateshow"  id="mysubordinateshow">
							<option value="0"<%if(mysubordinateshow==0){%> selected<%}%>>显示</option>
							<option value="1"<%if(mysubordinateshow==1){%> selected<%}%>>不显示</option>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<td width="20%">
					<label>是否显示签字意见来源</label>
				</td>
				<td>
					<select name="isShowTerminal">
						<option value="1"<%if(isShowTerminal==1){%> selected<%}%>>显示</option>
						<option value="0"<%if(isShowTerminal==0){%> selected<%}%>>不显示</option>
					</select>
				</td>
				<td width="20%">
					<label>浏览人员时是否显示常用组</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="commonGroup"  id="commonGroup">
							<option value="0"<%if(commonGroup==0){%> selected<%}%>>显示</option>
							<option value="1"<%if(commonGroup==1){%> selected<%}%>>不显示</option>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<td width="20%">
					<label>浏览人员时是否显示群聊</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="groupChat"  id="groupChat">
							<option value="0"<%if(groupChat==0){%> selected<%}%>>显示</option>
							<option value="1"<%if(groupChat==1){%> selected<%}%>>不显示</option>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<td width="20%">
					<label>是否启用CA集成</label>
				</td>
				<td>
					<select name="isUsingCA" id="isUsingCA">
						<option value="0"<%if(isUsingCA==0){%> selected<%}%>>否</option>
						<option value="1"<%if(isUsingCA==1){%> selected<%}%>>是</option>
					</select>
				</td>
				<td width="20%" id="isUsingCA1" style="display:none;">
					<label>CA服务器地址</label>
				</td>
				<td id="isUsingCA2" style="display:none;">
					<div style="float:left;padding-top: 5px;">
						<input style="width:215px;" type="text" id="caServerAddress" name="caServerAddress" value="<%=caServerAddress%>">
					</div>
				</td>
			</tr>
			<tr>
				<td width="20%">
					<label>Android签批启用方式</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="androidsign"  id="androidsign">
							<option value="0"<%if(androidsign==0){%> selected<%}%>>WPS</option>
							<option value="1"<%if(androidsign==1){%> selected<%}%>>永中office</option>
							<option value="2"<%if(androidsign==2){%> selected<%}%>>金格office</option>
						</select>
						<input type="text"   style="<%if(androidsign!=2){%>display:none<%}%>" value="<%=androidkey%>" id="androidkey" name="androidkey">
					</div>
					<div id="androidsignbtn" style="<%if(androidsign!=2){%>display:none<%}%>" title="设置">
				</td>
				<td width="20%">
					<label>IOS签批启用方式</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="iossign"  id="iossign">
							<option value="0"<%if(iossign==0){%> selected<%}%>>默认</option>
							<option value="1"<%if(iossign==1){%> selected<%}%>>金格office</option>
						</select>
						&nbsp;&nbsp;<span id="ioskeySpan" style="<%if(iossign!=1){%>display:none<%}%>">金格：</span><input type="text"    style="<%if(iossign!=1){%>display:none<%}%>"   value="<%=ioskey%>" id="ioskey" name="ioskey">
						&nbsp;&nbsp;<span id="iosWpskeySpan" style="<%if(iossign!=1){%>display:none<%}%>">WPS：</span><input type="text"    style="<%if(iossign!=1){%>display:none<%}%>"   value="<%=iosWpskey%>" id="iosWpskey" name="iosWpskey">
					</div>
					<div id="iossignbtn"      style="<%if(iossign!=1){%>display:none<%}%>"   value="<%=ioskey%>" title="设置">
				</td>
			</tr>
			<tr>
				<td width="20%">
					<label>客户端密码传输加密</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="encryptpassword"  id="encryptpassword">
							<option value="0"<%if(encryptpassword==0){%> selected<%}%>>不加密</option>
							<option value="1"<%if(encryptpassword==1){%> selected<%}%>>加密</option>
						</select>
					</div>
				</td>
			</tr>
			<tr id="isUsingCA3" style="display:none;">
				<td width="20%">
					<label>CA帐号使用方式</label>
				</td>
				<td>
					<div style="float:left;padding-top: 5px;">
						<select name="caUsageMode"  id="caUsageMode">
							<option value="0"<%if(caUsageMode ==0){%> selected<%}%>>使用用户的OA账号和密码</option>
							<option value="1"<%if(caUsageMode ==1){%> selected<%}%>>由终端用户输入账号和密码</option>
						</select>
					</div>
				</td>
			</tr>
		</table>
		<div style="text-align: center;margin-top: 10px;"><input type="submit" value="保存"></div>
	</form>
</body>
</html>