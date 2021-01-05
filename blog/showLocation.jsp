
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.hrm.*"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
String discussid=Util.null2String(request.getParameter("discussid"));
RecordSet recordSet=new RecordSet();
String sql = "select * from blog_location where discussid=? and (locationName='' or locationName is null) order by id asc ";
recordSet.executeQuery(sql, discussid);
//如果存在地址为空的数据，则认为是百度地图历史数据跳转到百度地图显示页面
if(recordSet.next()){
	response.sendRedirect("/blog/showLocationBybaidu.jsp?discussid="+discussid);
	return ;
}
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=SystemEnv.getHtmlLabelName(83167,user.getLanguage())%></title>
<script language="javascript" src="http://webapi.amap.com/maps?v=1.3&key=53a92850ca00d7f77aef3297effd8d59"></script>
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
	<div id="iCenter" style="height:420px;"></div>
</body>
<script language="javascript">
<%
String x="0";
String y="0";
sql="select * from blog_location where discussid=? order by id asc ";
recordSet.executeQuery(sql, discussid);
%>
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
	
	<%
	int index=0;
	while(recordSet.next()){
		index++;
		String[] locations=Util.null2String(recordSet.getString("location")).split(",");
		String createtime=Util.null2String(recordSet.getString("createtime"));
		String locationName=Util.null2String(recordSet.getString("locationname"));
		if(locations.length==0)
		   continue;
		y=locations[0];
		x=locations[1];
		String title=locationName+" "+createtime;
	%>
		lnglatXY = new AMap.LngLat(<%=x%>,<%=y%>);
		
	    Marker1=new AMap.Marker({	
	    	map:mapObj,  	
			//icon:"http://webapi.amap.com/images/<%=index%>_wev8.png",
            icon:"http://webapi.amap.com/theme/v1.3/markers/n/mark_b.png",
			position:lnglatXY,
			//content:"<div style='width:360px'><img src='http://webapi.amap.com/images/<%=index%>_wev8.png' align='absmiddle'><span class='mapspan'><%=title%></span></div>",
            content:"<div style='width:360px'><img src='http://webapi.amap.com/theme/v1.3/markers/n/mark_b.png' align='absmiddle'><span class='mapspan'><%=title%></span></div>",
			title:"<%=title%>", 
			offset:new AMap.Pixel(-12,-36)
		});
		if("<%=index%>"=="1"){
			mapObj.setZoom(15);
			mapObj.setCenter(lnglatXY);
		}
		//逆地理编码
	    //MGeocoder.getAddress(lnglatXY);
	<%}%>
}

//地图自适应显示函数
function setMapFitView(){
	if(<%=index%>>1)
		mapObj.setFitView();//使地图自适应显示到合适的范围
}
</script>
</html>		
