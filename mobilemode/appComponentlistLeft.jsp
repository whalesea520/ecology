<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.scriptlib.Function"%>
<%@page import="com.weaver.formmodel.mobile.scriptlib.ScriptLibHandler"%>
<%@page import="com.weaver.formmodel.mobile.mpc.model.MPCConfig"%>
<%@page import="com.weaver.formmodel.mobile.mpc.MPCManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String appid=Util.null2String(request.getParameter("id"));
int subCompanyId=-1;
if(mmdetachable.equals("1")){
	subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
    if(subCompanyId == -1){
        subCompanyId = user.getUserSubCompany1();
    }
}
int operatelevel = getCheckRightSubCompanyParam("MobileModeSet:All",user,mmdetachable ,subCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读

%>
<HTML><HEAD>

	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ux/miframe_wev8.js"></script>
	<!-- scroll plugin -->
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
	
	<style type="text/css">
		.active{background-color:#A9A9A9!important;}
		
		/*--top start--*/
		.div_top{
			padding:0px 10px 0px 10px;
		}
		/*--top end--*/
		.ui_selected{
			background-color:#FEFFFF!important;
		}
		
		.ui_icon td{
			text-align:center;
		}
		
		.x-layout-split{
			background-color:#eee !important;
		}
		
		.x-tab-panel-header{
			background-color:#eee !important;
			border-bottom:0px !important;
			padding-bottom:0px !important;
		}
		.x-tab-strip-top{
			background-color:#eee !important;
			background-image:none !important;
			border-bottom:0px !important;
		}
		.x-tab-strip-top .x-tab-left{
			background-image:none !important;
		}
		.x-tab-strip-top .x-tab-right{
			background-image:none !important;
		}
		.x-tab-strip-top .x-tab-strip-inner{
			background-image:none !important;
		}
		.x-tab-strip-top .x-tab-strip-active{
			background-color:#FEFFFF !important;
		}
	.mobile_component{
		padding-top:10px;
	}
	.mobile_component ul{
		list-style: none;
	}
	.mobile_component ul li{
		padding: 2px 18px;
		cursor: pointer;
		border-bottom: 0px solid #ddd;
	}
	.mobile_component ul li a{
		text-decoration: none !important;
	}
	.mobile_component ul li .e8_data_label{
		color: #000;
		font-size: 12px;
	}
	.mobile_component ul li .e8_data_label2{
		color: #aaa;
		font-size: 11px;
		line-height: 14px;
	}
	.mobile_component ul li .e8_data_subtablecount{
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
	
	.mobile_component ul li:hover{
		background-color: #eee;
	}
	.mobile_component ul li:hover a{
		border-bottom-color: #ddd;
	}
	.mobile_component ul li:hover .e8_data_label{
		
	}
	.mobile_component ul li:hover .e8_data_label2{
		
	}
	.mobile_component ul li:hover .e8_data_subtablecount{
	}
	.mobile_component ul li.selected{
		
		background-color: #ddd;
	}
	.mobile_component ul li.selected a{
		border-bottom-color: #;
	}
	.mobile_component ul li.selected .e8_data_label{
		color: ;
	}
	.mobile_component ul li.selected .e8_data_label2{
		color: #999;
	}
	.mobile_component ul li.selected .e8_data_subtablecount{
		background: url(/formmode/images/circleBgWhite_wev8.png) no-repeat 1px 1px;
		color: #fff;
	}
	.mobile_component ul li.nodata a{
		border-bottom: none;
		color: #333;	
		padding: 6px 1px;
	}
	</style>
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		
		.e8_module_tree{
			padding: 7px 0px 0px 0px;
			margin: 0px;
		}
		.e8_module_tree li{
			padding: 1px 0px 1px 0px;
		}
		.e8_module_tree li a{
			text-decoration: none !important;
		}
		.e8_module_tree li a.curSelectedNode{
			height: 17px;
			padding-top: 1px;
			border: none;
			background-color: transparent;
		}
		.e8_module_tree li a span{
			color: #333;
		}
		.e8_module_tree li ul{
			padding-left: 0px;
		}
		.e8_module_tree li ul.level1{
			margin-left: -14px;
		} 
		.e8_module_tree li ul.level2{
			margin-left: -28px;
		} 
		.e8_module_tree li.level1 {
			padding-left: 14px;
		}
		.e8_module_tree li.level2 {
			padding-left: 28px;
		}
		.e8_module_tree li.level3 {
			padding-left: 42px;
		}
		.e8_module_tree li:hover{
			background:url("/formmode/images/ztree_over_bg_wev8.png") repeat-x;	
		}
		.e8_module_tree li:hover a span{
			color: #333;
		}
		.e8_module_tree li.noover{
			background: none;
		}
		.e8_module_tree li.ztreeNodeBgColor{
			/*background:url("/formmode/images/ztree_select_bg_wev8.png") repeat-x;*/	
		}
		.e8_module_tree li.ztreeNodeBgColor>a span{
			color: #0072c6;
			font-weight: bold;
		}
		.e8_module_tree li span.noline_docu.button,
		.e8_module_tree li span.noline_close.button,
		.e8_module_tree li span.noline_open.button{
			margin-left: 5px;
		}
		.e8_module_tree li span.noline_close.button{
			background: url("/formmode/images/arrow_right_wev8.png") no-repeat center !important;
		}
		.e8_module_tree li span.noline_open.button{
			background: url("/formmode/images/arrow_right_wev8.png") no-repeat center !important;
		}

.x-tab-panel-header{
	border-bottom: 1px solid #ccc;
;
}
ul.x-tab-strip-top{
	border-bottom: 1px solid #ccc !important;
	padding-left: 5px;

}
.x-tab-strip-active .x-tab-right{
	border-top: 1px solid #ccc;
	border-left: 1px solid #ccc;
	border-right: 1px solid #ccc;
	border-bottom: 1px solid #fff !important;
}
.x-tab-strip-active SPAN.x-tab-strip-text{
	color: #0072c6;
}

.x-panel-noborder .x-panel-tbar-noborder .x-toolbar{
	border-bottom: 1px solid #ccc;
}
.x-toolbar {
	background-image: none;
	background-color: #fff;
	border: 0;
}
.x-btn-text-icon .x-btn-center .x-btn-text{
	font-family: 'Microsoft YaHei', Arial;
}
.add{
	background-image: url("/mobilemode/images/treeNodeAdd_wev8.png");
	color: #333;
	font: 11px Microsoft YaHei !important;
}
.homepage{
	background-image: url("/mobilemode/images/treeNodeAdd_wev8.png");
	color: #333;
	font: 11px Microsoft YaHei !important;
}
.x-btn-text.disabled{color:#999;cursor:not-allowed;}
.mpc_disabled{
	opacity: 0.4;	
	filter:alpha(opacity=40);
}
#fn_search{
	padding: 8px 10px 3px 10px;
	background-color:#fff; 
	position: absolute;
	top:0px;
	left:0px;
	width: 100%;
	display: none;
	box-sizing:border-box;
	z-index: 200;
	-moz-box-sizing:border-box; /* Firefox */
	-webkit-box-sizing:border-box; /* Safari */	
}
#fn_search input{
	height: 24px;
	width:100%;
	border: 1px solid #ddd;
	background: url("/mobilemode/browser/images/search.png") no-repeat;
	background-size: 16px 16px; 
	background-position: 3px center;
	padding-left: 22px;
	box-sizing:border-box;
	-moz-box-sizing:border-box; /* Firefox */
	-webkit-box-sizing:border-box; /* Safari */
}
#fn_ul{
	padding-top: 35px;
	height: 100%;
	box-sizing:border-box;
	-moz-box-sizing:border-box; /* Firefox */
	-webkit-box-sizing:border-box; /* Safari */
}
#fn_ul li{
	padding: 2px 10px; 
	border-bottom: 1px dotted #eee;
}
#fn_ul li.fselected{
	padding-left: 5px;
	border-left: 5px solid #2c2c2a;
	background-color: #eee;
}
#fn_ul.forChrome li .e8_data_label2{
	-webkit-transform: scale(0.92);
	-webkit-transform-origin-x: 0;
}
li.unMatch{
	display: none;
}
	</style>
	<script type="text/javascript">
		var prevSearchKey = null;
		var $fnScroll = null;
		var southPanel = null;
		$(document).ready(function () {
			var northPanel = new Ext.Panel({
				region: "north",
				height: 5,
				border: false,
				contentEl: "div_north",
				bodyStyle: "background-color:#eee;"
			});
			var centerPanel = new Ext.TabPanel({
				region: "center",
	            width:225,
	            border: false,
            	split:true,
	            activeTab:0,//当前激活标签
	            frame:true,
	            items:[{
                      title:"Mobile UI",
                      xtype     :'iframepanel',
	 				  frameConfig: {
                    	  id:'MobileUI',
                    	  name:'MobileUI', 
                    	  frameborder:0 ,
                    	  eventsFollowFrameLinks : false
					  },
		              autoScroll: true,
                      closable:false,
                      bodyStyle: "background-color:#fff;",
                      tbar:[{
				            text:'<%=SystemEnv.getHtmlLabelName(127492,user.getLanguage())%>', //添加模块
				            tooltip:'<%=SystemEnv.getHtmlLabelName(127492,user.getLanguage())%>', //添加模块
				            iconCls:'add <%if(operatelevel < 1){%>disabled<%}%>',
				            handler: function(){window.parent.createMobileModel();}
				        },{
				            text:'<%=SystemEnv.getHtmlLabelName(127493,user.getLanguage())%>', //添加自定义页面
				            tooltip:'<%=SystemEnv.getHtmlLabelName(127493,user.getLanguage())%>', //添加自定义页面
				            iconCls:'homepage <%if(operatelevel < 1){%>disabled<%}%>',
				            handler: function(){window.parent.createAppHomepage();}
				        }]
	            }]
			});
			southPanel=new Ext.TabPanel({
	            region: "south",
	            width:225,
	            height: 300,
	            border: false,
            	split:true,
	            activeTab:0,//当前激活标签
	            frame:true,
	            items:[{
	            	  id:"uiid",
                      contentEl:"div_center_ui",//标签页的页面元素id(加入你想显示的话)
                      title:"<%=SystemEnv.getHtmlLabelName(127494,user.getLanguage())%>", //e-mobile原生控件
		              autoScroll: true,
                      closable:false//是否现实关闭按钮,默认为false
	            },{
	            	  id:"codeid",
                      contentEl:"div_center_code",//标签页的页面元素id(加入你想显示的话)
                      title:"<%=SystemEnv.getHtmlLabelName(127495,user.getLanguage())%>", //脚本
                      closable:false//是否现实关闭按钮,默认为false
                      ,listeners:{
						'activate':function(){
							$("#fn_search").show();
							
							var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1 
							if(isChrome){
								$("#fn_ul").addClass("forChrome");
							}
							
							if(!$fnScroll){
								$fnScroll = $("#fn_ul").niceScroll({
									cursorcolor:"#aaa",
									cursorwidth:3
								});
							}
						}
					  }
	            }]
	            ,listeners:{
					'resize':function(){
						setTimeout(function(){
							if($fnScroll){	//触发resize矫正滚动条
								$fnScroll.resize();
							}
						}, 200);
						
					}
				}
	            
     		});
			
			var viewport = new Ext.Viewport({
				layout: 'border',
				items: [northPanel, centerPanel, southPanel]
			});
			
			var MobileUI = document.getElementById("MobileUI");
			MobileUI.src = "/mobilemode/appFormUIList.jsp?id=<%=appid%>";
			
			$("#searchKey").keyup(function(){
				var currSearchKey = this.value;
				if(currSearchKey != prevSearchKey){
					prevSearchKey = currSearchKey;
					
					$("#fn_ul li").removeClass("fselected");
					
					$("#fn_ul li").each(function(){
						var e8_data_label = $(".e8_data_label", this).text();
						var e8_data_label2 = $(".e8_data_label2", this).text();
						
						if(e8_data_label.toLowerCase().indexOf(currSearchKey.toLowerCase()) == -1
							&& e8_data_label2.toLowerCase().indexOf(currSearchKey.toLowerCase()) == -1){
							$(this).addClass("unMatch");	
						}else{
							$(this).removeClass("unMatch");
						}
					});
					
					if($fnScroll){	//触发resize矫正滚动条
						$fnScroll.resize();
					}
				}
			});
			
		});
	</script>
</HEAD>
<body>
	<div id="div_north" style=""></div>
	<div id="div_center_ui" class="mobile_component">
		<ul>
			<!-- Mobile Primary Component -->
			<%
				List<MPCConfig> mpcConfigList = MPCManager.readMPCConfigs();
				for(int i = 0; i < mpcConfigList.size(); i++){
					MPCConfig mpcConfig = mpcConfigList.get(i);
					String mpcDisabledClass = "";
					String mpcClickStr = "javascript:writeMobilePrimaryComponent('"+mpcConfig.getType()+"');";
					if("0".equals(mpcConfig.getIsEnabled())){
						mpcDisabledClass = "mpc_disabled";
						mpcClickStr = "javascript:void(0);";
					}
			%>
				<li id="MPC_<%=mpcConfig.getType()%>" class="<%=mpcDisabledClass%>">
					<a onclick="<%=mpcClickStr %>" href="javascript:void(0);">
					<table>
						<tr>
							<td style="padding-right:8px;"><img src="<%=mpcConfig.getIcon()%>" width=28 /></td>
							<td valign="top">
								<div class="e8_data_label"><%=mpcConfig.getText()%></div>
								<div class="e8_data_label2"><%=mpcConfig.getDesc()%></div>
							</td>
						</tr>
					</table>
					</a>
				</li>
			<% } %>
		</ul>
	</div>
	<script type="text/javascript">
		function writeMobilePrimaryComponent(type){
			parent.writeMobilePrimaryComponent(type);
		}
	</script>
	
	<div id="div_center_code" class="mobile_component" style="height:100%;padding-top: 0px;">
		<div id="fn_search">
			<input id="searchKey" type="text" placeholder="<%=SystemEnv.getHtmlLabelName(127496,user.getLanguage())%>"/>  <!-- 搜索脚本 -->
		</div>
		<ul id="fn_ul">
			<li onclick="javascript:openVarDescDialog(this);">
				<table>
					<tr>
						<td valign="top">
							<div class="e8_data_label" style="font-size: 12px;"><%=SystemEnv.getHtmlLabelName(127744,user.getLanguage())%><!-- 变量和参数 --></div>
							<div class="e8_data_label2" style="line-height: 16px;"><%=SystemEnv.getHtmlLabelName(127745,user.getLanguage())%><!-- 系统内置了一些系统变量和一些参数快捷获取方式，点击查看 --></div>
						</td>
					</tr>
				</table>
			</li>
			<li onclick="javascript:openVarparserDialog(this);">
				<table>
					<tr>
						<td valign="top">
							<div class="e8_data_label" style="font-size: 12px;"><%=SystemEnv.getHtmlLabelName(127746,user.getLanguage())%><!-- 后台解析方法 --></div>
							<div class="e8_data_label2" style="line-height: 16px;"><%=SystemEnv.getHtmlLabelName(127747,user.getLanguage())%><!-- 以字符串的形式嵌入调用，运行时会用方法返回值替换掉方法调用 --></div>
						</td>
					</tr>
				</table>
			</li>
			<%
				ScriptLibHandler scriptLibHandler = ScriptLibHandler.getInstance();
				List<Function> functions = scriptLibHandler.loadFunction();
				
				for(int i = 0; i < functions.size(); i++){
					Function function = functions.get(i);
					String text = function.getSign();
					if(text.indexOf("(") != -1){
						text = text.substring(0, text.indexOf("("));
						text = text + "()";
					}
			%>
				<li onclick="javascript:openJSCodeDialog('<%=function.getId() %>','<%=Util.formatMultiLang(function.getText())%>', this);">
					<table>
					<tr>
						<td valign="top">
							<div class="e8_data_label" style="font-size: 12px;"><%=text %></div>
							<div class="e8_data_label2" style="line-height: 16px;"><%=Util.formatMultiLang(function.getDesc()) %></div>
						</td>
					</tr>
					</table>
				</li>
			<%	} %>
			
		</ul>
	</div>
	
	<script type="text/javascript">
		function openJSCodeDialog(fid, text, eleObj){
			if(!$(eleObj).hasClass("fselected")){
				$(eleObj).parent().children(".fselected").removeClass("fselected");
				$(eleObj).addClass("fselected");
			}
			
			
			var dlg = top.createTopDialog();//获取Dialog对象
			dlg.Model = true;
			dlg.Width = 600;//定义长度
			dlg.Height = 600;
			dlg.URL = "/mobilemode/jscodedesc.jsp?fid="+fid;
			dlg.Title = "<%=SystemEnv.getHtmlLabelName(127499,user.getLanguage())%>" + text; //脚本：
			dlg.show();
			
		}
		function openVarparserDialog(eleObj){
			if(!$(eleObj).hasClass("fselected")){
				$(eleObj).parent().children(".fselected").removeClass("fselected");
				$(eleObj).addClass("fselected");
			}
			
			var dlg = top.createTopDialog();//获取Dialog对象
			dlg.Model = true;
			dlg.Width = 600;//定义长度
			dlg.Height = 600;
			dlg.URL = "/mobilemode/setup/varparserdoc.jsp";
			dlg.Title = "<%=SystemEnv.getHtmlLabelName(127750,user.getLanguage())%>";  //后台解析方法 使用文档
			dlg.show();
			
		}
		function openVarDescDialog(eleObj){
			if(!$(eleObj).hasClass("fselected")){
				$(eleObj).parent().children(".fselected").removeClass("fselected");
				$(eleObj).addClass("fselected");
			}
			
			var dlg = top.createTopDialog();//获取Dialog对象
			dlg.Model = true;
			dlg.Width = 726;//定义长度
			dlg.Height = 600;
			dlg.URL = "/mobilemode/setup/vardesc.jsp";
			dlg.Title = "<%=SystemEnv.getHtmlLabelName(127749,user.getLanguage())%>";  //变量和参数 使用文档
			dlg.show();
			
		}
	</script>
 </body>
</html>