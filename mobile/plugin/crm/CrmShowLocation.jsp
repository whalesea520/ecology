<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="weaver.general.Util"%>
<%@page import="sun.plugin.navig.URLDecoder"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">
body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;}
#l-map{height:100%;width:78%;float:left;border-right:2px solid #bcbcbc;}
#r-result{height:100%;width:20%;float:left;}
</style>
<link rel="stylesheet" href="/mobile/plugin/crm/css/crm_wev8.css" type="text/css">
<script language="javascript" src="http://webapi.amap.com/maps?v=1.3&key=53a92850ca00d7f77aef3297effd8d59"></script>
<%

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
String module=Util.null2String((String)request.getParameter("module"));
String scope=Util.null2String((String)request.getParameter("scope"));
String opengps = Util.null2String((String)request.getParameter("opengps"));
String customerid=Util.null2String((String)request.getParameter("customerid"));


String gps=request.getParameter("gps");
String nowtime=request.getParameter("nowtime");
String description=Util.null2String(request.getParameter("description"));
%>
</head>
<body onLoad="mapInit();">

<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
							<a href="/mobile/plugin/crm/CrmContact.jsp?customerid=<%=customerid%>&module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>">
								<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
									 返回
								</div>
							</a>
					</td>
					<td align="center" valign="middle">
						<div id="title" >查看位置</div>
					</td>
					<td width="10%" align="right" valign="middle" style="padding-right:5px;">
							
					</td>
				</tr>
			</table>
</div>

<div id="iCenter" style="height:100%;"></div>
	
</body>
</html>
<script type="text/javascript">

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
	setMapFitView();
}

////返回地址描述
function geocoder_CallBack(data) {
    address = data.regeocode.formattedAddress;
}

//添加点标记覆盖物，点的位置在地图上分布不均
function addOverlays(){
	mapObj.clearMap();
	var lnglatXY;
	
	var x="<%=gps%>".split(",")[0];
	var y="<%=gps%>".split(",")[1];
	lnglatXY = new AMap.LngLat(x,y);
	
    Marker1=new AMap.Marker({	
    	map:mapObj,  	
		icon:"http://webapi.amap.com/images/1.png",
		position:lnglatXY,
		content:"<div style='width:360px'><img src='http://webapi.amap.com/images/1.png' align='absmiddle'><span class='mapspan'><%=description%></span></div>",
		title:"<%=description%>", 
		offset:new AMap.Pixel(-12,-36)
	});
	
	mapObj.setZoom(15);
	mapObj.setCenter(lnglatXY);
	
	//逆地理编码
    //MGeocoder.getAddress(lnglatXY);
} 

function showMap(){
	
	//地图初始化
	var bm = new BMap.Map("allmap");
	bm.addControl(new BMap.NavigationControl());
	bm.enableScrollWheelZoom();    //启用滚轮放大缩小，默认禁用
	bm.enableContinuousZoom();     //启用地图惯性拖拽，默认禁用

	var x="<%=gps%>".split(",")[1];
	var y="<%=gps%>".split(",")[0];


	
	var point = new BMap.Point(x,y);

	var marker = new BMap.Marker(point);
	//alert(marker);
	bm.addOverlay(marker);
	bm.centerAndZoom(point, 15);
	bm.setCenter(point);
	
	showAddress(marker,point,"<%=nowtime%>");
}

function showAddress(marker,point,createtime){
	var gc = new BMap.Geocoder();
	gc.getLocation(point, function(rs){
		
	    var addComp = rs.addressComponents;
	    var locationLabel=addComp.city + addComp.district +addComp.street +addComp.streetNumber+" "+createtime;
	    
	    var label = new BMap.Label(locationLabel,{offset:new BMap.Size(20,-10)});
	    marker.setLabel(label); 
	});
}

//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
function doLeftButton() {
	window.location.href="/mobile/plugin/crm/CrmContact.jsp?customerid=<%=customerid%>&module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>";
	return "1";
}

</script>
