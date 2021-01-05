<!DOCTYPE html>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page language="java" contentType="text/html; charset=UTF-8" %>
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
<title>商机明细</title>
</head>
<body>
<div id="crm_businessview" class="page out">
	<style type="text/css">
		#crm_businessview label{display:block;margin:0 15px;padding:5px 0;border-bottom:1px solid #f4f4f4;color:#333;font-size: 14px;overflow: hidden;}
		#crm_businessview label div:nth-child(1){float:left;width:85px;color:#999;}
		#crm_businessview label div:nth-child(2){margin-left:85px;}
		#crm_businessview label div:nth-child(2) > a{display:block;}
		#crm_businessview label div.more{}
		#crm_businessview label div.more > a{position: relative;padding-right: 30px; background:url(/mobile/plugin/crm_new/images/rArrow999.gif) no-repeat;background-size:6px 10px;background-position: center right;}
		#crm_businessview label div.moreNumber{background-color:#0161c9;font-size:10px;color:#fff;border-radius:16px;width:16px;height:16px;text-align:center;line-height:16px;position: absolute;top: 0px;right: 12px;}
		#crm_businessview label div.more .jobTitle{font-size: 11px;color: #666;}
		#crm_businessview .content{padding:5px 0;}
		#crm_businessview .header .left{overflow: hidden;white-space: nowrap;text-overflow: ellipsis;width: 95%;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);"></div>
	</div>
	<div class="content">
		<label>
			<div>客户经理：</div>
			<div data-field="manager"></div>
		</label>
		<label>
			<div>商机名称：</div>
			<div data-field="subject"></div>
		</label>
		<label>
			<div>商机类型：</div>
			<div data-field="selltype"></div>
		</label>
		<label>
			<div>客户名称：</div>
			<div class="more" data-field="customerid"></div>
		</label>
		<label>
			<div>销售预期：</div>
			<div data-field="predate"></div>
		</label>
		<label>
			<div>预期收益：</div>
			<div data-field="preyield"></div>
		</label>
		<label>
			<div>商机状态：</div>
			<div data-field="sellstatus"></div>
		</label>
		<label>
			<div>可能性：</div>
			<div data-field="probability"></div>
		</label>
		<!-- 
		<label>
			<div>商机来源：</div>
			<div data-field="comefromid"></div>
		</label> -->
		<label>
			<div>成功因素：</div>
			<div data-field="sufactor"></div>
		</label>
	</div>
</div>
<script type="text/javascript">
	$.extend(CRM, {
		buildBusinessPage : function(id){
			var that = this;
			var $crm_businessview = $("#crm_businessview");
			if(!$crm_businessview) return;
			that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getBusiness&id="+id, function(result){
				var data = result["data"];
				$(".header .left", $crm_businessview).html(data["subject"]);
				$("[data-field='manager']", $crm_businessview).html(data["manager"]);
				$("[data-field='subject']",$crm_businessview).html(data["subject"]);
				$("[data-field='selltype']", $crm_businessview).html(data["selltype"]);
				var customerid = data["customerid"];
				var customername = data["customername"];
				customername = "<a href=\"/mobile/plugin/crm_new/customer.jsp\" data-formdata=\"id="+customerid+"\">"+customername+"</a>";
				$("[data-field='customerid']", $crm_businessview).html(customername);
				$("[data-field='predate']", $crm_businessview).html(data["predate"]);
				var preyield = data["preyield"];
				if(preyield > 0){
					preyield = preyield + "万";
				}
				$("[data-field='preyield']", $crm_businessview).html(preyield);
				$("[data-field='sellstatus']", $crm_businessview).html(data["sellstatus"]);
				$("[data-field='probability']", $crm_businessview).html(data["probability"] + "%");
				$("[data-field='sufactor']", $crm_businessview).html(data["sufactor"]);
				//联系人
				var contacter = that.fixEmptyValue(data["contacter"]);
				var contacterCount = data["contacterCount"];
				if(contacterCount > 0){
					contacter = "<a href=\"/mobile/plugin/crm_new/crmContacts.jsp\" data-formdata=\"id="+customerid+"\">"+contacter+"<div class=\"moreNumber\">"+contacterCount+"</div></a>";
				}
				$("[data-field='contacter']", $crm_businessview).html(contacter);
				$(".moreNumber", $crm_businessview).each(function(){
					var h = $(this).parent("a").height() - $(this).height();
					if(h < 0){
						h = 0;
					}
					$(this).css("top", (h/2) + "px");
				});
			});
		}
	});
	CRM.buildBusinessPage("<%=id%>");
	
	</script>
</body>
</html>
