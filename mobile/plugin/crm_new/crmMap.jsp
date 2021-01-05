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
String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
<title>地址</title>
</head>
<body>
<div id="crm_map" class="page out">
	<style type="text/css">
		#crm_map .content{top:0px;}
		#crm_map .header{background-color:rgba(1, 97, 201, 0.8);height:40px;}
		#crm_map .header .left, #crm_map .header .right{height:40px;line-height:40px;}
		#crm_map .poi-container{border-top: 5px solid #f0f0f0;box-shadow: 0px -1px 5px #ccc;position: absolute;top: 60%;bottom: 0px;left:0px;width: 100%;overflow-y: auto; overflow-x: hidden;-webkit-overflow-scrolling: touch;}
		#crm_map .poi-container ul{list-style: none;margin: 0px;padding: 0px 0px 0px 8px;}
		#crm_map .poi-container ul li{border-bottom: 1px solid #eee;padding: 8px 0px 8px 0px;}
		#crm_map .poi-container ul li.selected{background: url("/mobile/plugin/crm_new/images/pos_gray.png") no-repeat;background-position: 95% center;background-size: 20px 20px; }
		#crm_map .poi-container ul li .title{font-size: 16px;color: #000;}
		#crm_map .poi-container ul li .address{font-size: 12px;color: #666;margin-top: 3px;}
	</style>
	<div class="header" data-role="header">
		<div class="left">定位中...</div>
		<div class="right okBtn" style="display: none;"></div>
	</div>
	<div class="content">
		<div class="c_map" style="height:60%;"></div>
		<div class="poi-container">
			<div class="mask" style="display: none;"><i class="loading"></i></div>
			<ul></ul>
		</div>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmMapPage : function(callback){
			var that = this;
			var $crm_map = $("#crm_map");
			
			var b_map = null;
			
			function innerFn(){
				b_map = new BMap.Map($(".c_map", $crm_map)[0]);
				
				MLocation.getCurrentPosition(function(position){
					var lat = position.coords.latitude;
					var lng = position.coords.longitude;
					var gpsPoint = new BMap.Point(lng, lat);
					BMap.Convertor.translate(gpsPoint,0,function(point){
						b_map.centerAndZoom(point, 14);
						//b_map.addOverlay(new BMap.Marker(point));    //添加标注
						var scaleControl = new BMap.ScaleControl({anchor: BMAP_ANCHOR_BOTTOM_LEFT});
						var navControl = new BMap.NavigationControl({anchor: BMAP_ANCHOR_BOTTOM_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL}); 
						b_map.addControl(scaleControl);
						b_map.addControl(navControl);  
						
						movePoint(point.lng, point.lat, true);
						
						b_map.addEventListener("click", function(e){
							movePoint(e.point.lng, e.point.lat, true);
						});
						
						
					});
				},function(error){
					$(".header .left", $crm_map).html("定位失败");
				},{
					enableHighAcuracy: true,
					maximumAge: 3000
				});
			}
			
			var $addrContainer = $(".header .left", $crm_map);
			var $okBtn = $(".header .okBtn", $crm_map);
			
			function movePoint(lng, lat, isLoadPoi){
				var point = new BMap.Point(lng, lat);
				
				b_map.clearOverlays();    //清除地图上所有覆盖物
				var mk = new BMap.Marker(point);
				b_map.addOverlay(mk);
				b_map.panTo(point);	
				
				var $poiContainer = $(".poi-container", $crm_map);
				var $poiUL = $poiContainer.children("ul");
				var $poiLoading = $poiContainer.children(".mask");
				if(isLoadPoi){
					$poiUL.find("*").remove();
					$poiLoading.show();
				}
				
				var mOption = {    
					poiRadius : 500,           //半径为500米内的POI,默认100米    
					numPois : 12                //列举出12个POI,默认10个
				};
				var geoc = new BMap.Geocoder();
				geoc.getLocation(point, function(rs){
					var addComp = rs.addressComponents;
					var province = addComp.province;
					var city = addComp.city;
					var pAndC = "";
					if(province == city){
						pAndC = province;
					}else{
						pAndC = province + city;
					}
					var addr = pAndC + addComp.district + addComp.street + addComp.streetNumber;
					$addrContainer.html(addr);
					$okBtn.show();
					
					if(isLoadPoi){
						$poiLoading.hide();
						$poiUL.append("<li class=\"selected\" data-lng=\""+lng+"\" data-lat=\""+lat+"\"><div class=\"title\">"
								+ "[位置]"
							+ "</div>"
							+ "<div class=\"address\">"
								+ addr
							+ "</div>"
						+ "</li>");
						
						var pois = rs.surroundingPois;       //获取全部POI（该点半径为100米内有6个POI点）
						for(i=0; i<pois.length; ++i){
							$poiUL.append("<li data-lng=\""+pois[i].point.lng+"\" data-lat=\""+pois[i].point.lat+"\"><div class=\"title\">"
												+ pois[i].title
											+ "</div>"
											+ "<div class=\"address\">"
												+ pois[i].address
											+ "</div>"
										+ "</li>");
						}
						
						$("li", $poiUL).click(function(){
							if(!$(this).hasClass("selected")){
								$(this).parent().children(".selected").removeClass("selected");
								$(this).addClass("selected");
								
								var poi_lng = $(this).attr("data-lng");
								var poi_lat = $(this).attr("data-lat");
								movePoint(poi_lng, poi_lat, false);
							}
						});
					}
					
				}, mOption);
			}
			
			$okBtn.click(function(){
				if(callback){
					var callbackFn = eval(callback);
					if(typeof(callbackFn) == "function"){
						var addr = $addrContainer.text();
						var $poiContainer = $(".poi-container", $crm_map);
						var $poiUL = $poiContainer.children("ul");
						var $poiLi = $(".selected",$poiUL);
						var lnglat = $poiLi.attr("data-lng")+","+$poiLi.attr("data-lat")
						callbackFn.call(that, addr, lnglat);
					}
				}
				history.go(-1);
			});
			
			that.addJS("/mobile/plugin/crm_new/js/baidu/api_wev8.js", function(){
				that.addJS("/mobile/plugin/crm_new/js/baidu/convertor_wev8.js", function(){
					innerFn();
				});
			});
			
		}
	});
	CRM.buildCrmMapPage("<%=callback%>");	
	</script>
</div>
</body>
</html>
