
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.field.LocationElement" %>
<%@ page import='net.sf.json.JSONArray' %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String wfid = Util.null2String(request.getParameter("wfid"));
String requestId = Util.null2String(request.getParameter("requestId"));
String fieldId = Util.null2String(request.getParameter("fieldId"));
String fieldName = LocateUtil.getFieldNameById(wfid,fieldId);
String posInfo = LocateUtil.getLocationInfo(Integer.parseInt(wfid),Integer.parseInt(requestId),fieldName);
String[][] locations = LocateUtil.toArray(posInfo);
String clienttype = Util.null2String(request.getParameter("clienttype"));
String preNode = "";

String clientlevel = Util.null2String(request.getParameter("clientlevel"));
String module = Util.null2String(request.getParameter("module"));
String scope = Util.null2String(request.getParameter("scope"));

//System.out.println("============================module=" + module);
//System.out.println("==========================locations[0].length=" + locations[0].length +", requestId="+ requestId +", fieldName=" + fieldName);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
	<link rel="stylesheet" href="https://cache.amap.com/lbs/static/main.css?v=1.0" />
	<script src="https://cache.amap.com/lbs/static/es5.min.js"></script>
	<script src="https://webapi.amap.com/maps?v=1.3&key=ab13604106709a9ba50a95f8a59e6a4c&plugin=AMap.Geocoder"></script>
	<script src="/js/jquery/jquery-1.4.2.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="https://cache.amap.com/lbs/static/addToolbar.js"></script>
	<link rel="stylesheet" href="https://cache.amap.com/lbs/static/main1119.css"/>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<link rel="stylesheet" href="/mobile/plugin/1/css/r4_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<jsp:useBean id="rc" class='weaver.hrm.resource.ResourceComInfo'></jsp:useBean>
	<jsp:useBean id="dc" class='weaver.hrm.company.DepartmentComInfo'></jsp:useBean>
	<style type="text/css">
		#userInfo{
			position:absolute;
			bottom:0px;
			width:100%;
			height:100px;
			background:#fff;
			display:none;
		}
		div.close{
			float:right;
			width:22px;
			height:22px;
			background:url(/workflow/ruleDesign/images/amap/close.png) no-repeat ;
		}
		div.closeBottom{
			margin:0px auto;
			width:24px;
			height:24px;
			background:url(/workflow/ruleDesign/images/amap/close.png) no-repeat ;
		}
		div#nodeNameId{
			height:30px;
			line-height:30px;
			/*background:#0f0;*/
			color:#2A95FF;
			padding-left:5px;
			font-size:16px;
			overflow:hidden;
			text-overflow:ellipsis;
			white-space:nowrap;
		}
		div#addrId{
			width:100%;
			height:29px;
			/*background:#00f;*/
			padding-left:5px;
			overflow:hidden;
			text-overflow:ellipsis;
			/*white-space:nowrap;*/
		}

	</style>

  </head>
  
  <body>
  
  	<%
	if (clienttype.equals("Webclient")) {
	%>
	<div id="view_header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;position:absolute:top:0px;<%} else {%>display:none;<%}%>">
		<table class="webtoolbarTbl">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div class="webtoolbarItem">
						<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title"><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(126093,user.getLanguage())%></div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
					<a href="javascript:logout();">
						<div class="webtoolbarItem" onclick='doRightButton();'>
						<%=SystemEnv.getHtmlLabelName(126129,user.getLanguage())%> <!-- 筛选 -->
						</div>
					</a>
				</td>
			</tr>
		</table>
	</div>
	<%
	}
	%>
  	
    <div id='mapContainer' style='height:100%;<%if (clienttype.equals("Webclient")) {%>top:40px;<%} else {%>top:0px; <%}%>}' ></div>
    <img id='curPosition' src='/workflow/ruleDesign/images/amap/curiPosi.png' style='width:40px;height:40px;position:absolute;bottom:30px;left:15px;' onclick='getCurPosition()' />
		<div id="userInfo">
			<!-- 关闭按钮 -->
			<div class='close' onclick='closeUserInfo()'></div>

			<!-- 节点名称 -->
			<div id='nodeNameId'></div>

			<!-- 地址显示 -->
			<div id='addrId'></div>

			<!-- 用户信息和时间显示 -->			
			<div id='userDateId' style='height: 40px;display:""'>
				<div style="width: 100%; height: 1px !important; background: #A3A3A3;"></div>
				<div id='userId' style='width: 50%; font-size: 12px; margin: 5px;'>
					<img id='userIconId'
						style='float: left; height: 30px; width: 30px; border-radius: 15px; padding-right: 5px;' />
					<div id='userDataId'
						style='float: left; height: 30px;width: 70%; line-height: 30px; overflow: hidden; text-overflow: ellipsis;white-space:nowrap; color: #A3A3A3;'></div>
				</div>
				<div id='dateId' style='width: 50%; float: right; font-size: 12px;'>
					<div id='dateInfo'
						style='float: right; height: 30px; line-height: 30px;color: #A3A3A3;'></div>
					<img id='dateIconId' src='/workflow/ruleDesign/images/amap/time.png'
						style='float: right; margin: 7px 5px 5px 5px;' />
				</div>
			</div>
		</div>
		
	<!-- 筛选 -->
    <div id='filter' style='position:absolute;bottom:0px;width:100%;display:none;height:260px;'>
		
		<div id='showAllNodes' onclick='showAllNoeds()' onmousemove='mousein(this)' style='margin: 10px auto;height: 35px;line-height: 35px;width: 210px;font-size: 16px;background-color: #007AFD;color: #F8FBFF;text-align: center;-moz-border-radius: 18px;-webkit-border-radius: 18px;border-radius: 18px;font-family: "Microsoft YaHei"!important;' ><%=SystemEnv.getHtmlLabelName(126402,user.getLanguage())%></div>
		
		<!--<div style="width: 100%; height: 1px !important; background:#A3A3A3;"></div>-->
		
		<div style="overflow-y:auto; overflow-x:hidden;height:176px;">
			<table id='nodelist' style='width:100%'>
				<colgroup>
					<col width='5%' />
					<col width='15%' />
					<col width='70%' />
					<col width='10%'/>
				</colgroup>
			</table>
		</div>
		<!-- 关闭按钮 -->
		<div class='closeBottom' onclick='closeFilter()'></div>
    </div>
  </body>
  <script type="text/javascript">
   	var map = null;
  	var toolBar = null;
  	var markers = new Array();
  	var lines = new Array();
  	var curMarker = null;  //点击后，选中的标记
  	var mapHeight = 0;
  	var geolocation;
  	var curPosMarker =null; //当前位置的标记
  	var curiPosi =null ; //存放当前位置信息
  	var curMarkerIndex= -1;
  	var requestid = <%=requestId%>;
  	
  	function mousein(obj){
  		jQuery(obj).css("background-color","#B5B6BA");
  		setTimeout(function(){
			jQuery(obj).css("background-color","#007AFD");
		},200);
  	}
 	
  	function goBack(){
  		if(requestid >0){
  			location = "/mobile/plugin/1/view.jsp?requestid=" + requestid + "&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>";
  			return 1;
  		}else{
  			location = "/mobile/plugin/1/view.jsp?workflowid="+<%=wfid%>+"&method=create&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>";
  		}
  		
  		
  	}  	
  	
  	//逆地理编码
  	function regeocoder(lng,lat) {  
  		var geocoder = new AMap.Geocoder({
            radius: 1000,
            extensions: "all"
        });  
        
        var lngLat = [lng,lat]      
        geocoder.getAddress(lngLat, function(status, result) {
            if (status === 'complete' && result.info === 'OK') {
                geocoder_CallBack(lng,lat,result);
            }
        });        
    }
    
    function geocoder_CallBack(lng,lat,result) {
        var address = result.regeocode.formattedAddress; //返回地址描述
        
        var latitude  = lat; //对于苹果机，此处1：经度2：为纬度
  		var longitude = lng;   		
  		var addr = address
  		curiPosi = {
  						lng:longitude,
  						lat:latitude,
  						addr:addr
  					};
		curPosMarker.setPosition([longitude, latitude]);
		curPosMarker.setMap(map);
    	map.setCenter([longitude, latitude]);
    	
    	//显示信息框
    	jQuery('#filter').hide();
    	jQuery("#userInfo").show();
    	jQuery("#userDateId").hide();
    	jQuery('#mapContainer').height( mapHeight -98 );
    	jQuery('#userInfo').height(60);
    	jQuery('#curPosition').css('bottom','88px');
    	jQuery('#nodeNameId').html("[" +"<%=SystemEnv.getHtmlLabelName(126403,user.getLanguage())%>"+ "]");   //我的位置
    	jQuery('#addrId').html('<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>'+": "+ addr ); 
        
    }
  	
  	//解析定位结果
    function onComplete(data) {
		regeocoder(data.position.getLng(),data.position.getLat());
		jQuery('#curPosition').attr("src", "/workflow/ruleDesign/images/amap/curiPosi.png");
    }
    //解析定位错误信息
    function onError(data) {
    	alert("<%=SystemEnv.getHtmlLabelName(126404,user.getLanguage())%>！"); 
    }
  
  	/* 筛选按钮 */
	function getRightButton(){		
		return "1,<%=SystemEnv.getHtmlLabelName(126129,user.getLanguage())%>";  
	}
	function getRequestTitle(){
		return "<%=SystemEnv.getHtmlLabelName(22981,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(126093,user.getLanguage())%>";
	}
	
	//当用户点击标题右上边筛选按钮时，客户端会调用页面上的javascript方法:
	function doRightButton(){
		jQuery('#filter').css('display','block');
		<%if(clienttype.equals("Webclient")) {%>
			jQuery('#mapContainer').height( mapHeight -300 );
		<%}else{%>
			jQuery('#mapContainer').height( mapHeight -260 );
		<%}%>
		jQuery('#curPosition').css('bottom','290px');
		jQuery('#userInfo').hide();	
		return "1";
	}
	
  	/* 右侧控制栏，添加节点 */
  	function addnode(){
  		var userInfo = new Array();
  		<%
  		 preNode = "";
  		int index = 0;
		String trHTML = "";		
		Map<Integer,List<Integer>> nodes = new HashMap<Integer,List<Integer>> ();
		int markerIndex = 0;  //为了过滤掉，位置为空的数据
  		 for(int i=0; (!posInfo.equals("") && i< locations.length) ;i++){
  		   if(locations[i]!=null && locations[i].length >= 4 && locations[i][3] != null && !locations[i][3].equals("")){
  		     	 trHTML = "";
	  		     if( preNode.equals("") || !preNode.equals(locations[i][0]) ){ 	    		 
					trHTML =  "<tr style='cursor:pointer;height:30px;line-height:30px;font-size:14px;' onclick='getPoint("+(index+1)+")'  ><td></td><td style='text-indent:5px;border-bottom: 1px #E1EDF3 solid;'>"+(index+1)+     //onmouseout='mouseout(this)' onmousemove='mousein(this)'
						"</td><td style='border-bottom: 1px #E1EDF3 solid;'>"+ LocateUtil.getNodenameById(locations[i][0]) + 
						"</td><td style='border-bottom: 1px #E1EDF3 solid;'><img id='checkbox"+(index+1)+"' src='/workflow/ruleDesign/images/amap/checkbox.png' name='checkboxPng' style='width:16px;height:16px;display:none;position:relative;top:4px;'/></td></tr>";
		    		preNode = locations[i][0];
		    		index++;
	  		     }
	  		     if(index >0){	  		     
	  		         if(nodes.containsKey(index)){
		  		         nodes.get(index).add(markerIndex);
		  		     }else{
		  		         nodes.put(index,new ArrayList<Integer>());
		  		       	 nodes.get(index).add(markerIndex);
		  		     }
	  		     }

	  		   markerIndex++;
  		   
  		%>  			 
  			var trHTML = "<%=trHTML %>";
  			//alert(trHTML);
  			jQuery("#nodelist").append(trHTML); 
  		<%}}
  		 JSONArray json = JSONArray.fromObject(nodes); 
		 //System.out.println(json.toString());
  		%>  		
  	}
  	
  	/* 点击节点时，地图上仅显示该节点*/
  	function getPoint(index){
  		var nodesJson = <%=json%>[0];
  		//alert(JSON.stringify(nodesJson)); 
  		for(var i=1; i<lines.length; i++){
  			lines[i].hide();
  		} 
  	 	var showMarkers = new Array();  	 	
  		for(var n in nodesJson){
			if(index == n){
		  		for(var i=0; i<markers.length; i++){			
		  			var markerIndex = markers[i].getExtData();
		  			if(nodesJson[n].indexOf(markerIndex) == -1){
		  				markers[i].hide(); 
		  			}else{
		  				markers[i].show();
		  				//map.setZoom(13); 
		  				map.setCenter(markers[i].getPosition());  
		  				curMarker = markers[i];
		  				showMarkers.push(i);
		  			}		  			 			
		  		}
		  		jQuery("#checkbox"+index).show();			
			}else{
				jQuery("#checkbox"+n).hide();
			}
			
  		}
  		for(var i=1;i<showMarkers.length;i++){
  			//alert(showMarkers[i]);
  			lines[showMarkers[i]].show();
  		}
  		if(showMarkers.length ==1){
  			map.setCenter(curMarker.getPosition());
  			map.setZoom(16);
  		}else{
  			map.setFitView();  
  		} 			
  	}
  
  	/* 创建地图 */
	function createMap(){
		map = new AMap.Map("mapContainer", {
			keyboardEnable:false,
			level:11,
			resizeEnable:true,
		});	
		map.plugin(["AMap.ToolBar"], function () {
      		toolBar = new AMap.ToolBar();
      		map.addControl(toolBar);
    	});	
    	
    	map.plugin('AMap.Geolocation', function() {
	        geolocation = new AMap.Geolocation({
	            enableHighAccuracy: true,//是否使用高精度定位，默认:true
	            timeout: 5000,          //超过10秒后停止定位，默认：无穷大
	            showButton: false, 
	            //buttonOffset: new AMap.Pixel(10, 20),//定位按钮与设置的停靠位置的偏移量，默认：Pixel(10, 20)
	            zoomToAccuracy: true,     // 定位成功后调整地图视野范围使定位位置及精度范围视野内可见，默认：false
				showMarker:false
	        });	        
	        map.addControl(geolocation);	        
	        AMap.event.addListener(geolocation, 'complete', onComplete);//返回定位信息
	        AMap.event.addListener(geolocation, 'error', onError);      //返回定位出错信息
	    });	 	
  	}  

  	/*关闭信息框*/
  	function closeUserInfo(){
		jQuery('#userInfo').hide();
		jQuery('#mapContainer').height( mapHeight);
		jQuery('#curPosition').css('bottom','30px');
  	}
  	
  	function closeFilter(){
  		jQuery('#filter').hide();
		jQuery('#mapContainer').height( mapHeight);
		jQuery('#curPosition').css('bottom','30px');
  	}
  	
  	function showAllNoeds(){
  		jQuery("img[name='checkboxPng']").each(function(){
  			jQuery(this).hide();
  		})
  		showTrack(true);
  	}
  	
  	function closeWin(){
    	map.clearInfoWindow();
    };
  	  	
  	/* 查看/隐藏所有的节点或轨迹 
  	 * flag: true:显示，false:隐藏
  	 */
  	function showTrack(flag){
  		closeWin();
  		if(curMarker != null){
  			map.setCenter(curMarker.getPosition());
  			//map.setZoom(13);
  		}else{
  			map.setCenter(markers[0].getPosition());
  		}
  		
  		for(var i=0; i<markers.length; i++){
  			if(flag == true){
  				markers[i].show(); 
  			}else{
  				markers[i].hide(); 
  			}						
  		}
  		for(var i=1; i<lines.length; i++){
  			if(flag == true){
  				lines[i].show();
  			}else{
  				lines[i].hide(); 
  			}
  		}
  		map.setFitView();
  	}
  	
  	
  	/* 地图位置处添加图标 */
  	function addMark(i,longitude, latitude,nodename,username,time,addr,userIcon,department){
  		time = time.replace("/", " ");
  		var marker = new AMap.Marker({
 			icon:"/workflow/ruleDesign/images/amap/positionRed.png",
	        //position:new AMap.LngLat(longitude, latitude)
	        position: [longitude, latitude],
	        offset: new AMap.Pixel(-12, -24),
	        extData: i
    	});
    	marker.setMap(map);
    	markers[i] = marker;
    	AMap.event.addListener(markers[i], "click", function(){
    		jQuery('#filter').hide();
    		<%if (clienttype.equals("Webclient")) {%>
    			jQuery('#mapContainer').height( mapHeight -140 );
    		<%}else{%>
    			jQuery('#mapContainer').height( mapHeight -100 );
    		<%}%>
    		if(curMarkerIndex >=0 ){
    			markers[curMarkerIndex].setIcon("/workflow/ruleDesign/images/amap/positionRed.png");
    		}
    		markers[i].setIcon("/workflow/ruleDesign/images/amap/positionBlue.png");
    		jQuery('#curPosition').css('bottom','130px');
			jQuery('#userInfo').show();
			jQuery("#userDateId").show();
			jQuery('#userInfo').height(100);
			jQuery('#nodeNameId').html("[" +nodename+ "]");
			jQuery('#addrId').html('<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %>'+": "+ addr );			
			jQuery('#userIconId').attr("src", userIcon); 	
			jQuery('#userDataId').width(jQuery('#userId').width()-50); //固定高度，防止内容过多，导致布局错位
			jQuery('#userDataId').html(username +"/"+department);
			jQuery('#dateInfo').html(time);
			curMarkerIndex = i;
    	});
  	}
  	
  	/* 连接位置点 */
  	function linkMarks(i,longitude1, latitude1,longitude2, latitude2){
  		var lineArr = [
			[longitude1, latitude1],
			[longitude2, latitude2]
	  	];
		var line = new AMap.Polyline({
			path: lineArr,          //设置线覆盖物路径
			strokeColor: "#FC2C2C", //线颜色
			strokeOpacity: 1,       //线透明度
			strokeWeight: 2,        //线宽
			strokeStyle: "solid",   //线样式
			strokeDasharray: [10, 5] //补充线样式
	  	});
 	 	line.setMap(map);
  		line.show();
  		lines[i] = line;
  	}
  	
  	/* 调用手机GPS模块，获取位置信息 */
  	function getCurPosition(){
  		<%if (clienttype.equals("Webclient")) {%>
  			geolocation.getCurrentPosition();
  			jQuery('#curPosition').attr("src", "/workflow/ruleDesign/images/amap/loading.png");
  		<%}else {%>
  			location="emobile:gpsbyfieldid:getCurrentGps:" + '0';
  			jQuery('#curPosition').attr("src", "/workflow/ruleDesign/images/amap/loading.png");
  		<%}%>
  	}
  	
  	/* 获取位置的回调函数 */
  	function getCurrentGps(fieldid, data){
  		jQuery('#curPosition').attr("src", "/workflow/ruleDesign/images/amap/curiPosi.png");
  		var gpsInfo = data.split(',');
  		var latitude  = gpsInfo[2]; 
  		var longitude = gpsInfo[1];   		
  		var addr = gpsInfo[3];
  		curiPosi = {
  						lng:longitude,
  						lat:latitude,
  						addr:addr
  					};
		curPosMarker.setPosition([longitude, latitude]);
		curPosMarker.setMap(map);
    	map.setCenter([longitude, latitude]);
    	
    	//显示信息框
    	jQuery('#filter').hide();
    	jQuery("#userInfo").show();
    	jQuery("#userDateId").hide();
    	jQuery('#mapContainer').height( mapHeight -58 );
    	jQuery('#userInfo').height(58);
    	jQuery('#curPosition').css('bottom','88px');
    	jQuery('#nodeNameId').html("[" +"<%=SystemEnv.getHtmlLabelName(126403,user.getLanguage())%>"+ "]");   //我的位置
    	jQuery('#addrId').html('<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %>'+": "+ addr );
    		   	
    	
  	}

  	jQuery(function(){  
 		createMap();
 		addnode();
 		 //地图添加标记
  		curPosMarker = new AMap.Marker({
 			icon:"/workflow/ruleDesign/images/amap/position-red.png",
 			offset: new AMap.Pixel(-8, -20),
    	}); 
    	AMap.event.addListener(curPosMarker, "click", function(){ 
	    	jQuery('#filter').hide();
	    	jQuery("#userInfo").show();
	    	jQuery("#userDateId").hide();
	    	<%if (clienttype.equals("Webclient")) {%>
	    		jQuery('#mapContainer').height( mapHeight -98 );
	    		jQuery('#userInfo').height(60);
	    	<%}else{%>
	    		jQuery('#mapContainer').height( mapHeight -60 );
	    		jQuery('#userInfo').height(60);
	    	<%}%>
	    	jQuery('#curPosition').css('bottom','88px');
	    	jQuery('#nodeNameId').html("[" +"<%=SystemEnv.getHtmlLabelName(126403,user.getLanguage())%>"+ "]");   //我的位置
	    	jQuery('#addrId').html('<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %>'+": "+ curiPosi.addr );
    	});	 		
  		mapHeight = jQuery('#mapContainer').height();
  		<% if(locations[0].length >1){   //	locations[0].length确保二维数组中有内容，参考二维数组转换函数	
  		  	int markIndex = 0; 
	  		for(int i=0; i<locations.length;i++){
	  			if(locations[i]!=null && locations[i].length >= 4 && locations[i][3] != null && !locations[i][3].equals("")){
	    	    	String department =  dc.getDepartmentname(rc.getDepartmentID(locations[i][1]));
	    	    	department = department.replace("'","&acute;");
	  		%>  
		    		addMark(<%=markIndex%>,<%=locations[i][4]%>,<%=locations[i][5]%>,'<%=LocateUtil.getNodenameById(locations[i][0])%>',
		    				'<%=LocateUtil.getUserNameById(locations[i][1])%>','<%=locations[i][2]%>','<%=locations[i][3]%>',
		    				'<%=rc.getMessagerUrls(locations[i][1])%>','<%=department%>');
		    		<%if(i>0){
		    		    if(locations[i-1]!=null && locations[i-1].length >= 6 && locations[i-1][3] != null ){
			    			if(locations[i-1][3].equals("")){
			    				for(int j=i-2;j>=0;j--){
			    					if(locations[j]!=null && locations[j].length >= 6 && locations[j][3] != null && !locations[j][3].equals("") && !locations[j][4].equals("0") && !locations[j][5].equals("0")){
			    						%>linkMarks(<%=markIndex%>,<%=locations[j][4]%>,<%=locations[j][5]%>,<%=locations[i][4]%>,<%=locations[i][5]%>);<%	
			    						break;
			    					}
			    				}
			    			}else{%>		    			    
			    				linkMarks(<%=markIndex%>,<%=locations[i-1][4]%>,<%=locations[i-1][5]%>,<%=locations[i][4]%>,<%=locations[i][5]%>);		    			
			    			<%}
		    			}%>		    			

		    		<%}%>    
	    	<%	markIndex++;
	    		}
	  		} 
	  	}%>
		map.setFitView();  
  	});
  </script>
</html>
