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
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>



<%



/*用户验证*/
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String initsrcpage = "" ;
String logintype = Util.null2String(user.getLogintype()) ;


int id = Util.getIntValue(request.getParameter("id"));
String init =Util.null2String(request.getParameter("init"));

rs.executeSql("select * from ecology8theme where id="+id);

rs.next();
String pslSkinfolder = "default";

String skin = "default";


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
			<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" id="portalCss" type="text/css" href="/wui/theme/ecology8/skins/default/page/<%=colorStyle %>_wev8.css"> 
    	
		<link rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>	
		
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
				overflow:hidden;width:10px;position:absolute;left:0;top:0;background:url(/wui/theme/ecology8/skins/<%=pslSkinfolder %>/page/left/leftBlockTopBgLeft_wev8.jpg) no-repeat;height:10px;
			}
			#leftBlockTopBgCenter {
				overflow:hidden;position:absolute;left:10px;right:2px;top:0;height:10px;
			}
			.leftBlockTopBgRight {
				overflow:hidden;position:absolute;right:-2;top:0;
				
				height:10px;width:2px;
			}
			
			#leftmenu-top {
				position:absolute;width:128;height:87px;
			}
			
			.leftBlockHrmInfoLeft {
				width:60px;position:absolute;left:0;top:0;
				
			}
			
			.leftBlockHrmInfoCenter {
				position:absolute;left:60px;right:6px;top:0;height:87px;width:60px;
			}
			
			.leftBlockHrmInfoRight {
				position:absolute;right:0;top:0;
				
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
        	.editor{
        		border: 1px solid transparent;
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
    <input id="color" type="hidden">
			<table id="topTitle" cellpadding="0" cellspacing="0" width="100%" style='display:none'>
	<tr>
		<td width="75px">
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave()" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAs()" />
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			<!-- 签到签退用div -->
            <div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none;' valign='top'></div>            
            <div id='message_Div' style='display:none;'></div>    
            <div id="container"  style="height:100%;">
                <!--上-->
                <div id="mainTopBlockTr" class="topcolor editor" cls="topcolor">
                	<input type="text" name="togglePaletteOnly" id="togglePaletteOnly" style="display: none;">
                    <div id="head">
                        <div>
                            <div id="lftop" class="logocolor editor" cls="logocolor" tbname='SystemTemplate' field='logo' cls="logocolor" style="margin-top:-1px;float:left;width:225px;">
                            	<div class="logoArea" >
                            		
									<span>
										e-cology | <%=SystemEnv.getHtmlLabelName(83516,user.getLanguage())%>
									</span>
									
                                	<!-- main功能插件 -->
                                </div>
                            </div>
                            <div class="center" align="center" style="position:relative;z-index:1;float:left" id="topCenter">
                                <!--放置菜单区域-->
                                <div style="position: absolute;z-index: 111;height: 100%;width: 100%;top: 0px;left: 0px;"></div>
                                <jsp:include page="/systeminfo/template/e8deftop.jsp"></jsp:include>
								
                            </div>
                            <div style="position:absolute;right:0px;">
                            	<div style="position: absolute;z-index: 111;height: 100%;width: 100%;top: 0px;left: 0px;"></div>
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
                               		<div style="position: absolute;z-index: 111;height: 100%;top: 0px;left: 0px;"></div>
	                                            	<div style="width:100%;height:100%;">
	                                                   <iframe name="mainFrame" id="mainFrame" border="0"
	                                        frameborder="no" noresize="noresize"  width="100%" height="100%"
	                                        scrolling="auto" src="<%=initsrcpage%>" style="height:100%;overflow-y:hidden;"></iframe> 
	                                        <!--&nbsp;/hrm/resource/HrmResource_frm.jsp-->
	                                        </div>
	                                           
	                                     </div>
                                    <div id="leftBlockTd" style="width:225px;float:left;">
										
                                        <!--放置左侧菜单区-->
                                        <div  id="leftmenucontainer" class="leftcolor editor"   style="width:225px;overflow:hidden;"> 
                                            <div>
                                                    	
                                                    		<div id="hrmcolor" style="" class="leftMenuTop hrmcolor editor" cls="hrmcolor">
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
                                                    	
		                                                        <!--放置左侧菜单区-->
		                                                        <div style="position:relative;top:0px;"  id="leftmenucontentcontainer">
																	<div style="position: absolute;z-index: 111;height: 100%;width: 100%;top: 0px;left: 0px;"></div>
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
																	<div class="lfootitem skinsetting lfootitemlast" style="left:150px;" overclass="skinsettingover" style="border:transparent;" title="<%= SystemEnv.getHtmlLabelName(27714,user.getLanguage()) %>">
																		
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
        
       
		
		<div id="coloPanel" title="<%=SystemEnv.getHtmlLabelName(22975,user.getLanguage())%>">
			<div id="colorPicker"></div>
			<div style='text-align:center'>
				<input id="txtColorTemp" value="#ffffff">
				<input id="targetel" type="hidden" value="">
			</div>
			
		</div> 
		
		<div id="saveAsPanel">
			<wea:layout type="2Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
			      <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			      <wea:item>
			        <wea:required id="saveasnamespan" required="true">
			         <input type="text"  class="inputstyle" name="saveasname" id="saveasname" style="width:95%" onchange="checkinput('saveasname','saveasnamespan')">
			         </wea:required>
			      </wea:item>
			     
			     </wea:group>
			</wea:layout>		
			
			
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
   // setLeftBlockSize(tpLeftMenuMaxWidth, tpLeftMenuMaxHeight);
    LeftBlock_Max_Width = tpLeftMenuMaxWidth;
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

	jQuery("#lfFoot .lfootitem").hover(function(){
		jQuery(this).addClass($(this).attr("overclass"));
	},function(){
		jQuery(this).removeClass($(this).attr("overclass"));
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
	
   
    
 
  
    
});

		



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
function oppositeColor(color){
    color=color.replace('#','');
    var c16,c10,max16=15,b=[];
    for(var i=0;i<color.length;i++){   
        c16=parseInt(color.charAt(i),16);//  to 16进制
        c10=parseInt(max16-c16,10);// 10进制计算
        b.push(c10.toString(16)); // to 16进制
    }
    return '#'+b.join('');
}


function zero_fill_hex(num, digits) {
  var s = num.toString(16);
  while (s.length < digits)
    s = "0" + s;
  return s;
}


function rgb2hex(rgb) {

  if (rgb.charAt(0) == '#')
    return rgb;
 
  var ds = rgb.split(/\D+/);
  var decimal = Number(ds[1]) * 65536 + Number(ds[2]) * 256 + Number(ds[3]);
  return "#" + zero_fill_hex(decimal, 6);
}	


jQuery(document).ready(function(){
	jQuery(".editor").css("border-color",jQuery(".editor").css("background-color"))
	$(".editor").each(function(){
   		$(this).css("border-color",$(this).css("background-color"))
   		//jQuery(this).width(jQuery(this).width()-2)
		jQuery(this).height(jQuery(this).height()-2)
	  });
	
	jQuery(".editor").hover(
		function(event){
			var color = $(this).css("background-color");
			color = rgb2hex(color)
			//alert(color)
			color = oppositeColor(color)
			//alert(color)
			jQuery(this).css("border-color",color)
			jQuery(this).css("border-width","1px")
			jQuery(this).css("cursor","pointer");
			jQuery(this).css("border-style","dashed");
			
		},function(event){
			var color = rgb2hex($(this).css("background-color"));
			
			jQuery(this).css("border-color","transparent")
			
			jQuery(this).css("cursor","normal");
			
		}
	)

	
var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
/*RGB颜色转换为16进制*/
String.prototype.colorHex = function(){
	var that = this;
	if(/^(rgb|RGB)/.test(that)){
		var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
		var strHex = "#";
		for(var i=0; i<aColor.length; i++){
			var hex = Number(aColor[i]).toString(16);
			if(hex === "0"){
				hex += hex;	
			}
			strHex += hex;
		}
		if(strHex.length !== 7){
			strHex = that;	
		}
		return strHex;
	}else if(reg.test(that)){
		var aNum = that.replace(/#/,"").split("");
		if(aNum.length === 6){
			return that;	
		}else if(aNum.length === 3){
			var numHex = "#";
			for(var i=0; i<aNum.length; i+=1){
				numHex += (aNum[i]+aNum[i]);
			}
			return numHex;
		}
	}else{
		return that;	
	}
};

	var colorDialog = new Dialog();
	$(".editor").bind("click",function(event){
		var color = $(this).css("background-color");
		$("#txtColorTemp").val(rgb2hex(color));
		
		$("#targetel").val($(this).attr("id"));
		//jQuery.farbtastic('#colorPicker').linkTo('#txtColorTemp');
		
		$("#colorPicker").spectrum({
       			showPalette:true,
                showInput:true,
                allowEmpty:false,
                preferredFormat: "hex",
                chooseText:"<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>",
                cancelText:"<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>",
                color:color,
                noclickhide:true,
                hide: function(color) {
                	color = color.toHexString(); // #ff0000
				    var el = $("#targetel").val();
					$("#"+el).style("background-color",color,"important");
					$("#"+el).style("border-color",color,"important");
				   colorDialog.close();
				},
                move: function(color) {
					    color = color.toHexString(); // #ff0000
					    var el = $("#targetel").val();
						$("#"+el).style("background-color",color,"important");
						$("#"+el).style("border-color",color,"important");
					    
				},
				
				    palette: [
				        ["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
				        ["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
				        ["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
				        ["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
				        ["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
				        ["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
				        ["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
				        ["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
				    ]
				});

		colorDialog.currentWindow = window;   //传入当前window
	 	colorDialog.Width = 352;
	 	colorDialog.Height = 218;
	 	colorDialog.normalDialog = false;
	 	colorDialog.Modal = true;
	 	colorDialog.maxiumnable=false;
	 	colorDialog.Drag = false;
	 	colorDialog.opacity=0;
	 	colorDialog.CancelEvent=function(){
	 		$(".sp-cancel").hide();
	 	}
	 	colorDialog.Title = "<%=SystemEnv.getHtmlLabelName(22975,user.getLanguage())%>"; 
	 
	 	colorDialog.InvokeElementId = "coloPanel"
	 	colorDialog.show();
	 	$("#colorPicker").trigger("click");
	 	event.stopPropagation();
	});
	
	
	
	function doColorPick(){
		//alert("1")
		var color = $("#txtColorTemp").val()
		
		var el = $("#targetel").val();
		$("#"+el).style("background-color",color,"important");
		
		colorDialog.close();
	}
	
})

	
	
function doSave(){

	var topcolor = rgb2hex($(".topcolor").css("background-color"));
	var hrmcolor = rgb2hex($(".hrmcolor").css("background-color"));
	var leftcolor = rgb2hex($(".leftcolor").css("background-color"));
	var logocolor = rgb2hex($(".logocolor").css("background-color"));
	$.post("/systeminfo/template/themeOperation.jsp",
	{method:'save',id:'<%=id%>',logocolor:logocolor,hrmcolor:hrmcolor,leftcolor:leftcolor,topcolor:topcolor},function(){
		parent.parent.Dialog.close()
	})
	
}



function doSaveAs(){
		var saveAsDialog = new Dialog();
		saveAsDialog.currentWindow = window;   //传入当前window
	 	saveAsDialog.Width = 400;
	 	saveAsDialog.Height = 130;
	 	saveAsDialog.Modal = true;
	 	saveAsDialog.maxiumnable=false;
	 	saveAsDialog.Title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
	 	saveAsDialog.ShowButtonRow=true;
	 	saveAsDialog.OKEvent=function(){
	 		var name = $("#saveasname").val();
	 		var topcolor = rgb2hex($(".topcolor").css("background-color"));
			var hrmcolor = rgb2hex($(".hrmcolor").css("background-color"));
			var leftcolor = rgb2hex($(".leftcolor").css("background-color"));
			var logocolor = rgb2hex($(".logocolor").css("background-color"));
			$.post("/systeminfo/template/themeOperation.jsp",
			{method:'saveas',id:<%=id%>,name:name,logocolor:logocolor,hrmcolor:hrmcolor,leftcolor:leftcolor,topcolor:topcolor},function(data){
				data = $.parseJSON($.trim(data));
				if(data&&data.__result__===false){
					top.Dialog.alert(data.__msg__);
				}else{
					saveAsDialog.close();
					top.getDialog(parent).currentWindow.document.location.reload();
					dialog = top.getDialog(parent);
					dialog.close();
				}
			})
	 	};
	 	saveAsDialog.InvokeElementId = "saveAsPanel"
	 	saveAsDialog.show();
	 	
	 	event.stopPropagation();
	
}


(function($) {    
  if ($.fn.style) {
    return;
  }

  // Escape regex chars with \
  var escape = function(text) {
    return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
  };

  // For those who need them (< IE 9), add support for CSS functions
  var isStyleFuncSupported = !!CSSStyleDeclaration.prototype.getPropertyValue;
  if (!isStyleFuncSupported) {
    CSSStyleDeclaration.prototype.getPropertyValue = function(a) {
      return this.getAttribute(a);
    };
    CSSStyleDeclaration.prototype.setProperty = function(styleName, value, priority) {
      this.setAttribute(styleName, value);
      var priority = typeof priority != 'undefined' ? priority : '';
      if (priority != '') {
        // Add priority manually
        var rule = new RegExp(escape(styleName) + '\\s*:\\s*' + escape(value) +
            '(\\s*;)?', 'gmi');
        this.cssText =
            this.cssText.replace(rule, styleName + ': ' + value + ' !' + priority + ';');
      }
    };
    CSSStyleDeclaration.prototype.removeProperty = function(a) {
      return this.removeAttribute(a);
    };
    CSSStyleDeclaration.prototype.getPropertyPriority = function(styleName) {
      var rule = new RegExp(escape(styleName) + '\\s*:\\s*[^\\s]*\\s*!important(\\s*;)?',
          'gmi');
      return rule.test(this.cssText) ? 'important' : '';
    }
  }

  // The style function
  $.fn.style = function(styleName, value, priority) {
    // DOM node
    var node = this.get(0);
    // Ensure we have a DOM node
    if (typeof node == 'undefined') {
      return this;
    }
    // CSSStyleDeclaration
    var style = this.get(0).style;
    // Getter/Setter
    if (typeof styleName != 'undefined') {
      if (typeof value != 'undefined') {
        // Set style property
        priority = typeof priority != 'undefined' ? priority : '';
        style.setProperty(styleName, value, priority);
        return this;
      } else {
        // Get style property
        return style.getPropertyValue(styleName);
      }
    } else {
      // Get CSSStyleDeclaration
      return style;
    }
  };
})(jQuery);
</script>
