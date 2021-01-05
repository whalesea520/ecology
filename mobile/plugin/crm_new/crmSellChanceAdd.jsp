<!DOCTYPE html>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
%>
<html>
<head>
<title>新建商机</title>
</head>
<body>
<div id="crm_sell_add" class="page out">
	<style type="text/css">
	#crm_sell_add .form_msg{top: 185px;}
	#crm_sell_add form .field {padding-left: 15px;}
	#crm_sell_add form .field.required:before {content: '*';position: absolute;top: 50%;left: 5px;transform: translateY(-50%);height: 10px;font-size: 16px;color: red;}
	#crm_sell_add form .field.required.hasValue:before{display:none;}
	#crm_sell_add form .field > div:nth-child(1) {display: none;}
	#crm_sell_add .lbs{display: block;height: 100%;width: 50px;position: absolute;top: 0px;right: 0px;background-image: url('/mobilemode/images/emobile/lbs_wev8.png');background-repeat: no-repeat;background-size: 20px 20px;background-position: 20px center;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">新建商机</div>
		<div class="right okBtn"></div>
	</div>
	<div class="form_msg"></div>
	<div class="content">
		<form disabledEnterSubmit>
			<div class="controlTitle" style="font-size: 12px;">基本信息</div>
			<div class="field required" data-flag="subject">
				<div>商机名称 :</div>
				<div>
					<input placeholder="商机名称" type="text" name="subject"/>
				</div>
			</div>
			<div class="field required" data-flag="selltypesid">
				<div>商机类型 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmSellChanceType.jsp" data-formdata="callback=CRM.setSellAddPageTypes" class="more">
						<div class="text"></div>
						<input name="selltypesid" type="text" style="display: none;"/>
						<div class="tip">商机类型</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="customerid">
				<div>客户名称 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmSellChanceCustomer.jsp" data-formdata="callback=CRM.setSellAddPageCustomer" class="more">
						<div class="text"></div>
						<input name="customerid" type="text" style="display: none;"/>
						<input name="customername" type="hidden" id="customername"/>
						<div class="tip">客户名称</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field" data-flag="predate">
				<div>销售预期 :</div>
				<div>
					<input placeholder="销售预期" type="text" name="predate" readonly id="predate"/>
				</div>
			</div>
			<div class="field" data-flag="preyield">
				<div>预期收益 :</div>
				<div>
					<input placeholder="预期收益(单位:元)" type="text" name="preyield"/>
				</div>
			</div>
			<div class="field required" data-flag="sellstatusid">
				<div>商机状态 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmSellChanceStatus.jsp" data-formdata="callback=CRM.setSellAddPageStatus" class="more">
						<div class="text"></div>
						<input name="sellstatusid" type="text" style="display: none;"/>
						<div class="tip">商机状态</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field" data-flag="probability">
				<div>可能性 :</div>
				<div>
					<input placeholder="可能性(0.00-1.00)" type="text" name="probability"/>
				</div>
			</div>
			<!-- 
			<div class="field" data-flag="comefromid">
				<div>商机来源 :</div>
				<div>
					<a href="/mobilemode/apps/e-cology/crm/crmSellChanceContactLog.jsp" id="comfromid" class="more">
						<div class="text"></div>
						<input name="comefromid" type="text" style="display: none;"/>
						<div class="tip">商机来源</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div> -->
			<div class="field" data-flag="sufactor">
				<div>成功因素 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmSellChanceSufactor.jsp" data-formdata="callback=CRM.setSellAddPageSufactor" class="more">
						<div class="text"></div>
						<input name="sufactor" type="text" style="display: none;"/>
						<div class="tip">成功因素</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript">
	$("#predate").dateDropper({
		animate: false,
		format: 'Y-m-d',
		maxYear: '2099'
	});
	//判断非负整数
	function IsNum(num){
		var reNum=/^\d+$/;
		return(reNum.test(num));
	}
	//判断非负浮点数
	function IsFloat(num){
		var reNum=/^\d+(\.\d+)?$/;
		return(reNum.test(num));
	}
	//0-1的浮点数
	function IsFloat_1(num){
		var reNum=/^(0([\.]\d*[0-9]+)|0|1)$/;
		return(reNum.test(num));
	}
	$.extend(CRM, {
		buildSellAddPage : function(){
			var that = this;
			var $crm_sell_add = $("#crm_sell_add");
			$(".clear-btn", $crm_sell_add).click(function(){
				var $field = $(this).parents(".field[data-flag]");
				if($field.length > 0){
					var flag = $field.attr("data-flag");
					that.setSellAddFieldValue("", "", flag);
				}
			});
			$(".header .okBtn", $crm_sell_add).click(function(){
				var $form_msg = $(".form_msg", $crm_sell_add);
				var $form = $("form", $crm_sell_add);
				var $required_field = $(".field.required input", $form);
				
				var flag = false;
				$required_field.each(function(){
					if($.trim(this.value) == ""){
						flag = true;
						return;
					}
				});
				if(flag){
					$form_msg.html("必填信息不完整");
					$form_msg.show();
					//$name[0].focus();
					setTimeout(function(){$form_msg.hide();}, 1500);
					return;
				}
				//验证预期收益
				var $field_preyield = $("#crm_sell_add .field[data-flag='preyield']");
				var preyield = $("input[name='preyield']", $field_preyield).val();
				if(""!=preyield&&!IsFloat(preyield)){
					$form_msg.html("预期收益必须为>=0的数");
					$form_msg.show();
					setTimeout(function(){$form_msg.hide();}, 1500);
					return;
				}
				//验证可能性
				var $field_probability= $("#crm_sell_add .field[data-flag='probability']");
				var probability = $("input[name='probability']", $field_probability).val();
				if(""!=probability&&!IsFloat_1(probability)){
					$form_msg.html("可能性必须为0~1之间的数");
					$form_msg.show();
					setTimeout(function(){$form_msg.hide();}, 1500);
					return;
				}
				$form_msg.html("正在保存，请稍后...");
				$form_msg.show();
				that.ajax("/mobile/plugin/crm_new/crmSellChanceAction.jsp?action=saveSellChance", $form.serialize(), function(result){
					$form_msg.hide();
					history.go(-1);
					that.refreshCrmList();
				});
			});
			$("input[type='text'],input[type='number'],input[type='email'],input[type='tel']", $crm_sell_add).bind("input", function(){
				var v = this.value;
				var $field = $(this).closest(".field");
				if(v == ""){
					$field.removeClass("hasValue");
				}else{
					$field.addClass("hasValue");
				}
			});
		},
		setSellAddPageStatus : function(value, text){
			var that = this;
			that.setSellAddFieldValue(value, text, "sellstatusid");
		},
		setSellAddPageTypes : function(value, text){
			var that = this;
			that.setSellAddFieldValue(value, text, "selltypesid");
		},
		setSellAddPageManager : function(value, text){
			var that = this;
			that.setSellAddFieldValue(value, text, "manager");
		},
		setSellAddPageSufactor : function(value, text){
			var that = this;
			that.setSellAddFieldValue(value, text, "sufactor");
		},
		setSellAddPageCustomer : function(value, text){
			var that = this;
			that.setSellAddFieldValue(value, text, "customerid");
			that.setComeFromId(value);
			that.setZzyh(text);
		},
		setSellAddPageContactLog : function(value, text){
			var that = this;
			that.setSellAddFieldValue(value, text, "comefromid");
		},
		setSellAddFieldValue : function(value, text, flag){
			var $field = $("#crm_sell_add .field[data-flag='"+flag+"']");
			var $realField = $("input[name='"+flag+"']", $field);
			$realField.val(value);
			
			if(value == ""){
				$field.removeClass("hasValue");
			}else{
				$field.addClass("hasValue");
			}
			
			var $more = $(".more", $field);
			if($more.length > 0){
				$(".text", $more).html(text);
			}
		},
		setComeFromId :function(value){
			var $field = $("#crm_sell_add .field[data-flag='comefromid']");
			var $realField = $(".more", $field);
			$realField.attr("data-formdata","callback=CRM.setSellAddPageContactLog&crmid="+value);
		},
		setZzyh :function(value){
			var $field = $("#crm_sell_add .field[data-flag='zzyh']");
			var $realField = $("#zzyh", $field);
			$realField.val(value);
			//传客户名称，以此保存商机名称中
			var $field1 = $("#crm_sell_add .field[data-flag='customerid']");
			var $realField1 = $("#customername", $field1);
			$realField1.attr("value",value);
		}
	});
	CRM.buildSellAddPage();	
	</script>
</div>
</body>
</html>
