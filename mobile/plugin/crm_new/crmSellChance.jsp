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
<title>客户商机</title>
</head>
<body>
<div id="crm_sellChangeList" class="page out">
	<style type="text/css">
		#crm_sellChangeList div.title{margin:0 0 0 55px;}
		#crm_sellChangeList div.desc{margin:0 0 0 55px;}
		#crm_sellChangeList canvas{float:left;margin:2px 0 0 0;width:40px;}
	</style>
	<style type="text/css">
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);"></div>
	</div>
	<div class="content">
		<div class="controlTitleNull"></div>
		<ul class="list"></ul>
		<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
		<div class="no_data">无商机记录</div>
	</div>
	<script type="text/javascript">
		$.extend(CRM, {
		buildCrmSellChangeListPage : function(id){
			var that = this;
			var $crm_sellChangeList = $("#crm_sellChangeList");
			
			var controlTitle = $("#crm_cust .header .left").text();
			$("#crm_sellChangeList .header .left").html(controlTitle + " - 商机");
			
			var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getBusinessList&pageNo=1&pageSize=50&customerid="+id;
			var $loading = $(".crm_loading", $crm_sellChangeList);
			$loading.show();
			var $no_data = $(".no_data", $crm_sellChangeList);
			$no_data.hide();
			that.ajax(url, function(result){
				$loading.hide();
				var $list = $(".list", $crm_sellChangeList);
				$list.find("*").remove();
				var datas = result["datas"];
				var html = "";
				for(var i = 0; i < datas.length; i++){
					var d = datas[i];
					var statusHtml = "";
					var status = d["sellstatus"];
					if(status != ""){
						statusHtml = "<div class=\"flag flag"+d["sellstatusid"]+"\">"+status+"</div>";
					}
					var preyield = d["preyield"];
					if(preyield > 0){
						preyield = preyield + "万";
					}
					var titleHtml = d["subject"];
					if(titleHtml.length>15){
						titleHtml = titleHtml.substring(0,15)+"...";
					}
					var customernameHtml = d["customername"];
					if(customernameHtml.length>15){
						customernameHtml = customernameHtml.substring(0,15)+"...";
					}
					html += "<li>"
						+"<a href=\"/mobile/plugin/crm_new/sellchance.jsp\" data-formdata=\"id="+d["id"]+"\">"
							+"<canvas width='80' height='80' data-value=\""+d["probability"]+"\"></canvas>"
							+statusHtml
							+"<div class=\"title\">"+titleHtml+"</div>"
							+"<div class=\"desc\">客户经理: "+d["creater"]+"，客户: "+customernameHtml+"，预期收益: "+ preyield + "</div>"
						+"</a>"
						+"<div class=\"slideBtnContainer\">"
							+"<div class=\"btnContainer status_"+d["attention"]+"\">"
								+"<div class=\"btnBox box_0\" style=\"background-color: #da8e2c;\" onclick=\"CRM.setCrmAttention("+d["id"]+",'1','2',event)\">标记关注</div>"
								+"<div class=\"btnBox box_1\" style=\"background-color: #d83202;\" onclick=\"CRM.setCrmAttention("+d["id"]+",'0','2',event)\">取消关注</div>"
							+"</div>"
						+"</div>"
					+"</li>";					
				}
				$list.append(html);
				$("canvas", $list).drawPercent();
				
				var totalSize = result["totalSize"];
				if(totalSize <= 0){
					$no_data.show();
				}
			});
		}
	});
	CRM.buildCrmSellChangeListPage("<%=id%>");
	</script>
</div>
</body>
</html>
