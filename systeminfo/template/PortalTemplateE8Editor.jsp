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
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />



<%@ include file="/wui/common/page/initWui.jsp" %>

<%



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
String id = Util.null2String(request.getParameter("skin"));

if(targetid == 0) {
	if(!logintype.equals("2")){
		//initsrcpage="/workspace/WorkSpace.jsp";
        initsrcpage="";
	}else{
		initsrcpage="";
	}
}

/**
 * 系统主题、皮肤
	*/



Map pageConfigKv = getPageConfigInfo(session, user);


String isIE = (String)session.getAttribute("browser_isie");
if (isIE == null || "".equals(isIE)) {
	isIE = "true";
	session.setAttribute("browser_isie", "true");
}

String pslSkinfolder = "default";

String skin = "default";

String curTheme="ecology8";




int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));

int templateId = Util.getIntValue(request.getParameter("templateid"));
String init =Util.null2String(request.getParameter("init"));
//初始化数据
if(init.equals("true")){
	String clearSql = "drop table SystemTemplateTemp ";	
	rs.executeSql(clearSql);
	String copySql = "SELECT * into SystemTemplateTemp from SystemTemplate where id="+templateId;	
	if("oracle".equals((rs.getDBType())))
		copySql = "create table SystemTemplateTemp as select * from SystemTemplate where id="+templateId;
	rs.executeSql(copySql);
}
String tempatename="";
String templateType = "";
String TemplateTitle = "";
String extendtempletid ="";
String ecology7themeid="";
String logo = "";

rs.executeSql("select * from SystemTemplateTemp where id = "+templateId);

if(rs.next()){
	templateType = rs.getString("templateType");
	TemplateTitle = rs.getString("TemplateTitle");
	tempatename = rs.getString("TemplateName");
	extendtempletid = rs.getString("extendtempletid");
	ecology7themeid = rs.getString("ecology7themeid");

	logo =  rs.getString("logo");
}


rs.executeSql("select * from ecology8theme where id="+id);

rs.next();
String colorStyle = rs.getString("cssfile");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8;" />
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" >
        <title></title>
		<!--For Base-->
		<link rel="stylesheet" type="text/css" href="/wui/common/css/base_wev8.css" />
		<link rel="stylesheet" href="/wui/common/js/MenuMatic/css/MenuMatic_wev8.css" type="text/css" media="screen" />
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" id="portalCss" type="text/css" href="/wui/theme/ecology8/skins/default/page/<%=colorStyle %>_wev8.css"> 

		
		
		<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
		<link rel="stylesheet" href="/wui/common/js/MenuMatic/css/MenuMatic_wev8.css" type="text/css" media="screen" />
		<script src="/wui/common/js/MenuMatic/js/mootools-yui-compressed_wev8.js"></script>
		<script src="/wui/common/js/MenuMatic/js/MenuMatic_0.68.3-source_wev8.js" type="text/javascript"></script>
		<script src="/wui/theme/ecology8/page/js/jquery.cookie_wev8.js" type="text/javascript"></script>
		
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
        		width:160px;
        		z-index:9;
        		background: #5D5D5D;
        		padding-bottom: 5px;
        		left:70px;
        	}
        	.accountItem{
        		height:40px;
        		padding:3px;
        		cursor:pointer;
        	}
        	
        	.accountItemOver{
        		background: #6E6E6E!important;
        	}
        	
        	
        	.accountIcon{
        		float: left;
        		width:20px;
        		height:30px;
        		padding-right:5px;
        		padding-left:5px;
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
		width:66px; 
		min-width:50px; 
		list-style:none;}
	.dropdown span.value { display:none;}
	.selectContent ul li{list-style:none;!important;height:25px;color:#656565}
	.selectContent ul li a { padding:0px; display:block;margin:0;width:66px;height:25px;line-height:21px;font-size:14pt; }
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
	
	span.e8_number{
		border-radius: 8px; 
		display:inline-block;
		text-align:right;
		width:auto!important;
		float: right;
	}
	
	.logocolor{
		background-color:<%=rs.getString("logocolor")%>!important;
	}
	
	.logobordercolor{
		border-color: <%=rs.getString("logocolor")%>!important;
	}
	
	
	.hrmcolor{
		background-color:<%=rs.getString("hrmcolor")%>;
	}
	
	.leftcolor{
		background-color:<%=rs.getString("leftcolor")%>!important;
	}
	
	.topcolor{
		background-color:<%=rs.getString("topcolor")%>;
	}
	
	.lfFoot{
		position: static!important;
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
		jQuery(document).ready(function(){
		     //jQuery("#mainBody").css("background","url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y");
			 //jQuery("#mainBody").css("background-color","#4F81BD");
		});
		//background:url('/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y;
		</script>
    </head>
        
    
<!-- 锁定整个界面的CSS2011/5/19 -->

    <body id="mainBody" scroll="no"  style="overflow-y:hidden;">
			<table id="topTitle" cellpadding="0" cellspacing="0" width="100%" style='display:none'>
	<tr>
		<td width="75px">
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>" class="e8_btn_top" onclick="doPreview()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32599,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAndEnable()" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave()" />
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			<!-- 签到签退用div -->
            <div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none;' valign='top'></div>            
            <div id='message_Div' style='display:none;'></div>    
            <div id="container"  style="height:100%;">
                <!--上-->
                <div id="mainTopBlockTr" class="topcolor">
                    <div id="head">
                        <div>
                            <div id="lftop" class="logocolor" style="float:left;width:225px;">
                            	<div class="logoArea editor" tbname='SystemTemplate' field='logo'>
                            		<%if(logo.equals("")){ %>
									<span>
										e-cology | <%=SystemEnv.getHtmlLabelName(83516,user.getLanguage())%>
									</span>
									<%} else{%>
										<img id="logoImg" src="<%=logo %>"  style="width:100%;height:100%;">
									<%} %>
                                	<!-- main功能插件 -->
                                </div>
                            </div>
                            <div class="center" align="center" style="position:relative;z-index:1;float:left" id="topCenter">
                                <!--放置菜单区域-->
                                <jsp:include page="/systeminfo/template/e8deftop.jsp"></jsp:include>
								
                            </div>
                            <div style="position:absolute;right:0px;">
                                <!--放置搜索按钮框-->
                                
                                <!--放常用按钮区域-->
                                <jsp:include page="/systeminfo/template/e8deftoolbar.jsp"></jsp:include>
                            </div>
                            <div style="clear:both;"></div>
                        </div>
                     </div>  
                </div>
                <!--中-->
                <div style="height:100%;">
                    <div id="contentcontainer"style="width:100%;height:100%;">
                                <div id="content">
                               		<div id="e8rightContentDiv" style="background-color:#fff;height:100%;margin-left:225px;">
	                                            	<div style="width:100%;height:100%;">
	                                                   <iframe name="mainFrame" id="mainFrame" border="0"
	                                        frameborder="no" noresize="noresize"  width="100%" height="100%"
	                                        scrolling="auto" src="" style="height:100%;overflow-y:hidden;"></iframe> 
	                                        <!--&nbsp;/hrm/resource/HrmResource_frm.jsp-->
	                                        </div>
	                                           
	                                     </div>
                                    <div id="leftBlockTd" style="width:225px;float:left;">
										
                                        <!--放置左侧菜单区-->
                                        <div  id="leftmenucontainer" class="leftcolor"  style="width:225px;overflow:hidden;border:1px transparent;"> 
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
															
                                                        	<jsp:include page="/systeminfo/template/e8defleft.jsp"></jsp:include> 
															
                                                        </div>
															<div class="lfFoot leftMenuBottom" id="lfFoot">
																<%-- <a href="/systeminfo/menuconfig/CustomSetting.jsp" target="mainFrame">
																	<div class="lf0"><%=SystemEnv.getHtmlLabelName(18166,user.getLanguage())%></div>
																</a>
																<div id="sysConfig" style="z-index:99999;">
																	<a href="#" onclick="showPopMenu();return false;">
																		<div class="lf1">系统管理</div>
																	</a>
																	 
																</div>--%>
																<div class="lfootitem resourcesetting" overclass="resourcesettingover" title="<%= SystemEnv.getHtmlLabelName(18166,user.getLanguage()) %>">
																	
																</div>
																<div class="lfootitem passwordsetting" style="left:75px" overclass="passwordsettingover" title="<%= SystemEnv.getHtmlLabelName(17993,user.getLanguage()) %>">
																	
																</div>
																<div class="lfootitem skinsetting lfootitemlast" onclick="showSkinListDialog()" style="left:150px;" overclass="skinsettingover" style="border:transparent;" title="<%= SystemEnv.getHtmlLabelName(27714,user.getLanguage()) %>">
																	
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
            <div class="e8_leftToggle" title="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>"></div>   
            <!-- 上部区域隐藏 -->
            <%--<div class="e8_topToggle" title="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>"></div> --%>
        
        <div class="commonmenu" style="overflow:hidden">   
        	
	        <ul class="commonmenuul">
			<jsp:include page="/wui/theme/ecology8/page/commonmenu.jsp"></jsp:include>
			</ul>  
			
		</div>   
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
 
 jQuery(".accountItem").hover(function(){
 	$(this).addClass("accountItemOver")
 },function(){
 	$(this).removeClass("accountItemOver")
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

	
  
    
});

		

function loadCommonMenu(){
	 jQuery(".commonmenuul").load("/wui/theme/ecology8/page/commonmenu.jsp?t="+new Date().getTime(),function(){
    	initCommonMenu();
    	var ulheight = $('.commonmenuul').children().length*30;
    	if(ulheight>600){
    		ulheight = 600;
    	}
    	$('.commonmenu').height(ulheight);
    	if($('.commonmenu').hasClass("ps-container")){
    		$('.commonmenu').perfectScrollbar("update");
    	}else{
    		$('.commonmenu').perfectScrollbar();
    	}
    	
    });
    
}

function initCommonMenu(){
	 jQuery(".commonmenu").hover(function(){
		 	
		 },function(){
		 	jQuery(".commonmenu").hide();
		 	jQuery("#freqUse").removeClass("freqUseOver");
		 });
	   jQuery(".commonmenu li").hover(function(){
		 	$(this).find(".closemenu").show();
		 	$(this).addClass("over");
		 },function(){
		 	$(this).find(".closemenu").hide();
		 	$(this).removeClass("over");
		 });
		 
		 jQuery(".commonmenu li").click(function(){
			if(!jQuery(this).hasClass("addMenu")){
				jQuery(".commonmenu").hide();
				jQuery("#mainFrame").attr("src",$(this).attr("url"));
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
		    	if(ulheight>600){
		    		ulheight = 600;
		    	}
		    	$('.commonmenu').height(ulheight);
		    	if($('.commonmenu').hasClass("ps-container")){
		    		$('.commonmenu').perfectScrollbar("update");
		    	}else{
		    		$('.commonmenu').perfectScrollbar();
		    	}
			 })
		 });
		 event.stopPropagation();
	 	
	 });
	
	  jQuery(".commonmenu").find(".addMenu").bind("click",function(){
	  		var theme_imp = new window.top.Dialog();
			theme_imp.currentWindow = window;   //传入当前window
		 	theme_imp.Width = 800;
		 	theme_imp.Height = 600;
		 	theme_imp.maxiumnable=true;
		 	theme_imp.Modal = true;
		 	theme_imp.Title = "<%=SystemEnv.getHtmlLabelName(32127,user.getLanguage())%>"; 
		 	theme_imp.URL ="/wui/theme/ecology8/page/commonmenuSetting.jsp?type=left&isCustom=true&resourceType=3&resourceId=<%=user.getUID()%>";
		 	theme_imp.show();
	  })
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
	
}

jQuery(document).ready(function(){

	jQuery("#leftmenucontainer,.leftmenueidtor,.editor,.toolbarEditor").hover(
		function(){
			jQuery(this).css({"border":"1px dashed red","cursor":"pointer"});
			jQuery("#"+jQuery(this).attr("field")).show()
			//$("#drillmenu").css("z-index","-1")
			//var divHtml = '<div class="divMask" style="position: absolute; width: 100%; height: 100%; left: 0px; top: 0px; background: #fff; opacity: 0; filter: alpha(opacity=0)"> </div>'; 
			//$(this).wrap('<span style="position: relative"></span>'); 
			//$(this).parent().append(divHtml); 
		},function(){
			jQuery(this).css({"border":"1px dashed transparent","cursor":"normal"});
			//$(this).parent().find(".divMask").remove(); 
			//$(this).unwrap(); 
			//$("#drillmenu").css("z-index","0")
			//var obj = jQuery("#"+jQuery(this).attr("field"));
			//setTimeout(function(){jQuery(obj).hide();},2000);
		}
	)
	
	$(".editor").bind("click",function(event){
		var type = $(this).attr("type");
		showImageDialog($(this));
		event.stopPropagation();
		return false;
					
	});
	
	jQuery("#leftmenucontainer").live("click",function(event){
	
		onOrder();
		//event.stopPropagation();
		//return false;
	})
	
	jQuery(".leftmenueidtor").bind("click",function(event){
		onEditLeftMenu();
		//event.stopPropagation();
		//return false;
	})
	
	jQuery(".toolbarEditor").bind("click",function(event){
		var type = $(this).attr("type");
		showImageDialog2($(this));
		event.stopPropagation();
		return false;
	})
	
	
	
})

	
	
	/*图片文件选择框回调函数*/
	function doImageDialogCallBack(obj,datas){
		var	path=datas.id;
		//alert(path)
		if(path==undefined||path==''){
			path = '';
			
		}
		var type = $(obj).attr("type");
		if($(obj).hasClass("logoArea")){
			if(path==''){
				$(obj).html("<span> e-cology | <%=SystemEnv.getHtmlLabelName(83516,user.getLanguage())%></span>")
			}else{
				if($(obj).find("img").length>0){
				$("#logoImg").attr("src",path);
				}else{
					$(obj).html("<img id='logoImg' src='"+path+"'  style='width:100%;height:100%;'>")
				}
			}
		}else{
			if(type=="src"){
				$(obj).attr("src",path);
			}else{
				$(obj).css("background-image","url('"+path+"')")
			}
		}
		
		updateTempData($(obj).attr('tbname'),$(obj).attr("field"),path);
	}
	
	
	
	/*打开图片文件选择框*/
	function showImageDialog(target){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;   //传入当前window
	 	dialog.Width = top.document.body.clientWidth-100;
	 	dialog.Height = top.document.body.clientHeight-100;
	 	dialog.maxiumnable=true;
	 	dialog.callbackfun=doImageDialogCallBack;
	 	dialog.callbackfunParam=target;
	 	dialog.Modal = true;
	 	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32467,user.getLanguage())%>"; 
	 	dialog.URL = "/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1";
	 	dialog.show();
		
	}
	
	
	
function updateTempData(tbname,field,value,menuid){
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
	{method:'update',tbname:tbname,field:field,value:value,levelid:menuid},function(){
	})
}


function onEditLeftMenu(){
	var title = "<%=SystemEnv.getHtmlLabelName(33675,user.getLanguage())%>"; 
	<%
		if(subCompanyId==0){
			%>
			var resourceType = 1 ;
			var resourceId = 1;
			<%
		}else{
			%>
			var resourceType = 2 ;
			var resourceId = <%=subCompanyId%>;
			<%
		}
	%>
 	var url = "/homepage/maint/HomepageTabs.jsp?_fromURL=hpMenu&type=left&isCustom=false&resourceType="+resourceType+"&resourceId="+resourceId;
 	showDialog(title,url,600,500,true);
}

function onOrder(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(24668,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepageLocation.jsp";
	 	showDialog(title,url,600,500,true);
}

function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
	
function doSave(){
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
	{method:'commit',id:'<%=templateId%>',templatetype:'ecology7',subCompanyId:'<%=subCompanyId%>'},function(){
		parent.parent.Dialog.close()
	})
	
}

function doSaveAndEnable(){
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
	{method:'commit&enable',id:'<%=templateId%>',templatetype:'ecology8',subCompanyId:'<%=subCompanyId%>'},
	function(){
		parent.parent.Dialog.close()

	})
}
</script>