<!DOCTYPE html>
<%@page import="weaver.general.Util" %>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit" %>
<%@page import="weaver.hrm.User" %>
<%@page import="weaver.crm.CrmShareBase" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	User user = MobileUserInit.getUser(request, response);
	if (user == null) {
		out.println("无用户，请登录");
		return;
	}
%>
<html>
<head>
	<title>新建联系人</title>
</head>
<body>
<div id=crm_newContacter1 class="page out">
	<style type="text/css">
		#crm_newContacter1 .form_msg {
			top: 185px;
		}

		#crm_newContacter1 form .field {
			padding-left: 15px;
		}

		#crm_newContacter1 form .field.required:before {
			content: '*';
			position: absolute;
			top: 50%;
			left: 5px;
			transform: translateY(-50%);
			height: 10px;
			font-size: 16px;
			color: red;
		}

		#crm_newContacter1 form .field.required.hasValue:before {
			display: none;
		}

		#crm_newContacter1 form .field > div:nth-child(1) {
			display: none;
		}

		#crm_newContacter1 .lbs {
			display: block;
			height: 100%;
			width: 50px;
			position: absolute;
			top: 0px;
			right: 0px;
			background-image: url('/mobile/plugin/crm_new/images/lbs_wev8.png');
			background-repeat: no-repeat;
			background-size: 20px 20px;
			background-position: 20px center;
		}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">新建联系人</div>
		<div class="right okBtn"></div>
	</div>
	<div class="content">
		<div class="form_msg"></div>
		<form>
			<div class="field required" data-flag="customerid">
				<div>客户 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmCustomer.jsp" data-formdata="callback=CRM.setContacterAddPageCustomer" class="more">
						<div class="text"></div>
						<input name="customerid" type="text" style="display: none;"/>
						<div class="tip">客户</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="title">
				<div>称呼 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmContacterTitle.jsp" data-formdata="callback=CRM.setContacterAddPageTitle" class="more">
						<div class="text"></div>
						<input name="title" type="text" style="display: none;"/>
						<div class="tip">称呼</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" data-flag="firstname" style="box-sizing: content-box;">
				<div>姓名 :</div>
				<div>
					<input placeholder="姓名" type="text" name="firstname"/>
				</div>
			</div>
			<div class="field required" data-flag="jobtitle" style="box-sizing: content-box;">
				<div>职务 :</div>
				<div>
					<input placeholder="工作头衔" type="text" name="jobtitle"/>
				</div>
			</div>
			<div class="field" data-flag="mobilephone" style="box-sizing: content-box;">
				<div>移动电话 :</div>
				<div>
					<input placeholder="移动电话" type="tel" name="mobilephone"/>
				</div>
			</div>
			<div class="field" data-flag="phoneoffice" style="box-sizing: content-box;">
				<div>办公电话 :</div>
				<div>
					<input placeholder="办公室电话" type="number" name="phoneoffice"/>
				</div>
			</div>
			<div class="field" data-flag="contacteremail" style="box-sizing: content-box;">
				<div>电子邮件 :</div>
				<div>
					<input placeholder="电子邮件" type="email" name="contacteremail"/>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript">
        $.extend(CRM, {
            buildNewContacterPage: function () {
                var that = this;
                var $crm_newContacter1 = $("#crm_newContacter1");
                $(".clear-btn", $crm_newContacter1).click(function () {
                    var $field = $(this).parents(".field[data-flag]");
                    if ($field.length > 0) {
                        var flag = $field.attr("data-flag");
                        that.setContacterAddFieldValue("", "", flag);
                    }
                });
                $(".header .okBtn", $crm_newContacter1).click(function () {
                    var $form_msg = $(".form_msg", $crm_newContacter1);
                    var $form = $("form", $crm_newContacter1);
                    var firstname = $("input[name='firstname']", $form).val();
                    var jobtitle = $("input[name='jobtitle']", $form).val();
                    var title = $("input[name='title']", $form).val();
                    var customerid = $("input[name='customerid']", $form).val();
                    if ($.trim(customerid) == "") {
                        $form_msg.html("客户不能为空");
                        $form_msg.show();
                        setTimeout(function () {
                            $form_msg.hide();
                        }, 1000);
                        return;
                    }else if ($.trim(title) == "") {
                        $form_msg.html("称呼不能为空");
                        $form_msg.show();
                        setTimeout(function () {
                            $form_msg.hide();
                        }, 1000);
                        return;
                    } else if ($.trim(firstname) == "") {
                        $form_msg.html("姓名不能为空");
                        $form_msg.show();
                        setTimeout(function () {
                            $form_msg.hide();
                        }, 1000);
                        return;
                    } else if ($.trim(jobtitle) == "") {
                        $form_msg.html("工作头衔不能为空");
                        $form_msg.show();
                        setTimeout(function () {
                            $form_msg.hide();
                        }, 1000);
                        return;
                    }
                    $form_msg.html("正在保存，请稍后...");
                    $form_msg.show();
                    that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=saveContacter", $form.serialize(), function (result) {
                        $form_msg.hide();
                        var errMsg = result["errMsg"];
                        if(errMsg){
                            alert(errMsg);
						}else{
                            //重置form
                            $form[0].reset();
                            that.setContacterAddFieldValue("", "", "customerid");
                            that.setContacterAddFieldValue("", "", "title");
                            $(".btnSelect li.checked", $crm_newContacter1).removeClass("checked");
                            that.refreshCrmList();
                            //返回
                            history.go(-1);
						}
                    });
                });


                $("input[type='text'],input[type='number'],input[type='email'],input[type='tel']", $crm_newContacter1).bind("input", function(){
                    var v = this.value;
                    var $field = $(this).closest(".field");
                    if(v == ""){
                        $field.removeClass("hasValue");
                    }else{
                        $field.addClass("hasValue");
                    }
                });
            }, setContacterAddPageCustomer: function (value, text ,flag , isBack) {
                CRM.setContacterAddFieldValue(value, text, flag);
                if(isBack == true){
                    history.go(-1);
                }
            }, setContacterAddPageTitle: function (value, text) {
                var that = this;
                that.setContacterAddFieldValue(value, text, "title");
            }, setContacterAddFieldValue: function (value, text, flag) {
                var $field = $("#crm_newContacter1 .field[data-flag='" + flag + "']");
                var $realField = $("input[name='" + flag + "']", $field);
                $realField.val(value);

                if (value == "") {
                    $field.removeClass("hasValue");
                } else {
                    $field.addClass("hasValue");
                }

                var $more = $(".more", $field);
                if ($more.length > 0) {
                    $(".text", $more).html(text);
                }
            }
        });
        CRM.buildNewContacterPage();
	</script>
</div>
</body>
</html>