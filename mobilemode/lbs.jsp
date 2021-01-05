<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@	page import="weaver.general.Util"%>
<%
String posType = Util.null2String(request.getParameter("posType"), "1");
String posClassName = "";
if(posType.equals("1")){	//只显示当前位置，不显示周围热点
	posClassName = "pos";
}else if(posType.equals("2")){	//显示当前位置同时显示周围热点
	posClassName = "pos_poi";
}else if(posType.equals("3")){	//显示当前位置和周围热点，并允许改变当前位置及更新周围热点
	posClassName = "pos_poi2";
}
String btnText = Util.null2String(request.getParameter("btnText"), "确定");

int poiRadius = Util.getIntValue(request.getParameter("poiRadius"), 500);
int numPois = Util.getIntValue(request.getParameter("numPois"), 12);
%>
<!DOCTYPE html>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="/mobilemode/js/zepto/zepto.min_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/fastclick/fastclick.min_wev8.js"></script>
<!-- 
<script type="text/javascript" src="/mobilemode/js/baidu/api_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/baidu/convertor_wev8.js"></script>
 -->
<script type="text/javascript" src="/mobilemode/js/baidu/api_https_wev8.js"></script>

<style type="text/css">
*{
font-family: 'Microsoft YaHei', Arial;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	background-color: #ffffff;
	overflow: hidden;
}
#mapContainer{
	height: 50%;
	width: 100%;
	overflow: hidden;
	position: relative;
	visibility: hidden;
}
#maper{
	height: 100%;
	width: 100%;
}
#currPos{
	position: absolute;
	left: 13px;
	bottom: 26px;
	width: 36px;
	height: 36px;
	border: 1px solid #B2B2B0;
	border-radius: 5px;
	overflow: hidden;
	background: url("/mobilemode/images/pos_gray.png") no-repeat;
	background-size: 24px 24px;
	background-position: center center; 
	background-color: rgba(252, 252, 251, 1);
}
#loading{
	position: absolute;
    left:0px;
    top:0px;
    bottom: 0px;
    width: 100%;
    z-index: 20001;
    display: none;
}
.spinner {
  margin: 20px auto 20px;
  text-align: center;
}
 
.spinner > div {
  width: 10px;
  height: 10px;
  background-color: rgb(023, 180, 235);
 
  border-radius: 100%;
  display: inline-block;
  -webkit-animation: bouncedelay 1.4s infinite ease-in-out;
  animation: bouncedelay 1.4s infinite ease-in-out;
  /* Prevent first frame from flickering when animation starts */
  -webkit-animation-fill-mode: both;
  animation-fill-mode: both;
}
 
.spinner .bounce1 {
  -webkit-animation-delay: -0.32s;
  animation-delay: -0.32s;
}
 
.spinner .bounce2 {
  -webkit-animation-delay: -0.16s;
  animation-delay: -0.16s;
}
 
@-webkit-keyframes bouncedelay {
  0%, 80%, 100% { -webkit-transform: scale(0.0) }
  40% { -webkit-transform: scale(1.0) }
}
 
@keyframes bouncedelay {
  0%, 80%, 100% {
    transform: scale(0.0);
    -webkit-transform: scale(0.0);
  } 40% {
    transform: scale(1.0);
    -webkit-transform: scale(1.0);
  }
}
#header{
	width: 100%;
	height: 50px;
	position: absolute;
	top: 0px;
	left: 0px;
	z-index: 10000;
	background-color: rgba(023, 180, 235, 0.8);
}
#okBtn{
	position: absolute;
	width: 60px;
	height: 100%;
	position: absolute;
	top: 0px;
	right: 0px;
	background-size: 24px;
	color: #fff;
	font-size: 18px;
	text-align: center;
	line-height: 50px;
	display: none;
	-webkit-tap-highlight-color:transparent;
}
#backBtn{
	position: absolute;
	height: 100%;
	position: absolute;
	top: 0px;
	left: 0px;
	color: #fff;
	font-size: 18px;
	line-height: 50px;
	background: url("/mobilemode/images/emobile/fanhui.png") no-repeat;
	width: 60px;
	background-size: 24px 24px; 
	background-position: 10px center;
	-webkit-tap-highlight-color:transparent;
}
#poiContainer{
	height: 50%;
	width: 100%;
	box-shadow: 0px -1px 6px #ccc;
	overflow-y: auto;
	overflow-x: hidden;
	-webkit-overflow-scrolling:touch;
	visibility: hidden;
	position: relative;
}
#poiContainer ul{
	list-style: none;
	margin: 0px;
	padding: 0px 0px 0px 8px;
}
#poiContainer ul li{
	border-bottom: 1px solid #eee;
	padding: 8px 0px 8px 0px;
	
}
#poiContainer ul li.selected{
	background: url("/mobilemode/images/right_blue.png") no-repeat;
	background-position: 95% center;
	background-size: 24px 19px; 
}
#poiContainer ul li .title{
	font-size: 16px;
	color: #000;
}
#poiContainer ul li .address{
	font-size: 12px;
	color: #666;
	margin-top: 3px;
}
.anchorBL{
	display: none;
}

.pos #mapContainer{
	height: 100%;
}
.pos #poiContainer{
	display: none;
}
.pos #currPos{
	display: none;
}
</style>
<script>
var _top = null;var _win = window;try{while((_win.parent) != _win){_win = _win.parent;if(_win._mobilemode_root_page == true){_top = _win;break;}}}catch(e){}if(_top == null){_top = _win;}

function isRunInEmobile(){
	var _isRunInEmobile = (_top && typeof(_top.isRunInEmobile) == "function") ? _top.isRunInEmobile() : false;
	return _isRunInEmobile;
}

function isRunInWeiXin(){
	var _isRunInWeiXin = (_top && typeof(_top.isRunInWeiXin) == "function") ? _top.isRunInWeiXin() : false;
	return _isRunInWeiXin;
}

function _p_getLBS(){
	if(_top && typeof(_top.registMPCWindow) == "function"){
		_top.registMPCWindow(window);
	}
	
	if(isRunInEmobile()){
		location = "emobile:gps:_p_getLBSResult";
	}else if(_top && _top.eb_GetLocation){
		_top.eb_GetLocation("_p_wx_getLBSResult");
	}else if(typeof(eb_GetLocation) == "function"){
		eb_GetLocation("_p_wx_getLBSResult");
	}else{
		navigator.geolocation.getCurrentPosition(function(position){
			var timestamp = (new Date()).valueOf();  
			var gpsstr = timestamp+","+position.coords.latitude+","+position.coords.longitude;
			_p_getLBSResult(gpsstr, "gps");
		},function(error){
			var errMsg = "";
			switch(error.code){
			    case error.PERMISSION_DENIED:
			      errMsg = "用户拒绝对获取地理位置的请求。";
			      break;
			    case error.POSITION_UNAVAILABLE:
			      errMsg = "位置信息是不可用的。";
			      break;
			    case error.TIMEOUT:
			      errMsg = "请求用户地理位置超时。";
			      break;
			    case error.UNKNOWN_ERROR:
			      errMsg = "未知错误。";
			      break;
		    }
		    alert(errMsg);
		},{
			enableHighAcuracy: true,
			maximumAge: 3000
		});
	}
	
}

function _p_wx_getLBSResult(longitude, latitude){
	var timestamp = (new Date()).valueOf();  
	var gpsstr = timestamp+","+latitude+","+longitude;
	_p_getLBSResult(gpsstr, "google");
}

function _p_getLBSResult_error(result){
	var index = result.lastIndexOf(","); 
	var status = result.substring(index+1);
	var errmsg = "";
	var errnum = "2,3,4,5,6,11,13,14";
	if(errnum.indexOf(status)){
		errmsg = result.substring(0,index);
	}
	alert("定位失败，"+errmsg+"响应码："+status);
}

var map;
var originalGps = null;
var posType = "<%=posType%>";
var _result;
function _p_getLBSResult(result, gpsType){
	if(result){
		var resultArr = result.split(",");
		if(resultArr.length >= 3){
			if(!gpsType){
				gpsType = "google";	//emobile使用的是google坐标
			}
			
			function initMap(point){
				
				map = new BMap.Map("maper");  
				map.centerAndZoom(point, 16);  
				map.enableScrollWheelZoom();  
				
				setPageVisible();
				originalGps = point.lng + "," + point.lat;
				moveToNewPoint(originalGps, true);
				
				
				if(posType == "3"){
					map.addEventListener("click", function(e){
						var _gpsstr = e.point.lng + "," + e.point.lat;
						moveToNewPoint(_gpsstr, true);
					});
				}
			}
			
			var convertor = new BMap.Convertor();
			if(gpsType == "google"){	//谷歌坐标
				var googlePoint = new BMap.Point(resultArr[2], resultArr[1]);
				convertor.translate([googlePoint], 3, 5, function(data){
					var point = data.points[0];
					initMap(point);
				});		
				/*		
				BMap.Convertor.translate(googlePoint,2,function(point){
					initMap(point);
				});*/
			}else if(gpsType == "baidu"){	//百度坐标
				var baiduPoint = new BMap.Point(resultArr[2], resultArr[1]);
				initMap(baiduPoint);
			}else if(gpsType == "gps"){	//原始坐标
				var gpsPoint = new BMap.Point(resultArr[2], resultArr[1]);
				convertor.translate([gpsPoint], 1, 5, function(data){
					var point = data.points[0];
					initMap(point);
				});
				/*
				BMap.Convertor.translate(gpsPoint,0,function(point){
					initMap(point);
				});*/
			}
		}
	}
}

function moveToNewPoint(_gpsstr, changePoi){
	var gpsArr = _gpsstr.split(",");
	var point = new BMap.Point(gpsArr[0], gpsArr[1]);
	
	map.clearOverlays();    //清除地图上所有覆盖物
	var mk = new BMap.Marker(point);
	map.addOverlay(mk);
	map.panTo(point);
	
	var mOption = {    
		poiRadius : <%=poiRadius%>,           //半径为500米内的POI,默认100米    
		numPois : <%=numPois%>                //列举出12个POI,默认10个
	};
	
	var $poiUL = $("#poiContainer > ul");
	
	if(changePoi && posType != "1"){
		$poiUL.find("*").remove();
		$("#loading").show();
	}
				
	var geoc = new BMap.Geocoder();
	geoc.getLocation(point, function(rs){
	
		document.getElementById("loading").style.display = "none";
		
		var addComp = rs.addressComponents;
		var addstr = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
		
		var gpsstr = point.lng + "," + point.lat;
		_result = gpsstr + ";;" + addstr;
		
		document.getElementById("okBtn").style.display = "block";
		
		
		if(changePoi && posType != "1"){
			
			$poiUL.append("<li class=\"selected\" data-gps=\""+gpsstr+"\"><div class=\"title\">"
									+ "[位置]"
								+ "</div>"
								+ "<div class=\"address\">"
									+ addstr
								+ "</div>"
							+ "</li>");
			
			var allPois = rs.surroundingPois;       //获取全部POI（该点半径为100米内有6个POI点）
			for(i=0; i<allPois.length; ++i){
				var that_gpsstr = allPois[i].point.lng+","+allPois[i].point.lat;
				$poiUL.append("<li data-gps=\""+that_gpsstr+"\"><div class=\"title\">"
									+ allPois[i].title
								+ "</div>"
								+ "<div class=\"address\">"
									+ allPois[i].address
								+ "</div>"
							+ "</li>");
			}
			
			$("li", $poiUL).click(function(){
				if(!$(this).hasClass("selected")){
					$(this).parent().children(".selected").removeClass("selected");
					$(this).addClass("selected");
					
					var _gpsstr = $(this).attr("data-gps");
					moveToNewPoint(_gpsstr);
				}
			});
		
		}
	}, mOption); 
	
}

function setPageVisible(){
	$("#mapContainer").css("visibility", "visible");
	$("#poiContainer").css("visibility", "visible");
}

//var gpsstr = "31.173211,121.475134";
window.onload = function(){

	FastClick.attach(document.body);
	
	$("#backBtn").click(function(e){
		if(_top && typeof(_top.doHistoryBack) == "function"){
			_top.doHistoryBack();
		}
		e.stopPropagation(); 
	});
	
	$("#okBtn").click(function(e){
		if(_top && typeof(_top.backPageAndCallLBSLoaded) == "function"){
			_top.backPageAndCallLBSLoaded(_result);
		}
		e.stopPropagation(); 
	});
	
	$("#currPos").click(function(e){
		if(originalGps){
			moveToNewPoint(originalGps, true);
		}
		e.stopPropagation(); 
	});
	
	setTimeout(_p_getLBS, 100);
};
</script>

</HEAD> 
<body class="<%=posClassName%>">

<div id="header">
	<div id="backBtn"></div>
	<div id="okBtn"><%=btnText %></div>
</div>
<div id="mapContainer">
	<div id="maper"></div>
	<div id="currPos"></div>
</div>

<div id="poiContainer">
	<div id="loading">
		<div class="spinner">
		  <div class="bounce1"></div>
		  <div class="bounce2"></div>
		  <div class="bounce3"></div>
		</div>
	</div>
	
	<ul>
	</ul>
</div>
</body>
</html>