<%@page language="java" contentType="text/html; charset=UTF-8"%>
<html>  
<head>
	<title>e-cology后端管理中心</title>
	<meta http-equiv="Content-Type" Content="text/html; charset=UTF-8" />
	<link href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" rel="stylesheet" />
	<style type="text/css">
		.zd_btn_submit{
			height:25px;
			line-height:25px;
		}
		.zd_btn_cancle{
			border:0px;cursor:pointer;
			padding-left:10px;
			padding-right:10px;
			height:25px;
			line-height:25px;
		
			background-color:#558ED5;
			color:white;
		}
	</style>
	<link href="/css/ecology8/base_wev8.css" rel="stylesheet" />
	<link href="/css/ecology8/leftmenu_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/admincenter_wev8.css" type="text/css"></link>
	
	<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/jquery.easing_wev8.js"></script>    
	<script type="text/javascript" src="/js/ecology8/admincenter_wev8.js"></script> 
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>  
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>  
</head>
<body scroll=no>
	<table class="w-all h-all">
		<colgroup>
			<col width="190" />
			<col width="*" />
		</colgroup>
		<tr class="h-24" id="logoTR">
			<td colspan="2">
				<div class="h-24 colorbg000 colorfff p-t-5 p-l-20">
					<div class="left w-200 colorccc">泛微协同运营管控平台</div>
					<div class="right w-260">
						<img id="selectIcon" class="hand" src="/images/ecology8/images/select/ecology_wev8.png"></img>
						
						
						<!-- 这里是右上角菜单 -->
						<div class="cornerMenu absolute hide" id="selectContentDiv">
						
							<div class="selectItem hand" url="/wui/main.jsp" target="ecology">
								<div class="left p-t-5 p-l-6">
									<img src="/images/ecology8/images/select/e_wev8.png">
								</div>
								<div class="right w-151" style="text-align: left">
									<div class="font14 bold color000" style="padding-top:2px">e-cology前端</div>
									<div class="color666">	
										用户中心
									</div>
								</div>
								<div class="clear"></div>
							</div>
							
							<div class="selectItem hand" url="/middlecenter/index.jsp">
								<div class="left p-t-5 p-l-6"><img src="/images/ecology8/images/select/p_wev8.png"></div>
								<div class="right w-151" style="text-align: left">
									<div style="height: 1px"><img width="130" src="/images/ecology8/images/select/line_wev8.png"></div>
									<div class="font14 bold color000" style="padding-top:2px">e-cology中端</div>
									<div class="color666">	
										应用管理中心
									</div>
								</div>
								<div class="clear"></div>
							</div>
							
							<div class="selectItem hand" url="/admincenter/admincenter.jsp">
								<div class="left p-t-5 p-l-6"><img src="/images/ecology8/images/select/w_wev8.png"></div>
								<div class="right w-151" style="text-align: left">
									<div style="height: 1px"><img width="130" src="/images/ecology8/images/select/line_wev8.png"></div>
									<div class="font14 bold color000" style="padding-top:2px">e-cology后端</div>
									<div class="color666">	
										引擎管理中心
									</div>
								</div>
								<div class="clear"></div>
							</div>
						</div>
						
						<!-- 退出按钮 -->
						<img src="/images/ecology8/images/icon-exit_wev8.png" class="hand m-r-10 shortcutItem touming-8" onclick="window.location='/login/Logout.jsp'"  title="退出"/> 
					</div>	
				</div>			
			</td>
		</tr>
		<tr class="h-50" id="mainMenuTR">
			<td colspan="2">
				<div class="h-50" style="background:url('/images/ecology8/images/topbg_wev8.png') repeat-x">
					<table class="w-all h-all">
						<tr>
							<td class="w-160 colorfff font18 p-l-50" style="background:url('/images/ecology8/images/logo2_wev8.png') 5px center no-repeat">
								<div class="colorfff font15 bold">e-cology后端管理中心</div>
								<div class="coloreee font11">e-cology Admin Center</div>
								<!--
								<img src="/images/ecology8/images/logo_wev8.png" class="m-t-2 m-l-20"/>
								-->
							</td>
							<td class="relative" style="vertical-align:bottom;">
								<!-- 这是菜单的浮动层 -->
								<div id="divFloatItem" class="hide absolute h-60">
									<table class="w-all h-all">
										<tr>
											<td style="width:16px;background:url('/images/ecology8/images/tab_left_wev8.png') left bottom no-repeat;"></td>
											<td style="background:url('/images/ecology8/images/tab_center_wev8.png') bottom repeat-x;vertical-align:bottom;padding-bottom:12px;" class="center imgCenter"></td>
											<td style="width:16px;background:url('/images/ecology8/images/tab_right_wev8.png') right bottom no-repeat;"></td>
										</tr>
									</table>
									<div class="left" style="width:18px;"></div>
									<div class="left" style="width:21px;"></div>
									<div class="left" style="width:17px;"></div>
								</div>
								
								<!-- 以下是菜单 -->
								<!--WUC  -->
								<div tabname="  WUC  " class="left w-110 h-all hand toptabitem firstselected" target="WUC" >WUC</div>
								
								<!--流程引擎  -->
								<div tabname="流程引擎" class="left w-110 h-all hand toptabitem" target="flowEngine">流程引擎</div>
								
								<!--门户引擎  -->
								<div tabname="门户引擎" class="left w-110 h-all hand toptabitem" target="portalEngine">门户引擎</div>
								
								<!--内容引擎  -->
								<div tabname="内容引擎" class="left w-110 h-all hand toptabitem" target="contentEngine">内容引擎</div>
								
								<!--表单引擎  -->
								<div tabname="表单引擎" class="left w-110 h-all hand toptabitem" target="formEngine">表单引擎</div>

								<!--移动引擎  -->
								<div tabname="移动引擎" class="left w-110 h-all hand toptabitem" target="mobileEngine">移动引擎</div>
								
								<!--报表引擎 
								<div tabname="报表引擎" class="left w-110 h-all hand toptabitem" target="reportEngine">报表引擎</div> -->
								
								<!--集成平台  -->
								<div tabname="集成平台" class="left w-110 h-all hand toptabitem" target="combinePlat">集成平台</div>
								
								<!--开发平台 -->
								<div tabname="开发平台" class="left w-110 h-all hand toptabitem" target="devPlat">开发平台</div>
								
								<!--运维平台-->
								<div tabname="运维平台" class="left w-110 h-all hand toptabitem" target="maintainPlat">运维平台</div>
							</td>
						</tr>
					</table>
				</div>		
			</td>
		</tr>
		
		<tr class="h-35" style="background:url('/images/ecology8/images/navbg_wev8.png') repeat-x" id="submenuTr">
			<td class="relative" colspan="2" style="padding-bottom:0px;">
				<div id="selectedLeftMenu" class="color000 bold p-l-20 left h-35" style="width:190px;line-height:40px;font-size:10pt;background-position: right center;" >
				<!-- 这里是顶部二级菜单左侧的空白区域 -->
				</div>
				<div class="h-35 left" style="padding-bottom:0px;" >
					<!-- 顶部二级菜单区域 -->
					<div class="p-l-10 " style="padding-top:11px" id="submenusDiv" ></div>
				</div>		
			</td>
		</tr>
		
		<tr>
			<td colspan="2">
				<div id="ecologyMoudel" class="colorbgfff h-all">
					<table class="w-all h-all" id="ecologyMoudelContent">
						<tr>
							<td class="w-190" style="vertical-align:top;height:100%;overflow:hidden;border-right:#D8D8D8 1px solid;" width="190" id="leftmenuTD">
								<div id="leftMenu">
									<div id="drillmenu" class='w-all'>
									</div>
								</div>
							</td>
							<td style='background:#ffffff; vertical-align: top;'>
								<iframe id="mainFrame" style="margin:0;" name="mainFrame" src="" BORDER="0" FRAMEBORDER="no" NORESIZE="NORESIZE" height="100%" width="100%" scrolling="auto" ></iframe>
							</td>					
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
	<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<script type="text/javascript">
	jQuery(document).ready(function(){
		changeMainHeight();
	});
	function changeMainHeight(){
		if(jQuery.browser.msie && document.documentMode!=5)
			jQuery("#mainFrame").height(jQuery(window).height()-jQuery("#logoTR").height()-jQuery("#mainMenuTR").height()-jQuery("#submenuTr").height()-6);
		jQuery("#leftMenu").height(jQuery("#mainFrame").height());
		 $('#leftMenu').perfectScrollbar();
	}
	
	function changeMainFrameAppUrl(){
		var mainFrameWin = document.getElementById("mainFrame").contentWindow;
		var index = mainFrameWin.location.href.indexOf('/formmode/setup/main.jsp');
		if(index==-1){
			mainFrameWin.location.href = "/formmode/setup/main.jsp";
		}else{
			mainFrameWin.changeAppUrl();
		}
	}
</script>
</body>
</html>

