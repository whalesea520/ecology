<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<title>Text Area Properties</title>
<meta content="noindex, nofollow" name="robots">
<script type="text/javascript" language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/fieldAttr_wev8.css"/>
<script type="text/javascript">
<%
	String efieldid = Util.null2String(request.getParameter("efieldid"));
	String isDetail = Util.null2String(request.getParameter("isDetail"));
%>
var parentWin = null;
var dialog = null;
var config = null;
var excel_isDetail = "<%=isDetail%>";
try {
	parentWin = parent.getParentWindow(window);
	dialog = parent.getDialog(window);
	//dialog = parent.parent.parent.getDialog(parent.window);
} catch (e) {
}

function btncancel_onclick(){
	dialog.close();
}

function onClear(){
	jQuery("#fieldattr").val("");
	jQuery("#caltype").val("");
}

//var oEditor = window.parent.InnerDialogLoaded() ;
//var oEditor = dialog.callbackfunParam.editor;
var iscanuse = true;
// Gets the document DOM
//var oDOM = oEditor.FCK.EditorDocument ;

//var oActiveEl = oEditor.FCKSelection.GetSelectedElement() ;
//var oActiveEl = dialog.callbackfunParam.selected;
var LayoutEditFrameObj = null;
var fieldid = 0;
	fieldid = "<%=efieldid%>";
var fieldGroupid = "";
var isDisabled = false;
var isDetail = 0;
var isZhengshuField = false;
window.onload = function(){
	//GetE('txtCols').value	= GetAttribute(oActiveEl, 'cols');//这2行不删是留着以后看方法怎么写，没实际意义
	//GetE('txtName').value = inputname;
	//oEditor.FCKLanguageManager.TranslatePage(document) ;
	//下面这个就是我们要的LayoutEditFrame.jsp那个document
	//LayoutEditFrameObj = window.parent.dialogArguments.FrameWindow.document;

	LayoutEditFrameObj = parentWin.document;
	if(excel_isDetail === "on")
		LayoutEditFrameObj = parentWin.parentWin_Main.document;
	//var inputname = oActiveEl.name;//当前选中的那个input的name
	//fieldid = inputname.substring(5, inputname.length);
	
	try{
		fieldGroupid = jQuery(LayoutEditFrameObj.getElementById("fieldattr"+fieldid)).attr("nodetype");
	}catch(e){
		fieldGroupid = "-1";
	}
	if(fieldGroupid != "-1"){
		isDetail = 1;
	}

	//window.parent.SetOkButton( true ) ;

	//var selectOuterHtml = LayoutEditFrameObj.getElementById("labellist"+fieldGroupid).outerHTML;
	var selectOuterHtml = jQuery("<div></div>").append(jQuery(LayoutEditFrameObj.getElementById("labellist"+fieldGroupid)).clone()).html()
	while(selectOuterHtml.indexOf("size=15") > -1){
		selectOuterHtml = selectOuterHtml.replace("size=15", "size=7");
	}

	$("#spanfieldlist").html(selectOuterHtml);
	$("#labellist"+fieldGroupid).show();
	
	var fileFieldids = LayoutEditFrameObj.getElementById("fileFieldids").value;
	var inputFieldids = LayoutEditFrameObj.getElementById("inputFieldids").value;
	var dateFields = LayoutEditFrameObj.getElementById("dateFields").value;
	var zhengshuFields = LayoutEditFrameObj.getElementById("zhengshuFields").value;
	var shuziFieldids = LayoutEditFrameObj.getElementById("shuziFieldids").value;
	
	try{
		var fieldsql = LayoutEditFrameObj.getElementById("fieldsql"+fieldid).value;
		//GetE("fieldattr").value = fieldsql;
		jQuery("#fieldattr").val(fieldsql);
		var caltype = LayoutEditFrameObj.getElementById("caltype"+fieldid).value;
		//GetE("caltype").value = caltype;
		jQuery("#caltype").val(caltype);
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
	LayoutEditFrameObj = parentWin.document;
	if(excel_isDetail === "on")
		LayoutEditFrameObj = parentWin.parentWin_Main.document;
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
	
	dialog.close();
}
</script>
</head>
<body style='OVERFLOW: auto;' scroll='no'>

<div class="zDialog_div_content" id="zDialog_div_content" style="position:absolute;top:0px;bottom:40px;width:100%;">
	<wea:layout>
		<wea:group context="<%=SystemEnv.getHtmlLabelName(82113, user.getLanguage())%>">
			<wea:item attributes="{\"colspan\":\"full\"}">

	<div style="height:10px!important;"></div>
	<table height="100%" width="100%">
		<tr>
			<td align="center" valign="top">
			<table border="0" cellpadding="0" cellspacing="0" width="90%" height="90%">
			<colgroup>
			<col width="60%">
			<col width="40%">
			</colgroup>
				<tr class="Title" valign="top">
					<td align="left">
						<span style="font-size:14px; color:#31b0b2;"><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%></span>
						<div style="height:2px; width:75px;background:#31b0b2;"></div>
						<div style="height:1px; width:190px; background:#b0b0b0;"></div>
					</td>
					<td align="left">
						<span style="font-size:14px; color:#3f8fff;"><%=SystemEnv.getHtmlLabelName(23860,user.getLanguage())%></span>
						<div style="height:2px; width:75px;background:#3f8fff;"></div>
						<div style="height:1px; width:120px; background:#b0b0b0;"></div>
					</td>
				</tr>
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
										<button id="sapoperation" name="sapoperation" title="SAP" class="oper_btn" onclick="sapOperation()" >SAP</button>
										<span id="sapoperationspan"></span>
									<%}else{ %>
										<button id="sapoperation" disabled="disabled" name="sapoperation" title="SAP" class="oper_btn" onclick="sapOperation()" >SAP</button>
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
									<td rowspan="2"><a href="javascript:insertSAPInfo(1)"><%=SystemEnv.getHtmlLabelNames("30615,30686", user.getLanguage())%></a>&nbsp;&nbsp;</td>
									
									<td><a href="javascript:insertSAPInfo(2)"><%=SystemEnv.getHtmlLabelNames("30615,28245", user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(3)"><%=SystemEnv.getHtmlLabelNames("30615,30712", user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(4)"><%=SystemEnv.getHtmlLabelNames("30615,28251", user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(5)"><%=SystemEnv.getHtmlLabelNames("30615,128050", user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(6)"><%=SystemEnv.getHtmlLabelNames("30615,128051", user.getLanguage())%></a>&nbsp;&nbsp;</td>
								</tr>
								<tr>
									<td><a href="javascript:insertSAPInfo(2.5)"><%=SystemEnv.getHtmlLabelNames("30615,128052", user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(3.5)"><%=SystemEnv.getHtmlLabelName(129001, user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(4.5)"><%=SystemEnv.getHtmlLabelName(129002, user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(5.5)"><%=SystemEnv.getHtmlLabelName(129003, user.getLanguage())%></a>&nbsp;&nbsp;</td>
									<td><a href="javascript:insertSAPInfo(6.5)"><%=SystemEnv.getHtmlLabelName(129004, user.getLanguage())%></a>&nbsp;&nbsp;</td>
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
		</wea:item>
		</wea:group>
	</wea:layout>
	</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">	
			<wea:layout type="2col" needImportDefaultJsAndCss="false">
				<wea:group context="">
					<wea:item type="toolbar">
						<input class=zd_btn_submit type="button" accessKey=O  id=btnok onclick="Ok()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
						<input class=zd_btn_submit type="button" accessKey=2  id=btnclear onclick="onClear()" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
		        		<input class=zd_btn_submit type="button" accessKey=T  id=btncancel onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	
</body>
<script type="text/javascript" language="javascript">
function onchangeformlabel(obj){
	$(".labellist").hide();
	$("#labellist"+obj.value).show();
}
function cool_webcontrollabel(obj){
	var textvalue = "$"+jQuery(obj).find("input[type='hidden']").val()+"$";
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
	LayoutEditFrameObj = parentWin.document;
	if(excel_isDetail === "on")
		LayoutEditFrameObj = parentWin.parentWin_Main.document;
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
			alert('<%=SystemEnv.getHtmlLabelName(128053, user.getLanguage())%>');
			return;
		}
		textval = "FunctionName:' <%=SystemEnv.getHtmlLabelName(28231, user.getLanguage())%> ', ";
		insertIntoTextarea(textval);
		return;
	}
	if(fieldattr.indexOf('FunctionName:') == -1){
		alert('<%=SystemEnv.getHtmlLabelName(128054, user.getLanguage())%>');
		return;
	}
	
	
	if(type == 2){
		if(fieldattr.indexOf('InputParams:') != -1){
			textval = ",{SAPParamName:' <%=SystemEnv.getHtmlLabelName(129005, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ";
		}else{
			textval = "InputParams:[{SAPParamName:' <%=SystemEnv.getHtmlLabelName(129005, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ], ";
		}
	}
	if(type == 2.5){
		if(fieldattr.indexOf('OutputParams:') != -1){
			textval = ",{SAPParamName:' SAP<%=SystemEnv.getHtmlLabelName(129006, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ";
		}else{
			textval = "OutputParams:[{SAPParamName:' SAP<%=SystemEnv.getHtmlLabelName(129006, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ], ";
		}
	}
	
	if(type == 3){
		if(fieldattr.indexOf('InputTables:') != -1){
			textval = ",{TableName:' <%=SystemEnv.getHtmlLabelName(128057, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129007, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ";
		}else{
			textval = "InputTables:[{TableName:' <%=SystemEnv.getHtmlLabelName(128057, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129007, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ], ";
		}
	}
	if(type == 3.5){
		textval = ",{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129007, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ";
	}
	
	
	if(type == 4){
		if(fieldattr.indexOf('InputStructs:') != -1){
			textval = ",{StructName:' <%=SystemEnv.getHtmlLabelName(129008, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129016, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ";
		}else{
			textval = "InputStructs:[{StructName:' <%=SystemEnv.getHtmlLabelName(129008, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129016, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ], ";
		}
	}
	if(type == 4.5){
		textval = ",{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129016, user.getLanguage())%> ',FromOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ";
	}
	
	
	if(type == 5){
		if(fieldattr.indexOf('OutputTables:') != -1){
			textval = ",{TableName:' <%=SystemEnv.getHtmlLabelName(129017, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129018, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ";
		}else{
			textval = "OutputTables:[{TableName:' <%=SystemEnv.getHtmlLabelName(129017, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129018, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ], ";
		}
	}
	if(type == 5.5){
		textval = ",{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129018, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ";
	}
	
	
	if(type == 6){
		if(fieldattr.indexOf('OutputStructs:') != -1){
			textval = ",{StructName:' <%=SystemEnv.getHtmlLabelName(129020, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129019, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ";
		}else{
			textval = "OutputStructs:[{StructName:' <%=SystemEnv.getHtmlLabelName(129020, user.getLanguage())%> ',Fields:[{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129019, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ]} ], ";
		}
	}
	if(type == 6.5){
		textval = ",{SAPFieldName:' <%=SystemEnv.getHtmlLabelName(129019, user.getLanguage())%> ',TOOAField:' <%=SystemEnv.getHtmlLabelName(30607, user.getLanguage())%> '} ";
	}
	insertIntoTextarea(textval);
}

</script>
</html>