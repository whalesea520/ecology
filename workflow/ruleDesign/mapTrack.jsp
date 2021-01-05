
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.field.LocationElement" %>
<%@ page import='net.sf.json.JSONArray' %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%-- 该文件是位置字段PC端，查看位置轨迹 --%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

   String wfid = Util.null2String(request.getParameter("wfid"));
   String requestId = Util.null2String(request.getParameter("requestId"));
   String fieldname = Util.null2String(request.getParameter("fieldname"));
   String posInfo = LocateUtil.getLocationInfo(Integer.parseInt(wfid),Integer.parseInt(requestId),fieldname);   
   String[][] locations ;
   String preNode = "";
   if(!posInfo.equals("")){
   		locations = LocateUtil.toArray(posInfo);
   }else{
       locations = new String[1][];
   }

   String csstemp = "height:100%25;";
%>

<style>
	.title{
		  background-color: #D7D7D7;
		  position: absolute;
		  top: 15px;
		  width: 140px;
		  font-size: 16px;
		  height: 24px;
		  margin-left: 20px;
		  padding-left: 14px;
		  padding-right: 5px;
		  padding-top: 12px;
		  padding-bottom: 12px;
	}
	.righttable{
		  position: absolute;
		  top: 74px;
		  margin-left: 6px;
		  border-collapse: separate;
  		  border-spacing: 15px;
	}
	.infoWin {
	  height: 140px;
	  width: 330px;
	  /*border-top: solid 2px #6CAEFF;*/
	  background-color: #FFFFFF;
	  /*color: #787E8D;*/
	  color:#000000;
	  box-shadow: 2px 2px 2px rgba(0,0,0,.3);
	  font-size:14px;
	}
	div.field{
	  height: 35px;
	  line-height: 35px;
	  /* overflow: hidden; */
	  white-space: nowrap;
	  text-overflow: ellipsis;
	  font-size:15px;
	}
	div.close{
	  height: 15px;
	  width: 12px;
	  padding: 10px;
	  float: right;
	  cursor: pointer;
	  background: url('/workflow/ruleDesign/images/amap/close-white.png') no-repeat 12px 10px ;
	  background-color: #4F81BD;
	}

	div.close:hover {
	  background-image: url('/workflow/ruleDesign/images/amap/close-hover.png');
	  background-repeat: no-repeat;
	}
	
	.dotedLine {
	  border-bottom: 1px dashed #D8D8D8;
	  padding-top: 28px;
	  margin-right: 17px;
	}	
	div.info-bottom {
	  height: 0px;
	  width: 100%;
	  clear: both;
	  text-align: center;
	  position: absolute;
  	  bottom:0px;
	  margin: 0px auto;
	}
	
	TABLE.ListStyle {
	  width: "100%";
	  margin: 10px 0pt 15px;
	  width: 100%;
	  text-align: left;
	  border-collapse: collapse;
	}
	div.input-div{
	  width: 249px;
	  height: 30px;
	  border-style: solid;
	  border-width: 1px;
	  border-color: #D6D6D6;
	  position: relative;
	  left: 7px;
	  top: 7px;
	  cursor:text;
	}
	input.searchNode{
	  float:left;
	  height: 30px;
	  border-style: none;
	  width: 219px;
	}
	img.searchImg{
		float:left;
		position: relative;
		top: 6px;
		left: 7px;
		cursor:pointer
	}
	tr.trNodes{ 
	}
	div.allpos{
	  height: 22px;
	  /*border-style: solid;*/
	  position: absolute;
  	  top: 518px;
  	  width: 100%;
	}
	span.left{
		position:relative;
		left:9px;
		top:3px;
	}
</style>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<!-- 位置轨迹 -->
  	<title><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(126093,user.getLanguage())%></title> 
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
	<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main.css?v=1.0" />
	<script src="http://cache.amap.com/lbs/static/es5.min.js"></script>
	<script src="http://webapi.amap.com/maps?v=1.3&key=67afffc83c79edd5584e9368362102aa"></script>
	<script src="/js/jquery/jquery-1.4.2.min.js" type="text/javascript"></script>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  </head>
  
	<BODY>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow" />
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%>" />
	   <jsp:param name="contentDivStyle" value="<%=csstemp %>" />
	</jsp:include>	
	
	<jsp:useBean id="rc" class='weaver.hrm.resource.ResourceComInfo'></jsp:useBean>
	<jsp:useBean id="dc" class='weaver.hrm.company.DepartmentComInfo'></jsp:useBean>
	
	<table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td></td>
			<td class="rightSearchSpan">
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 	
	
	<div class="zDialog_div_content" style="height:100%;">
		<!-- 控制栏 -->
		<div id='controlBar' style="width:265px;height:100%;float:right;position:relative;">
			<div style="height:45px;">
				<!-- 搜索框 -->
				<div class='input-div'>
					<input id='searchId' class='searchNode' type='text'></input>
					<img class='searchImg' src="/images/ecology8/request/search-input_wev8.png" onclick='nodeSearch()'>
				</div>				
			</div>			
			<table cellpadding="0" cellspacing="0" style="width:100%;font-size:12px;color:#242424;height:40px;">
				   	<colgroup>
	    				<col width="30%"/>
	    				<col width="70%"/>
	    			</colgroup>
	    			<tr style="height:1px!important;background:#DADEDB;">
	    				<td colspan="2" style='height:1px'>
	    			</tr>
	   				<tr style="height:37px;background:#f8f8f8;">
						<td style='text-align:center;'><%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td> <!-- 流转顺序 -->
						<td ><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></td> <!-- 节点 -->
					</tr>
					<tr style="height:2px!important;background:#bedef3;">
						<td colspan="2" style="height:2px;"></td>
					</tr>
			</table>
			<div>
				<div id='nodeListDiv' style="position:relative;top:4px;overflow-y:auto; overflow-x:hidden;height:100%">
					<table id='nodelist' cellpadding="0" cellspacing="0" style="width:100%;font-size:12px;color:#242424;text-overflow:ellipsis;">
						<colgroup>
		    				<col width="30%"/>
		    				<col width="70%"/>
		    			</colgroup>
					</table>
				</div>
			</div>		

			<div class='allpos' >
				<div style='width:100%;height:1px!important;background-color:#DADEDB;'></div>
				<span class='left'><input id='getAllPoint'  type='checkbox' checked onclick='selectAllMarkers(this)'><%=SystemEnv.getHtmlLabelName(126402,user.getLanguage())%></input></span>  <!-- 查看所有位置轨迹 -->
			</div>
			
		</div>
		<div style="float:right;width:1px!important;height:100%;background:#DADEDB;">
		</div>
		
		<!--地图-->
		<div style="position:absolute;right:266px;left:0;top:0;bottom:0;">
			<div id='mapContainer' style='width:100%;'></div>
		</div>
	</div>
	
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
	
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
		    </wea:item>
			</wea:group>
		</wea:layout>
	</div>	
	</BODY>
  
  <script type="text/javascript">
  	var map = null;
  	var toolBar = null;
  	var markers = new Array();
  	var lines = new Array();
  	var curMarker = null;  //点击后，选中的标记
  	var nodesList = new Array();
  	
  	function selectAllMarkers(obj){
  		if($(obj).attr("checked") == true){
  			showTrack(true);
  		}else{
  			showTrack(false);
  		}
  	}
  	
  	function nodeSearch(){
		var tableId = document.getElementById("nodelist"); 
		for(var i=0;i<tableId.rows.length;i++){ 
			if(document.getElementById("searchId").value == ''){
				tableId.rows[i].style.display='';
			}else{
				if(tableId.rows[i].cells[1].innerHTML.indexOf(document.getElementById("searchId").value) != -1){
					tableId.rows[i].style.display='';
				}else{
					tableId.rows[i].style.display='none';
				}			
			}
		} 
  	}
  	
  	function createMap(){
		map = new AMap.Map("mapContainer", {
			keyboardEnable:false,
		});	
		map.plugin(["AMap.ToolBar"], function () {
      		toolBar = new AMap.ToolBar();
      		map.addControl(toolBar);
    	});	
  	}
  	
  	function addMark(i,longitude, latitude,nodename,username,time,addr,userIcon,department){
  		time = time.replace("/", " ");
  		var marker = new AMap.Marker({
 			icon:"/workflow/ruleDesign/images/amap/positionRed.png",
	        //position:new AMap.LngLat(longitude, latitude)
	        position: [longitude, latitude],
	        offset: new AMap.Pixel(-12, -23),
	        extData: i
    	});
    	marker.setMap(map);
    	markers[i] = marker;
    	AMap.event.addListener(markers[i], "click", function(){
    		windowContent = "<div class='infoWin'>"
    			+ "<div class='close' onclick='closeWin()'></div>"
        		+ "<div class='field' style='padding-left:0px; background-color:#4F81BD;color:#FFFFFF;padding-left: 3%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;' title='" + nodename + "'>["+ nodename +"]</div>"
        		+ "<div style='padding: 11px 0px 0px 11px;'><img src='" +userIcon +"' style='width:40px;height:40px;border-radius:20px;float: left;'/>"
        		+ "<div title='"+username +"/"+department+"'  style='float: left;padding-left: 10px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;'>"+ username +"/"+department+"</div><br/>"
        		+ "<div title='"+time+"' style='float: left;padding-left: 10px;'>"+time+"</div>"
        		+ "<div class='dotedLine'></div>"
        		+ "<div title='" + addr +"' style='overflow:hidden;text-overflow:ellipsis;margin-top: 4px;'>"+'<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %>'+": " + addr +"</div>"
        		+ "<div class='info-bottom'><img src='http://webapi.amap.com/images/sharp.png' /></div>";
        	infoWindow.setContent(windowContent);
    		infoWindow.open(map, markers[i].getPosition());
    	});
  	}
  	
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
  	
  	function mousein(obj){
  		$(obj).css("color","#018EFB");
  	}
  	function mouseout(obj){
  		$(obj).css("color","#242424");
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
  		   if(!locations[i][3].equals("")){
  		     	 trHTML = "";
	  		     if(preNode.equals("") ){ 	    		
					trHTML =  "<tr class='trNodes' onclick='getPoint("+(index+1)+")' onmouseout='mouseout(this)' onmousemove='mousein(this)' style='cursor:pointer;height:30px;'><td style='text-align:center;'>"+(index+1)+"</td><td >"+ LocateUtil.getNodenameById(locations[i][0]) + "</td></tr>";
		    		preNode = locations[i][0];
		    		index++;
	  		     }else if( !preNode.equals(locations[i][0]) ){
	 				trHTML =  "<tr class='trNodes' onclick='getPoint("+(index+1)+")' onmouseout='mouseout(this)' onmousemove='mousein(this)' style='cursor:pointer;height:30px;'><td style='text-align:center;'>"+(index+1)+"</td><td >"+ LocateUtil.getNodenameById(locations[i][0]) + "</td></tr>";
		    		preNode = locations[i][0];
		    		index++;
	  		     }
	  		     if(nodes.containsKey(index)){
	  		         nodes.get(index).add(markerIndex);
	  		     }else{
	  		         nodes.put(index,new ArrayList<Integer>());
	  		       	 nodes.get(index).add(markerIndex);
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
  		closeWin();
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
  	
    function closeWin(){
    	map.clearInfoWindow();
    };
  	
  	var infoWindow = new AMap.InfoWindow({
    	isCustom:true,  //使用自定义窗体
        autoMove:true,    
        offset:new AMap.Pixel(17,-48)  
    });

    

  	jQuery(function(){
  		createMap();
    	<%
    	int markIndex = 0;
    	for(int i=0; (!posInfo.equals("") && i< locations.length);i++){
    	    if(!locations[i][3].equals("")){
    	    	String department =  dc.getDepartmentname(rc.getDepartmentID(locations[i][1]));
    	    	department = department.replace("'","&acute;");
    	%>    		
    		addMark(<%=markIndex%>,<%=locations[i][4]%>,<%=locations[i][5]%>,'<%=LocateUtil.getNodenameById(locations[i][0])%>',
    				'<%=LocateUtil.getUserNameById(locations[i][1])%>','<%=locations[i][2]%>','<%=locations[i][3]%>',
    				'<%=rc.getMessagerUrls(locations[i][1])%>','<%=department%>');
    		<%if(markIndex>0){
    			if(locations[i-1][3].equals("")){
    				for(int j=i-2;j>=0;j--){
    					if(!locations[j][3].equals("") && !locations[j][4].equals("0") && !locations[j][5].equals("0")){
    						%>linkMarks(<%=markIndex%>,<%=locations[j][4]%>,<%=locations[j][5]%>,<%=locations[i][4]%>,<%=locations[i][5]%>);<%	
    						break;
    					}
    				}
    			}else{%>		    			    
    				linkMarks(<%=markIndex%>,<%=locations[i-1][4]%>,<%=locations[i-1][5]%>,<%=locations[i][4]%>,<%=locations[i][5]%>);		    			
    			<%}%>
    		<%}%>    
    	<%markIndex++;}
    	}%>
    	addnode(); 
    	var cBarHeight = jQuery("#controlBar").height();
    	jQuery('#nodeListDiv').height(cBarHeight -120); //根据布局确定高度，从而可以出现垂直滚动条

		$('#searchId').bind('input propertychange', function(){
			nodeSearch();
		});
		map.setFitView();  
  	});
  	
  </script>
</html>
