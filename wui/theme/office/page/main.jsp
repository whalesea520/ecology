<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="weaver.hrm.User,
                 weaver.general.TimeUtil,
				 weaver.login.Account,
				 weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" %>
<%@page import="weaver.hrm.common.Tools"%>				 
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/>
<%@page import="weaver.social.service.SocialIMService"%>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />
<%@ include file="/times.jsp" %>
<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null){
		response.sendRedirect("/login/Login.jsp");
	    return;
	}
	String mainId = "";
	
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
	
	//判断是否有微搜功能
	boolean microSearch=weaver.fullsearch.util.RmiConfig.isOpenMicroSearch();
	//读取title
	UsrTemplate.getTemplateByUID(user.getUID(), user.getUserSubCompany1());
	String templateTitle = UsrTemplate.getTemplateTitle();
	
	//------------------------------------
	//签到部分 Start
	//------------------------------------
	String[] signInfo = HrmScheduleDiffUtil.getSignInfo(user);
	boolean isNeedSign = Boolean.parseBoolean(signInfo[0]);
	String sign_flag = signInfo[1];
	String signType = signInfo[2];
	
	//判断此人今天是否需要签到提醒 判断依据 在线签到功能开启 工作日 不是管理员 在签到时间范围外
	String isSignInOrSignOut="0";//是否启用前到签退功能  
	String onlyworkday = "1";//只在工作日签到
	String signTimeScope = "";//签到是时间范围  
	boolean isWorkday=false;//是否工作日
	boolean isSyadmin=false;//是否管理员
	boolean inSignTimeScope = true;

	String CurrentDate = TimeUtil.getCurrentDateString();
	//判断分权管理员
	signRs.executeSql("select loginid from hrmresourcemanager where loginid = '"+user.getLoginid()+"'");
	if(signRs.next()){
	   isSyadmin = true;
	}

	signRs.executeSql("select needsign,onlyworkday, signTimeScope from hrmkqsystemSet ");
	if(signRs.next()){
		isSignInOrSignOut = ""+signRs.getInt("needsign");
		onlyworkday = ""+signRs.getInt("onlyworkday");
		signTimeScope = ""+signRs.getString("signTimeScope");
	}  	
	HrmScheduleDiffUtil hrmScheduleDiffUtil = new HrmScheduleDiffUtil();
	hrmScheduleDiffUtil.setUser(user);
	isWorkday = hrmScheduleDiffUtil.getIsWorkday(CurrentDate);
	if(onlyworkday.equals("0"))isWorkday=true;//如果非工作日也要签到

	//签到时间范围
	String begin_time =null;
	String end_time =null;
	if(signTimeScope.length()>0){
		String[] str = signTimeScope.split("-");
		begin_time = Tools.getCurrentDate()+" "+str[0]+":00";
		end_time = Tools.getCurrentDate()+" "+str[1]+":00";
		
		//判断是否在签到时间段内
		if(sign_flag.equals("2")){
			//任意时间都可以签退
		}else{
			if(TimeUtil.timeInterval(begin_time, nowtime)<0)inSignTimeScope=false;
			if(TimeUtil.timeInterval(nowtime, end_time)<0)inSignTimeScope=false;
		}
	}
	//------------------------------------
	//签到部分 End
	//------------------------------------
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=templateTitle%></title>
		<link href="/wui/theme/office/page/css/MutilMenu.css" rel="stylesheet" type="text/css"  />
		<link href="/wui/theme/office/page/css/style.css" rel="stylesheet" type="text/css" />
		<link href='/wui/theme/office/page/css/color.css' rel='stylesheet' type='text/css' />
		<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<style type="text/css">
			BUTTON.AddDoc {
				BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(../images/workPlan.gif); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 55px; CURSOR: pointer; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 18px; BACKGROUND-COLOR: transparent;padding-top:0px;
			}
			
			
			#divMessager{
				display:none;
				right:auto !important;
				background:none !important; 
			}
		
			/* 搜索控件用css */
			.searchkeywork {vertical-align:middle;font-family: "微软雅黑";font-size: 12px;width: 74px;height: 20px !important;font-size: 12px;line-height:20px;margin-top:2px;margin-left:-2px;background:none !important;border:none !important;color:#333;top:0px;padding:1px;}
			.dropdown {margin-left:5px; font-size:12px; color:#000;height:23px;margin:0px;padding:0px;}
			.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px; }
			.selectContent { position:relative; }
			.dropdown a, .dropdown a:visited { color:#816c5b; text-decoration:none; outline:none;}
			.dropdown a:hover { color:#5d4617;}
			.selectTile a:hover { color:#5d4617;}
			.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
			.selectTile a span {cursor:pointer; display:block; padding:0 0 0 0;background:none;}
			.selectContent ul { background:#fff none repeat scroll 0 0; border:1px solid #828790; color:#C5C0B0; display:none;left:0px; position:absolute; top:2px; width:auto; min-width:50px; list-style:none;}
			.dropdown span.value { display:none;}
			.selectContent ul li a { padding:0px 0 0px 2px; display:block;margin:0;width:60px;}
			.selectContent ul li a:hover { background-color:#3399FF;color: #fff !important;}
			.selectContent ul li a img {border:none;vertical-align:middle;margin-left:2px;}
			.selectContent ul li a span {margin-left:5px;}
			.flagvisibility { display:none;}
			#_ButtonOK_0,#_ButtonCancel_0{
				width:50px;
				margin:0 5px;
				cursor:pointer;
			}
			input[type='button']{
				width:50px;
				margin:0 5px;
				cursor:pointer;
			}
			iframe{
				border: 0;
			}
			#mainFrame {
				max-height: 100%;
				height: 100% !important;
			}
			#subMenusContainer ul{
			    background: #d4d4d4;
			}
			.subParentBtn {
			    background: url(/wui/theme/office/page/images/btn/arrow_right_over.png) right center no-repeat;
			}
		</style>
		
		<!-- 签到/签退js -->
		<script language=javascript>
		function signInOrSignOut(signType){
		    if(signType != 1){
			    var ajaxUrl = "/wui/theme/ecology8/page/getSystemTime.jsp";
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
				    	if (isWorkTime == "true") {
				       window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(26273, user.getLanguage())%>',function(){
				       	writeSignStatus(signType);
				       },function(){
				       	return;
				       })     
				      }else{
				      	writeSignStatus(signType);
				      }
				    }  
			    });
		    } else {
		    	writeSignStatus(signType);
		    }
		}
		
		function writeSignStatus(signType) {
			var ajax=ajaxInit();
		    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp", true);
		    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		    ajax.send("signType="+signType);
		    //获取执行状态
		    ajax.onreadystatechange = function() {
		        //如果执行状态成功，那么就把返回信息写到指定的层里
		        if (ajax.readyState == 4 && ajax.status == 200) {
		            try{
		            	jQuery("#sign_dispan").text("<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%>");
		                showPromptForShowSignInfo(ajax.responseText, signType);
		                jQuery("#sign_dispan").attr("_signType", 2);
		                if(navigator.userAgent.indexOf("MSIE")>0 && navigator.userAgent.indexOf("MSIE 6.0") > 0){  
							DD_belatedPNG.fix('.tbItm,#toolbarMoreBlockTop,.searchBlockBgDiv,#sign_dispan,.topBlockDateBlock,.toolbarTopRight,background');
						}
		            }catch(e){
		            }
		        }
		    }
		}

		//type  1:显示提示信息
//		      2:显示返回的历史动态情况信息
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
		    var showTableDiv  = document.getElementById('divShowSignInfo');
		    var oIframe = document.createElement('iframe');
		    
		    divShowSignInfo.style.display='none';
		    message_Div.style.display='none';
		    if (document.all.HelpFrame && document.all.HelpFrame.style) {
		        document.all.HelpFrame.style.display='none'
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
		</script>
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
			        
			        <%
					if (isNeedSign) {
						if("1".equals(signType)){
				 	%>
				
						window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>",function(){
							signInOrSignOut(<%=signType%>);
						});
			
					<%
						}
					}
			    	%>
			});	


		</script>
		
	</head>
	<body style="overflow: hidden" scroll="no" oncontextmenu="return false;">
	<%if(SocialIMService.isOpenIM()){%>
		<jsp:include page="/social/im/SocialIMInclude.jsp"></jsp:include>
	<%}%>
	<div id="main" style="position: absolute;top: 0px;left: 0px;width: 100%;">
		<div id="head">
			<div id="top">
				<div style="float: left; line-height: 27px; width: 200px;font-family:'微软雅黑';" class="text">
					<div class="text1" style="float: left;margin-left: 5px;">
						<%=SystemEnv.getHtmlLabelName(27306, user.getLanguage())%>：
						<span style="cursor: pointer;" onclick="window.open('/hrm/resource/HrmResource.jsp?id=<%=user.getUID() %>','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(16415, user.getLanguage())%>"><%=user.getLastname()%>
						--<%=DepartmentComInfo.getDepartmentname(String.valueOf(user.getUserDepartment()))%>
						</span>
					</div>
				</div>
				<div style="float: right; width: auto; line-height: 27px;height: 27px;">
							<!--多账号-->
							<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){
								List accounts =(List)session.getAttribute("accounts");
							    if(accounts!=null&&accounts.size()>1){
							    	Iterator iter=accounts.iterator();
							%>
							<div style="width: 10px;height: 27px;float: left;vertical-align: middle">
									<!--<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:3px;margin-left:4px;" /> -->
							</div>
							<div style="width:auto;height:27px;float: left">
								<table class="toolbarMenu">
									<tr>
										<td>
											<select id="accountSelect" name="accountSelect" onchange="onCheckTime(this);"  disabled>
								        	<% while(iter.hasNext()){Account a=(Account)iter.next();
								               		String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
								                    String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
								                    String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());                       
								            %>
								            	<option <%if((""+a.getId()).equals(user.getUID()+"")){%>selected<%}%> value=<%=a.getId()%>><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></option>
								            <%}%>
								        	</select>
								    	</td>
								  	</tr>
								</table>
							</div>
								<%}%>
							<%}%>
							
								<div style="width: 10px;height: 27px;float: left;vertical-align: middle">
									<!--<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:3px;margin-left:4px;" /> -->
								</div>
							
							<%
					        boolean havaMobile = false;
					        if(Prop.getPropValue("EMobile4","serverUrl")!=null&&!Prop.getPropValue("EMobile4","serverUrl").equals("")){
					        	havaMobile = true;
					        }
					        String version = Prop.getPropValue("EMobileVersion","version");
		
					        %>
							<%if(havaMobile){%>	
					        <!-- emessage -->
					        <div style="float: left;margin-right: 8px;">
					        	<div style="height: 27px;cursor: pointer;width: 20px; background-image: url(/wui/theme/ecology8/page/images/menuicon/bright/emobile_wev8.png)!important;background: url(/wui/theme/ecology8/page/images/info_wev8.png) no-repeat scroll center 50%;" title="E-Mobile" onclick="javascript:window.open('http://emobile.weaver.com.cn/customerproduce.do?serverVersion=<%=version %>')"></div>
					        </div>
					        
							<%}%>
							
							<!--放置即时通讯-->
							<div style="float: left;">
	                              <%
									int userId=user.getUID();
									boolean canMessager=false;
									boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
									boolean isHaveEMessager=Prop.getPropValue("Messager2","IsUseEMessager").equalsIgnoreCase("1");
									int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",userId+"");
									if((isHaveMessager&&userId!=1&&isHaveMessagerRight==1)||isHaveEMessager){
										canMessager=true;
									}
									if(canMessager){
									%>					
										<div style="height: 27px;cursor: pointer;width: 20px; background-image: url(/wui/theme/ecology8/page/images/menuicon/bright/emessage_wev8.png)!important;background: url(/wui/theme/ecology8/page/images/info_wev8.png) no-repeat scroll center 50%;" title="E-Message" onclick="javascript:window.open('/messager/installm3/emessageproduce.jsp')"></div>
									<%}%>
							</div>
							
							<!-- 收藏夹开始 -->
							<!-- 收藏夹 -->
			        		
			        		<!--div width="50px" id="favouriteshortcutid" style="position:relative;padding-top:6px">
											<span id="favouriteshortcutSpan" style="color:#fff;text-align:center;padding-top:5px;border:none">
												<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage()) %>
											</span>
											<span class="toolbarBgSpan" style="position:absolute;width:10px;height:6px;border:none;margin-top:5px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/favorites_slt.png) no-repeat;">
											</span>
										</div-->
			        		<!-- 
								<div id="favouriteshortcutid" style="padding-top:0px;float: left;width: 50px;">
									<span id="favouriteshortcutSpan" style="color:#fff;text-align:center;padding-top:5px;border:none">
										<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage()) %>
									</span>
									<span class="toolbarBgSpan" style="width:10px;height:6px;border:none;margin-top:3px;">
										<img src="/wui/theme/ecologyBasic/page/images/toolbar/favorites_slt.png" border=0 style="width:10px;height:6px;margin-top:3px;" />
									</span>
								</div>
							 -->
							 <!-- 收藏夹结束 -->
								<div style="width: 10px;height: 27px;float: left;vertical-align: middle">
									<!--<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:3px;margin-left:4px;" /> -->
								</div>
							
							<!-- 搜索block start -->		
								<div id="searchdiv" style="width:143px;padding-top:0px;float: left;">
									<form name="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
										<table cellpadding="0px" cellspacing="0px" height="23px" width="100%" align="right" style="position:relative;z-index:6;" id="searchBlockTBL">
											<tr height="100%" style="">
												<td width="*" height="100%" style="margin:0;padding:0;">
											    	<input type="hidden" name="searchtype" value="<%=microSearch?9:1%>" />
											     	<div id="sample" class="dropdown" style="position:relative;top:0px;">
											        	<div class="selectTile" style="height: 100%;vertical-align: middle;">
												        	<a href="#">
												        		<span style="float:left;width:25px;display:block;line-height:22px;" id="basicSearchrTypeText"><%=microSearch?SystemEnv.getHtmlLabelName(31953,user.getLanguage()):SystemEnv.getHtmlLabelName(58,user.getLanguage())%></span>
																<table cellpadding="0" cellspacing="0" style="height: 4px" width="8px" align="center">
																	<tr>
																		<td width="8px" height="4px" valign="middle" >
																			<div id="searchpoint" style="position:absolute;overflow:hidden;display:block;margin-left:2px;width:8px;top:8px;height:8px;background:url(/wui/theme/office/page/images/search/searchSlt.png) no-repeat;" class="toolbarSplitLine"></div>
																		</td>
																	</tr>
																</table>
															</a>
														</div>
											            <div class="selectContent">
											            	<ul id="searchBlockUl">
											            		<% if(microSearch){ %>
																	<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/ws_wev8.png"/><span searchType="9"><%=SystemEnv.getHtmlLabelName(31953,user.getLanguage())%></span></a></li>
																<%}%>
											                	<li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/doc.gif"/><span searchType="1"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></span></a></li>
											                    <li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/hr.png"/><span searchType="2"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></span></a></li>
											                	<li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/crm.gif"/><span searchType="3"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></span></a></li>
											               		<li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/zc.gif"/><span searchType="4"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></span></a></li>
											                	<li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/wl.png"/><span searchType="5"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></span></a></li>
											                	<li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/p.gif"/><span searchType="6"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></span></a></li>
											                	<li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/mail.gif"/><span searchType="7"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></span></a></li>
								                           		<li><a href="#"><img src="/wui/theme/office/page/images/search/searchType/xz.gif"/><span searchType="8"><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></span></a></li>
											                </ul>
											            </div>
											        </div>
											    </td>
											    <td width="74px">
											     	<input type="text" id="searchvalue" name="searchvalue" onmouseover="this.select()" class="searchkeywork"  style=""/>
											  	</td>
											    <td width="22px" style="position:relative;">
											    	<span onclick="searchForm.submit()" id="searchbt" style="top:4px;background:url(/wui/theme/office/page/images/search/searchBt.png)  no-repeat;display:block;width:16px;height:16px;overflow:hidden;cursor:pointer;"></span>
											    </td>
											</tr>
										</table>
									</form>
								</div>
							<!-- 搜索block end -->
							
								<div class="blank" style="width: 10px;height: 27px;float: left;vertical-align: middle;cursor: pointer;">
									<!--<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:3px;margin-left:4px;" /> -->
								</div>
							
							<!-- 签到/签退start -->
				        	<%
							%>
							<div id="tdSignInfo" <%=isNeedSign?"":"style='display: none'" %> style="float: left;">	
								<div id="sign_dispan" onclick="signInOrSignOut(jQuery(this).attr('_signType'))" _signType="<%=signType%>" style="display:block;height:21px;line-height:21px;width:56px;text-align:center;padding-bottom:3px;background:url(/wui/theme/office/page/images/btn/sign.gif) no-repeat;cursor:pointer;color:#505050;Vertical-align:middle;position:relative;overflow:hidden;float: left;margin-top: 2px;">
							<%
									if(signType.equals("1")){
										out.println(SystemEnv.getHtmlLabelName(20032,user.getLanguage()));
									}else{
										out.println(SystemEnv.getHtmlLabelName(20033,user.getLanguage()));
									}
							%>						      
								</div>
							</div>	
							<%
							%>
				       		<!-- 签到/签退end -->
				       		
								<div style="width: 10px;height: 25px;float: left;vertical-align: middle">
									<!--<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:3px;margin-left:4px;" /> -->
								</div>
				       		
				       		<!-- 右侧工具按钮 -->
								<div style="width: auto; float: left; margin-right: 0px;">
									<table style="height: 27px;" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<!-- 主页 -->
											<td><img src="/wui/theme/office/page/images/toolbar/icon_home.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(227, user.getLanguage())%>" onclick="doShowMain()"/></td>
											<!-- 刷新 -->
											<td><img src="/wui/theme/office/page/images/toolbar/icon_refresh.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(354, user.getLanguage())%>" onclick="document.getElementById('mainFrame').contentWindow.document.location.reload()"/></td>
											<!-- 后退 -->
									        <td><img src="/wui/theme/office/page/images/toolbar/icon_back.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(15122, user.getLanguage())%>" onclick="mainFrame.history.go(-1)"/></td>
									        <!-- 前进 -->
									        <td><img src="/wui/theme/office/page/images/toolbar/icon_forward.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(15123, user.getLanguage())%>" onclick="mainFrame.history.go(1)"/></td>
											<!-- 收藏夹 -->
											<td><span id="favouriteshortcutSpan" style=""><jsp:include page="/wui/theme/office/page/left.jsp"></jsp:include></span></td>
											<!-- 切换皮肤 -->
											<%
												Map pageConfigKv = getPageConfigInfo(session, user);
												String islock = (String)pageConfigKv.get("islock");
												if (islock == null || !"1".equals(islock)) {
											%>
											<td><img src="/wui/theme/office/page/images/toolbar/icon_skin.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(27714, user.getLanguage())%>" onclick="showSkinListDialog();" /></td>
											<%	} %>
											
											<td><img id="showmore" src="/wui/theme/office/page/images/toolbar/icon_more.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(17499, user.getLanguage())%>" onclick="showMore()"/></td>
											
											<!-- 退出系统 -->
											<td><img src="/wui/theme/office/page/images/toolbar/icon_close.png" class="top_icon"
												onclick="logout();" title="<%=SystemEnv.getHtmlLabelName(1205, user.getLanguage())%>" /></td>
												
											<!-- 控制菜单显示  -->
											<td><div id="menucon" class="menucon" onclick="dosubmenu()" title="<%=SystemEnv.getHtmlLabelName(20721, user.getLanguage())%>"></div></td>
								
										</tr>
										
									</table>
			        				
			        				<div id="btn_more" style="position: absolute;right: 64px;top: 27px;background: #0B457A;overflow: hidden;height: 0px;padding-left:3px;padding-right:3px;z-index: 100;">
				        				<table cellpadding="0" cellspacing="0" border="0">
											<tr style="height: 27px;">
												<!-- 个性化设置 -->
												<td><img src="/wui/theme/office/page/images/toolbar/icon_setting.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>" onclick="window.open('/systeminfo/menuconfig/CustomSetting.jsp','mainFrame')" /></td>
												<!-- 日程 -->
												<td><img src="/wui/theme/office/page/images/toolbar/icon_workplan.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(18480, user.getLanguage())%>" onclick="window.open('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>','mainFrame')"/></td>
												<!-- 组织架构 -->
												<td><img src="/wui/theme/office/page/images/toolbar/icon_org.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(16455, user.getLanguage())%>" onclick="window.open('/org/OrgChart.jsp?charttype=H','mainFrame')"/></td>
												<!-- 插件下载 -->
												<td><img src="/wui/theme/office/page/images/toolbar/icon_plugin.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(7171, user.getLanguage())%>" onclick="goopenWindow('插件下载','/weaverplugin/PluginMaintenance.jsp')"/></td>
										        <!-- 版本信息 -->
										        <td><img src="/wui/theme/office/page/images/toolbar/icon_version.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(567, user.getLanguage())%>" onclick="showVersion()"/></td>
											</tr>
											<tr style="height: 27px;">
												<!-- 密码 -->
												<td><img src="/wui/theme/office/page/images/toolbar/password.png" class="top_icon" title="<%=SystemEnv.getHtmlLabelName(17993, user.getLanguage())%>" onclick="window.open('/hrm/HrmTab.jsp?_fromURL=HrmResourcePassword','mainFrame')" /></td>
												<!-- 授权信息 -->
												<td><img src="/wui/theme/office/page/images/toolbar/license.png" class="top_icon" title="授权信息" onclick="window.open('/hrm/HrmTab.jsp?_fromURL=licenseInfo','mainFrame')" /></td>
											</tr>
										</table>
			        				</div>
							    </div>
							    
							    
						
				</div>
			</div>
			<div id="menu" style="width: 100%; height: 50px; margin: 0 auto;position: relative;">
				<%@ include file="/wui/common/page/initWui.jsp" %>
				<!-- logo -->
				<div style="position:absolute;">
				<%
					//Map pageConfigKv = getPageConfigInfo(session, user);
					String logo = (String)pageConfigKv.get("logoTop");
            		if (logo == null || logo.equals("")) {
            	%>
					<div class="logo" style=""></div>
				<% 	}else{ %>
					<div class="logo" style="background:url(<%=logo %>) no-repeat;"></div>
				<%  } %>
				<!-- 一级菜单 -->
				<div class="menu" style="line-height: 30px;">
					<div id="scrolldiv" style="height: 20px;float: left;margin-left: 23px;">
						<div id="scrollBar" style="display: none">
							<div id="scroll" style="left:0" onmouseover="test()"></div>
						</div>
					</div>
					<div style="clear:both;"></div>
					<div id="img_bag">
						<div class="scrollbtn" style="float: left;display: none">
							<div class="btn_left" onmousedown="moveLeft()"></div>
						</div>
						<div id="img">
							<ul class="ul1">
								<!-- 读取一级菜单 -->
								<jsp:include page="/wui/theme/office/page/top.jsp">
									<jsp:param name="mainId" value="<%=mainId %>" /> 
								</jsp:include>
							</ul>
						</div>
						<div class="scrollbtn" style="float: left;display: none">
							<div class="btn_right" onmousedown="moveRight()"></div>
						</div>
					</div>
				</div>
				</div>
				
				<!-- 切换颜色 -->
				<div id="colorpanel" style="width:16px;height:50px;position: absolute;right: 0px;top: 0px;overflow: hidden;background: url('/wui/theme/office/page/images/toolbar/color_bg.png') repeat;z-index: 200">
					<div style="width:16px;height: 50px;float: left;background: url('/wui/theme/office/page/images/toolbar/color_point.png') center no-repeat;" title="切换颜色"></div>
					<div style="width: 130px;height: 50px;float: left;">
						<div id="coloritem1" class="coloritem" style="background: #0B457A;border-color: #0B457A;" title="蓝色" onclick="changeColor(1)"></div>
						<div id="coloritem2" class="coloritem" style="background: #6FA53C;border-color: #6FA53C;" title="绿色" onclick="changeColor(2)"></div>
						<div id="coloritem3" class="coloritem" style="background: #BF2919;border-color: #BF2919;" title="红色" onclick="changeColor(3)"></div>
						<div id="coloritem4" class="coloritem" style="background: #B56611;border-color: #B56611;" title="橙色" onclick="changeColor(4)"></div>
						<div id="coloritem5" class="coloritem" style="background: #A09B17;border-color: #A09B17;" title="黄色" onclick="changeColor(5)"></div>
						<div id="coloritem6" class="coloritem" style="background: #9C6D3A;border-color: #9C6D3A;" title="棕色" onclick="changeColor(6)"></div>
						<div id="coloritem7" class="coloritem" style="background: #8D15B5;border-color: #8D15B5;" title="紫色" onclick="changeColor(7)"></div>
						<div id="coloritem8" class="coloritem" style="background: #DCDCDC;border-color: #DCDCDC;" title="灰色" onclick="changeColor(8)"></div>
						<div id="coloritem0" class="coloritem" style="background: url('/wui/theme/office/page/images/toolbar/old.png') center no-repeat;;border-color: #0B457A;" title="原始" onclick="changeColor(0)"></div>
					</div>
				</div>
			</div>
			
			<!-- 读取二、三级菜单 -->
				<jsp:include page="/wui/theme/office/page/left.jsp">
					<jsp:param name="mainId" value="<%=mainId %>" /> 
				</jsp:include>
			<!-- 二级菜单 -->
			<div id="menulevel2" style="height: 32px;overflow: hidden;position: relative;">
				<ul id="nav"></ul>
				<div id="nav_btn" class="nav_btn">
					<div class="nav_left" id="nav_left" style=""></div>
					<div class="nav_right" id="nav_right" style=""></div>
				</div>
			</div>
		</div>
		
		<!-- 主内容显示区 -->
		<div id="center" style="padding-top: 2px;">
			<iframe name="mainFrame" id="mainFrame" scrolling="auto" frameborder="0"
				 width="100%" src="" style="padding-top: 0px;background-color: #fff"></iframe>
			<div id="foot" style="100%;height:5px;"></div>
		</div>
		
		<!-- 显示签到/签退信息 -->
		<div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none' valign='top'></div>
		<div id='message_Div' style='display:none;background-color: #fff'></div>
		
	</div>
	
	<div id="color_msg" style="width: 49px;height: 44px;background: url('/wui/theme/office/page/images/toolbar/color_msg.png') center no-repeat;
		position: absolute;top: 25px;right: 18px;display: none;"></div>
	
	<jsp:include page="/wui/common/page/mainPlugins.jsp"></jsp:include>

	

	

<SCRIPT LANGUAGE="javascript">
var voteids = "";//网上调查的id
var voteshows = "";//网上调查是否弹出
var votefores = "";//网上调查---> 强制调查
</SCRIPT>


<%

    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
	String belongtoids = user.getBelongtoids();
	String account_type = user.getAccount_type();


boolean isSys=true;
RecordSet.executeSql("select 1 from hrmresource where id="+user.getUID());
if(RecordSet.next()){
	isSys=false;
}	

Date votingnewdate = new Date() ;
long votingdatetime = votingnewdate.getTime() ;
Timestamp votingtimestamp = new Timestamp(votingdatetime) ;
String votingCurrentDate = (votingtimestamp.toString()).substring(0,4) + "-" + (votingtimestamp.toString()).substring(5,7) + "-" +(votingtimestamp.toString()).substring(8,10);
String votingCurrentTime = (votingtimestamp.toString()).substring(11,13) + ":" + (votingtimestamp.toString()).substring(14,16);
String votingsql=""; 
if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
belongtoids +=","+user.getUID();

votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+ 
        " and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"'))) "; 
	votingsql +=" and (";
	
  String[] votingshareids=Util.TokenizerString2(belongtoids,",");
	for(int i=0;i<votingshareids.length;i++){
		User tmptUser=VotingManager.getUser(Util.getIntValue(votingshareids[i]));
		String seclevel=tmptUser.getSeclevel();
		int subcompany1=tmptUser.getUserSubCompany1();
		int department=tmptUser.getUserDepartment();
		String  jobtitles=tmptUser.getJobtitle();
	     	
		String tmptsubcompanyid=subcompany1+"";
		String tmptdepartment=department+"";
		RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+tmptUser.getUID());
		while(RecordSet.next()){
			tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
			tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
		}
		
		if(i==0){
			votingsql += " ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		} else {
			votingsql += " or ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		}
		
		  		
	}
	votingsql +=")";

}else{
	String seclevel=user.getSeclevel();
	int subcompany1=user.getUserSubCompany1();
	int department=user.getUserDepartment();
	String  jobtitles=user.getJobtitle();
	  		
	String tmptsubcompanyid=subcompany1+"";
	String tmptdepartment=department+"";
	RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+user.getUID());
	while(RecordSet.next()){
		tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
		tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
	}
	
	votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+
	" and t1.id not in (select distinct votingid from VotingRemark where resourceid ="+user.getUID()+")"+
	" and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"')))"+
	" and t1.id in(select votingid from VotingShare t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) )  or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel>=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ))"; 
}
if(isSys){
	votingsql +=" and 1=2";
}
signRs.executeSql(votingsql);
while(signRs.next()){ 
String votingid = signRs.getString("id");
String voteshow = signRs.getString("autoshowvote"); 
String forcevote = signRs.getString("forcevote"); 

%>

<script language=javascript>  
   if(voteids == ""){
      voteids = '<%=votingid%>';
      voteshows = '<%=voteshow%>';
      forcevotes = '<%=forcevote%>';
   }else{
      voteids =voteids + "," +  '<%=votingid%>';
      voteshows =voteshows + "," +  '<%=voteshow%>';
      forcevotes =forcevotes + "," +  '<%=forcevote%>';
   }

</script> 
<%
}
//------------------------------------
//网上调查部分 End
//------------------------------------
%> 

		<script type="text/javascript">

		
		function showVote(){
     if(voteids !=""){
	     var arr = voteids.split(",");
	     var autoshowarr = voteshows.split(",");
	     var forcevotearr = forcevotes.split(",");
		 for(i=0;i<arr.length;i++){
		    //判断是否弹出调查
		    if(autoshowarr[i] !='' || forcevotearr[i] !=''){//弹出
			    var diag_vote = new Dialog();
				diag_vote.Width = 960;
				diag_vote.Height = 800;
				diag_vote.Modal = false;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>";
				diag_vote.URL = "/voting/VotingPoll.jsp?votingid="+arr[i];
				if(forcevotearr[i] !=''){//强制调查
				  diag_vote.ShowCloseButton=false; 
				}
				diag_vote.show();
			}
		 }
	 }
}
			var _head = 0;
			var colorindex = 0;
			jQuery(document).ready(function() {
showVote();
				colorindex = getCookie("OFFICECOLORINDEX");
				if(colorindex==null || typeof(colorindex)=="undefined"){
					colorindex = 1;
					//显示提示
					jQuery("#color_msg").show();
					//addCookie("OFFICECOLORINDEX",colorindex,1);
				}
				loadCss();
				
				jQuery("#favouriteshortcutSpan").load("/wui/theme/office/page/FavouriteShortCut.jsp",function(){
					<%if(!"".equals(initsrcpage)){%>
						jQuery("#mainFrame").attr("src","<%=initsrcpage%>");
					<%}else{%>
						jQuery(".ul1").find("a")[0].click();
					<%}%>
				});
				
				setfh();
				setAccountSelect();

				//设置一级菜单滚动
				if(jQuery(".topmenu").length>6){
					jQuery("#scrollBar").show();
					jQuery(".scrollbtn").show();
				}

				jQuery("div.btn_left").bind("mouseover",function(){
					jQuery(this).addClass("btn_left_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_left_hover");
				});
				jQuery("div.btn_right").bind("mouseover",function(){
					jQuery(this).addClass("btn_right_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_right_hover");
				});
				

				jQuery("#colorpanel").bind("mouseenter",function(){
					jQuery("#color_msg").hide();
					jQuery(this).animate({ width:146},200,null,null);
				}).bind("mouseleave",function(){
					jQuery(this).animate({ width:16},200,null,null);
				});
				
				jQuery(document).bind("click",function(e){
					e = e ? e : event;   
					var target=jQuery.event.fix(e).target;
					if(jQuery(target).attr("id") != "showmore" && jQuery(target).attr("id") != "btn_more"){
						jQuery("#btn_more").animate({ height:0},300,null,null);
				    }
				});

				if(colorindex!=0){
					_head=105;
				}else{
					_head=115;  
				} 
				
				//jQuery("#divMessager").css("left",jQuery(window).width()-300);
			});
			jQuery(window).resize(function() {
				setfh();
				setNav();
			});

			function changeColor(index){
				colorindex = index;
				addCookie("OFFICECOLORINDEX",index,1);
				loadCss();
			}
			function loadCss(){
				replacejscssfile("color","/wui/theme/office/page/css/color"+colorindex+".css","css");

				jQuery("div.coloritem").removeClass("coloritem_click");
				jQuery("#coloritem"+colorindex).addClass("coloritem_click");
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

			function createjscssfile(filename, filetype){
				if (filetype=="js"){
					var fileref=document.createElement('script')
					fileref.setAttribute("type","text/javascript")
					fileref.setAttribute("src", filename)
				}
				else if (filetype=="css"){
					var fileref=document.createElement("link")
					fileref.setAttribute("rel", "stylesheet")
					fileref.setAttribute("type", "text/css")
					fileref.setAttribute("href", filename)
				}
				return fileref
			}

			function replacejscssfile(oldfilename, newfilename, filetype){
				var targetelement=(filetype=="js")? "script" : (filetype=="css")? "link" : "none"
				var targetattr=(filetype=="js")? "src" : (filetype=="css")? "href" : "none"
				var allsuspects=document.getElementsByTagName(targetelement)
				for (var i=allsuspects.length; i>=0; i--){
					if (allsuspects[i] && allsuspects[i].getAttribute(targetattr)!=null && allsuspects[i].getAttribute(targetattr).indexOf(oldfilename)!=-1){
					   var newelement=createjscssfile(newfilename, filetype)
					   allsuspects[i].parentNode.replaceChild(newelement, allsuspects[i])
					}
				}
			}

			function showMore(){
				jQuery("#btn_more").animate({ height:54},300,null,null);
			}

			function isMouseLeaveOrEnter(e, handler) {
				e = jQuery.event.fix(e); 
			    if (e.type != 'mouseout' && e.type != 'mouseover') return false;
			    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
			    while (reltg && reltg != handler)  {
			        reltg = reltg.parentNode;
			     }
			    return (reltg != handler);
			}

			var sm;
			var showmain=0;
			function doShowMain(){
				if(jQuery(".topmenu").length>6){
					showmain=1;
					sm = setInterval(moveLeft,50);
				}else{
					jQuery(".ul1").find("a")[0].click();
				}
			}
			
			//设置内容iframe高度
			function setfh() {
				if(jQuery(window).width()<1000){
					jQuery("#main").width(1000);
				}else{
					jQuery("#main").width("100%");
				}
				jQuery("#center").height(jQuery(window).height() - jQuery("#head").height() -7);
			}
		
			var menudisplay = 1;
			function dosubmenu() {
				if (menudisplay == 0) {
					jQuery("#nav").show();
					jQuery("#menu").show();
					//jQuery("#nav_btn").show();
					var _h2 = jQuery("#menulevel2").height();
					jQuery("#head").height(77+_h2);
					jQuery("#menucon").removeClass("menucon_up");
					jQuery("#menucon").attr("title","<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>");
					menudisplay = 1;
				} else {
					jQuery("#nav").hide();
					jQuery("#menu").hide();
					//jQuery("#nav_btn").hide();
					jQuery("#head").height(27);
					jQuery("#menucon").addClass("menucon_up");
					jQuery("#menucon").attr("title","<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>");
					menudisplay = 0;
				}
				setfh();
			}

			//插件下载
			function goopenWindow(title,url){
			    var dlg=new window.top.Dialog();//定义Dialog对象
				var title = title;
				dlg.currentWindow = window;
				//var chasm = screen.availWidth;
				//var mount = screen.availHeight;
				//if(chasm<600) chasm=600;
				//if(mount<500) mount=500;
				dlg.Model=true;
				dlg.Width=730;//定义长度
				dlg.Height=600;
				dlg.URL=url;
				dlg.Title=title;
				dlg.show();
			}
			//显示版本信息
			function showVersion(){
				//about=window.showModalDialog("/systeminfo/version.jsp","","dialogHeight:376px;dialogwidth:466px;help:no");
				var dlg=new window.top.Dialog();//定义Dialog对象
				var url = "/systeminfo/version.jsp";
				var title = "关于e-cology";
				dlg.currentWindow = window;
				dlg.Model=true;
				dlg.Width=630;//定义长度
				dlg.Height=400;
				dlg.URL=url;
				dlg.Title=title;
				dlg.show();
			}
			
			function logout(){
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>",function(){
					window.location='/login/Logout.jsp';
				});
			}
		</script>
		<!-- 切换主题js -->
		<script language=javascript>
			function showSkinListDialog() {
				var diag_xx = new Dialog();
				diag_xx.Width = 600;
				diag_xx.Height = 500;
				
				diag_xx.ShowCloseButton=true;
				diag_xx.Title = "主题中心";//"主题中心";
				diag_xx.Modal = true;
				diag_xx.opacity=0;
				diag_xx.URL = "/wui/theme/ecology8/page/skinTabs.jsp";
				diag_xx.show();
			}
		</script>
		
		
		<!-- 多账户js -->
		<script type="text/javascript">
			var firstTime = new Date().getTime();
			function onCheckTime(obj){
				window.location = "/login/IdentityShift.jsp?shiftid="+obj.value;
			}
			function setAccountSelect(){
				var nowTime = new Date().getTime();
				if((nowTime-firstTime) < 10000){
					setTimeout(function(){setAccountSelect();},1000);
				}else{
					try{
						document.getElementById("accountSelect").disabled = false;
					}catch(e){}
				}
			}
		</script>
		
		<!-- 菜单滚动js -->
		<script type="text/javascript" defer="defer">
			/**一级主菜单滚动js*/
			function T$(obj){return document.getElementById(obj);}

			var temp = 630;//一次滚动距离
			var maxw = 630;
			var movw = 600;
			
			var maxWidth=T$("img").getElementsByTagName("ul")[0].getElementsByTagName("li").length*105;
			var isScroll=false;
			var modiLeft;

			var tt = 0;
			function test(){
				if(tt==0){
					
			//jQuery(window).load(function(){
			//jQuery(document).ready(function() {
				T$("scroll").onmousedown=function(evt){
					isScroll=true;
					evt=(evt)?evt:((window.event)?window.event:null);
					if(evt.offsetX){
						modiLeft=parseInt(evt.offsetX);
					}else{
						modiLeft=parseInt(evt.layerX);
					}
				}
				document.onmouseup=function(){
					isScroll=false;
					
				}
				document.onmousemove=function(evt){
					evt=(evt)?evt:((window.event)?window.event:null);
					if(evt && isScroll){
						//alert(jQuery("#scroll").attr("_temp"));
						T$("scroll").style.left=parseInt(evt.clientX)-parseInt(T$("scrollBar").offsetLeft)-modiLeft+"px";
						//alert(T$("scroll").style.left);
						if(parseInt(T$("scroll").style.left)<0){T$("scroll").style.left=0+"px"}
						if(parseInt(T$("scroll").style.left)>movw){T$("scroll").style.left=movw+"px"}
						T$("img").scrollLeft=parseInt(T$("scroll").style.left)*((maxWidth-maxw)/movw);
				  	}
				}
				tt==1;
				}
			}
			
			var targetx = 600;
			var dx;
			var a=null;
			function moveLeft(){
				var le=parseInt(T$("img").scrollLeft);
				if(le>temp){
					targetx=parseInt(T$("img").scrollLeft)-temp;
				}else{
					targetx=parseInt(T$("img").scrollLeft)-le-1;
				}
				scLeft();
				if(targetx==-1 && showmain==1){
					clearInterval(sm);
					jQuery(".ul1").find("a")[0].click();
					showmain=0;
				}
			}
			function scLeft(){
				dx=parseInt(T$("img").scrollLeft)-targetx;
				T$("img").scrollLeft-=dx*.3;
				T$("scroll").style.left=parseInt(T$("img").scrollLeft)*(movw/(maxWidth-maxw))+"px";
				if(parseInt(T$("scroll").style.left)<0){T$("scroll").style.left=0+"px"}
				if(parseInt(T$("scroll").style.left)>movw){T$("scroll").style.left=movw+"px"}
				clearScroll=setTimeout(scLeft,50);
				if(dx*.3<1){clearTimeout(clearScroll)}	
			}
			function moveRight(){
				var le=parseInt(T$("img").scrollLeft)+temp;
				var maxL=maxWidth-maxw;
				if(le<maxL){
					targetx=parseInt(T$("img").scrollLeft)+temp;
				}else{targetx=maxL}
				scRight();
			}
			function scRight(){
				dx=targetx-parseInt(T$("img").scrollLeft);
				T$("img").scrollLeft+=dx*.3;
				T$("scroll").style.left=parseInt(T$("img").scrollLeft)*((movw+3)/(maxWidth-maxw))+"px";
				if(parseInt(T$("scroll").style.left)<0){T$("scroll").style.left=0+"px"}
				if(parseInt(T$("scroll").style.left)>=movw){T$("scroll").style.left=movw+"px"}
				a=setTimeout(scRight,50);
				if(dx*.3<1 || T$("scroll").style.left==(movw+"px")){
					clearTimeout(a);
				}
			}
		</script>
		<script type="text/javascript">
			/**二级菜单滚动js*/
			var left;
			var right;
			var canleft;
			var canright;
			jQuery('#nav_left')
			.bind('mousedown', function(){
				left = setInterval(scrollLeft,300);
				scrollLeft();
			})
			.bind('mouseup',function(){
				clearInterval(left);
			});
			
			jQuery('#nav_right')
			.bind('mousedown', function(){
				right = setInterval(scrollRight,300);
				scrollRight();
			})
			.bind('mouseup',function(){
				clearInterval(right);
			});
			
			function scrollLeft(){
				if(canleft==0) return;
				var l = jQuery("#nav").offset().left+100;
				jQuery("#nav").css("left",l);
				setNav();
			}
			
			function scrollRight(){
				if(canright==0) return;
				var l = jQuery("#nav").offset().left-100;
				//alert(left);
				jQuery("#nav").css("left",l);
				setNav();
			}

			function setNav(){
				var ww = jQuery("#menulevel2").width();
				var nw = jQuery(".menulink").length * 100;
				if(nw>ww){
					var l = jQuery("#nav").offset().left;
					//alert("top:"+top);
					if(l>=0){
						jQuery('#nav_left').attr("disabled",true).removeClass("nav_left2");
						canleft=0;
						clearInterval(left);
					}else{
						//if(l>-70){
						//	jQuery("#nav").css("left",0);
						//	jQuery('#nav_left').attr("disabled",true).removeClass("nav_left2");
						//	clearInterval(left);
						//}else{
							jQuery('#nav_left').attr("disabled",false).addClass("nav_left2");
							canleft=1;
						//}
						
						//jQuery('#nav_left').show();
					}
					if(l*-1+ww-46>=nw){
						//jQuery("#nav").css("left",ww-nw-46);
						jQuery('#nav_right').attr("disabled",true).removeClass("nav_right2");
						canright=0;
						//jQuery('#nav_right').hide();
						clearInterval(right);
					}else{
						jQuery('#nav_right').attr("disabled",false).addClass("nav_right2");
						canright=1;
						//jQuery('#nav_right').show();
					}
				}else{
					jQuery("#nav").css("left",0);
					//jQuery('#nav_left').hide();
					jQuery('#nav_left').attr("disabled",true).removeClass("nav_left2");
					canleft=0;
					//jQuery('#nav_right').hide();
					jQuery('#nav_right').attr("disabled",true).removeClass("nav_right2");
					canright=0;
					clearInterval(left);
					clearInterval(right);
				}
				if((canleft==0 && canright==0) || menudisplay==0){
					
					jQuery("#nav_btn").hide();
				}else{
					jQuery("#nav_btn").show();
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
		  
		  var needRemind = true;
			function canSign(){
				if(!needRemind)return;
				try{
					jQuery.ajax({
						url:"/hrm/ajaxData.jsp",
						type:"POST",
						dataType:"json",
						async:false,
						data:{
							cmd:"isNeedSign",
						},
						success:function(data){
							if(data.isNeedSign){
								window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>",function(){
									signInOrSignOut(data.signType);
									needRemind = false;
									jQuery("#tdSignInfo").show();
								},function(){
									needRemind = false;
								  try{
									  	jQuery("#tdSignInfo").show();
						            	jQuery("#sign_dispan").text("<%=SystemEnv.getHtmlLabelName(20032,user.getLanguage())%>");
						                showPromptForShowSignInfo(ajax.responseText, signType);
						                jQuery("#sign_dispan").attr("_signFlag", 1);
						                if(navigator.userAgent.indexOf("MSIE")>0 && navigator.userAgent.indexOf("MSIE 6.0") > 0){  
											DD_belatedPNG.fix('.tbItm,#toolbarMoreBlockTop,.searchBlockBgDiv,#sign_dispan,.topBlockDateBlock,.toolbarTopRight,background');
										}
			           		 		}catch(e){}
								})
							}else{
								setTimeout('canSign()', 60*5*1000);
							}
						}
					});
				}catch(e){}
			}
			
			<%
			if(isSignInOrSignOut.equals("1")&&isWorkday&&!isSyadmin&&!inSignTimeScope&&ll<0){
			%>
			canSign();
			<%}%>
		</script>
	</body>
</html>