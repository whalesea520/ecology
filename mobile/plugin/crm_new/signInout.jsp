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
String id = Util.null2String(request.getParameter("id"));
String customerid=id;
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
		#crm_map textarea{width:90%;font-size:14px;border:1px solid #f0f0f0;height:80px;padding:5px 0;margin-left:15px;}
		#crm_map div.tab{position: relative;background-color:#fff;padding:15px 0 13px 0;border-top:0px solid #e5e5e5;border-bottom:1px solid #e5e5e5;font-size: 12px;}
		#crm_map #btn_1{width:25%;font-size:14px;  border:none; position:absolute;left:15px;color:#fff;background:rgba(1, 97, 201, 0.7);}
        #crm_map #btn_2{width:25%;font-size:14px; border:none; position:absolute;right:25px;color:#fff;background: rgba(1, 97, 201, 0.7);}
        .btn {  
		    position: relative;  
		    cursor: pointer;  
		    display: inline-block;  
		    vertical-align: middle;  
		    font-size: 12px;  
		    font-weight: bold;  
		    height: 27px;  
		    line-height: 27px;  
		    min-width: 52px;  
		    padding: 0 12px;  
		    text-align: center;  
		    text-decoration: none;  
		    border-radius: 2px;  
		    border: 1px solid #ddd;  
		    color: #666;  
		    background-color: #f5f5f5;  
		    background: -webkit-linear-gradient(top, #F5F5F5, #F1F1F1);  
		    background: -moz-linear-gradient(top, #F5F5F5, #F1F1F1);  
		    background: linear-gradient(top, #F5F5F5, #F1F1F1);  
		}
		.btn-primary {  
		    border-color: #3079ED;  
		    color: #F3F7FC;  
		    background-color: #4D90FE;  l
		    background: -webkit-linear-gradient(top, #4D90FE, #4787ED);  
		    background: -moz-linear-gradient(top, #4D90FE, #4787ED);  
		    background: linear-gradient(top, #4D90FE, #4787ED);  
		}    
	</style>
	<div class="header" data-role="header">
		<div class="left">定位中...</div>
		<div class="right okBtn" style="display: none;"></div>
	</div>
	<div class="content">
		<div class="c_map" style="height:60%;"></div>
		<div class="tab">
			<div id="currentAddrs" style="position:absolute;top:13px;left:15px;color:#777;"></div>
		</div>
		<ul></ul>
		<form>
        
		</form>
		<input type="hidden" id="mapAddress" value="" />
		<input type="hidden" id="maplatlng" value="" />
		<ul></ul>
		<div id="btns">
			<div></div>
            <button class="btn" id="btn_1" onclick="doSave(this,'签到')">签到</button>
            <button class="btn" id="btn_2" onclick="doSave(this,'签退')">签退</button>
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
					$("#currentAddrs").html("我的位置："+addr);
					
					$("#mapAddress").val(addr);
					$("#maplatlng").val(lng+","+lat);
					$addrContainer.html(addr);
					//$okBtn.show();
					
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
	
	function doSave(obj,type){				
		if(!confirm("是否确定"+type))
			return ;
		var address=$("#mapAddress").val();
		var latlng=$("#maplatlng").val();
		var addresss=$("#mapAddresss").val();
		if(address==""||latlng==""){
			alert("未获取位置");
			eturn;
		}
		saveLocation(type,address,latlng);
	}
	   
    function saveLocation(type,planName,gps){
			
			var now= new Date();
			var nowdate=now.pattern("yyyy-MM-dd");
			var nowtime=now.pattern("HH:mm");
			var description = type+":"+planName;
			var title=type+":"+planName;
			var param={"workPlanType":"3","planName":title,"urgentLevel":"0","remindType":"1",
					    "urgentLevel":"1","beginDate":nowdate,"beginTime":nowtime,"endDate":nowdate,"endTime":nowtime,
					    "description":description,"crmIDs":"<%=customerid%>","location":gps
					  }
			//showLoading(1,1);		  
			$.post("/mobile/plugin/crm_new/CrmContactOperation.jsp?method=addCalendarItem",param,function(data){
				data = JSON.parse(data)
				if(data.IsSuccess) {
					window.location.href = "/mobile/plugin/crm_new/index.jsp#&/mobile/plugin/crm_new/customer.jsp?id=<%=customerid%>&dataTime="+new Date().getTime();

					alert(type+"成功");
				}
			});
		
		}
//时间日期格式化
		Date.prototype.pattern=function(fmt) {     
		   var o = {     
		   "M+" : this.getMonth()+1, //月份     
		   "d+" : this.getDate(), //日     
		   "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时     
		   "H+" : this.getHours(), //小时     
		   "m+" : this.getMinutes(), //分     
		   "s+" : this.getSeconds(), //秒     
		   "q+" : Math.floor((this.getMonth()+3)/3), //季度     
		   "S" : this.getMilliseconds() //毫秒     
		   };     
		   var week = {     
		   "0" : "\u65e5",     
		   "1" : "\u4e00",     
		   "2" : "\u4e8c",     
		   "3" : "\u4e09",     
		   "4" : "\u56db",     
		   "5" : "\u4e94",     
		   "6" : "\u516d"    
		   };     
		   if(/(y+)/.test(fmt)){     
		       fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));     
		   }     
		   if(/(E+)/.test(fmt)){     
		       fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "\u661f\u671f" : "\u5468") : "")+week[this.getDay()+""]);     
		   }     
		   for(var k in o){     
		       if(new RegExp("("+ k +")").test(fmt)){     
		           fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));     
		       }     
		   }     
		  return fmt;     
		 }		
	</script>
</div>
</body>
</html>
