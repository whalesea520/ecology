
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	//pagetype 为1：出口条件； 2：批次条件; 4:督办条件; 3:规则设计
	/*String pagetype = Util.null2String(request.getParameter("pagetype"));
	if(pagetype.equals("")) pagetype = "1";
	//pagetype = "2";
	//出口条件传过来的参数   start
	String formid = Util.null2String(request.getParameter("formid"));
	
	String isbill = Util.null2String(request.getParameter("isbill"));
	//System.out.println(formid+"+++"+isbill);
	String linkid = Util.null2String(request.getParameter("linkid"));
	
	String src = Util.null2String(request.getParameter("method"));
	String fshowname = Util.null2String(request.getParameter("fshowname"));
	String ftype = Util.null2String(request.getParameter("ftype"));
	if(ftype.equals(""))ftype="2";
	
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	//出口条件传过来的参数   end
	*/
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	String fromType = Util.null2String(request.getParameter("useType"));  // 1：表示从签字意见处调用地图, 2:点击地址调用地图(只读),3:来自规则
	//System.out.println("================useType=" + useType);
	String addr = "";
	String lng = "";
	String lat = "";
	if(fromType.equals("2") || fromType.equals("1")){  //来着签字意见插入位置
	    addr = java.net.URLDecoder.decode(Util.null2String(request.getParameter("addr")),"utf-8");
	    lng = Util.null2String(request.getParameter("lng"));
	    lat = Util.null2String(request.getParameter("lat"));
	}else if (fromType.equals("3")){ //来着规则编辑
	    addr = Util.null2String(request.getParameter("addr"));
	    lng  = Util.null2String(request.getParameter("lng"));
	    lat  = Util.null2String(request.getParameter("lat"));
	}
	
%>
<HTML oncontextmenu="doNothing();"><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--<base href="<%=basePath%>">-->
<link href="/workflow/ruleDesign/css/common.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="/workflow/ruleDesign/css/map.css" />
<script src="/js/jquery/jquery-1.4.2.min.js" type="text/javascript"></script>
<!--  <script language="javascript" src="http://webapi.amap.com/maps?v=1.2&key=1de5f5f7f410712e1280aaf08d2065f1"></script> -->
<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main1119.css"/>
<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=fc5d1213234d994e5f4f8b1afd10eb71&plugin=AMap.DistrictSearch"></script>
<script type="text/javascript" src="http://cache.amap.com/lbs/static/addToolbar.js"></script>
<style type="text/css">
#searchInput{ 
	width:300px;	
	height: 38px;
	line-height: 38px;
	font-size: 16px;
	color: #333;
	position: relative;
	top:0px;
	box-sizing: border-box;	
	border-left: 0px;
    text-indent: 4px;
}
.searchDiv{
	border-radius: 2px 0 0 2px;
	position:absolute;
	top:5px;
	left: 85px;
	background:#000;
	background: #fff;    
	position:absolute;
	top: 20px;
	left: 85px;
	pointer-events: auto;
	border-radius: 2px 0 0 2px;
	box-sizing: border-box;
	box-shadow: 1px 2px 1px rgba(0,0,0,.15);
	border-left: 1px #e9e9e2 solid;
}
</style>
<script language="javascript">
var map,toolBar,mouseTool,contextMenu,locateDatavar,signMarker, msearch,selectMarker , icon, curProvince='',searchMarker,autoSearch;

$(function(){
	map = new AMap.Map("map", {
		keyboardEnable:false,
		level:13
	});	
	document.oncontextmenu = function(){return false;} //禁止右键菜单
	jQuery("html").mousedown(function(event){  //禁止冒泡
            event.stopPropagation();
    });
    
    map.getCity(function(result){
    	curProvince = result.citycode;
    });
    
	jQuery("#inputClear").click(function(){
		jQuery('#searchInput').val("");
		jQuery(this).hide();
		jQuery("#result").hide();
	});
	jQuery("#searchButton").click(function(){
		var keyWord = jQuery(searchInput).val();
		if(keyWord !=''){
			//alert(jQuery("#searchHidden").val() + keyWord);
			searchByKeword(jQuery("#searchHidden").val() + keyWord);
		}
		jQuery("#result").hide();
	});
	jQuery("#map").click(function(){
		jQuery("#result").hide();
	});
    
    <%if(fromType.equals("2")){%>
		jQuery(".searchDiv").hide();
		jQuery("#searchButton").hide();
    	var lng = <%=lng%>;
    	var lat = <%=lat%>;
    	var width = 0;
    	var lngNew =0;
    	var addr = "<%=addr%>";
    	var lnglat = new AMap.LngLat(lng,lat)
   	
    	var addrWindow = new AMap.InfoWindow({
	    	isCustom:true,  //使用自定义窗体
	        autoMove:false,    
	        offset:new AMap.Pixel(480,-46)
	    });
    	
    	//签字意见中的marker
		signMarker = new AMap.Marker({  
	        map:map,  
	        icon:"/ueditor/custbtn/images/positionBlue.png",
	        //offset: new AMap.Pixel(0, 0),
	        
	        position:lnglat  
	    });
		
		map.setCenter(lnglat);
	  	windowContent = "<div id=addr style='position: absolute;'><div class=addrLeft></div><div class='addrMiddle'>" + addr + "</div><div class='addrRight'></div></div></div>"
	  	addrWindow.setContent(windowContent);	  	
		addrWindow.open(map, lnglat);
		
    	signMarker.show();    	
    	//
    	map.setZoom(14);
    	//map.setFitView();
    	
    	
    <%}%>
    

    
	<%if(!fromType.equals("2")){%>
	
		//地图中添加地图操作ToolBar插件、鼠标工具MouseTool插件
	    map.plugin(["AMap.ToolBar","AMap.MouseTool","AMap.Geocoder"],function(){    
	        toolBar = new AMap.ToolBar();
	        map.addControl(toolBar);
	        mouseTool = new AMap.MouseTool(map);
	        
	        MGeocoder = new AMap.Geocoder({
	            radius: 1000,
	            extensions: "all"
	        });
	        //返回地理编码结果
	        AMap.event.addListener(MGeocoder, "complete", geocoder_CallBack);
	    });
	    
	    /*map.plugin(["AMap.PlaceSearch"], function() {          
	        msearch = new AMap.PlaceSearch({ //构造地点查询类
	            pageSize: 5,
	            pageIndex: 1,
	            map: map,
	            panel: "panel",
	            //city: curProvince
	        });  //构造地点查询类  
	        
	        AMap.event.addListener(msearch, "complete", Search_CallBack); //查询成功时的回调函数  
	        AMap.event.addListener(msearch, 'error', onError); 
	    });*/
	    
	    //用于点击搜索按钮或回车
	    map.plugin(["AMap.Autocomplete"], function() {
            var autoOptions = {
                //city:  curProvince //城市，默认全国
            };
            msearch = new AMap.Autocomplete(autoOptions);
            AMap.event.addListener(msearch,"complete",Search_CallBack);

        });        
        
		//用于下拉列表的自动搜索
        map.plugin(["AMap.Autocomplete"], function() {
            autoSearch = new AMap.Autocomplete('');
            //查询成功时返回查询结果
            AMap.event.addListener(autoSearch,"complete",autocomplete_CallBack);

        });
        
	    //自定义右键菜单内容
	    var menuContent = document.createElement("div");
	    menuContent.innerHTML = "<ul class='rightMenu'>"
	    	//选择位置
	        + "<li class='item setting' onclick='addMarkerMenu()'>"+'<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%>' +"</li>"
	        + "<li><div class='line'></div></li>"
	        //放大
	        + "<li class='item zoomOut' onclick='zoomMenu(1)'>"+'<%=SystemEnv.getHtmlLabelName(22208,user.getLanguage())%>' +"</li>"
	        //缩小
	        + "<li class='item zoomIn' onclick='zoomMenu(0)'>"+'<%=SystemEnv.getHtmlLabelName(22209,user.getLanguage())%>' +"</li>"
	        + "</ul>";
	    
	    //创建右键菜单
	    contextMenu = new AMap.ContextMenu({isCustom:true,content:menuContent});//通过content自定义右键菜单内容
	     
	    //地图绑定鼠标右击事件——弹出右键菜单
	    AMap.event.addListener(map,"rightclick",function(e){
	    	jQuery(".rightMenu").children().css("background-color","#fff");
	        contextMenu.open(map,e.lnglat);
	        contextMenuPositon = e.lnglat;
	        
	    });	  
	    
	    AMap.event.addListener(map,"click",function(e){
	    		jQuery(".rightMenu").children().css("background-color","#fff"); 
	    		contextMenu.close();
	    		//alert(2);
	    });
	    
	    jQuery(".rightMenu").children().css("background-color","#fff"); 	
	    contextMenu.close();
	    


	<%}%>
	<%if((fromType.equals("1") || fromType.equals("3")) && !lng.equals("") && !lat.equals("")){%>
		contextMenuPositon = new AMap.LngLat(<%=lng%>,<%=lat%>);
	    contextMenuPositon.address = '<%=addr%>';
	    contextMenuPositon.showInfo = true;
		addmarker(contextMenuPositon);
		map.setCenter(new AMap.LngLat(<%=lng%>,<%=lat%>));
		//var icon1 = new AMap.Icon({
		//	image: "images/mark_r.png",
		//	imageOffset: new AMap.Pixel(-32, -0)
		// });
	    selectMarker = new AMap.Marker({  
		    map:map,  
		    icon: "images/mark_r.png",
		    zIndex:200,
		    shape: new AMap.MarkerShape([<%=lng%>,<%=lat%> ,1],'circle') //设置marker的可点击面积
		});

	    
		selectMarker.setPosition(new AMap.LngLat(<%=lng%>,<%=lat%>));
		selectMarker.show();
	<%}%>	

    
    $("#searchInput").bind("input propertychange", function(){
    	if(jQuery(this).val() !=""){
			jQuery("#inputClear").show();
		}else{
			jQuery("#inputClear").hide();
			jQuery("#result").hide();
		}
    	var keywords = jQuery(this).val();
    	if(keywords !== ""){
    	    autoSearch.search(keywords);
    	}else{
    		jQuery("#result").hide();
    	}
    	jQuery("#searchHidden").val("");

    }).hover(
		function(){ //光标进入		
			if(jQuery("#result").children().length >0){
				jQuery("#result").show();
			}	
			jQuery(this).focus();
			if(jQuery(this).val() !=""){
				jQuery("#inputClear").show();
				autoSearch.search(keywords);
			}else{
				jQuery("#inputClear").hide();
				jQuery("#result").hide();
			}
			contextMenu.close();
		}
	).keydown(function(){
    	var key = (event||window.event).keyCode;
        var result = jQuery("#result")[0];
        var cur = result.curSelect;        
        contextMenu.close();
        if(key===40){//down
            if(cur + 1 < result.childNodes.length){
                if(result.childNodes[cur]){
                    result.childNodes[cur].style.background='';
                }
                result.curSelect=cur+1;
                result.childNodes[cur+1].style.background='#CAE1FF';
                jQuery("#searchInput").val(result.tipArr[cur+1].name );
            }
        }else if(key===38){//up
            if(cur-1>=0 && result.childNodes.length > 0){
                if(result.childNodes[cur]){
                    result.childNodes[cur].style.background='';
                }
                result.curSelect=cur-1;
                result.childNodes[cur-1].style.background='#CAE1FF';
                jQuery("#searchInput").val(result.tipArr[cur-1].name);
            }
        }else if(key === 13){ //回车
            //selectResult(result.curSelect);
            var index = cur+1;
            var searchKey = jQuery(this).val();
            if(searchKey !=""){
            	resultSize = jQuery("#result").children().length;
	            if(index == 0 || resultSize < index ){ //回车时，下拉列表的条目数量 <条目索引，说明没有选下拉列表内容，直接按回车搜索
					$("#result").hide();
		            if(jQuery(this).val() != ""){ 
		            	searchByKeword(jQuery("#searchHidden").val() + searchKey);
		            	jQuery("#result").hide();
		            }
	            }else{
	           		jQuery("#divid"+(index)).trigger("click");
	            }    
            }
                   

            //$("#result").hide();
            /*if(jQuery(this).val() != ""){ 
            	searchByKeword($(this).val());
            	jQuery("#result").hide();
            }*/
        }else if(key === 8){ //兼容ie的问题   input propertychange删除 无效
        	jQuery("#searchHidden").val("");
        	var inputval= jQuery(this).val();
        	if((inputval+"").length == 1){ 
        		jQuery("#inputClear").hide();
        	}
        	        //加载输入提示插件
	        map.plugin(["AMap.Autocomplete"], function() {
	            var autoOptions = {
	                //city: curProvince //城市，默认全国
	            };
	            var auto = new AMap.Autocomplete(autoOptions);
	            //查询成功时返回查询结果
	            if (inputval.length > 0) {
	                AMap.event.addListener(auto,"complete",autocomplete_CallBack);
	                auto.search(inputval);
	            } else {
	                $("#result").hide();
	            }
	        });
        }
    });
});

/*屏蔽右键*/
function doNothing(){
	window.event.returnValue=false;
	return false;
}

function closeWin(){
	map.clearInfoWindow();
};

function autocomplete_CallBack(data) {
    var resultStr = "";
    var tipArr = data.tips;
    
    
    if (tipArr&&tipArr.length>0) {
        for (var i = 0; i < tipArr.length; i++) {
            resultStr += "<div id='divid" + (i + 1) + "' class='searchItem' onmousemove='mousein(this)' onmouseout='mouseout(this)' onclick='selectResult("+ tipArr[i].location+",\""+tipArr[i].name+"\",\""+tipArr[i].district + "\");' ><span class='tipName'>" + tipArr[i].name + "</span><span style='color:#C1C1C1;'>"+ tipArr[i].district + "</span></div>";
        	//console.info(tipArr[i]);
        }
    } else  {
        resultStr = "<div style='line-height: 25px;padding: 5px;'>π__π "
        	+'<%=SystemEnv.getHtmlLabelName(126394,user.getLanguage())%>' +"!<br />"		//亲,人家找不到结果
        	+'<%=SystemEnv.getHtmlLabelName(126395,user.getLanguage())%>' +"：<br />1." 		//要不试试 
        	+'<%=SystemEnv.getHtmlLabelName(126396,user.getLanguage())%>' +"<br />2." 	    //请确保所有字词拼写正确 
        	+'<%=SystemEnv.getHtmlLabelName(126397,user.getLanguage())%>' +"<br />3."  		//尝试不同的关键字 
        	+'<%=SystemEnv.getHtmlLabelName(126398,user.getLanguage())%>' +"</div>";		//尝试更宽泛的关键字
    }
    
    $("#result")[0].curSelect = -1;
    $("#result")[0].tipArr = tipArr;
    $("#result").html(resultStr).show();
    if(jQuery("#searchInput").val() == ""){
    	$("#result").hide();
    }
}

function mousein(obj){
    //解决滚动条滚动，背景不铺满的问题
    var widthSum = 0;    
    jQuery(obj).children().each(function(i,o){
        widthSum+=jQuery(o).width();
    });
    jQuery(obj).css("min-width",widthSum);   
    jQuery(obj).css("background-color","#CAE1FF");
}
function mouseout(obj){
    jQuery(obj).css("background-color","#fff");
}


//选择输入提示关键字
function selectResult(lng,lat,addr,district) {

	map.clearMap();
	var lnglat = new AMap.LngLat(lng,lat)
    if (navigator.userAgent.indexOf("MSIE") > 0) {
        document.getElementById("searchInput").onpropertychange = null;
        document.getElementById("searchInput").onfocus = focus_callback;
    }
    //截取输入提示的关键字部分
    //var text = $("#divid" + (index + 1)).children().text();
    //$("#searchInput").val(text);
    $("#result").hide().html("");

    //searchByKeword(text);
    //var lng = obj.location.lng;
    //var lat = obj.location.lat;
    jQuery("#searchInput").val(addr);
    jQuery("#searchHidden").val(district);
    searchMarker = new AMap.Marker({  
	    map:map,  
	    icon: "/workflow/ruleDesign/images/mark.png",
	    zIndex:200    
	});  
	//marker绑定鼠标右击事件——弹出右键菜单
    AMap.event.addListener(searchMarker,"rightclick",function(e){
    	jQuery(".rightMenu").children().css("background-color","#fff");
        contextMenu.open(map,e.lnglat);
        contextMenuPositon = e.lnglat;	        
    });
    searchMarker.setPosition(lnglat);
    searchMarker.show();
    map.setZoom(18);
    map.setCenter(lnglat);
}

//根据选择的输入提示关键字查询
function searchByKeword(keyword) {
    msearch.search(keyword);  //关键字查询查询  
}
//回调函数  
function Search_CallBack(data) {
	map.clearMap();
	if(data.info == "NO_DATA") {
		alert("<%=SystemEnv.getHtmlLabelName(126399,user.getLanguage())%>！\n\n1.<%=SystemEnv.getHtmlLabelName(126396,user.getLanguage())%>\n2.<%=SystemEnv.getHtmlLabelName(126397,user.getLanguage())%>\n3.<%=SystemEnv.getHtmlLabelName(126398,user.getLanguage())%>");
		return;
	}
    var poiArr = data.tips;  
    var resultCount = poiArr.length;
    for (var i = 0; i < resultCount; i++) {
    	addmarker(poiArr[i], i);
    }  
    map.setFitView();
    
    //$(".main").slideUp();
    //$("#keyword").val("");
    //$("#selectProvince").val("");
}
function onError(data){
	alert("<%=SystemEnv.getHtmlLabelName(126400,user.getLanguage())%>！");  //获取数据失败
	return;
}

function addMarkerByPostion(data) {
	//alert(data.lng +":"+ data.lat+ ":" + data.address);
	var lng = data.lng;
	var lat = data.lat;
	//var icon = new AMap.Icon({
	//	image: "http://webapi.amap.com/theme/v1.3/markers/n/mark_r.png",
	//	imageOffset: new AMap.Pixel(-32, -0)
	// });
	selectMarker = new AMap.Marker({  
	    map:map,  
	    icon: "images/mark_r.png",
	    zIndex:200,
	    shape: new AMap.MarkerShape([lng,lat,1],'circle') //设置marker的可点击面积
	});

	selectMarker.setPosition(new AMap.LngLat(lng,lat));
	selectMarker.show();
}

//添加marker&infowindow      
function addmarker(data, index) {
	var lngX; 
	var latY;
	var icon;
	var openInfoFlag=true;

	
	if(data.lng && data.lat){
		lngX = data.lng;
		latY = data.lat;
	} else {
		if(data.location){
			lngX = data.location.getLng();  
			latY = data.location.getLat();  
		}else{
			lngX = data._location.getLng();  
			latY = data._location.getLat(); 
		}
	}
	var lnglat =  new AMap.LngLat(lngX,latY);
	
	var iAddress = data.address ? data.address : data._address;

		if(data.icon) {
			icon = data.icon;
		} else if(index >= 0) {
			icon = "/workflow/ruleDesign/images/mark.png";
			openInfoFlag = false;
		}/*else{
			openInfoFlag = true;
		}*/
		
	if(!openInfoFlag){
	    var mar = new AMap.Marker({  
	        map:map,  
	        icon:icon,  
	        position:new AMap.LngLat(lngX, latY),
	        zIndex: 150
	    });
	    AMap.event.addListener(mar,"rightclick",function(e){
	    		jQuery(".rightMenu").children().css("background-color","#fff");
		        contextMenu.open(map,e.lnglat);
		        contextMenuPositon = e.lnglat;
		        	    	
		});
	}/*else{
		selectMarker.setPosition(lnglat);
		selectMarker.show();		
	}*/
    
    var windowContent  = $("<div class='infoWin'>"
    	+ "<div class='close'></div>"
        + "<div class='clearboth'></div>"
        + "<div class='field' style='padding-left:0px;'>"+'<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%>' +"：<span title='"+iAddress+"'>"+iAddress+"</span></div>"
        + "<button class='ok' style='float:right;margin-right:10px;'>"+'<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>' +"</button>"
        + "<div>");
    
    windowContent.find(".close").click(function(){
    	map.clearInfoWindow();
    	selectMarker.hide();
    });
    
    windowContent.find("input.attname").focus(function(){
    	$(this).siblings(".required").hide();
    }).blur(function(){
    	if($(this).val()=="") {
        	$(this).siblings(".required").show();
        } else {
        	$(this).siblings(".required").hide();
        }
    });
    
    windowContent.find("button.ok").click(function(){
 	
        var param = {
        	name: name,
        	lng: lngX,
        	lat: latY,
        	addr: iAddress
        };
        var returnjson = {jingdu:lngX,addr:iAddress,weidu:latY,};
		if(dialog){
			dialog.callback(returnjson);
			dialog.close();
		}else
		{
			window.parent.parent.returnValue = returnjson;
		  	window.parent.parent.close();
		}
    });
  
    var infoWindow = new AMap.InfoWindow({
    	isCustom:true,  //使用自定义窗体
        content:windowContent[0],
        autoMove:true,    
        offset:new AMap.Pixel(-30,-40)  
    });    
    if(data.showInfo) 
    	infoWindow.open(map, lnglat);
}
  
function focus_callback() {
    if (navigator.userAgent.indexOf("MSIE") > 0) {
        document.getElementById("searchInput").onpropertychange = autoSearch;
    }
}

//回调函数
function geocoder_CallBack(data) {
    //返回地址描述
    address = data.regeocode.formattedAddress;
    contextMenuPositon.address = address;
    contextMenuPositon.showInfo = true;
	addmarker(contextMenuPositon);

}
//右键菜单添加Marker标记
function addMarkerMenu() {
	try{
		selectMarker.hide();	
	}catch(e){}

	//逆地理编码
    MGeocoder.getAddress(contextMenuPositon);
   // alert(contextMenuPositon);
    addMarkerByPostion(contextMenuPositon)
    mouseTool.close();
    jQuery(".rightMenu").children().css("background-color","#fff");
    contextMenu.close();
       
}

//右键菜单缩放地图
function zoomMenu(tag) {
    if(tag==0) map.zoomOut();
    if(tag==1) map.zoomIn();
    if(tag==2) map.panTo(contextMenuPositon);
    jQuery(".rightMenu").children().css("background-color","#fff");
    contextMenu.close();   
    
    
}

var dialog = parent.parent.getDialog(parent);


$(document).ready(function(){
 	resizeDialog(document);
});

</script>
</HEAD>

<BODY>

<div class="zDialog_div_content">

	<div id="_xTable" class="_xTableSplit" style="background:#FFFFFF;padding:0px;width:100%" valign="top"> 
		<div style="background-color:#FFFFFF;border-bottom: solid 1px #E8EBF3;position: relative;">
<%-- 		<div class="main" style="<%if(fromType.equals("2")){%>display:none;<%}%>width:730px;height:30px;margin-top:30px;margin-left:-360px;">
					<label style="font-weight:bold;margin-left:25px;" for="selectProvince">城市：</label>
					<select id="province" style="width:138px;height:22px;border: solid 1px #E3E3E3;" onchange='amapAdcode.selectProvince(this.value)'>
						<option value="">--请选择--</option>
					</select>
					<div style="position: relative;display: inline-block;">
						<label style="font-weight:bold;margin-left:40px;">地址：<input id="keyword" style="width:330px;" type="text"></label>
						<div id="result"></div>
					</div>
					<button id="searchBtn" class="ok" style="margin-left:10px;width:65px;height:26px;">搜&nbsp;索</button>
			</div>
			<div style="<%if(fromType.equals("2")){%>display:none;<%}%>padding:2px;font-weight:bold;background-color:#EEF1F9;border-bottom: solid 1px #D6DCE8;">地图选点
				<div id="showSearch" title="搜索"></div>
			</div>--%>
			
			
			<div id="map" style="width:930px;height:553px;border:#F6F6F6 solid 1px;"></div>
			<div class='searchDiv'>
				<input type='text' id='searchInput' autocomplete='off' maxlength='256' placeholder='<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%>' ></input> <!-- 搜索地点-->
				<div id="inputClear" title="<%=SystemEnv.getHtmlLabelName(15504,user.getLanguage())%>"  ></div> <!-- 清空 -->
				<input type="hidden" id="searchHidden" value=""></input>
			</div>
			<button id="searchButton" style='position:absolute;left:383px;' title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" data-tooltip="2"></button> <!-- 搜索 -->
			<div id="result" style='width:297px;'></div>
		</div>
	</div>

</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<%if(!fromType.equals("2")) {  //签字意见调用地图时，不显示清除按钮%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
				<%}else{ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
				<%} %>
				
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<script type="text/javascript">
function onSearch()
{
	SearchForm.submit();
}

function afterDoWhenLoaded(){
	ontrclick();
}

var weaverSplit = "||~WEAVERSPLIT~||";
function comfirmClick(type)
{	
	var returnjson = {lng:locateData.lng,lat:locateData.lat,addr:locateData.address};
	if(dialog){
		dialog.callbackfun(returnjson);
		dialog.close();
	}else
	{
		window.parent.parent.returnValue = returnjson;
	  	window.parent.parent.close();
	}
	
}

function submitClear()
{
	<%if(fromType.equals("1")){%>
		var returnjson = "";
	<%}else{%>
		var returnjson = {id:"",name:""};
	<%}%>
	if(dialog) {
		dialog.callback(returnjson);
		dialog.close();
	} else {
		window.parent.returnValue = returnjson;
		window.parent.close()
	}
}
function errorGifJudge(){
	if($("input[name='addr']").val() == ''){
		$("img[name='errorGif']").show();
	}else{
		$("img[name='errorGif']").hide();
	}
	
}

</script>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>
</HTML>

