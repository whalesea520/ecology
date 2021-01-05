<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*,HT.HTSrvAPI,java.math.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@page import="weaver.social.service.SocialIMService"%>
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />



<%@ include file="/wui/common/page/initWui.jsp" %>

<%
//判断密码强制修改
String changepwd = (String)request.getSession().getAttribute("changepwd");
if("n".equals(changepwd)){
	request.getSession().removeAttribute("changepwd");
	response.sendRedirect("/login/Login.jsp");
	return;
}else if("y".equals(changepwd)){
	request.getSession().removeAttribute("changepwd");
}


/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String initsrcpage = "" ;
String gopage = Util.null2String(request.getParameter("gopage"));
String frompage = Util.null2String(request.getParameter("frompage"));
int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
String logintype = Util.null2String(user.getLogintype()) ;

if(targetid == 0) {
	if(!logintype.equals("2")){
		//initsrcpage="/workspace/WorkSpace.jsp";
        initsrcpage="";
	}else{
		initsrcpage="";
	}
}
if(!gopage.equals("")){
	gopage=URLDecoder.decode(gopage);
	if(!"".equals(frompage)){
		//System.out.println(frompage);
		initsrcpage = gopage+"&message=1&id="+user.getUID();
	}else{
		initsrcpage = gopage;
	}
}
else {
	String username = user.getUsername() ;
	String userid = ""+user.getUID() ;
	if(logintype.equals("2")){
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=1" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=2" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/org/OrgChart.jsp?charttype=F" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/catalog/LgcCatalogsView.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/data/ViewCustomer.jsp?CustomerID="+userid ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/search/SearchOperation.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/request/RequestView.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/CptMaintenance.jsp" ;
				break ;

		}
	}else{
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/report/DocRp.jsp" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/hrm/report/HrmRp.jsp" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/fna/report/FnaReport.jsp" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/report/LgcRp.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/CRMReport.jsp" ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/ProjReport.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/WFReport.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/report/CptRp.jsp" ;
				break ;

		}
	}
}
/**
 * 系统主题、皮肤
 */
String pslSkinfolder = "";

String curTheme = "";

curTheme = getCurrWuiConfig(session, user, "theme");
pslSkinfolder = getCurrWuiConfig(session, user, "skin");
String ely6flg = "";
if ("ecology6".equals(curTheme.toLowerCase())) {
	curTheme = "ecology7";
	ely6flg = "ecology6";
}

request.setAttribute("REQUEST_SKIN_FOLDER", pslSkinfolder);

Map pageConfigKv = getPageConfigInfo(session, user);

String logo = (String)pageConfigKv.get("logoTop");
if(!"".equals(logo)&&!"null".equals(logo)&&!logo.startsWith("/")){
	logo = "/weaver/weaver.file.FileDownload?fileid="+logo;
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title></title>
		<!--For Base-->
		<link rel="stylesheet" type="text/css" href="/wui/common/css/base_wev8.css" />
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>

		 <!--[if IE 6]>
			<script type='text/javascript' src='/wui/common/jquery/plugin/8a-min_wev8.js'></script>
		<![endif]-->
		 <!--[if IE 6]>	
			<script languange="javascript">
				DD_belatedPNG.fix('.menuItemIcon,#divFloatBg,.menuNavSpan_Expand,.menuNavSpan_Contraction,.toolbarSplitLine,#navTd span,.divFloatLeftmenu div,#leftBlockHrmInfoCenter,#topBlockHiddenContr,#leftBlockHiddenContr,.leftBlockTopBgLeft,.leftBlockHrmInfoLeft,.leftBlockHrmInfoRight,.leftMenuBottomLeft,.leftMenuBottomRight,.versiontype,#tblHrmToolbr span,.tbItm,#toolbarMoreBlockTop,.searchBlockBgDiv,#sign_dispan,.topBlockDateBlock,.toolbarTopRight,background');
				DD_belatedPNG.fix('#logo');
			</script>  
			<STYLE TYPE="text/css">
				html {filter:expression(document.execCommand("BackgroundImageCache", false, true));}
			</style>

		<![endif]-->

        <STYLE TYPE="text/css">
            
            body{
                 margin: 0px; 
                /*可以被动态更改的值*/
                /*background:url('images/body-bg_wev8.png') repeat-y;*/
                font-size: 9pt;font-family: verdana;
                overflow-y:hidden;
            }
            TABLE {
			    FONT-SIZE: 9pt; FONT-FAMILY: Verdana
			}
            .xTable_message{
			    border:1px solid #8888AA;
			    background:white;
			    position:absolute;
			    padding:5px;
			    z-index:100;
			    display:none;
			    FONT-SIZE: 9pt; 
			    MARGIN: 0px; 
			    FONT-FAMILY: Verdana; 
			    LIST-STYLE-TYPE: circle; 
            }   
            
            table td{
                padding:0px;
            }
            #container{
                width:100%;height:100%;    /*border-collapse:collapse;*/
            }
            #head{
                WIDTH:100%;height:70px;
                background:url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/head-bg_wev8.jpg') no-repeat;
                /*background:url('images/head-bg_wev8.png') no-repeat;*/
                 /*border-collapse:collapse;*/
            }
            


            #contentContainer{
                width:100%;height:100%;
                 /*border-collapse:collapse;*/
            }
            #contentContainer #content{
                width:100%;height:100%;
                /*border-collapse:collapse;*/
            }

            #leftmenucontainer{
                height:100%;
            }
            #footer{

            }

            #shadown-corner{
                background:url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/shadown-coner_wev8.png') no-repeat; width:10px;height:10px;
            }
            #shadown-x{
                background:url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/shadown-x_wev8.png') repeat-x; height:10px;
            }
            #shadown-y{
                background:url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/shadown-y_wev8.png') repeat-y; width:10px;
            }
            #shadown-content{background:#fff;}
            
            
            /*可更改区域  左侧菜单*/
            /*左侧菜单下*/
            #leftmenucontainer{}
            /*左侧菜单上*/
            #leftmenucontainer-top{
                height:10px;
            }

            #leftmenu-top{
                height:86px;
            } 
            #leftmenu-bottom{
                
                height:250px;                
            }
            #leftmenu-bottom-bottom{
                height:7px;
            }
			#leftmenu-bottom {
				position:absolute;
				width:128;
				height:0px;
				z-index:0;
			}
			
			
			#leftBlockTd {
				background:none;
				height: 100%;
			}
			.leftBlockTopBgLeft {
				overflow:hidden;width:10px;position:absolute;left:0;top:0;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftBlockTopBgLeft_wev8.jpg) no-repeat;height:10px;
			}
			#leftBlockTopBgCenter {
				overflow:hidden;position:absolute;left:10px;right:2px;top:0;height:10px;
			}
			.leftBlockTopBgRight {
				overflow:hidden;position:absolute;right:-2;top:0;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftBlockTopBgRight_wev8.jpg) no-repeat;height:10px;width:2px;
			}
			
			#leftmenu-top {
				position:absolute;width:128;height:87px;
			}
			
			.leftBlockHrmInfoLeft {
				width:60px;position:absolute;left:0;top:0;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftBlockHrmInfoBgLeft_wev8.png) no-repeat;height:87px;
			}
			
			.leftBlockHrmInfoCenter {
				position:absolute;left:60px;right:6px;top:0;height:87px;width:60px;
			}
			
			.leftBlockHrmInfoRight {
				position:absolute;right:0;top:0;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftBlockHrmInfoBgRight_wev8.png) no-repeat;height:87px;width:6px;
			}
			#leftBlock_HrmDiv {
				position:relative;top:0px;height:86px;
			}
			
			#leftmenu-bottom-bottom {
				width:128px;position:relative;top:0px;
			}
			.leftMenuBottomLeft {
				width:5px;position:absolute;left:0;top:0;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftMenuBottomLeft_wev8.png) no-repeat;height:7px;
			}
			#leftMenuBottomCenter {
				position:absolute;left:5px;right:6px;top:0;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftMenuBottomCenter_wev8.png) repeat-x;height:7px;
			}
			
			.leftMenuBottomRight {
				position:absolute;right:0;top:0;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftMenuBottomRight_wev8.png) no-repeat;height:7px;width:6px;
			}
			
			#topBlockHiddenContr {
				width:502px;height:20px;position:relative;margin-bottom:-12px;cursor:pointer;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/topBlockContraction_wev8.png) no-repeat;background-position:0px 25px;
			}
			#leftBlockHiddenContr {
				height:502px;width:12px;position:relative;margin-right:-12px;cursor:pointer;background:url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/leftBlockContraction_wev8.png) no-repeat;overflow:hidden;background-position:25px 0px;
			}
			.versiontype { 
				position:absolute;left:150;top:40;
				/*background:url(/wui/theme/ecology7/page/images/versiontype_wev8.png) no-repeat;height:10px;width:33px;display:block;overflow:hidden;*/
			}
			#mainFrame {
				height:100%!important;
			}
			/*IE6 fixed*/
			

        </STYLE>
		
		<script type="text/javascript">
		window.onresize = function winResize() {
			if (jQuery("#mainBody").width() <= 1024 ) {
				jQuery("#container").css("width", "1020px");
			} else {
				jQuery("#container").css("width", jQuery("#mainBody").width() - 4);
			}
		}
		var common = new MFCommon();
		var uid = "<%=String.valueOf(user.getUID())%>";
		var isAdmin = "<%=String.valueOf(user.isAdmin())%>";
		function checkUserOffline(){
			var result = "";
			try{
				result = common.ajax("cmd=isOffline&uid="+uid);
			}catch(e){}
			if(result === "-1" || result === "0"){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81908,user.getLanguage())%>", function(){
					window.location = '/login/Login.jsp';
				});
				return;
			}
			setTimeout("checkUserOffline()",3000);
		}
		jQuery(document).ready(function(){
			//if(isAdmin === "false") checkUserOffline();
		    jQuery("#mainBody").css("background","url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y");
		});
		//background:url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y;
		</script>
    </head>
        
    
<!-- 锁定整个界面的CSS2011/5/19 -->

    <body id="mainBody" scroll="no"  style="">
			
			<%if(SocialIMService.isOpenIM()){%>
				<jsp:include page="/social/im/SocialIMInclude.jsp"></jsp:include>
			<%}%>
			
			<!-- 签到签退用div -->
            <div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none;' valign='top'></div>            
            <div id='message_Div' style='display:none;'></div>    
            <table id="container"  height="70px" cellspacing="0" cellpadding="0">
                <!--上-->
                <tr id="mainTopBlockTr"><td  height="70px" valign="top"> 
                    <table id="head" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="270px">
                            	<div style="height:70px;overflow:hidden;">
                                	<!-- main功能插件 -->
                                	<jsp:include page="/wui/common/page/mainPlugins.jsp"></jsp:include>
                                </div>
                            </td>
                            <td width="*" class="center" align="center" style="position:relative;z-index:1;">
                                <!--放置菜单区域-->
                                <jsp:include page="/wui/theme/ecology7/page/top.jsp"></jsp:include>
								
                            </td>
                            <td width="300px">
                                <!--放置搜索按钮框-->
                                
                                <!--放常用按钮区域-->
                                <jsp:include page="/wui/theme/ecology7/page/toolbar.jsp"></jsp:include>
                            </td>
                        </tr>
                        </table>  
                </td></tr>
                <!--中-->
                <tr height="auto"><td valign="top">
                    <table id="contentcontainer" height="100%" width="100%">
                        <tr height="auto">
                            <td  width="5px"></td>
                            <td  width="*">
                                <table id="content" height="100%" width="100%">
                                <tr>
                                    <td  width="126px" id="leftBlockTd" valign="top">
										
                                        <!--放置左侧菜单区-->
                                        <div  id="leftmenucontainer"  style="width:100%;overflow:hidden;"> 
                                            <div id="leftmenucontainer-top" style="position:relative;left:-1;">
                                            	<div class="leftBlockTopBgLeft"></div>
                                   				<div id="leftBlockTopBgCenter"></div>
                                   				<div class="leftBlockTopBgRight"></div>
                                            </div>
                                            <div style="padding-left:10px;margin-top:5px;">
                                                <table width="100%"  cellpadding="0px" cellspacing="0px">
                                                    <tr><td height="86px">
                                                    	<table width="100%"  cellpadding="0px" cellspacing="0px">
                                                    		<tr>
                                                    			<td style="position:relative;">
                                                    				<div id="leftmenu-top" style="">
                                                    					<div class="leftBlockHrmInfoLeft"></div>
                                                        				<div id="leftBlockHrmInfoCenter" class="leftBlockHrmInfoCenter"></div>
                                                        				<div class="leftBlockHrmInfoRight"></div>
                                                    				</div>
                                                    				<div id="leftBlock_HrmDiv">
	                                                    				<!--放置即时通讯相关的东西-->
	                                                        			<jsp:include page="/wui/theme/ecology7/page/hrmInfo.jsp"></jsp:include>
                                                        			</div>
                                                    			</td>
                                                    		</tr>
                                                    	</table>
                                                        
                                                    </td></tr>
                                                    <tr><td style="position:relative;vertical-align: top;">
                                                    	<div id="leftmenu-bottom"></div>
                                                        <!--放置左侧菜单区-->
                                                        <div style="position:relative;top:0px;">
															
                                                        	<jsp:include page="/wui/theme/ecology7/page/left.jsp"></jsp:include> 
															
                                                        </div>
                                                        <div id="leftmenu-bottom-bottom">
                                                        	<div class="leftMenuBottomLeft"></div>
                                                        	<div id="leftMenuBottomCenter"></div>
                                                        	<div class="leftMenuBottomRight"></div>
                                                        </div>
                                                    </td></tr>
                                                </table>
                                            </div>
                                        </div>
                                        
                                    </td>
                                    <td  width="*">
                                        <TABLE width="100%" height="100%" cellpadding="0px" cellspacing="0px">
                                        <TR>
                                            <TD id="shadown-corner"></TD>
                                            <TD width="*"  id="shadown-x">
                                            	<!-- 顶部菜单隐藏用block -->
                                            	<TABLE  width="100%" height="100%" cellpadding="0px" cellspacing="0px"><TR><TD align="center">
                                            		<table border="0" width="502px" height="5px" align="center" cellpadding="0px" cellspacing="0px"><tr><td style="position:relative;width:502px;">
   														<div id="topBlockHiddenContr">
		                                            	</div>
        										</td></tr></table></TD></TR></TABLE>
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD id="shadown-y" align="center">
                                            	<!-- 左侧菜单隐藏用block -->
                                            	<TABLE width="100%" height="100%" cellpadding="0px" cellspacing="0px"><TR><TD align="center">
                                            		<table border="0" width="100%" height="502px" width="0" align="center" cellpadding="0px" cellspacing="0px"><tr><td style="position:relative;">
   														<div id="leftBlockHiddenContr">
		                                            	</div>
        										</td></tr></table></TD></TR></TABLE>
                                            </TD>
                                            <TD  id="shadown-content" valign="top">
                                                   <iframe name="mainFrame" id="mainFrame" border="0"
                                        frameborder="no" noresize="noresize"  width="100%"
                                        scrolling="auto" src="<%=initsrcpage%>" style="height:100%;"></iframe> 
                                        <!--&nbsp;/hrm/resource/HrmResource_frm.jsp-->
                                            </TD>
                                        </TR>
                                        </TABLE>
                                    </td>
                                </tr>
                                </table>
                            </td>
                            <td  width="5px"></td>
                        </tr>
                    </table>                
                </td></tr>
				
                <!--下-->
                <tr  height="5px"><td>
                    <div id="footer"></div>                
                </td></tr>
            </table>
            
            <!--放置logo区域-->
            <%
            if (logo == null || logo.equals("")) {
            %>
            <img src="/wui/theme/ecology7/page/images/logo_wev8.png" border="0" style="position:absolute;top:0;left:0;" id="logo"/>
			<%	
            } else {
            %>
            <img src="<%=logo %>" border="0" style="position:absolute;top:0;left:0;" id="logo"/>
            <%
            }
            %>
            <!-- 版本信息 -->
            <div class="versiontype"></div>   
    </body>
</html>

<script languange="javascript">
//左侧区域宽度（根据分辨率自动解析）
var LeftBlock_Max_Width = 0;
/**
 * 初始化左侧区域各个块得大小
 * 自动执行
 */
function leftBlockSizeInit() {
	var clientScreenHeight = window.screen.height;
	var clientScreenWidth = window.screen.width;
	if (clientScreenWidth < 1280) {
		clientScreenWidth = 1280;
	}
    var tpLeftMenuMaxHeight = Math.round(clientScreenHeight / 2.8);
    var tpLeftMenuMaxWidth = Math.round(clientScreenWidth / 8);
    setLeftBlockSize(tpLeftMenuMaxWidth, tpLeftMenuMaxHeight);
    //alert(tpLeftMenuMaxHeight);
    LeftBlock_Max_Width = tpLeftMenuMaxWidth;
}

/**
 * 设置左侧区域各个块得大小
 */
function setLeftBlockSize(tpLeftMenuMaxWidth, tpLeftMenuMaxHeight) {
	//jQuery("#leftBlockTd").css("width", tpLeftMenuMaxWidth + 3);
	jQuery("#leftBlockTd").css("width", tpLeftMenuMaxWidth + 25);
	jQuery("#leftmenucontainer").css("width", tpLeftMenuMaxWidth + 25);
	jQuery("#leftBlockTopBgCenter").css("width", tpLeftMenuMaxWidth + 14);
	jQuery("#leftBlockTopBgCenter").css("background", "url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftBlockTopBgCenter_wev8.jpg')");
	
	//td 126px
	jQuery("#leftmenu-top").css("width", tpLeftMenuMaxWidth + 3);
	jQuery("#leftmenu-top").css("height", 86);
	
	jQuery("#leftBlockHrmInfoCenter").css("width", tpLeftMenuMaxWidth - 63);
	jQuery("#leftBlockHrmInfoCenter").css("background", "url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/left/leftBlockHrmInfoBgCenter_wev8.png')");
	jQuery("#leftBlockHrmInfoCenter").css("background-repeat", "repeat-x");	
	
	//jQuery("#leftmenu-bottom").css("height", tpLeftMenuMaxHeight + 124 - 61);
	setMainElementHeight(27);
	
	if(jQuery.client.browser=="Explorer"){
		jQuery("#leftmenu-bottom").css("width", tpLeftMenuMaxWidth + 3);
	}else{
		jQuery("#leftmenu-bottom").css("width", tpLeftMenuMaxWidth + 1);
	}
	jQuery("#leftBlock_HrmDiv").css("height", 86);
	jQuery("#leftmenu-bottom-bottom").css("width", tpLeftMenuMaxWidth + 3);
	
	jQuery("#leftMenuBottomCenter").css("width", tpLeftMenuMaxWidth - 8);
	
	
	
	setHrmInfoDep(tpLeftMenuMaxWidth - 62);
}
/**
 * 自动调用
 */
leftBlockSizeInit();


function  setMainElementHeight(height) {
	if(jQuery.client.browser=="Explorer"){
		jQuery("#leftmenu-bottom").css("height", height + jQuery("#drillcrumb").height() + 71);
	}else{
		jQuery("#leftmenu-bottom").css("height", height + jQuery("#drillcrumb").height() + 71);
	}
} 

/**
 * 显示或者隐藏左侧区域
 */
function leftBlockContractionOrExpand(_this) {
	if (jQuery("#leftmenucontainer").css("display") == 'none') {
		jQuery("#leftmenucontainer").show();
		jQuery("#leftBlockTd").css("width", LeftBlock_Max_Width + 25);
		
		if (tmpLyTopmenu != lyClickTopmenuStatictics) {
			dymlftenu(recentlyClickTopMenuObj, false);
		}
		
		jQuery("#leftBlockHiddenContr").css("background", "");
		
		leftBlockHiddenContrFlag = 0;
	} else {
		jQuery("#leftmenucontainer").hide();
		jQuery("#leftBlockTd").css("width", 0);
		
		if (recentlyClickTopMenuObj != null && recentlyClickTopMenuObj != undefined) {
			recentlyClickTopMenuObjId = jQuery(recentlyClickTopMenuObj).attr("levelid");
			if (recentlyClickTopMenuObjId == "" || recentlyClickTopMenuObjId == undefined || recentlyClickTopMenuObjId == null) {
				recentlyClickTopMenuObjId = "-9999";
			} 
		}
		
		tmpLyTopmenu = lyClickTopmenuStatictics;
		jQuery("#leftBlockHiddenContr").css("background", "url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/leftBlockExpand_wev8.png) no-repeat");
		leftBlockHiddenContrFlag = -1;
	}
}

/**
 * 显示或者隐藏顶部区域
 */
function topBlockContractionOrExpand(_this) {
	if (jQuery("#mainTopBlockTr").css("display") == 'none') {
		jQuery("#mainTopBlockTr").show();
		jQuery("#topBlockHiddenContr").css("background", "");
		jQuery("#logo").show();
		jQuery(".versiontype").show();
		topBlockHiddenContrFlag = 0;
	} else {
		jQuery("#mainTopBlockTr").hide();
		jQuery("#logo").hide();
		jQuery(".versiontype").hide();
		jQuery("#topBlockHiddenContr").css("background", "url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/topBlockExpand_wev8.png) no-repeat");
		topBlockHiddenContrFlag = -1;
	}
	
	jQuery("table").each(function(){
		$(this).css("height",$(this).parent().height())
	})
	$("#shadown-x").find("table").css("height","10px")
	
	$("#mainFrame").parent().css("height",$("#mainFrame").parent().height())
	
}
/**
 * 设置左侧区域内hrmInfo的大小
 */
function setHrmInfoDep(tpLeftMenuMaxWidth) {
	jQuery("#leftBlockHrmDep").css("width", tpLeftMenuMaxWidth);
	jQuery("#tdMessageState").css("left", tpLeftMenuMaxWidth - 60);
}

jQuery("#leftBlockHiddenContr").css("background", "");
jQuery("#topBlockHiddenContr").css("background", "");

/**
 * 最近一次点击左侧菜单的id
 * 用于当左侧菜单隐藏，并且点击了顶部菜单的情况下，更新用。
 */
var recentlyClickTopMenuObjId = "";
var tmpLyTopmenu = -1;

/**
 * 记录左侧区域的状态：0：隐藏   -1：正常显示
 * 作用：是否持续显示隐藏/显示左侧的按钮
 */
var leftBlockHiddenContrFlag = 0;
var topBlockHiddenContrFlag = 0;
jQuery(document).ready(function() {
	jQuery("table").each(function(){
		$(this).css("height",$(this).parent().height())
	})
	$("#mainFrame").parent().css("height",$("#mainFrame").parent().height())
	
	
	//左侧区域隐藏按钮点击时触发
	jQuery("#leftBlockHiddenContr").bind("click", function() {
		leftBlockContractionOrExpand();
	});
	
	//顶部区域隐藏按钮点击时触发
	jQuery("#topBlockHiddenContr").bind("click", function() {
		topBlockContractionOrExpand();
	});
	
	//左侧区域隐藏按钮
	jQuery("#leftBlockHiddenContr").hover(function() {
		if (leftBlockHiddenContrFlag != -1) {
			jQuery(this).css("background", "url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/leftBlockContraction_wev8.png) no-repeat");
		}
	}, function() {
		if (leftBlockHiddenContrFlag != -1) {
			jQuery(this).css("background", "none");
		}
	});
	
	//顶部区域隐藏按钮
	jQuery("#topBlockHiddenContr").hover(function() {
		if (topBlockHiddenContrFlag != -1) {
			jQuery(this).css("background", "url(/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/topBlockContraction_wev8.png) no-repeat");
		
		}
	}, function() {
		if (topBlockHiddenContrFlag != -1) {
			jQuery(this).css("background", "none");
		}
	});
});

window.document.onkeydown = function () {
	if (window.event.ctrlKey &&window.event.shiftKey && window.event.keyCode == 13) {
		if (topBlockHiddenContrFlag == leftBlockHiddenContrFlag) {
			topBlockContractionOrExpand();
			leftBlockContractionOrExpand();
		} else if (topBlockHiddenContrFlag != -1) {
			topBlockContractionOrExpand();
		} else if (leftBlockHiddenContrFlag != -1) {
			leftBlockContractionOrExpand();
		}
	}
}

function addCookie(objName,objValue,objHours){//添加cookie
	var str = objName + "=" + escape(objValue);
	if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
		var date = new Date();
		var ms = 10*365*24*60*60*1000;
		date.setTime(date.getTime() + ms);
		str += "; expires=" + date.toGMTString();
	}
	document.cookie = str;
}

function getCookie(objName){//获取指定名称的cookie的值
	var arrStr = document.cookie.split("; ");
	for(var i = 0;i < arrStr.length;i ++){
		var temp = arrStr[i].split("=");
		if(temp[0] == objName) return unescape(temp[1]);
 	}
}
				
</script>
<script>   
  var con=null;
  window.onbeforeunload=function(){	
	  if(typeof(isMesasgerUnavailable) == "undefined") {
		     isMesasgerUnavailable = true; 
	  }  
	  if(!isMesasgerUnavailable){
	  	return "<%=SystemEnv.getHtmlLabelName(24985,user.getLanguage())%>";
	  }	 
	  var e=getEvent();
	  var n = e.screenX - window.screenLeft;
	  var b = n > document.documentElement.scrollWidth-20;  
	  if(b && e.clientY < 0 || e.altKey){
	  	  e.returnValue = "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>"; 
	  }
  }  
  </script>
<script language="javascript">
//定时接收邮件
window.setInterval(function (){
	<%
	String isTimeOutLogin = Prop.getPropValue("Others","isTimeOutLogin");
	if("2".equals(isTimeOutLogin)){
	%>
	return false;
	<%}%>
	jQuery.post("/email/MailTimingDateReceiveOperation.jsp?"+new Date().getTime());
  },1000 * 60 * 5);
</script>
<%
boolean isHaveEMessager=Prop.getPropValue("Messager2","IsUseEMessager").equalsIgnoreCase("1");
if(isHaveEMessager){
%>
	<%@ include file="/messager/joinEMessage.jsp"%>
<%
}else{
	int userId=user.getUID();
	boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
	int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",userId+"");
	if(isHaveMessager&&userId!=1&&isHaveMessagerRight==1){
%>
	<%@ include file="/messager/join.jsp"%>
<%}}%>
