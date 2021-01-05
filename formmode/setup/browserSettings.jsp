<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@page import="weaver.formmode.service.BrowserInfoService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ include file="/formmode/pub.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int appId=Util.getIntValue(request.getParameter("modelId"),0);
AppInfoService appInfoService=new AppInfoService();
Map<String, Object> appInfo = appInfoService.getAppInfoById(appId);
String treeFieldName = Util.null2String(appInfo.get("treefieldname"));
String treelevel = Util.null2String(appInfo.get("treelevel"));
int subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
String subCompanyId3 = ""+subCompanyId;
int currentSubCompanyId = Util.getIntValue(Util.null2String(rightMap.get("currentSubCompanyId")),-1);

BrowserInfoService browserInfoService = new BrowserInfoService();
JSONArray customSearchData = new JSONArray();
if(fmdetachable.equals("1")){
	customSearchData = browserInfoService.getBrowserInfoByAppIdWithJSONDetach(appId,currentSubCompanyId);
}else{
	customSearchData = browserInfoService.getBrowserInfoByAppIdWithJSON(appId);
}

String titlename=SystemEnv.getHtmlLabelName(82016,user.getLanguage());//浏览框设置
%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ux/miframe_wev8.js"></script>
	
	<script type="text/javascript" src="/formmode/js/jquery/pagination/jquery.pagination_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
	
	<link rel="stylesheet" href="/formmode/js/jquery/zTree3.5.15/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/formmode/js/jquery/zTree3.5.15/js/jquery.ztree.all-3.5.min_wev8.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/formmode/css/leftPartTemplate_wev8.css" />
	<script type="text/javascript" src="/formmode/js/leftPartTemplate_wev8.js"></script>
	
	<script type="text/javascript">
	
		var datas = <%=customSearchData.toString()%>;
		
		var currentDatas;
		
		var currBrowserId = null;
		
		$(document).ready(function () {
			
			currBrowserId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_BROWSER, datas, "id");
			currPageIndex = FormmodeUtil.getLastIdPageIndex(currBrowserId,datas,"id",pageSize);
			
			//去掉左菜单边框
			try{
				top.document.getElementById("leftmenuTD").style.borderRight = "#e6e6e6 1px solid";
			}catch(e){}
			
			var leftPanel = new Ext.Panel({
				contentEl: "leftPart",
				header: false,
				region: "west",
				width:250,
				border: false,
            	split:true,
            	collapsible: true,
           		collapsed : false
			});
			
			var url = "";
			//if(currBrowserId != null){
				url = "/formmode/setup/browserInfo.jsp?id="+currBrowserId+"&appid=<%=appId%>";
			//}
			
			var viewport = new Ext.Viewport({
				layout: 'border',
				items: [leftPanel,
                {
					region:'center',
					xtype     :'iframepanel',
 					frameConfig: {
                    	id:'rightFrame', 
                    	name:'rightFrame', 
                    	frameborder:0 ,
                    	eventsFollowFrameLinks : false,
                    	height:"100%",
                    	width:"100%",
                    	onload:"rightFrameLoad()",
                    	src: url
					},
                	autoScroll:true,
                	border: false
 				}]
			});
			
			initSearchText(onSearchTextChange);
			
			currentDatas = datas;
			changeRightFrameUrl(currBrowserId);
			doSearchTextChange();
		});
		
		var srarchData;
		function onSearchTextChange(text){
			text = text.toLowerCase();
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].customname.toLowerCase().indexOf(text) != -1 || currentDatas[i].customdesc.toLowerCase().indexOf(text) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			doPagination(srarchData, pagedDataRender);
			
			$(".e8_left_center .e8_title span").html("<%=treeFieldName%>(" + srarchData.length +")");
		}

		function doSearchTextChange(){
			var st = $(".e8_searchText").val();
			onSearchTextChange(st);
		}
		
		function changeRightFrameUrl(id, AElement){
			var $li = $(AElement).parent();
			$li.siblings().removeClass("selected");
			$li.addClass("selected");
			
			currBrowserId = id;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_BROWSER, id);
			
			$("#rightFrame").attr("src", "/formmode/setup/browserInfo.jsp?id="+id+"&appid=<%=appId%>");
		}
		
		function onPagedCallback(){
			if(currBrowserId != null){
				var $currForm = $("#A_" + currBrowserId);
				if($currForm.length > 0){
					$currForm.parent().addClass("selected");
				}
			}
		}
		
		function pagedDataRender(data){
			return "<a id=\"A_"+data["id"]+"\" href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl("+data["id"]+",this);\">" +
						"<div class=\"e8_data_label\">"+data["customname"]+"</div>" +
						"<div class=\"e8_data_label2\">"+data["customdesc"]+"</div>" +
					"</a>";
		}

		function refreshData(){
			var url = "/weaver/weaver.formmode.servelt.BrowserAction?action=getBrowserInfoByAppIdWithJSON&appid=<%=appId%>&fmdetachable=<%=fmdetachable%>&subCompanyId=<%=currentSubCompanyId%>";
			FormmodeUtil.doAjaxDataLoad(url, function(formDatas){
				currentDatas = formDatas;
				doSearchTextChange();
			});
		}
		
		function refreshBrowser(id){
			changeRightFrameUrl(id);
			refreshData();
		}

		function right() {
		    rightMenu.style.visibility = "hidden";
			$("#rightFrame").attr("src","/formmode/setup/browserInfo.jsp?appid=<%=appId%>");
		}
		
		function rightFrameLoad(){
			try{
				rightFrame.forPageResize();
			}catch(e){}
		}
	</script>
</head>
  
<body>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
	<%
		if(operatelevel>0&&(fmdetachable.equals("1")&&!treelevel.equals("0")||!fmdetachable.equals("1"))){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(33416,user.getLanguage())+",javascript:right(),_top} " ;//新建浏览框
			RCMenuHeight += RCMenuHeightStep ;
		}
	%>
	
	<%@ include file="/formmode/setup/leftPartTemplate.jsp" %>
	
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script type="text/javascript">
window.onload = function (){
	changePageMenuDiaplay(1);
}

var menuCount = 0;

var menuTitleArr = ["<%=SystemEnv.getHtmlLabelName(18363, user.getLanguage())%>",//首页
					"<%=SystemEnv.getHtmlLabelName(1258, user.getLanguage())%>",//上一页
					"<%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%>",//下一页
					"<%=SystemEnv.getHtmlLabelName(18362, user.getLanguage())%>"];//尾页
var pageMenuIndex = [];
function changePageMenuDiaplay(type){
	var rightMenuIframe = document.getElementById("rightMenuIframe");
	var rightMenuWin = rightMenuIframe.contentWindow;
	var menuTable = $(rightMenuWin.document.getElementById("menuTable"));
	if(rightMenuWin.location.href=="about:blank"){
		if(type==1){
			setTimeout(function(){
				changePageMenuDiaplay(1);
			},500);
		}
	}
	if(type==1){
		var index = 0;
		menuTable.children().each(function () {
			if (!jQuery(this).css("display") || jQuery(this).css("display").toLowerCase() != "none") {
				menuCount++;
				var obj = jQuery(this);
				var title = obj.find("button").attr("title");
				if(title){
					for(var i=0;i<menuTitleArr.length;i++){
						if(menuTitleArr[i]==title){
							pageMenuIndex.push(index);
							break;
						}
					}
				}
			}
			index++;
		});
	}
	var st = $(".e8_searchText").val();
	var isshow = true;
	var len = srarchData.length;
	if(st=="") len = currentDatas.length;
	if(len<=10) isshow = false;
	if(isshow){//显示右键菜单  首页    上一页    下一页    尾页
		for(var i=0;i<pageMenuIndex.length;i++){
			showRCMenuItem(pageMenuIndex[i]);
		}
	}else{
		for(var i=0;i<pageMenuIndex.length;i++){
			hiddenRCMenuItem(pageMenuIndex[i]);
		}
	}
}
</script>
</html>
