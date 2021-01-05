
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.hrm.*"%>
<%@page import="java.net.URLDecoder"%>
<%

User user = HrmUserVarify.getUser (request , response) ;
String description=URLDecoder.decode(Util.null2String(request.getParameter("description")));
//System.out.println("description:"+description);
String latitude=Util.null2String(request.getParameter("latitude"));
String longitude=Util.null2String(request.getParameter("longitude"));
boolean isHttps=request.getScheme().equals("https");
String protocal = isHttps? "https":"http";
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=SystemEnv.getHtmlLabelName(83167,user.getLanguage())%></title>
<script language="javascript" src="<%=protocal %>://webapi.amap.com/maps?v=1.3&key=53a92850ca00d7f77aef3297effd8d59"></script>
<style>
*{
	font-size:12px;
	font-family: 微软雅黑;
}
.mapspan{
    border: 1px solid #008ef7;
    background: #008ef7;
    color: #fff;
    padding: 3px;
    border-radius: 5px;
}
</style>
</head>
<body onLoad="mapInit();" style="overflow:hidden;margin:0px;">
	<div id="iCenter" style="height:450px;"></div>
</body>
<script language="javascript">

var mapObj,Marker,Marker1,Marker2,Marker3,MGeocoder,address;
//初始化地图对象，加载地图
function mapInit(){
	mapObj = new AMap.Map("iCenter",{
		//二维地图显示视口
		view: new AMap.View2D({})
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
	//setMapFitView();
}

////返回地址描述
function geocoder_CallBack(data) {
    address = data.regeocode.formattedAddress;
}  

//添加点标记覆盖物，点的位置在地图上分布不均
function addOverlays(){
	mapObj.clearMap();
	var lnglatXY;
	
	lnglatXY = new AMap.LngLat(<%=longitude%>,<%=latitude%>);
		
    Marker1=new AMap.Marker({	
    map:mapObj,  	
			icon:"http://webapi.amap.com/images/1.png",
			position:lnglatXY,
			content:"<div style='width:360px'><img src='http://webapi.amap.com/images/1.png' align='absmiddle'><span class='mapspan'><%=description%></span></div>",
			title:"<%=description%>", 
			offset:new AMap.Pixel(-12,-36)
	});
	
	mapObj.setZoom(14);
	mapObj.setCenter(lnglatXY);
		//逆地理编码
	    //MGeocoder.getAddress(lnglatXY);
}

//地图自适应显示函数
function setMapFitView(){
	mapObj.setFitView();//使地图自适应显示到合适的范围
}
</script>
</html>		
