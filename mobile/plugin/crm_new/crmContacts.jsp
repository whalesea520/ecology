<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.crm.CrmShareBase"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String id = Util.null2String(request.getParameter("id"));
CrmShareBase crmShareBase = new CrmShareBase();
//判断是否有查看该客户权限
int sharelevel = crmShareBase.getRightLevelForCRM("" + user.getUID(), id);
boolean canEdit = false;
if(sharelevel > 1) canEdit = true;
%>
<html>
<head>
<title>联系人</title>
</head>
<body>
<div id="crm_contacts" class="page out">
	<style type="text/css">
		#crm_contacts ul.list li > div.line {-webkit-transition: -webkit-transform 0.3s;transition: transform 0.3s;}
		#crm_contacts ul.list li > div.line img{margin:1px 15px 0 0;}
		#crm_contacts ul.list li > div.line div a{color:#777;}
		#crm_contacts ul.list li > div.line div:nth-child(3){margin-left:55px;word-break:break-all;}
		
		#crm_contacts .slideBtnContainer{background-color: #f0f0f0;}
		#crm_contacts .btnContainer a{width:70px;box-sizing:border-box;height: 100%;background-position: center center;background-repeat: no-repeat;background-size: 30px 30px; display: table-cell;}
		#crm_contacts .btnContainer a.tel{background-image: url("/mobile/plugin/crm_new/images/1.png");}
		#crm_contacts .btnContainer a.msg{background-image: url("/mobile/plugin/crm_new/images/2.png");}
		#crm_contacts .btnContainer a.email{background-image: url("/mobile/plugin/crm_new/images/4.png");}

	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);"></div>
		<%if(canEdit){%>
		<div class="right addBtn"><a href="/mobile/plugin/crm_new/crmContactsAdd.jsp?id=<%=id%>" style="display: block;height:45px;" data-reload="true"></a></div>
		<%}%>
	</div>
	<div class="content">
		<div class="controlTitleNull"></div>
		<ul class="list"></ul>
		<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
		<div class="no_data">无联系人记录</div>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildContactsPage : function(id){
			var that = this;
			var $crm_contacts = $("#crm_contacts");
			
			var controlTitle = $("#crm_cust .header .left").text() || $("#crm_businessview .header .left").text();
			$("#crm_contacts .header .left").html(controlTitle + " - 联系人");

			var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getContacts&id="+id;
			var $loading = $(".crm_loading", $crm_contacts);
			$loading.show();
			var $no_data = $(".no_data", $crm_contacts);
			$no_data.hide();
			that.ajax(url, function(result){
				$loading.hide();
				
				var $list = $(".list", $crm_contacts);
				$list.find("*").remove();
				var datas = result["datas"];
				var html = "";
				for(var i = 0; i < datas.length; i++){
					var d = datas[i];
					var contacterid = d["id"];
					var fullname = d["fullname"];
					var title = d["title"];
					var jobTitle = that.fixEmptyValue(d["jobTitle"]);
					var mobilephone = d["mobilephone"];
					if(mobilephone == ""){
						mobilephone = that.fixEmptyValue(mobilephone);
					}else{
						mobilephone = "<a href=\"tel:"+mobilephone+"\">"+mobilephone+"</a>";
					}
					var email = d["email"];
					
					var ht = "岗位: "+jobTitle+"，电话: "+mobilephone;
					if(email != ""){
						ht += "<br/>邮箱: " + "<a href=\"mailto:"+email+"\">" + email + "</a>";
					}
					html += "<li>"
								+ "<div class=\"line\">"
									+ "<a href='/mobile/plugin/crm_new/contacter.jsp' data-formdata='id="+contacterid+"'><img src=\"/mobile/plugin/crm_new/images/avatar.png\"/>"
									+ "<div class=\"title\">"+fullname+" "+title+"</div></a>"
									+ "<div>"+ht+"</div>"
								+ "</div>"
								+ "<div class=\"slideBtnContainer\">"
									+"<div class=\"btnContainer\">"
										+ "<a class=\"tel\" href=\"tel:"+(d["mobilephone"] || "")+"\"></a>"
										+ "<a class=\"msg\" href=\"sms:"+(d["mobilephone"] || "")+"\"></a>"
										+ "<a class=\"email\" href=\"mailto:"+(d["email"] || "")+"\"></a>"
									+"</div>"
								+ "</div>"
							+"</li>";
				}
				$list.append(html);
				
				ToucherUtil.swipeList($list, ".slideBtnContainer");
				
				var totalSize = result["totalSize"];
				if(totalSize <= 0){
					$no_data.show();
				}
			});
		}
	});
	CRM.buildContactsPage("<%=id%>");
	</script>
</div>
</body>
</html>
