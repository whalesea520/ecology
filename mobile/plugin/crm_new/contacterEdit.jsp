<!DOCTYPE html>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = MobileUserInit.getUser(request, response);
	if(user == null){
		out.println("无用户，请登录");
		return;
	}
	String id = Util.null2String(request.getParameter("id"));
	rs.executeProc("CRM_CustomerContacter_SByID", id);
	if (rs.getCounts() <= 0) {
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();
	String customerid = rs.getString(2);
	CrmShareBase crmShareBase = new CrmShareBase();
	//判断是否有查看该客户权限
	int sharelevel = crmShareBase.getRightLevelForCRM("" + user.getUID(), customerid);
	boolean canEdit = false;
	if(sharelevel > 1) canEdit = true;
	if(!canEdit){
		out.println("您没有权限编辑该客户联系人");
		return;
	}
%>
<html>
<head>
	<title>客户联系人编辑</title>
	<style type="text/css">
		#crm_contacter_detail_edit form .field {
			padding-left: 15px;
		}

		#crm_contacter_detail_edit form .field.required:before {
			content: '*';
			position: absolute;
			top: 50%;
			left: 5px;
			transform: translateY(-50%);
			height: 10px;
			font-size: 16px;
			color: red;
		}

		#crm_contacter_detail_edit form .field.required.hasValue:before {
			display: none;
		}

		#crm_contacter_detail_edit form .field > div:nth-child(1) {
			display: none;
		}

		#crm_contacter_detail_edit .lbs {
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
</head>
<body>
<div id=crm_contacter_detail_edit class="page out">
	<style type="text/css">
		#crm_contacter_detail_edit .form_msg {
			top: 185px;
		}

		#crm_contacter_detail_edit form .field {
			padding-left: 15px;
		}

		#crm_contacter_detail_edit form .field.required:before {
			content: '*';
			position: absolute;
			top: 50%;
			left: 5px;
			transform: translateY(-50%);
			height: 10px;
			font-size: 16px;
			color: red;
		}

		#crm_contacter_detail_edit form .field.required.hasValue:before {
			display: none;
		}

		#crm_contacter_detail_edit form .field > div:nth-child(1) {
			display: none;
		}

		#crm_contacter_detail_edit .lbs {
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
		<div class="left" onclick="javascript:history.go(-1);">编辑联系人</div>
		<div class="right okBtn"></div>
	</div>
	<div class="content">
		<div class="form_msg"></div>
		<form>
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="customerid" value="<%=customerid%>">
			<div class="field required" data-flag="title">
				<div>称呼 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmContacterTitle.jsp" data-formdata="callback=CRM.setContacterEditPageTitle" class="more">
						<div class="text"></div>
						<input name="title" type="text" style="display: none;"/>
						<div class="tip">称呼</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field required" style="box-sizing: content-box;" data-flag="fullname">
				<div>姓名 :</div>
				<div>
					<input placeholder="姓名" type="text" name="fullname"/>
				</div>
			</div>
			<div class="field required" style="box-sizing: content-box;" data-flag="jobtitle">
				<div>职务 :</div>
				<div>
					<input placeholder="职务" type="text" name="jobtitle"/>
				</div>
			</div>
			<%--<div class="field" style="box-sizing: content-box;">--%>
				<%--<div>部门 :</div>--%>
				<%--<div>--%>
					<%--<input placeholder="部门" type="text" name="department"/>--%>
				<%--</div>--%>
			<%--</div>--%>
			<div class="field" style="box-sizing: content-box;">
				<div>移动电话 :</div>
				<div>
					<input placeholder="移动电话" type="tel" name="mobilephone"/>
				</div>
			</div>
			<div class="field" style="box-sizing: content-box;">
				<div>办公电话 :</div>
				<div>
					<input placeholder="办公电话" type="number" name="phoneoffice"/>
				</div>
			</div>
			<div class="field" style="box-sizing: content-box;">
				<div>电子邮件 :</div>
				<div>
					<input placeholder="电子邮件" type="email" name="contacteremail"/>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript">
        $.extend(CRM, {
            buildEditContacterPage: function () {
                var that = this;
                var $crm_contacter_detail_edit = $("#crm_contacter_detail_edit");
				var id= "<%=id%>";
                $(".clear-btn", $crm_contacter_detail_edit).click(function () {
                    var $field = $(this).parents(".field[data-flag]");
                    if ($field.length > 0) {
                        var flag = $field.attr("data-flag");
                        that.setContacterEditFieldValue("", "", flag);
                    }
                });
                $(".header .okBtn", $crm_contacter_detail_edit).click(function () {
                    var $form_msg = $(".form_msg", $crm_contacter_detail_edit);
                    var $form = $("form", $crm_contacter_detail_edit);
                    var title = $("input[name='title']", $form).val();
                    var fullname = $("input[name='fullname']", $form).val();
                    var jobtitle = $("input[name='jobtitle']", $form).val();

                    if ($.trim(title) == "") {
                        $form_msg.html("称呼不能为空");
                        $form_msg.show();
                        setTimeout(function () {
                            $form_msg.hide();
                        }, 1000);
                        return;
                    }else if ($.trim(fullname) == "") {
                        $form_msg.html("姓名不能为空");
                        $form_msg.show();
                        setTimeout(function () {
                            $form_msg.hide();
                        }, 1000);
                        return;
                    } else if ($.trim(jobtitle) == "") {
                        $form_msg.html("职务不能为空");
                        $form_msg.show();
                        setTimeout(function () {
                            $form_msg.hide();
                        }, 1000);
                        return;
                    }
                    $form_msg.html("正在保存，请稍后...");
                    $form_msg.show();
                    that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=updateContacter", $form.serialize(), function (result) {
                        $form_msg.hide();
                        var errMsg = result["errMsg"];
                        if(errMsg){
                            alert(errMsg);
                        }else{
                            //重置form
                            $form[0].reset();
                            that.setContacterEditFieldValue("", "", "title");
                            $(".btnSelect li.checked", $crm_contacter_detail_edit).removeClass("checked");
                            //返回
                            history.go(-1);
                            if(typeof(that.buildContacterPage) == "function"){
                                that.buildContacterPage(id,true,'<%=customerid%>');
                            }
                        }
                    });
                });

                $("input[type='text'],input[type='number'],input[type='email'],input[type='tel']", $crm_contacter_detail_edit).bind("input", function(){
                    var v = this.value;
                    var $field = $(this).closest(".field");
                    if(v == ""){
                        $field.removeClass("hasValue");
                    }else{
                        $field.addClass("hasValue");
                    }
                });

                that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getContacter&id="+id, function(result){
                    var data = result["data"];
                    var lastname = data["lastname"];
                    var fullname = data["fullname"];
                    var title = data["title"];
                    var titleid = data["titleid"];
                    var jobtitle = data["jobtitle"];
                    var mobilephone = data["mobilephone"];
                    var phoneoffice = data["phoneoffice"];
                    var email = data["email"];
                    var customerName = data["customerName"];
                    // var department = data["department"];
                    var customerAddress = data["customerAddress"];
                    var $form = $("form", $crm_contacter_detail_edit);
                    that.setContacterEditPageTitle(titleid,title);
                    $("input[name='fullname']", $form).val(fullname);
                    $("input[name='jobtitle']", $form).val(jobtitle);
                    that.setContacterEditFieldValue(fullname, fullname, "fullname");
                    that.setContacterEditFieldValue(jobtitle, jobtitle, "jobtitle");
                    // $("input[name='department']", $form).val(department);
                    $("input[name='mobilephone']", $form).val(mobilephone);
                    $("input[name='phoneoffice']", $form).val(phoneoffice);
                    $("input[name='contacteremail']", $form).val(email);
                });
            }, setContacterEditPageTitle: function (value, text) {
                var that = this;
                that.setContacterEditFieldValue(value, text, "title");
            }, setContacterEditFieldValue: function (value, text, flag) {
                var $field = $("#crm_contacter_detail_edit .field[data-flag='" + flag + "']");
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
        CRM.buildEditContacterPage();
	</script>
</div>
</body>
</html>
