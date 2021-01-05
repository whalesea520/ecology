<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<%@ include file="/formmode/pub.jsp"%>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSet" scope="page" />

<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int appId = Util.getIntValue(request.getParameter("modelId"), 0);
AppInfoService appInfoService = new AppInfoService();
Map<String, Object> appInfo = appInfoService.getAppInfoById(appId);
String treeFieldName = Util.null2String(appInfo.get("treefieldname"));

int subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subCompanyId")),-1);
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
String subCompanyId2 = ""+subCompanyId;
int currentSubCompanyId = Util.getIntValue(Util.null2String(rightMap.get("currentSubCompanyId")),-1);
//若未选择则应用则用默认分权id 
if(subCompanyId==-1||subCompanyId==0){
    subCompanyId=currentSubCompanyId;
    //若应用分权还是空
    if(subCompanyId==-1||subCompanyId==0){
        RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
        if(RecordSetTrans.next()) subCompanyId = RecordSetTrans.getInt("id");
    }
}

ModelInfoService modelInfoService = new ModelInfoService();
JSONArray modelInfoArr = new JSONArray();
if(fmdetachable.equals("1")){
	modelInfoArr = modelInfoService.getModelInfoByAppIdWithJSONDetach(appId,currentSubCompanyId);
}else{
	modelInfoArr = modelInfoService.getModelInfoByAppIdWithJSON(appId);
}

String titlename=SystemEnv.getHtmlLabelName(23669,user.getLanguage());//模块设置
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
	    //从数据库 获取
	    //var datas = [{"id":"1", "entityname":"信息传递", "entitydesc":""},{"id":"2", "entityname":"模块1", "entitydesc":"用于测试，创建人ly"},{"id":"3", "entityname":"（作废）测所有类型字段", "entitydesc":""},{"id":"4", "entityname":"表单测试", "entitydesc":""},{"id":"5", "entityname":"111", "entitydesc":""},{"id":"6", "entityname":"自定义模板＋明细(作废)", "entitydesc":""},{"id":"7", "entityname":"weiw-testMode", "entitydesc":"weiw-testMode"},{"id":"8", "entityname":"aaaaa", "entitydesc":""},{"id":"9", "entityname":"xj模块1", "entitydesc":""},{"id":"11", "entityname":"车辆油卡", "entitydesc":""},{"id":"12", "entityname":"ly带明细表单", "entitydesc":""},{"id":"13", "entityname":"111", "entitydesc":""},{"id":"14", "entityname":"01驾驶员基本信息", "entitydesc":""},{"id":"15", "entityname":"驾驶员培训记录", "entitydesc":""},{"id":"18", "entityname":"公文", "entitydesc":""},{"id":"22", "entityname":"自定义模板＋明细", "entitydesc":""},{"id":"23", "entityname":"（作废）ly带明细表单", "entitydesc":""},{"id":"24", "entityname":"ly多明细", "entitydesc":""},{"id":"27", "entityname":"html字段计算", "entitydesc":""},{"id":"26", "entityname":"客户信息－客户", "entitydesc":""},{"id":"28", "entityname":"test", "entitydesc":""},{"id":"29", "entityname":"ly测试自定义浏览框", "entitydesc":""},{"id":"30", "entityname":"ly测流转", "entitydesc":""},{"id":"31", "entityname":"测试模块1", "entitydesc":"test1"},{"id":"32", "entityname":"lxd模块01", "entitydesc":""},{"id":"33", "entityname":"liuy模块01", "entitydesc":"liuy模块01description"},{"id":"35", "entityname":"图书类别", "entitydesc":"分类信息"},{"id":"36", "entityname":"lxd02", "entitydesc":""},{"id":"37", "entityname":"02驾驶员培训记录", "entitydesc":""},{"id":"39", "entityname":"车辆ETC费用管理", "entitydesc":""},{"id":"40", "entityname":"03驾驶员事故违章记录", "entitydesc":""},{"id":"43", "entityname":"07车辆停车过路费", "entitydesc":""},{"id":"44", "entityname":"liuy模块02", "entitydesc":""},{"id":"45", "entityname":"liuy模块03（停用）", "entitydesc":""},{"id":"46", "entityname":"liuy模块04", "entitydesc":""},{"id":"47", "entityname":"liuy模块05", "entitydesc":""},{"id":"48", "entityname":"培训表单", "entitydesc":""},{"id":"49", "entityname":"zjy001", "entitydesc":""},{"id":"50", "entityname":"dc_测试建模", "entitydesc":"dc_测试建模"},{"id":"52", "entityname":"asdad", "entitydesc":""},{"id":"53", "entityname":"201308", "entitydesc":""},{"id":"60", "entityname":"hubo", "entitydesc":""},{"id":"61", "entityname":"客户", "entitydesc":""},{"id":"62", "entityname":"ffff", "entitydesc":""},{"id":"10", "entityname":"康康测试", "entitydesc":"康康测试"},{"id":"21", "entityname":"客户信息2", "entitydesc":""},{"id":"16", "entityname":"所有字段", "entitydesc":""},{"id":"19", "entityname":"111", "entitydesc":""},{"id":"38", "entityname":"04车辆信息维护", "entitydesc":""},{"id":"54", "entityname":"xxtest", "entitydesc":""},{"id":"20", "entityname":"客户信息－个人用户", "entitydesc":""},{"id":"34", "entityname":"图书管理", "entitydesc":""},{"id":"55", "entityname":"liuy模块07", "entitydesc":""},{"id":"41", "entityname":"05车辆保险", "entitydesc":""},{"id":"42", "entityname":"06车辆税费", "entitydesc":""},{"id":"51", "entityname":"liuy模块06", "entitydesc":""},{"id":"59", "entityname":"权限测试模块", "entitydesc":""}];
		var datas = <%=modelInfoArr%>;
		var currModelId;
		var currentDatas;
		$(document).ready(function () {
			//currModelId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_MODEL, datas, "id");
			//currPageIndex = FormmodeUtil.getLastIdPageIndex(currModelId,datas,"id",pageSize);
			//去掉左菜单边框
			try{
				top.document.getElementById("leftmenuTD").style.borderRight = "#e6e6e6 1px solid";
			}catch(e){}
			
			var leftPanel = new Ext.Panel({
				contentEl: "leftPart",
				header:false,
				region: "west",
				width:250,
				border: false,
            	split:true,
            	collapsible: true,
           		collapsed : false
			});
			
			var url = "";
			//if(currModelId != null){
				url = "/formmode/exttools/impexp.jsp?appId="+<%=appId%>+"&subCompanyId="+<%=subCompanyId%>;	
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
			
			initSearchText(doTextSearch);
			currentDatas = datas;
			doSearchTextChange();
		});
		
		var srarchData;
		function doTextSearch(text){
			text = text.toLowerCase();
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].entityname.toLowerCase().indexOf(text) != -1 || currentDatas[i].entitydesc.toLowerCase().indexOf(text) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			doPagination(srarchData, pagedDataRender);
			$(".e8_left_center .e8_title span").html("<%=treeFieldName%>(" + srarchData.length +")");
		}
		
		function doSearchTextChange(){
			var st = $(".e8_searchText").val();
			doTextSearch(st);
		}
		
		function changeRightFrameUrl(id){
			var $AElement = $("#A_" + id);
			var $li = $AElement.parent();
			$li.siblings().removeClass("selected");
			$li.addClass("selected");
			currModelId = id;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_MODEL, id);
			var url = "/formmode/exttools/impexp.jsp?id="+id+"&appId=<%=appId%>&" + ((new Date()).valueOf())+"&subCompanyId="+<%=subCompanyId%>;
			$("#rightFrame").attr("src", url);
		}
		
		function pagedDataRender(data){
			var entitydesc = data["entitydesc"];
			if(entitydesc==""){
				entitydesc = "<%=SystemEnv.getHtmlLabelName(82164,user.getLanguage())%>";//无描述信息.
			}else if(entitydesc.length>30){
				entitydesc = entitydesc.substring(0, 25) + "...";
			}
			var subtablecount = "";
			var virtualRightPosition = 0;
			//virtualRightPosition = 20;
			return "<a id=\"A_"+data["id"]+"\" href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl('"+data["id"]+"',this);\">" +
						"<div class=\"e8_data_label\">"+data["entityname"]+"</div>" +
						"<div class=\"e8_data_label2\">"+entitydesc+"</div>" +
						//subtablecount +
					"</a>";
		}
		
		function createModel(){
			$("#rightFrame").attr("src", "/formmode/setup/modelInfo.jsp?appId="+<%=appId%>);
			rightMenu.style.visibility = "hidden";
		}
		
		//翻页时选中当前数据，leftPartTemplate.js中调用。
		function onPagedCallback(){
			if(currModelId != null){
				var $currModel = $("#A_" + currModelId);
				if($currModel.length > 0){
					$currModel.parent().addClass("selected");
				}
			}
		}
		function refreshData(){
			var url = "/weaver/weaver.formmode.servelt.ModelInfoAction?action=getModelInfoByAppIdWithJSON&modeid=<%=appId%>&fmdetachable=<%=fmdetachable%>&subCompanyId=<%=currentSubCompanyId%>";
			FormmodeUtil.doAjaxDataLoad(url, function(formDatas){
				currentDatas = formDatas;
				doSearchTextChange();
			});
		}
		
		function refreshModeOperation(id){
			changeRightFrameUrl(id);
			refreshData();
		}
		
		function refreshWithFormCreated(modelId){
			changeRightFrameUrl(modelId);
			refreshData();
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
