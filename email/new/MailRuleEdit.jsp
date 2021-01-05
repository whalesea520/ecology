<%@ page import="weaver.email.domain.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<!-- start -->

<!-- end -->

<!-- start -->
<div class="m-t-15">
	<div class="left font13 color333 p-l-30 w-80"><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage()) %></div>
	<div class="left">
		<div class="left">
			<input type="text" name="ruleNameTemp" id="ruleNameTemp" class="inputstyle styled input w-300 h-25 font12" value="" onchange="checkinput('ruleNameTemp','ruleNameSpan'),setRuleName(this)">
			<span id="ruleNameSpan"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
		</div>
	</div>
	<div class="clear"></div>
</div>
<!-- end -->

<!-- start -->
<div class="m-t-15">
	<div class="left font13 color333 p-l-30 w-80"><%=SystemEnv.getHtmlLabelName(19835,user.getLanguage()) %></div>
	<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px;">
		<div id="rule"><%=SystemEnv.getHtmlLabelName(19836,user.getLanguage()) %></div>
		<ul class="btnGrayDropContent hide">
			<li target="#rule" onclick="changeRule(this),setMatchAll(this)" id="0"><%=SystemEnv.getHtmlLabelName(19836,user.getLanguage()) %></li>
			<li target="#rule" onclick="changeRule(this),setMatchAll(this)" id="1"><%=SystemEnv.getHtmlLabelName(19837,user.getLanguage()) %></li>
		</ul>
	</div>
	<a class="hand font12 p-l-20" target="#conditions" onclick="addHTML(this,'#condition',1)"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %></a>
	<div class="clear"></div>
	<!-- 条件列表 -->
	<div id="conditions">
		<div class="m-t-15">
			<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px; margin-left: 125px;">
				<div id="rule"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage()) %></div>
				<ul class="btnGrayDropContent hide" style="width: 100px;">
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'cSourceTemp')" id="1"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'cSourceTemp')" id="2"><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'cSourceTemp')" id="3"><%=SystemEnv.getHtmlLabelName(2046,user.getLanguage()) %></li>
				</ul>
			</div>
			<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px;">
				<div id="rule"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></div>
				<ul class="btnGrayDropContent hide" style="width: 100px;">
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="3"><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="4"><%=SystemEnv.getHtmlLabelName(19843,user.getLanguage()) %></li>
				</ul>
			</div>
			<div class="left" style="margin-left: 3px;">
				<input type="text" class="h-25 font12 w-150 styled input" onchange="getAndSetValue(this,'cTargetTemp')" />
				<span _img=''><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
			</div>
			<a class="hand font12 right p-r-15" onclick="deleteHTML(this)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %></a>
			<div class="clear"></div>
			<div id="mailRule" class="hide">
				<input type="hidden" name="cSourceTemp" value="1">
				<input type="hidden" name="operatorTemp" value="1">
				<input type="hidden" name="cTargetTemp" value="">
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
<!-- end -->

<!-- start -->
<div class="m-t-15">
	<div class="left font13 color333 p-l-30 w-80"><%=SystemEnv.getHtmlLabelName(19831,user.getLanguage()) %></div>
	
	<div class="btnGrayDrop relative left font13 color333"   style="padding-right: 15px;background-image: none;">
			<%=SystemEnv.getHtmlLabelName(30928,user.getLanguage()) %>
	</div>
	
	<a class="hand font12 p-l-20" target="#actions" onclick="addHTML(this,'#action',2)"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %></a>
	<div class="clear"></div>
	<div id="actions">
		<div class="m-t-15">
			<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px; margin-left: 125px;">
				<div id="rule"><%=SystemEnv.getHtmlLabelName(30929,user.getLanguage()) %></div>
				<ul class="btnGrayDropContent hide" style="width: 100px;">
					<li target="#rule" onclick="changeRule(this),hideFoldersShowMarks(this),setInnerValue(this,'aSourceTemp')" id="3"><%=SystemEnv.getHtmlLabelName(30929,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),showFoldersHideMarks(this),setInnerValue(this,'aSourceTemp')" id="1"><%=SystemEnv.getHtmlLabelName(19832,user.getLanguage()) %></li>
				</ul>
			</div>
			<div id="marks" class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px;">
				<div id="rule"><%=SystemEnv.getHtmlLabelName(30930,user.getLanguage()) %></div>
				<ul class="btnGrayDropContent hide" style="width: 100px;">
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aSourceTemp')" id="3"><%=SystemEnv.getHtmlLabelName(30930,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aSourceTemp')" id="5"><%=SystemEnv.getHtmlLabelName(30931,user.getLanguage()) %></li>
					<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
					<%
			 			ArrayList lmsList= lms.getLabelManagerList(user.getUID());
						for(int i=0; i<lmsList.size();i++){
						MailLabel ml = (MailLabel)lmsList.get(i);
					%>
						<li class="markLabel item" target="#rule" onclick="changeRule(this),setInnerValueForLable(this,'aSourceTemp','aTargetFolderIdTemp')" id="6">
							<div target="markLable" class="m-r-5 left" id="<%=ml.getId() %>" style="margin-top:8px;border-radius:2px; height:8px;width:8px; background:<%=ml.getColor()%>;">&nbsp;</div>
							<span><%=ml.getName() %></span>
						</li>
					<%
						}
					%>
				</ul>
			</div>
			<div id="mailFolders" class="btnGrayDrop relative left font13 color333 hide" onclick="matchManner(this)" style="padding-right: 15px;">
				<div id="rule"><%=SystemEnv.getHtmlLabelName(2040,user.getLanguage()) %></div>
				<ul class="btnGrayDropContent hide" style="width: 100px;">
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="-3"><%=SystemEnv.getHtmlLabelName(2040,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="0"><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="-1"><%=SystemEnv.getHtmlLabelName(2038,user.getLanguage()) %></li>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="-2"><%=SystemEnv.getHtmlLabelName(2039,user.getLanguage()) %></li>
				<%
					ArrayList folderList= fms.getFolderManagerList(user.getUID());
					for(int i=0; i<folderList.size();i++){
						MailFolder mf = (MailFolder)folderList.get(i);
						%>
						<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="<%=mf.getId() %>"><%=mf.getFolderName() %></li>
						<%
					}
				%>
				</ul>
			</div>
			<a class="hand font12 right p-r-15" onclick="deleteHTML(this)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %></a>
			<div class="clear"></div>
			<div id="mailAction" class="hide">
				<input type="hidden" name="aSourceTemp" value="3">
				<input type="hidden" name="aTargetFolderIdTemp" value="-3">
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>
<!-- end -->

<!-- start -->
<div class="m-t-15">
	<div class="left font13 color333 p-l-30 w-80"><%=SystemEnv.getHtmlLabelName(19830,user.getLanguage()) %></div>
	<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px;">
		<div id="rule"><%=SystemEnv.getHtmlLabelName(31350,user.getLanguage()) %></div>
		<ul class="btnGrayDropContent hide" style="width: 200px;">
			<li target="#rule" onclick="changeRule(this),setMailAccountId(this,'mailAccountId')" id="-1"><%=SystemEnv.getHtmlLabelName(30932,user.getLanguage()) %></li>
			<%
				mas.clear();
				mas.setUserid(user.getUID()+"");
				mas.selectMailAccount();
				while(mas.next()){
			%>
				<li target="#rule" onclick="changeRule(this),setMailAccountId(this,'mailAccountId')" id="<%=mas.getId()%>"><%=mas.getAccountname() %></li>
			<%
				}
			%>
		</ul>
	</div>
	<div class="clear"></div>
</div>
<!-- end -->


<!-- start -->
<div id="bottomBtnBar" class="hide" style="text-align: right;background: #f6f6f6;height: 35px;" class="p-t-10 p-r-15">
	<button class="btnGray" onclick="submitAddMailRule(this)"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %></button>
	<button onclick="closeAddMailRule(this)" class="btnGray"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %></button>
</div>
<!-- end -->

<!-- ===================================start=================================== -->
<form id="addMailRule" name="addMailRule">
	<input type="hidden" name="operation" value="add">
	<input type="hidden" name="ruleName" value="">
	<input type="hidden" name="matchAll" value="0">
	<input type="hidden" name="applyTime" value="0">
	<input type="hidden" name="mailAccountId" value="-1">
	<input type="hidden"  name="cSource" value="">
	<input type="hidden" name="operator" value="">
	<input type="hidden" name="cTarget" value="">
	<input type="hidden" name="cTargetPriority" value="">
	<input type="hidden" name="SendDateArrayass" value="">
	<input type="hidden" name="aSource" value="">
	<input type="hidden"  name="aTargetFolderId" value="">
</form>
<!-- ===================================end=================================== -->

<!-- start 待添加的HTML -->
<div id="condition" class="hide">
	<div class="m-t-15">
		<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px; margin-left: 125px;">
			<div id="rule"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage()) %></div>
			<ul class="btnGrayDropContent hide" style="width: 100px;">
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'cSourceTemp')" id="1"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'cSourceTemp')" id="2"><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'cSourceTemp')" id="3"><%=SystemEnv.getHtmlLabelName(2046,user.getLanguage()) %></li>
			</ul>
		</div>
		<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px;">
			<div id="rule"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></div>
			<ul class="btnGrayDropContent hide" style="width: 100px;">
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="3"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'operatorTemp')" id="4"><%=SystemEnv.getHtmlLabelName(19843,user.getLanguage()) %></li>
			</ul>
		</div>
		<div class="left" style="margin-left: 3px;">
			<input type="text" class="h-25 font12 w-150 styled input" onchange="getAndSetValue(this,'cTargetTemp')" />
			<span _img=''><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
		</div>
		<a class="hand font12 right p-r-15" onclick="deleteHTML(this)"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %></a>
		<div class="clear"></div>
		<div id="mailRule" class="hide">
			<input type="hidden" name="cSourceTemp" value="1">
			<input type="hidden" name="operatorTemp" value="1">
			<input type="hidden" name="cTargetTemp" value="">
		</div>
	</div>
</div>
<!-- end 待添加的HTML -->

<!-- start 待添加的HTML -->
<div id="action" class="hide">
	<div class="m-t-15">
		<div class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px; margin-left: 125px;">
			<div id="rule"><%=SystemEnv.getHtmlLabelName(30929,user.getLanguage()) %></div>
			<ul class="btnGrayDropContent hide" style="width: 100px;">
				<li target="#rule" onclick="changeRule(this),hideFoldersShowMarks(this),setInnerValue(this,'aSourceTemp')" id="3"><%=SystemEnv.getHtmlLabelName(30929,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),showFoldersHideMarks(this),setInnerValue(this,'aSourceTemp')" id="1"><%=SystemEnv.getHtmlLabelName(19832,user.getLanguage()) %></li>
			</ul>
		</div>
		<div id="marks" class="btnGrayDrop relative left font13 color333" onclick="matchManner(this)" style="padding-right: 15px;">
			<div id="rule"><%=SystemEnv.getHtmlLabelName(30930,user.getLanguage()) %></div>
			<ul class="btnGrayDropContent hide" style="width: 100px;">
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aSourceTemp')" id="3"><%=SystemEnv.getHtmlLabelName(30930,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aSourceTemp')" id="5"><%=SystemEnv.getHtmlLabelName(30931,user.getLanguage()) %></li>
				<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
				<%
					for(int i=0; i<lmsList.size();i++){
					MailLabel ml = (MailLabel)lmsList.get(i);
				%>
					<li class="markLabel item" target="#rule" onclick="changeRule(this),setInnerValueForLable(this,'aSourceTemp','aTargetFolderIdTemp')" id="6">
						<div target="markLable" class="m-r-5 left" id="<%=ml.getId() %>" style="margin-top:8px;border-radius:2px; height:8px;width:8px; background:<%=ml.getColor()%>;">&nbsp;</div>
						<span><%=ml.getName() %></span>
					</li>
				<%
					}
				%>
			</ul>
		</div>
		<div id="mailFolders" class="btnGrayDrop relative left font13 color333 hide" onclick="matchManner(this)" style="padding-right: 15px;">
			<div id="rule"><%=SystemEnv.getHtmlLabelName(2040,user.getLanguage()) %></div>
			<ul class="btnGrayDropContent hide" style="width: 100px;">
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="-3"><%=SystemEnv.getHtmlLabelName(2040,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="0"><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="-1"><%=SystemEnv.getHtmlLabelName(2038,user.getLanguage()) %></li>
				<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="-2"><%=SystemEnv.getHtmlLabelName(2039,user.getLanguage()) %></li>
			<%
				for(int i=0; i<folderList.size();i++){
					MailFolder mf = (MailFolder)folderList.get(i);
					%>
					<li target="#rule" onclick="changeRule(this),setInnerValue(this,'aTargetFolderIdTemp')" id="<%=mf.getId() %>"><%=mf.getFolderName() %></li>
					<%
				}
			%>
			</ul>
		</div>
		<a class="hand font12 right p-r-15" onclick="deleteHTML(this)"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %></a>
		<div class="clear"></div>
		<div id="mailAction" class="hide">
			<input type="hidden" name="aSourceTemp" value="3">
			<input type="hidden" name="aTargetFolderIdTemp" value="-3">
		</div>
	</div>
</div>
<!-- end 待添加的HTML -->

<!-- 在lean_modal中添加规则，请在需要的页面使用下面的div加载(load)本页面
	<div id="addMailRule"></div>
-->

<style>
.popWindow{
      width:450px;
      height:auto;
      box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
      border: 2px solid #90969E;
      background: #ffffff;
}
#lean_overlay {
    position: fixed!important;
    z-index:100;
    top: 0px;
    left: 0px;
    height:100%;
    width:100%;
    background: #000;
    display: none;
    filter: alpha(opacity=30);
}
.checkedRadio{
	width: 14px;
	height: 14px;
	background: url("/email/images/checkedRadio_wev8.png") no-repeat;
	display: inline-block;
}
.unCheckedRadio{
	width: 14px;
	height: 14px;
	background: url("/email/images/unCheckedRadio_wev8.png") no-repeat;
	display: inline-block;
}
</style>

<script>
function setMailAccountId(himself, name) {
	var _value_ = himself.id;
	var _parentNode_ = himself.parentNode.parentNode.parentNode.parentNode;
	$(_parentNode_).find("input[name="+ name +"]").val(_value_);
}

function setInnerValue(himself, name) {
	var _value_ = himself.id;
	var _parentNode_ = himself.parentNode.parentNode.parentNode;
	$(_parentNode_).find("input[name="+ name +"]").val(_value_);
}

function setInnerValueForLable(himself, name1, name2) {
	var _value1_ = himself.id;
	var _value2_ = $(himself).children("div[target=markLable]").attr("id");
	var _parentNode_ = himself.parentNode.parentNode.parentNode;
	$(_parentNode_).find("input[name="+ name1 +"]").val(_value1_);
	$(_parentNode_).find("input[name="+ name2 +"]").val(_value2_);
}

function getAndSetValue(himself, name) {
	var _value_ = himself.value;
	var _parentNode_ = himself.parentNode.parentNode;
	$(_parentNode_).find("input[name="+ name +"]").val(_value_);
	if($.trim($(himself).val())!=""){
		$(himself).next().html("");
	}else{
		$(himself).next().html("<img src='/images/BacoError_wev8.gif' align='absMiddle'>");
	}
	
}

function setRuleName(himself) {
	var _value_ = himself.value;
	$("#addMailRule").find("[name=ruleName]").val(_value_);
}

function setMatchAll(himself) {
	var _value_ = himself.id;
	$("form#addMailRule").find("[name=matchAll]").val(_value_);
}

function submitAddMailRule(himself) {
	
	var _containForm_ = $("#addMailRule");
	getValueSetToFrom(_containForm_);
	if(checkAddMailRule(_containForm_)) {
		var _paramAdd_ = _containForm_.serializeArray();
		$.post("/email/new/MailRuleOperation.jsp", _paramAdd_ , function(){
			//closeAddMailRule(himself);
			//Dialog.getInstance('0').close();
			parentDialog.close();
		});
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage()) %>");
	}
}

function checkAddMailRule(containForm) {
	var _ruleName_ = $.trim(containForm.find("input[name=ruleName]").val());
	var _cTarget_ = $.trim(containForm.find("input[name=cTarget]").val());
	var temp=0;
	$("#conditions span[_img=''] img").each(function (){
				temp++;
	});
	if(temp!=0){
		return false;
	}
	if(_ruleName_ == "" || _cTarget_ == "") {
		return false;
	} else {
		return true;
	}
}

function getValueSetToFrom(containForm) {
	var cSource = new Array();
	var operator = new Array();
	var cTarget = new Array();
	
	var cTargetPriority = new Array();
	var SendDateArrayass = new Array();
	
	var aSource = new Array();
	var aTargetFolderId = new Array();
	$("#conditions").find("input[type=hidden]").each(function(){
		if(this.name=="cSourceTemp") {
			cSource.push(this.value);
		} else
		if(this.name=="operatorTemp") {
			operator.push(this.value);
		} else
		if(this.name=="cTargetTemp") {
			cTarget.push(this.value);
		}
	});
	$("#actions").find("input[type=hidden]").each(function(){
		if(this.name=="aSourceTemp") {
			aSource.push(this.value);
		} else
		if(this.name=="aTargetFolderIdTemp") {
			aTargetFolderId.push(this.value);
		}
	});
	
	for(var i=0; i<cSource.length; i++) {
		cTargetPriority.push("3");
		SendDateArrayass.push("a");
	}
	
	containForm.find("input[name=cSource]").val(cSource);
	containForm.find("input[name=operator]").val(operator);
	containForm.find("input[name=cTarget]").val(cTarget);
	containForm.find("input[name=cTargetPriority]").val(cTargetPriority);
	containForm.find("input[name=SendDateArrayass]").val(SendDateArrayass);
	containForm.find("input[name=aSource]").val(aSource);
	containForm.find("input[name=aTargetFolderId]").val(aTargetFolderId);
}

function closeAddMailRule(himself) {
	$(himself).close_modal("div#addMailRule");
}

function hideFoldersShowMarks(himself) {
	var _parentNode_ = himself.parentNode.parentNode.parentNode;
	$(_parentNode_).find("#mailFolders").hide();
	$(_parentNode_).find("#marks").show();
	
	var _aTargetFolderIdTemp_ = $(_parentNode_).find("#mailAction input[name=aTargetFolderIdTemp]").val();
	$(_parentNode_).find("#mailFolders").data("aTargetFolderIdTemp", _aTargetFolderIdTemp_);
	var _oldATargetFolderIdTemp_ = $(_parentNode_).find("#marks").data("aTargetFolderIdTemp");
	
	if(_oldATargetFolderIdTemp_ == undefined) {
		_oldATargetFolderIdTemp_ = undefined;
	}
	$(_parentNode_).find("#mailAction input[name=aTargetFolderIdTemp]").val(_oldATargetFolderIdTemp_);
}

function showFoldersHideMarks(himself) {
	var _parentNode_ = himself.parentNode.parentNode.parentNode;
	$(_parentNode_).find("#mailFolders").show();
	$(_parentNode_).find("#marks").hide();
	
	var _aTargetFolderIdTemp_ = $(_parentNode_).find("#mailAction input[name=aTargetFolderIdTemp]").val();
	var _oldATargetFolderIdTemp_ = $(_parentNode_).find("#mailFolders").data("aTargetFolderIdTemp");
	$(_parentNode_).find("#marks").data("aTargetFolderIdTemp", _aTargetFolderIdTemp_);
	
	if(_oldATargetFolderIdTemp_ == undefined) {
		_oldATargetFolderIdTemp_ = -3;
	}
	$(_parentNode_).find("#mailAction input[name=aTargetFolderIdTemp]").val(_oldATargetFolderIdTemp_);
}

function deleteHTML(himself) {
	var _parentNode_ = himself.parentNode;
	var _containNode_ = _parentNode_.parentNode;
	var _length_ = $(_containNode_).children("div").length;
	if(_length_ > 1) {
		$(_parentNode_).remove();
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30934,user.getLanguage()) %>");
	}
}

function addHTML(himself,source,type) {
	var _html_ = $(source).html();
	$(himself.target).append(_html_);
}

function changeRule(himself) {
	var _text_ = himself.innerHTML;
	var _parentNode_ = himself.parentNode.parentNode;
	var _target_ = $(himself).attr("target");
	$(_parentNode_).find(_target_).html(_text_);
}

function matchManner(himself) {
    var _currentList_ = $(himself).find("ul.btnGrayDropContent");
	
	//隐藏弹出的下拉列表
	$("#addMailRule").find("ul.btnGrayDropContent").each(function(){
		if(_currentList_[0]!=this) {
			$(this).hide();
		}
	});
	
	_currentList_.toggle();
	if (event.stopPropagation) { event.stopPropagation(); } 
	else if (window.event) { window.event.cancelBubble = true; }
}

function checkinput(elementname,spanid){
	var tmpvalue = $GetEle(elementname).value;
	// 处理$GetEle可能找不到对象时的情况，通过id查找对象
    if(tmpvalue==undefined)
        tmpvalue=document.getElementById(elementname).value;

	while(tmpvalue.indexOf(" ") >= 0){
		tmpvalue = tmpvalue.replace(" ", "");
	}
	if(tmpvalue != ""){
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue != ""){
			$GetEle(spanid).innerHTML = "";
		}else{
			$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			//$GetEle(elementname).value = "";
		}
	}else{
		$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		//$GetEle(elementname).value = "";
	}
}
</script>