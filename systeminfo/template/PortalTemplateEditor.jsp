
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
String frompage = Util.null2String(request.getParameter("frompage"));
int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
String logintype = Util.null2String(user.getLogintype()) ;
int isIncludeToptitle = 0;
String titlename = "";
int templateId = Util.getIntValue(request.getParameter("templateid"));
String init =Util.null2String(request.getParameter("init"));
String skin = Util.null2String(request.getParameter("skin"));
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

String pslSkinfolder = skin;

String curTheme = "ecology7";



/**
 * 系统主题、皮肤
 */


request.setAttribute("REQUEST_SKIN_FOLDER", pslSkinfolder);

Map pageConfigKv = getPageConfigInfo(session, user);


%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title></title>
		<!--For Base-->
		<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/<%=pslSkinfolder%>/wui_wev8.css'/>
		<link rel="stylesheet" type="text/css" href="/wui/common/css/base_wev8.css" />
		<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>

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
                WIDTH:100%;height:100%;
                   /*border-collapse:collapse;*/
            }
            #contentContainer #content{
                WIDTH:100%;height:100%;
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
            #leftmenucontainer{
            	background:#B1D4D8;
            }
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
			#searchbt{
				display:none!important;
			}

        </STYLE>
		
		<script type="text/javascript">
		window.onresize = function winResize() {
			if (jQuery("#mainBody").width() <= 1024 ) {
				jQuery("#container").css("width", "1020px");
			} else {
				jQuery("#container").css("width", jQuery("#mainBody").width() - 4);
			}
		}		
		jQuery(document).ready(function(){
		     jQuery("#mainBody").css("background","url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y");
		});
		//background:url('/wui/theme/ecology7/skins/<%=pslSkinfolder %>/page/main/body-bg_wev8.png') repeat-y;
		</script>
    </head>
        
    
<!-- 锁定整个界面的CSS2011/5/19 -->

    <body id="mainBody" scroll="no"  style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
            <table id="container"  height="70px" cellspacing="0" cellpadding="0">
                <!--上-->
                <tr id="mainTopBlockTr"><td  height="70px" valign="top"> 
                    <table id="head" cellspacing="0" cellpadding="0" class="editor1" tbname='SystemTemplate' field='topbgimage' type='background-image'>
                        <tr>
                            <td width="270px">
                            	<div style="height:70px;overflow:hidden;">
                                	<!-- main功能插件 -->
                                </div>
                            </td>
                            <td width="*" class="center" align="center" style="position:relative;z-index:1;">
                                <!--放置菜单区域-->
								<jsp:include page="e7deftop.jsp">
									<jsp:param name="templateid" value="<%=templateId %>"/>
									<jsp:param name="subCompanyId" value="<%=subCompanyId %>"/>
									<jsp:param name="skin" value="<%=pslSkinfolder %>"/>
								</jsp:include>
                            </td>
                            <td width="300px" class="toolbarEditor" type='background-image' tbname='SystemTemplate' field='toolbarbgimage' >
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
                                                    				<div id="leftmenu-top" style="" class="" tbname='SystemTemplate' field='leftbarbgimage' type='background-image'>
                                                    					<div class="leftBlockHrmInfoLeft"></div>
                                                        				<div id="leftBlockHrmInfoCenter" class="leftBlockHrmInfoCenter"></div>
                                                        				<div class="leftBlockHrmInfoRight"></div>
                                                    				</div>
                                                    				<div id="leftBlock_HrmDiv">
	                                                    				<!--放置即时通讯相关的东西-->
<div style="position:relative;height:100%;width:163px;background:url(/<%=rs.getString("leftbarbgimage") %>)" class="" tbname='SystemTemplate' field='leftbarbgimage' type="background-image">
    <!-- 更换皮肤设置 Start -->
    <div  style="position:absolute;left:63px;top:5px;font-size:12px;height:16px;right:25px;">
       <span style="float:right;margin-right:2px;">
       </span>
    </div>
    <!-- 更换皮肤设置 End -->
	<div  style="position:absolute;left:63px;top:16px;font-size:12px;color:#006699;font-weight:bold" class="hrminfo_fontcolor">
	   <%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%>
	</div>
	<div id="leftBlockHrmDep" style="position:absolute;left:63px;top:37px;font-size:11px;color:#666;cursor:pointer;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:110px;" title=""></a></div>
	<div  style="position:absolute;width:41px;height:41px;left:14px;top:17px;">
		<img src="<%="".equals(rs.getString("leftmenubgimg2"))?"/messager/usericon/loginid20130509190805_wev8.jpg":"/"+rs.getString("leftmenubgimg2") %> border="0" width="38" height="37" title="<%=SystemEnv.getHtmlLabelName(28062,user.getLanguage())%>" id="userIcon" class="" tbname='SystemTemplate' field='leftmenubgimg2' type="src" style="cursor: pointer;">
	</div>
	<div  style="position:absolute;width:170px;height:18px;left:8px;top:66px;">
		<table width="100%" cellpadding="0px" cellspacing="0px" id="tblHrmToolbr" align="left">
			<tr>
				<!-- 解决因ie6下png透明引起img图片空白显示的bug -->
				<td width="24px"><a title=' <%=SystemEnv.getHtmlLabelName(84238,user.getLanguage())%>'   target="mainFrame" style><span class="editor1" tbname='SystemTemplate' field='leftmenubgimg3' type="background-image" style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(<%="".equals(rs.getString("leftmenubgimg3"))?"/wui/theme/ecology7/page/images/hrminfo/address_wev8.png":"/"+rs.getString("leftmenubgimg3")%>) no-repeat;"></span></a></td>
				<td width="24px"><a title='<%=SystemEnv.getHtmlLabelName(16415,user.getLanguage())%>' target="mainFrame" style><span class="editor1" tbname='SystemTemplate' field='leftmenubgimg4' type="background-image" style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(<%="".equals(rs.getString("leftmenubgimg4"))?"/wui/theme/ecology7/page/images/hrminfo/card_wev8.png":"/"+rs.getString("leftmenubgimg4")%>) no-repeat;"></span></a></td>
				<td width="24px"><a title='<%=SystemEnv.getHtmlLabelName(83511,user.getLanguage())%>' target="mainFrame" style><span class="editor1" tbname='SystemTemplate' field='leftmenubgimg5' type="background-image" style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(<%="".equals(rs.getString("leftmenubgimg5"))?"/wui/theme/ecology7/page/images/hrminfo/psw_wev8.png":"/"+rs.getString("leftmenubgimg5")%>) no-repeat;"></span></a></td>
				<td width="24px"><a title='<%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%>' target="mainFrame" style><span class="editor1" tbname='SystemTemplate' field='leftmenubgimg6' type="background-image" style="cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(<%="".equals(rs.getString("leftmenubgimg6"))?"/wui/theme/ecology7/page/images/hrminfo/org_wev8.png":"/"+rs.getString("leftmenubgimg6")%>) no-repeat;"></span></a></td>
				<!--  <td width="24px"><a  href="/workplan/data/WorkPlan.jsp" title='日程'  target="mainFrame" style><img  src="/wui/theme/ecology7/page/images/hrminfo/cal_wev8.gif" border="0"></a></td>-->
				<td width="*" align="left">
					<div id="tdMessageState" class="editor1" tbname='SystemTemplate' field='leftmenubgimg7' type="background-image" style="cursor:pointer;font-size:11px;color:#666;position:relative;background:url(/<%=rs.getString("leftmenubgimg7") %>)"></div>	
				</td>
				<td width="3px" align="right">
					&nbsp;
				</td>
			</tr>
		</table>
	</div>
</div>

                                                        			</div>
                                                    			</td>
                                                    		</tr>
                                                    	</table>
                                                        
                                                    </td></tr>
                                                    <tr><td style="position:relative;vertical-align: top;">
                                                    	<div id="leftmenu-bottom"></div>
                                                        <!--放置左侧菜单区-->
                                                        <div style="position:relative;top:0px;1px dashed transparent;" id="leftmennu">
															
                                                        	<jsp:include page="e7defleft.jsp">
                                                        		<jsp:param name="templateid" value="<%=templateId %>"/>
																<jsp:param name="subCompanyId" value="<%=subCompanyId %>"/>
								
                                                        	</jsp:include> 
															
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
            <img width="278px" height="70px" src="/wui/theme/ecology7/page/images/logo_wev8.png" class="editor" tbname='SystemTemplate' field='logo' dfvalue="/wui/theme/ecology7/page/images/logo_wev8.png" type='src' border="1" style="border-color:transparent;position:absolute;top:0;left:0;" id="logo"/>
			<%	
            } else {
            %>
            <img width="278px" height="70px" src="<%=logo %>" class="editor" tbname='SystemTemplate' field='logo' type='src' border="1" dfvalue="/wui/theme/ecology7/page/images/logo_wev8.png"   style="border-color:transparent;position:absolute;top:0;left:0;" id="logo"/>
            <%
            }
            %>
            <!-- 版本信息 -->
            <div class="versiontype"></div>   
    </body>
</html>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.easing_wev8.js"></script>   
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
	return;
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
	return;
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
	
	
        
	/*jQuery(".menuItem").hover(function() {
    	$this=jQuery(this);
	    jQuery("#divFloatBg").show();
	    jQuery("#divFloatBg").each(function(){jQuery.dequeue(this, "fx");}).animate({                
        top: $this.position().top -3,
        left: $this.position().left+4
    },600, 'easeOutExpo');
    }, function(){});*/
    
   
	
	jQuery("#leftmennu,.leftmenueidtor,.editor").hover(
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
	
	jQuery("#leftmennu").bind("click",function(event){
		onOrder();
		//event.stopPropagation();
		//return false;
	})
	
	jQuery(".leftmenueidtor").bind("click",function(event){
		onEditLeftMenu();
		//event.stopPropagation();
		//return false;
	})
	
	/*
	jQuery(".toolbarEditor").bind("click",function(event){
		var type = $(this).attr("type");
		showImageDialog2($(this));
		event.stopPropagation();
		return false;
	})
	*/
	
	
	
	/*图片文件选择框回调函数*/
	function doImageDialogCallBack(obj,datas){
		var	path=datas.id;
		
		if(path==undefined){
			path=''
		}
		var type = $(obj).attr("type");
		if(path==''){
			if(type=="src"){
				$(obj).attr("src",$(obj).attr("dfvalue"));
			}else{
				$(obj).css("background-image","url('"+$(obj).attr("dfvalue")+"')")
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
	
	/*图片文件选择框回调函数*/
	function doImageDialogCallBack2(obj,datas){
		var	path=datas.id;
		
		if(path==undefined||path==''){
			return false;
		}
		var type = $(obj).attr("type");
		
		
		$(".tbItm").css("background-image","url('"+path+"')")
		
		
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
	
	/*打开图片文件选择框*/
	function showImageDialog2(target){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;   //传入当前window
	 	dialog.Width = top.document.body.clientWidth-100;
	 	dialog.Height = top.document.body.clientHeight-100;
	 	dialog.maxiumnable=true;
	 	dialog.callbackfun=doImageDialogCallBack2;
	 	dialog.callbackfunParam=target;
	 	dialog.Modal = true;
	 	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32467,user.getLanguage())%>"; 
	 	dialog.URL = "/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp?isDialog=1";
	 	dialog.show();
		
	}
	
	/*jQuery(".editor").bind("click",function(event){
		var type = $(this).attr("type");
		if(type=="background-image"){
			var path = getImagePath();
			if(path==undefined||path==''){
				return false;
			}
			$(this).css({"background-image":"url('/"+path+"')","background-position":"0 0"})
			updateTempData($(this).attr('tbname'),$(this).attr("field"),path,$(this).parent().attr('levelid'));
		}
		if(type=="src"){
			var path = getImagePath();
			if(path==undefined||path==''){
				return false;
			}
			$(this).attr("src","/"+path)
			updateTempData($(this).attr('tbname'),$(this).attr("field"),path,$(this).parent().attr('levelid'));
		}
	})*/
	
	jQuery(document, '#mainFrame').ready(function(){
    	jQuery("#mainFrame").contents().find("body").bind("click",function(){alert(5)})
	})
	
	function updateTempData(tbname,field,value,menuid){
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
	{method:'update',tbname:tbname,field:field,value:value,levelid:menuid},function(){
	})
}
	
	
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

function doPreview(){
	//alert("/systeminfo/template/loginTemplatePreview.jsp?loginTemplateId=<%=templateId%>&tmpdata=Tmp")
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 700;
 	menuStyle_dialog.Height = 500;
 	menuStyle_dialog.maxiumnable=true;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
 	menuStyle_dialog.URL = "//wui/theme/ecology8/page/main.jsp?id=<%=templateId%>&tmpdata=Temp"
 	menuStyle_dialog.show();
	
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
	{method:'commit&enable',id:'<%=templateId%>',templatetype:'ecology7',subCompanyId:'<%=subCompanyId%>'},
	function(){
		parent.parent.Dialog.close()

	})
}

function edit_topmenu(obj,event){
	var menuid = jQuery(obj).parent().attr("levelid");
	var Show_dialog = new window.top.Dialog();
	Show_dialog.currentWindow = window;   //传入当前window
 	Show_dialog.Width = 860;
 	Show_dialog.Height = 650;
 	Show_dialog.maxiumnable = true;
 	Show_dialog.Modal = true;
 	Show_dialog.Title = "<%=SystemEnv.getHtmlLabelName(20603,user.getLanguage())%>";
 	Show_dialog.URL = "/systeminfo/menuconfig/CustomMenuName.jsp?type=left&resourceType=1&resourceId=1&subCompanyId=<%=subCompanyId%>&id="+menuid;
 	Show_dialog.show();
 	event = jQuery.event.fix(event);
 	stopDefault(event);
}
//阻止事件(包括冒泡和默认行为)
function stopDefault(e) {
    if(e.preventDefault) {
      e.preventDefault();
      e.stopPropagation();
    }else{
      e.returnValue = false;
      e.cancelBubble = true;
    }
}				
</script>