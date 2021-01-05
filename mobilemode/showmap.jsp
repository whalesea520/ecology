
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@	page import="weaver.general.Util"%>
<%
	String gpsstr = Util.null2String(request.getParameter("gpsstr"));
	String isLbsAddress = Util.null2String(request.getParameter("isLbsAddress"));
	if(gpsstr.trim().equals("")){
		return;
	}
%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="/mobilemode/js/baidu/api_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/baidu/convertor_wev8.js"></script>
<style type="text/css">
html,body{
	margin: 0px;
	padding: 0px;
	background-color: #ffffff;
}
#mapContainer{
	height: 100%;
	width: 100%;
}
</style>
<script>
var gpsstr = "<%=gpsstr %>";
//var gpsstr = "31.173211,121.475134";
var isLbsAddress = "<%=isLbsAddress %>";
window.onload = function(){

	var map = new BMap.Map("mapContainer");  
	map.clearOverlays();    //清除地图上所有覆盖物

	if(isLbsAddress == "1"){// gpsstr 中文地址
		var myGeo = new BMap.Geocoder();
		myGeo.getPoint(gpsstr, function(point){
			if (point) {
				map.centerAndZoom(point, 18);
				map.enableScrollWheelZoom();
				var marker=new BMap.Marker(point);  
				map.addOverlay(marker);  
			}else{
				alert("地址没有解析到结果!");
			}
		}, "上海市");
	}else{
		var dataArr = gpsstr.split(",");
		var gpsPoint = new BMap.Point(dataArr[1], dataArr[0]);
			
		map.centerAndZoom(gpsPoint, 18);  
		map.enableScrollWheelZoom();  
		var marker=new BMap.Marker(gpsPoint);  
		map.addOverlay(marker);  
	}
   
};
</script>
</HEAD> 
<body>
<div id="mapContainer">
	
</div>
</body>
</html>