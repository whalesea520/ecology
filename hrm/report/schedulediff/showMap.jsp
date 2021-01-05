
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- Added by wcd 2014-11-05 [查看地图] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String x = Tools.vString(request.getParameter("x"),"0");
	String y = Tools.vString(request.getParameter("y"),"0");
	String key = Tools.getURLDecode(request.getParameter("key"));
	String title = Tools.getURLDecode(request.getParameter("title"));
%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title><%=SystemEnv.getHtmlLabelNames("367,81524",user.getLanguage())%></title>
		<link rel="stylesheet" type="text/css" href="http://developer.amap.com/Public/css/demo.Default.css" /> 
		<script language="javascript" src="http://webapi.amap.com/maps?v=1.3&key=<%=key%>"></script>
		<style>
		.mapspan{
			border: 1px solid #008ef7;
			background: #008ef7;
			color: #fff;
			padding: 3px;
			border-radius: 5px;
		}
		</style>
	</head>
	<body onLoad="mapInit();" style="overflow:hidden;">
		<div id="iCenter" style="height:100%;"></div>
	</body>
	<script language="javascript">
		var mapObj,Marker,Marker1,Marker2,Marker3,MGeocoder,address;
		//初始化地图对象，加载地图
		function mapInit(){
			mapObj = new AMap.Map("iCenter",{
				//二维地图显示视口
				view: new AMap.View2D({
					center:new AMap.LngLat(116.397428,39.90923),//地图中心点
					zoom:13 //地图显示的缩放级别
				})
			});	
			
			mapObj.plugin(["AMap.Geocoder"], function() {        
				MGeocoder = new AMap.Geocoder({ 
					radius: 1000,
					extensions: "all"
				});
				//返回地理编码结果 
				AMap.event.addListener(MGeocoder, "complete", geocoder_CallBack); 
			});
			
			//地图加载时添加点标记物
			addOverlays();
			//地图自适应显示函数
			setMapFitView();
		}

		////返回地址描述
		function geocoder_CallBack(data) {
			address = data.regeocode.formattedAddress;
		}  

		//添加点标记覆盖物，点的位置在地图上分布不均
		function addOverlays(){
			mapObj.clearMap();
			//地图上添加三个点标记，作为参照
			var lnglatXY = new AMap.LngLat(<%=x%>,<%=y%>);
			Marker1=new AMap.Marker({
				map:mapObj,  	
				icon:"http://webapi.amap.com/images/0.png",
				position:lnglatXY,
				content:"<div style='width:360px'><img src='http://webapi.amap.com/images/0.png' align='absmiddle'><span class='mapspan'><%=title%></span></div>",
				title:"<%=title%>", 
				offset:new AMap.Pixel(-12,-36)
			});
			//逆地理编码
			//MGeocoder.getAddress(lnglatXY);
		}

		//地图自适应显示函数
		function setMapFitView(){
			var newCenter = mapObj.setFitView();//使地图自适应显示到合适的范围
		}
	</script>
</html>		
