
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileTemplateManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%@ page import="net.sf.json.JSONArray"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
MobileTemplateManager mobileTemplateManager=MobileTemplateManager.getInstance();
//String hpTmplateHtml=mobileTemplateManager.getTemplateHtml("homepage");
//String uilistTemplateHtml=mobileTemplateManager.getTemplateHtml("formuilist");
String templateType = Util.null2String(request.getParameter("templateType"),"homepage");
JSONArray templist = mobileTemplateManager.getTemplateWithJSON(templateType);
String topname = "UI模板";
if("homepage".equals(templateType)){
	topname ="自定义页面模板";
	request.getRequestDispatcher("/mobilemode/H5Check.jsp?url=/mobilemode/setup/templateManage.jsp").forward(request, response);
	return;
}

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
		
		var datas = <%=templist.toString() %>;
		
		var templateType = "<%=templateType%>";
		
		var currentDatas;
		
		var currFormId = null;
		
		$(document).ready(function () {
			
			currFormId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_FORM, datas, "id");
			currPageIndex = FormmodeUtil.getLastIdPageIndex(currFormId,datas,"id",pageSize);
			//去掉左菜单边框
			try{
				//top.document.getElementById("leftmenuTD").style.borderRight = "#e6e6e6 1px solid";
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
			//if(currFormId != null){
				url = "/mobilemode/templateEdit.jsp?templateType="+templateType+"&index="+currFormId
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
                    	src: url
					},
                	autoScroll:true,
                	border: false
 				}]
			});
			
			initSearchText(onSearchTextChange);
			
			currentDatas = datas;
	
			doSearchTextChange();
		});
		
		function onSearchTextChange(text){
			var srarchData;
			text = text.toLowerCase();
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].name.toLowerCase().indexOf(text) != -1 || currentDatas[i].name.toLowerCase().indexOf(text) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			doPagination(srarchData, pagedDataRender);
			$(".e8_left_center .e8_title span").html("<%=topname%>(" + srarchData.length +")");
			
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
			$("#rightFrame").attr("src", "/mobilemode/templateEdit.jsp?templateType="+templateType+"&index="+id);
		}
		
		function pagedDataRender(data){
			var entitydesc = data["desc"];
			if(entitydesc==""){
				entitydesc = "无描述信息.";
			}else if(entitydesc.length>30){
				entitydesc = entitydesc.substring(0, 25) + "...";
			}
			
			return "<a id=\"A_"+data["id"]+"\" href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl('"+data["id"]+"');\">" +
						"<div class=\"e8_data_label\">"+data["name"]+"</div>" +
						"<div class=\"e8_data_label2\">"+entitydesc+"</div>" +
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
			var url = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileTemplateAction", "action=getTemplateWithJSON&templateType="+templateType);
			FormmodeUtil.doAjaxDataLoad(url, function(formDatas){
				currentDatas = formDatas;
				doSearchTextChange();
			});
		}
		
		function closeFormDlg(){
			if(formDlg){
				formDlg.close();
			}
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
	</script>
</head>
<body>
	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
	<%@ include file="/formmode/setup/leftPartTemplate.jsp" %>
	
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>  
</html>
