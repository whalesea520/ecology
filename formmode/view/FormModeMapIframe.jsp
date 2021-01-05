<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
 %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(126782, user.getLanguage())+",javascript:getAddress(),_top} " ;
 		RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(126783, user.getLanguage())+",javascript:getAddress2(),_top} " ;
 		RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(126782, user.getLanguage()) %>" id="zd_btn_save" class="e8_btn_top" onclick="getAddress()">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(126783, user.getLanguage()) %>" id="zd_btn_save" class="e8_btn_top" onclick="getAddress2()">
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<div style="height: 30px;position:absolute;  z-index:1;float:right; top: 30px;left: 60px;" >
	<div class="searchText_tip"><%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(83578, user.getLanguage()) %></div>
	<input id="searchaddress"  class="searchText" onkeydown="keydownEvent()">
	<input onclick="searchaddress()"
	style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; max-width: 100px; height: 30px;" 
	id="zd_btn_save" 
	class="e8_btn_top_first" title="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>"  value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" type="button">
</div>
<div style="width:815px;height:515px;border:1px solid gray" id="container"></div>
</body>
</html>
<script type="text/javascript">

function keydownEvent() {
    var e = window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 13 ) {
        searchaddress();
    }
}
function searchaddress(){
	var searchaddress =  jQuery("#searchaddress").val();
    gc.getPoint(searchaddress, function(point){
		if (point) {
			if(marker){
				map.removeOverlay(marker);
			}
			doMarker(point);
		}else{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(128181, user.getLanguage()) %>");
		}
	}, "");

}
try{
<%
String fieldvalue = Util.null2String(request.getParameter("fieldvalue"));
%>
var fieldvalue = "<%=fieldvalue%>";
var fieldid = "<%=fieldid%>";
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
doMarker(point);
if(fieldvalue==''){
	geolocation.getCurrentPosition(function(r){
		if(this.getStatus() == BMAP_STATUS_SUCCESS){
			doMarker(r.point);
		} 
	},{enableHighAccuracy: true});
}else{
	searchaddressfun(fieldvalue);
}

map.addEventListener("click", function(e){
	if(marker){
		map.removeOverlay(marker);
	}
	doMarker(e.point);
});
}catch(e){}

function doMarker(point,searchaddress){
	try{
		marker = new BMap.Marker(point);
		map.addOverlay(marker);
		map.panTo(point);
		marker.enableDragging(); //标记开启拖拽
		//添加标记拖拽监听
		marker.addEventListener("dragend", function(e){
		    //获取地址信息
		    gc.getLocation(e.point, function(rs){
		        showLocationInfo(e.point, rs);
		    });
		});
	}catch(e){}
	 
    gc.getLocation(point, function(rs){
        showLocationInfo(point, rs,searchaddress);
    });
}

//显示地址信息窗口
function showLocationInfo(pt, rs,searchaddress){
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
    if(searchaddress==''||searchaddress==undefined||searchaddress=='undefined'){
    	addressinfo = provincecity + addComp.district + addComp.street  + addComp.streetNumber;
    }else{
    	addressinfo = searchaddress;
    }
    addr = "<br/><%=SystemEnv.getHtmlLabelName(34177,user.getLanguage())%>：" + addressinfo;
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
	var $searchText = $(".searchText");
	var $searchTextTip = $(".searchText_tip");
	
	$searchTextTip.click(function(){
		$searchText[0].focus();
	});
	
	$searchText.focus(function(){
		$searchTextTip.hide();
	});
	
	$searchText.blur(function(){
		if(this.value == ""){
			$searchTextTip.show();
		}
	});

})

function searchaddressfun(searchaddress){
	if(searchaddress==''){
		return;
	}
	jQuery("#searchaddress").val(searchaddress);
	jQuery(".searchText_tip").hide();
	gc.getPoint(searchaddress, function(point){
		if (point) {
			if(marker){
				map.removeOverlay(marker);
			}
			doMarker(point,searchaddress);
		}else{
			if(marker){
				map.removeOverlay(marker);
			}
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(128181, user.getLanguage()) %>");
			
		}
	}, "");
}
pingmap();
var ispingmap = 1;//0没有ping -1 ping不通   1 ping通
function pingmap(){
  	var p = new Ping();
  	var pingnum = 0;
	p.ping("http://map.baidu.com", function(data) {
        pingnum = data;
        if(pingnum>0){
	     	if(pingnum>1000){
	     		Dialog.alert("<%=SystemEnv.getHtmlLabelName(128176, user.getLanguage()) %>");
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