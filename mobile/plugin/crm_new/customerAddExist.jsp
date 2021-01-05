<!DOCTYPE html>
<%@page import="weaver.crm.Maint.CustomerTypeComInfo"%>
<%@page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
CustomerTypeComInfo comInfo = new CustomerTypeComInfo();
String value = "";
String text = "";
if(comInfo.next()){
	value = comInfo.getCustomerTypeid();
	text = Util.toScreen(comInfo.getCustomerTypename(),user.getLanguage());
}
%>
<html>
<head>
<title>新建客户-搜索</title>
</head>
<body>
<div id="crm_cust_add_exist" class="page out">
	<style type="text/css">
	#crm_cust_add_exist ul.list{overflow: auto; -webkit-overflow-scrolling: touch;}
	#crm_cust_add_exist ul.list li{padding:0px;}
	#crm_cust_add_exist ul.list li > a{padding: 10px 0px;}
	#crm_cust_add_exist ul.list .manager{float: right;font-size:12px;margin-right:3px;}
	#crm_cust_add_exist ul.list .cust-name{color:#333;font-size:14px;}
	#crm_cust_add_exist .search-result{visibility: hidden;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">新建客户</div>
		<div class="right searchBtn">搜索</div>
	</div>
	<div class="content">
		<div class="form_msg" style="top:140px;"></div>
		<form disabledEnterSubmit>
			<div class="field" data-flag="type">
				<div>类型 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmType.jsp" data-formdata="callback=CRM.setCrmAddExistPageType" class="more">
						<div class="text"></div>
						<input name="type" type="text" style="display: none;"/>
						<div class="tip">选择类型</div>
					</a>
					<div class="clear-btn" style="display:none;"></div>
				</div>
			</div>
			<div class="field">
				<div>名称 :</div>
				<div>
					<input placeholder="输入要新建的客户名称" type="text" name="name"/>
				</div>
			</div>
		</form>
		<ul style="list-style: none;padding:15px;margin: 0px;">
			<li style="font-size: 12px;color:#666;">请输入客户名称，系统将搜索是否有重名客户。</li>
			<li style="font-size: 12px;color:#666;">如已有类似名称客户存在，系统将给出提醒，否则直接进入新建客户卡片页面。</li>
		</ul>
		<div class="search-result">
			<div class="controlTitle" style="font-size: 12px;padding-top: 8px;">名称包含" <span>mm</span> "的客户如下：</div>
			<ul class="list"></ul>
		</div>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmAddExistPage : function(){
			var that = this;
			var $crm_custAddExist = $("#crm_cust_add_exist");
			$(".clear-btn", $crm_custAddExist).click(function(){
				var $field = $(this).parents(".field[data-flag]");
				if($field.length > 0){
					var flag = $field.attr("data-flag");
					that.setCrmAddExistFieldValue("", "", flag);
				}
			});
			var $list = $("ul.list", $crm_custAddExist);
			var t = $list.offset().top-45;
			$list.css({
				"position": "absolute",
				"left": "0px",
				"right": "0px",
				"bottom": "0px",
				"top": t + "px"
			});
			var $search_result = $(".search-result", $crm_custAddExist);
			$search_result.hide();
			$search_result.css("visibility","visible");
			
			$(".header .searchBtn", $crm_custAddExist).click(function(){
				$search_result.hide();
				$list.find("*").remove();
				var $form_msg = $(".form_msg", $crm_custAddExist);
				var $form = $("form", $crm_custAddExist);
				var $name = $("input[name='name']", $form);
				var name = $name.val();
				if($.trim(name) == ""){
					$form_msg.html("客户名称不能为空");
					$form_msg.show();
					//$name[0].focus();
					setTimeout(function(){$form_msg.hide();}, 1500);
					return;
				}
				$form_msg.html("正在查询，请稍后...");
				$form_msg.show();
				that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getExistCrm", $form.serialize(), function(result){
					$form_msg.hide();
					var type = $("input[name='type']", $form).val();
					var crms = result.crms;
					if(crms.length > 0){
						$(".header", $crm_custAddExist).append("<div class=\"right goBtn\" style=\"right:50px;\">继续</div>");
						$(".header .goBtn", $crm_custAddExist).click(function(){
							location.href = '#&/mobile/plugin/crm_new/customerAdd.jsp?name='+name+"&type="+type;
						})
						$(".controlTitle span",$search_result).html(name);
						$.each(crms, function(i, cdata){
							$list.append("<li><a href=\"/mobile/plugin/crm_new/customer.jsp?id="+cdata["id"]+"\"><div class=\"manager\">"+cdata["manager"]+"</div><div class=\"cust-name\">"+cdata["name"]+"</div></a></li>");
						});
						$search_result.show();
					}else{
						location.href = '#&/mobile/plugin/crm_new/customerAdd.jsp?name='+name+"&type="+type;
					}
					//重置form
					//$form[0].reset();
					//that.setCrmAddExistFieldValue("<%=value%>", "<%=text%>", "type");
				});
			});
			that.setCrmAddExistFieldValue("<%=value%>", "<%=text%>", "type");
		},
		setCrmAddExistPageType : function(value, text){
			var that = this;
			that.setCrmAddExistFieldValue(value, text, "type");
		},
		setCrmAddExistFieldValue : function(value, text, flag){
			var $field = $("#crm_cust_add_exist .field[data-flag='"+flag+"']");
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
		}
	});
	CRM.buildCrmAddExistPage();	
	</script>
</div>
</body>
</html>
