<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.crm.Maint.ContacterTitleComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String cid =  Util.null2String(request.getParameter("contactid"));
String id = Util.null2String(request.getParameter("id"));
CrmShareBase crmShareBase = new CrmShareBase();
//判断是否有查看该客户权限
boolean canEdit = false;
int sharelevel = crmShareBase.getRightLevelForCRM("" + user.getUID(), id);
if(sharelevel <= 1){
	out.println("您没有权限查看联系人");
	return;
}else if(sharelevel>1){
	canEdit = true;
}
%>
<html>
<head>
<title><%=canEdit?"编辑":"查看"%>联系人</title>
</head>
<body>
<div id=crm_editContacter class="page out">
	<style type="text/css">
	#crm_editContacter .form_msg{top: 185px;}
	#crm_editContacter form .field > div:nth-child(1) {<%=canEdit?"display: none":"width:80px"%>;}
	#crm_editContacter form .field {padding-left: <%=canEdit?"15px":"95px;"%>;}
	#crm_editContacter form .field.required:before {content: '*';position: absolute;top: 50%;left: 5px;transform: translateY(-50%);height: 10px;font-size: 16px;color: red;}
	#crm_editContacter form .field.required.hasValue:before{display:none;}
	#crm_editContacter .lbs{display: block;height: 100%;width: 50px;position: absolute;top: 0px;right: 0px;background-image: url('/mobile/plugin/crm_new/images/lbs_wev8.png');background-repeat: no-repeat;background-size: 20px 20px;background-position: 20px center;}
	.viewDiv{font-size:14px;line-height:40px;}
	</style>
	<input type="hidden" id="userinfo" showname="<%=user.getLastname()%>" value="<%=user.getUID() %>" >
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);"><%=canEdit?"编辑":"查看"%>联系人</div>
		<%if(canEdit){%><div class="right okBtn"></div><%}%>
	</div>
	<div class="content">
		<div class="form_msg"></div>
		<form>
			<input type="hidden" name="id" value="<%=cid%>" />
			<table width="100%">
				<tr>
					<td>
						<div class="field required" data-flag="title">
							<div>称呼 :</div>
							<div id="call">
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="field required">
							<div>姓名 :</div>
							<div id="firstname">
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="field required">
							<div>工作头衔 :</div>
							<div id="jobtitle">
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="field">
							<div>移动电话 :</div>
							<div id="mobilephone">
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="field">
							<div>办公室电话 :</div>
							<div id="phoneoffice">
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="field" >
							<div>电子邮件 :</div>
							<div id="contacteremail">
							</div>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildEditContacterPage : function(id){
			var that = this;
			var canEdit = <%=canEdit%>;
			if(canEdit==true){
				var callStr="<a href=\"/mobile/plugin/crm_new/crmContacterTitle.jsp\" data-formdata=\"callback=CRM.setContacterEditPageTitle\" class=\"more\">"
					+"<div id=\"title\" class=\"text\"></div>"
					+"<input name=\"title\" type=\"hidden\"/>"
					+"<div class=\"tip\">称呼</div>"
					+"</a>"
					+"<div class=\"clear-btn\"></div>";
				$("[id='call']", $crm_editContacter).html(callStr);
				
				var firstnameStr = "<input placeholder=\"姓名\" type=\"text\" name=\"firstname\"/>";
				$("[id='firstname']", $crm_editContacter).html(firstnameStr);
				
				var jobtitleStr = "<input placeholder=\"工作头衔\" type=\"text\" name=\"jobtitle\"/>";
				$("[id='jobtitle']", $crm_editContacter).html(jobtitleStr);
				
				var mobilephoneStr = "<input placeholder=\"移动电话\" type=\"tel\" name=\"mobilephone\"/>";
				$("[id='mobilephone']", $crm_editContacter).html(mobilephoneStr);
				
				var phoneofficeStr = "<input placeholder=\"办公室电话\" type=\"number\" name=\"phoneoffice\"/>";
				$("[id='phoneoffice']", $crm_editContacter).html(phoneofficeStr);
				
				var contacteremailStr = "<input placeholder=\"电子邮件\" type=\"email\" name=\"contacteremail\"/>";
				$("[id='contacteremail']", $crm_editContacter).html(contacteremailStr);
				
			}
			
			var $crm_editContacter = $("#crm_editContacter");
			that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getContacter&cid="+id, function(result){
				var data = result["data"];
				if(""!=data["_title"]){
					if(canEdit==true){
						$("[name='title']", $crm_editContacter).val(data["_title"]);
						$("[id='title']", $crm_editContacter).html(data["title"]);
						$("[class='tip']", $crm_editContacter).empty();
					}else{
						$("[id='call']", $crm_editContacter).html("<div class=\"viewDiv\">"+data["title"]+"</div>");
					}
				}
				if(""!=data["fullname"])
					if(canEdit==true)
						$("[name='firstname']", $crm_editContacter).val(data["fullname"]);
					else
						$("[id='firstname']", $crm_editContacter).html("<div class=\"viewDiv\">"+data["fullname"]+"</div>");
				if(""!=data["jobtitle"])
					if(canEdit==true)
						$("[name='jobtitle']", $crm_editContacter).val(data["jobTitle"]);
					else
						$("[id='jobtitle']", $crm_editContacter).html("<div class=\"viewDiv\">"+data["jobTitle"]+"</div>");
				if(""!=data["mobilephone"])
					if(canEdit==true)
						$("[name='mobilephone']", $crm_editContacter).val(data["mobilephone"]);
					else
						$("[id='mobilephone']", $crm_editContacter).html("<div class=\"viewDiv\">"+data["mobilephone"]+"</div>");
				if(""!=data["phoneoffice"])
					if(canEdit==true)
						$("[name='phoneoffice']", $crm_editContacter).val(data["phoneoffice"]);
					else
						$("[id='phoneoffice']", $crm_editContacter).html("<div class=\"viewDiv\">"+data["phoneoffice"]+"</div>");
				if(""!=data["email"])
					if(canEdit==true)
						$("[name='contacteremail']", $crm_editContacter).val(data["email"]);
					else
						$("[id='contacteremail']", $crm_editContacter).html("<div class=\"viewDiv\">"+data["email"]+"</div>");
			})
			
			$(".clear-btn", $crm_editContacter).click(function(){
				var $field = $(this).parents(".field[data-flag]");
				if($field.length > 0){
					var flag = $field.attr("data-flag");
					that.setContacterEditFieldValue("", "", flag);
				}
			});
			$(".header .okBtn", $crm_editContacter).click(function(){
				var $form_msg = $(".form_msg", $crm_editContacter);
				var $form = $("form", $crm_editContacter);
				var firstname = $("input[name='firstname']", $form).val();
				var jobtitle = $("input[name='jobtitle']", $form).val();
				var title = $("input[name='title']", $form).val();
				if($.trim(title) == ""){
					$form_msg.html("称呼不能为空");
					$form_msg.show();
					setTimeout(function(){$form_msg.hide();}, 1000);
					return;
				}else if($.trim(firstname) == ""){
					$form_msg.html("姓名不能为空");
					$form_msg.show();
					setTimeout(function(){$form_msg.hide();}, 1000);
					return;
				}else if($.trim(jobtitle) == ""){
					$form_msg.html("工作头衔不能为空");
					$form_msg.show();
					setTimeout(function(){$form_msg.hide();}, 1000);
					return;
				}
				$form_msg.html("正在保存，请稍后...");
				$form_msg.show();
				that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=updContacter", $form.serialize(), function(result){
					$form_msg.hide();
					that.buildEditContacterPage(id);
				});
			});
		},
		setContacterEditPageTitle : function(value, text){
			var that = this;
			that.setContacterEditFieldValue(value, text, "title");
		},
		setContacterEditFieldValue : function(value, text, flag){
			var $field = $("#crm_editContacter .field[data-flag='"+flag+"']");
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
	CRM.buildEditContacterPage("<%=cid%>");
	</script>
</div>
</body>
</html>