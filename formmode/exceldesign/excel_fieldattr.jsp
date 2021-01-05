<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<html>
<head>
<title>Text Area Properties</title>
<meta content="noindex, nofollow" name="robots">
<script type="text/javascript" language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/formmode/exceldesign/css/fieldAttr_wev8.css"/>
<%
	String efieldid = Util.null2String(request.getParameter("efieldid"));
	String isDetail = Util.null2String(request.getParameter("isDetail"));
%>
<script type="text/javascript">

var parentWin = null;
var dialog = null;
var config = null;
var excel_isDetail = "<%=isDetail%>";
try {
	parentWin = parent.getParentWindow(window);
	dialog = parent.getDialog(window);
} catch (e) {
}

function btncancel_onclick(){
	dialog.close();
}

function onClear(){
	jQuery("#fieldattr").val("");
	jQuery("#datasource").val("");
	jQuery("#caltype").val("");
}

//var oEditor = dialog.callbackfunParam.editor;//window.parent.InnerDialogLoaded() ;
var iscanuse = true;
// Gets the document DOM
//var oDOM = oEditor.CK.EditorDocument ;

//var oActiveEl = dialog.callbackfunParam.selected; //oEditor.FCKSelection.GetSelectedElement() ;
var LayoutEditFrameObj = null;
var fieldid = 0;
fieldid = "<%=efieldid%>";

var fieldGroupid = "";
var isDisabled = false;
var isDetail = 0;
var isZhengshuField = false;
var layouttype = "";
window.onload = function(){
	LayoutEditFrameObj = parentWin.document;//window.parent.dialogArguments.FrameWindow.document;
	if(excel_isDetail === "on")
		LayoutEditFrameObj = parentWin.parentWin_Main.document;
	try{
		fieldGroupid = jQuery(LayoutEditFrameObj.getElementById("fieldattr"+fieldid)).attr("nodetype");
	}catch(e){
		fieldGroupid = "-1";
	}
	if(fieldGroupid != "-1"){
		$("#sumoperation").attr("disabled", true).addClass("oper_btn_disabled");
		isDetail = 1;
	}
	//window.parent.SetOkButton( true ) ;
	layouttype = LayoutEditFrameObj.getElementById("layouttype").value;
	if(excel_isDetail=="on"&&layouttype==0){	
		$("#sqloperation").attr("disabled", true).addClass("oper_btn_disabled");
	}
	//var selectOuterHtml = jQuery(LayoutEditFrameObj.getElementById("labellist"+fieldGroupid)).outerHTML;
	var selectOuterHtml = jQuery("<div></div>").append(jQuery(LayoutEditFrameObj.getElementById("labellist"+fieldGroupid)).clone()).html()
	while(selectOuterHtml.indexOf("size=15") > -1){
		selectOuterHtml = selectOuterHtml.replace("size=15", "size=7");
	}
	$("#spanfieldlist").html(selectOuterHtml);
	if(isDetail==1){
		$("#labellist"+fieldGroupid).prepend(LayoutEditFrameObj.getElementById("labellist-1").innerHTML);
	}
	$("#labellist"+fieldGroupid).show();
	try{
		var fileFieldids = LayoutEditFrameObj.getElementById("fileFieldids").value;
		var inputFieldids = LayoutEditFrameObj.getElementById("inputFieldids").value;
		var dateFields = LayoutEditFrameObj.getElementById("dateFields").value;
		var zhengshuFields = LayoutEditFrameObj.getElementById("zhengshuFields").value;
		var mapFields = $("#mapFields", LayoutEditFrameObj).attr("value");
		if((","+fileFieldids+",").indexOf(","+fieldid+",") > -1){
			doDisplayAll();
			showEscPara(0);
			isDisabled = true;
		}else if((","+inputFieldids+",").indexOf(","+fieldid+",") == -1){
			$("#sumoperation").attr("disabled", true).addClass("oper_btn_disabled");
		}
	}catch(e){}
	try{
		var dateFields = LayoutEditFrameObj.getElementById("dateFields").value;
		var shuziFieldids = LayoutEditFrameObj.getElementById("shuziFieldids").value;
		if((","+dateFields+",").indexOf(","+fieldid+"_"+isDetail+",")==-1 && (","+shuziFieldids+",").indexOf(","+fieldid+"_"+isDetail+",")==-1){
			$("#dateoperation").attr("disabled", true).addClass("oper_btn_disabled");
		}
	}catch(e){}
	try{
		var shuziFieldids = LayoutEditFrameObj.getElementById("shuziFieldids").value;
		if((","+shuziFieldids+",").indexOf(","+fieldid+"_"+isDetail+",") != -1){
			if(isDetail != 1){
				$("#fieldtransdiv").show();
			}
			var transtype_t = LayoutEditFrameObj.getElementById("transtype"+fieldid).value;
			jQuery("#transtype"+transtype_t).attr("checked", true).next().addClass("jNiceChecked");
			isZhengshuField = true;
		}
	}catch(e){}
	try{
		var fieldsql = LayoutEditFrameObj.getElementById("fieldsql"+fieldid).value;
		jQuery("#fieldattr").val(fieldsql);
		var datasource = LayoutEditFrameObj.getElementById("datasource"+fieldid).value;
		jQuery("#datasource").val(datasource);
		if(fieldsql.indexOf("doFieldSQL")!=-1){
			showEscPara(1);
		}
		if(datasource!=""){
			if(jQuery("#datasource").val()==""){
				$("#datasourceNoExists").html("<%=SystemEnv.getHtmlLabelName(128208, user.getLanguage())+SystemEnv.getHtmlLabelName(18076, user.getLanguage())%>"+"【 "+datasource+" 】"+"<%=SystemEnv.getHtmlLabelName(23084, user.getLanguage())+SystemEnv.getHtmlLabelName(21695, user.getLanguage())+SystemEnv.getHtmlLabelName(126543, user.getLanguage())+SystemEnv.getHtmlLabelName(18201, user.getLanguage()) %>").show();
			}
		}
		var caltype = LayoutEditFrameObj.getElementById("caltype"+fieldid).value;
		//GetE("caltype").value = caltype;
		jQuery("#caltype").val(caltype);
		var othertype = LayoutEditFrameObj.getElementById("othertype"+fieldid).value;
		if(caltype == 1){
			showEscPara(1);
			onchangeSFields(1);
		}else if(caltype == 2){
			onchangeSFields(2);
			showEscPara(2);
		}else if(caltype == 3){
			onchangeSFields(3);
			showEscPara(3);
		}else if(caltype==5){
			onchangeSFields(5);
			showEscPara(5);
		}
		try{
			if(othertype ==1){
				jQuery("#worddateonly").attr("checked", true).next().addClass("jNiceChecked");
			}else{
				jQuery("#worddateonly").attr("checked", false).next().removeClass("jNiceChecked");
			}
		}catch(e){}
	}catch(e){}
	checkSql2($("#fieldattr").get(0));
}
function doDisplayAll(){
	$("#sqloperation").attr("disabled", true).addClass("oper_btn_disabled");
	$("#sumoperation").attr("disabled", true).addClass("oper_btn_disabled");
	$("#dateoperation").attr("disabled", true).addClass("oper_btn_disabled");
	$("#fieldattr").attr("disabled", true);

	$("#currentuser").attr("disabled", true).removeAttr("onclick");
	$("#currentdept").attr("disabled", true).removeAttr("onclick");
	$("#wfcreater").attr("disabled", true).removeAttr("onclick");
	$("#createrdept").attr("disabled", true).removeAttr("onclick");
	$("#currentdate").attr("disabled", true).removeAttr("onclick");
	//$("#id").attr("disabled", true);
	//$("#requestid").attr("disabled", true).removeAttr("onclick");
}
function Ok(){
	var sqlcontent = $("#fieldattr").val();
	LayoutEditFrameObj = parentWin.document;
	if(excel_isDetail === "on")
		LayoutEditFrameObj = parentWin.parentWin_Main.document;
	var sqlCheck = false;
	sqlCheck = checkSql(sqlcontent);
	var caltype = document.getElementById("caltype").value;
	var othertype = "";
	try{
		if(jQuery("#worddateonly").attr("checked")){
			othertype = "1";
		}else{
			othertype = "0";
		}
	}catch(e){}
	if(othertype=="")	othertype = "0";
	
	var transtype = "";
	try{
		if(jQuery("[name='transtype']:checked").length>0){
			transtype = jQuery("[name='transtype']:checked").val();
		}
	}catch(e){}
	if(transtype=="")	transtype = "0";
	
	var datasource = $("#datasource").val();
	
	if(sqlCheck == true){
		if(iscanuse == true){
			LayoutEditFrameObj.getElementById("fieldsql"+fieldid).value = sqlcontent;
			LayoutEditFrameObj.getElementById("datasource"+fieldid).value = datasource;
			LayoutEditFrameObj.getElementById("caltype"+fieldid).value = caltype;
			LayoutEditFrameObj.getElementById("othertype"+fieldid).value = othertype;
			LayoutEditFrameObj.getElementById("transtype"+fieldid).value = transtype;
			dialog.close();
		}else{
			if(confirm("<%=SystemEnv.getHtmlLabelName(26896,user.getLanguage())%>")){
				LayoutEditFrameObj.getElementById("fieldsql"+fieldid).value = sqlcontent;
				LayoutEditFrameObj.getElementById("datasource"+fieldid).value = datasource;
				LayoutEditFrameObj.getElementById("caltype"+fieldid).vlaue = caltype;
				LayoutEditFrameObj.getElementById("othertype"+fieldid).value = othertype;
				LayoutEditFrameObj.getElementById("transtype"+fieldid).value = transtype;
				dialog.close();
			}else{
				return false;
			}
		}
	}
}
function checkSql(sqlcontent){
	var sqlLowerCase = sqlcontent.toLowerCase();
	var pos1 = sqlLowerCase.indexOf("update");
	var pos2 = sqlLowerCase.indexOf("set");
	if(pos1>-1 && pos2>-1 && pos2>pos1){//有update语句
		alert("<%=SystemEnv.getHtmlLabelName(23813,user.getLanguage())+"update"+SystemEnv.getHtmlLabelName(23814,user.getLanguage())%>");
		return false;
	}
	pos1 = sqlLowerCase.indexOf("insert");
	if(pos1 > -1){//有insert语句
		alert("<%=SystemEnv.getHtmlLabelName(23813,user.getLanguage())+"insert"+SystemEnv.getHtmlLabelName(23814,user.getLanguage())%>");
		return false;
	}
	pos1 = sqlLowerCase.indexOf("delete");
	if(pos1 > -1){//有delete语句
		alert("<%=SystemEnv.getHtmlLabelName(23813,user.getLanguage())+"delete"+SystemEnv.getHtmlLabelName(23814,user.getLanguage())%>");
		return false;
	}
	pos1 = sqlLowerCase.indexOf("drop");
	if(pos1 > -1){//有drop语句
		alert("<%=SystemEnv.getHtmlLabelName(23813,user.getLanguage())+"drop"+SystemEnv.getHtmlLabelName(23814,user.getLanguage())%>");
		return false;
	}
	pos1 = sqlLowerCase.indexOf("alter");
	if(pos1 > -1){//有alter语句
		alert("<%=SystemEnv.getHtmlLabelName(23813,user.getLanguage())+"alter"+SystemEnv.getHtmlLabelName(23814,user.getLanguage())%>");
		return false;
	}
	return true;
}
function checkSql2(obj){
	var sqlcontent = obj.value;
    sqlcontent = sqlcontent.replace(/\+/g, "%2B");
    sqlcontent = sqlcontent.replace(/\&/g, "%26");
    var ds = $("#datasource").val();
    if(ds=="$ECOLOGY_SYS_LOCAL_POOLNAME"){
    	ds = "";
    }
	if(sqlcontent=="" || sqlcontent.indexOf("doFieldSQL")==-1){
		iscanuse = true;
		$("#noticeDiv").html("");
	}else{
		$.ajax({
			url : "/systeminfo/SqlCheckAjax.jsp?isFormMode=1",
			type : "post",
			data : "sql="+sqlcontent+"&datasourceid="+ds,
			dataType : "json",
			timeout:10000,
			success : function do4Success(json){
				var errormsg = "";
				if(json){
					iscanuse = json["isCanUse"];
					errormsg = json["errormsg"];
					if(errormsg=="-101"){
						errormsg = "<%=SystemEnv.getHtmlLabelName(27104,user.getLanguage())%>";
					}
					if(errormsg=="-102"){
						errormsg = "<%=SystemEnv.getHtmlLabelName(2012,user.getLanguage())%>";
					}
				}
				if(iscanuse==false){
					if(errormsg!=""){
						$("#noticeDiv").html(errormsg);
					}else{
						$("#noticeDiv").html("<%=SystemEnv.getHtmlLabelName(23818,user.getLanguage())%>");
					}
				}else{
					$("#noticeDiv").html("");
				}
			},
			error : function do4Error(request, textStatus, errorThrown){
				if(textStatus&&textStatus=="timeout"){
					$("#noticeDiv").html("<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())+SystemEnv.getHtmlLabelName(82879,user.getLanguage())+SystemEnv.getHtmlLabelName(21695,user.getLanguage())+SystemEnv.getHtmlLabelName(32264,user.getLanguage())%>");
				}else{
					$("#noticeDiv").html("<%=SystemEnv.getHtmlLabelName(23818,user.getLanguage())%>");
				}
			}
		});
	}
}
</script>
</head>
<body style='OVERFLOW: hidden' scroll='no'>


<div class="zDialog_div_content" id="zDialog_div_content" style="position:absolute;top:0px;bottom:40px;width:100%;">
	<wea:layout>
		<wea:group context="字段属性">
			<wea:item attributes="{'colspan':'full'}">
			
	<div style="height:10px!important;"></div>
	<table height="100%" width="100%">
		<tr>
			<td align="center" valign="top">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
			<colgroup>
			<col width="230px">
			<col width="140px">
			<col width="220px">
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
					<td align="left">
						<span style="font-size:14px; color:#63c66c;"><%=SystemEnv.getHtmlLabelName(23861,user.getLanguage())%></span>
						<div style="height:2px; width:75px;background:#63c66c;"></div>
						<div style="height:1px; width:190px; background:#b0b0b0;"></div>
					</td>
				</tr>
				
				<tr valign="top">
					<td align="left" >
						<div id="spanfieldlist"></div>
					</td>
					<td align="left" valign="top">
						<input type="hidden" id="caltype" name="caltype" value="0">
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr valign="top">
								<td width="100%">
									<button id="sqloperation" name="sqloperation" title="<%=SystemEnv.getHtmlLabelName(23748,user.getLanguage())%>" class="oper_btn" onclick="sqlOperation()" ><%=SystemEnv.getHtmlLabelName(23748,user.getLanguage())%></button>
									<span id="sqloperationspan"></span>
								</td>
							</tr>
							<tr valign="top">
								<td width="100%">
									<button id="sumoperation" name="sumoperation" title="<%=SystemEnv.getHtmlLabelName(261,user.getLanguage())+SystemEnv.getHtmlLabelName(21845,user.getLanguage())%>" class="oper_btn" onclick="sumOperation()" ><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())+SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></button>
									<span id="sumoperationspan"></span>
								</td>
							</tr>
							<tr valign="top">
								<td width="100%">
									<button id="dateoperation" name="dateoperation" title="<%=SystemEnv.getHtmlLabelName(27812,user.getLanguage())%>" class="oper_btn" onclick="dateOperation()" ><%=SystemEnv.getHtmlLabelName(27812,user.getLanguage())%></button>
									<span id="dateoperationspan"></span>
								</td>
							</tr>
							<tr valign="top">
								<td width="100%">
									<button id="mapoperation" name="mapoperation" title="<%=SystemEnv.getHtmlLabelName(126784,user.getLanguage()) %>" class="oper_btn" onclick="mapOperation()" ><%=SystemEnv.getHtmlLabelName(126784,user.getLanguage()) %></button>
									<span id="mapoperationspan"></span>
								</td>
							</tr>
						</table>
					</td>
					<td align="left" valign="top">
						<div class="fieldlist">
							<div id="currentuser" onclick="insertMark(' $currentuser$ ')">
								<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(17482,user.getLanguage())%>
							</div>
							<div id="currentdept" onclick="insertMark(' $currentdept$ ')">
								<%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())+SystemEnv.getHtmlLabelName(15393,user.getLanguage())%>
							</div>
							<div id="currentdate" onclick="insertMark(' $currentdate$ ')">
								<%=SystemEnv.getHtmlLabelName(15625,user.getLanguage())%>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="3" align="left" height="0"><div id="noticeDiv" style="height:0px;color:#ff0000;"></div>
					</td>
				</tr>
				<tr>
					<td align="left" colspan="3">
						<div id="fieldtransdiv" style="display:none">
						<span><input type="radio" id="transtype1" name="transtype" value="1" /><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></span>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<span><input type="radio" id="transtype2" name="transtype" value="2" /><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></span>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<span><input type="radio" id="transtype0" name="transtype" value="0" /><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></span>
						&nbsp;&nbsp;&nbsp;&nbsp;
						</div>
						<div id="worddateonlydiv" style="display:none">
						<input type="checkbox" id="worddateonly" name="worddateonly" value="1" /><%=SystemEnv.getHtmlLabelName(27813,user.getLanguage())%>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="#" onclick="insertMark(' $datetime$ ')" ><%=SystemEnv.getHtmlLabelName(27814,user.getLanguage())%></a>
						<br>&nbsp;
							<font color="#ff0000">
						<%if(user.getLanguage() == 7){%>
							暂时只支持日期[合并时间]字段间的减法，以及日期[合并时间]字段与整数的加减法。
						<%}else if(user.getLanguage() == 8){%>
							Supports only for the date [unite time] field subtraction, and the date [unite time] field with integer addition and subtraction.
						<%}else if(user.getLanguage() == 9){%>
							暫時隻支持日期[合并時間]字段間的減法，以及日期[合并時間]字段與整數的加減法。
						<%}%>
							</font>
						</div>
						<textarea id="fieldattr" name="fieldattr" rows="7" style="width:95%" onchange="checkSql2(this)"></textarea>
						<div id="dataSourceDiv" style="padding:10px 0px;display: none;" >
							<span ><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage()) %>：</span>
							<select id="datasource" name="datasource" notBeauty=true style="width:200px;" onchange="checkSql2(fieldattr)" >
								<option value="" ></option>
								<option value="<%=DataSourceXML.SYS_LOCAL_POOLNAME%>">local</option>
							` <%
								List pointArrayList = DataSourceXML.getPointArrayList();
								for(int i=0;i<pointArrayList.size();i++){
								    String pointid = (String)pointArrayList.get(i);
								    String dbType = Util.null2String(DataSourceXML.getDataSourceDBType(pointid));
								    boolean isEffective = VirtualFormHandler.getDSIsEffectiveWithMode(pointid,dbType);
								    if(!isEffective){
								    	continue;
								    }
							   %>
								<option value="<%=pointid %>"><%=pointid+" ["+dbType+"]" %></option>
								<%} %>
							</select>
							<span title="<%=SystemEnv.getHtmlLabelName(126768, user.getLanguage()) %>" id="remind">
								<img align="absMiddle" src="/images/remind_wev8.png">
							</span>
							<div id="datasourceNoExists" style="display:none;color:red;padding:5px 0px;"></div>
						</div>
						<div id="mapinfodiv" style="display: none;color: red;"><%=SystemEnv.getHtmlLabelName(127293 , user.getLanguage()) %>：doFieldMap("",D)，<%=SystemEnv.getHtmlLabelName(127294 , user.getLanguage()) %>：doFieldMap("",S)。</div>
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
function cool_webcontrollabel(vthis){
	var textvalue = "$"+jQuery(vthis).find("input[type='hidden']").val()+"$";
	if(isDisabled == false){
		insertIntoTextarea(textvalue);
	}
}
function sqlOperation(){
	var fieldattr = document.getElementById("fieldattr").value;
	var textvalue = "doFieldSQL(\"  \")";
	if(fieldattr.indexOf("doField")>-1 && fieldattr.indexOf("doFieldSQL")==-1){//有设置过，但曾经的设置不是FieldSQL
		if(confirm("<%=SystemEnv.getHtmlLabelName(23820,user.getLanguage())%>")){
			document.getElementById("fieldattr").value = textvalue;
			showEscPara(1);
			$("#worddateonlydiv").hide();
		}		
	}else if(fieldattr.indexOf("doFieldSQL") == -1){
		insertIntoTextarea(textvalue);
		showEscPara(1);
		$("#worddateonlydiv").hide();
	}
	onchangeSFields(1);
	checkSql2($("#fieldattr").get(0));
}
function sumOperation(){
	var fieldattr = document.getElementById("fieldattr").value;
	var textvalue = "doFieldMath(\"  \")";
	if(fieldattr.indexOf("doField")>-1 && fieldattr.indexOf("doFieldMath")==-1){//有设置过，但曾经的设置不是FieldMath
		if(confirm("<%=SystemEnv.getHtmlLabelName(23820,user.getLanguage())%>")){
			document.getElementById("fieldattr").value = textvalue;
			showEscPara(2);
			onchangeSFields(2);
		}
	}else if(fieldattr.indexOf("doFieldMath") == -1){
		insertIntoTextarea(textvalue);
		showEscPara(2);
		onchangeSFields(2);
	}
	//checkSql2($("#fieldattr").get(0));
}
function dateOperation(){
	var fieldattr = document.getElementById("fieldattr").value;
	var textvalue = "doFieldDate(\"  \")";
	if(fieldattr.indexOf("doField")>-1 && fieldattr.indexOf("doFieldDate")==-1){//有设置过，但曾经的设置不是FieldMath
		if(confirm("<%=SystemEnv.getHtmlLabelName(23820,user.getLanguage())%>")){
			document.getElementById("fieldattr").value = textvalue;
			showEscPara(3);
			onchangeSFields(3);
		}
	}else if(fieldattr.indexOf("doFieldDate") == -1){
		insertIntoTextarea(textvalue);
		showEscPara(3);
		onchangeSFields(3);
	}else{
		$("#worddateonlydiv").show();
	}
}

function mapOperation(){
	var fieldattr = document.getElementById("fieldattr").value;
	//var inputname = oActiveEl.name;
//	var fieldid = inputname.substring(5, inputname.length);
	
	var textvalue = "doFieldMap(\" $"+fieldid+"$ \")";
	if(layouttype=="0"){
		textvalue = "doFieldMap(\" $"+fieldid+"$ \",D)";
	}
	if(fieldattr.indexOf("doField")>-1 && fieldattr.indexOf("doFieldMap")==-1){
		if(confirm("<%=SystemEnv.getHtmlLabelName(23820,user.getLanguage())%>")){
			document.getElementById("fieldattr").value = textvalue;
			showEscPara(5);
			onchangeSFields(5);
		}
	}else if(fieldattr.indexOf("doFieldMap") == -1){
		insertIntoTextarea(textvalue);
		showEscPara(5);
		$("#worddateonlydiv").hide();
	}
	onchangeSFields(5);
}

function insertIntoTextarea(textvalue){
	var obj = document.getElementById("fieldattr");
	obj.focus();
	if(document.selection){		//IE下，此方式操作不需设置鼠标焦点
		document.selection.createRange().text = textvalue;
	}else{
		var set_cursor_p = obj.selectionStart + textvalue.length;
		obj.value = obj.value.substr(0, obj.selectionStart) + textvalue + obj.value.substr(obj.selectionEnd);
		obj.setSelectionRange(set_cursor_p, set_cursor_p);		//设置鼠标焦点
	}
	checkSql2($("#fieldattr").get(0));
}

function insertMark(textvalue){
	insertIntoTextarea(textvalue);
}
//type:1,sql;0,sum;2,date
function showEscPara(type){
	document.getElementById("sqloperationspan").innerHTML = "";
	document.getElementById("sumoperationspan").innerHTML = "";
	document.getElementById("dateoperationspan").innerHTML = "";
	document.getElementById("mapoperationspan").innerHTML = "";
	if(type == 1){
		$("#dataSourceDiv").show();
	}else{
		$("#dataSourceDiv").hide();
	}
	if(type == 1){//sql
		$("#currentuser").attr("disabled", false);
		$("#currentdept").attr("disabled", false);
		$("#wfcreater").attr("disabled", false);
		$("#createrdept").attr("disabled", false);
		$("#currentdate").attr("disabled", false);
		//$("#id").attr("disabled", false);
		//$("#requestid").attr("disabled", false);
		document.getElementById("sqloperationspan").innerHTML = "<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
	}else if(type == 2){//sum
		$("#currentuser").attr("disabled", true);
		$("#currentdept").attr("disabled", true);
		$("#wfcreater").attr("disabled", true);
		$("#createrdept").attr("disabled", true);
		$("#currentdate").attr("disabled", true);
		//$("#id").attr("disabled", true);
		//$("#requestid").attr("disabled", true);
		document.getElementById("sumoperationspan").innerHTML = "<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
	}else if(type == 3){//date
		$("#currentuser").attr("disabled", true);
		$("#currentdept").attr("disabled", true);
		$("#wfcreater").attr("disabled", true);
		$("#createrdept").attr("disabled", true);
		$("#currentdate").attr("disabled", false);
		//$("#id").attr("disabled", true);
		//$("#requestid").attr("disabled", true);
		document.getElementById("dateoperationspan").innerHTML = "<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
	}else if(type==5){//map
		$("#currentuser").attr("disabled", true);
		$("#currentdept").attr("disabled", true);
		$("#wfcreater").attr("disabled", true);
		$("#createrdept").attr("disabled", true);
		$("#currentdate").attr("disabled", true);
		$("#id").attr("disabled", true);
		document.getElementById("mapoperationspan").innerHTML = "<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
	}
	//GetE("caltype").value = type;
	jQuery("#caltype").val(type);
}
function onchangeSFields(type){
	$("#worddateonlydiv").hide();
	//$("#fieldtransdiv").hide();
	$("#mapinfodiv").hide();
	LayoutEditFrameObj = parentWin.document;
	if(excel_isDetail === "on")
		LayoutEditFrameObj = parentWin.parentWin_Main.document;
	var selectOuterHtml = LayoutEditFrameObj.getElementById("labellist"+fieldGroupid).outerHTML;
	while(selectOuterHtml.indexOf("size=15") > -1){
		selectOuterHtml = selectOuterHtml.replace("size=15", "size=7");
	}
	$("#spanfieldlist").html(selectOuterHtml);
	if(type == 1){
		if(isDetail==1){
			$("#labellist"+fieldGroupid).prepend(LayoutEditFrameObj.getElementById("labellist-1").innerHTML);
		}
		$("#labellist"+fieldGroupid).show();
		$("#worddateonlydiv").hide();
	}else if(type == 2){
		var inputFieldids = LayoutEditFrameObj.getElementById("inputFieldids").value;
		$("#labellist"+fieldGroupid+" input").each(function(){
			if((","+inputFieldids+",").indexOf(","+$(this).val()+",") == -1){
				$(this).parent().remove();
			}
		});
		$("#labellist"+fieldGroupid).show();
		$("#worddateonlydiv").hide();
	}else if(type == 3){
		var zhengshuFields = LayoutEditFrameObj.getElementById("zhengshuFields").value;
		var dateFields = LayoutEditFrameObj.getElementById("dateFields").value;
		var canDateSumFields = zhengshuFields + "," + dateFields;
		$("#labellist"+fieldGroupid+" input").each(function(){
			if((","+canDateSumFields+",").indexOf(","+$(this).val()+"_"+isDetail+",") == -1){
				$(this).parent().remove();
			}
		});
		$("#labellist"+fieldGroupid).show();
		$("#worddateonlydiv").show();
	}else if(type==5){
		var mapFields = LayoutEditFrameObj.getElementById("mapFields").value;
		$("#labellist"+fieldGroupid+" input").each(function(){
			if((","+mapFields+",").indexOf(","+$(this).val()+"_"+isDetail+",") == -1){
				$(this).parent().remove();
			}
		});
		$("#labellist"+fieldGroupid).show();
		if(LayoutEditFrameObj.getElementById("layouttype").value=='0'){
			$("#mapinfodiv").show();
		}
	}

}

jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
 
});
</script>
</html>