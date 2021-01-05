<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2015-03-25 [移动签到-地图视图] -->
<%@ include file="/hrm/header.jsp" %>
<%@ page import="weaver.mobile.sign.MobileSign"%>
<jsp:useBean id="signIn" class="weaver.hrm.mobile.signin.SignInManager" scope="page" />
<jsp:useBean id="resourceInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String imagefilename = "/images/hdHRM_wev8.gif", needfav ="1", needhelp ="";
	String titlename = SystemEnv.getHtmlLabelNames("31726,32559", user.getLanguage());
	String tvToday = dateUtil.getCurrentDate();
	String thisDate = strUtil.vString(request.getParameter("thisDate"), tvToday);
	int oper = strUtil.parseToInt(request.getParameter("oper"), -99);
	String initPage = "N";
	if(oper == -99){
		initPage = "Y";
		oper = 0;
	}
	Calendar cal = dateUtil.getCalendar(thisDate);
	cal = dateUtil.addDay(cal, oper);
	thisDate = dateUtil.getCalendarDate(cal);
	boolean isToday = thisDate.equals(tvToday);
	String id = strUtil.vString(request.getParameter("id"));
	String uid = strUtil.vString(request.getParameter("uid"), String.valueOf(user.getUID()));
	Map datas = signIn.getData(uid, thisDate+" 00:00:00", thisDate+" 23:59:59", 1, 1000);
	List signs = null;
	if(datas != null && !datas.isEmpty()){
		signs = (List)datas.get("list");
	}
	String operDate = "";
	MobileSign mSign = null;
	
	int lSize = signs == null ? 0 : signs.size();
	Map map = new HashMap();
	for(int i=lSize-1; i>=0; i--){
		mSign = (MobileSign)signs.get(i);
		operDate = mSign.getOperateDate();
		if(!operDate.equals(thisDate)) continue;
		if(strUtil.parseToDouble(mSign.getLongitude()) <= 0 || strUtil.parseToDouble(mSign.getLatitude()) <= 0) continue;
		
		StringBuffer str = new StringBuffer();
		str.append(mSign.getLongitude())
		.append(",").append(mSign.getLatitude())
		.append(",").append(mSign.getAddress())
		.append(",").append(signIn.getShowName(mSign.getOperateType()))
		.append(",").append(mSign.getOperateTime())
		.append(",").append(mSign.getRemark())
		.append(",").append(String.valueOf(id.equals(mSign.getUniqueId())))
		.append(",").append(strUtil.replace(mSign.getAttachmentIds(), ",", "-"))
		.append(",").append(mSign.getOperaterId())
		.append(",").append(resourceInfo.getLastname(mSign.getOperaterId()));
		
		String addStrs = "";
		if(map.containsKey(mSign.getOperaterId())){
			addStrs = strUtil.vString(map.get(mSign.getOperaterId()));
		}
		addStrs += str.toString()+";";
		map.put(mSign.getOperaterId(), addStrs);
	}
	
	StringBuffer adds = new StringBuffer();
	Iterator it = map.entrySet().iterator();
	while(it.hasNext()){
		Map.Entry entry = (Map.Entry) it.next();
		adds.append((String)entry.getValue()).append("*");
	}
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title><%=SystemEnv.getHtmlLabelNames("367,81524",user.getLanguage())%></title>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
		<link rel="stylesheet" href="/appres/hrm/css/signin_wev8.css" type="text/css" />
		<link rel="stylesheet" type="text/css" href="http://developer.amap.com/Public/css/demo.Default.css" /> 
		<script language="javascript" src="http://webapi.amap.com/maps?v=1.3&key=<%=weaver.hrm.common.Constants.WEB_MAP_KEY%>"></script>
		<style type="text/css">
			body{
				margin:0;
				height:100%;
				width:100%;
				position:absolute;
			}
			#mapContainer{
				position: absolute;
				top:0;
				left: 0;
				right:0;
				bottom:0;
			}
			#tip{
				height: 45px;;
				line-height: 45px;
				padding-left: 10px;
				padding-right: 10px;
				position:absolute;
				font-size: 12px;
				left: 300px;
				top: 10px;
				border-radius: 3px;
			}
			#tipDate{
				color:#0D9BF2;
				outline:none;
				width:100px;
				float: left;
				text-align:center;
				background: url(/appres/hrm/image/mobile/signin/img010.png) repeat-x;
			}
			
			#markerContent {
				color:#fff;
				width:32px;
				height:32px;
			}
			
			.markerRBg {
				background:url(/appres/hrm/image/mobile/signin/img019.png) no-repeat;
			}
			
			.markerYBg {
				background:url(/appres/hrm/image/mobile/signin/img020.png) no-repeat;
			}
		</style>
		<script type="text/javascript">
			var thisDate = "<%=thisDate%>";
			var initPage = "<%=initPage%>";
			var _browser = $.client.browserVersion.browser;
			var _version = $.client.browserVersion.version;
			
			function changeBg(id, rClass, aClass){
				var obj = $("#"+id);
				if(obj.hasClass(rClass)){
					obj.removeClass(rClass);
					obj.addClass(aClass);
				}
			}
			
			function changeDate(v){
				$GetEle("oper").value = v;
				document.weaver.submit();
			}
		
			function blowUpImage(obj) {
				hs.graphicsDir = '/js/messagejs/highslide/graphics/';
				hs.outlineType = 'rounded-white';
				hs.fadeInOut = true;
				hs.headingEval = 'this.a.title';
				return hs.expand(obj);
			}
			
			function chooseDate(){
				WdatePicker({
					lang:languageStr,
					el: _browser === "IE" ? "datespan" : "hideDate",
					maxDate:"<%=tvToday%>",
					onpicked:function(dp){
						$GetEle("thisDate").value = dp.cal.getDateStr();
						changeDate(0);
						if(_browser === "IE") $GetEle("datespan").innerHTML = "";
					},
					oncleared:function(dp){}
				});
			}
		</script>
	</head>
	<body style="overflow:hidden;">
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<form id="weaver" name="weaver" method="post" action="mapViewContent.jsp">
			<div id="mapContainer"></div>
			<div id="tip">
				<div class="img img009">
					<a href="javascript:void(0);" onclick="changeDate(-1);">
						<div id="left" class="img leftBg" style="position:absolute;margin: 8px 0px 0px 9px;" onMouseOver="changeBg('left', 'leftBg', 'leftBgMou');" onMouseOut="changeBg('left', 'leftBgMou', 'leftBg');"></div>
					</a>
				</div>
				<div id="tipDate"><a href="javascript:void(0);" onclick="chooseDate();"><font color="#0072E3"><%=isToday ? SystemEnv.getHtmlLabelName(15537, user.getLanguage()) : thisDate%></font></a></div>
				<input type="hidden" name="oper" id="oper" value="0"/>
				<input type="hidden" name="hideDate" id="hideDate"/>
				<input type="hidden" name="thisDate" id="thisDate" value="<%=thisDate%>"/>
				<input type="hidden" name="uid" id="uid" value="<%=uid%>"/>
				<div class="img img011">
					<a href="javascript:void(0);" onclick="<%=isToday ? "" : "changeDate(1);"%>">
						<div id="right" class="img <%=isToday ? "rightDisBg" : "rightBg"%>" style="position:absolute;margin: <%=isToday ? "8" : "7"%>px 0px 0px -7px;" onMouseOver="changeBg('right', 'rightBg', 'rightBgMou');" onMouseOut="changeBg('right', 'rightBgMou', 'rightBg');"></div>
					</a>
				</div>
				<div style="padding-top:38px;"><span id="datespan" name="datespan"></span></div>
			</div>
		</form>
	</body>
	<script type="text/javascript">
		var allUserSings = "<%=adds.toString()%>".split("*");
		var canExc = true;
		var map = null;
		$(document).ready(function(){
			parent.setThisDate(thisDate);
			$GetEle("tip").style.left = (document.body.clientWidth/2-60)+"px";
			if(initPage === "Y" && _browser==="IE") changeDate(0);
			
			map = new AMap.Map("mapContainer", {
				resizeEnable: true,
				view: new AMap.View2D({
					zoom:10
				})
			});
			
			//设置地图语言  英文：'en' 中英混合 'zh_en'  中文：'zh_cn', 只支持中英文，除英文外的语言，还是默认中文
			<%if(user.getLanguage()==8){%>
				map.setLang('en');
			<%}%>
			map.plugin(["AMap.ToolBar"],function(){		
				var toolBar = new AMap.ToolBar();
				map.addControl(toolBar);
			});
			map.plugin(["AMap.Scale"], function(){		
				var scale = new AMap.Scale();
				map.addControl(scale);
			});
			var rectOptions = {	
				strokeStyle:"dashed",
				strokeColor:"#FF2D2D",
				fillColor:"#FFFFFF",
				fillOpacity:0.5,
				strokeOpacity:1,
				strokeWeight:2	
			};
			map.plugin(["AMap.MouseTool"],function(){ 
				var mouseTool = new AMap.MouseTool(map); 
				mouseTool.rectZoomIn(rectOptions);
			});
			
			var colorIndex = -1;
			var colors = ["#0072E3", "#BE77FF", "#FFD306", "#02DF82", "#D94600", "#AE0000", "#5CADAD", "#AE57A4", "#613030 ", "#D9006C"];
			if(allUserSings && allUserSings.length > 0){
				var _str = "";
				for(var _i = 0; _i<allUserSings.length; _i++){
					_str = allUserSings[_i].replace(/\*/g, "");
					if(_str === "") continue;
					var addArr = _str.split(";");
					if(addArr && addArr.length > 0){
						colorIndex++;
						if(colorIndex > colors.length-1) colorIndex = 0;
						var lineArr = new Array();
						var info;
						for(var i=0; i<addArr.length; i++){
							if(addArr[i] == "") continue;
							info = addArr[i].split(",");
							lineArr.push(new AMap.LngLat(info[0], info[1]));
							addMarker(info[0], info[1], i+1, colors[colorIndex], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9], addArr.length);
						}
						var polyline = new AMap.Polyline({
							path: lineArr,
							strokeColor: colors[colorIndex],
							strokeOpacity: 1,
							strokeWeight: 3,
							strokeStyle: "solid"
						});
						polyline.setMap(map);
					}
				}
				AMap.event.addListener(map,'click',function(e){
					if(canExc === false) return;
					closeInfoWindow();
					var markers = $("#mapContainer").find("div.amap-layers").children("div");
					markers.each(function(i, obj){
						if(i == 1) {
							obj = $(obj).children("div.amap-marker");
							obj.each(function(i, obj){
								obj = $(obj).find("#markerContent");
								if(obj.hasClass("markerYBg")){
									obj.removeClass("markerYBg");
									obj.addClass("markerRBg");
								}
							});
						}
					});
				});
			}
			
			map.setFitView();
		});
		
		function addMarker(x, y, index, color, title, type, signTime, memo, isDance, img, uid, lastname, mSize){
			var marker = new AMap.Marker({
				map: map,
				title: lastname+","+title,
				content: "<div id='markerContent' class='markerContent"+uid+"_"+index+" markerRBg' style='padding:5px 0px 0px 12px;'>"+index+"</div>",
				position: new AMap.LngLat(x, y)
			});
			var content = "<%=SystemEnv.getHtmlLabelName(83508,user.getLanguage())%>"+title+"<br><img src='/appres/hrm/image/mobile/signin/img005.png' style='position:relative;float:left;margin:0 5px 5px 0;'>"+signTime+"<br><div class='dotedLine'></div><br><img src='/appres/hrm/image/mobile/signin/img018.png' style='position:relative;float:left;margin:0 5px 5px 0;'>"+memo+"<br>";
			var imgArray = img.split("-");
			for(var i=0; i<imgArray.length; i++){
				if(!imgArray[i] || imgArray[i]=="") continue;
				content += "<a href='/weaver/weaver.file.FileDownload?fileid="+imgArray[i]+"' onclick='return blowUpImage(this);'><img src='/weaver/weaver.file.FileDownload?fileid="+imgArray[i]+"' border=0 width='100' height='110'></a>";
			}
			var infoWindow = new AMap.InfoWindow({
				isCustom:true,
				content:createInfoWindow(
					type,
					content
				),
				offset:new AMap.Pixel(16, -45)
			});
			
			AMap.event.addListener(marker, 'click', function (){
				restoreBg(uid, index, mSize, 'marker');
				canExc = false;
				window.setTimeout(function(){canExc = true;},100);
                infoWindow.open(map, marker.getPosition());
				window.setTimeout(function(){try{if($(".info").width() < 260) $(".info").width(260)}catch(e){}},100);
            });
		}
		
		function restoreBg(uid, index, mSize, from){
			for(var i=0; i<mSize; i++){
				if(i != index && $("div.markerContent"+uid+"_"+i).hasClass("markerYBg")){
					$("div.markerContent"+uid+"_"+i).removeClass("markerYBg");
					$("div.markerContent"+uid+"_"+i).addClass("markerRBg");
				}
			}
			if(from === "marker") highlightBg(uid, index);
		}
		
		function highlightBg(uid, index){
			if($("div.markerContent"+uid+"_"+index).hasClass("markerRBg")){
				$("div.markerContent"+uid+"_"+index).removeClass("markerRBg");
				$("div.markerContent"+uid+"_"+index).addClass("markerYBg");
			}
		}
			
		function createInfoWindow(title,content){
			var info = document.createElement("div");
			info.className = "info";
		
			//info.style.width = "400px";//修改自定义窗体的宽高
		
			var top = document.createElement("div");
			var titleD = document.createElement("div");
			var closeX = document.createElement("img");
			top.className = "info-top"; 
			titleD.innerHTML = title; 
			closeX.src = "http://webapi.amap.com/images/close2.gif";
			closeX.onclick = closeInfoWindow;
			  
			top.appendChild(titleD);
			top.appendChild(closeX);
			info.appendChild(top);
			
		    
			var middle = document.createElement("div");
			middle.className = "info-middle";
			middle.style.backgroundColor='white';
			middle.innerHTML = content;
			info.appendChild(middle);
			
			var bottom = document.createElement("div");
			bottom.className = "info-bottom";
			bottom.style.position = 'relative';
			bottom.style.top = '0px';
			bottom.style.margin = '0 auto';
			var sharp = document.createElement("img");
			sharp.src = "http://webapi.amap.com/images/sharp.png";
			bottom.appendChild(sharp);	
			info.appendChild(bottom);
			return info;
		}
		
		function closeInfoWindow(){
			map.clearInfoWindow();
		}
	</script>
	<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>