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
String name = Util.null2String(request.getParameter("name"));
String typeid = Util.null2String(request.getParameter("type"));
CustomerTypeComInfo comInfo = new CustomerTypeComInfo();
String typeText = comInfo.getCustomerTypename(typeid);

%>
<html>
<head>
<title>新建客户</title>
</head>
<body>
<div id="crm_cust_add" class="page out">
	<style type="text/css">
	#crm_cust_add .form_msg{top: 185px;}
	#crm_cust_add form .field {padding-left: 15px;}
	#crm_cust_add form .field.required:before {content: '*';position: absolute;top: 50%;left: 5px;transform: translateY(-50%);height: 10px;font-size: 16px;color: red;}
	#crm_cust_add form .field.required.hasValue:before{display:none;}
	#crm_cust_add form .field > div:nth-child(1) {display: none;}
	#crm_cust_add .lbs{display: block;height: 100%;width: 50px;position: absolute;top: 0px;right: 0px;background-image: url('/mobile/plugin/crm_new/images/lbs_wev8.png');background-repeat: no-repeat;background-size: 20px 20px;background-position: 20px center;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">新建客户</div>
		<div class="right okBtn"></div>
	</div>
	<div class="form_msg"></div>
	<div class="content">
		<form disabledEnterSubmit>
			<div class="controlTitle" style="font-size: 12px;">一般信息</div>
			<div class="field required" data-flag="name">
				<div>名称 :</div>
				<div>
					<input placeholder="客户名称" type="text" name="name"/>
				</div>
			</div>
			<!-- 
			<div class="field">
				<div>客户编码 :</div>
				<div>
					<input placeholder="客户编码" type="text" name="crmcode"/>
				</div>
			</div>
			 -->
			<div class="field required">
				<div>客户简称 :</div>
				<div>
					<input placeholder="客户简称" type="text" name="engname"/><!-- Abbrev -->
				</div>
			</div>
			<input type="hidden" name="lnglat" id="lnglat"/>
			<div class="field required" data-flag="address1">
				<div>地址 :</div>
				<div>
					<input placeholder="地址 " type="text" name="address1"/>
					<a href="/mobile/plugin/crm_new/crmMap.jsp" data-formdata="callback=CRM.setCrmAddPageAddress1" class="lbs" data-reload="true"></a>
				</div>
			</div>
			<div class="field required">
				<div>电话 :</div>
				<div>
					<input placeholder="电话 " type="number" name="phone"/>
				</div>
			</div>
			<div class="field required" style="border-bottom:none;">
				<div>电子邮件:</div>
				<div>
					<input placeholder="电子邮件 " type="email" name="email"/>
				</div>
			</div>
			<div class="controlTitle" style="font-size: 12px;">分类信息</div>
			<div class="field required" data-flag="status">
				<div>状态 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmStatus.jsp" data-formdata="callback=CRM.setCrmAddPageStatus" class="more">
						<div class="text"></div>
						<input name="status" type="text" style="display: none;"/>
						<div class="tip">状态</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="type">
				<div>类型 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmType.jsp" data-formdata="callback=CRM.setCrmAddPageType" class="more">
						<div class="text"></div>
						<input name="type" type="text" style="display: none;"/>
						<div class="tip">类型</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="description">
				<div>描述:</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmDesc.jsp" data-formdata="callback=CRM.setCrmAddPageDesc" class="more">
						<div class="text"></div>
						<input name="description" type="text" style="display: none;"/>
						<div class="tip">描述</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="size_n">
				<div>规模 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmSize.jsp" data-formdata="callback=CRM.setCrmAddPageSize" class="more">
						<div class="text"></div>
						<input name="size_n" type="text" style="display: none;"/>
						<div class="tip">规模</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="source">
				<div>获得途径 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmWay.jsp" data-formdata="callback=CRM.setCrmAddPageWay" class="more">
						<div class="text"></div>
						<input name="source" type="text" style="display: none;"/>
						<div class="tip">获得途径</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="sector">
				<div>行业 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmSector.jsp" data-formdata="callback=CRM.setCrmAddPageSector" class="more">
						<div class="text"></div>
						<input name="sector" type="text" style="display: none;"/>
						<div class="tip">行业</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="manager" style="border-bottom:none;">
				<div>客户经理 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/hrmList.jsp" data-formdata="flag=add_customer&isMilt=0&callback=CRM.setCrmAddPageManager" class="more">
						<div class="text"></div>
						<input name="manager" type="text" style="display: none;"/>
						<div class="tip">客户经理</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="controlTitle" style="font-size: 12px;">联系人</div>
			<div class="field required" data-flag="title">
				<div>称呼 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmContacterTitle.jsp" data-formdata="callback=CRM.setCrmAddPageTitle" class="more">
						<div class="text"></div>
						<input name="title" type="text" style="display: none;"/>
						<div class="tip">称呼</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required">
				<div>姓名 :</div>
				<div>
					<input placeholder="姓名" type="text" name="firstname"/>
				</div>
			</div>
			<div class="field required">
				<div>工作头衔 :</div>
				<div>
					<input placeholder="工作头衔" type="text" name="jobtitle"/>
				</div>
			</div>
			<div class="field">
				<div>移动电话 :</div>
				<div>
					<input placeholder="移动电话" type="tel" name="mobilephone"/>
				</div>
			</div>
			<div class="field">
				<div>办公室电话 :</div>
				<div>
					<input placeholder="办公室电话" type="number" name="phoneoffice"/>
				</div>
			</div>
			<div class="field" style="border-bottom: none;">
				<div>电子邮件 :</div>
				<div>
					<input placeholder="电子邮件" type="email" name="contacteremail"/>
				</div>
			</div>
			<div class="controlTitle" style="font-size: 12px;">帐务</div>
			<div class="field required" data-flag="CreditAmount">
				<div>信用额度 :</div>
				<div>
					<input placeholder="信用额度" type="number" name="CreditAmount"/>
				</div>
			</div>
			<div class="field required" data-flag="CreditTime">
				<div>信用期间 :</div>
				<div>
					<input placeholder="信用期间" type="number" name="CreditTime"/>
				</div>
			</div>
			<div class="field">
				<div>开户银行 :</div>
				<div>
					<input placeholder="开户银行" type="text" name="bankname"/>
				</div>
			</div>
			<div class="field">
				<div>帐户 :</div>
				<div>
					<input placeholder="帐户" type="text" name="accountname"/>
				</div>
			</div>
			<div class="field">
				<div>银行帐号 :</div>
				<div>
					<input placeholder="银行帐号" type="text" name="accounts"/>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmAddPage : function(crmName, typeid, typeText, managerid, managername){
			var that = this;
			var $crm_cust_add = $("#crm_cust_add");
			$(".clear-btn", $crm_cust_add).click(function(){
				var $field = $(this).parents(".field[data-flag]");
				if($field.length > 0){
					var flag = $field.attr("data-flag");
					that.setCrmAddFieldValue("", "", flag);
				}
			});
			
			$(".header .okBtn", $crm_cust_add).click(function(){
				var $form_msg = $(".form_msg", $crm_cust_add);
				var $form = $("form", $crm_cust_add);
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
				$form_msg.html("正在保存，请稍后...");
				$form_msg.show();
				$(".header .okBtn").hide();
				that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=saveCustomer", $form.serialize(), function(result){
					$form_msg.hide();
					history.go(-2);
					that.refreshCrmList();
				});
			});
			
			that.setCrmAddFieldValue(crmName, "", "name");
			that.setCrmAddFieldValue(typeid, typeText, "type");
			that.setCrmAddFieldValue(managerid, managername, "manager");
			that.setCrmAddFieldValue("1000000.00", "", "CreditAmount");
			that.setCrmAddFieldValue("30", "", "CreditTime");
			
			
			$("input[type='text'],input[type='number'],input[type='email'],input[type='tel']", $crm_cust_add).bind("input", function(){
				var v = this.value;
				var $field = $(this).closest(".field");
				if(v == ""){
					$field.removeClass("hasValue");
				}else{
					$field.addClass("hasValue");
				}
			});
		},
		setCrmAddPageStatus : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "status");
		},
		setCrmAddPageType : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "type");
		},
		setCrmAddPageSector : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "sector");
		},
		setCrmAddPageDesc : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "description");
		},
		setCrmAddPageSize : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "size_n");
		},
		setCrmAddPageWay : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "source");
		},
		setCrmAddPageManager : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "manager");
		},
		setCrmAddPageTitle : function(value, text){
			var that = this;
			that.setCrmAddFieldValue(value, text, "title");
		},
		setCrmAddPageAddress1 : function(value,text){
			var that = this;
			$("#lnglat").val(text);
			that.setCrmAddFieldValue(value, "", "address1");
		},
		setCrmAddFieldValue : function(value, text, flag){
			var $field = $("#crm_cust_add .field[data-flag='"+flag+"']");
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
	CRM.buildCrmAddPage("<%=name%>","<%=typeid%>","<%=typeText%>","<%=user.getUID()%>","<%=user.getLastname()%>");	
	</script>
</div>
</body>
</html>
