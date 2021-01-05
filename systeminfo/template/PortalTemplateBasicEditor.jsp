<%@page import="weaver.login.LoginMsg"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.hrm.User,
                 weaver.rtx.RTXExtCom,
				 weaver.rtx.RTXConfig,
                 weaver.hrm.settings.BirthdayReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.systeminfo.setting.HrmUserSettingHandler,
                 weaver.systeminfo.setting.HrmUserSetting,
                 weaver.general.TimeUtil,
				 weaver.login.Account" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*,HT.HTSrvAPI,java.math.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.Prop" %>
<%@page import="weaver.page.PageUtil"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/template/templateCss.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ include file="/times.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="autoPlan" class="weaver.hrm.performance.targetplan.AutoPlan" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page" />

<%
//Map pageConfigKv = getPageConfigInfo(session, user);
String logoTop ="";
String logoBtm = "";
String islock = "";
String bodyBg ="";
String topBgImage = "";
String toolbarBgColor ="";
String templateId = Util.null2String(request.getParameter("templateid"));
String init =Util.null2String(request.getParameter("init"));
String skin = Util.null2String(request.getParameter("skin"));
String isSoft = Util.null2String(request.getParameter("isSoft"));
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


rs.executeSql("select * from SystemTemplateTemp where id = "+templateId);

if(rs.next()){
	templateType = rs.getString("templateType");
	TemplateTitle = rs.getString("TemplateTitle");
	tempatename = rs.getString("TemplateName");
	extendtempletid = rs.getString("extendtempletid");
	ecology7themeid = rs.getString("ecology7themeid");
	logoTop =  rs.getString("logo");
	logoBtm = rs.getString("logobottom");
}

String pslSkinfolder = skin;


if (bodyBg.equals("")) {
	if(!isSoft.equals("true")){
		bodyBg = "/wui/theme/ecologyBasic/page/images/bodyBg_wev8.png";
	}else{
		bodyBg = "/wui/theme/ecologyBasic/page/images/bodyBg_wev8.png";
	}
}

if (topBgImage.equals("")) {
	if(!isSoft.equals("true")){
		topBgImage = "/wui/theme/ecologyBasic/page/images/headBg_wev8.jpg";
	}else{
		topBgImage = "/wui/theme/ecologyBasic/page/images/headBg_wev8.jpg";
	}
	
}

if (toolbarBgColor.equals("")) {
	toolbarBgColor = "/wui/theme/ecologyBasic/page/images/toolbarBg_wev8.png";
}

%>
<%
String username = ""+user.getUsername() ;
String userid = ""+user.getUID() ;
String usertype = "" ;

%>



<html>
<head>
<title><%=templateTitle%> - <%=username%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">

<script language=javascript>
	var glbreply = true;
</script>


<style id="popupmanager">
#rightMenu{
	display:none;
}
#arrowBoxUp{
	text-align:center;
	border-left: 1px solid #666666;
	border-right: 1px solid #666666;
	border-top:1px solid #666666;
	background-color: #F9F8F7;
	display:none;
}
#arrowBoxDown{
	text-align:center;
	border-left: 1px solid #666666;
	border-right: 1px solid #666666;
	border-bottom:1px solid #666666;
	background-color: #F9F8F7;
	display:none;
}
.popupMenu{
	width: 100px;
	border: 1px solid #666666;
	background-color: #F9F8F7;
	padding: 1px;
}
.popupMenuTable{
	background-image: url(/images/popup/bg_menu_wev8.gif);
	background-repeat: repeat-y;
}
.popupMenuTable TD{
	font-family:MS Shell Dlg;
	font-size: 12px;
	cursor: default;
}
.popupMenuRow{
	height: 18px!important;
	
}
.popupMenuRowHover{
	height: 18px!important;
	
	background-color: #B6BDD2;
}
.popupMenuSep{
	background-color: #A6A6A6;
	height:1px;
	width: 70;
	position: relative;
	left: 28;
}
</style>


<style type="text/css">
/* 搜索控件用css */
.searchkeywork {width: 74px;font-size: 12px;height:22px;margin-top:1;margin-left:-2px;background:none;border:none;color:#333;top:0;margin:0;padding:1;padding-top:3px;}
.dropdown {margin-left:5px; font-size:11px; color:#000;height:23px;margin:0;padding:0;padding-top:2px;}
.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px; }
.selectContent { position:relative;z-index:6; }
.dropdown a, .dropdown a:visited { color:#816c5b; text-decoration:none; outline:none;}
.dropdown a:hover { color:#5d4617;}
.selectTile a:hover { color:#5d4617;}
.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
.selectTile a span {cursor:pointer; display:block; padding:0 0 0 0;background:none;}
.selectContent ul { background:#fff none repeat scroll 0 0; border:1px solid #828790; color:#C5C0B0; display:none;left:0px; position:absolute; top:2px; width:auto; min-width:50px; list-style:none;}
.dropdown span.value { display:none;}
.selectContent ul li a { padding:0px 0 0px 2px; display:block;margin:0;width:60px;}
.selectContent ul li a:hover { background-color:#3399FF;}
.selectContent ul li a img {border:none;vertical-align:middle;margin-left:2px;}
.selectContent ul li a span {margin-left:5px;}
.flagvisibility { display:none;}

.editor{
	border:1px solid transparent;
}
</style>

<script type="text/javascript">
// 搜索控件用js
jQuery(document).ready(function() {
		jQuery(".dropdown img.flag").addClass("flagvisibility");

        jQuery(".selectTile a").click(function() {
            jQuery(".selectContent ul").toggle();
        });
                    
        jQuery(".selectContent ul li a").click(function() {
            var text = jQuery(this).children("span").html();
            jQuery("#basicSearchrTypeText").html(text);
            jQuery("input[name='searchtype']").val(jQuery(this).children("span").attr("searchType"));
            jQuery(".selectContent ul").hide();
        });
                    
        function getSelectedValue(id) {
            return jQuery("#" + id).find("selectContent a span.value").html();
        }

        jQuery(document).bind('click', function(e) {
            var $clicked = jQuery(e.target);
            if (! $clicked.parents().hasClass("dropdown"))
                jQuery(".selectContent ul").hide();
        });


        jQuery("#flagSwitcher").click(function() {
            jQuery(".dropdown img.flag").toggleClass("flagvisibility");
        });
});		

window.onresize = function winResize() {
	if (jQuery("#mainBody").width() <= 1024 ) {
		jQuery("#topMenuTbl").css("width", "1019px");
	} else {
		jQuery("#topMenuTbl").css("width", jQuery("#mainBody").width() - 5);
	}
}	

jQuery(document).ready(function(){
   jQuery("#mainBody").css("background","url(<%=bodyBg %>) repeat-y");
});

</script>


	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>

<script language=javascript> 

function showThemeListDialog(){
	var themeDialog = new Dialog();
	themeDialog.Width = 500;
	themeDialog.Height = 440;
	themeDialog.ShowCloseButton=true;
	themeDialog.Title = "<%=SystemEnv.getHtmlLabelName(27714,user.getLanguage())%>";
	themeDialog.Modal = false;
	themeDialog.URL = "/wui/theme/ecology7/page/skinList.jsp";
	themeDialog.show();
}
</script> 
	
<script language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body id="mainBody"  text="#000000"  style="overflow: hidden;" scroll="no" oncontextmenu="return false;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/favourite/FavouriteShortCut.jsp" %>
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
<script>   
  var con=null;
  window.onbeforeunload=function(e){	
	  if(typeof(isMesasgerUnavailable) == "undefined") {
		     isMesasgerUnavailable = true; 
	  }  
	  if(!isMesasgerUnavailable && glbreply == true){
	  	return "<%=SystemEnv.getHtmlLabelName(24985,user.getLanguage())%>";
	  }	
	  e=getEvent(); 
	  var n = e.screenX - e.screenLeft;
	  var b = n > document.documentElement.scrollWidth-20;  
	  if(b && e.clientY < 0 || e.altKey){
	  	e.returnValue = "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>"; 
	  }
  }  
  </script>
<iframe id="downLoadReg" style="display: none;"></iframe>  
<div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none' valign='top'>
</div>

<div id='message_Div' style='display:none'>
</div>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="71px" id="topMenuTd">
		<Table id="topMenuTbl" height="100%" width="100%" cellspacing="0" cellpadding="0" style="background:url(<%=topBgImage %>) repeat-x;">
			<tr id="topMenuLogo" height="43px">
				<td  width="198px" height="43px" class="editor" dfvalue="/wui/theme/ecologyBasic/page/images/logo_up_wev8.png"  tbname='SystemTemplate' field='logo' style=" position:relative;background:url(<%=(logoTop == null || logoTop.equals("")) ? "/wui/theme/ecologyBasic/page/images/logo_up_wev8.png" : logoTop %>) no-repeat;">
				&nbsp;
				</td>
				<td width="*">
				</td>
			</tr>
			<%
					String logoBtmImgSrc="";
		            if (logoBtm == null || logoBtm.equals("")) {
		            	logoBtmImgSrc = "/wui/theme/ecologyBasic/page/images/logo_down_wev8.png";
		           
		            } else {
		            	logoBtmImgSrc = logoBtm;
					
		            }
					%>
			<tr height="28px">
				<td height="28px" class="editor" tbname='SystemTemplate' dfvalue="/wui/theme/ecologyBasic/page/images/logo_down_wev8.png" field='logobottom' width="198px" style="background:url(<%=logoBtmImgSrc %>) no-repeat;">
				</td>
				<td width="*" height="28px" style="">
					
					<table height="28px" width="100%"  cellspacing="0" cellpadding="0" style='background:url(<%=toolbarBgColor %>) repeat-x'>
						<tr>
							<td height="100%" width="680px" align="left">
								<table  height=100% border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width=23 align="center" >
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/BP_Hide_wev8.png) no-repeat;" id="LeftHideShow" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></td></tr></table>
										</td>
											<td width=23 align="center">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/BP2_Hide_wev8.png) no-repeat;" id="TopHideShow" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></td></tr></table>
										</td>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/LogOut_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"></span></td></tr></table><!--退出-->
										</td>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu"  style="position:relative;"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Back_wev8.png) no-repeat" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>"></span></td></tr></table><!--后退-->
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle" >
											<table style="position:relative;" class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Pre_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>"></span></td></tr></table><!---->
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Refur_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>"></span></td></tr></table><!--刷新-->
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table style="position:relative;" class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Print_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>"></span></td></tr></table><!--打印-->
										</td>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<td width="50px" id="favouriteshortcutid" style="position:relative;padding-top:6px">
											<span id="favouriteshortcutSpan" style="color:#fff;text-align:center;padding-top:5px;border:none">
												<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage()) %>
											</span>
											<span class="toolbarBgSpan" style="position:absolute;width:10px;height:6px;border:none;margin-top:5px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/favorites_slt_wev8.png) no-repeat;">
											</span>
										</td>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<!-- 搜索block start -->			
										<td width="143px" style="padding-top:2px;">
					                        <form name="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
								            <TABLE cellpadding="0px" cellspacing="0px" height="23px" width="100%" align="right" style="position:relative;z-index:6;" id="searchBlockTBL">
								                <tr height="100%" style="background: url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchBg_wev8.png) center repeat;">
								                    <td width="40px" height="100%" style="margin:0;padding:0;">
								                        <input type="hidden" name="searchtype" value="1">
								                        <div id="sample" class="dropdown" style="position:relative;top:1px;">
								                            <div class="selectTile" style="height: 100%;vertical-align: middle;">
									                            <a><span style="float:left;width:25px;display:block;" id="basicSearchrTypeText"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span>
																	<TABLE cellpadding="0px" cellspacing="0px" height="4px" width="8px" align="center">
																		<tr>
																			<td width="8px" height="4px" valign="middle" >
																			
																				<div style="position:absolute;overflow:hidden;display:block;width:8px;top:10px;left:36px;height:8px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchSlt_wev8.png) no-repeat;" class="toolbarSplitLine"></div>
																			
																			</td>
																		</tr>
																	</TABLE>
																</a>
															</div>
								                            <div class="selectContent1" style="display: none">
								                                <ul id="searchBlockUl">
								                                    <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/doc_wev8.gif"/><span searchType="1"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span></a></li>
								                                    <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/hr_wev8.png"/><span searchType="2"><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></span></a></li>
								                                    <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/crm_wev8.gif"/><span searchType="3"><%=SystemEnv.getHtmlLabelName(30043,user.getLanguage())%></span></a></li>
								                                    <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/zc_wev8.gif"/><span searchType="4"><%=SystemEnv.getHtmlLabelName(30044,user.getLanguage())%></span></a></li>
								                                    <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/wl_wev8.png"/><span searchType="5"><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></span></a></li>
								                                    <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/p_wev8.gif"/><span searchType="6"><%=SystemEnv.getHtmlLabelName(30046,user.getLanguage())%></span></a></li>
								                                    <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/mail_wev8.gif"/><span searchType="7"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></span></a></li>
					                                                <li><a><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/xz_wev8.gif"/><span searchType="8"><%=SystemEnv.getHtmlLabelName(30047,user.getLanguage())%></span></a></li>
								                                </ul>
								                            </div>
								                        </div>
								                    </td>
								                      <td width="74px">
								                        
								                    </td>
								                    <td width="22px" style="position:relative;">
								                        <span id="" style="top:4px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchBt_wev8.png)  no-repeat;display:block;width:16px;height:16px;overflow:hidden;cursor:hand;"></span>
								                    </td>
								                </tr>
								            </table>
								            </form>
					                    </td>
										<!-- 搜索block end -->
										<td width="10px">
										</td>
										<td>
										    
										</td>
									</tr>
								</table>
							</td>
							<td align="right" style="">
		<table height=100% border="0" cellspacing="0" cellpadding="0" >
			<tr>
			<td width=23 align="center" >
				<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Home_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%>"></span></td></tr></table><!--首页-->
			</td>
			
         <!-- 页面模板选择开始-->
		<td style="width:10;height:28px;"></td>
	    <td style="width:23;height:28px;z-index:1;" align="left" valign="middle">
	    	<div style="position:relative;">
			<table class="toolbarMenu" >
			<tr>
			<td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';" ><span class="toolbarBgSpan" style="top:6px;left:4px;display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/ThemeSlt_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(84105,user.getLanguage())%>"></span>
			</td>
			</tr>
			</table><!--皮肤-->
			
			</div>
		</td>
         <!-- 页面模板选择结束-->

			<td width=10 align="center" style="position:relative;">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
			</td>
			<td width=30 align="center" style="z-index:1;">
						<div style="position:relative;">
						<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="left:4;top:4px;display:block;width:23px;height:22px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMore_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>"></span></td></tr></table>
			        	<div id="toolbarMore" style="display:none;position:absolute;width:184px;right:8px;top:25px;">
			        		<div id="toolbarMoreBlockTop" style="overflow:hidden;width:184px;background-image:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreTop_wev8.png);height:11px;"></div>
			        		<TABLE cellpadding="2" cellspacing="0" align="center" width="100%" style="margin:0;background-image:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreCenter_wev8.jpg);background-repeat: repeat-y;">
			        			<tr><td colspan="5" height="5px"></td></tr>
				    	    	<tr align="center">
				    	    			<td width="5px"></td>
										<td width="25px" align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/msn_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(23525,user.getLanguage())%>"></td></tr></table><!---->
										</td>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plan_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>"></td></tr></table><!--我的计划-->
										</td>
										<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Mail_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%>"></td></tr></table><!--新建邮件-->
										</td>
							        	<td width=25px align="center">
											 <table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Doc_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>"></td></tr></table><!--新建文档-->
										</td>
								        <td width=23px align="center">
										    <table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/WorkFlow_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>"></td></tr></table><!--新建流程-->
										</td>
								</tr>
								<tr align="center">
										<td width="5px"></td>
							      		<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/CRM_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%>"></td></tr></table><!---->
										</td>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/PRJ_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(15007,user.getLanguage())%>"></td></tr></table><!---->
										</td>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Meeting_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(15008,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Org_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%>"></td></tr></table><!--组织结构-->
										</td>	
									</tr>
									<tr align="center">	
										<td width="5px"></td>
										<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plugin_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>"></td></tr></table><!--插件-->
										</td>
										<td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/rtx_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(83530,user.getLanguage())%>"></td></tr></table><!---->
										</td>
							         	<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Version_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>"></td></tr></table><!--版本-->
										</td>
										<td width=25px align="center">
										    <table class="toolbarMenu"><tr><td onmouseover1="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/safeSite_wev8.png" width="15px" title="Ecology<%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%>"></td></tr></table><!--版本-->
										</td>
										<td>
										</td>
							    	</tr>
							   
							    <tr><td colspan="5" height="5px"></td></tr>
			        		</TABLE>
			        		<TABLE cellpadding="0px" cellspacing="0px" height="5px" width="100%" style="background:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreBottom_wev8.png) no-repeat;"><tr><td height="5px"></td></tr></TABLE>
						</div>
						</div>
			        </td>
			</tr>
		</table>
		</td>
						</tr>
					</table>
				</td>
			</tr>
		</Table>
		<div id="divFavContent" style="position: absolute;z-index: 1000; bottom:10;left:100">
	<div class="popupMenu">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="popupMenuTable">
		<tr height="26">
			<td class="popupMenuRow" onmouseover1="this.className='popupMenuRowHover';" onmouseout="this.className='popupMenuRow';" id="popupWin_Menu_Setting">
				<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
					<tr>
						<td width="28">&nbsp;</td>
						<td ><%=SystemEnv.getHtmlLabelName(18166,user.getLanguage())%></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="3">
			<td>
				<div class="popupMenuSep"><img height="1px"></div>
			</td>
		</tr>
	</table>
	</div>
</div>
	</td>	
</tr>
<tr>
	<td style="padding:0px 0px 0px 0px;">
		
		<table height="100%" width="100%" style="table-layout: fixed;">
		<tr>
			<td width="184px;" class="leftmenu"  style="overflow:hidden;border:1px solid transparent; " >
				<div style="width: 184px;height: 100%;position: absolute;"></div>
				<iframe height="100%" style="overflow:hidden; " id="leftmenuframe"  scrolling="NO" width="100%" frameborder=0 src=/wui/theme/ecologyBasic/page/leftMenu/leftForEditor.jsp></iframe>
			</td>
			<td width="*">
			<%
			PageUtil pc = new PageUtil();
			String url = pc.getHomepageUrl(user,false);
			url = url.replace("Homepage.jsp","HomepageEditor.jsp");
			url = url+"&skin=ecologyBasic";
			%>
				<iframe height="100%" frameborder=0 id="mainframe" scrolling="NO"  width="100%" border=0 src="<%=url %>"></iframe>
			</td>
		</tr>
		</table>
		
		
	</td>
</tr>
</table>
<script>
function onLoadComplete(ifm){
	if(ifm.readyState=="complete") {   
		if(ifm.contentWindow.location.href.indexOf("Homepage.jsp")!=-1){
			return;
		}
        try{
			 if( ifm.contentWindow.document.body.clientHeight>document.body.clientHeight){
				  ifm.style.height = document.body.clientHeight;
			 }else{
				  ifm.style.height = ifm.contentWindow.document.body.clientHeight;		 
			 }
		 }catch(e){}
 	}
}

document.oncontextmenu=""
//search.searchvalue.oncontextmenu=showRightClickMenu1

function showRightClickMenu1(){
	var o = document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame");
    if(o.workSpaceLeft!=null)
		o.workSpaceLeft.rightMenu.style.visibility="hidden";
    if(o.workSpaceInfo!=null)
        o.workSpaceInfo.rightMenu.style.visibility="hidden";
    if(o.workSpaceRight!=null)
		o.workSpaceRight.rightMenu.style.visibility="hidden";
    if(o.workplanLeft!=null)
        o.workplanLeft.rightMenu.style.visibility="hidden";
    if(o.workplanRight!=null)
		o.workplanRight.rightMenu.style.visibility="hidden";
        showRightClickMenu();
}
</script>
</body>
<SCRIPT language=javascript>

jQuery(document).ready(function(){
	jQuery("table").each(function(){
		$(this).css("height",$(this).parent().height())
	})
	$("#leftmenuframe").height($("#leftmenuframe").parent().height())
	$("#mainframe").height($("#mainframe").parent().height())
	

	jQuery(".leftmenu,.editor").hover(
		function(){
			jQuery(this).css({"border":"1px dashed red","cursor":"pointer"});
			
		},function(){
			jQuery(this).css({"border":"1px dashed transparent","cursor":"normal"});
			
		}
	)
	
	$(".editor").bind("click",function(event){
		var type = $(this).attr("type");
		showImageDialog($(this));
		event.stopPropagation();
		return false;
					
	});
	
	jQuery(".leftmenu").bind("click",function(event){
		
		onOrder();
		//event.stopPropagation();
		//return false;
	})
	
	jQuery(".leftmenueidtor").bind("click",function(event){
		onEditLeftMenu();
		//event.stopPropagation();
		//return false;
	})
	
	function onOrder(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(24668,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepageLocation.jsp";
	 	showDialog(title,url,600,500,true);
	}
	
	
	
	/*图片文件选择框回调函数*/
	function doImageDialogCallBack(obj,datas){
		var	path=datas.id;
		
		if(path==undefined){
			path=''
		}
		var type = $(obj).attr("type");
		var field = $(obj).attr("field");
		if(path!=''){
			if(type=="src"){
				$(obj).attr("src",path);
			}else{
				$(obj).css("background-image","url('"+path+"')")
			}
		}else{
			
			if(type=="src"){
				$(obj).attr("src",$(obj).attr("dfvalue"));
			}else{
				$(obj).css("background-image","url('"+$(obj).attr("dfvalue")+"')")
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
})
function updateTempData(tbname,field,value,menuid){
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp",
	{method:'update',tbname:tbname,field:field,value:value,levelid:menuid},function(){
	})
}
function insertToPopupMenu(o){
	//alert(o.src)
	var tbl,tbl2,tr,td;
	tbl = document.createElement("table");
	
	tbl.cellspacing = 0;
	tbl.cellpadding = 0;
	tbl.width = "100%";
	tbl.height = "100%";
	tr = tbl.insertRow(-1);
	td = tr.insertCell(-1);
	td.width = 20;
	td.innerHTML = "<img src='"+o.src+"' width='16' heigh='16'/>";
	td = tr.insertCell(-1);
	//td.algin='left';
	td.innerHTML = o.getAttribute("menuname");
	//alert(jQuery(".popupMenuTable").length)
	tbl2 = jQuery(".popupMenuTable").get(0);
	//alert(tbl2.tagName)
	tr = tbl2.insertRow(-1);
	//tr.height="21px";
	td = tr.insertCell(-1);
	tr.height = 21;
	td.onclick = function(){slideFolder(this);};
	td.onmouseover = function(){this.className='popupMenuRowHover';};
	td.onmouseout = function(){this.className='popupMenuRow';};
	td.className = "popupMenuRow";
	td.setAttribute("menuid",o.getAttribute("menuid"));
	td.appendChild(tbl);
}

jQuery("#divFavContent").bind('mouseout',function(e){
	if(isMouseLeaveOrEnter(e, this)) {hideLeftMoreMenu(e);}
	
});

function isMouseLeaveOrEnter(e, handler) {
	e = jQuery.event.fix(e); 
    if (e.type != 'mouseout' && e.type != 'mouseover') return false;
    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
    while (reltg && reltg != handler)  {
        reltg = reltg.parentNode;
     }
    return (reltg != handler);
}

function hideLeftMoreMenu(){	
	jQuery("#divFavContent").hide();
	return false;
}
function goSetting(){
	jQuery("#mainFrame",jQuery("#leftFrame")[0].contentWindow.document)[0].src='/systeminfo/menuconfig/CustomSetting.jsp'
}


function mnToggleleft(){
	var o = document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrameSet");
	if(o.cols=="0,*"){
		var iMenuWidth=134;
		var iLeftMenuFrameWidth=Cookies.get("iLeftMenuFrameWidth");	
		if(iLeftMenuFrameWidth!=null) iMenuWidth=iLeftMenuFrameWidth;
		try{
			if(jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox")){
				jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox").style.display = "block";
			}
			o.cols = iMenuWidth+",*";
			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").noResize = false;
			document.getElementById("leftFrame").contentWindow.document.getElementById("LeftMenuFrame").noResize = false;
			
			LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";//隐藏
		}catch(e){
			window.status = e;
		}		
	}else{		
		try{
			if(jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox")){
		    	jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox").style.display = "none";
			}
			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").noResize = true;
			document.getElementById("leftFrame").contentWindow.document.getElementById("LeftMenuFrame").noResize = true;
			
			o.cols = "0,*";
			LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示
		}catch(e){
			alert(e)
			window.status = e;
		}
	}
	//add by lupeng 2004.04.27 for TD315
	//leftFrame.location.reload();//重新load左边按钮
	//end
}

function mnToggletop(){
	if(topMenuLogo.style.display == ""){
		jQuery("#topMenuTd").height(28);
		if(document.getElementById("logoBottom")!=null){
			logoBottomSpan.style.display = "block";
			logoBottom.style.display = "none";
			jQuery("#bgy").css("top", jQuery("#bgy").offset().top - 43);
			jQuery("#toolbarBg").css("top", 0);
		}
		topMenuLogo.style.display = "none";
		topMenu.style.height = "28px";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示

	}
	else{
		jQuery("#topMenuTd").height(71);
		if(document.getElementById("logoBottom")!=null){
			logoBottomSpan.style.display = "none";
			logoBottom.style.display = "block";
			jQuery("#bgy").css("top", jQuery("#bgy").offset().top + 43);
			jQuery("#toolbarBg").css("top", 43);
		}
		topMenuLogo.style.display = "";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";//隐藏
	}
	//leftFrame.location.reload();//重新load左边按钮
}

function slideFolder(o){

	//jQuery("#leftFrame").contentWindow.document.getElementById("mainFrame")
	jQuery("#LeftMenuFrame",jQuery("#leftFrame")[0].contentWindow.document)[0].contentWindow.slideFolder(o);
	
}

function goUrl(url){
	document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").src = url;
}

var chatwindforward;


function goUrlPopup(o){
	var url = o.getAttribute("url");
	parent.document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").src = url;
}
function goopenWindow(url){
  var chasm = screen.availWidth;
  var mount = screen.availHeight;
  if(chasm<650) chasm=650;
  if(mount<700) mount=700;
  window.open(url,"PluginCheck","scrollbars=yes,resizable=no,width=690,Height=650,top="+(mount-700)/2+",left="+(chasm-650)/2);
}
function isConfirm(LabelStr){
if(!confirm(LabelStr)){
   return false;
}
   return true;
}

function toolBarLogOut() //退出
{
	var LabelStr= "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>" ;
	<%/* TD4406 modified by hubo,2006-07-10 */%>
	//if(isConfirm(LabelStr)) location.href="/login/Logout.jsp";
	<%/* TD5713 modified by fanggsh,2007-01-09 */%>
	if(isConfirm(LabelStr)){ 
		//mainBody.onbeforeunload=null;
		mainBody.onunload=null;
		location.href="/login/Logout.jsp";
	}

}

function ajaxInit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function signInOrSignOut(signType){
    if(signType != 1){
	    var ajaxUrl = "/wui/theme/ecology7/page/getSystemTime.jsp";
		ajaxUrl += "?field=";
		ajaxUrl += "HH";
		ajaxUrl += "&token=";
		ajaxUrl += new Date().getTime();
		
		jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    contentType : "charset=UTF-8", 
		    error:function(ajaxrequest){}, 
		    success:function(content){
		    	var isWorkTime = jQuery.trim(content);
		    	if (isWorkTime == "true" && !confirm('<%=SystemEnv.getHtmlLabelName(26273, user.getLanguage())%>')) {
		            return;
		        }
		    	writeSignStatus(signType);
		    }  
	    });
    } else {
    	writeSignStatus(signType);
    }
}

function writeSignStatus(signType) {
	var ajax=ajaxInit();
    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp?t="+Math.random(), true); 
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("signType="+signType);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	signInOrSignOutSpan.innerHTML='<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%>';
                showPromptForShowSignInfo(ajax.responseText, signType);
                jQuery("#signInOrSignOutSpan").attr("_signType", 2);
            }catch(e){
            }
        }
    }
}


var showTableDiv  = document.getElementById('divShowSignInfo');
var oIframe = document.createElement('iframe');


//type  1:显示提示信息
//      2:显示返回的历史动态情况信息
function showPromptForShowSignInfo(content, signType){
    var targetSrc = "";
	content = jQuery.trim(content).replace(/&nbsp;/g, "");
	var confirmContent = "<div style=\"margin-left:5px;margin-right:5px;\">" + content.substring(content.toUpperCase().indexOf('<TD VALIGN="TOP">') + 17, content.toUpperCase().indexOf("<BUTTON"));
	
    var checkday="";
	if(signType==1) checkday="prevWorkDay";
	if(signType==2) checkday="today";
	jQuery.post("/blog/blogOperation.jsp?operation=signCheck&checkday="+checkday,"",function(data){
		var dataJson=eval("("+data+")");
		if (dataJson.isSignRemind==1){
		    if(!dataJson.prevWorkDayHasBlog&&signType==1){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26987,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}else if(!dataJson.todayHasBlog&&signType==2){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26983,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}
			
			confirmContent += "</div>";
			if (targetSrc != undefined && targetSrc != null && targetSrc != "") {
				Dialog.confirm(
					confirmContent, function (){
						window.open(targetSrc);
					}, function () {}, 520, 90,false
			    );
			} else {
				Dialog.alert(confirmContent, function() {}, 520, 60,false);
			}
			
		    return ;
		}
		confirmContent += "</div>";
		Dialog.alert(confirmContent, function() {}, 520, 60,false);
    });
}

function onCloseDivShowSignInfo(){
	divShowSignInfo.style.display='none';
	message_Div.style.display='none';
	document.all.HelpFrame.style.display='none'
}
var firstTime = new Date().getTime();
function onCheckTime(obj){
	window.location = "/login/IdentityShift.jsp?shiftid="+obj.value;
}


</SCRIPT>
</html>
<script language="javascript" src="/js/Cookies_wev8.js"></script>