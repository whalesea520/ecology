<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.virtualform.ExtendDSHandler"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.service.AppInfoService"%>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" />
<%@ include file="/formmode/pub.jsp"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int appId = Util.getIntValue(request.getParameter("appId"), 0);

FormInfoService formInfoService = new FormInfoService();
ExtendDSHandler extendDSHandler = ExtendDSHandler.getInstance();

String errorMsg = Util.null2String(request.getParameter("errorMsg"));
errorMsg = xssUtil.get(errorMsg);
int subCompanyId = -1;
if(subCompanyId==-1){
	AppInfoService appInfoService = new AppInfoService();
	Map<String, Object> appInfo = appInfoService.getAppInfoById(appId);
	subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
}

String userRightStr = "FORMMODEFORM:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
int currentSubCompanyId = Util.getIntValue(Util.null2String(rightMap.get("currentSubCompanyId")),-1);
String subCompanyId3 = ""+currentSubCompanyId;
%>
<html>
<head>
	<title></title>
	<!-- 
	<script type="text/javascript" src="/js/weaver_wev8.js"></script> 
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>-->
	<SCRIPT language="javascript" src="/js/init_wev8.js" type="text/javascript"></SCRIPT>
	
	<LINK href="/wui/theme/ecology8/templates/default/css/default2_wev8.css" rel="stylesheet"  type="text/css"> 	  
	<SCRIPT src="/wui/theme/ecology8/templates/default/js/default_wev8.js" type="text/javascript"></SCRIPT>
	
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<style>
	*{
		font: 12px Microsoft YaHei;
	}
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
		overflow: auto;
	}
	textarea{overflow:auto;}
	.e8_tblForm{
		width: 100%;
		margin: 0 0;
		border-collapse: collapse;
	}
	.e8_tblForm .e8_tblForm_label{
		vertical-align: top;
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 2px;
	}
	.e8_tblForm .e8_tblForm_field{
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
	}
	.e8_label_desc{
		color: #aaa;
	}
	#vtablenameSearch,#vpkgentypewrap{
		width:125px; border: 0px;background-color: #fff;background-image: url('/formmode/images/btnSearch_wev8.png');background-repeat: no-repeat;background-position: 108px center;
	}
	#vtablenameTip, #vpkgentypeTip{
		position: absolute;left: 5px;top: 2px;color: #ccc;font: 12px Microsoft YaHei;font-style: italic;
	}
	#vtableName_loading{
		position: absolute;top: 0px;left: 5px;z-index: 10000;
		padding: 3px 10px 3px 20px; 
		vertical-align:middle; 
		background-image: url('/images/messageimages/loading_wev8.gif');
		background-repeat: no-repeat;
		background-position: 0px center;
		color: #aaa;
		display: none;
	}
	#vtablefield_loading{
		position: absolute;top: 0px;left: 0px;z-index: 10000;
		background-image: url('/images/messageimages/loading_wev8.gif');
		background-repeat: no-repeat;
		background-position: 5px center;
		padding: 4px 0px 2px 25px; 
		background-color: #fff;
		color: #aaa;
		width: 175px;
		display: none;
	}
	#vprimaryKey_loading{
		position: absolute;top: 0px;left: 5px;z-index: 10000;
		padding: 3px 10px 3px 20px; 
		vertical-align:middle; 
		background-image: url('/images/messageimages/loading_wev8.gif');
		background-repeat: no-repeat;
		background-position: 0px center;
		color: #aaa;
		display: none;
	}
	#vtablefieldContainer{
		margin: 0px;
		padding: 0px;
		height: 120px;
		overflow: auto;
	}
	#vtablefieldContainer ul{
		margin: 0px;
		padding: 0px;
		list-style: none;
	}
	#vtablefieldContainer ul li{
		padding:1px 0px;
	}
	.listResult{
		position: absolute;
		right: 65px;
		z-index: 100001;
		margin: 0px;
		padding: 3px 5px;
		height: 97px;
		width: 250px;
		overflow: auto;
		background-color: #fff;
		border: 1px solid #e9e9e9;
		display: none;
	}
	.listResult ul{
		margin: 0px;
		padding: 0px;
		list-style: none;
	}
	.listResult ul li{
		border-bottom: #eee 1px dotted;
	}
	.listResult ul li a{
		padding: 2px 0px 2px 2px;
		text-decoration: none;
		color: #333;
		display: block;
	}
	.listResult ul li a:hover{
		background-color: #0072C6;
		color: #fff;
	}
	.listResult ul li .tip{
		padding: 2px 0px 2px 2px;
		color: #ccc;
	}
	#vtableNameSrarchResult{
		top: 232px;
	}
	#vpkGenTypeChooseResult{
		top: 265px;
		height: 70px;
	}
	#vpkgentypeEditFlag{
		width: 16px;height: 16px;position: absolute;right: 2px;top: 2px;background:transparent url('/formmode/images/list_edit_wev8.png') no-repeat !important;
		display: none;
		cursor: pointer;
	}
	a{
		text-decoration: none !important;
	}
	</style>
<script type="text/javascript">
jQuery(document).ready(function ($) {
	
	<%if(!errorMsg.equals("")){%>
		setErrorMsg("<%=SystemEnv.getHtmlLabelName(82087,user.getLanguage())%>", "<%=errorMsg%>");//表单保存时发生如下错误：
	<%}%>
	
	try{
		document.getElementById("formname").focus();
	}catch(e){}
	
	try{
		var h = $(document.body).height() - $("table.e8_tblForm").height();
		if(h > 0){
			var oldH = $("#vtablefieldContainer").height();
			$("#vtablefieldContainer").height(oldH + h - 1);
		}
	}catch(e){}
	
	initVtablenameSearch();
	
	initVpkGenTypeChoose();
});

function formtypechange(){
	var $ = jQuery;
	var $vtable_tr = $("#vtable_tr");
	var formtypeV = $("#formtype").val();
	if(formtypeV == "1"){
		$vtable_tr.show();
	}else{
		$vtable_tr.hide();
	}
}

function vdatasourcechange(){
	var $ = jQuery;
	resetErrorMsg();
	var $vtableName = $("#vtableName");
	$vtableName.find("option").remove();
	
	var $vdatasource = $("#vdatasource");
	var vdatasourceV = $vdatasource.val();
	if(vdatasourceV != ""){
		$vdatasource.attr("disabled","true");
		$vtableName.attr("disabled","true");
		var $vtableName_loading = $("#vtableName_loading");
		$vtableName_loading.show();
		var url = "/formmode/setup/formSettingsAction.jsp?action=getTablesByDS&dsName="+vdatasourceV;
		FormmodeUtil.doAjaxDataLoad(url, function(result){
			var status = result.status;
			if(status == "1"){
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var table_name = data[i]["table_name"];
					var table_type = data[i]["table_type"];
					var showText = table_name + (table_type == "TABLE" ? " [<%=SystemEnv.getHtmlLabelName(31902,user.getLanguage())%>]" : (table_type == "VIEW" ? " [<%=SystemEnv.getHtmlLabelName(32559,user.getLanguage())%>]" : ""));//表  视图
					var virtualformtype = table_type == "TABLE" ? 0 : (table_type == "VIEW" ? 1 : "");
					var optionHtml = "<option value=\""+table_name+"\" virtualformtype=\""+virtualformtype+"\">"+showText+"</option>";
					$vtableName.append(optionHtml);
				}
				vtableNamechange();
			}else{
				var errorMsg = result.errorMsg;
				errorMsg+="<p><a href='javascript:vdatasourcechange()'><%=SystemEnv.getHtmlLabelName(128168, user.getLanguage()) %></a>";
				setErrorMsg("<%=SystemEnv.getHtmlLabelName(82088,user.getLanguage())%>", errorMsg);//获取表(视图)时发生如下错误：
			}
			$vdatasource.removeAttr("disabled");
			$vtableName.removeAttr("disabled");
			$vtableName_loading.hide();
		});
	}	
}

function vtableNamechange(){
	var $ = jQuery;
	resetErrorMsg();
	
	var $vtablefieldContainer = $("#vtablefieldContainer");
	$vtablefieldContainer.empty();
	
	var $vdatasource = $("#vdatasource");
	var vdatasourceV = $vdatasource.val();
	
	var $vtableName = $("#vtableName");
	var vtableNameV = $vtableName.val();
	
	if(vdatasourceV != "" && vtableNameV != ""){
		$vdatasource.attr("disabled","true");
		$vtableName.attr("disabled","true");
		var $vtablefield_loading = $("#vtablefield_loading");
		$vtablefield_loading.show();
		
		var $vprimarykey = $("#vprimarykey");
		$vprimarykey.attr("disabled","true");
		var $vprimaryKey_loading = $("#vprimaryKey_loading");
		$vprimaryKey_loading.show();
		$vprimarykey.find("option").remove();
		
		var url = "/formmode/setup/formSettingsAction.jsp?action=getFieldsByTable&formType=1&dsName="+vdatasourceV+"&tbName="+vtableNameV;
		FormmodeUtil.doAjaxDataLoad(url, function(result){
			var status = result.status;
			if(status == "1"){
				var data = result.data;
				var $fieldUL = $("<ul></ul>");
				for(var i = 0; i < data.length; i++){
					var column_name = data[i]["column_name"];
					$fieldUL.append("<li><input type=\"checkbox\" value=\""+column_name+"\" name=\"vfieldName\" checked=\"checked\"/>&nbsp;"+column_name+"</li>");
					
					var selectedHtml = "";
					if(column_name.toUpperCase() == "ID"){
						selectedHtml = " selected=\"selected\"";
					}
					var optionHtml = "<option value=\""+column_name+"\""+selectedHtml+">"+column_name+"</option>";
					$vprimarykey.append(optionHtml);
				}
				$vtablefieldContainer.append($fieldUL);
				$vtablefieldContainer.jNice();
			}else{
				var errorMsg = result.errorMsg;
				setErrorMsg("<%=SystemEnv.getHtmlLabelName(82089,user.getLanguage())%>", errorMsg);//获取字段列表时发生如下错误：
			}
			$vdatasource.removeAttr("disabled");
			$vtableName.removeAttr("disabled");
			$vprimarykey.removeAttr("disabled");
			$vprimaryKey_loading.hide();
			$vtablefield_loading.hide();
		});
	}
}

function setErrorMsg(title, content){
	$("#errorMsgTitle").html(title);
	$("#errorMsgContent").html(content);
	$("#errorMsgContainer").show();
}

function resetErrorMsg(){
	$("#errorMsgTitle").html("");
	$("#errorMsgContent").html("");
	$("#errorMsgContainer").hide();
}

var preSearchText = "";
function initVtablenameSearch(){
	var $searchText = $("#vtablenameSearch");
	var $searchTextTip = $("#vtablenameTip");
	
	$searchTextTip.click(function(e){
		$searchText[0].focus();
		e.stopPropagation(); 
	});
	
	$searchText.focus(function(){
		$searchTextTip.hide();
	});
	
	$searchText.blur(function(){
		if(this.value == ""){
			$searchTextTip.show();
		}
	});
	
	$searchText.click(function(e){
		e.stopPropagation(); 
	});
	
	var $vtableNameSrarchResult = $("#vtableNameSrarchResult");
	function hideSearchResult(){
		$vtableNameSrarchResult.hide();	
	}
	
	var pFlag = true;
	function showSearchResult(){
		if(pFlag){
			pFlag = false;
			try{
				var offset = $searchText.offset();
				var t = offset.top + $searchText.height() + 6;
				var r = $(document.body).width() - (offset.left + $searchText.width()) - 3;
				$vtableNameSrarchResult.css({"top": (t+"px"), "right": (r+"px")});
			}catch(e){}
		}
		$vtableNameSrarchResult.show();	
	}
	
	function clearSearchResult(){
		$vtableNameSrarchResult.children("ul").find("*").remove();	
	}
	
	$searchText.keyup(function(event){
		if(this.value == ""){
			preSearchText = "";
			hideSearchResult();
			clearSearchResult();
		}else{
			if(this.value != preSearchText){
				preSearchText = this.value;
				var searchValue = this.value;
				//clearSearchResult();
				
				var resultHtml = "";
				
				var $vtableName = $("#vtableName");
				$vtableName.find("option").each(function(){
					var vt = $(this).attr("value");
					if(vt.toLowerCase().indexOf(searchValue) != -1){
						resultHtml += "<li><a href=\"javascript:setVtableNameSelected('"+vt+"');\">"+vt+"</a></li>";
					}
				});
				
				if(resultHtml == ""){
					resultHtml = "<li><font class='tip'><%=SystemEnv.getHtmlLabelName(82090,user.getLanguage())%></font></li>";//无匹配的结果
				}
				
				$vtableNameSrarchResult.children("ul").html(resultHtml);
				
				showSearchResult();
			}
		}
	});
	
	$(document.body).bind("click", function(){
		hideSearchResult();
	});
}

function setVtableNameSelected(vtableNameV){
	$("#vtableName").val(vtableNameV);
	
	preSearchText = "";
	var $searchText = $("#vtablenameSearch");
	$searchText.val("");
	$searchText.trigger("blur");
	
	vtableNamechange();
}

function corVtablefield(){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $vfieldName = $("input[type='checkbox'][name='vfieldName']");
		var vtablefieldFlag = document.getElementById("vtablefieldFlag");
		$vfieldName.each(function(){
			//changeCheckboxStatus(this, vtablefieldFlag.checked);
			$(this).attr("checked", vtablefieldFlag.checked);
			if(vtablefieldFlag.checked){
				jQuery(this).next("span.jNiceCheckbox").addClass("jNiceChecked");
			}else{
				jQuery(this).next("span.jNiceCheckbox").removeClass("jNiceChecked");
			}
		});
	},100);
}

function onSave() {
	rightMenu.style.visibility = "hidden";
	
	var $ = jQuery;
	var formname = $("#formname").val();
	if(formname == ""){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(82091,user.getLanguage())%>", function(){//请填写表单名称
			$("#formname")[0].focus();
		}, null, null, true);
		return;
	}
	
	var formtype = $("#formtype").val();
	if(formtype == "1"){ //虚拟表单
		var vdatasource = $("#vdatasource").val();
		if(vdatasource == ""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82092,user.getLanguage())%>", function(){//请选择数据源
				$("#vdatasource")[0].focus();
			}, null, null, true);
			return;
		}
		
		var vtableName = $("#vtableName").val();
		if(!vtableName || vtableName == ""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82093,user.getLanguage())%>", function(){//请选择表(视图)
				$("#vtableName")[0].focus();
			}, null, null, true);
			return;
		}
		
		var vprimarykey = $("#vprimarykey").val();
		if(!vprimarykey || vprimarykey == ""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82096,user.getLanguage())%>", function(){//请选择主键字段
				$("#vprimarykey")[0].focus();
			}, null, null, true);
			return;
		}
		
		var vpkgentype = $("#vpkgentype").val();
		if(!vpkgentype || vpkgentype == ""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82097,user.getLanguage())%>", function(){//请选择主键生成策略
				$("#vpkgentypewrap").trigger("click");
			}, null, null, true);
			return;
		}
		
		var $ck_vfieldName = $("input[type='checkbox'][name='vfieldName']:checked");
		if($ck_vfieldName.length == 0){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82098,user.getLanguage())%>", function(){//请选择字段
			}, null, null, true);
			return;
		}
		
		var virtualformtypeV = $("#vtableName option:selected").attr("virtualformtype");
		$("#virtualformtype").val(virtualformtypeV);
		
		enableAllmenu();
		document.getElementById("formAdd").submit();
		
	}else{
		enableAllmenu();
		document.getElementById("formAdd").submit();	
	}
	
}
/*
function onClose(){
	parent.closeFormDlg();
}*/

function initVpkGenTypeChoose(){
	var $vpkgentypewrap = $("#vpkgentypewrap");
	var $vpkgentypeTip = $("#vpkgentypeTip");
	var $vpkGenTypeChooseResult = $("#vpkGenTypeChooseResult");
	
	var offset = $vpkgentypewrap.offset();
	var t = offset.top + $vpkgentypewrap.height() + 6;
	var r = $(document.body).width() - (offset.left + $vpkgentypewrap.width()) - 3;
	$vpkGenTypeChooseResult.css({"top": (t+"px"), "right": (r+"px")});
				
	$vpkgentypeTip.click(function(e){
		$vpkGenTypeChooseResult.show();
		e.stopPropagation(); 
	});
	
	$vpkgentypewrap.click(function(e){
		$vpkGenTypeChooseResult.show();
		e.stopPropagation(); 
	});
	
	$(document.body).bind("click", function(){
		$vpkGenTypeChooseResult.hide();
	});
}

function setVpkGenTypeChoose(theA){
	var $theA = $(theA);
	var v = $theA.attr("vpkGenTypeVal");
	var t = $theA.attr("vpkGenTypeText");
	
	$("#vpkgentypewrap").val(t);
	$("#vpkgentype").val(v);
	
	$("#vpkgentypeTip").hide();
	
	var $vpkgentypeEditFlag = $("#vpkgentypeEditFlag");
	if(v == "3"){
		$vpkgentypeEditFlag.show();
	}else{
		$vpkgentypeEditFlag.hide();
	}
}

function openCodeEdit(){
	parent.parent.openCodeEdit();
}
</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="errorMsgContainer" style="border: 1px solid red;margin: 3px 0px;padding: 3px;display: none;">
	<div id="errorMsgTitle" style="color: red;font-weight: bold;"></div>
	<div style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="errorMsgContent"></span></div>
</div>

<div id="vtableNameSrarchResult" class="listResult">
	<ul>
	</ul>
</div>

<div id="vpkGenTypeChooseResult" class="listResult">
	<ul>
		<li style="border-bottom-color:#ccc;color: #ccc;padding: 2px;"><%=SystemEnv.getHtmlLabelName(82099,user.getLanguage())%></li><!-- 请根据表情况在以下策略中选择一种 -->
		<%
			Map<String, String> map = new HashMap<String, String>();
			map.put("1", SystemEnv.getHtmlLabelName(83174 , user.getLanguage()));
			map.put("2", SystemEnv.getHtmlLabelName(83175 , user.getLanguage()));
			//map.put("3", SystemEnv.getHtmlLabelName(83176 , user.getLanguage()));
			Map<String, String> pkTypeIdMap = new TreeMap<String, String>(map);
			Set<Map.Entry<String, String>> entrySet = pkTypeIdMap.entrySet();
			Iterator<Map.Entry<String, String>> it = entrySet.iterator();
			while(it.hasNext()) {
				Map.Entry<String, String> entry = it.next();
				String pkTypeId = entry.getKey();
				String pkTypeText = entry.getValue();
		%>
			<li><a href="javascript:void(0);" onclick="javascript:setVpkGenTypeChoose(this);" vpkGenTypeVal="<%=pkTypeId %>" vpkGenTypeText=" <%=pkTypeText %>"><%=pkTypeId %>. <%=pkTypeText %></a></li>
		<%  } %>
</ul>
</div>

<form id="formAdd" name="formAdd" method="post" action="/formmode/setup/formSettingsAction.jsp?action=addform">
<input type="hidden" id="appId" name="appId" value="<%=appId %>"/>
<input type="hidden" id="virtualformtype" name="virtualformtype"/>
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td><!-- 表单名称 -->
	<td class="e8_tblForm_field">
		<input type="text" style="width:80%;border: 1px solid #e9e9e2;height: 22px" id="formname" name="formname" value="" onchange="checkinput('formname','formnameImage')"/>
		<span id="formnameImage">
			<img src="/images/BacoError_wev8.gif"/></td>
		</span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%><!-- 表单描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82100,user.getLanguage())%><!-- 描述表单的基本功能 --></div></td>
	<td class="e8_tblForm_field">
		<textarea name="formdes" style="width:80%;height:40px;"></textarea>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%><!-- 表单类型 --></td>
	<td class="e8_tblForm_field">
		<select name="formtype" id="formtype" onchange="javascript:formtypechange();" disabled="disabled">
			<option value="0"><%=SystemEnv.getHtmlLabelName(33886,user.getLanguage())%><!-- 实际表单 --></option>
			<option value="1" selected="selected"><%=SystemEnv.getHtmlLabelName(33885,user.getLanguage())%><!-- 虚拟表单 --></option>
		</select>
	</td>
</tr>
<tr style="/*display: none;*/" id="vtable_tr">
	<td class="e8_tblForm_label" colspan="2" style="padding: 0px;">
		<table class="e8_tblForm">
			<tr>
				<td class="e8_tblForm_label"  width="20%"><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%><!-- 数据源 --></td>
				<td class="e8_tblForm_field">
					
					<% List<String> dsNames = extendDSHandler.getDSNames(); %>
					<select name="vdatasource" id="vdatasource" notBeauty=true style="width: 200px;" onchange="javascript:vdatasourcechange();">
						<option value="" selected="selected"></option>
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
					<span style="cursor: pointer;margin-left: 10px;" onclick="window.open('/integration/integrationTab.jsp?urlType=3');"><%=SystemEnv.getHtmlLabelName(23660,user.getLanguage())%><!-- 配置数据源 --></span>
				</td>
			</tr>
			<tr>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82101,user.getLanguage())%><!-- 表(视图)名 --></td>
				<td class="e8_tblForm_field">
					<div style="position: relative;">
						<select name="vtableName" id="vtableName" notBeauty=true style="width: 200px;" onchange="javascript:vtableNamechange();">
							
						</select>
						
						<span style="margin-left: 15px; position: relative;">
							<INPUT id="vtablenameSearch" type="text"/>
							<div id="vtablenameTip"><%=SystemEnv.getHtmlLabelName(82102,user.getLanguage())%><!-- 在表名中检索... --></div>
						</span>
						
						<div id="vtableName_loading" style=""><%=SystemEnv.getHtmlLabelName(82048,user.getLanguage())%><!-- 数据加载中，请等待... --></div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82103,user.getLanguage())%><!-- 主键字段 --></td>
				<td class="e8_tblForm_field">
					<div style="position: relative;">
						<select name="vprimarykey" notBeauty=true id="vprimarykey" style="width: 200px;">
							
						</select>
						<span style="margin-left: 15px; position: relative;padding-right: 25px;">
							<INPUT id="vpkgentypewrap" type="text" readonly="readonly" style="cursor: pointer;color: #666;" value=""/>
							<INPUT id="vpkgentype" name="vpkgentype" type="hidden" value=""/>							
							<div id="vpkgentypeTip"><%=SystemEnv.getHtmlLabelName(82097,user.getLanguage())%><!-- 选择主键生成策略 --></div>
							
							<div id="vpkgentypeEditFlag" onclick="openCodeEdit();"></div>
						</span>
						
						<div id="vprimaryKey_loading"><%=SystemEnv.getHtmlLabelName(82048,user.getLanguage())%><!-- 加载中，请等待... --></div>
					</div>
				</td>
			</tr>
			<%if(fmdetachable.equals("1")){%>
				<tr >
						<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%><!-- 所属分部 --></td>
						<td class="e8_tblForm_field">
						<brow:browser name="subCompanyId3" viewType="0" hasBrowser="true" hasAdd="false" 
					        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=FORMMODEFORM:ALL" isMustInput="2" isSingle="true" hasInput="true"
					        completeUrl="/data.jsp?type=164_1&rightStr=FORMMODEFORM:ALL"  width="260px" browserValue='<%=subCompanyId3%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId3)%>' />
						</td>
					</tr>
					<%}else{%>
						<input type="hidden" name="subCompanyId3" id="subCompanyId3" value="<%=subCompanyId3 %>" />
					<%} %>
			<tr>
				<td class="e8_tblForm_label" style="vertical-align: top; height: 30px;padding-top: 6px;">
					<%=SystemEnv.getHtmlLabelName(82104,user.getLanguage())%><!-- 字段列表 -->
					<input type="checkbox" id="vtablefieldFlag" name="vtablefieldFlag" value="1" checked="checked" onclick="javascript:corVtablefield();"/>
				</td>
				<td class="e8_tblForm_field" style="vertical-align: top;">
					<div style="position: relative;">
						<div id="vtablefield_loading" ><%=SystemEnv.getHtmlLabelName(82048,user.getLanguage())%><!-- 数据加载中，请等待... --></div>
						<div id="vtablefieldContainer">
							
						</div>
					</div>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>

</form>
</body>
</html>
