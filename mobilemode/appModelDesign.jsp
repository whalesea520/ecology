
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String appid=Util.null2String(request.getParameter("appid"));
int appId = Util.getIntValue(request.getParameter("modelId"), 0);
ModelInfoService modelInfoService = new ModelInfoService();
JSONArray modelInfoArr = modelInfoService.getModelInfoByAppIdWithJSON(appId);
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
	<script type="text/javascript" src="/formmode/js/leftPartTemplate_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/css/leftPartTemplate_wev8.css?v=2" />
	<style>
	html,body{
		height:100% ;
		padding: 8px 0;
		overflow: hidden;
	}
	* {font:12px Microsoft YaHei}
input,a:focus { outline: none; } 
#leftPart{
	height: 100%;
	width:200px;
	background-color: #fff;
	overflow: auto;
	position: relative;
	float:left;
	border-left: 1px solid #e5e5e5;
	border-right: 1px solid #e5e5e5;
	padding-top:18px;
}
.e8_left_top{
	top: 0px;
	left: 0px;
	padding: 0 12px 5px 12px;
}
.e8_left_top .e8_module_range{

	cursor: pointer;
}
.e8_searchTable{
	border-collapse:collapse;background-color:#eee;height:24px;width:100%;
}
.e8_searchText{
	width: 100%;
	border: 0px;;background-color:#eee;
}
.e8_searchText_tip{
	position: absolute;
	top: 4px;
	left: 5px;
	color: #ccc;
}
.e8_left_center{
	padding-bottom: 35px;
}
.e8_left_center .e8_title{
	padding: 0px 12px;
}
.e8_left_center .e8_title span{
	display: block;
	padding: 5px 0 7px 0;
	border-bottom: 1px solid #D3D3D3;
	font-size: 12px;
	font-weight: bold;
	color: #333;
	padding-left: 1px;
}
.e8_left_center ul{
	list-style: none;
	padding:0 0;
}
.e8_left_center ul li{
	padding: 0px 12px;
	cursor: pointer;
}
.e8_left_center ul li a{
	display: block;
	padding: 3px 0px;
	border-bottom: 0px solid #CFCFCF;
	padding-left: 8px;
	text-decoration: none;
	position: relative;
}
.e8_left_center ul li a .e8_data_label{
	color: #000;
}
.e8_left_center ul li a .e8_data_label2{
	color: #A8A8A8;
	font-size: 10px;
	line-height: 14px;
}
.e8_left_center ul li a .e8_data_subtablecount{
	background: url(/formmode/images/circleBg_wev8.png) no-repeat 1px 1px;
	font-size: 9px;
	font-style: italic;
	color: #333;
	width: 16px;
	/*
	float: right;
	*/
	position: absolute;
	top: 5px;
	right: 0px;
	padding-left: 4px;
}

.e8_left_center ul li:hover{
	background-color: #CFCFCF;
}
.e8_left_center ul li:hover a{
	border: 0;
	border-bottom-color: #CFCFCF;
}
.e8_left_center ul li:hover a .e8_data_label{
	
}
.e8_left_center ul li:hover a .e8_data_label2{
	
}
.e8_left_center ul li:hover a .e8_data_subtablecount{
}
.e8_left_center ul li.selected{
	background-color: #0072C6;
}
.e8_left_center ul li.selected a{
	border-bottom-color: #0072C6;
}
.e8_left_center ul li.selected a .e8_data_label{
	color: #fff;
}
.e8_left_center ul li.selected a .e8_data_label2{
	color: #60a7db;
}
.e8_left_center ul li.selected a .e8_data_subtablecount{
	background: url(/formmode/images/circleBgWhite_wev8.png) no-repeat 1px 1px;
	color: #fff;
}
.e8_left_center ul li.nodata a{
	border-bottom: none;
	color: #333;	
	padding: 6px 1px;
}
.e8_left_button{
		position: fixed ;
		padding-bottom: 5px;
		padding-left: 25px;
		width: 223px;
		bottom: 10px;
		padding-right: 5px;
		padding-top: 5px;
		left: 0px;
	}
	.e8_left_button span{
		color: #333;
		padding-bottom: 0px;
		padding-left: 2px;
		padding-right: 2px;
		padding-top: 0px;
	}
	.e8_left_button  A{
		color: #fff;
		padding-bottom: 0px;
		padding-left: 2px;
		padding-right: 2px;
		padding-top: 0px;
		color: #0072c6;
		text-decoration:underline
	}

.e8_paginationProxy{
	text-align: center;
}
.e8_paginationProxy span{
	display: inline-block;
	font-size: 10px;
	color: #666;
}
.e8_paginationProxy span.e8_pg_label{
	margin-right: 8px;	
}
.e8_paginationProxy span.e8_pg_jump{
	margin-right: 8px;	
	color: #1B80CA;
}
.e8_paginationProxy span.e8_pg_first,
.e8_paginationProxy span.e8_pg_prev,
.e8_paginationProxy span.e8_pg_next,
.e8_paginationProxy span.e8_pg_last{
	background-repeat: no-repeat;
	height: 12px;
	width: 12px;
	margin-bottom: -2px;
	margin-right: 3px;
	cursor: pointer;
}

.e8_paginationProxy span.e8_pg_first{
	background-image: url("/formmode/images/pg_first_wev8.png");
}
.e8_paginationProxy span.e8_pg_prev{
	background-image: url("/formmode/images/pg_prev_wev8.png");
}
.e8_paginationProxy span.e8_pg_next{
	background-image: url("/formmode/images/pg_next_wev8.png");
}
.e8_paginationProxy span.e8_pg_last{
	background-image: url("/formmode/images/pg_last_wev8.png");
}

.e8_paginationProxy span.e8_pg_first.disabled{
	background-image: url("/formmode/images/pg_first_disabled_wev8.png");
	cursor: text;
}
.e8_paginationProxy span.e8_pg_prev.disabled{
	background-image: url("/formmode/images/pg_prev_disabled_wev8.png");
	cursor: text;
}
.e8_paginationProxy span.e8_pg_next.disabled{
	background-image: url("/formmode/images/pg_next_disabled_wev8.png");
	cursor: text;
}
.e8_paginationProxy span.e8_pg_last.disabled{
	background-image: url("/formmode/images/pg_last_disabled_wev8.png");
	cursor: text;
}

.e8_module{
	position: absolute;
	top: 0px;
	right: 0px;
	width: 0px;
	height: 100%;
	background-color: #0072C6;
	overflow: hidden;
}
.e8_module .e8_module_title{
	padding: 0px 10px;
}
.e8_module .e8_module_title span{
	padding: 10px 0px 10px 28px;
	color: #F3F3F3;
	font-size: 17px;
	border-bottom: 0px solid #2587CE;
	display: block;
	background: url("/formmode/images/btnBackMetro_wev8.png") no-repeat;
	background-position: 0px 10px;
}

#rightPart{
	float:left;
	height:100%;
	width: 412px;
}

.clear{
	clear:both;
}

.x-layout-split{
	background-color:#eee !important;
	width:1px;
}
	</style>
	<script type="text/javascript">
		var datas = <%=modelInfoArr%>;
		var currentDatas;
		
		var currFormId = null;
		
		$(document).ready(function () {
			currFormId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_FORM, datas, "id");
			currPageIndex = FormmodeUtil.getLastIdPageIndex(currFormId,datas,"id",pageSize);
		
			
			var leftPanel = new Ext.Panel({
				header:false,
				contentEl: "leftPart",
				region: "west",
				width:200,
				border: false,
            	split:true,
            	collapsible: true,
           		collapsed : false
			});
			
			var url = "";
			//if(currFormId != null){
				url = "/mobilemode/appFormUIInit.jsp?modelid="+currFormId+"&appid=<%=appid%>"	
				
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
			
			initSearchText(doTextSearch);
			currentDatas = datas;
			doPagination(datas, pagedDataRender);
			$("#leftPart").show();
		});
		
		function doTextSearch(text){
			var srarchData;
			if(text == ""){
				srarchData = currentDatas;
			}else{
				srarchData = [];
				for(var i = 0; i < currentDatas.length; i++){
					if(currentDatas[i].entityname.toLowerCase().indexOf(text.toLowerCase()) != -1 || currentDatas[i].entitydesc.toLowerCase().indexOf(text.toLowerCase()) != -1){
						srarchData.push(currentDatas[i]);
					}
				}
			}
			doPagination(srarchData, pagedDataRender);
		}
		
		function changeRightFrameUrl(id){
			var AElement=$("#A_"+id);
			var $li = AElement.parent();
			$li.siblings().removeClass("selected");
			$li.addClass("selected");
			currFormId = id;
			FormmodeUtil.writeCookie(FormModeConstant._CURRENT_FORM, id);
			$("#rightFrame").attr("src", "/mobilemode/appFormUIInit.jsp?modelid="+id+"&appid=<%=appid%>");
		}
		
		function onPagedCallback(){
			if(currFormId != null){
				var $currForm = $("#A_" + currFormId);
				if($currForm.length > 0){
					$currForm.parent().addClass("selected");
				}
			}
		}
		
		function pagedDataRender(data){
			var entitydesc = data["entitydesc"];
			if(entitydesc==""){
				entitydesc = "<%=SystemEnv.getHtmlLabelName(82164,user.getLanguage())%>"; //无描述信息.
			}else if(entitydesc.length>30){
				entitydesc = entitydesc.substring(0, 25) + "...";
			}
			
			return "<a id=\"A_"+data["id"]+"\" href=\"javascript:void(0);\" onclick=\"javascript:changeRightFrameUrl('"+data["id"]+"');\">" +
						"<div class=\"e8_data_label\">"+data["entityname"]+"</div>" +
						"<div class=\"e8_data_label2\">"+entitydesc+"</div>" +
					"</a>";
		}
	</script>
</head>
  
<body>
<input type="hidden" id="currModelId"/>
<div style="height:100%;">
	<div id="leftPart" style="display: none;">
		<div class="e8_left_top">
			<table class="e8_searchTable">
				<tr>
					<td style="padding:0 0 0 5px;position: relative;"><input type="text" class="e8_searchText" value=""/><div class="e8_searchText_tip">Search...</div></td>
					<td width="18" style="padding:0px 2px 0 0;line-height:5px;"><img src="/formmode/images/btnSearch_wev8.png" /></td>
				</tr>
			</table>
		</div>
		
		<div class="e8_left_center">
			<div class="e8_title">
				<span></span>
			</div>
			<ul>
			</ul>
		</div>
		
		<div class="e8_left_button" id="pagination" style=""></div>
		
		<div class="e8_module">
			<div class="e8_module_title">
				<span><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%><!-- 应用 --></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>
