<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.formmode.service.ExpandInfoService"%>
<%@ include file="/formmode/pub.jsp"%>
<%
int modeId = Util.getIntValue(request.getParameter("id"), 0);

ExpandInfoService expandInfoService = new ExpandInfoService();
Map<String, Object> modeinfo = expandInfoService.getModeinfoById(modeId);
String treeFieldName = Util.null2String(modeinfo.get("modename"));
JSONArray pageExpandArr = expandInfoService.getExpandInfoByModeIdWithJSON(modeId,user.getLanguage());
%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
	
	<script type="text/javascript" src="/formmode/js/jquery/pagination/jquery.pagination_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/hoverIntent/jquery.hoverIntent.minified_wev8.js"></script>
	
	<link rel="stylesheet" href="/formmode/js/jquery/zTree3.5.15/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/formmode/js/jquery/zTree3.5.15/js/jquery.ztree.all-3.5.min_wev8.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/formmode/css/leftPartTemplate_wev8.css" />
	<script type="text/javascript" src="/formmode/js/leftPartTemplate_wev8.js"></script>
	
	<script type="text/javascript">
	
		var datas = <%=pageExpandArr.toString() %>;
		var currentDatas;
		
		var currExpandId = null;
		
		$(document).ready(function () {
			
			currExpandId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_EXPAND, datas, "id");
			currPageIndex = FormmodeUtil.getLastIdPageIndex(currExpandId,datas,"id",pageSize);
			
			//去掉左菜单边框
			try{
				top.document.getElementById("leftmenuTD").style.borderRight = "#e6e6e6 1px solid";
			}catch(e){}
			
			var leftPanel = new Ext.Panel({
				contentEl: "leftPart",
				region: "west",
				width:250,
				border: false,
            	split:true,
            	collapsible: true,
           		collapsed : false
			});
			
			var url = "";
			if(currExpandId != null){
				url = "/formmode/setup/expandBase.jsp?id="+currExpandId;	
			}
			
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
			doPagination(datas, pagedDataRender);
			$(".e8_left_center .e8_title span").html("<%=treeFieldName%>(" + datas.length +")");
			
			if(currExpandId != null){
				$("#A_" + currExpandId).parent().addClass("selected");
			}
		});
		
		function onSearchTextChange(text){
			var srarchData;
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].expandname.indexOf(text) != -1 || currentDatas[i].expanddesc.indexOf(text) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			doPagination(srarchData, pagedDataRender);
			
			$(".e8_left_center .e8_title span").html("<%=treeFieldName%>(" + srarchData.length +")");
		}
		
		function changeRightFrameUrl(id, AElement){
			var $li = $(AElement).parent();
			$li.siblings().removeClass("selected");
			$li.addClass("selected");
			
			currExpandId = id;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_EXPAND, id);
			
			$("#rightFrame").attr("src", "/formmode/setup/expandBase.jsp?id="+id);
		}
		
		function pagedDataRender(data){
			//var subtablecount = data["subtablecount"]=="0" ? "" : "<div class=\"e8_data_subtablecount\">"+data["subtablecount"]+"</div>";
			
			return "<a id=\"A_"+data["id"]+"\" href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl("+data["id"]+",this);\">" +
						"<div class=\"e8_data_label\">"+data["expandname"]+"</div>" +
						"<div class=\"e8_data_label2\">"+data["expanddesc"]+"</div>" +
						//subtablecount +
					"</a>";
		}
		
		function reloadDataWithChange(id,type){
			//编辑和新建时刷新左侧内容和顶部内容
			var refreshtype = "reload";
			if(refreshtype=="ajax"){
				$.ajax({
			   type: "POST",
			   dataType:"json",
			   url: "/formmode/setup/expandSettingsActing.jsp?operation=getexpandlist",
			   data: "modeid=<%=modeId%>&language=<%=user.getLanguage()%>",
			   success: function(respData){
					datas = respData;
					currentDatas = datas;
					$(".e8_left_center .e8_title span").html("<%=treeFieldName%>(" + datas.length +")")
					onSearchTextChange("");
					if($("#A_" + id).length>0){
						currExpandId = id;
						$("#A_" + currExpandId).parent().addClass("selected");
					}
					var topwindow = document.frames["rightFrame"];
					topwindow.reloadinfo(id,type);
			   }
			});
			}else{
				if(type=="add"){
					FormmodeUtil.writeCookie(FormModeConstant._CURRENT_EXPAND, id);
				}
				window.location.reload();
			}
			
		}
	</script>
</head>
  
<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
	<%@ include file="/formmode/setup/leftPartTemplate.jsp" %>
	
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
</html>
