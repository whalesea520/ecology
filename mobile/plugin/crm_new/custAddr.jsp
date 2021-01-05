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
<title>客户地址</title>
</head>
<body>
<div id="crm_cust_addr" class="page out">
	<style type="text/css">
		#crm_cust_addr div.tab{position: relative;background-color:#fff;padding:15px 0 13px 0;border-top:0px solid #e5e5e5;border-bottom:1px solid #e5e5e5;font-size: 12px;}
		#crm_cust_addr div.tab ul li{color:#0161c9;border:1px solid #0161c9;border-right: 0;}
		#crm_cust_addr div.tab ul li:last-child{border:1px solid #0161c9;}
		#crm_cust_addr div.tab ul li.selected{background-color:#0161c9;color:#fff;}
		
		#crm_cust_addr ul.list li div:nth-child(1){float:left;width:45px;font-size:16px;color:#0161c9;text-align:left;line-height:10px;padding:7px 0 0 0;}
		#crm_cust_addr ul.list li div:nth-child(1) span{color:#777;font-size:10px;padding:0 0 0 2px;}
		#crm_cust_addr ul.list li div:nth-child(3){color:#333;font-size:14px;margin:0 50px 0 60px;padding:1px 0 2px 0;}
		#crm_cust_addr ul.list li div:nth-child(4){color:#777;font-size:10px;margin:0 50px 0 60px;}
				
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);"></div>
	</div>
	<div class="content">
		<div class="c_map" style="height:200px;"></div>
		<div class="tab">
			<div style="position:absolute;top:13px;left:15px;color:#777;">周边：</div>
			<ul>
				<li data-value="1">1km</li>
				<li data-value="3">3km</li>
				<li data-value="5">5km</li>
				<li data-value="10">10km</li>
			</ul>
		</div>
		<ul class="list"></ul>
		<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
		<div class="no_data">无附近客户</div>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmAddrPage : function(id){
			var that = this;
			var $crm_cust_addr = $("#crm_cust_addr");
			
			that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=getSimpeCustomer&id="+id, function(result){
				var data = result["data"];
				$(".header .left", $crm_cust_addr).html(data["name"]);
				var lat1 = data["lat1"];
				var lng1 = data["lng1"];
				
				function innerFn(){
					var b_map = new BMap.Map($(".c_map", $crm_cust_addr)[0]);
					b_map.clearOverlays();    //清除地图上所有覆盖物
					var gpsPoint = new BMap.Point(lng1, lat1);
					b_map.centerAndZoom(gpsPoint, 14);
			        b_map.addOverlay(new BMap.Marker(gpsPoint));    //添加标注
					
				}
				
				if(typeof(BMap) == "undefined"){
					that.addJS("/mobile/plugin/crm_new/js/baidu/api_wev8.js", function(){
						that.addJS("/mobile/plugin/crm_new/js/baidu/convertor_wev8.js", function(){
							innerFn();
						});
					});
				}else{
					innerFn();
				}
				
				var $tab = $(".tab", $crm_cust_addr);
				$("ul li", $tab).click(function(){
					if(!$(this).hasClass("selected")){
						$(this).siblings("li.selected").removeClass("selected");
						$(this).addClass("selected");
						that.loadCrmListByAddr(id, lng1, lat1);
					}
				});
				
				$("ul li", $tab).eq(0).triggerHandler("click");
			});
		},
		loadCrmListByAddr : function(id, lng, lat){
			var that = this;
			var pageNo = 1;
			var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getCustomerList&pageNo="+pageNo+"&pageSize=20";
			var $crm_cust_addr = $("#crm_cust_addr");
			var $currTab = $(".tab ul li.selected", $crm_cust_addr);
			var raidus = $currTab.attr("data-value");
			url = url + "&opt=around&aroundCrm="+id+"&raidus="+raidus+"&lng="+lng+"&lat="+lat;
			var $list = $(".list", $crm_cust_addr);
			$list.find("*").remove();
			var $loading = $(".crm_loading", $crm_cust_addr);
			$loading.show();			
			var $no_data = $(".no_data", $crm_cust_addr);
			$no_data.hide();
			that.ajax(url, that.crmSearchCondition, function(result){
				$loading.hide();
				
				if(pageNo == 1){
					$list.find("*").remove();
				}
				var datas = result["datas"];
				var html = "";
				for(var i = 0; i < datas.length; i++){
					var d = datas[i];
					var statusHtml = "";
					var status = d["status"];
					if(status != ""){
						statusHtml = "<div class=\"flag flag"+d["statusId"]+"\">"+status+"</div>";
					}else{
						statusHtml = "<div></div>";
					}
					///mobilemode/apps/e-cology/crm/customer.jsp
					html += "<li>"
								+"<a href=\"javascript:void(0);\" data-formdata=\"id="+d["id"]+"\">"
									+"<div>"+d["distance"]+"<span>m</span></div>"
									+statusHtml
									+"<div class=\"title\">"+d["name"]+"</div>"
									+"<div>客户经理："+d["manager"]+"，最近联系：<span class=\"contactinfo\" data-customerid=\""+d["id"]+"\" data-loaded=\"0\">...</span></div>"
								+"</a>"
							+"</li>";
							
				}
				$list.append(html);
				
				$(".contactinfo[data-loaded='0']", $list).each(function(){
					that.loadCrmContactInfo($(this));
				});
				
				var totalSize = result["totalSize"];
				if(totalSize <= 0){
					$no_data.show();
				}
			});
		}
	});
	CRM.buildCrmAddrPage("<%=id%>");	
	</script>
</div>
</body>
</html>
