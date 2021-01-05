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
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<%@page import="weaver.social.service.SocialIMService"%>
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />

<jsp:useBean id="rsSkin" class="weaver.conn.RecordSet" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />


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

String templateid = Util.null2String(request.getParameter("templateid"));
//out.println(templateid+"$$$");
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
		baseBean.writeLog(frompage);
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
	curTheme = "ecology8";
	ely6flg = "ecology6";
}
curTheme = "ecology8";
pslSkinfolder = "default";
request.setAttribute("REQUEST_SKIN_FOLDER", pslSkinfolder);

Map pageConfigKv = getPageConfigInfo(session, user);

String logo = getCurrTemplateLogo(user);

String isIE = (String)session.getAttribute("browser_isie");
if (isIE == null || "".equals(isIE)) {
	isIE = "true";
	session.setAttribute("browser_isie", "true");
}

int isShowLeftMenu = 1;
RecordSet.execute("select isshowleftmenu  from PageUserDefault where userid="+user.getUID());
if(RecordSet.next()){
	isShowLeftMenu = RecordSet.getInt("isshowleftmenu");
}

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8;" />
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" >
        <title></title>
		<!--For Base-->
		<script type="text/javascript">
		var isShowLeftMenu=<%=isShowLeftMenu%>
		</script>
		<link rel="stylesheet" type="text/css" href="/wui/common/css/base_wev8.css" />
		<link rel="stylesheet" href="/wui/common/js/MenuMatic/css/MenuMatic_wev8.css" type="text/css" media="screen" />
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		
		<link rel="stylesheet" href="/wui/common/js/MenuMatic/css/MenuMatic_wev8.css" type="text/css" media="screen" />
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		
		<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
		<script src="/wui/common/js/MenuMatic/js/mootools-yui-compressed_wev8.js"></script>
		<script src="/wui/common/js/MenuMatic/js/MenuMatic_0.68.3-source_wev8.js" type="text/javascript"></script>
		
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
      
            
            <%
	            String skin = (String)request.getAttribute("REQUEST_SKIN_FOLDER");
	            String e8skincss ="left";
	            String e8skin = getCurrE8SkinInfo(user);

	        	RecordSet.execute("select * from ColorStyleInfo where userid="+user.getUID());
            	String colorStyle="";
            	if(RecordSet.next()){
            		colorStyle = RecordSet.getString("style");
            		session.setAttribute("ColorStyleInfo",colorStyle);
            		
            	}else{
		            rsSkin.execute("select * from ecology8theme where id="+e8skin);
		            if(rsSkin.next()){
		            	
		            	e8skincss = rsSkin.getString("cssfile");
		            	%>
		            	<link rel="stylesheet" id="themecolorfile" type="text/css"  href="/wui/theme/ecology8/skins/default/page/<%=e8skincss %>_wev8.css"> 
		            	<STYLE TYPE="text/css" id="themecolor">
		            	.logocolor{
							background-color:<%=rsSkin.getString("logocolor")%>!important;
						}
						
						.logobordercolor{
							border-color: <%=rsSkin.getString("logocolor")%>!important;
						}
						
						
						.hrmcolor{
							background-color:<%=rsSkin.getString("hrmcolor")%>;
						}
						
						.leftcolor{
							background-color:<%=rsSkin.getString("leftcolor")%>!important;
						}
						
						.topcolor{
							background-color:<%=rsSkin.getString("topcolor")%>;
						}
						</STYLE> 
		            	<%
		            }else{
		            	colorStyle = "left";
		            }
            	}
            	
            	
            %>
        <link rel="stylesheet" id="portalCss" type="text/css" href="/wui/theme/ecology8/skins/default/page/<%=colorStyle %>_wev8.css"> 
        
            
        <STYLE TYPE="text/css">
            body{
                 margin: 0px; 
                /*可以被动态更改的值*/
                /*background:url('images/body-bg_wev8.png') repeat-y;*/
                font-size: 9pt;font-family: verdana;
                
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
                width:100%;height:100%;    border-collapse:collapse;
                overflow: hidden;
            }
            #head{
                WIDTH:100%;
				height:50px;
                /*background:url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/head-bg_wev8.jpg') no-repeat;*/
                /*background:url('images/head-bg_wev8.png') no-repeat;*/
                border-collapse:collapse;
            }
            


            #contentcontainer{
                WIDTH:100%;height:100%;
                border-collapse:collapse;
            }
            #contentcontainer #content{
                WIDTH:100%;height:100%;
                border-collapse:collapse;
                position:relative;
            }

            #leftmenucontainer{
                height:100%;
            }
            #footer{

            }

            #shadown-corner{
                background:url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/shadown-coner_wev8.png') no-repeat; width:10px;height:10px;
            }
            #shadown-x{
                background:url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/shadown-x_wev8.png') repeat-x; height:10px;
            }
            #shadown-y{
            	display:none;
                background:url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/shadown-y_wev8.png') repeat-y; 
				/*width:10px;*/
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
				background-color:#FFF;
				height:100%;
				top:0;
				position:absolute;
			}
			.leftBlockTopBgLeft {
				overflow:hidden;width:10px;position:absolute;left:0;top:0;background:url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/left/leftBlockTopBgLeft_wev8.jpg) no-repeat;height:10px;
			}
			#leftBlockTopBgCenter {
				overflow:hidden;position:absolute;left:10px;right:2px;top:0;height:10px;
			}
			.leftBlockTopBgRight {
				overflow:hidden;position:absolute;right:-2;top:0;
				/*background:url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/left/leftBlockTopBgRight_wev8.jpg) no-repeat;*/
				height:10px;width:2px;
			}
			
			#leftmenu-top {
				position:absolute;width:128;height:87px;
			}
			
			.leftBlockHrmInfoLeft {
				width:60px;position:absolute;left:0;top:0;
				/*background:url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/left/leftBlockHrmInfoBgLeft_wev8.png) no-repeat;height:87px;*/
			}
			
			.leftBlockHrmInfoCenter {
				position:absolute;left:60px;right:6px;top:0;height:87px;width:60px;
			}
			
			.leftBlockHrmInfoRight {
				position:absolute;right:0;top:0;
				/*background:url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/left/leftBlockHrmInfoBgRight_wev8.png) no-repeat;*/
				height:87px;width:6px;
			}
			#leftBlock_HrmDiv {
				position:relative;top:0px;height:41px;
			}
			
			#leftmenu-bottom-bottom {
				width:128px;position:relative;top:0px;
			}
			.leftMenuBottomLeft {
				width:5px;position:absolute;left:0;top:0;background:url(/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/left/leftMenuBottomLeft_wev8.png) no-repeat;height:7px;
			}
			#leftMenuBottomCenter {
				position:absolute;left:5px;right:6px;top:0;background:url(/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/left/leftMenuBottomCenter_wev8.png) repeat-x;height:7px;
			}
			
			.leftMenuBottomRight {
				position:absolute;right:0;top:0;background:url(/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/left/leftMenuBottomRight_wev8.png) no-repeat;height:7px;width:6px;
			}
			
			#topBlockHiddenContr {
				width:502px;height:20px;position:relative;margin-bottom:-12px;cursor:pointer;background:url(/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/topBlockContraction_wev8.png) no-repeat;background-position:0 25;
			}
			#leftBlockHiddenContr {
				height:502px;width:12px;position:relative;margin-right:-12px;cursor:pointer;background:url(/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/leftBlockContraction_wev8.png) no-repeat;overflow:hidden;background-position:25 0;
			}
			.versiontype { 
				position:absolute;left:150;top:40;
				/*background:url(/wui/theme/ecology8/page/images/versiontype_wev8.png) no-repeat;height:10px;width:33px;display:block;overflow:hidden;*/
			}
			#mainFrame {
				height:100%!important;
			}
			
			/*IE6 fixed*/
			
			 .accoutSelect{
			 	padding-top:5px;
			 	padding-left:10px;
			 	position:relative;
			 	
			 	width:110px;
			 	background-image: url("/images/ecology8/doc/down_sel_wev8.png");
			 	background-repeat: no-repeat;
			 	background-position: center right;
			 	height:20px;
			 	line-height: 20px;
			 }
			 
			.accoutBg{
				background: #adadad;
			}
        	.accoutList{
        		display:none;
        		padding-top:5px;
        		position:absolute;
        		top:35px;
        		width:200px;
        		z-index:100;
        		padding-bottom: 5px;
        	}
        	.accountItem{
        		height:65px;
        		cursor:pointer;
        	}
        	
        	.accoutListBox{
        		background: #ffffff;
        		border:1px solid #d4d4d4;
        		width:190px;
        		padding:0 5px;
        		top: 8px;
        		left:-18px;
        		position: absolute;
        		-moz-border-radius: 3px;
			    -webkit-border-radius: 3px;
			    border-radius:3px;
        	}
        	.accountText{
        		width:185px;
        		height: 56px;
        		margin-top:9px;
        		padding-left:5px;
        		line-height:28px;
        		white-space: nowrap;
        		overflow: hidden;
        		text-overflow:ellipsis;
        	}
        	.accountIcon{
        		width:20px;
        		height:20px;
        		right:5px;
        		position: absolute;
        		margin-top:-39px;
        	}
        	.accountContext{
        		float: right;
        		
        	}
        	
        	
        
        </STYLE>
        
        <STYLE TYPE="text/css">
    .tbItm{
        cursor:pointer;
        background-position: left center;
        height:20px;
        width:30px;
		color:#fff;
		font-size:14px;
		color:rgb(205,205,205);
       /* background:url(/wui/theme/ecology8/skins/<%=skin %>/page/ecologyShellImg_wev8.png);*/
    }
    
    .tbItmNav{
    	 cursor:pointer;
    	 width:106px;
    	 color:#fff;
    }
    
    .toolbarItemSelected{
        filter:alpha(opacity=99);-moz-opacity:0.99;
    }

	.searchkeywork {width: 112px;font-size: 12px;height:32px !important;margin-top:1;background-color:transparent;border:none !important;line-height:30px;}
	.dropdown {
		padding-left:5px; 
		font-size:11px; 
		color:#000;
		height:35px;
		border-left:1px solid transparent;
		border-top:1px solid transparent;
		border-right:1px solid transparent;
	}
	.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px;}
	.selectContent { position:relative;z-index:6; }
	.dropdown a, .dropdown a:visited { color:#666666; text-decoration:none; outline:none;}
	.dropdown a:hover { color:#5d4617;}
	.selectTile a:hover { color:#5d4617;}
	.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
	.selectTile a span {cursor:pointer; display:block; padding:6 0 0 0;background:none;height:25px;font-size:14px; }
	.selectContent ul { 
		background:#fff none repeat scroll 0 0; 
		border-left:1px solid #d0d0d0; 
		border-right:1px solid #d0d0d0;
		border-bottom:1px solid #d0d0d0;
		color:#C5C0B0; 
		display:none;
		left:-6px; 
		position:absolute; 
		top:8px; 
		
		min-width:50px; 
		list-style:none;}
	.selectContent ul a{
	 	position:relative;
	 	display: block;
	}
	
	.selectContent ul img{
	 	position:absolute;
	 	top:2px;
	 	display: block;
	}
	.selectContent ul span{
		padding-right:10px;
		padding-left:27px;
		white-space:nowrap;
		display:block;
		
	}
	.dropdown span.value { display:none;}
	.selectContent ul li{list-style:none;!important;height:25px;color:#656565}
	.selectContent ul li a { padding:0px; display:block;margin:0;height:25px;line-height:21px;font-size:14pt; }
	.selectContent ul li a:hover { background-color:#218bde;color:#fff!important;}
	.selectContent ul li a img {border:none;vertical-align:middle;padding-left:8px;}
	.selectContent ul li a span {margin-left:5px;}
	.flagvisibility { display:none;}
	.sampleSelected{
		background-color:#fff;
		border-left:1px solid rgb(170,210,242);
		border-top:1px solid rgb(170,210,242);
		border-right:1px solid rgb(170,210,242);
	}
	.sampleSelected .selectTile a span{
		color:#4a4a4a!important;
	}
	.sampleSelected .selectTile a div{
		color:#fff!important;
	}
	.sampleSelected .e8_dropdown{
		background-image:url(/wui/theme/ecology8/page/images/toolbar/up_wev8.png)!important;
	}
	.dropdown .e8_dropdown{
		background-image:url(/wui/theme/ecology8/page/images/toolbar/down_wev8.png);
		width:12px;
		height:12px;
		float:left;
		margin-top:10px;
		background-position:50% 50%;
	}
	
	.menuMore{
		background-image: url(/wui/theme/ecology8/page/images/menumoretext_bright_wev8.png);
		
		background-repeat: no-repeat;
		width: 100%;
		line-height:40px;
		cursor: pointer;
		
		
		
		
	}
	.menuMore .text{
		background-position: 12px center;
		background-repeat: no-repeat;
		width: 100px;
		display: inline-block;
		
	}
	.lfFoot {
        bottom: 0px!important;
    }
	
</STYLE>
		
		<script type="text/javascript">
		window.onresize = function winResize() {
			if (jQuery("#mainBody").width() <= 1024 ) {
				jQuery("#container").css("width", "1024px");
			} else {
				jQuery("#container").css("width", jQuery("#mainBody").width());
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
		     //jQuery("#mainBody").css("background","url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y");
			 //jQuery("#mainBody").css("background-color","#4F81BD");
		});
		//background:url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y;
		</script>
		
		
    </head>
        
    
<!-- 锁定整个界面的CSS2011/5/19 -->

    <body id="mainBody" scroll="no"  style="overflow-y:hidden;">
			
			<%if(SocialIMService.isOpenIM()){%>
				<jsp:include page="/social/im/SocialIMInclude.jsp"></jsp:include>
			<%}%>
			
			<!-- 签到签退用div -->
            <div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none;' valign='top'></div>            
            <div id='message_Div' style='display:none;'></div>    
            <div id="container"  style="height:100%;">
                <!--上-->
                <div id="mainTopBlockTr" class="topcolor">
                    <div id="head">
                        <div>
                            <div id="lftop" class="logocolor" style="float:left;width:225px;">
                            	<div class="logoArea">
                            		<%if(logo.equals("")){ %>
									<span>
										e-cology | <%=SystemEnv.getHtmlLabelName(83516,user.getLanguage())%>
									</span>
									<% }else{%>
										<img src="<%=logo %>" width="225px" height="50px">
									<%} %>
                                	<!-- main功能插件 -->
                                	<jsp:include page="/wui/common/page/mainPlugins.jsp"></jsp:include>
                                </div>
                            </div>
                            <div class="center" align="center" style="position:relative;z-index:1;float:left" id="topCenter">
                                <!--放置菜单区域-->
                                <jsp:include page="/wui/theme/ecology8/page/top.jsp"></jsp:include>
								
                            </div>
                            <div style="position:absolute;right:0px;">
                                <!--放置搜索按钮框-->
                                
                                <!--放常用按钮区域-->
                                <jsp:include page="/wui/theme/ecology8/page/toolbar.jsp"></jsp:include>
                            </div>
                            <div style="clear:both;"></div>
                        </div>
                     </div>  
                </div>
                <!--中-->
                <div style="">
                    <div id="contentcontainer"style="width:100%;height:100%;">
                                <div id="conFtent">
                               		<div id="e8rightContentDiv" style="background-color:#fff;height:100%;margin-left:225px;">
	                                            	<div style="width:100%;height:100%;">
	                                                   <iframe name="mainFrame" id="mainFrame" border="0"
	                                        frameborder="no" noresize="noresize"  width="100%" height="100%"
	                                        scrolling="auto" src="<%=initsrcpage%>" style="height:100%;overflow-y:hidden;"></iframe> 
	                                        <!--&nbsp;/hrm/resource/HrmResource_frm.jsp-->
	                                        </div>
	                                           
	                                     </div>
                                    <div id="leftBlockTd" style="width:225px;float:left;">
										
                                        <!--放置左侧菜单区overflow:hidden;-->
                                        <div  id="leftmenucontainer" class="leftcolor"  style="width:225px;"> 
                                            <div>
                                                    	<div>
                                                    		<div class="leftMenuTop hrmcolor">
                                                    			<div style="position:relative;">
                                                    				<div id="leftmenu-top" style="">
                                                    					<div class="leftBlockHrmInfoLeft"></div>
                                                        				<div id="leftBlockHrmInfoCenter" class="leftBlockHrmInfoCenter"></div>
                                                        				<div class="leftBlockHrmInfoRight"></div>
                                                    				</div>
                                                    				<div id="leftBlock_HrmDiv">
	                                                    				<!--放置即时通讯相关的东西-->
	                                                        			<jsp:include page="/wui/theme/ecology8/page/hrmInfo.jsp"></jsp:include>
                                                        			</div>
                                                    			</div>
                                                    		</div>
                                                    	</div>
                                                        
                                                        <!--放置左侧菜单区-->
                                                        <div style="position:relative;top:0px;"  id="leftmenucontentcontainer">
															
                                                        	<jsp:include page="/wui/theme/ecology8/page/left.jsp"></jsp:include> 
															
                                                        </div>
															<div class="lfFoot leftMenuBottom" id="lfFoot" style="z-index:99">
																<%-- <a href="/systeminfo/menuconfig/CustomSetting.jsp" target="mainFrame">
																	<div class="lf0"><%=SystemEnv.getHtmlLabelName(18166,user.getLanguage())%></div>
																</a>
																<div id="sysConfig" style="z-index:99999;">
																	<a href="#" onclick="showPopMenu();return false;">
																		<div class="lf1">系统管理</div>
																	</a>
																	 
																</div>--%>
																<div class="lfootitem resourcesetting" style="width:56px;"  overclass="resourcesettingOver" title="<%= SystemEnv.getHtmlLabelName(18166,user.getLanguage()) %>">
																	
																</div>
																<div class="lfootitem passwordsetting" style="left:56px;width:56px;" overclass="passwordsettingOver" title="<%= SystemEnv.getHtmlLabelName(17993,user.getLanguage()) %>">
																	
																</div>
																<div class="lfootitem skinsetting " onclick="showSkinListDialog()" style="left:112px;width:56px;" overclass="skinsettingOver" style="border:transparent;" title="<%= SystemEnv.getHtmlLabelName(27714,user.getLanguage()) %>">
																	
																</div>
																<div class="lfootitem remindsetting lfootitemlast" overclass="remindsettingover"   style="left:168px;width:56px;" overclass="skinsettingover" style="border:transparent;" title="<%= SystemEnv.getHtmlLabelName(19085,user.getLanguage()) %>">
																	
																</div>
															</div>
                                                </div>
                                            </div>
                                        </div>
	                                     <div style="clear:both;"></div>
              </div>
              </div>
              </div>
              </div>
            
            
            <!-- 版本信息 -->
            <div class="versiontype"></div>
            <!-- 左侧区域隐藏 -->
            <div class="e8_leftToggle" style="z-index:99;" title="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>"></div>   
            <!-- 上部区域隐藏 -->
            <%--<div class="e8_topToggle" title="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>"></div> --%>
        <div class="remindcontent" style="">   
        	<div class="title">
        		<div class="icon" ></div>
        		
        		<div class="name" >
        			<%=SystemEnv.getHtmlLabelName(84240,user.getLanguage()) %>
        		</div>
        		<div class="closebtn"></div>
        		<div style="clear: both;"></div>
        	</div>
	        <ul class="remindcontentul">
				<li class="liOver"><%=SystemEnv.getHtmlLabelName(84241,user.getLanguage()) %><span>8</span></li>
				<li><%=SystemEnv.getHtmlLabelName(84241,user.getLanguage()) %><span>8</span></li>
			</ul>  
			<div class="bottomfoot"></div>
		</div>   
        <div class="commonmenu leftcolor" >   
        	<div class="commonmenucontent" style="overflow:hidden;position: relative;">
				<ul style="list-style-type: none" class="commonmenuul">
			</ul>
			</div>
			<div class="menuToolBar">
				<div class="" >
					<span style="float:left;padding-left:10px;" id="addMenu" >+&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %></span>
					
					<span style="float:right;padding-right:10px;" id="clearMenu">&times;&nbsp;<%=SystemEnv.getHtmlLabelName(15504,user.getLanguage()) %></span>
					<span style="clear: both;"></span>
				</div>
			</div>  
			
		</div>
		
		  	
		<style type="text/css">
				.menuToolBar{
					
				}
				.menuToolBar{
					background-color: rgba(255, 255, 255, 0.2);
					
					height: 25px!important;
					line-height: 25px!important;
					color:#ebebeb!important;
					cursor: pointer;
				}
				.commonmenu .menuname{
					width: 80px;
					display: block;
					float: left;
					overflow: hidden;
					word-break:keep-all;
					white-space:nowrap;
					text-overflow:ellipsis;
				}
				.commonmenu .icon{
					display: block;
					float: left;
				}
				.remindcontent{
					position: absolute;
					left: 10px;
					bottom: 50px;
					z-index: 999999;
					width: 204px;
					display: none;
					height: 0px;
					
				}
				
				.remindcontentul{
					background: #ffffff;
					padding-top:3px;
					padding-bottom: 3px;
				}
				
				.remindcontentul .nodata{
					line-height: 30px;
					text-align: center;
					display: block;
				}
				.remindcontentul li{
					background: #ffffff;
					color:#919191;
					height: 35px;
					line-height: 35px;
					padding-left:12px;
					cursor: pointer;
				}
				
				.remindcontentul li span{
					float: right;
					margin-right: 20px;
					color:#fe9348;
				}
				
				.remindcontentul .liOver{
					background: #f0f0f0!important;
				}
				
				.remindcontent .title{
					height:33px;
					
					background: #33a3ff;
				}
				.remindcontent .title .name{
					color:#ffffff;
					float:left;
					line-height: 33px;
					width: 130px;
					height: 100%;
				}
				.remindcontent .title .icon{
					float:left;
					width: 36px;
					height: 100%;
					background: url('/wui/theme/ecology8/page/images/remind/icon_wev8.png');
					background-position: center center;
					background-repeat: no-repeat;
				}
				.remindcontent .title .closebtn{
					float:right;
					width: 36px;
					height: 100%;
					background: url('/wui/theme/ecology8/page/images/remind/close_wev8.png');
					background-position: center center;
					background-repeat: no-repeat;
					cursor: pointer;
				}
				
				.remindcontent .bottomfoot{
					width: 100%;
					height: 12px;
					background: url('/wui/theme/ecology8/page/images/remind/d_wev8.png');
					background-position: 180px -6px;
					background-repeat: no-repeat;
				}
				
				span.e8_number{
					border-radius: 8px; 
					display:inline-block;
					text-align:right;
					width:auto!important;
					float: right;
					
				
				}
				
				.commonmenu{
					display: none;
				}
			</style>
		
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
    var tpLeftMenuMaxWidth = Math.round(clientScreenWidth / 8)+20;
    setLeftBlockSize(tpLeftMenuMaxWidth, tpLeftMenuMaxHeight);
    LeftBlock_Max_Width = tpLeftMenuMaxWidth;
}

/**
 * 设置左侧区域各个块得大小
 */
function setLeftBlockSize(tpLeftMenuMaxWidth, tpLeftMenuMaxHeight) {
	//jQuery("#leftBlockTd").css("width", tpLeftMenuMaxWidth + 3);
	/*jQuery("#leftBlockTd").css("width", tpLeftMenuMaxWidth + 25);*/
	//jQuery("#leftmenucontainer").css("width", tpLeftMenuMaxWidth + 45);
	//jQuery("#lftop").css("width",tpLeftMenuMaxWidth + 45);
	//jQuery("#lfFoot").css("width",tpLeftMenuMaxWidth + 45);
	//jQuery("#popMenu").css("left",tpLeftMenuMaxWidth + 45);
	//jQuery("#topCenterTable").css("width",jQuery("#topCenter").width());
	//jQuery(".topMenuDiv").css("width",jQuery("#topCenter").width()-18);
	/*jQuery("#leftBlockTopBgCenter").css("width", tpLeftMenuMaxWidth + 14);
	jQuery("#leftBlockTopBgCenter").css("background", "url('/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/left/leftBlockTopBgCenter_wev8.jpg')");
	
	//td 126px
	jQuery("#leftmenu-top").css("width", tpLeftMenuMaxWidth + 3);
	jQuery("#leftmenu-top").css("height", 86);
	
	jQuery("#leftBlockHrmInfoCenter").css("width", tpLeftMenuMaxWidth - 63);
	/*jQuery("#leftBlockHrmInfoCenter").css("background", "url('/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/left/leftBlockHrmInfoBgCenter_wev8.png')");*/
	//jQuery("#leftBlockHrmInfoCenter").css("background-repeat", "repeat-x");	
	
	//jQuery("#leftmenu-bottom").css("height", tpLeftMenuMaxHeight + 124 - 61);
	/*setMainElementHeight(27);
	
	if(jQuery.client.browser=="Explorer"){
		jQuery("#leftmenu-bottom").css("width", tpLeftMenuMaxWidth + 3);
	}else{
		jQuery("#leftmenu-bottom").css("width", tpLeftMenuMaxWidth + 1);
	}
	jQuery("#leftBlock_HrmDiv").css("height", 86);
	jQuery("#leftmenu-bottom-bottom").css("width", tpLeftMenuMaxWidth + 3);
	
	jQuery("#leftMenuBottomCenter").css("width", tpLeftMenuMaxWidth - 8);
	
	
	
	setHrmInfoDep(tpLeftMenuMaxWidth - 62);*/
}

function isIE(){
	var brow=jQuery.browser;
	return brow.msie;
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
		jQuery("#e8rightContentDiv").css("margin-left","225px");
		//jQuery("#leftBlockTd").css("width", LeftBlock_Max_Width + 25);
		jQuery("#shadown-y").hide();
		if (tmpLyTopmenu != lyClickTopmenuStatictics) {
			dymlftenu(recentlyClickTopMenuObj, false);
		}
		
		jQuery("#leftBlockHiddenContr").css("background", "");
		jQuery("#leftHiddenTR").hide();
		
		leftBlockHiddenContrFlag = 0;
	} else {
		jQuery("#leftBlockTd").hide();
		jQuery("#e8rightContentDiv").css("margin-left","0px");
		//jQuery("#leftBlockTd").css("width", 0);
		//jQuery("#shadown-y").show();
		if (recentlyClickTopMenuObj != null && recentlyClickTopMenuObj != undefined) {
			recentlyClickTopMenuObjId = jQuery(recentlyClickTopMenuObj).attr("levelid");
			if (recentlyClickTopMenuObjId == "" || recentlyClickTopMenuObjId == undefined || recentlyClickTopMenuObjId == null) {
				recentlyClickTopMenuObjId = "-9999";
			} 
		}
		
		tmpLyTopmenu = lyClickTopmenuStatictics;
		//jQuery("#leftBlockHiddenContr").css("background", "url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/main/leftBlockExpand_wev8.png) no-repeat");
		leftBlockHiddenContrFlag = -1;
		//jQuery("#leftHiddenTR").show();
		jQuery(".e8_leftToggle").addClass("e8_leftToggleShow").show();
	}
}

jQuery(document).ready(function(){

	
	$("body").bind("click",function(){
		jQuery(".commonmenu").hide();
		jQuery("#freqUse").removeClass("freqUseOver").removeClass("leftcolor");
	})
	
	var leftTime = null;
	//左侧区域隐藏
	/*jQuery("#leftmenucontainer").hover(function(){
		var _top = (jQuery(this).height()-jQuery(".e8_leftToggle").height())/2;
		jQuery(".e8_leftToggle").css("top",_top);
		jQuery(".e8_leftToggle").show();
		jQuery(".e8_leftToggle").data("isOpen",true);
		if(leftTime)
			clearTimeout(leftTime);
	},function(){
		leftTime = window.setTimeout(function(){
			if(jQuery(".e8_leftToggle").data("isOpen")){
				jQuery(".e8_leftToggle").hide();
				jQuery(".e8_leftToggle").data("isOpen",false);
			}
		},500);
	});*/
	
	
	
	jQuery(".e8_leftToggle").click(function(){
		jQuery("#leftBlockTd").toggle();
		jQuery(".e8_leftToggle").removeClass("e8_leftToggleHover");
		jQuery(".e8_leftToggle").removeClass("e8_leftToggleShowHover");
		if(jQuery("#leftBlockTd").css("display")=="none"){
			jQuery(".e8_leftToggle").addClass("e8_leftToggleShow").show();
			jQuery("#e8rightContentDiv").css("margin-left","0px");
			jQuery(".e8_leftToggle").attr("title","<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>");
		}else{
			jQuery(".e8_leftToggle").removeClass("e8_leftToggleShow");
			jQuery("#e8rightContentDiv").css("margin-left","225px");
			jQuery(".e8_leftToggle").attr("title","<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>");
		}
		if(leftTime)
			clearTimeout(leftTime);
	}).hover(function(){
		//jQuery(".e8_leftToggle").data("isOpen",false);
		if(jQuery(".e8_leftToggle").hasClass("e8_leftToggleShow")){
			jQuery(".e8_leftToggle").addClass("e8_leftToggleShowHover");
		}else{
			jQuery(".e8_leftToggle").addClass("e8_leftToggleHover");
		}
		if(leftTime)
			clearTimeout(leftTime);
	},function(){
		if(!jQuery(".e8_leftToggle").hasClass("e8_leftToggleShow")){
			jQuery(".e8_leftToggle").removeClass("e8_leftToggleHover");
			//jQuery(".e8_leftToggle").hide();
		}else{
			jQuery(".e8_leftToggle").removeClass("e8_leftToggleShowHover");
		}
		if(leftTime)
			clearTimeout(leftTime);
		//jQuery(".e8_leftToggle").data("isOpen",false);
	});
	
	var topTime = null;
	//上侧区域隐藏
	jQuery("#mainTopBlockTr").hover(function(){
		var _left = (jQuery(this).width()-jQuery(".e8_topToggle").width())/2;
		jQuery(".e8_topToggle").css("left",_left);
		jQuery(".e8_topToggle").show();
		jQuery(".e8_topToggle").data("isOpen",true);
		if(topTime)
			clearTimeout(topTime);
	},function(){
		topTime = window.setTimeout(function(){
			if(jQuery(".e8_topToggle").data("isOpen")){
				jQuery(".e8_topToggle").hide();
				jQuery(".e8_topToggle").data("isOpen",false);
			}
		},500);
	});
	
	jQuery(".e8_topToggle").click(function(){
		jQuery("#mainTopBlockTr").toggle();
		jQuery(".e8_topToggle").removeClass("e8_topToggleHover");
		jQuery(".e8_topToggle").removeClass("e8_topToggleShowHover");
		if(jQuery("#mainTopBlockTr").css("display")=="none"){
			jQuery(".e8_topToggle").addClass("e8_topToggleShow").show();
			jQuery(".e8_topToggle").attr("title","<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>");
		}else{
			jQuery(".e8_topToggle").removeClass("e8_topToggleShow");
			jQuery(".e8_topToggle").attr("title","<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>");
		}
		if(topTime)
			clearTimeout(topTime);
		syncLMHeight();
	}).hover(function(){
		jQuery(".e8_topToggle").data("isOpen",false);
		if(jQuery(".e8_topToggle").hasClass("e8_topToggleShow")){
			jQuery(".e8_topToggle").addClass("e8_topToggleShowHover");
		}else{
			jQuery(".e8_topToggle").addClass("e8_topToggleHover");
		}
		if(topTime)
			clearTimeout(topTime);
	},function(){
		if(!jQuery(".e8_topToggle").hasClass("e8_topToggleShow")){
			jQuery(".e8_topToggle").removeClass("e8_topToggleHover");
			jQuery(".e8_topToggle").hide();
		}else{
			jQuery(".e8_topToggle").removeClass("e8_topToggleShowHover");
		}
		jQuery(".e8_topToggle").data("isOpen",false);
		if(topTime)
			clearTimeout(topTime);
	});
});

/**
 * 显示或者隐藏顶部区域
 */
function topBlockContractionOrExpand(_this) {
	if (jQuery("#mainTopBlockTr").css("display") == 'none') {
		jQuery("#mainTopBlockTr").show();
		//jQuery("#topBlockHiddenContr").css("background", "");
		jQuery("#logo").show();
		jQuery("#topHiddenTR").hide();
		jQuery(".versiontype").show();
		topBlockHiddenContrFlag = 0;
		setLeftMenuHeight(-50);
	} else {
		jQuery("#mainTopBlockTr").hide();
		jQuery("#logo").hide();
		jQuery(".versiontype").hide();
		jQuery("#topHiddenTR").show();
		//jQuery("#topBlockHiddenContr").css("background", "url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/main/topBlockExpand_wev8.png) no-repeat");
		topBlockHiddenContrFlag = -1;
		setLeftMenuHeight(50);
	}
	
}
/**
 * 设置左侧区域内hrmInfo的大小
 */
function setHrmInfoDep(tpLeftMenuMaxWidth) {
	jQuery("#leftBlockHrmDep").css("width", tpLeftMenuMaxWidth);
	jQuery("#tdMessageState").css("left", tpLeftMenuMaxWidth - 60);
}

function showSelectNav(){
	jQuery('#e8NavDH').toggle();
	if(jQuery("#e8NavDH").css("display")=="none"){
		jQuery(".qzhNavSpanImg").removeClass("qzhNavSpanImgup");
		jQuery(".qzhNavSpanImg").data("isOpen",false);
	}else{
		jQuery(".qzhNavSpanImg").addClass("qzhNavSpanImgup");
		jQuery(".qzhNavSpanImg").data("isOpen",true);
	}
}
function showAccoutList(){
	jQuery('#accoutList').toggle();
	if(jQuery("#accoutList").css("display")=="none"){
		jQuery(".accoutSelect").removeClass("accoutBg");
	}else{
		jQuery(".accoutSelect").addClass("accoutBg");
	}
}

jQuery("#accoutList").hover(function(){
 },function(){
 	jQuery('#accoutList').toggle();
 	jQuery(".accoutSelect").removeClass("accoutBg");
 });
 
 jQuery("#accoutImg").hover(function(){
 	$(this).attr("src","/wui/theme/ecology8/page/images/hrminfo/accoutOver_wev8.png")
 },function(){
 	$(this).attr("src","/wui/theme/ecology8/page/images/hrminfo/accout_wev8.png")
 });

jQuery(".qzhNavSpanImg").hover(function(){
 },function(){
 	window.setTimeout(function(){
 		if(jQuery(".qzhNavSpanImg").data("isOpen")){
 			jQuery("#e8NavDH").hide();
 			jQuery(".qzhNavSpanImg").removeClass("qzhNavSpanImgup");
 			jQuery(".qzhNavSpanImg").data("isOpen",false);
 		}
 	},600);
 });

//jQuery("#leftBlockHiddenContr").css("background", "");
//jQuery("#topBlockHiddenContr").css("background", "");


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

	$(".passwordsetting").bind("click",function(){
		$("#mainFrame").attr("src","/hrm/HrmTab.jsp?_fromURL=Hrm" +
        "" +
        "ResourcePassword");
	})
	
	
	$(".resourcesetting").bind("click",function(){
		$("#mainFrame").attr("src","/systeminfo/menuconfig/CustomSetting.jsp");
	})
	
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
			//jQuery(this).css("background", "url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/main/leftBlockContraction_wev8.png) no-repeat");
		}
	}, function() {
		if (leftBlockHiddenContrFlag != -1) {
			//jQuery(this).css("background", "none");
		}
	});
	
	jQuery("#lfFoot .lfootitem").hover(function(){
		jQuery(this).addClass($(this).attr("overclass"));
	},function(){
		jQuery(this).removeClass($(this).attr("overclass"));
	});
	
	//顶部区域隐藏按钮
	jQuery("#topBlockHiddenContr").hover(function() {
		if (topBlockHiddenContrFlag != -1) {
			//jQuery(this).css("background", "url(/wui/theme/<%=curTheme%>/skins/<%=pslSkinfolder %>/page/main/topBlockContraction_wev8.png) no-repeat");
		
		}
	}, function() {
		if (topBlockHiddenContrFlag != -1) {
			//jQuery(this).css("background", "none");
		}
	});
	
	//前中后端切换
		 jQuery("#e8NavDH").hover(function(){
		 	jQuery(".qzhNavSpanImg").data("isOpen",false);
		 },function(){
		 	jQuery("#e8NavDH").hide();
		 	jQuery(".qzhNavSpanImg").removeClass("qzhNavSpanImgup");
		 	jQuery(".qzhNavSpanImg").data("isOpen",false);
		 });
		 jQuery(".optionNormal").hover(function(){
		 	jQuery(this).addClass("colorfff").addClass("optionSelect");
		 	var fsrc = jQuery(this).find("#e8Current").attr("src");
		 	if(fsrc && fsrc.indexOf("_sel")==-1){
		 		fsrc = fsrc.replace(/\.png/,"_sel_wev8.png");
		 		jQuery(this).find("#e8Current").attr("src",fsrc);
		 	}
		 	var src = jQuery(this).find("img:last").attr("src");
		 	if(src.indexOf("_sel")==-1){
		 		src = src.replace(/\.png/,"_sel_wev8.png");
		 	}
		 	jQuery(this).find("img:last").attr("src",src);
		 },function(){
		 	var fsrc = jQuery(this).find("#e8Current").attr("src");
		 	if(fsrc && fsrc.indexOf("_sel")!=-1){
		 		fsrc = fsrc.replace(/_sel\.png/,".png");
		 		jQuery(this).find("#e8Current").attr("src",fsrc);
		 	}
		 	var src = jQuery(this).find("img:last").attr("src");
		 	src = src.replace(/_sel\.png/,".png");
		 	jQuery(this).find("img:last").attr("src",src);
		 	jQuery(this).removeClass("colorfff").removeClass("optionSelect");
		 });
		 
		 //更多菜单
		 jQuery("#toolbarMore").hover(function(){
		 	
		 },function(){
		 	jQuery("#toolbarMore").hide();
		 	jQuery("#toolbarMore").removeClass("moreBtnSel");
		 });
		 
	jQuery("#freqUse").parent().bind("click",function(event){
		hideOtherHoverDiv('common');
    	var left = jQuery(this).offset().left
    	var top = jQuery(this).offset().top
    	jQuery(".commonmenu").css("top",(top+35)+"px")
    	jQuery(".commonmenu").css("left",left+"px")
    	jQuery(".commonmenu").show();
    	
    	jQuery("#freqUse").addClass("freqUseOver").addClass("leftcolor")
    	event.stopPropagation();
    })
   
     jQuery(".commonmenu").find("#addMenu").bind("click",function(event){
	  		var theme_imp = new window.top.Dialog();
			theme_imp.currentWindow = window;   //传入当前window
		 	theme_imp.Width = 800;
		 	theme_imp.Height = 600;
		 	theme_imp.maxiumnable=true;
		 	theme_imp.Modal = true;
		 	theme_imp.Title = "<%=SystemEnv.getHtmlLabelName(32127,user.getLanguage())%>"; 
		 	theme_imp.URL ="/wui/theme/ecology8/page/commonmenuSetting.jsp?type=left&isCustom=true&resourceType=3&resourceId=<%=user.getUID()%>";
		 	theme_imp.show();
		 	event.stopPropagation();
	  })
	  
	  jQuery(".commonmenu").find("#clearMenu").bind("click",function(event){
	  		$this = jQuery(this)
		 	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81491,user.getLanguage())%>",function(){
			 	
			 	
			 	 jQuery.post("/wui/theme/ecology8/page/commonmenuoperation.jsp?method=clear",
				 function(data){
				 	loadCommonMenu();
				 })
			 });
			  event.stopPropagation();
			
	  })
  loadCommonMenu();
  updateRemindInfo();
    
});

function hideOtherHoverDiv(current){
	if(current != 'top'){
		topMenuContraction();
	}
	if(current != 'common'){
		jQuery(".commonmenu").hide();
	 	jQuery("#freqUse").removeClass("freqUseOver").removeClass("leftcolor");
	}
	if(current != 'search'){
		jQuery("#searchBlockUl").hide();
		jQuery("#searchBlockUl").closest("div#sample").removeClass("sampleSelected");
	}
	if(current != 'toolbar'){
		jQuery("#toolbarMore").hide();
    	jQuery("#toolbarMoreBtn").removeClass("moreBtnSel");
    	jQuery("#toolbarMoreBtn").data("isOpen",false);
	}
}		

function loadCommonMenu(){
	 jQuery(".commonmenuul").load("/wui/theme/ecology8/page/commonmenu.jsp?t="+new Date().getTime(),function(){
    	initCommonMenu();
    	var ulheight = $('.commonmenuul').children().length*30;
    	if(ulheight>300){
    		ulheight = 300;
    	}
    	$('.commonmenucontent').height(ulheight);
    	if($('.commonmenucontent').hasClass("ps-container")){
    		$('.commonmenucontent').perfectScrollbar("update");
    	}else{
    		$('.commonmenucontent').perfectScrollbar();
    	}
    	
    });
    
}

function initCommonMenu(){
	 jQuery(".commonmenu").hover(function(){
		 	
		 },function(){
		 	jQuery(".commonmenu").hide();
		 	jQuery("#freqUse").removeClass("freqUseOver").removeClass("leftcolor");
		 });
	   jQuery(".commonmenu li").hover(function(){
		 	$(this).find(".closemenu").show();
		 	$(this).addClass("over");
		 	$(this).find(".icon").addClass("logocolor")
		 },function(){
		 	$(this).find(".closemenu").hide();
		 	$(this).removeClass("over");
		 	$(this).find(".logocolor").removeClass("logocolor")
		 });
		 
		 jQuery(".commonmenu li").click(function(){
			if(!jQuery(this).hasClass("addMenu")){
				jQuery(".commonmenu").hide();
				window.open($(this).attr("url"),$(this).attr("target"))
			}
		 });
		 
	 jQuery(".closemenu").bind("click",function(event){
		$this = jQuery(this)
	 	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
		 	
		 	var menuid = $this.attr("menuid")
		 	 jQuery.post("/wui/theme/ecology8/page/commonmenuoperation.jsp?method=del&menuid="+menuid,
			 function(data){
			 	$this.parent().remove();
			 	var ulheight = $('.commonmenuul').children().length*30;
		    	if(ulheight>300){
		    		ulheight = 300;
		    	}
		    	$('.commonmenucontent').height(ulheight);
		    	if($('.commonmenucontent').hasClass("ps-container")){
		    		$('.commonmenucontent').perfectScrollbar("update");
		    	}else{
		    		$('.commonmenucontent').perfectScrollbar();
		    	}
			 })
		 });
		 event.stopPropagation();
	 	
	 });
}
window.document.onkeydown = function () {
	try{
	if (window.event.ctrlKey &&window.event.shiftKey && window.event.keyCode == 13) {
		if (topBlockHiddenContrFlag == leftBlockHiddenContrFlag) {
			topBlockContractionOrExpand();
			leftBlockContractionOrExpand();
		} else if (topBlockHiddenContrFlag != -1) {
			topBlockContractionOrExpand();
		} else if (leftBlockHiddenContrFlag != -1) {
			leftBlockContractionOrExpand();
		}
	}}catch(e){}
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

<script type="text/javascript">
	 var clearOut = null;
	 $(function() {
        $('#leftMenu').perfectScrollbar();
    });

	$(window).resize(function() {
			setLeftMenuHeight();
			setBodyScroll();
		});


function setLeftMenuHeight(detaheight){
	if(detaheight){
		jQuery("#leftMenu").height(jQuery("#leftMenu").height()+(detaheight));
	}else{
		syncLMHeight();
	}
	jQuery('#leftMenu').perfectScrollbar("update");
}

function showPopMenu(){
	if(clearOut){
		clearInterval(clearOut);
	}
	jQuery("#popMenu").show("slow");
}

function hiddenPopMenu(){
	jQuery("#popMenu").hide("slow");
}

function setBodyScroll(){
	try{
		jQuery("#mainFrame").parent().height(jQuery("#leftmenucontainer").height());
	}catch(e){
	}
}

jQuery("#frequseContent").children("div").bind("click",function(){
	jQuery(".aSelected").removeClass("aSelected");
	jQuery(this).addClass("aSelected");
});

function updateHandleRequest(){
	var levelid = "";
	var isPortal = false;
	jQuery("span[id^='num_']").each(function(){
		if( jQuery(this).attr("id").indexOf("_portal")>0){
			isPortal = true;
			return;
		}
		if(levelid == ""){
			levelid = jQuery(this).attr("id").replace(/\D/g,"");
		}else{
			levelid = levelid + ","+jQuery(this).attr("id").replace(/\D/g,"");
		}
	});
	if(isPortal){
		return;
	}
	jQuery.ajax({
            url: "/workflow/request/menuCount.jsp?levelid="+levelid+"&userid=<%=user.getUID()%>&usertype=<%=user.getLogintype().equals("2")?1:0%>&lftmn" + new Date().getTime() + "=",
            dataType: "json", 
            contentType : "charset=UTF-8", 
            error:function(ajaxrequest){
				
			}, 
            success:function(content){
            	try{
					var json = content; 
					for(var key in json){
						jQuery("#"+key).html("<span style='padding-left:5px;padding-right:5px;'>"+json[key]+"</span>");
						//jQuery("#"+key).css("margin-left",-jQuery("#"+key).closest("li").width()+jQuery("#"+key).closest("div").width()-7);
					}
				}catch(e){
					if(window.console)console.log(e);
				}
			}
	});
	
	
}
function updateRemindInfo(flag){
	jQuery.ajax({
            url: "/wui/theme/ecology8/page/getRemindInfo.jsp?1=" + new Date().getTime() + "=",
            dataType: "text", 
            contentType : "charset=UTF-8", 
            error:function(ajaxrequest){
				
			}, 
            success:function(content){
            	//alert(content)
            	if($.trim(content)!=""&&content.indexOf("nodata")==-1){
            		if(!flag){
            			$(".remindsetting").addClass("remindsettingOver");
            		}
            		$(".remindcontentul").html(content);
            		$(".remindcontentul").find("li").hover(function(){
            			$(this).addClass("liOver")
            		},function(){
            			$(this).removeClass("liOver")
            		})
            		$(".remindcontentul").find("li").bind("click",function(){
            			window.open($(this).attr("url"),"mainFrame")
            			$(".remindcontent").animate({height:"0px"})
						$(".remindcontent").hide();
            		})
            		
            	}else{
            		$(".remindcontentul").html(content);
            		$(".remindsetting").removeClass("remindsettingOver");
            	}
			}
	});
}

$(".remindsetting").bind("click",function(){
	if($(".remindcontent").is(":hidden")){
		updateRemindInfo(true)
		var height;
		if($(".remindcontentul").find("li").length>0){
			height= $(".remindcontentul").find("li").length*35+45;
		}else{
			height = 75
		}
		$(".remindcontent").show();
		$(".remindcontent").animate({height:height+"px"})
		$(this).removeClass("remindsettingOver")
	}else{
		$(".remindcontent").animate({height:"0px"})
		$(".remindcontent").hide();
	}
	
})

$(".closebtn").bind("click",function(){
	$(".remindcontent").animate({height:"0px"})
	$(".remindcontent").hide();
	
})
</script>
<%@ include file="/email/new/timingReceive.jsp" %>