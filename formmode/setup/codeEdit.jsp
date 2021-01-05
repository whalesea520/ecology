<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.virtualform.ExtendDSHandler"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="com.weaver.formmodel.util.FileHelper"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/formmode/pub.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)&&!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

boolean isNewFile = false;	//是否是新建文件

String type = StringHelper.null2String(request.getParameter("type"));

String fileName = Util.null2String(request.getParameter("filename"));	//filename通过参数获取，为以后可能多文件做准备。
if(fileName.equals("")){
	fileName = "Template.java";
	isNewFile = true;
}
String formid=Util.null2String(request.getParameter("formid"),"0");

Map<String, String> sourceCodePathMap = CommonConstant.SOURCECODE_PATH_MAP;
String sourceCodePath = sourceCodePathMap.get(type);

	
String filepath = GCONST.getRootPath() + sourceCodePath;
filepath = filepath + fileName;
String content = FileHelper.loadFile(filepath, "UTF-8");

if(isNewFile){
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	String timeStamp = sdf.format(new Date(System.currentTimeMillis()));
	String className = "CustomJavaCode_" + timeStamp;
	
	Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
	String sourceCodePackageName = sourceCodePackageNameMap.get(type);
	FormInfoService formInfoService=new FormInfoService();
	String preFieldInfo=formInfoService.getPreFieldInfo(Util.getIntValue(formid));
	content = content.replaceAll("\\$PackageName\\$", sourceCodePackageName);
	content = content.replaceAll("\\$ClassName\\$", className);
	content = content.replaceAll("\\$fieldinfo\\$", preFieldInfo);
	fileName = className + ".java";
}

int subCompanyId = -1;
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
%>
<html>
<head>
	<title><%=SystemEnv.getHtmlLabelName(82032,user.getLanguage())%></title><!-- 代码编辑 -->
	<script src="/formmode/js/codemirror/lib/codemirror_wev8.js"></script>
	<link rel="stylesheet" href="/formmode/js/codemirror/lib/codemirror_wev8.css"/>
	<script src="/formmode/js/codemirror/mode/clike/clike_wev8.js"></script>
	<link rel="stylesheet" href="/formmode/js/codemirror/theme/eclipse_wev8.css"/>
	<script src="/formmode/js/jquery/form/jquery.form_wev8.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" language="javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" language="javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
	<style>
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: hidden;
	}
	.CodeMirror{
		font-size: 12px;
		line-height: 1.5em;
		height: 516px;
		border-bottom: 1px solid #eee;
	}
	#title{
		height: 30px;
		position: relative;
		border-bottom: 1px solid #eee;
	}
	.filename{
		border: 1px solid #eee;
		border-bottom: none;
		background-color:#fff;
		position: absolute;
		left: 28px;
		bottom: -1px;
		padding: 7px 7px;
		font-weight: bold;
	}
	</style>
<script type="text/javascript">
var editor;
var myMask;
jQuery(document).ready(function ($) {
	editor = CodeMirror.fromTextArea(document.getElementById("code"), {
		lineNumbers: true,
		theme: "eclipse",
		indentUnit: 4,
		mode: "text/x-java"
	});
	
	$("#CodeForm").ajaxForm({
		
		beforeSubmit:function(arr){
			for(var i = 0; i < arr.length; i++){
				if(arr[i].name == "code"){
					var vv = arr[i].value;
					var encodeVV = encodeURI(vv);
					encodeVV = encodeVV.replace(/\+/g,'%2B');
					arr[i].value = encodeVV;
					break;
				}
			}
			
			rightMenu.style.visibility = "hidden";
			
			myMask = new Ext.LoadMask(Ext.getBody(), {
				msg: '<%=SystemEnv.getHtmlLabelName(82033,user.getLanguage())%>',//保存中,请稍后...
				removeMask: true //完成后移除
			});
			myMask.show();
			return true;
		},
        success: function(responseText, statusText, xhr, $form){
			myMask.hide();
        	if(responseText == "1"){
        		Dialog.alert("<%=SystemEnv.getHtmlLabelName(82034,user.getLanguage())%>", function(){//已保存
        			if(top && top.callCodeDlgHookFn){
        				var result = {
							"fileName" : $("#filename").val()
						};
        				top.callCodeDlgHookFn(result);
        			}
					if(saveFlag == 2){
						onClose();
					}
				}, 200, 60, false);
        	}else{
        		alert("<%=SystemEnv.getHtmlLabelName(82035,user.getLanguage())%>:\n\n" + decodeURIComponent(responseText));	//保存时出现错误
        		saveFlag = 0;
        	}
        }
	}); 
});

function updateEditorValToTextarea(){
	$('#code').val(editor.getValue());
}

var saveFlag = 0;
function onSave(){
	saveFlag = 1;
	updateEditorValToTextarea();
	$("#CodeForm").submit();
}

function onSaveAndClose(){
	saveFlag = 2;
	updateEditorValToTextarea();
	$("#CodeForm").submit();
}

function onClose(){
	if(top && top.closeCodeEdit){
		top.closeCodeEdit();
	}else{
		window.close();
	}
}
</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
    if(!"2".equals(type)&&!"3".equals(type)&&!"5".equals(type)&&!"6".equals(type)&&!"8".equals(type)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82036,user.getLanguage())+",javascript:onSaveAndClose(),_top} " ;//保存并关闭
	RCMenuHeight += RCMenuHeightStep ;
    }
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onClose(),_top} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="title">
	<div class="filename"><%=fileName %></div>
</div>

<form name="CodeForm" method="post" action="/formmode/setup/codeEditAction.jsp?action=saveCode" id="CodeForm">
	<input type="hidden"  name="filename" id="filename" value="<%=fileName %>">
	<input type="hidden"  name="type" id="type" value="<%=type %>">
	
	<textarea id="code" name="code">
<%=content %>
	</textarea>
</form> 
</body>
</html>
