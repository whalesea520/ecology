<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.file.*" %>
<html>
<head>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript" src='/formmode/js/ping_wev8.js'></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=<%=Prop.getPropValue("map", "baidumapversion") %>&ak=<%=Prop.getPropValue("map", "baidumapak")%>"></script>
<style type="text/css">
.searchText_tip{
	position: absolute;
	top: 7px;
	left: 15px;
	color: #BBB;
	font-style: italic;
}
.searchBtn{
	background: url("/formmode/images/btnSearch.png") no-repeat;
	width:16px;
	height: 16px;
	position: absolute;
	top: 11px;
	left: 178px;
	cursor:pointer;
}
.searchText{
	height: 30px;
	width: 300px;
	padding-right: 40px;
	border: 1px solid #BBB;
	background-position: 162px center;
}
</style>
</head>
<body>
<%
String titlename ="";
String fieldid = Util.null2String(request.getParameter("fieldid"));
String fieldvalue = Util.null2String(request.getParameter("fieldvalue"));
 %>
<div style="width:815px;height:515px;border:1px solid gray" id="container"></div>
</body>
</html>
<script type="text/javascript">

function searchaddress(){
	var searchaddress =  "<%=fieldvalue%>";
    gc.getPoint(searchaddress, function(point){
		if (point) {
			if(marker){
				map.removeOverlay(marker);
			}
			doMarker(point);
		}else{
			Dialog.alert("未能定位具体位置！</br>1.请确保所有字词拼写正确</br>2.尝试不同的关键字</br>3.尝试更宽泛的关键字");
			//alert("未能定位具体位置！\n1.请确保所有字词拼写正确\n2.尝试不同的关键字\n3.尝试更宽泛的关键字");
		}
	}, "");

}
try{
var fieldid = "<%=fieldid%>";
var fieldvalue = "<%=fieldvalue%>";
var addressinfo="";
var map = new BMap.Map("container",{enableMapClick:false});//初始化地图      
var top_left_navigation = new BMap.NavigationControl();  //左上角，添加默认缩放平移控件
// var top_right_navigation = new BMap.NavigationControl({anchor: BMAP_ANCHOR_TOP_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL}); //右上角，仅包含平移和缩放按钮              
map.addControl(top_left_navigation);  //初始化地图控件
// map.addControl(top_right_navigation);  //初始化地图控件               
map.addControl(new BMap.ScaleControl());                   
map.addControl(new BMap.OverviewMapControl());  
var point=new BMap.Point(116.404, 39.915);
map.centerAndZoom(point, 15);
map.enableScrollWheelZoom();//启动鼠标滚轮缩放地图

var marker ; //初始化地图标记
var gc = new BMap.Geocoder();//地址解析类
var geolocation = new BMap.Geolocation();
}catch(e){}

function doMarker(point){
	try{
		marker = new BMap.Marker(point);
		map.addOverlay(marker);
		map.panTo(point);
		//添加标记拖拽监听
		marker.addEventListener("click", function(e){
		    //获取地址信息
		    gc.getLocation(e.point, function(rs){
		        showLocationInfo(e.point, rs);
		    });
		});
	}catch(e){}
	 
    gc.getLocation(point, function(rs){
        showLocationInfo(point, rs);
    });
}

//显示地址信息窗口
function showLocationInfo(pt, rs){
    var opts = {
      width : 150,     //信息窗口宽度
      height: 30,     //信息窗口高度
      title : ""  //信息窗口标题
    }
    var addComp = rs.addressComponents;
    var provincecity = "";
    if(addComp.province==addComp.city){
    	provincecity = addComp.city;
    }else{
    	provincecity = addComp.province+addComp.city;
    }
    addressinfo = provincecity + addComp.district + addComp.street  + addComp.streetNumber;
    addr = "<br/><%=SystemEnv.getHtmlLabelName(34177,user.getLanguage())%>：" + fieldvalue;
    //addr += "纬度: " + pt.lat + ", " + "经度：" + pt.lng;
    //alert(addr);
    var infoWindow = new BMap.InfoWindow(addr, opts);  //创建信息窗口对象
    marker.openInfoWindow(infoWindow);
}
//获取地址
function getAddress(){
	parent.closeWinAFrsh(addressinfo,1);
}
//获取地址并覆盖
function getAddress2(){
	parent.closeWinAFrsh(addressinfo,2);
}
jQuery(document).ready(function(){
	searchaddress();
})
pingmap();
var ispingmap = 1;//0没有ping -1 ping不通   1 ping通
function pingmap(){
  	var p = new Ping();
  	var pingnum = 0;
	p.ping("http://map.baidu.com", function(data) {
        pingnum = data;
        if(pingnum>0){
	     	if(pingnum>1000){
	     		Dialog.alert("无法链接到互联网!<br/>1.请检查网线是否接好<br/>2.请检查网络是否可以链接互联网");
	     	}else{
	     		
	     	}
	    }
     },1500);
}
</script>
<style>
.mapimage{
	width:16px;
	heigth:16px;
}
</style>