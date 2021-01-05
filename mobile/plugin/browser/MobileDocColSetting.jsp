
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />

<%@ include file="MobileInit.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
String module = fu.getParameter("module");
String scope = fu.getParameter("moduleid");
String modulename = fu.getParameter("modulename");
String selectids = fu.getParameter("selectids");
List<Map<String,Object>> columnlist = ps.parseDocSetting(selectids, modulename, true);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type='text/javascript' src='/js/jquery/jquery.js'></script>
<style>
	body {
	  background-color: #F9F9F9;
	  font-family: "微软雅黑", Arial, Helvetica, sans-serif;
	  font-size: 14px;
	  padding: 0;
	  margin: 5;
	}
	table {
	  width: 100%;
	  border: none;
	}
	th {
	  background-color: #EEF1F9;
	  padding: 10px;
	  text-align: left;
	  border-bottom: solid 1px #D6DCE8;
	  font-size: 14px;
	}
	tr {
	  background-color: #FFFFFF;
	}
	td {
	  padding: 2px 10px;
	  border-top: solid 1px #E9ECF3;
	  color: #757F87;
	  height: 50px;
	  line-height: 50px;
	}
	
	table input.name,table select {
	  width:120px;
	}
	
	table input.index {
	  width: 60px;
	}
	
	td img {
	  margin-bottom: -20px;
	  width:50px;
	  height:50px;
	}
	
	input[type=text],select {
	  border: solid 1px #E3E3E3;
	  padding-left: 5px;
	}
	
	.required {
	  color: #EFBC44;
	}
	
	button.modedit {
	  width:32px;
	  height:32px;
	  padding: 0;
	  border: 0;
	  cursor: pointer;
	  background-color: transparent;
	  background-position: center;
	  float: left;
	}
	
	button.setting {
	  background-image: url('/images/manager/V50/setting.png');
	  background-repeat: no-repeat;
	  margin-left: 15px;
	}
	
	button.setting:hover {
	  background-image: url('/images/manager/V50/setting-hover.png');
	  background-repeat: no-repeat;
	}
	
	button.delmodule {
	  background-image: url('/images/manager/V50/del-3.png');
	  background-repeat: no-repeat;
	  display: none;
	}
	
	button.delmodule:hover {
	  background-image: url('/images/manager/V50/del-3-hover.png');
	  background-repeat: no-repeat;
	}
	
	div#addmodule {
	  height: 45px;
	  line-height: 45px;
	  border: dotted 2px #DFDFDF;
	  padding-right: 20px;
	  text-align: right;
	  color: #B9B9B9;
	  cursor: pointer;
	}
	
	div#addmodule:hover {
	  color: #0090FF;
	}
	
	.numberonly {
	  padding-right: 5px;
	  padding-left: 0 !important;
	  text-align: right;
	}
	
	input[name=moduleLabel] {
		width: 120px;
	}
	
	input[name=showOrder] {
		width: 43px;
		margin-left: 10px;
	}
	
	button.ok {
	  color:#FFFFFF;
	  background-color: #B4C1DA;
	  border-radius: 3px;
	  border: none;
	  padding: 0 19px;
	  cursor: pointer;
	  height: 33px;
	  line-height: 33px;
	}
	
	button.cancel {
	  color:#FFFFFF;
	  background-color: #BFC5CD;
	  border-radius: 3px;
	  border: none;
	  padding: 7px 19px;
	  cursor: pointer;
	  line-height: normal;
	}
</style>
<script type="text/javascript">
	var cnt=0;
	var settingDialog = void 0;
	
	function openSettingDialog(columnid) {
		if (settingDialog) {
			settingDialog.close();
		};
		settingDialog = window.open("/mobile/plugin/browser/MobileDocColBrowser.jsp?columnid="+columnid, "", "width=560px,height=580px,resizable=no,scroll=no,status=no,top=" + (window.screen.availHeight - 580)/2 + ",left=" + (window.screen.availWidth - 560)/2);
	}

	function delModule(_this){
		if(!window.confirm("确认删除模块？")) return;
		$(_this).parents("tr:first").remove();
	}

	$(document).ready(function() {
		$("#save").click(function() {
			var required = true;
			var settings = "";
			$("table tr:has(td)").each(function(){
				if(!required) return;
				var name = $.trim($(this).find("input[name=moduleLabel]").val());
				var showOrder = parseInt($(this).find("input[name=showOrder]").val());
				var source = $(this).find("input[name=source]").val();
				var docids = $(this).find("input[name=docids]").val();
				var isreplay = $(this).find("input[name=isreplay]").val();
				if(name=="") {
					alert("请输入版块名称！");
					$(this).find("input[name=moduleLabel]").focus();
					required = false;
					return;
				}
				if(isNaN(showOrder)) {
					alert("请输入显示顺序！");
					$(this).find("input[name=showOrder]").focus();
					required = false;
					return;
				}
				settings += "#"+encodeURIComponent(name)+"|"+showOrder+"|"+source+"|"+docids+"|"+isreplay;//版块名|显示顺序|文档来源|所选id|是否包含回复
			});
			
			if(required) {
				settings = (settings == "") ? "" : "@"+settings.substring(1);
				window.parent.closeModalDialog(settings);
			}
		});

		$("#cancel").click(function() {
			window.parent.closeModalDialog();
		});

		$("#moduleList tr").hover(function(){
			$(this).find(".delmodule").show();
		}, function(){
			$(this).find(".delmodule").hide();
		});

		$("#addmodule").click(function() {
			cnt++;
			var htmltr = "<tr columnid='new"+cnt+"'>"
				+"<td><input name='moduleLabel' class='moduleLabel' type='text' value=''></td>"
				+"<td><input type='text' value='' name='showOrder' size='3' maxlength='3' class='numberonly'></td>"
				+"<td class='toolbtn'>"
				+"<button type='button' class='modedit setting' onclick='openSettingDialog(\"new"+cnt+"\")' title='设置'></button>"
				+"<input type='hidden' name='source' value=''>"
				+"<input type='hidden' name='docids' value=''>"
				+"<input type='hidden' name='docnames' value=''>"
				+"<input type='hidden' name='isreplay' value=''>"
				+"</td>"
				+"<td><button type='button' class='modedit delmodule' onclick='delModule(this)' title='删除'></button></td>"
				+"</tr>";

			var newtr = $(htmltr).appendTo($("#moduleList")).hover(function(){
				$(this).find(".delmodule").show();
			}, function(){
				$(this).find(".delmodule").hide();
			});

			newtr.find(".numberonly").keypress(function(event) {
				var keyCode = event.which;
				return ((keyCode >= 48 && keyCode <= 57) || keyCode == 8);//8是删除键
			}).keyup(function(){
				if(typeof this.value == "undefined") return;
				this.value = this.value.replace(/\D/g, "");
			}).bind("paste", function(){
				return false;
			});

			newtr.find("input[name='moduleLabel']").focus();
		}).hover(function(){
			$(this).find("img").attr("src", "/images/manager/V50/plus-small-hover.png");
		}, function(){
			$(this).find("img").attr("src", "/images/manager/V50/plus-small.png");
		});
	});
</script>
</head>
<body>
	<div style="color:#A6A6A6;margin:5px">栏目列表</div>
	<table id="moduleList" cellspacing="0" cellpadding="0">
		<tr>
			<th>版块名称<span class="required">[必填]<span></th>
			<th>显示顺序<span class="required">[必填]<span></th>
			<th>文档来源</th>
			<th style="width:32px;">&nbsp;</th>
		</tr>
		<%
		for(int i=0; i<columnlist.size(); i++) {
			Map<String, Object> column = columnlist.get(i);
			List docidlist = (List)column.get("docids");
			String docids = StringUtils.trimToEmpty(StringUtils.join(docidlist, ","));
			List docnamelist = (List)column.get("docnames");
			String docnames = StringUtils.trimToEmpty(StringUtils.join(docnamelist, "&nbsp;"));
			%>
		<tr columnid="<%=i %>">
			<td><input name="moduleLabel" class="moduleLabel" type="text" value="<%=column.get("name") %>"></td>
			<td><input type="text" value="<%=column.get("showOrder") %>" name="showOrder" size="3" maxlength="3" class="numberonly"></td>
			<td class="toolbtn">
				<button type="button" class="modedit setting" onclick='openSettingDialog("<%=i %>")' title="设置"></button>
				<input type="hidden" name="source" value="<%=column.get("source") %>">
				<input type="hidden" name="docids" value="<%=docids %>">
				<input type="hidden" name="docnames" value="<%=docnames %>">
				<input type="hidden" name="isreplay" value="<%=column.get("isreplay") %>">
			</td>
			<td><button type="button" class="modedit delmodule" onclick="delModule(this)" title="删除"></button></td>
		</tr>
			<%
		}
		%>
	</table>
	<div id="addmodule"><img src="/images/manager/V50/plus-small.png" style="margin-bottom: -2px;" />&nbsp;&nbsp;添加栏目</div>
	<div style="margin-top: 30px;text-align:center;">
		<button type="button" id="save" class="ok" style="background-color: #3F8EF1">确定</button>
		<button type="button" id="cancel" class="cancel" style="margin-left: 10px;">取消</button>
	</div>
</body>
</html>