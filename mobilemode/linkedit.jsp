<%@page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSON"%>
<%@ page import="com.weaver.formmodel.mobile.mec.MECManager"%>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%

String dataurlJson=(StringHelper.null2String(request.getParameter("dataurlJson")).equals(""))?"{}":StringHelper.null2String(request.getParameter("dataurlJson"));
JSONObject titleJson = JSONObject.fromObject(Util.null2String(dataurlJson));
String linkType = StringHelper.null2String(titleJson.get("linkType"),"1");
String openType = StringHelper.null2String(titleJson.get("openType"),"1");
String urlContent = StringHelper.null2String(titleJson.get("urlContent"));
String jsContent = StringHelper.null2String(titleJson.get("jsContent"));
String bgcolor = StringHelper.null2String2(titleJson.get("bgcolor"),"#fff");
String wd = StringHelper.null2String2(titleJson.get("wd"),"70%");
String effect = StringHelper.null2String2(titleJson.get("effect"),"1");
String maskbgcolor = StringHelper.null2String2(titleJson.get("maskbgcolor"),"rgba(0,0,0,0.2)");
String speed = StringHelper.null2String2(titleJson.get("speed"),"0.5s");

int appid = Util.getIntValue(Util.null2String(request.getParameter("appid")));
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
	if(uitype != -1){
		MobileAppModelInfo mobileAppModelInfo=MobileAppModelManager.getInstance().getAppModel(appid, modelid);
		String modename=mobileAppModelInfo.getEntityName();
		nav_item.put("uiname", homepage.getPagename() + " （"+modename+"）");
		if(uitype == 0){
			common_mec_nav_layoutpages.add(nav_item);
		}else if(uitype == 3){
			common_list_items.add(nav_item);
		}
	}else{
		nav_item.put("uiname", homepage.getPagename());
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
	String modename = mobileAppModelInfo.getEntityName();
	String uiname = appFormUI.getUiName() + "（"+modename+"）";
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
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
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
.e8_zDialog_bottom{
	position: absolute;
	left: 0px;
	bottom: 0px;
	width: 100%;
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
	background-color: rgb(0, 122, 255);
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	font-family: 'Microsoft YaHei', Arial;
	font-size: 12px;
	height: 30px;
	line-height: 30px;
	width: 65px; text-align: center;
	position: absolute;
	top: 3px;
	right: 3px; 
}
.textareaStyle{
	border: 1px solid #ccc;
	width: 330px;
	height: 100px;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 14px;
	overflow: auto;
	padding: 5px 70px 5px 5px;
}
.jNiceCheckbox{
	margin-bottom: -2px;	
}
.checkboxWrap{
	margin-right: 15px; 
	color: #333;
}
table.linktable{
	width: 100%;
	border-collapse: collapse;
	margin: 5px 0px 0px 0px;
}
table.linktable tr{

}
table.linktable tr td{
	color: rgb(166,167,171);
	text-align: center;
	padding: 3px 0px;
}
table.linktable tr.title td{
	border-bottom: 1px solid #e6e6e6;
}
.textStyle{
	border: 1px solid #ccc;
	width: 50px;
	height: 20px;
	text-align: center;
}
.selectStyle{
	border: 1px solid #ccc;
	height: 24px;
}
.valueContainer{
	position: absolute;
	top: 68px;
	right: 10px;
	width: 200px;
	height: 206px;
	background-color: rgb(0, 122, 255);
	overflow: hidden;
	z-index: 100;
	width: 65px;
	height: 0px;
}
.valueContainer ul{
	list-style: none;
	padding: 3px 8px 3px 8px;
	margin: 0px;
}
.valueContainer ul li{
	color: #fff;
	padding: 0px 6px;
	overflow: hidden;
	border-bottom: 1px dotted #fff;
	cursor: pointer;
	height: 24px;
	line-height: 24px;
}
.valueContainer ul li .valueName{
	float: left;	
	font-size: 12px;
}
.valueContainer ul li .valueType{
	float: right;
	font-size: 11px;
}
.valueContainer ul li:HOVER{
	background-color: #f8f8f8;
}
.valueContainer ul li:HOVER .valueName{
	color: #333;
}
.valueContainer ul li:HOVER .valueType{
	color: #222;
}
</style>

<script type="text/javascript">
var vcShow = false;
$(function() {
	$(".valueHolder").click(function(e){
		vcShow ? hideValueContainer() : showValueContainer();
		e.stopPropagation();
	});
	
	$(document.body).click(hideValueContainer);
	
	$(".valueContainer > ul > li").click(function(){
		$("#urlContent")[0].value = $(this).attr("url");
	});
	var linkType = <%=linkType%>;
	var openType = <%=openType%>;
	if(linkType==1){
		$("#valueDiv_2").css("display","none");
		if(openType==1){
			$(".linktable").css("display","none");
		}
	}else{
		$("#valueDiv_1").css("display","none");
		$("#opentype").css("display","none");
	}
});

function showValueContainer(){
	vcShow = true;
	$(".valueContainer").show();
	$(".valueContainer").animate({ width: "320px", height: "208px"}, 200, function(){
		initOrResetScroll();
	});	
	
}

function hideValueContainer(){
	vcShow = false;
	$(".valueContainer").animate({ width: "65px", height: "0px"}, 200, function(){
		$(this).hide();
	});
}

function onClose(){
	top.closeTopDialog();
}

function returnResult(){
	var linkType = $("input[type='checkbox'][name='linkType']:checked").val();
	var urlContent = $("#urlContent").val();
	var jsContent = $("#jsContent").val();
	var openType = $("input[type='checkbox'][name='openType']:checked").val();
	var bgcolor = $("#bgcolor").val();
	var wd = $("#wd").val();
	var effect = $("#effect").val();
	var maskbgcolor = $("#maskbgcolor").val();
	var speed = $("#speed").val();
	
	var dataurlJson = {};
	var dataurl = "";
	
	if(linkType==2){
		dataurl = jsContent;
		urlContent = "";
		openType = "1";
		bgcolor = "";
		wd = "";
		effect = "";
		maskbgcolor = "";
		speed = "";
	}else{
		jsContent = "";
		if(openType==1){
			dataurl = urlContent;
			bgcolor = "";
			wd = "";
			effect = "";
			maskbgcolor = "";
			speed = "";
		}else{
			dataurl = "mobilemode:createTopfloorPage:"+urlContent+":{";
			if(bgcolor==""){
				bgcolor = "#fff";
			}
			dataurl = dataurl+"bgcolor:\""+bgcolor+"\",";
			if(wd==""){
				wd = "70%";
			}
			dataurl = dataurl+"width:\""+wd+"\",";
			if(effect==""){
				effect = "1";
			}
			dataurl = dataurl+"effect:\""+effect+"\",";
			if(maskbgcolor==""){
				maskbgcolor = "rgba(0,0,0,0.2)";
			}
			dataurl = dataurl+"maskBgColor:\""+maskbgcolor+"\",";
			if(speed==""){
				speed = "0.5s";
			}
			dataurl = dataurl+"speed:\""+speed+"\"}";
		}
	}
	
	dataurlJson["linkType"] = linkType;
	dataurlJson["urlContent"] = urlContent;
	dataurlJson["jsContent"] = jsContent;
	dataurlJson["openType"] = openType;
	dataurlJson["bgcolor"] = bgcolor;
	dataurlJson["wd"] = wd;
	dataurlJson["effect"] = effect;
	dataurlJson["maskbgcolor"] = maskbgcolor;
	dataurlJson["speed"] = speed;
	if(top && top.callTopDlgHookFn){
		var result = {
			"dataurlJson" : $.isEmptyObject(dataurlJson) ? "" : JSON.stringify(dataurlJson),
			"dataurl" : dataurl
		};
		top.callTopDlgHookFn(result);
	}
	
	onClose();
}

function onOK(){
	returnResult();
}

var $valueContainerScroll = null;
function initOrResetScroll(){
	if($valueContainerScroll == null){
		$valueContainerScroll = $(".valueContainer").niceScroll();
	}else{
		$valueContainerScroll.resize();
	}
}

function changeLinkType(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='linkType']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		if (objV == 1){
			$("#valueDiv_2").css("display","none");
			$("#valueDiv_1").css("display","");
			$("#opentype").css("display","");
			var openvalue = $("input[type='checkbox'][name='openType']:checked").val();
			if(openvalue==1){
				$(".linktable").css("display","none");
			}
		}else{
			$("#valueDiv_1").css("display","none");
			$("#valueDiv_2").css("display","");
			$("#opentype").css("display","none");
		} 
	},100);
}

function changeOpenType(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='openType']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		if (objV == 1){
			$(".linktable").css("display","none");
		}else{
			$(".linktable").css("display","");
		} 
	},100);
}
</script>

</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+ SystemEnv.getHtmlLabelName(83446,user.getLanguage()) + ",javascript:onSave(),_top} " ;  //确定
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+ SystemEnv.getHtmlLabelName(32694,user.getLanguage()) + ",javascript:onClose(),_top} " ;  //取消
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div id="warn-info"></div>
	<table class="e8_tblForm">
		<colgroup>
			<col width="20%"/>
			<col width="80%"/>
		</colgroup>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%><!-- 类型 --></td>
			<td class="e8_tblForm_field">
				<span class="checkboxWrap">
					<input type="checkbox" name="linkType" value="1" onclick="changeLinkType(this);" checked=checked /><%=SystemEnv.getHtmlLabelName(124880,user.getLanguage())%><!-- 链接地址 -->
				</span>
			</td>
		</tr>
		
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(33368,user.getLanguage())%><!-- 内容 --></td>
			<td class="e8_tblForm_field">
				<div id="valueDiv_1" style="width: 100%; position: relative;">
					<textarea id="urlContent" name="urlContent" class="textareaStyle"><%=urlContent%></textarea>
					<div class="valueHolder"><%=SystemEnv.getHtmlLabelName(127633,user.getLanguage())%><!-- 系统组件 --></div>
				</div>
				<div id="valueDiv_2" style="width: 100%; position: relative;">
					<textarea id="jsContent" name="jsContent" class="textareaStyle" style="padding: 5px;"><%=jsContent%></textarea>
				</div>
			</td>
		</tr>
		<tr id="opentype">
			<td class="e8_tblForm_label" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(30173,user.getLanguage())%><!-- 打开方式 --></td>
			<td class="e8_tblForm_field">
				<span class="checkboxWrap">
					<input type="checkbox" name="openType" value="1" onclick="changeOpenType(this);" <%if(openType.equals("1")){%>checked=checked <%}%>><%=SystemEnv.getHtmlLabelName(127642,user.getLanguage())%><!-- 普通方式打开 -->
				</span>
				<span class="checkboxWrap">
					<input type="checkbox" name="openType" value="2" onclick="changeOpenType(this);" <%if(openType.equals("2")){%>checked=checked <%}%>><%=SystemEnv.getHtmlLabelName(127643,user.getLanguage())%><!-- 在顶层页面中打开 -->
				</span>
				<table class="linktable">
					<tr class="title">
						<td><%=SystemEnv.getHtmlLabelName(83749,user.getLanguage())%><!-- 背景色 --></td>
						<td><%=SystemEnv.getHtmlLabelName(33818,user.getLanguage())%><!-- 宽度 --></td>
						<td><%=SystemEnv.getHtmlLabelName(127634,user.getLanguage())%><!-- 滑出效果 --></td>
						<td><%=SystemEnv.getHtmlLabelName(127635,user.getLanguage())%><!-- 遮罩层背景色 --></td>
						<td><%=SystemEnv.getHtmlLabelName(127636,user.getLanguage())%><!-- 滑出速度 --></td>
					</tr>
					<tr>
						<td><input id="bgcolor" type="text" class="textStyle" value="<%=bgcolor%>"/></td>
						<td><input id="wd" type="text" class="textStyle" value="<%=wd%>" style="width:40px;"/></td>
						<td>
							<select id="effect" class="selectStyle">
								<option value="1" <%if(effect.equals("1")){ %>selected<%}%>><%=SystemEnv.getHtmlLabelName(127637,user.getLanguage())%><!-- 从页面上层滑出 --></option>
								<option value="2" <%if(effect.equals("2")){ %>selected<%}%>><%=SystemEnv.getHtmlLabelName(127638,user.getLanguage())%><!-- 从左侧推出 --></option>
								<option value="3" <%if(effect.equals("3")){ %>selected<%}%>><%=SystemEnv.getHtmlLabelName(127639,user.getLanguage())%><!-- 从右侧推出 --></option>
							</select>
						</td>
						<td><input id="maskbgcolor" type="text" class="textStyle" value="<%=maskbgcolor%>" style="width:100px;"/></td>
						<td><input id="speed" type="text" class="textStyle" value="<%=speed%>" style="width:40px;"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<div class="valueContainer">
		<ul>
			<%
			for(int i = 0; i < common_homepage_items.size(); i++){
				JSONObject item = common_homepage_items.getJSONObject(i);
				String uiid = Util.null2String(item.getString("uiid"));
				String uiname = item.getString("uiname");
				if(uiid.indexOf(MECManager.APPHOMEPAGE_ID_PREFIX) != -1){
					uiid = uiid.substring(MECManager.APPHOMEPAGE_ID_PREFIX.length());
				}
				String url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + uiid;
			%>
				<li url="<%=url%>">
					<div class="valueName"><%=uiname %></div>
					<div class="valueType"><%=SystemEnv.getHtmlLabelName(32309,user.getLanguage())%><!-- 自定义页面 --></div>
				</li>
			<%} %>
			
			<%
			for(int i = 0; i < common_mec_nav_layoutpages.size(); i++){
				JSONObject item = common_mec_nav_layoutpages.getJSONObject(i);
				String uiid = Util.null2String(item.getString("uiid"));
				String uiname = item.getString("uiname");
				String url;
				if(uiid.indexOf(MECManager.APPHOMEPAGE_ID_PREFIX) != -1){
					uiid = uiid.substring(MECManager.APPHOMEPAGE_ID_PREFIX.length());
					url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + uiid;
				}else{
					url = "/mobilemode/formbaseview.jsp?uiid=" + uiid;
				}
			%>
				<li url="<%=url%>">
					<div class="valueName"><%=uiname %></div>
					<div class="valueType"><%=SystemEnv.getHtmlLabelName(83132,user.getLanguage())%><!-- 布局页面 --></div>
				</li>
			<%} %>
			
			<%
			for(int i = 0; i < common_list_items.size(); i++){
				JSONObject item = common_list_items.getJSONObject(i);
				String uiid = Util.null2String(item.getString("uiid"));
				String uiname = item.getString("uiname");
				String url;
				if(uiid.indexOf(MECManager.APPHOMEPAGE_ID_PREFIX) != -1){
					uiid = uiid.substring(MECManager.APPHOMEPAGE_ID_PREFIX.length());
					url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + uiid;
				}else{
					url = "/mobilemode/formbaseview.jsp?uiid=" + uiid;
				}
			%>
				<li url="<%=url%>">
					<div class="valueName"><%=uiname %></div>
					<div class="valueType"><%=SystemEnv.getHtmlLabelName(127623,user.getLanguage())%><!-- 列表页面 --></div>
				</li>
			<%} %>
		</ul>
	</div>
	<div class="e8_zDialog_bottom">
		<button type="button" class="e8_btn_submit" onclick="onOK()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
		<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
	</div>
</body>
</html>
