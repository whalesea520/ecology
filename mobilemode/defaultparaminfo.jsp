<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
weaver.filter.ECompatibleSetting.setVersion(weaver.filter.ECompatibleSetting.ECOLOGY_JSP_VERSION_E8,request); 
String paramValue = Util.null2String(request.getParameter("paramValue"));
%>
<html>
<head>
	<title></title>
<style>
*{
	font-family: 'Microsoft YaHei', Arial;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
	
}
.e8_tblForm{
	width: 100%;
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
	font-family: 'Microsoft YaHei', Arial;
	font-size: 11px;
	height: 24px;
	line-height: 24px;
	width: 60px;
	text-align: center;
	margin-right:6px;
	margin-bottom: 6px; 
}
.valueHolder_style8{
	width: 130px;
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
/* #warn-info{
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
} */
</style>

<script type="text/javascript">
$(function() {
	$(".valueHolder").click(function(){
		var valueTemplate = $(this).attr("valueTemplate");
		var $paramValue = $("#paramValue");
		if(valueTemplate && valueTemplate != ""){
			//$paramValue[0].value = valueTemplate;
			insertText($paramValue[0], valueTemplate);
		}else{
			var valueType = $(this).attr("valueType");
			if(valueType == "param"){
				var pmV = window.prompt("<%=SystemEnv.getHtmlLabelName(127626,user.getLanguage())%>","");  //请输入要获取的参数名称
				if(pmV != null && pmV != ""){
					//$paramValue[0].value = "param(\""+pmV+"\")";
					insertText($paramValue[0], "param(\""+pmV+"\")");
				}  
			}else if(valueType == "SQL"){
				//$paramValue[0].value = "SQL(\" \")";
				insertText($paramValue[0], "SQL(\" \")");
			}
		}
		
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
	var paramValue = $.trim($("#paramValue").val());
	/* var errorMsg = "";
	if(paramValue == ""){
		errorMsg = "参数值不能为空";
	}
	
	if(errorMsg != ""){
		var $warn = $("#warn-info");
		$warn.html(errorMsg);
		$warn.fadeIn(1000, function(){
			$(this).fadeOut(3000);
		});
		return;
	} */
	
	if(top && top.callTopDlgHookFn){
		var result = {
			"paramValue" : paramValue
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onOK(){
	returnResult();
}

function onReset(){
	$("#paramValue").val("");
}
</script>

</head>
<body>
	<!-- <div id="warn-info"></div> -->
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%><!-- 默认值 --></td>
			<td class="e8_tblForm_field">
				<div style="margin-bottom:2px;">
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueTemplate="{CURRUSER}"><%=SystemEnv.getHtmlLabelName(82151,user.getLanguage())%><!-- 当前用户 --></div>
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueTemplate="{CURRDEPT}"><%=SystemEnv.getHtmlLabelName(127630,user.getLanguage())%><!-- 当前部门 --></div>
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueTemplate="{CURRDEPTSUB}"><%=SystemEnv.getHtmlLabelName(127631,user.getLanguage())%><!-- 当前分部 --></div>
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueTemplate="{CURRDATE}"><%=SystemEnv.getHtmlLabelName(15625,user.getLanguage())%><!-- 当前日期 --></div>
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueTemplate="{CURRTIME}"><%=SystemEnv.getHtmlLabelName(15626,user.getLanguage())%><!-- 当前时间 --></div>
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueType="param"><%=SystemEnv.getHtmlLabelName(127632,user.getLanguage())%><!-- 获取参数 --></div>
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueType="SQL">SQL</div>
					<div class="valueHolder valueHolder_style<%=user.getLanguage()%>" valueTemplate="{UUID}">UUID<!-- 32位ID --></div>
				</div>
				<textarea id="paramValue" name="paramValue" class="textareaStyle"><%=paramValue %></textarea>
			</td>
		</tr>
	</table>
	
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onReset()"><%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%><!-- 重置 --></button>
	</div>
</body>
</html>
