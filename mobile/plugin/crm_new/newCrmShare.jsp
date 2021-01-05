<!DOCTYPE html>
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
String id = Util.null2String(request.getParameter("id"));
%>
<html>
<head>
<title>添加共享</title>
</head>
<body>
<div id="crm_newCrmShare" class="page out">
	<style type="text/css">
	#crm_newCrmShare ul.btnSelect{margin:5px 0px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">添加共享</div>
		<div class="right okBtn"></div>
	</div>
	<div class="content">
		<div class="form_msg"></div>
		<form disabledEnterSubmit class="biger">
			<input type="hidden" name="customerid" value="<%=id%>" />
			<div class="field vertical">
				<div>共享类型 :</div>
				<div>
					<ul class="btnSelect" data-flag="sharetype">
						<li class="checked" data-value="1">人力资源</li>
					</ul>
					<input type="text" name="sharetype" style="display: none;" value="1"/>
				</div>
			</div>
			<div class="field" data-flag="relatedshareid">
				<div>共享对象 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/hrmList.jsp" data-formdata="id=<%=id %>&flag=new_crm_share&isMilt=1&callback=CRM.setCrmShareRelatedshareid" class="more">
						<div class="text"></div>
						<input name="relatedshareid" type="text" style="display: none;"/>
						<div class="tip">选择人员</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field vertical">
				<div>共享级别 :</div>
				<div>
					<ul class="btnSelect" data-flag="sharelevel">
						<li class="checked" data-value="1">查看</li>
						<li data-value="2">编辑</li>
					</ul>
					<input type="text" name="sharelevel" style="display: none;"  value="1"/>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildNewCrmSharePage : function(id){
			var that = this;
			var $crm_newCrmShare = $("#crm_newCrmShare");
			
			$(".btnSelect li", $crm_newCrmShare).click(function(){
				var $this = $(this);
				if(!$this.hasClass("checked")){
					$this.siblings("li.checked").removeClass("checked");
					$this.addClass("checked");
					var v = $this.attr("data-value");
					var flag = $this.parent().attr("data-flag");
					$("input[name='"+flag+"']", $crm_newCrmShare).val(v);
				}
			});
			
			$(".clear-btn", $crm_newCrmShare).click(function(){
				var $field = $(this).parents(".field[data-flag]");
				if($field.length > 0){
					var flag = $field.attr("data-flag");
					that.setCrmShareFieldValue("", "", flag);
				}
			});
			
			$(".header .okBtn", $crm_newCrmShare).click(function(){
				var $form_msg = $(".form_msg", $crm_newCrmShare);
				var $form = $("form", $crm_newCrmShare);
				var relatedshareid = $("input[name='relatedshareid']", $form).val();
				if($.trim(relatedshareid) == ""){
					$form_msg.html("共享对象不能为空");
					$form_msg.show();
					setTimeout(function(){$form_msg.hide();}, 1000);
					return;
				}
				$form_msg.html("正在保存，请稍后...");
				$form_msg.show();
				that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=saveCrmShare", $form.serialize(), function(result){
					$form_msg.hide();
					//返回
					history.go(-1);
					//重置form
					$form[0].reset();
					that.setCrmShareRelatedshareid("", "");
					$(".btnSelect", $crm_newCrmShare).each(function(){
						$("li.checked", $(this)).removeClass("checked").eq(0).addClass("checked");
					});
					
					//刷新列表
					if(typeof(that.refreshShareViewList) == "function"){
						that.refreshShareViewList(id);
					}
				});
			});
		},
		setCrmShareRelatedshareid : function(id, name){
			var that = this;
			that.setCrmShareFieldValue(id, name, "relatedshareid");
		},
		setCrmShareFieldValue : function(value, text, flag){
			var $field = $("#crm_newCrmShare .field[data-flag='"+flag+"']");
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
	CRM.buildNewCrmSharePage("<%=id%>");
	</script>
</div>
</body>
</html>
