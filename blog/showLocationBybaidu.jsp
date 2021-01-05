<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="weaver.general.Util"%>

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
<script type="text/javascript" src="http://api.map.baidu.com/api?v=1.5&ak=C1edf768b08866f84e344fafd229fbe0"></script>
<script type="text/javascript" src="http://developer.baidu.com/map/jsdemo/demo/convertor_wev8.js"></script>
<%
String x="0";
String y="0";

String discussid=Util.null2String(request.getParameter("discussid"));
String sql="select * from blog_location where discussid=? order by id asc ";
RecordSet recordSet=new RecordSet();
recordSet.executeQuery(sql, discussid);
%>
</head>
<body onload="showMap()">
<div id="allmap"></div>
</body>
</html>
<script type="text/javascript">

function showMap(){
	
	//地图初始化
	var bm = new BMap.Map("allmap");
	bm.addControl(new BMap.NavigationControl());
	bm.enableScrollWheelZoom();    //启用滚轮放大缩小，默认禁用
	bm.enableContinuousZoom();     //启用地图惯性拖拽，默认禁用

	<%
	int index=0;
	while(recordSet.next()){
		index++;
		String[] locations=Util.null2String(recordSet.getString("location")).split(",");
		String createtime=Util.null2String(recordSet.getString("createtime"));
		if(locations.length==0)
		   continue;
		y=locations[0];
		x=locations[1];
	%>
	var x=<%=x%>;
	var y=<%=y%>;
	
	var point = new BMap.Point(x,y);

	var marker = new BMap.Marker(point);
	//alert(marker);
	bm.addOverlay(marker);
	if(<%=index%>==1){
		bm.centerAndZoom(point, 15);
		bm.setCenter(point);
	}
	showAddress(marker,point,"<%=createtime%>");
	<%}%>
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

</script>
