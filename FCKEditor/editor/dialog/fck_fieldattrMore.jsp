<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<title>Text Area Properties</title>
<meta content="noindex, nofollow" name="robots">
<script src="common/fck_dialog_common_wev8.js" type="text/javascript"></script>
<script type="text/javascript" language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">

var oEditor = window.parent.InnerDialogLoaded() ;
var iscanuse = true;
// Gets the document DOM
var oDOM = oEditor.FCK.EditorDocument ;

var oActiveEl = oEditor.FCKSelection.GetSelectedElement() ;
var LayoutEditFrameObj = null;
var fieldid = 0;
var fieldGroupid = "";
var isDisabled = false;
var isDetail = 0;
var isZhengshuField = false;
window.onload = function(){
	//GetE('txtCols').value	= GetAttribute(oActiveEl, 'cols');//这2行不删是留着以后看方法怎么写，没实际意义
	//GetE('txtName').value = inputname;
	oEditor.FCKLanguageManager.TranslatePage(document) ;
	//下面这个就是我们要的LayoutEditFrame.jsp那个document
	LayoutEditFrameObj = window.parent.dialogArguments.FrameWindow.document;
	var inputname = oActiveEl.name;//当前选中的那个input的name
	fieldid = inputname.substring(5, inputname.length);
	try{
		fieldGroupid = LayoutEditFrameObj.getElementById("fieldattr"+fieldid).nodetype;
	}catch(e){
		fieldGroupid = "-1";
	}
	if(fieldGroupid != "-1"){
		isDetail = 1;
	}
	window.parent.SetOkButton( true ) ;

	var selectOuterHtml = LayoutEditFrameObj.getElementById("labellist"+fieldGroupid).outerHTML;
	while(selectOuterHtml.indexOf("size=15") > -1){
		selectOuterHtml = selectOuterHtml.replace("size=15", "size=7");
	}
	$("#spanfieldlist").html(selectOuterHtml);
	$("#labellist"+fieldGroupid).show();
	$("#labellist"+fieldGroupid).width("95%");
	
	var fileFieldids = LayoutEditFrameObj.getElementById("fileFieldids").value;
	var inputFieldids = LayoutEditFrameObj.getElementById("inputFieldids").value;
	var dateFields = LayoutEditFrameObj.getElementById("dateFields").value;
	var zhengshuFields = LayoutEditFrameObj.getElementById("zhengshuFields").value;
	var shuziFieldids = LayoutEditFrameObj.getElementById("shuziFieldids").value;
	
	try{
		var fieldsql = LayoutEditFrameObj.getElementById("fieldsql"+fieldid).value;
		GetE("fieldattr").value = fieldsql;
		var caltype = LayoutEditFrameObj.getElementById("caltype"+fieldid).value;
		GetE("caltype").value = caltype;
		var othertype = LayoutEditFrameObj.getElementById("othertype"+fieldid).value;
		if(caltype == 4){
			showEscPara(4);
			onchangeSFields(4);
		}
	}catch(e){}
}
function doDisplayAll(){
	$("#sqloperation").attr("disabled", true);
	$("#sumoperation").attr("disabled", true);
	$("#dateoperation").attr("disabled", true);
	$("#fieldattr").attr("disabled", true);

	$("#currentuser").attr("disabled", true);
	$("#currentdept").attr("disabled", true);
	$("#wfcreater").attr("disabled", true);
	$("#createrdept").attr("disabled", true);
	$("#currentdate").attr("disabled", true);
}
function Ok(){
	var sqlcontent = $("#fieldattr").val();

	var caltype = document.getElementById("caltype").value;
	
	if(caltype == '4' && sqlcontent.indexOf('doFieldSAP') != -1){
		var index1 = sqlcontent.lastIndexOf(',');
		var index2 = sqlcontent.lastIndexOf('}');
		if(sqlcontent.substring(index1+1,index2).replace(/^\s*/g,'').replace(/\s*$/g,'') == ''){
			sqlcontent = sqlcontent.substring(0,index1) + sqlcontent.substring(index2);
		}
	}
	
	
	var othertype = "0";
	var transtype = "0";
	
	LayoutEditFrameObj.getElementById("fieldsql"+fieldid).value = sqlcontent;
	LayoutEditFrameObj.getElementById("caltype"+fieldid).value = caltype;
	LayoutEditFrameObj.getElementById("othertype"+fieldid).value = othertype;
	LayoutEditFrameObj.getElementById("transtype"+fieldid).value = transtype;
	
	return true;
}
</script>
</head>
<body style='OVERFLOW: auto;' >
	<table height="100%" width="100%">
		<tr>
			<td align="center" valign="top">
			<table class="ViewForm" border="0" cellpadding="0" cellspacing="0" width="90%" height="90%">
			<colgroup>
			<col width="60%">
			<col width="40%">
			</colgroup>
				<tr class="Title" valign="top">
					<TH align="left">
						<%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%>
					</TH>
					<TH align="left">
						<%=SystemEnv.getHtmlLabelName(23860,user.getLanguage())%>
					</TH>

				</tr>
				<tr height="5"><td colspan="3"></td></tr>
				<tr valign="top">
					<td align="left" valign="top">
						<div id="spanfieldlist0"></div>
						<div id="spanfieldlist"></div>
					</td>
					<td align="left" valign="top">
						<input type="hidden" id="caltype" name="caltype" value="0">
						<table cellpadding="0" cellspacing="2" border="0" width="100%">
							<tr valign="top">
								<td width="100%">
									<%
									String saptriggerflag = Util.null2String(new BaseBean().getPropValue("SAPTrigger","SAPTriggerFlag"));
									%>
									<%if(saptriggerflag.equals("1") || saptriggerflag.equalsIgnoreCase("y")){ %>
										<button id="sapoperation" name="sapoperation" title="SAP" class="btn" onclick="sapOperation()" >SAP</button>
										<span id="sapoperationspan"></span>
									<%}else{ %>
										<button id="sapoperation" disabled="disabled" name="sapoperation" title="SAP" class="btn" onclick="sapOperation()" >SAP</button>
									<%} %>
								</td>
							</tr>
						</table>
					</td>

				</tr>
				<tr>
					<td colspan="3" align="left" height="0"><div id="noticeDiv" style="height:0px;color:#ff0000;padding-left:25px;"></div>
					</td>
				</tr>
				<tr>
					<td align="left" colspan="3">
						<div id="sapinfodiv" style="display:none">
							<table cellpadding="0" cellspacing="2" border="0">
								<tr>
									<td rowspan="2"><a href="javascript:insertSAPInfo(1)">插入函数</a>&nbsp;&nbsp;</td>
									
									<td><a href="javascript:insertSAPInfo(2)">插入输入参数</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(3)">插入输入表</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(4)">插入输入结构</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(5)">插入返回表</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(6)">插入返回结构</a>&nbsp;&nbsp;</td>
								</tr>
								<tr>
									<td><a href="javascript:insertSAPInfo(2.5)">插入返回参数</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(3.5)">插入输入表字段</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(4.5)">插入输入结构字段</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(5.5)">插入返回表字段</a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(6.5)">插入返回结构字段</a>&nbsp;&nbsp;</td>
								</tr>
							</table>
						</div>
						<textarea id="fieldattr" name="fieldattr" rows="7" style="width:95%"></textarea>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</body>
<script type="text/javascript" language="javascript">
function onchangeformlabel(obj){
	$(".labellist").hide();
	$("#labellist"+obj.value).show();
}
function cool_webcontrollabel(obj){
	var textvalue = "$"+obj.value+"$";
	if(isDisabled == false){
		insertIntoTextarea(textvalue);
	}
}
function sapOperation(){
	var fieldattr = document.getElementById("fieldattr").value;
	var textvalue = "doFieldSAP(\" { } \")";
	var toset = true;
	if(fieldattr.indexOf("doField")>-1 && fieldattr.indexOf("doFieldSAP")==-1){//有设置过，但曾经的设置不是FieldSAP
		if(confirm("<%=SystemEnv.getHtmlLabelName(23820,user.getLanguage())%>")){
			document.getElementById("fieldattr").value = textvalue;
			showEscPara(4);
			//onchangeSFields(4);
		}else{
			toset = false;
		}
	}else if(fieldattr.indexOf("doFieldSAP") == -1){
		insertIntoTextarea(textvalue);
		showEscPara(4);
		//onchangeSFields(4);
	}
	if(toset){
		if(fieldGroupid == "-1"){
			var selectOuterHtml0 = LayoutEditFrameObj.getElementById("labellist-all").outerHTML;
			while(selectOuterHtml0.indexOf("size=15") > -1){
				selectOuterHtml0 = selectOuterHtml0.replace("size=15", "size=7");
			}
			selectOuterHtml0 = selectOuterHtml0.replace(/display\s*:\s*none/ig, "");
			$("#spanfieldlist").hide();
			$("#spanfieldlist0").html(selectOuterHtml0);
			$("#spanfieldlist0").show();
		}else{
			$("#spanfieldlist0").hide();
			$("#spanfieldlist").show();
		}
		$("#sapinfodiv").show();
	}else{
		$("#spanfieldlist0").hide();
		$("#spanfieldlist").show();
		$("#sapinfodiv").show();
	}
}





function insertIntoTextarea(textvalue){
	var obj = document.getElementById("fieldattr");
	obj.focus();
	if(document.selection){
		document.selection.createRange().text = textvalue;
	}else{
		obj.value = obj.value.substr(0, obj.selectionStart) + textvalue + obj.value.substr(obj.selectionEnd);
	}
}

function insertMark(textvalue){
	insertIntoTextarea(textvalue);
}
//type:1,sql;0,sum;2,date
function showEscPara(type){
	document.getElementById("sapoperationspan").innerHTML = "";
	if(type == 4){//sap
		$("#currentuser").attr("disabled", true);
		$("#currentdept").attr("disabled", true);
		$("#wfcreater").attr("disabled", true);
		$("#createrdept").attr("disabled", true);
		$("#currentdate").attr("disabled", false);
		document.getElementById("sapoperationspan").innerHTML = "<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
	}
	GetE("caltype").value = type;
}

function onchangeSFields(type){
	var selectOuterHtml = LayoutEditFrameObj.getElementById("labellist"+fieldGroupid).outerHTML;
	while(selectOuterHtml.indexOf("size=15") > -1){
		selectOuterHtml = selectOuterHtml.replace("size=15", "size=7");
	}
	$("#spanfieldlist").html(selectOuterHtml);
	
	if(type == 4){
		if(fieldGroupid == "-1"){
			var selectOuterHtml0 = LayoutEditFrameObj.getElementById("labellist-all").outerHTML;
			while(selectOuterHtml0.indexOf("size=15") > -1){
				selectOuterHtml0 = selectOuterHtml0.replace("size=15", "size=7");
			}
			selectOuterHtml0 = selectOuterHtml0.replace(/display\s*:\s*none/ig, "");
			$("#spanfieldlist0").html(selectOuterHtml0);
			$("#spanfieldlist0").show();
			$("#spanfieldlist").hide();
		}else{
			$("#spanfieldlist0").hide();
			$("#spanfieldlist").show();
		}
		$("#sapinfodiv").show();
		
		$("#labellist"+fieldGroupid).show();
	}
}

function insertSAPInfo(type){
	var fieldattr = document.getElementById("fieldattr").value;
	var textval = '';
	if(type == 1){
		if(fieldattr.indexOf('FunctionName:') != -1){
			alert('只能插入一个函数！');
			return;
		}
		textval = "FunctionName:' SAP函数名 ', ";
		insertIntoTextarea(textval);
		return;
	}
	if(fieldattr.indexOf('FunctionName:') == -1){
		alert('先插入函数！');
		return;
	}
	
	
	if(type == 2){
		if(fieldattr.indexOf('InputParams:') != -1){
			textval = ",{SAPParamName:' SAP输入参数名 ',FromOAField:' OA取值字段 '} ";
		}else{
			textval = "InputParams:[{SAPParamName:' SAP输入参数名 ',FromOAField:' OA取值字段 '} ], ";
		}
	}
	if(type == 2.5){
		if(fieldattr.indexOf('OutputParams:') != -1){
			textval = ",{SAPParamName:' SAP返回参数名 ',TOOAField:' OA赋值字段 '} ";
		}else{
			textval = "OutputParams:[{SAPParamName:' SAP返回参数名 ',TOOAField:' OA赋值字段 '} ], ";
		}
	}
	
	if(type == 3){
		if(fieldattr.indexOf('InputTables:') != -1){
			textval = ",{TableName:' SAP输入表名 ',Fields:[{SAPFieldName:' SAP输入表字段名 ',FromOAField:' OA取值字段 '} ]} ";
		}else{
			textval = "InputTables:[{TableName:' SAP输入表名 ',Fields:[{SAPFieldName:' SAP输入表字段名 ',FromOAField:' OA取值字段 '} ]} ], ";
		}
	}
	if(type == 3.5){
		textval = ",{SAPFieldName:' SAP输入表字段名 ',FromOAField:' OA取值字段 '} ";
	}
	
	
	if(type == 4){
		if(fieldattr.indexOf('InputStructs:') != -1){
			textval = ",{StructName:' SAP输入结构名 ',Fields:[{SAPFieldName:' SAP输入结构字段名 ',FromOAField:' OA取值字段 '} ]} ";
		}else{
			textval = "InputStructs:[{StructName:' SAP输入结构名 ',Fields:[{SAPFieldName:' SAP输入结构字段名 ',FromOAField:' OA取值字段 '} ]} ], ";
		}
	}
	if(type == 4.5){
		textval = ",{SAPFieldName:' SAP输入结构字段名 ',FromOAField:' OA取值字段 '} ";
	}
	
	
	if(type == 5){
		if(fieldattr.indexOf('OutputTables:') != -1){
			textval = ",{TableName:' SAP返回表名 ',Fields:[{SAPFieldName:' SAP返回表字段名 ',TOOAField:' OA赋值字段 '} ]} ";
		}else{
			textval = "OutputTables:[{TableName:' SAP返回表名 ',Fields:[{SAPFieldName:' SAP返回表字段名 ',TOOAField:' OA赋值字段 '} ]} ], ";
		}
	}
	if(type == 5.5){
		textval = ",{SAPFieldName:' SAP返回表字段名 ',TOOAField:' OA赋值字段 '} ";
	}
	
	
	if(type == 6){
		if(fieldattr.indexOf('OutputStructs:') != -1){
			textval = ",{StructName:' SAP返回结构名 ',Fields:[{SAPFieldName:' SAP返回结构字段名 ',TOOAField:' OA赋值字段 '} ]} ";
		}else{
			textval = "OutputStructs:[{StructName:' SAP返回结构名 ',Fields:[{SAPFieldName:' SAP返回结构字段名 ',TOOAField:' OA赋值字段 '} ]} ], ";
		}
	}
	if(type == 6.5){
		textval = ",{SAPFieldName:' SAP返回结构字段名 ',TOOAField:' OA赋值字段 '} ";
	}
	insertIntoTextarea(textval);
}

</script>
</html>