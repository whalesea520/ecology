<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@	page import="weaver.general.Util"%>
<%
	String destination = Util.null2String(request.getParameter("destination"));	//目的地，可以是：中文地址，也可以是：经度,纬度
	if(destination.trim().equals("")){
		return;
	}
	//坐标类型：1：google,高德,腾讯地图类的坐标系。2：百度地图类的坐标系。3：gps类的坐标系  (如果目的地是中文地址，坐标类型无意义)
	String coordinateType = Util.null2String(request.getParameter("coordinateType"));	
%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="/mobilemode/js/baidu/api_https_wev8.js"></script>
<style type="text/css">
html,body{
	margin: 0;
	background-color: #ffffff;
	overflow:hidden;
}
body{
	font-size:16px;
	overflow: hidden;
}
.anchorBL{
	display: none;
}
#mapContainer{
	position: absolute; top:0px; left: 0px; bottom:50px; width: 100%; overflow:hidden; z-index:1;
}
#chineseAddr {
    position: absolute;
    left: 0px;
    bottom: 0px;
    width: 100%;
    height: 50px;
    line-height: 50px;
    padding-left: 15px;
    box-sizing: border-box;
    color: #000;
    font-size:16px;
    font-weight: bold;
    z-index:2;
    box-shadow: 0px -1px 6px #aaa;
}
#naviBtn {
    position: absolute;
    right: 15px;
    bottom: 50px;
    width: 66px;
    height: 66px;
    background-color: #4287FF;
    z-index: 3;
    color: #fff;
    border-radius: 66px;
    text-align: center;
    padding-top: 35px;
    box-sizing: border-box;
    font-size: 12px;
    box-shadow: 0px 1px 6px #aaa;
	transform: translateY(50%);
	background-image: url("/mobilemode/images/go.png");
	background-repeat: no-repeat;
	background-position: center 6px;
	display: none;
}
#naviBtn.disabled{
	background-color: #aaa;
}
#currPos{
	position: absolute;
	left: 10px;
    bottom: 60px;
    width: 36px;
    height: 36px;
    border: 1px solid #ccc;
    border-radius: 3px;
    overflow: hidden;
    background: url(/mobilemode/images/curr_pos.png) no-repeat;
    background-size: 30px 30px;
    background-position: center center;
    background-color: rgba(252, 252, 251, 1);
    z-index: 3;
    display: none;
}
#currPos.active{
	background-image: url(/mobilemode/images/curr_pos2.png);
}
</style>
</HEAD> 
<body>
<div id="mapContainer">
	
</div>
<div id="chineseAddr"></div>
<div id="naviBtn">去这里</div>
<div id="currPos"></div>
<script type="text/javascript">
//上海市浦东新区泛微软件大厦
//121.4816113354,31.1792826232  百度经纬度
//121.4750600000,31.1735300000	高德经纬度
/*模拟微信定位的方法，测试用的
function eb_GetLocation(){
	_p_wx_getLBSResult("121.4750600000","31.1735300000");
}*/

var _top = null;var _win = window;try{while((_win.parent) != _win){_win = _win.parent;if(_win._mobilemode_root_page == true){_top = _win;break;}}}catch(e){}if(_top == null){_top = _win;}

var destPoint = null;	//目的地 坐标点
 
(function(){

	var destination = "<%=destination%>";
	var coordinateType = "<%=coordinateType%>";
	
	var map = new BMap.Map("mapContainer");
	map.enableScrollWheelZoom();
	
	function setPoint(p, chineseAddr){
		map.centerAndZoom(p, 15);
		map.addOverlay(new BMap.Marker(p));
		
		if(chineseAddr){
			document.querySelector("#chineseAddr").innerHTML = chineseAddr;
		}else{
			var geoc = new BMap.Geocoder();
			geoc.getLocation(p, function(rs){
				var addComp = rs.addressComponents;
				var province = addComp.province;
				var city = addComp.city;
				var pc;
				if(province == city){
					pc = city;
				}else{
					pc = province + city;
				}
				var addr = pc + addComp.district + addComp.street + addComp.streetNumber;
				document.querySelector("#chineseAddr").innerHTML = addr;
			});
		}
		
		document.querySelector("#naviBtn").style.display = "block";
		document.querySelector("#currPos").style.display = "block";
		
		destPoint = p;
	}
	
	function changeToGD(p){
		var baidu_lng = p.lng;
		var baidu_lat = p.lat;
		
		var X_PI = Math.PI * 3000.0 / 180.0;
		var x = baidu_lng - 0.0065;
		var y = baidu_lat - 0.006;
		var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * X_PI);
		var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * X_PI);
		var gd_lng = z * Math.cos(theta);
		var gd_lat = z * Math.sin(theta);
		
		return {"lng" : gd_lng, "lat" : gd_lat};
	}
	
	function isRunInEmobile(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/e-mobile/i) == "e-mobile"){
			return true;
	    }else{
	        return false;
	    }
	}
	
	function getCurrentPosition(callback){
	
		window.lbsCallback = callback;
		
		if(_top && typeof(_top.registMPCWindow) == "function"){
			_top.registMPCWindow(window);
		}
	
		if(isRunInEmobile()){
			//运行在Emobile中
			location = "emobile:gps:_p_getLBSResult";
		}else if(_top && _top.eb_GetLocation){
			_top.eb_GetLocation("_p_wx_getLBSResult");
		}else if(typeof(eb_GetLocation) == "function"){
			eb_GetLocation("_p_wx_getLBSResult");
		}
	}
	
	function callbackRun(longitude, latitude){
		var position = {
			"lng" : longitude,
			"lat" : latitude
		};
		if(typeof(window.lbsCallback) == "function"){
			window.lbsCallback.call(window, position);
		}
	}
	
	//Emobile定位当前位置回调
	window._p_getLBSResult = function(result){
		if(result){
			var resultArr = result.split(",");
			if(resultArr.length >= 3){
				var currLng = resultArr[2];
				var currLat = resultArr[1];
				
				callbackRun(currLng, currLat);
			}
		}
	};
	
	//云桥定位当前位置回调
	window._p_wx_getLBSResult = function(longitude, latitude){
		callbackRun(longitude, latitude);
	}
	
	
	if((/.*[\u4e00-\u9fa5]+.*$/).test(destination)){	//中文地址
		var localSearch = new BMap.LocalSearch(map, { //智能搜索
			onSearchComplete: function(){
				var results = localSearch.getResults();
	            if(results.getNumPois() > 0){
	            	var p = localSearch.getResults().getPoi(0).point;
	            	setPoint(p, destination);
	            }else{
	            	alert("地址("+destination+")没有解析到结果!");
	            }
	    	}
	    });
	    localSearch.search(destination);
	}else{
		if(coordinateType == ""){
			alert("使用经纬度进行定位时,未明确指定坐标类型");
			return;
		}
		
		var arr = destination.split(",");
		var lng = arr[0];	//地理经度
		var lat = arr[1];	//地理纬度
		
		var transPoint = new BMap.Point(lng, lat);
		
		var convertor = new BMap.Convertor();
		if(coordinateType == "1"){	//google,高德,腾讯地图类的坐标系。
			convertor.translate([transPoint], 3, 5, function(data){
				setPoint(data.points[0]);
			});		
		}else if(coordinateType == "2"){	//百度地图类的坐标系。
			setPoint(transPoint);
		}else if(coordinateType == "3"){	//gps类的原始坐标系
			convertor.translate([transPoint], 1, 5, function(data){
				setPoint(data.points[0]);
			});
		}
	}
	
	document.querySelector("#naviBtn").onclick = function(){
		var that = this;
		if(that.classList.contains("disabled")){
			return;
		}
		that.classList.add("disabled");
		
		getCurrentPosition(function(currPos){
			
			that.classList.remove("disabled");
			
			var currLng = currPos.lng;
			var currLat = currPos.lat;
			
			var gbInfo = changeToGD(destPoint);
			
			var destLng = gbInfo.lng;
			var destLat = gbInfo.lat;
			var destAddr = document.querySelector("#chineseAddr").innerHTML;
			
			if(isRunInEmobile()){
				location.href = "emobile:navigation:"+currLat+":"+currLng+":"+destLat+":"+destLng+":"+destAddr;
			}else{
				_top.location.href = "http://apis.map.qq.com/uri/v1/routeplan?type=drive&from=&fromcoord="+currLat+","+currLng+"&to="+destAddr+"&tocoord="+destLat+","+destLng+"&policy=1&referer=Emobile";
			}
		});
	};
	
	
	document.querySelector("#chineseAddr").onclick = function(){
		if(destPoint != null){
			map.panTo(destPoint);
		}
	};
	
	var currMarker = null;
	document.querySelector("#currPos").onclick = function(){
		var that = this;
		that.classList.add("active");
		
		getCurrentPosition(function(currPos){
			var currLng = currPos.lng;
			var currLat = currPos.lat;
			
			var transPoint = new BMap.Point(currLng, currLat);
		
			var convertor = new BMap.Convertor();
			convertor.translate([transPoint], 3, 5, function(data){
				that.classList.remove("active");
				if(currMarker != null){
					map.removeOverlay(currMarker);
				}
				
				var point = data.points[0];
				currMarker = new BMap.Marker(point, {
					icon: new BMap.Symbol(BMap_Symbol_SHAPE_POINT, {
					    scale: 1,
					    fillColor: "#F75850",
					    strokeColor : "#BC443D",
					    strokeOpacity : 1,
					    fillOpacity: 1
				  	})
				});
				map.addOverlay(currMarker);
				map.panTo(point);
			});		
		});
	};
	
})();
</script>
</body>
</html>