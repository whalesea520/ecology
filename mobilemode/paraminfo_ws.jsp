<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%@page import="com.weaver.formmodel.mobile.ws.ParameterManager"%>
<%@page import="com.weaver.formmodel.mobile.ws.type.ParameterType"%>
<%
String paramName = Util.null2String(request.getParameter("paramName"));
String paramType = Util.null2String(request.getParameter("paramType"));
String paramValue = Util.null2String(request.getParameter("paramValue"));
String desc = Util.null2String(request.getParameter("desc"));
String isEncrypt = Util.null2String(request.getParameter("isEncrypt"));
%>
<html>
<head>
	<title></title>
<style>
*{
	font-family: Microsoft YaHei;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
	
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: middle;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 5px 5px 10px;
	color: #666;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
.valueHolder{
	background-color: rgb(93, 156, 236);
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	font-family: Microsoft YaHei;
	font-size: 11px;
	height: 24px;
	line-height: 24px;
	padding-bottom: 0px;
	padding-left: 6px;
	padding-right: 6px;
	padding-top: 0px;
	margin-right:6px; 
	margin-bottom: 6px;
}
.textStyle{
	border: 1px solid #ccc;
	height: 20px;
	width:90%;
	font-size: 12px;
	padding-left: 5px;
}
.textareaStyle{
	border: 1px solid #ccc;
	width: 90%;
	height: 60px;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 14px;
	overflow: auto;
	padding-left: 5px;
	padding-top: 3px;
}
.selectStyle{
	border: 1px solid #ccc;
}
#warn-info{
	background-color: #F699B4;	
	border-bottom-color: rgba(0, 0, 0, 0);
	border-bottom-left-radius: 4px;
	border-bottom-right-radius: 4px;
	border-bottom-style: solid;
	border-bottom-width: 1px;
	border-image-outset: 0px;
	border-image-repeat: stretch;
	border-image-slice: 100%;
	border-image-source: none;
	border-image-width: 1;
	border-left-color: rgba(0, 0, 0, 0);
	border-left-style: solid;
	border-left-width: 1px;
	border-right-color: rgba(0, 0, 0, 0);
	border-right-style: solid;
	border-right-width: 1px;
	border-top-color: rgba(0, 0, 0, 0);
	border-top-left-radius: 4px;
	border-top-right-radius: 4px;
	border-top-style: solid;
	border-top-width: 1px;
	box-sizing: border-box;
	color: rgb(255, 255, 255);
	font-family: 'Microsoft Yahei', Arial, sans-serif;
	font-size: 12px;
	height: 30px;
	left: 60px;
	line-height: 30px;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 0px;
	position: absolute;
	text-align: center;
	top: 3px;
	vertical-align: middle;
	width: 302px;
	z-index: 1000;
	zoom: 1;	
	display: none;
}
.jNiceCheckbox{
	margin-bottom: -1px;	
}
</style>

<script type="text/javascript">
$(function() {
	$(".valueHolder").click(function(){
		var valueTemplate = $(this).attr("valueTemplate");
		var $paramValue = $("#paramValue");
		if(valueTemplate && valueTemplate != ""){
			//$paramValue[0].value = valueTemplate;
			insertText($paramValue[0], valueTemplate);
			//$("#desc")[0].value = $(this).text();
		}else{
			var valueType = $(this).attr("valueType");
			if(valueType == "param"){
				var pmV = window.prompt("<%=SystemEnv.getHtmlLabelName(127626,user.getLanguage())%>","");  //请输入要获取的参数名称
				if(pmV != null && pmV != ""){
					//$paramValue[0].value = "param(\""+pmV+"\")";
					insertText($paramValue[0], "param(\""+pmV+"\")");
					//$("#desc")[0].value = "获取参数--" + pmV;
				}  
			}
		}
		
	});
	MLanguage({
		container: $(".e8_tblForm")
    });
});

function insertText(obj,str) { 
	obj.focus();
	if (document.selection) {
		var sel = document.selection.createRange(); 
		sel.text = str; 
	} else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') { 
		var startPos = obj.selectionStart, 
		endPos = obj.selectionEnd, 
		cursorPos = startPos, 
		tmpStr = obj.value; 
		obj.value = tmpStr.substring(0, startPos) + str + tmpStr.substring(endPos, tmpStr.length); 
		cursorPos += str.length; 
		obj.selectionStart = obj.selectionEnd = cursorPos; 
	} else { 
		obj.value += str; 
	} 
} 

function onClose(){
	top.closeTopDialog();
}

function returnResult(){
	var paramName = $.trim($("#paramName").val());
	var paramValue = $.trim($("#paramValue").val());
	var errorMsg = "";
	if(paramName == ""){
		errorMsg = "<%=SystemEnv.getHtmlLabelName(127627,user.getLanguage())%>";  //参数名称不能为空
	}else if(paramValue == ""){
		errorMsg = "<%=SystemEnv.getHtmlLabelName(127628,user.getLanguage())%>";  //参数值不能为空
	}
	
	if(errorMsg != ""){
		var $warn = $("#warn-info");
		$warn.html(errorMsg);
		$warn.fadeIn(1000, function(){
			$(this).fadeOut(3000);
		});
		return;
	}
	
	if(top && top.callTopDlgHookFn){
		var desc = MLanguage.getValue($("#desc")) || $("#desc").val();
		var result = {
			"paramName" : paramName,
			"paramValue" : paramValue,
			"paramType" : $("#paramType").val(),
			"paramTypeText" : $("#paramType").find("option:selected").text(),
			"desc" : desc,
			"isEncrypt" : $("#isEncrypt").is(':checked') ? "1" : "0"
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onOK(){
	returnResult();
}
</script>

</head>
<body>
	<div id="warn-info"></div>
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr>
			<td class="e8_tblForm_label" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(126481,user.getLanguage())%><!-- 参数名称 --></td>
			<td class="e8_tblForm_field">
				<input type="text" id="paramName" name="paramName" value="<%=paramName %>" class="textStyle" placeholder="<%=SystemEnv.getHtmlLabelName(127644,user.getLanguage())%>"/><!-- 方法的参数名称，如name -->
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(32400,user.getLanguage())%><!-- 参数类型 --></td>
			<td class="e8_tblForm_field">
				<%
					List<ParameterType> paramTypeList = ParameterManager.getAllParamType();
				%>
				<select id="paramType" name="paramType" class="selectStyle">
					<%
						for(ParameterType p : paramTypeList){
							String selectedStr = (paramType.equals(p.getFaceType())) ? " selected=\"selected\"" : "";
					%>
						<option value="<%=p.getFaceType()%>"<%=selectedStr %>><%=p.toString() %></option>
					<%}%>
					
				</select>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(126482,user.getLanguage())%><!-- 参数值 --></td>
			<td class="e8_tblForm_field">
				<div style="margin-bottom:5px;">
					<div class="valueHolder" valueTemplate="{CURRUSER}"><%=SystemEnv.getHtmlLabelName(82151,user.getLanguage())%><!-- 当前用户 --></div>
					<div class="valueHolder" valueTemplate="{CURRDEPT}"><%=SystemEnv.getHtmlLabelName(127630,user.getLanguage())%><!-- 当前部门 --></div>
					<div class="valueHolder" valueTemplate="{CURRDEPTSUB}"><%=SystemEnv.getHtmlLabelName(127631,user.getLanguage())%><!-- 当前分部 --></div>
					<div class="valueHolder" valueTemplate="{CURRDATE}"><%=SystemEnv.getHtmlLabelName(15625,user.getLanguage())%><!-- 当前日期 --></div>
					<div class="valueHolder" valueTemplate="{CURRTIME}"><%=SystemEnv.getHtmlLabelName(15626,user.getLanguage())%><!-- 当前时间 --></div>
					<div class="valueHolder" valueTemplate="{PAGE_NO}"><%=SystemEnv.getHtmlLabelName(19497,user.getLanguage())%><!-- 当前页 --></div>
					<div class="valueHolder" valueTemplate="{DATA_START}"><%=SystemEnv.getHtmlLabelName(127645,user.getLanguage())%><!-- 数据起始位置 --></div>
					<div class="valueHolder" valueTemplate="{PAGE_SIZE}"><%=SystemEnv.getHtmlLabelName(127646,user.getLanguage())%><!-- 每页显示数量 --></div>
					<div class="valueHolder" valueTemplate="{SEARCH_KEY}"><%=SystemEnv.getHtmlLabelName(127647,user.getLanguage())%><!-- 查询参数 --></div>
					<div class="valueHolder" valueType="param"><%=SystemEnv.getHtmlLabelName(127632,user.getLanguage())%><!-- 获取参数 --></div>
				</div>
				<textarea id="paramValue" name="paramValue" class="textareaStyle"><%=paramValue %></textarea>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --></td>
			<td class="e8_tblForm_field">
				<input type="text" id="desc" name="desc" value="<%=desc %>" class="textStyle" data-multi=false/>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%><!-- 是否加密 --></td>
			<td class="e8_tblForm_field">
				<input type="checkbox" id="isEncrypt" name="isEncrypt" value="1" <%if(isEncrypt.equals("1")){%> checked="checked" <%}%>/>
			</td>
		</tr>
	</table>
	
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
	</div>
</body>
</html>
