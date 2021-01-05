
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
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
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<style type="text/css">
		.active{background-color:#A9A9A9!important;}
		
		/*--top start--*/
		.div_top{
			padding:40px 0px 50px 20px;
		}
		.div_top ul li{
			height:20px;
			line-height:20px;
		}
		.li_level2{
			padding-left:20px;
			cursor: pointer;
		}
		.li_level2:hover{
			background-color:#E5E5E5;
		}
		.selected{
			background-color:#A9A9A9!important;
		}
		.li_level1{
			background:url(images/libg0_wev8.png) no-repeat;
			padding-left:12px;
		}
		/*--top end--*/
		
		/*--center start--*/
		
		.div_center_head{
			display:block;
			height:25px;
			background-color:#E5E6E6;
			border-top:1px solid #E5E6E6;
		}
		.div_center_head ul{
			list_style:none;
		}
		.div_center_head li{
			width:66px;
			height:25px;
			line-height:25px;
			float:left;
			background-color:#E5E6E6;
			cursor:pointer;
		}
		.div_center_head a{display:block;text-align:center;height:25px;}
		/*--center end--*/
		
		.ui_selected{
			background-color:#FEFFFF!important;
		}
		
		.ui_icon td{
			text-align:center;
		}
		.x-layout-split{
			background-color:#eee !important;
		}
		.x-layout-cmini-west{
			background-color: #eee !important;
		}
	</style>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext-3.4.1/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext-3.4.1/ux/miframe_wev8.js"></script>
	<script>
	Ext.layout.BorderLayout.Region.prototype.onExpandClick = function(){
			this.panel.expand(false);
	}
	Ext.layout.BorderLayout.Region.prototype.onCollapseClick= function(){
			this.panel.collapse(false);
	}
	</script>
	<script type="text/javascript">
		$(document).ready(function () {
			var url = "/mobilemode/appuidesign.jsp";
			var leftUrl="/mobilemode/appComponentlistLeft.jsp?id=<%=appid%>";
			var viewport = new Ext.Viewport({
				layout: 'border',
				items: [{
					id: 'leftPanelModelTree',
					header:false,
					region:'west',
					xtype     :'iframepanel',
 					frameConfig: {
                    	id:'leftFrame', 
                    	name:'leftFrame', 
                    	frameborder:0 ,
                    	eventsFollowFrameLinks : false
					},
					width:225,
                	autoScroll:true,
                	collapsible: true,
                	split:true,
                	collapseMode:'mini',
                	border: false
				},{
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
			
			var leftFrame = document.getElementById("leftFrame");
			leftFrame.src = leftUrl;
		});
		
		var mobileModelDlg;
		function createMobileModel(){
			var operatelevel = <%=operatelevel%>;
			if(operatelevel < 1) return;
			var appid = "<%=appid%>";
			if(appid==""){
				alert("<%=SystemEnv.getHtmlLabelName(127501,user.getLanguage())%>"); //请先建一个移动应用!
				return;
			}
			mobileModelDlg = top.createTopDialog();//定义Dialog对象
			mobileModelDlg.Model = true;
			mobileModelDlg.Width = 750;//定义长度
			mobileModelDlg.Height = 550;
			mobileModelDlg.URL = "/mobilemode/appModelDesignTree.jsp?appid=<%=appid%>";
			mobileModelDlg.Title = "<%=SystemEnv.getHtmlLabelName(127502,user.getLanguage())%>"; //添加模块布局页面
			mobileModelDlg.checkDataChange=false;
			mobileModelDlg.show();
			mobileModelDlg.hookFn=function(result){
				leftFrame.MobileUI.refreshData();
			};
		}
		
		function createInitAppHomepage(id){
			mobileModelDlg = top.createTopDialog();//定义Dialog对象
			mobileModelDlg.Model = true;
			mobileModelDlg.Width = 900;//定义长度
			mobileModelDlg.Height = 600;
			if(typeof(id)=="undefined"){
				id="";
			}
			mobileModelDlg.URL = "/mobilemode/setup/templateChoose.jsp?appHomepageId="+id+"&type=1";
			mobileModelDlg.Title = "<%=SystemEnv.getHtmlLabelName(127503,user.getLanguage())%>"; //初始化页面
			mobileModelDlg.show();
			mobileModelDlg.onCloseCallbackFn=function(result){
				leftFrame.MobileUI.refreshData(true,result);
			};
		}
		
		function closeMobileModelDlg(){
			if(mobileModelDlg){
				mobileModelDlg.close();
			}
		}
		
		function refreshWithMobileAppModelCreated(){
			leftFrame.MobileUI.refreshData();
		}
		
		function refreshWithMobileAppModelDelete(){
			refreshWithMobileAppModelCreated();
			closeMobileModelDlg();
		}
		
		function createAppHomepage(id){
			var operatelevel = <%=operatelevel%>;
			if(operatelevel < 1) return;
			var appid = "<%=appid%>";
			if(appid==""){
				alert("<%=SystemEnv.getHtmlLabelName(127501,user.getLanguage())%>"); //请先建一个移动应用!
				return;
			}
			mobileModelDlg = top.createTopDialog();//定义Dialog对象
			mobileModelDlg.Model = true;
			mobileModelDlg.normalDialog = false;
			mobileModelDlg.Width = 500;//定义长度
			mobileModelDlg.Height = 250;
			if(typeof(id)=="undefined"){
				id="";
			}
			mobileModelDlg.URL = "/mobilemode/appHomepageCreate.jsp?appid=<%=appid%>&id="+id;
			mobileModelDlg.Title = "<%=SystemEnv.getHtmlLabelName(127493,user.getLanguage())%>"; //添加自定义页面
			mobileModelDlg.show();
			mobileModelDlg.hookFn=function(result){
				leftFrame.MobileUI.refreshData(true, result);
			};
		}
		
		function copyPage(id){
			mobileModelDlg = top.createTopDialog();//定义Dialog对象
			mobileModelDlg.Model = true;
			mobileModelDlg.Width = 400;//定义长度
			mobileModelDlg.Height = 130;
			mobileModelDlg.normalDialog = false;
			if(typeof(id)=="undefined"){
				return;
			}
			mobileModelDlg.URL = "/mobilemode/appHomepageCopy.jsp?appid=<%=appid%>&id="+id;
			mobileModelDlg.Title = "<%=SystemEnv.getHtmlLabelName(127504,user.getLanguage())%>"; //复制自定义页面
			mobileModelDlg.show();
			mobileModelDlg.hookFn=function(result){
				leftFrame.MobileUI.refreshData(true, result);
			};
		}
		
		function transformPage(id){
			mobileModelDlg = top.createTopDialog();//定义Dialog对象
			mobileModelDlg.Model = true;
			mobileModelDlg.Width = 330;//定义长度
			mobileModelDlg.Height = 200;
			mobileModelDlg.normalDialog = false;
			if(typeof(id)=="undefined"){
				return;
			}
			mobileModelDlg.URL = "/mobilemode/appHomepageTransform.jsp?id="+id;
			mobileModelDlg.Title = "<%=SystemEnv.getHtmlLabelName(127505,user.getLanguage())%>"; //转移自定义页面
			mobileModelDlg.show();
			mobileModelDlg.hookFn=function(result){
				leftFrame.MobileUI.refreshData(true, result);
			};
		}
		
		function writeMobilePrimaryComponent(type){
			var rightFrame = document.getElementById("rightFrame");
			var frameWin = rightFrame.contentWindow;
			if(frameWin && typeof(frameWin.writeMobilePrimaryComponent) == "function"){
				frameWin.writeMobilePrimaryComponent(type);
			}
		}
	</script>
</HEAD>
<body>
</body>
</html>