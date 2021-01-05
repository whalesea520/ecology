<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ include file="/formmode/pub.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int appId = Util.getIntValue(request.getParameter("modelId"), 0);
AppInfoService appInfoService = new AppInfoService();
FormInfoService formInfoService = new FormInfoService();
Map<String, Object> appInfo = appInfoService.getAppInfoById(appId);
String treeFieldName = Util.null2String(appInfo.get("treefieldname"));
String receiveFormid = Util.null2String(request.getParameter("formid"));

int subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
String userRightStr = "FORMMODEFORM:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
String subCompanyId3 = ""+subCompanyId;
int currentSubCompanyId = Util.getIntValue(Util.null2String(rightMap.get("currentSubCompanyId")),-1);
JSONArray forminfoArr = new JSONArray();
if(fmdetachable.equals("1")){
	forminfoArr = formInfoService.getFormInfoByAppIdWithJSONDetach(appId,currentSubCompanyId);
}else{
	forminfoArr = formInfoService.getFormInfoByAppIdWithJSON(appId);
}
String titlename=SystemEnv.getHtmlLabelName(33655,user.getLanguage());//表单设置
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
	
	<link rel="stylesheet" type="text/css" href="/formmode/css/leftPartTemplate_wev8.css?v=2" />
	<script type="text/javascript" src="/formmode/js/leftPartTemplate_wev8.js"></script>
	
	<script type="text/javascript">
	
		var datas = <%=forminfoArr.toString() %>;
		
		var currentDatas;
		
		var currFormId = null;
		
		$(document).ready(function () {
			
			currFormId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_FORM, datas, "id");
			
			if("<%=receiveFormid%>" != ""){
				currFormId = "<%=receiveFormid%>";
			}
			
			currPageIndex = FormmodeUtil.getLastIdPageIndex(currFormId,datas,"id",pageSize);
			
			
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
			
			var url = "/formmode/setup/forminfo.jsp?id="+currFormId+"&appId=<%=appId %>";	
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
	
			doSearchTextChange();
			<%
			String URLStr = request.getRequestURL().toString();   
			if(URLStr.startsWith("https:")){%>   
				//https服务才需要再次改变右侧iframe的地址
				if(currFormId){
					changeRightFrameUrl(currFormId);
				}else{
					createForm();
				}
			<%}%>
			
			//doPagination(datas, pagedDataRender);
		});
		
		var srarchData;
		function onSearchTextChange(text){
			text = text.toLowerCase();
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].formname.toLowerCase().indexOf(text) != -1 || currentDatas[i].tablename.toLowerCase().indexOf(text) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			doPagination(srarchData, pagedDataRender);
			
			$(".e8_left_center .e8_title span").html("<%=treeFieldName%>(" + srarchData.length +")");
			
			//selectedCurrData();
		}
		
		function doSearchTextChange(){
			var st = $(".e8_searchText").val();
			onSearchTextChange(st);
		}
		
		function changeRightFrameUrl(id){
			var $AElement = $("#A_" + id);
			var $li = $AElement.parent();
			$li.siblings().removeClass("selected");
			$li.addClass("selected");
			
			currFormId = id;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_FORM, id);
			
			$("#rightFrame").attr("src", "/formmode/setup/forminfo.jsp?id="+id);
		}
		
		function pagedDataRender(data){
			var subtablecount = "";
			var virtualRightPosition = 0;
			if(data["subtablecount"]!="0"){//包含 个明细表
				subtablecount = "<div class=\"e8_data_subtablecount\" title=\"<%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>"+data["subtablecount"]+"<%=SystemEnv.getHtmlLabelName(82140,user.getLanguage())%>\">"+data["subtablecount"]+"</div>";
				virtualRightPosition = 20;
			}
			var virtualform = "";
			if(data["isvirtualform"]==1){
				virtualform = "<div class=\"e8_data_virtualform\" style=\"right:"+virtualRightPosition+"px;\" title=\"<%=SystemEnv.getHtmlLabelName(33885,user.getLanguage())%>\">V</div>";//虚拟表单
			}
			
			return "<a id=\"A_"+data["id"]+"\" href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl("+data["id"]+");\">" +
						"<div class=\"e8_data_label\">"+data["formname"]+"</div>" +
						"<div class=\"e8_data_label2\">"+data["tablename"]+"</div>" +
						subtablecount +
						virtualform +
					"</a>";
		}
		
		function onPagedCallback(){
			if(currFormId != null){
				var $currForm = $("#A_" + currFormId);
				if($currForm.length > 0){
					$currForm.parent().addClass("selected");
				}
			}
		}
		
		function refreshData(){
			var url = "/formmode/setup/formSettingsAction.jsp?action=getFormInfoByAppIdWithJSON&appId=<%=appId%>&fmdetachable=<%=fmdetachable%>&subCompanyId=<%=currentSubCompanyId%>";
			FormmodeUtil.doAjaxDataLoad(url, function(formDatas){
				currentDatas = formDatas;
				doSearchTextChange();
			});
		}
		
		var formDlg;
		function createForm(){
			
			rightMenu.style.visibility = "hidden";
			$("#rightFrame").attr("src", "/formmode/setup/forminfo.jsp?appId=<%=appId%>");
			return
			formDlg = new Dialog();//定义Dialog对象
			formDlg.Model = true;
			formDlg.Width = 500;//定义长度
			formDlg.Height = 382;
			formDlg.URL = "/formmode/setup/formAdd.jsp?appId=<%=appId%>";
			formDlg.Title = "<%=SystemEnv.getHtmlLabelName(82141,user.getLanguage())%>";//新增表单
			formDlg.show();
		}
		
		function closeFormDlg(){
			if(formDlg){
				formDlg.close();
			}
		}
		function refreshFormDel(){
			
			jQuery.ajax({
			   type: "POST",
			   dataType:"json",
			   url: "formSettingsAction.jsp?action=getfirstid&appid=<%=appId%>&fmdetachable<%=fmdetachable%>&subCompanyId<%=subCompanyId%>",
			   success: function(data){
				refreshData();
				changeRightFrameUrl(data.id);
			   }
			});
			
		}
		
		function refreshForm(formId){
			changeRightFrameUrl(formId);
			
			refreshData();
		}
		
		function refreshWithFormCreated(formId){
			
			changeRightFrameUrl(formId);
			
			refreshData();
			
			closeFormDlg();
		}
		
		function openCodeEdit(){
			top.openCodeEdit({
				"type" : "1",
				"filename" : "CustomPKVFormDataSave.java"
			});
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
		if(operatelevel>0){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82021,user.getLanguage())+",javascript:toformtab(),_top} " ;//新建表单
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82106,user.getLanguage())+",javascript:createForm(),_top} " ;//新建虚拟表单
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
					"<%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%>",// 下一页  
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
var diag_vote;
function toformtab(){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;	
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
		diag_vote.Width = 1000;
		diag_vote.Height = 600;
		diag_vote.Modal = true;
		
		diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1&appid=<%=appId%>";
		diag_vote.isIframe=false;
		diag_vote.show();
}
</script>
</html>
