<%@page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.mec.MECManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.mobile.mec.MECManager"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

int appid = Util.getIntValue(Util.null2String(request.getParameter("appid")));

String picpath = Util.null2String(request.getParameter("picpath"));
String showname = Util.null2String(request.getParameter("showname"));
String source_type = Util.null2String(request.getParameter("source_type"));
String source_value = Util.null2String(request.getParameter("source_value"));
String isremind = Util.null2String(request.getParameter("isremind"));
String remindtype = Util.null2String(request.getParameter("remindtype"));
String remindsql = Util.null2String(request.getParameter("remindsql"));
String reminddatasource = Util.null2String(request.getParameter("reminddatasource"));
String remindjavafilename = Util.null2String(request.getParameter("remindjavafilename"));


List<AppHomepage> appHomepages = MobileAppHomepageManager.getInstance().getAllAppHomepagesByAppid(appid);
List<AppFormUI> formuiList = MobileAppUIManager.getInstance().getDefaultAppUIListForHomepage(appid);

JSONArray common_mec_nav_layoutpages = new JSONArray();
JSONArray common_homepage_items = new JSONArray();
JSONArray common_list_items = new JSONArray();

for(int i = 0; i < appHomepages.size(); i++){
	AppHomepage homepage = appHomepages.get(i);
	JSONObject nav_item = new JSONObject();
	String uiid = String.valueOf(homepage.getId());
	nav_item.put("uiid", MECManager.APPHOMEPAGE_ID_PREFIX + uiid);
	int uitype = Util.getIntValue(Util.null2String(homepage.getUitype()));
	int modelid = Util.getIntValue(Util.null2String(homepage.getModelid()));
	String homepagename = Util.formatMultiLang(homepage.getPagename());
	if(uitype != -1){
		MobileAppModelInfo mobileAppModelInfo=MobileAppModelManager.getInstance().getAppModel(appid, modelid);
		String modename=Util.formatMultiLang(mobileAppModelInfo.getEntityName());
		nav_item.put("uiname", homepagename + " （"+modename+"）");
		if(uitype == 0){
			common_mec_nav_layoutpages.add(nav_item);
		}else if(uitype == 3){
			common_list_items.add(nav_item);
		}
	}else{
		nav_item.put("uiname", homepagename);
		common_homepage_items.add(nav_item);
	}
}

for(int i = 0; i < formuiList.size(); i++){
	AppFormUI appFormUI = formuiList.get(i);
	JSONObject nav_item = new JSONObject();
	int uitype = appFormUI.getUiType();
	int uiid = appFormUI.getId();
	nav_item.put("uiid", uiid);
	MobileAppModelInfo mobileAppModelInfo=MobileAppModelManager.getInstance().getAppModelInfo(appFormUI.getEntityId());
	String modename = Util.formatMultiLang(mobileAppModelInfo.getEntityName());
	String uiname = Util.formatMultiLang(appFormUI.getUiName()) + "（"+modename+"）";
	nav_item.put("uiname", uiname);
	if(uitype == 3){
		common_list_items.add(nav_item);
	}else{
		common_mec_nav_layoutpages.add(nav_item);
	}
}
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
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: middle;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 5px 5px 10px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
#addPicDiv{
	background-color: rgb(93, 156, 236);
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 12px;
	font-weight: bold;
	height: 30px;
	line-height: 30px;
	padding-bottom: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-top: 0px;
}
#previewDiv{
	background: url("/mobilemode/images/mec/img-space2_wev8.png") no-repeat;
	width: 32px;
	height: 32px;
	border: 1px solid rgb(204,204,204);
	background-color: #fff;
	border-radius: 4px;
	margin-top: 5px;
}
#previewImg{
	width: 100%;
	height: 100%;
	border-radius: 4px;
}
#showname{
	border: 1px solid #ccc;
	height: 20px;
	width:90%;
}
.selectStyle{
	border: 1px solid #ccc !important;
	max-width:230px !important;
}
.textStyle{
	border: 1px solid #ccc  !important;
	width: 180px !important;	
	height: 20px;
}
#remindEditFlag{
	background: url("/mobilemode/images/toolbar/tbar01_wev8.png") no-repeat;
	position: absolute;
	top: 2px;
	left: 20px;
	width: 15px;
	height: 18px;
	cursor: pointer;
	display: none;
}
</style>

<script type="text/javascript">

$(function() {
	sourceTypeChange();
	remindChange();
	
	MLanguage({
		container: $(".e8_tblForm")
    });
});
function onClose(){
	top.closeTopDialog();
}
function addPic(){
	var pic_pathV = $("#picpath").val();
	var url = "/mobilemode/picset.jsp?pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(124841,user.getLanguage())%>";  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		$("#picpath").val(picPath);
		$("#previewImg").show().attr("src", picPath);
	};
}

function remindChange(){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $remindEditFlag = $("#remindEditFlag");
		$("#isremind").is(':checked') ? $remindEditFlag.show() : $remindEditFlag.hide();
	},100);
}

function remindEdit(rowIndex, mec_id){
	var remindtypeV = $("#remindtype").val();
	
	var remindsqlV = $("#remindsql").val();
	remindsqlV = $m_encrypt(remindsqlV);
	
	var reminddatasourceV = $("#reminddatasource").val();
	var remindjavafilenameV = $("#remindjavafilename").val();
	
	var url = "/mobilemode/numremind.jsp?remindtype="+remindtypeV+"&remindsql="+remindsqlV+"&reminddatasource="+reminddatasourceV+"&remindjavafilename="+remindjavafilenameV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 500;//定义长度
	dlg.Height = 255;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>";  //提醒
	dlg.show();
	dlg.hookFn = function(result){
		$("#remindtype").val(result["remindtype"]);
		$("#remindsql").val(result["remindsql"]);
		$("#reminddatasource").val(result["reminddatasource"]);
		$("#remindjavafilename").val(result["remindjavafilename"]);
	};
}

function sourceTypeChange(){
	var sourceType = $("#source_type").val();
	
	var $source_apphomepage = $("#source_apphomepage");
	var $source_layoutpage = $("#source_layoutpage");
	var $source_listpage = $("#source_listpage");
	var $source_custominput = $("#source_custominput");
	var $source_jscodefn = $("#source_jscodefn");
	
	$source_apphomepage.hide();
	$source_layoutpage.hide();
	$source_listpage.hide();
	$source_custominput.hide();
	$source_jscodefn.hide();
	
	if(sourceType == "1"){
		$source_apphomepage.show();
	}else if(sourceType == "2"){
		$source_layoutpage.show();
	}else if(sourceType == "3"){
		$source_listpage.show();
	}else if(sourceType == "4"){
		$source_custominput.show();
	}else if(sourceType == "5"){
		$source_jscodefn.show();
	}
}

function getSourceValue(){
	var sourceType = $("#source_type").val();
	
	var result = {};
	if(sourceType == "1"){
		var $source_apphomepage = $("#source_apphomepage");
		result.value = $source_apphomepage.val();
		result.text = $source_apphomepage.find("option:selected").text();  
	}else if(sourceType == "2"){
		var $source_layoutpage = $("#source_layoutpage");
		result.value = $source_layoutpage.val();
		result.text = $source_layoutpage.find("option:selected").text();  
	}else if(sourceType == "3"){
		var $source_listpage = $("#source_listpage");
		result.value = $source_listpage.val();
		result.text = $source_listpage.find("option:selected").text();  
	}else if(sourceType == "4"){
		var $source_custominput = $("#source_custominput");
		result.value = $source_custominput.val();
		result.text = $source_custominput.val();  
	}else if(sourceType == "5"){
		var $source_jscodefn = $("#source_jscodefn");
		result.value = $source_jscodefn.val();
		result.text = $source_jscodefn.find("option:selected").text();  
	}
	return result;
}

function returnResult(){
	if(top && top.callTopDlgHookFn){
		var sourcevalueObj = getSourceValue();
		var showname = MLanguage.getValue($("#showname")) || $("#showname").val();
		var result = {
			"picpath" : $("#picpath").val(),
			"showname" : showname,
			"source_type" : $("#source_type").val(),
			"_source_type" : $("#source_type").find("option:selected").text(),
			"source_value" : sourcevalueObj.value,
			"_source_value" : sourcevalueObj.text,
			"isremind" : $("#isremind").is(':checked') ? "1" : "0",
			"remindtype" : $("#remindtype").val(),
			"remindsql" : $("#remindsql").val(),
			"reminddatasource" : $("#reminddatasource").val(),
			"remindjavafilename" : $("#remindjavafilename").val()
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
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr>
			<td class="e8_tblForm_label" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(125075,user.getLanguage())%><!-- 图标 --></td>
			<td class="e8_tblForm_field">
				<div id="addPicDiv" onclick="addPic();"><%=SystemEnv.getHtmlLabelName(125080,user.getLanguage())%><!-- 选择图片 --></div>
					
				<div id="previewDiv">
	            	<img id="previewImg" <%if(picpath.trim().equals("")){%> style="display: none;" <%}else{%> src="<%=picpath %>" <%}%> />
	            </div>
	            
	            <INPUT type="hidden" name="picpath" id="picpath" value="<%=picpath%>">
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%><!-- 显示名称 --></td>
			<td class="e8_tblForm_field">
				<input type="text" id="showname" name="showname" value="<%=showname%>" data-multi=false/>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%><!-- 来源 --></td>
			<td class="e8_tblForm_field">
				<select id="source_type" class="selectStyle" style="width: 90px;" onchange="sourceTypeChange();">
					<option value="1" <%if(source_type.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32309,user.getLanguage())%><!-- 自定义页面 --></option>
					<option value="2" <%if(source_type.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82132,user.getLanguage())%><!-- 布局页面 --></option>
					<option value="3" <%if(source_type.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(127623,user.getLanguage())%><!-- 列表页面 --></option>
					<option value="4" <%if(source_type.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(127624,user.getLanguage())%><!-- 输入链接 --></option>
					<option value="5" <%if(source_type.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(127495,user.getLanguage())%><!-- 脚本 --></option>
				</select>
				
				<select id="source_apphomepage" class="selectStyle" style="display: none;">
					<%
					for(int i = 0; i < common_homepage_items.size(); i++){
						JSONObject item = common_homepage_items.getJSONObject(i);
						String uiid = item.getString("uiid");
						String uiname = item.getString("uiname"); 
						String selectedStr = "";
						if(source_type.equals("1") && source_value.equals(uiid)){
							selectedStr = "selected=\"selected\"";
						}
					%>
						<option value="<%=uiid%>" <%=selectedStr %>><%=uiname %></option>
					<%} %>
				</select>
				
				<select id="source_layoutpage" class="selectStyle" style="display: none;">
					<%
					for(int i = 0; i < common_mec_nav_layoutpages.size(); i++){
						JSONObject item = common_mec_nav_layoutpages.getJSONObject(i);
						String uiid = item.getString("uiid");
						String uiname = item.getString("uiname");
						String selectedStr = "";
						if(source_type.equals("2") && source_value.equals(uiid)){
							selectedStr = "selected=\"selected\"";
						}
					%>
						<option value="<%=uiid%>" <%=selectedStr %>><%=uiname %></option>
					<%} %>
				</select>
				
				<select id="source_listpage" class="selectStyle" style="display: none;">
					<%
					for(int i = 0; i < common_list_items.size(); i++){
						JSONObject item = common_list_items.getJSONObject(i);
						String uiid = item.getString("uiid");
						String uiname = item.getString("uiname");
						String selectedStr = "";
						if(source_type.equals("3") && source_value.equals(uiid)){
							selectedStr = "selected=\"selected\"";
						}
					%>
						<option value="<%=uiid%>" <%=selectedStr %>><%=uiname %></option>
					<%} %>
				</select>
				
				<input type="text" id="source_custominput" class="textStyle" style="display: none;" <%if(source_type.equals("4")){ %>value="<%=source_value%>"<%} %>/>
				
				<select id="source_jscodefn" class="selectStyle" style="display: none;" >value="
					<option value=""></option>
					<option value="refresh" <%if(source_value.equals("refresh")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%><!-- 刷新 --></option>
					<option value="backToHomepage" <%if(source_value.equals("backToHomepage")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(127625,user.getLanguage())%><!-- 回到首页 --></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(558,user.getLanguage())%><!-- 提示 --></td>
			<td class="e8_tblForm_field">
				<div style="position: relative;">
					<input type="checkbox" id="isremind" value="1" onclick="remindChange();" <%if(isremind.equals("1")){ %> checked="checked" <%} %>/>
					<input type="hidden" id="remindtype" value="<%=remindtype%>"/>
					<input type="hidden" id="remindsql" value="<%=remindsql%>"/>
					<input type="hidden" id="reminddatasource" value="<%=reminddatasource%>"/>
					<input type="hidden" id="remindjavafilename" value="<%=remindjavafilename%>"/>
					<div id="remindEditFlag" onclick="remindEdit();"></div>
				</div>
			</td>
		</tr>
	</table>
	
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
	</div>
</body>
</html>
