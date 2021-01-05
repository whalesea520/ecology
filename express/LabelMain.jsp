
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	//读取title
	UsrTemplate.getTemplateByUID(user.getUID(), user.getUserSubCompany1());
	String templateTitle = UsrTemplate.getTemplateTitle();
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
	
	Calendar calendar=Calendar.getInstance();
	String todaydate=dateFormat.format(calendar.getTime());    //今天日期
	calendar.add(Calendar.DAY_OF_MONTH,1);
	String tomorrowdate=dateFormat.format(calendar.getTime()); //明天日期
	
    String viewType=Util.null2String(request.getParameter("viewType"));//查看类型
    String hrmid=Util.null2String(request.getParameter("hrmid"));//被查看人id
   
    String labelId = Util.null2String(request.getParameter("LabelId"));
    
    String userid=user.getUID()+"";
    hrmid=hrmid.equals("")?userid:hrmid;
    String detailsrc="/express/DetailLabel.jsp?labelId="+labelId;
    if(viewType.equals("viewhrm"))
       detailsrc="/blog/viewBlog.jsp?blogid="+hrmid;
    else if(viewType.equals("mainline"))
       detailsrc="DetailMainline.jsp?blogid="+hrmid;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=templateTitle%> - <%=user.getUsername()%></title>
		<link rel="stylesheet" href="/express/css/ui/jquery.ui.all_wev8.css" />
		<link rel="stylesheet" href="/express/css/base_wev8.css" />
		<script language="javascript" src="/express/js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="/express/js/jquery.fuzzyquery.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<script src="/express/js/jquery.ui.core_wev8.js"></script>
		<script src="/express/js/jquery.ui.widget_wev8.js"></script>
		<script src="/express/js/jquery.ui.datepicker_wev8.js"></script>
		<script src="/express/js/jquery.dragsort_wev8.js"></script>
		<script src="/express/js/jquery.textarea.autoheight_wev8.js"></script>
		<script src="/express/js/util_wev8.js"></script>
		<style type="text/css">
			html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
			*{font-size: 12px;font-family: Arial,'微软雅黑';outline:none;}
			
			.calendar{width:100%;cursor:default;background: #F1F1F1;}
			.calendar td{background: #fff;vertical-align: top;text-align: left;height: 65px;padding-left: 0px;position: relative;}
			tr.header td{height: 23px;text-align: center;vertical-align: middle;}
			
			.datalist{width:100%;table-layout: fixed;}
			.datalist td{empty-cells:show;height: 28px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #999999;
				padding-left: 0px;background-color: #fff;border-bottom: 1px #EFEFEF solid;border-top: 1px #ffffff solid;}
			.datalist td.td1{border-bottom: 0px;background: #F7F7F7;text-align: center;}
			.datalist td.td_icon{background: url('/express/task/images/point_02_wev8.png') center no-repeat;background-color: #fff;}
			.datalist td.td_icon2{background: url('/express/task/images/li_wev8.png') center no-repeat;}
			.datalist tr{cursor: pointer;}
			.datalist tr.tr_blank{height: 0px !important;}
			.datalist tr.tr_blank td{height: 0px !important;border-width: 0px !important;}
			
			.datalist2{width:100%;table-layout: fixed;}
			.datalist2 td{height: 25px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #999999;;background-color: #fff;}
			.datalist2 td.td_icon2{background: url('/express/task/images/li_wev8.png') right no-repeat;}
			.datalist2 tr{cursor: pointer;}
			
			tr.data_hover td{background-color: #F6F6F6;}
			tr.data_hover2 td{background: #75B5DF;color: #FAFAFA;}
			tr.data_hover2 td.td_icon{background: url('/express/task/images/point_01_wev8.png') center no-repeat;background-color: #75B5DF;}
			
			.colortable td{width: auto;height: auto;font-size: 0px;}
			.weekcon{cursor: pointer;}
			
			.scroll1{overflow-y: auto;overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
			  	SCROLLBAR-ARROW-COLOR: #EAEAEA;
			  	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
			  	SCROLLBAR-SHADOW-COLOR: #E0E0E0 ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
			  	SCROLLBAR-FACE-COLOR: #ffffff;}
			.scroll2{overflow-y: auto;overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #CDCDCD;
			  	SCROLLBAR-ARROW-COLOR: #E2E2E2;
			  	SCROLLBAR-3DLIGHT-COLOR: #CDCDCD;
			  	SCROLLBAR-SHADOW-COLOR: #CDCDCD ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #CDCDCD;
			  	SCROLLBAR-FACE-COLOR: #CDCDCD;
			  	scrollbar-track-color:#E2E2E2;
			  	}
			  	
			.leftmenu{width: 100%;height: 26px;margin-top: 0px;position: relative;cursor: pointer;color:#3A3A3A;}
			.leftmenu_over{background: #CECECE;color:#fff;}
			.leftmenu_select{background: url('/express/task/images/left_menu_wev8.png') left no-repeat;color:#fff;font-weight: bold;}
			 
			.input_inner{height:26px;width:220px;margin-left:0px;margin-right:0px;border:0px;font-size:12px;margin-top: 0px;margin-bottom: 0px;font-family:微软雅黑;
				border: 1px #B4B4B4 solid;box-shadow:0px 0px 2px #B4B4B4;-moz-box-shadow:0px 0px 2px #B4B4B4;-webkit-box-shadow:0px 0px 2px #B4B4B4;
				border-radius: 4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;padding-left: 2px;}
			label.overlabel {line-height:20px;position:absolute;top:3px;left:5px;color:#999;font-family: 微软雅黑;z-index:1;}
		
			.fuzzyquery_query_div{/*显示出来的模糊查询容器*/
				position:absolute;
				z-index:999;
				width: 577px;
				/**height:115px;*/
				border: 1px #53A9FF solid;
				border-radius: 4px;
				-moz-border-radius: 4px;
				-webkit-border-radius: 4px;
				box-shadow:0px 0px 2px #53A9FF;
				-moz-box-shadow:0px 0px 2px #53A9FF;
				-webkit-box-shadow:0px 0px 2px #53A9FF;
				overflow: hidden;
				background-color: #fff;
			}
			.fuzzyquery_main_div{width: 100%;height: auto;overflow: hidden;}
			.fuzzyquery_load{background: url('/express/task/images/loading2_wev8.gif') center no-repeat;height: 40px;}
			.fuzzyquery_query_tab{width:100%;table-layout: fixed;border: 0px;}
			.fuzzyquery_query_tab tr{width:100%;cursor:pointer;}
			.fuzzyquery_query_tab td{
				text-align:left;
				font-size:12px;
				overflow:hidden;
				text-overflow: ellipsis;
				height: 22px;
				line-height: 22px;
				color: #A4A4A4;
				border-bottom: 0px #E6F1F9 dotted;
				word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;
				padding-left: 1px;
			}
			.fuzzyquery_query_tab td.t_status{color: #D7D7D7;width: 40px;}
			
			.fuzzyquery_query_tab2{width:100%;table-layout: fixed;border: 0px;}
			.fuzzyquery_query_tab2 tr{width:100%;cursor:pointer;}
			.fuzzyquery_query_tab2 td{
				text-align:left;
				font-size:12px;
				overflow:hidden;
				text-overflow: ellipsis;
				height: 24px;
				line-height: 24px;
				color: #6E6E6E;
				border-bottom: 1px #EFF7FC solid;
				word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;
				padding-left: 3px;
				font-family: '微软雅黑';
			}
			.fuzzyquery_query_tab2 td.t_status{color: #D7D7D7;width: 90px;text-align: right;padding-right: 2px;}
			
			.fuzzyquery_query_title td{border:0px;color:#393939;}
			.fuzzyquery_query_row_hover{background-color:#2F9AE1;}/*行移上去的样式*/
			.fuzzyquery_query_row_hover td{color: #fff !important;}
			.fuzzyquery-floor{/*创建的底板IFRAME，如无特殊情况请勿修改*/
				width:0%;
				height:0%;
				z-index:998;
				position:absolute;
				filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';
				left: 13px;
				top: 76px;
				border: 0px;
			}
			.div_line{height:50%;border-bottom:2px #EEEFEF solid;float:left;}
		
			.btn_add_type img{margin-top: -1px;}
			.type_btn_select{color: #fff;cursor: default !important;}
			
			.disinput{border: 0px;width: 100%;background: none;height: 100%;line-height:100%;cursor: pointer;}
			
			.addinput{color: #C0C0C0;font-style: italic;}
			
			.cond_txt{line-height: 26px;position: absolute;left: 10px;}
			.cond_icon{width: 16px;height: 26px;position: absolute;right: 10px;background: url('/express/task/images/menu_icon_2_wev8.png') center no-repeat;}
			.cond_icon10{background: url('/express/task/images/menu_icon_2_wev8.png') center no-repeat;}
			.cond_icon11{background: url('/express/task/images/menu_icon_2_hover_wev8.png') center no-repeat;}
			.cond_icon20{background: url('/express/task/images/menu_icon_1_wev8.png') center no-repeat;}
			.cond_icon21{background: url('/express/task/images/menu_icon_1_hover_wev8.png') center no-repeat;}
			.cond_icon30{background: url('/express/task/images/menu_icon_3_wev8.png') center no-repeat;}
			.cond_icon31{background: url('/express/task/images/menu_icon_3_hover_wev8.png') center no-repeat;}
			.lefttitle{cursor: pointer;background: url('/express/task/images/left_title_wev8.png') repeat-x;color: #818181;font-weight: bold;
				width: 100%;height: 26px;margin-top: 0px;position: relative;}
			.lefttitle_select{font-weight: bold;color: #818181;}
			
			#divmenu div{font-family: '微软雅黑' !important;}
			
			.drop_list{position: absolute;width: 100px;height: 125px;text-align:left;z-index: 999;top: 83px;left: 803px;
						background: #fff;border: 1px #CACACA solid;display: none;
						border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
						box-shadow:0px 0px 3px #CACACA;-moz-box-shadow:0px 0px 3px #CACACA;-webkit-box-shadow:0px 0px 3px #CACACA;
    					behavior:url(/express/css/PIE2.htc);}
			::-webkit-scrollbar-track-piece{
				background-color:#E2E2E2;
				-webkit-border-radius:0;
			}
			::-webkit-scrollbar{
				width:12px;
				height:8px;
			}
			::-webkit-scrollbar-thumb{
				height:50px;
				background-color:#CDCDCD;
				-webkit-border-radius:1px;
				outline:0px solid #fff;
				outline-offset:-2px;
				border: 0px solid #fff;
			}
			::-webkit-scrollbar-thumb:hover{
				height:50px;
				background-color:#BEBEBE;
				-webkit-border-radius:1px;
			}
			
			#help_content p{margin: 0px;padding: 0px;line-height: 25px;margin-left: 5px;font-family: 微软雅黑;color: #000040}
		    
		    input[type="checkbox"]{width:11px; height: 11px;}
		    
		    #loading{position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(/express/task/images/bg_ahp_wev8.png) repeat;display: none;}
		    #loading div{position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(/express/task/images/loading1_wev8.gif) center no-repeat}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.disinput{line-height: 28px !important;height: 28px !important;}
			.input_inner{line-height: 26px !important;}
		</style>
		<![endif]-->
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div id="main" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;right: 0px;bottom: 0px;">
			
			<!-- 中心视图 -->
			<div id="view" style="width:auto;height:auto;position: absolute;top: 0px;left:0px;right:647px;bottom: 0px;z-index: 3">
				<div style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;border-right: 1px #BFC5CC solid;">
					<div style="width: 100%;height: 40px;position: relative;line-height: 40px;">
					  <%
					  //查看主线
					  if(viewType.equals("label")) {%>
					     <span style="margin-left: 15px;"><span style="font-weight: bold;">标签：</span>Express项目开发</span>
					  <%}%>
					
					</div>
					<div style="width: 100%;height:31px;background: url('/express/images/title_bg_01_wev8.png') repeat-x;position: relative;">
						<div id="changesort" class="main_btn" style="width: 45px;text-left: center;position: absolute;left: 22px;height: 31px;line-height: 31px;top: 0px;border-right: 1px #E4E4E4 solid;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;
							" title="全选">
						    <input id="choseAll" type="checkbox"/>全选
						</div>
						<div id="changestatus" class="main_btn" style="width:84px;text-align: center;position: absolute;left: 65px;line-height: 26px;top: 0px;border-right: 1px #E4E4E4 solid;color: #786571;cursor: pointer;
							" onclick="showChangeStatus(event)" title="状态">
							<div style="float: left;margin-left: 8px;"><span style="color: #999999">类型:</span><span id="taskType" style="color: #666666">事务</span><img  style="margin-left: 10px;margin-bottom: 2px;" src="/express/images/express_maintask_pull_wev8.png"/></div>
						</div>
						<div id="filter" class="main_btn" style="width:60px;text-align: center;position: absolute;left: 145px;line-height: 26px;top: 0px;border-right: 1px #E4E4E4 solid;color: #786571;cursor: pointer;"
							onclick="showFiterSort(event)" title="过滤">
							<div style="float: left;margin-left: 8px;" id="changeFilter1" ><span style="color: #999999" id="changeFilter1">过滤</span><img style="margin-left: 5px; margin-bottom:2px;" src="/express/images/express_maintask_pull_wev8.png"/></div>
						</div>
						<div class="main_btn" style="width:158px;text-align: center;position: absolute;right:60px;height: 31px;line-height: 31px;top: 0px;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;">
							<div style="color: #666666;margin-top: 5px;">
							   <div onclick="shareTask(event)" class="btn_operate" style="width: 32px;float: left;" id="shareToP" title="提醒">分享</div>
							   <div onclick="remindTask()" class="btn_operate" style="width: 32px;float: left;" id="remind" title="提醒">提醒</div>
							   <div onclick="attTask()" class="btn_operate" style="width: 32px;float: left;" id="remind" title="提醒">关注</div>
							   <div onclick="markdateTask(this)" class="btn_operate" style="width: 32px;float: left;" id="remind" title="提醒">时间
							    <div style="width: 32px;display: none;"></div>
							   </div>
							</div>
						</div>
						<div id="create" class="main_btn" style="width: 50px;text-align: center;position: absolute;right:0px;line-height: 26px;top: 0px;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;"
							onclick="showNewCreate(event)" title="新建">
							<div style="float: left;margin-left: 2px;font-family: 微软雅黑;color: #666666" id="changeNew">新建<img style="margin-left: 10px;margin-bottom: 2px;" src="/express/images/express_maintask_pull_wev8.png"/></div>
						</div>
						<!--
						<div id="doOperate" class="main_btn" style="width: 60px;text-align: center;position: absolute;right: 0px;line-height: 26px;top: 0px;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;"
							onclick=" showOperate(event)" title="新建">
							<div style="float: left;margin-left: 2px;font-family: 微软雅黑;color: #666666" id="changeOperate">操作<img style="margin-left: 10px;margin-bottom: 2px;" src="/express/images/express_maintask_pull_wev8.png"/></div>
						</div>
						 -->
					</div>
					<div id="statusbtn" class="drop_list" style="width:78px; height: 180px; ">
						<div>
						    <div class="btn_add_type" name="事务" onclick="doChangeStatus(this,0)">事务</div>
							<div class="btn_add_type" name="流程" onclick="doChangeStatus(this,2)"><div style="margin-left:12px;">流程</div></div>
							<div class="btn_add_type" name="任务" onclick="doChangeStatus(this,1)"><div style="margin-left:12px;">任务</div></div>
							<div class="btn_add_type" name="会议" onclick="doChangeStatus(this,6)"><div style="margin-left:12px;">会议</div></div>
							<div class="btn_add_type" name="协作" onclick="doChangeStatus(this,3)">协作</div>
							<div class="btn_add_type" name="邮件" onclick="doChangeStatus(this,4)">邮件</div>
							<div class="btn_add_type" name="文档" onclick="doChangeStatus(this,5)">文档</div>
						</div>
					</div>
					
					<div id="fiterChose"  class="drop_list" style="height: 182px;">
    					<div>
    						<div style=" color: #666666; font-weight: bold; margin-top: 3px;">&nbsp;状态：</div>
    						<div class="btn_add_type" onclick="doFiter(this,1)">全部</div>
							<div class="btn_add_type" onclick="doFiter(this,2)"  >进行中</div>
							<div class="btn_add_type" onclick="doFiter(this,3)"  >已完成</div>
						</div>
						<div>
							<div style="text-align: left; color: #666666; font-weight: bold;">&nbsp;任务：</div>
							<div class="btn_add_type"  onclick="doFiter(this,1)"  >我的任务</div>
							<div class="btn_add_type"  onclick="doFiter(this,2)"  >我分享的任务</div>
							<div class="btn_add_type" onclick="doFiter(this,3)"  >我关注的任务</div>
						</div>
					</div>
					
					<div id="newCreate"  class="drop_list" style="height: 150px;">
						<div class="btn_add_type" onclick="addTask(1)"  >新建任务</div>
						<div class="btn_add_type"  onclick="addTask(2)" >新建流程</div>
						<div class="btn_add_type"  onclick="addTask(3)" >新建协作</div>
						<div class="btn_add_type"  onclick="addTask(4)">新建邮件</div>
						<div class="btn_add_type" onclick="addTask(5)" >上传文档</div>
						<div class="btn_add_type" onclick="addTask(6)" >新建会议</div>
					</div>
					
					<div id="operate"  class="drop_list" style="height:100px;">
						<div class="btn_add_type"  onclick="">分享</div>
						<div class="btn_add_type"  onclick="remindTask()" >提醒</div>
						<div class="btn_add_type"  onclick="attTask()" >关注</div>
						<div class="btn_add_type"  onclick="markdateTask()" >时间</div>
					</div>
					
					<div id="shareTaskToName" class="drop_list" style="width:100px; height: auto ">
						<div>
							<div class="btn_add_type" onclick="" >吴凡中&nbsp; </div>
							<div class="btn_add_type" onclick="" >张中波&nbsp; </div>
							<div class="btn_add_type" onclick="" >吴凡中&nbsp;</div>
							<div class="btn_add_type" onclick="" >张中波&nbsp;</div>
							<div  style="margin-top: 10px; margin-left: 15px; margin-bottom: 8px;"><input id="share_input" class="tag_input" /> </div>
						</div>
					</div>
					
					
					<div id="sortbtn" style="position: absolute;width: 69px;height: 65px;text-align: center;z-index: 999;top: 83px;left: 803px;
						background: #fff;border: 1px #CACACA solid;display: none;
						border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
						box-shadow:0px 0px 3px #CACACA;-moz-box-shadow:0px 0px 3px #CACACA;-webkit-box-shadow:0px 0px 3px #CACACA;
    					behavior:url(/express/css/PIE2.htc);">
						<div class="btn_add_type" onclick="doChangeSort(this,2)"><img src="/express/task/images/date_wev8.png" style="margin-right: 10px;" align="absMiddle" title="日期"/>日期</div>
						<div class="btn_add_type" style="border-bottom: 0px;" onclick="doChangeSort(this,3)"><img src="/express/task/images/level_wev8.png" style="margin-right: 10px;" align="absMiddle" title="紧急"/>紧急</div>
						<div class="btn_add_type" onclick="doChangeSort(this,1)"><img src="/express/task/images/list_wev8.png" style="margin-right: 10px;" align="absMiddle" title="列表"/>列表</div>
					</div>
					<div id="listview">
						
					</div>
					
				</div>
			</div>
			
			<!-- 明细视图 -->
			<div id="detail" style="width:647px;height:auto;position: absolute;top: 0px;right: 0px;bottom: 1px;z-index: 2;">
				<div id="detaildiv" name="ccm" style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;border-left: 1px #BFC5CC solid;overflow: hidden;">
				     <iframe style="height: 100%;width: 100%;" scrolling="no" frameborder="0" id="detailFrame" name="detailFrame" src="<%=detailsrc%>" ></iframe>
				</div>
				<div id="loading" align='center'>
				<div></div>
				</div>
			</div>
		</div>
		<div id="checknew"></div>
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			var newMap = new Map();
			var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(/express/task/images/bg_ahp_wev8.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(/express/task/images/loading1_wev8.gif) center no-repeat'></div></div>";

			var statuscond = 1;//默认状态为进行中
			var sortcond = 2;//默认分类
			var condtype = 1;//默认为我的任务
			var hrmid = "";
			var tag = "";

			var hrmHeight = 0;
			var tagHeight = 0;
					
			var datatype = 0;//数据类型 默认时间安排

			var deffeedback = "";

			var leveltitle = new Array("未设置紧急程度","重要紧急","重要不紧急","不重要紧急","不重要不紧急");

			var listloadststus = 0;
			var detailloadstatus = 0;
            
			//初始事件绑定
			$(document).ready(function(){
			
				//隐藏主题页面的左侧菜单
				var parentbtn = window.parent.jQuery("#leftBlockHiddenContr");
				//alert(parentbtn.length);
				if(parentbtn.length>0){
					if(window.parent.jQuery("#leftBlockTd").width()>0){
						parentbtn.click();
					}
				}else{
					parentbtn = window.parent.parent.jQuery("#LeftHideShow");
					if(parentbtn.length>0){
						if(parentbtn.attr("title")=="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"){
							parentbtn.click();
						}
					}
				}

				$("#help").bind("mouseover",function(){
					var left = $(this).offset().left-$("#help_content").width()-2;
					$("#help_content").css("left",left).show();
				}).bind("mouseout",function(){
					$("#help_content").hide();
				});
				
				$("#divmenu").bind("mouseenter",function(){
					showMenu();
				}).bind("mouseleave",function(){
					hideMenu();
				});

				$("div.leftmenu").bind("mouseover",function(){
					$("div.leftmenu").removeClass("leftmenu_over");
					$(this).addClass("leftmenu_over");
				}).bind("mouseout",function(){
					$(this).removeClass("leftmenu_over");
				}).bind("click",function(){
					$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
					$(this).addClass("leftmenu_select");
					datatype = $(this).attr("_datatype");
					condtype = $(this).attr("_condtype");
					hrmid = $(this).attr("_hrmid");
					tag = $(this).attr("_tag");
					var mtitle = $($(this).find("div")[0]).html();
					$("#mtitle").html(mtitle);
					$("#micon").css("background","url('/express/task/images/title_icon_"+datatype+".png') no-repeat");
					loadList();
				});

				$("div.btn_add_type").bind("mouseover",function(){
					$("div.btn_add_type").removeClass("btn_add_type_over");
					$(this).addClass("btn_add_type_over");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_add_type_over");
				});

				$("div.main_btn").bind("mouseover",function(){
					$(this).css("color","#004080");
				}).bind("mouseout",function(){
					$(this).css("color","#786571");
				});

				//搜索框事件绑定
				$("#objname").FuzzyQuery({
					url:"/express/task/data/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:'search',
					divwidth: 400,
					updatename:'objname',
					updatetype:''
				});

				$("label.overlabel").overlabel();

				$("#objname").blur(function(e){
					$(this).val("");
					$("label.overlabel").css("text-indent",0);
				});

				//$("div.leftmenu")[0].click();
				datatype ="0";
				condtype ="1";
				hrmid ="";
				tag ="";
				loadList(); //加载数据
				
				//$("#detaildiv").append(loadstr).load("DefaultView.jsp");
				//$("#detaildiv").append(loadstr).load("TaskView.jsp?operation=new&taskType=1");
				//$("#detailFrame").attr("src","TaskView.jsp?operation=new&taskType=1");
                
				hrmHeight = $("#hrmdiv").height();
				tagHeight = $("#tagdiv").height();
				setPosition();

				//列表页中事件绑定
				$("tr.item_tr").live("mouseover",function(){
					$(this).addClass("tr_hover");
				}).live("mouseout",function(){
					$(this).removeClass("tr_hover");
				}).live("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("status") && !$(target).hasClass("item_att") && !$(target).parent().hasClass("item_hrm")){
						$("tr.item_tr").removeClass("tr_select tr_blur");
						$(this).addClass("tr_select");
						doClickItem($(this).find(".disinput"));
					}
				});

				$("div.status_do").live("mouseover",function(){
					var _status = $(this).attr("_status");
					$(this).addClass("status"+_status+"_hover");
				}).live("mouseout",function(){
					var _status = $(this).attr("_status");
					$(this).removeClass("status"+_status+"_hover");
				});

				$("input.disinput").live("keyup",function(event) {
					var keyCode = event.keyCode;
					if (keyCode == 40) {//向下
						moveUpOrDown(1,$(this));
					} else if (keyCode == 38) {//向上
						moveUpOrDown(2,$(this));
					} 
				});

				$("td.item_att").live("click",function(event) {
					var attobj = $(this);
					var _special = $(this).attr("_special");
					var taskid = "";
					if(_special==0 || _special==1){
						taskid = $(this).parent().find("input.disinput").attr("id");
						if(_special==0){
					    	attobj.removeClass("item_att0").addClass("item_att1").attr("_special",1).attr("title","取消关注");
					    	$("#div_att_"+taskid).removeClass("div_att0").addClass("div_att1").attr("_special",1).attr("title","取消关注");
						}else{
							attobj.removeClass("item_att1").addClass("item_att0").attr("_special",0).attr("title","标记关注");
							$("#div_att_"+taskid).removeClass("div_att1").addClass("div_att0").attr("_special",0).attr("title","标记关注");
						}
						$.ajax({
							type: "post",
						    url: "/express/task/data/Operation.jsp",
						    data:{"operation":"set_special","taskid":taskid,"special":_special}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){}
					    });
					}
				});
                
                //标记任务日期
                $(".div_date").live("click",function(event) {
					markDate(this);
					return false; //阻止冒泡事件
				});
				
				checknew();
				setInterval(checknew,300000);
				//$('.scroll1').jScrollPane();
				
				//全选/全不选
				$("#choseAll").bind("click",function(){
					$('[name = check_items]:checkbox').attr("checked",this.checked);
				});
				
				//主复选框与子复选框联动
				$('[name=check_items]:checkbox').live("click",function(){
					var flag = true;
					$('[name=check_items]:checkbox').each(function(){
						if(!this.checked){
							flag = false;
						}
					});
					$("#choseAll").attr('checked',flag);
					
					//return false; //阻止冒泡事件
				});
				$(".tag_input").bind("click",function(e){
					stopBubble(e);
				});
			});

			function checknew(){
				$.ajax({
					type: "post",
				    url: "/express/task/data/Operation.jsp",
				    data:{"operation":"check_new"}, 
				    complete: function(data){
						$("#checknew").html($.trim(data.responseText));
						setnew();
					}
			    });
			}
			function setnew(){
				var mynew = false;
				for(var i=2;i<7;i++){
					var amount = newMap.get("mine"+i);
					if(parseInt(amount)>0){
						if(i<6) mynew = true;
						$("#icon1_"+i).removeClass("cond_icon10").addClass("cond_icon11").attr("title","有新任务或新反馈");
					}else{
						$("#icon1_"+i).removeClass("cond_icon11").addClass("cond_icon10").attr("title","");
					}
				}
				if(mynew){
					$("#icon1_1").removeClass("cond_icon10").addClass("cond_icon11").attr("title","有新任务或新反馈");
				}else{
					$("#icon1_1").removeClass("cond_icon11").addClass("cond_icon10").attr("title","");
				}
			}

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});

			//控制下拉菜单的控制
			$(document).bind("click",function(e){
				$("#statusbtn").hide();
				$("#fiterChose").hide();
				$("#newCreate").hide();
				$("#operate").hide();
				$("#shareTaskToName").hide();
			});

			function hideSearch(){
				$("#fuzzyquery_query_div").slideUp("fast",function() {});
			}
			//显示状态下拉菜单
			function showChangeStatus(e){
				$("#statusbtn").css({
					"left":$("#changestatus").position().left+"px",
					"top":"67px"
				}).show();
				$("#fiterChose").hide();
				$("#newCreate").hide();
				$("#operate").hide();
				stopBubble(e);
			}
			//切换状态
			function doChangeStatus(obj,status){
				var typeName =jQuery(obj).attr("name");
				jQuery("#taskType").html(typeName);
				if(statuscond==status){
					return;
				}else{
					statuscond=status;
					//$("#changestatus").html($(obj).html());
					$("#changestatus").children(".c_img").css("background-image","url('"+$(obj).find("img").attr("src")+"')")
					.attr("title",$(obj).find("img").attr("title"));
					loadList(status);
				}
			}
			//过滤选择
			function doFiter(obj,status){
				$("#fiterChose").hide();
			
			}
			//显示新建下拉菜单
			function showNewCreate(e){
				$("#newCreate").css({
					"left":$("#create").position().left+"px",
					"top":"67px"
				}).show();
				$("#statusbtn").hide();
				$("#fiterChose").hide();
				$("#operate").hide();
			stopBubble(e);
			}
			//显示操作下拉菜单
			function showOperate(e){
				$("#operate").css({
					"left":$("#doOperate").position().left+"px",
					"top":"67px"
				}).show();
				$("#statusbtn").hide();
				$("#fiterChose").hide();
				$("#newCreate").hide();
				stopBubble(e);
			}
			//新建按钮单击事件
			function addTask(taskType){
				//$("#detaildiv").append(loadstr).load("TaskView.jsp?operation=new&taskType="+taskType);
				beforeLoading();
				$("#detailFrame").attr("src","TaskView.jsp?operation=new&taskType="+taskType);
				afterLoading();//iframe加载完成后隐藏loading
			}
			
			
			//显示过滤下拉菜单
			function showFiterSort(e){
				$("#fiterChose").css({
					"left":$("#filter").position().left+"px",
					"top":"67px"
				}).show();
				$("#statusbtn").hide();
				$("#newCreate").hide();
				$("#operate").hide();
				stopBubble(e);
			}
		
			//显示分类下拉菜单
			function showChangeSort(e){
				$("#sortbtn").css({
					"left":$("#changesort").position().left+"px",
					"top":"67px"
				}).show();
				$("#statusbtn").hide();
				$("#fiterChose").hide();
				$("#newCreate").hide();
				$("#operate").hide();
				stopBubble(e);
			}
			//切换分类
			function doChangeSort(obj,status){
				if(sortcond==status){
					return;
				}else{
					sortcond=status;
					//$("#changesort").html($(obj).html());
					$("#changesort").children(".c_img").css("background-image","url('"+$(obj).find("img").attr("src")+"')")
					.attr("title",$(obj).find("img").attr("title"));
					loadList();
				}
			}
			//加载列表部分
			function loadList(taskType){
			    taskType=taskType||0;
				var date = new Date();
				listloadststus = date;
				$("#listview").append(loadstr);//.load("ListView.jsp?status="+statuscond+"&sorttype="+sortcond+"&condtype="+condtype+"&hrmid="+hrmid+"&tag="+tag);
				$.ajax({
					type: "post",
				    url: "ListView.jsp?viewType=<%=viewType%>&taskType="+taskType,
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"status":statuscond,"sorttype":sortcond,"condtype":condtype,"hrmid":hrmid,"tag":encodeURI(tag)}, 
				    complete: function(data){ 
					    if(listloadststus==date){
					    	$("#listview").html(data.responseText);
						}
					}
			    });
			}
			//加载明细部分
			function loadDetail(id,name){
				var upload = document.getElementById("uploadDiv");
				if(upload!=null) upload.innerHTML = "";
				var fbupload = document.getElementById("fbUploadDiv");
				if(fbupload!=null) fbupload.innerHTML = "";
				defaultname = name;
				detailid = id;
				detailloadstatus = id;
				$("#detaildiv").html("").append(loadstr);
				$.ajax({
					type: "post",
				    url: "/express/task/data/DetailView.jsp",
				    data:{"taskId":id}, 
				    complete: function(data){ 
					    if(detailloadstatus==id){
					    	$("#detaildiv").html(data.responseText);
						}
					}
			    });
				$("#objname").blur();
				if($("#"+id).length>0){
					//$("#"+id).parent().parent().click();
					$("#"+id).attr("_defaultname",$("#"+id).val());
					if(!$("#"+id).parent().parent().hasClass("tr_select")){
						$(".item_tr").removeClass("tr_select tr_blur");
						$("#"+id).parent().parent().addClass("tr_select");
					}
				}else{
					$(".item_tr").removeClass("tr_select tr_blur");
				}
			}
			//通过搜索框查询某人时执行的加载列表部分
			function searchList(id,name){
				$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
				datatype = 1;
				condtype = 0;
				hrmid = id;
				tag = "";
				$("#mtitle").html(name);
				$("#micon").css("background","url('/express/task/images/title_icon_"+datatype+".png') no-repeat");
				loadList();
			}
			//替换ajax传递特殊符号
			function filter(str){
				str = str.replace(/\+/g,"%2B");
			    str = str.replace(/\&/g,"%26");
				return str;	
			}
			var speed = 200;
			var w1;
			var w2;
			//设置各部分内容大小及位置
			function setPosition(){
				var width = $("#main").width();
				//if(width>1220){//窗口宽度大于1220时 右侧视图不会浮动在左侧菜单上
					
					//width -= 196; 
					w1 = Math.round(width*4/9)+1;
					w2 = width-w1+1;
					$("#detail").animate({ width:w2 },speed,null,function(){
						
						$("#view").animate({ width:w1 },speed,null,function(){
							//$("#view").animate({ left:196 },speed,null,function(){});
						});
					});
				/*	
				}else{
					width -= 40; 
					w1 = Math.round(width*5/9)+1;
					w2 = width-w1+1;
					$("#detail").animate({ width:w2 },speed,null,function(){
						
						$("#view").animate({ width:w1 },speed,null,function(){
							$("#view").animate({ left:30 },speed,null,function(){	
							});
						});
					});
				}
                */
				//$("#addbtn").hide();
				var lheight = $("#main").height()-301-52;
				var selecth = Math.round(($("#main").height()-301)/2)-26;
				if(hrmHeight<selecth){
					$("#tagdiv").height(lheight-hrmHeight);
					$("#hrmdiv").height(hrmHeight);
				}else{
					if(tagHeight<selecth){
						if((tagHeight+hrmHeight)<lheight){
							$("#hrmdiv").height(hrmHeight);
							$("#tagdiv").height(tagHeight);
						}else{
							$("#hrmdiv").height(lheight-tagHeight);
							$("#tagdiv").height(tagHeight);
						}
					}else{
						$("#hrmdiv").height(selecth);
						$("#tagdiv").height(selecth);
					}
				}

				$("#detaildiv").height($("#detail").height());
			}
			//var aa;
			//显示左侧菜单
			function showMenu(){
				if($(window).width()<=1220){
					$("#view").stop().animate({ left:246 },speed,null,function(){});
					//clearTimeout(aa);
				}
				$("#addbtn").hide();
			}
			//遮挡左侧菜单
			function hideMenu(){
				//判断宽度 以及搜索框是否显示
				if($(window).width()<=1220 && ($("#fuzzyquery_query_div").length==0 || $("#fuzzyquery_query_div").css("display")=="none")){
					//aa = setTimeout(doHide,100);
					doHide();
				}
			}
			function doHide(){
				$("#view").stop().animate({ left:30 },speed,null,function(){});
				$("#addbtn").hide();
			}

			document.onmousedown=click;
			document.oncontextmenu = new Function("return false;")
			function click(e) {
				if (document.all) {
					if (event.button==2||event.button==3) {
						oncontextmenu='return false';
					}
				}
				if (document.layers) {
					if (e.which == 3) {
						oncontextmenu='return false';
					}
				}
			}
			if (document.layers) {
				document.captureEvents(Event.MOUSEDOWN);
			}

			function Map() {    
			    var struct = function(key, value) {    
			        this.key = key;    
			        this.value = value;    
			    }    
			     
			    var put = function(key, value){    
			        for (var i = 0; i < this.arr.length; i++) {    
			            if ( this.arr[i].key === key ) {    
			                this.arr[i].value = value;    
			                return;    
			            }    
			        }    
			        this.arr[this.arr.length] = new struct(key, value);    
			    }    
			         
			    var get = function(key) {    
			        for (var i = 0; i < this.arr.length; i++) {    
			            if ( this.arr[i].key === key ) {    
			                return this.arr[i].value;    
			            }    
			        }    
			        return null;    
			    }    
			         
			    var remove = function(key) {    
			        var v;    
			        for (var i = 0; i < this.arr.length; i++) {    
			            v = this.arr.pop();    
			            if ( v.key === key ) {    
			                continue;    
			            }    
			            this.arr.unshift(v);    
			        }    
			    }    
			         
			    var size = function() {    
			        return this.arr.length;    
			    }    
			         
			    var isEmpty = function() {    
			        return this.arr.length <= 0;    
			    }    
			       
			    this.arr = new Array();    
			    this.get = get;    
			    this.put = put;    
			    this.remove = remove;    
			    this.size = size;    
			    this.isEmpty = isEmpty;    
			}
			
			//显示时间视图
			function showTimeView(){
			    window.location.href="/express/calendar/WorkPlan.jsp";
			}
			
			//标记任务时间
			function markDate(obj){  
			    WdatePicker({
				    isShowClear:false,        //是否显示清空按钮
					isShowOK:false,           //是否显示确定按钮
					//startDate:"2012-10-12", //设置选中日期
				    onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();
						if(new Date(returnvalue.replace(/\-/g, "\/"))<new Date("<%=todaydate%>".replace(/\-/g, "\/"))){
						   alert("标记时间不能小于今天(<%=todaydate%>)");
						   return;
						}
						if(returnvalue=="<%=todaydate%>"){          //移动到今天
						   jQuery(obj).parents("tr:first").appendTo(jQuery("#datalist0"));
						}else if(returnvalue=="<%=tomorrowdate%>"){ //移动到明天
						   jQuery(obj).parents("tr:first").appendTo(jQuery("#datalist1"));
						}else{ //移动到将要
						   jQuery(obj).parents("tr:first").appendTo(jQuery("#datalist2"));
						}   
						jQuery(obj).html("");
						//jQuery(obj).val(returnvalue);
						//doUpdate(obj,1);
						//resetSort();
					}
			  });
			}
			
			 //阻止事件冒泡函数
			 function stopBubble(e)
			 {
			     if (e && e.stopPropagation){
			         e.stopPropagation()
			     }else{
			         window.event.cancelBubble=true
			     }
			}
			//加载消息
			function loadMessage(){
			    beforeLoading();
			    $("#detailFrame").attr("src","/express/ViewMsg.jsp");
			    afterLoading();
			}
			//加载提醒
			function loadRemind(){
			    beforeLoading();
			    $("#detailFrame").attr("src","/express/ViewRemind.jsp");
			    afterLoading();
			}
			//加载主线
			function loadDetailMainline(){
			    beforeLoading();
			    $("#detailFrame").attr("src","/express/task/data/DetailView.jsp");
			    afterLoading();
			}
			
			function beforeLoading(){
			    $("#loading").show();
			}
			
			function afterLoading1(){
			    var iframe=$("#detailFrame")[0];
				if (iframe.attachEvent){
				    iframe.attachEvent("onload", function(){
				        $("#loading").hide();
				    });
				} else {
				    iframe.onreadystatechange = function(){
				    	
				        if (iframe.readyState == "complete"|| iframe.readyState == "loaded"){
				             $("#loading").hide();
				        }
				    };
				}
			}
			
			function afterLoading(){
			    var iframe=$("#detailFrame")[0];
			if (iframe.attachEvent){   
				 iframe.attachEvent("onload", function(){        
				 	$("#loading").hide();   
			});
			} else {   
					iframe.onload = function(){      
					 $("#loading").hide();  
				};}
			}
			
			function shareTask(e){
			   //var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
				$("#shareTaskToName").css({
					"left":"263px",
					"top":"67px"
				}).show();
				stopBubble(e);
			}
			function remindTask(){
			   alert("提醒成功")
			}
			function attTask(){
			   $(".item_att").removeClass("item_att0").addClass("item_att1");;
			   alert("关注成功")
			}
			function markdateTask(obj){
			   WdatePicker({
			        el:$(obj).find("div")[0],
				    isShowClear:false,        //是否显示清空按钮
					isShowOK:false,           //是否显示确定按钮
					//startDate:"2012-10-12", //设置选中日期
				    onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();
						if(new Date(returnvalue.replace(/\-/g, "\/"))<new Date("<%=todaydate%>".replace(/\-/g, "\/"))){
						   alert("标记时间不能小于今天(<%=todaydate%>)");
						   return;
						}
						//jQuery(obj).html("");
						//jQuery(obj).val(returnvalue);
						//doUpdate(obj,1);
						//resetSort();
					}
			  });
			  return false; //阻止冒泡事件
			}
		</script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
        <SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>
