
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ include file="/express/task/util/uploader.jsp" %>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <script language="javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
   <script language="javascript" src="/express/js/jquery.fuzzyquery.min_wev8.js"></script>
   <script src="/express/js/jquery.textarea.autoheight_wev8.js"></script>
   <script src="/express/js/jquery.ui.datepicker_wev8.js"></script>
   <script src="/express/js/jquery.ui.core_wev8.js"></script>
   <script src="/express/js/jquery.ui.widget_wev8.js"></script>
   <link rel="stylesheet" href="/express/css/base_wev8.css" />
   
   <style>
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
			 
			.input_inner{height:26px;width:220px;margin-left:0px;margin-right:0px;border:0px;font-size:12px;margin-top: 0px;margin-bottom: 0px;font-family:微软雅黑;
				border: 1px #B4B4B4 solid;box-shadow:0px 0px 2px #B4B4B4;-moz-box-shadow:0px 0px 2px #B4B4B4;-webkit-box-shadow:0px 0px 2px #B4B4B4;
				border-radius: 4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;padding-left: 2px;}
		
			.div_line{height:50%;border-bottom:2px #EEEFEF solid;float:left;}
		
			.btn_add_type{width: 85%;line-height: 25px;cursor: pointer;font-family: 微软雅黑;padding-left: 15px;}
			.btn_add_type img{margin-top: -1px;}
			.btn_add_type_over{background-color: #75B5DF;color: #FAFAFA;}
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
   
   </style>
</head>
<body>
<%
	String taskId = Util.null2String(request.getParameter("labelid"));

String operator=Util.null2String(request.getParameter("operator"));//查询关键字
	String labelName = "";
	rs.executeSql("select * from task_label where id ="+taskId);
	while(rs.next()){
		labelName = rs.getString("name");
	}
	if(taskId.equals("0")){
		labelName = "新建标签";
	}
	boolean canedit = false;
	rs.executeSql("select id,name,level,status,remark,risk,difficulty,assist,tag,principalid,begindate,enddate,taskids,docids,wfids,meetingids,crmids,projectids,fileids,creater,createdate,createtime"
			+",isnull((select distinct 1 from TM_TaskSpecial tts where tts.taskid=TM_TaskInfo.id and tts.userid="+user.getUID()+"),0) as special"
			+",(select top 1 tlog.operatedate+' '+tlog.operatetime from TM_TaskLog tlog where tlog.taskid=TM_TaskInfo.id and tlog.type=0 and tlog.operator="+user.getUID()+" order by tlog.operatedate desc,tlog.operatetime desc) as viewdate"
			+" from TM_TaskInfo where id="+taskId+" and (deleted=0 or deleted is null)");
	rs.next();
	String name = Util.toScreen(rs.getString("name"),user.getLanguage());
	String level = Util.null2String(rs.getString("level"));
	String status = Util.null2String(rs.getString("status"));
	String statusstr = "进行中";
	if(status.equals("2")) statusstr = "完成";
	if(status.equals("3")) statusstr = "撤销";
	String remark = Util.convertDbInput(Util.null2String(rs.getString("remark")));
	String risk = Util.convertDbInput(Util.null2String(rs.getString("risk")));
	String difficulty = Util.convertDbInput(Util.null2String(rs.getString("difficulty")));
	String assist = Util.convertDbInput(Util.null2String(rs.getString("assist")));
	String tag = Util.toScreen(rs.getString("tag"),user.getLanguage());
	String principalid = Util.null2String(rs.getString("principalid"));
	String begindate = Util.null2String(rs.getString("begindate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String taskids = Util.null2String(rs.getString("taskids"));
	String docids = Util.null2String(rs.getString("docids"));
	String wfids = Util.null2String(rs.getString("wfids"));
	String meetingids = Util.null2String(rs.getString("meetingids"));
	String crmids = Util.null2String(rs.getString("crmids"));
	String projectids = Util.null2String(rs.getString("projectids"));
	String fileids = Util.null2String(rs.getString("fileids"));
	String creater = Util.null2String(rs.getString("creater"));
	String createdate = Util.null2String(rs.getString("createdate"));
	String createtime = Util.null2String(rs.getString("createtime"));
	int special = Util.getIntValue(rs.getString("special"),0);
	String viewdate = Util.null2String(rs.getString("viewdate"));
	String creatTime ="";
	rs.executeSql("select * from task_label where id="+taskId);
	while(rs.next()){
		int userId  = rs.getInt("id");
		 creatTime = rs.getString("createdate");
	}
	
%>
<style type="text/css">
     html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
	 *{font-size: 12px;font-family: Arial,'微软雅黑';outline:none;}
	.datatable{width: 100%;}	
	.datatable td{padding-left: 5px;padding-top:1px;padding-bottom:1px;text-align: left;}
	.datatable td.title{font-family: 微软雅黑;color: #999999;vertical-align: top;padding-top: 7px;padding-bottom: 7px;padding-left: 20px;background: #F6F6F6;border-top: 1px #F6F6F6 solid;border-bottom: 1px #F6F6F6 solid;}
	.datatable td.data{vertical-align: middle;border-top: 1px #fff solid;border-bottom: 1px #fff solid;}
	.feedrelate{display: none;}
	.feedrelate td{background: #fff !important;border-top: 1px #fff solid !important;border-bottom: 1px #fff solid !important;}
	
	.div_show{word-wrap:break-word;word-break:break-all;width: 90%;line-height: 20px;min-height:20px;}
	.div_show p{padding: 0px;margin: 0px;line-height: 20px !important;}
	.input_def{word-wrap:break-word;word-break:break-all;width: 90%;height:23px;line-height: 23px;border: 1px #fff solid;padding-left: 4px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;behavior:url(/express/css/PIE2.htc);}
	.input_over{border: 1px #F0F0F0 solid;background: #fff;}
	.input_focus{border: 1px #1A8CFF solid;background: #fff;box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;}
	.content_def{width: 90%;min-height:20px;line-height: 20px;border: 1px #fff solid;padding: 3px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;text-align: left;behavior:url(/express/css/PIE2.htc);}
	.content_def p{padding: 0px;margin: 0px;}
	.content_over{border: 1px #F0F0F0 solid;background: #fff;}
	.content_focus{border: 1px #1A8CFF solid;background: #fff;box-shadow:0px 0px 3px #1A8CFF;-moz-box-shadow:0px 0px 3px #1A8CFF;-webkit-box-shadow:0px 0px 3px #1A8CFF;}
	.feedback_def{width: 90%;min-height:30px;margin-bottom:30px;line-height: 20px !important;border: 1px #D7D7D7 solid;padding: 0px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;text-align: left;behavior:url(/express/css/PIE2.htc);}
	.feedback_def p{padding: 0px;margin: 0px;line-height: 20px !important;}
	.feedback_over{border: 1px #C8C8C8 solid;}
	.feedback_focus{min-height:50px;margin-bottom: 5px;border: 1px #1A8CFF solid;box-shadow:0px 0px 3px #1A8CFF;-moz-box-shadow:0px 0px 3px #1A8CFF;-webkit-box-shadow:0px 0px 3px #1A8CFF;}
	a.slink{padding-right: 5px;border-right: 0px #DBDBDB dashed;}
	a.slink,a.slink:active,a.slink:visited{color: #DBDBDB !important;text-decoration: none;}
	a.slink:hover{color: #1A8CFF !important;text-decoration: underline;}
	a.sdlink{color: #000 !important;text-decoration: none !important;cursor: default;font-weight: bold;}
	a.sdlink:hover,a.sdlink:active,a.sdlink:visited{color: #000 !important;text-decoration: none !important;}
	
	#rightinfo a,#rightinfo a:active,#rightinfo a:visited{text-decoration: none;color: #000000;}
	#rightinfo a:hover{text-decoration: underline;color: #0080FF;}
	
	tr.tr_over td{background: #F4F4F4 !important;border-top:1px #E6E9EC solid !important;border-bottom:1px #E6E9EC solid !important;}
	.upload{display: ;float: left;}
	tr.tr_over .upload{display: ;}
	.btn_add{width:40px;height:22px;float: left;margin-left: 10px;margin-top: 1px;margin-bottom: 1px;
		background: url('/express/task/images/edit_wev8.png') center no-repeat;display: none;cursor: pointer;}
	.btn_browser{width:40px;height:22px;float: left;margin-left: 5px;margin-top: 1px;margin-bottom: 1px;display: none;cursor: pointer;
		background: url('/express/task/images/browser_wev8.png') center no-repeat !important;}
	.browser_hrm{background: url('/express/task/images/browser_wev8.png') center no-repeat;}
	.browser_doc{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_wf{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_meeting{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_crm{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.browser_proj{background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;}
	.add_input{width: 100px;height:20px;line-height: 20px;border: 1px #fff solid;padding-left: 2px;display: none;margin-left：5px;
		border: 1px #1A8CFF solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
		box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;float: left;
		behavior:url(/express/css/PIE2.htc);}
		
	.txtlink{line-height:24px;float: left;margin-left: 3px;}
	
	.btn_del{width: 16px;height: 16px;background: url('/express/task/images/mainline_wev8.png') no-repeat -80px -126px;display: none;cursor: pointer;float: left;margin-left: 0px;}
	.btn_wh{width: 16px;height: 16px;float: left;margin-left: 0px;}
	
	.dtitle{width: 100%;height: 31px;line-height: 26px;font-weight: bold;border-bottom: 0px #E8E8E8 solid;cursor: pointer;
		background: url('/express/images/title_bg_01_wev8.png') repeat-x;}
	.dtxt{height: 26px;float: left;margin-left: 10px;font-family: 微软雅黑;}
	
	.btn_feedback{width: 50px;text-align: center;line-height: 18px;cursor: pointer;float: left;font-family: 微软雅黑;
		background-color: #67B5E9;color:#fff;margin-left: 20px;margin-bottom: 5px;display: none;margin-top: 5px;
		border: 1px #50A9E4 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
		box-shadow:0px 0px 2px #8EC8EE;-moz-box-shadow:0px 0px 2px #8EC8EE;-webkit-box-shadow:0px 0px 2px #8EC8EE;
		behavior:url(/express/css/PIE2.htc);
	}
	.btn_feedback_hover{background-color: #1F8DD6;}
	
	.fbdata{border-bottom: 1px #EFEFEF dashed !important;}
	.feedbackshow{width: 90%;margin-left: 20px;margin-top: 3px;margin-bottom: 3px;overflow: hidden;}
	.feedbackinfo{width: auto;line-height: 24px;color: #808080;}
	.feedbackinfo a,.feedbackinfo a:active,.feedbackinfo a:visited{text-decoration: none !important;color: #808080 !important;}
	.feedbackinfo a:hover{text-decoration: underline !important;color: #0080FF !important;}
	.feedbackrelate{width: auto;line-height: 24px;background: #F9F9F9;overflow:hidden;padding:5px;
		border: 1px #E7E7E7 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
		box-shadow:0px 0px 2px #E7E7E7;-moz-box-shadow:0px 0px 2px #E7E7E7;-webkit-box-shadow:0px 0px 2px #E7E7E7;
		behavior:url(/express/css/PIE2.htc);
	}
	.feedbackrelate .relatetitle{color: #808080}
	.feedbackrelate a,.feedbackrelate a:active,.feedbackrelate a:visited{text-decoration: none !important;color: #1D76A4 !important;}
	.feedbackrelate a:hover{text-decoration: underline !important;color: #FF0000 !important;}
	.feedbackshow p{padding: 0px;margin: 0px;line-height: 20px !important;}
	
	.btn_operate{width: 60px;text-align: center;line-height: 18px;cursor: pointer;float: left;font-family: 微软雅黑;
		color:#808080;margin-left: 5px;margin-bottom: 0px;
		border: 1px #D2D2D2 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
		box-shadow:1px 1px 3px #FDFDFD;-moz-box-shadow:1px 1px 3px #FDFDFD;-webkit-box-shadow:1px 1px 3px #FDFDFD;
		background:-webkit-gradient(linear, 0 0, 0 bottom, from(#FDFDFD), to(#EEEEEE));
    	background:-moz-linear-gradient(#FDFDFD, #EEEEEE);
    	-pie-background:linear-gradient(#FDFDFD, #EEEEEE);
    	behavior:url(/express/css/PIE2.htc);}
	.btn_complete{background-color: #34AD00;color:#fff;border: 1px #34AD00 solid;
		box-shadow:0px 0px 2px #34AD00;-moz-box-shadow:0px 0px 2px #34AD00;-webkit-box-shadow:0px 0px 2px #34AD00;
		background:-webkit-gradient(linear, 0 0, 0 bottom, from(#34AD00), to(#34AD00));
    	background:-moz-linear-gradient(#34AD00, #34AD00);
    	-pie-background:linear-gradient(#34AD00, #34AD00);}
	.btn_revoke{background-color: #FF6060;color:#fff;border: 1px #FF6060 solid;
		box-shadow:0px 0px 2px #FF6060;-moz-box-shadow:0px 0px 2px #FF6060;-webkit-box-shadow:0px 0px 2px #FF6060;
		background:-webkit-gradient(linear, 0 0, 0 bottom, from(#FF6060), to(#FF6060));
    	background:-moz-linear-gradient(#FF6060, #FF6060);
    	-pie-background:linear-gradient(#FF6060, #FF6060);
    	}
    .btn_hover{background:#EEEEEE;
		background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F9F9F9), to(#D7D7D7)) !important;
    	background:-moz-linear-gradient(#F9F9F9, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F9F9F9, #D7D7D7) !important;
    	}
		
	.createinfo{line-height: 18px;font-style: italic;font-size: 12px;color: #B2B2B2;position: absolute;right: 10px;top: 2px;}
	.createinfo a,.createinfo a:active,.createinfo a:visited{text-decoration: none;color: #B2B2B2 !important;}
	.createinfo a:hover{text-decoration: underline;color: #0080FF;}
	
	#logdiv{padding-top: 10px;padding-bottom: 10px;}
	.logitem{margin-left: 15px;color: #9999A5;line-height: 20px;}
	.logitem p{line-height: 20px !important;margin: 0px;padding: 0px;}
	.logitem a,.logitem a:active,.logitem a:visited{text-decoration: none;color: #9999A5 !important;}
	.logitem a:hover{text-decoration: underline;}
	.datetxt{color: #DACFCC;}
	
	.div_att{width:18px;height:20px;float: left;margin-left: 5px;cursor: pointer;}
	.div_att0{background: url('/express/task/images/icon_special_wev8.png') center no-repeat;}
	.div_att1{background: url('/express/task/images/icon_special2_wev8.png') center no-repeat;}
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<input type="hidden" id="taskid" name="taskid" value="<%=taskId %>"/>
	
	<div style="width: 100%;height: 30px;position: relative;overflow:hidden;
	background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important; display: none;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div style="position: absolute;top: 0px;left: 0px;height: 100%;z-index: 5;">
			<div id="div_att_<%=taskId %>" class="div_att div_att<%=special %>" title="<%if(special==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=special %>"></div>
			<%if(canedit){ 
			%>
				<div class="btn_operate " <%if(!status.equals("1")){ %>style="display: none"<%} %> onmouseover="hideop(this,'btn_hover','完成')" onmouseout="showop(this,'btn_hover','完成')" onclick="doOperate(2)" title="设置为完成">完成</div>
				<div class="btn_operate " <%if(!status.equals("1")){ %>style="display: none"<%} %> onmouseover="hideop(this,'btn_hover','撤销')" onmouseout="showop(this,'btn_hover','撤销')" onclick="doOperate(3)" title="设置为撤销">撤销</div>
				<div class="btn_operate btn_complete" onmouseover="showop(this,'btn_complete','进行中')" onmouseout="hideop(this,'btn_complete','已完成')" <%if(!status.equals("2")){ %>style="display: none"<%} %> onclick="hideop(this,'btn_complete','已完成');doOperate(1)" title="设置为进行中">已完成</div>
				<div class="btn_operate btn_revoke" onmouseover="showop(this,'btn_revoke','进行中')" onmouseout="hideop(this,'btn_revoke','已撤销')" <%if(!status.equals("3")){ %>style="display: none"<%} %> onclick="hideop(this,'btn_revoke','已撤销');doOperate(1)" title="设置为进行中">已撤销</div>
				<div class="btn_operate btn_delete" onmouseover="hideop(this,'btn_hover','删除')" onmouseout="showop(this,'btn_hover','删除')" onclick="doOperate(4)" title="删除任务">删除</div>
			<%} %>
				<div class="btn_operate btn_delete" onmouseover="hideop(this,'btn_hover','反馈')" onmouseout="showop(this,'btn_hover','反馈')" onclick="showFeedback()" title="任务反馈">反馈</div>
				<%if(!canedit){%><div style="float: left;font-style: italic;margin-top: 3px;color: #B2B2B2;margin-left: 3px;">(不具有编辑权限)</div><%} %>
			</div>
			<div style="display: block;" class="createinfo" title="创建人:<%=ResourceComInfo.getLastname(creater) %> 创建时间:<%=createdate %> <%=createtime %>"><%=cmutil.getHrm(creater) %> <%=createdate %> <%=createtime %></div>
		</div>
	</div>

	
	<div style="display: block; margin-top: 20px;" class="createinfo" title="创建人:<%=ResourceComInfo.getLastname(creater) %> 创建时间:<%=createdate %> <%=createtime %>"><%=cmutil.getHrm(creater) %> <%=createdate %> <%=createtime %></div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:40px;left:0px;bottom:0px;border-top:0px #E8E8E8 solid;" class="scroll1" align="center">
		<div class="dtitle" title="点击收缩"><div class="dtxt">标签信息</div></div>
		<table class="datatable" cellpadding="0" cellspacing="0" border="0" align="center">
			<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
				<TBODY>		
			
				<tr>
					<td class="title">标签名称</TD>
					<td class="data">
				  			<textarea  onkeyup="changeListName(this)"  class="input_def" id="name" style="font-weight: bold;font-size: 16px;overflow: hidden;resize:none;"><%=labelName %></textarea>
				  	</td>
				</tr>
					
				
				</TBODY>
  		</table>
  	
  		<table id="feedbacktable" style="width: 100%;margin: 0px auto;text-align: left; display: none;" cellpadding="0" cellspacing="0" border="0">
				<%
					int feedbackcount = 0;
					String lastid = "";
					rs.executeSql("select count(*) from TM_TaskFeedback where taskid="+taskId);
					if(rs.next()){
						feedbackcount = Util.getIntValue(rs.getString(1),0);
					}
					boolean hasnewfb = false;
					if(feedbackcount>0){
						rs.executeSql("select top 3 id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from TM_TaskFeedback where taskid=" + taskId +" order by createdate desc,createtime desc");
						while(rs.next()){
							lastid = Util.null2String(rs.getString("id"));
							
				%>
				<tr>
					<td class="data fbdata" >
						<div class="feedbackshow">
							<div class="feedbackinfo" style="display: none;"><%=cmutil.getHrm(rs.getString("hrmid")) %> <%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")) %>
								<%if(!viewdate.equals("") && !(user.getUID()+"").equals(rs.getString("hrmid")) && TimeUtil.timeInterval(viewdate,Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime")))>0){
									hasnewfb = true;
								%>
					 			<font style="color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;" title="新反馈">new</font><%} %>
							</div>
					
						</div>
					</td>
				</tr>
				<%
						}
					}
					int lastcount = feedbackcount-3;
					if(lastcount>0){
				%>
				<%		
						
					}
					
				%>
				
		</table>
  	
	</div>
</div>
<script language=javascript defer>
	
</script>
<script language="javascript">
	var tempval = "";
	var tempbdate = "<%=begindate%>";
	var tempedate = "<%=enddate%>";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var taskid = <%=taskId%>;
	$(document).ready(function(){
		<%if(canedit){%>
		$("#name").textareaAutoHeight({ minHeight:25 });
		var textarea= document.getElementById("name"); 
		//alert(textarea.clientHeight);
		
		//日期控件绑定
		$.datepicker.setDefaults( {
			"dateFormat": "yy-mm-dd",
			"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
			"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
			"changeMonth": true,
			"changeYear": true} );
		$( "#begindate" ).datepicker({
			"onSelect":function(){
				if($("#begindate").val()!="" && $("#enddate").val()!="" && !compdate($("#begindate").val(),$("#enddate").val())){
					alert("开始日期不能大于结束日期!");
					$("#begindate").val(tempbdate);
					return;
				}else{
					tempbdate = $("#begindate").val();
					doUpdate(this,1);
					resetSort();
				}
			}
		}).datepicker("setDate","<%=begindate%>");
		$( "#enddate" ).datepicker({
			"onSelect":function(){
				if($("#begindate").val()!="" && $("#enddate").val()!="" && !compdate($("#begindate").val(),$("#enddate").val())){
					alert("结束日期不能小于开始日期!");
					$("#enddate").val(tempedate);
					return;
				}else{
					tempedate = $("#enddate").val();
					doUpdate(this,1);
					resetSort();
				}
			}
		}).datepicker("setDate","<%=enddate%>");
		<%}%>

		//分类信息收缩展开动作绑定
		$("div.dtitle").bind("click",function(){
			if($(this).attr("_click")!=0){
				var table = $(this).next("table.datatable");
				table.toggle();
				if(table.css("display")=="none"){
					$(this).attr("title","点击展开");
				}else{
					$(this).attr("title","点击收缩");
				}
			}
		});

		//表格行背景效果及操作按钮控制绑定
		$("table.datatable").find("tr").bind("click mouseenter",function(){
			$(".btn_add").hide();$(".btn_browser").hide();
			$(this).addClass("tr_over");
			$(this).find(".input_def").addClass("input_over");
			$(this).find("div.content_def").addClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").show();
				$(this).find("div.btn_browser").show();
			}
		}).bind("mouseleave",function(){
			$(this).removeClass("tr_over");
			$(this).find(".input_def").removeClass("input_over");
			$(this).find("div.content_def").removeClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").hide();
				$(this).find("div.btn_browser").hide();
			}
		});

		//输入添加按钮事件绑定
		$("div.btn_add").bind("click",function(){
			$(this).hide();
			$(this).nextAll("div.btn_browser").hide();
			$(this).prevAll("div.showcon").hide();
			$(this).prevAll("input.add_input").show().focus();
			$(this).prevAll("div.btn_select").show()
		});

		//单行文本输入框事件绑定
		$(".input_def").bind("mouseover",function(){
			$(this).addClass("input_over");
		}).bind("mouseout",function(){
			$(this).removeClass("input_over");
		}).bind("focus",function(){
			$(this).addClass("input_focus");
			tempval = $(this).val();
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
			if($(this).attr("id")=="name"){
				oldname = $(this).val();
				//document.onkeyup=keyListener4;
			}
		}).bind("blur",function(){
			$(this).removeClass("input_focus");
			doUpdate(this,1);
			//document.onkeydown=null;
			//document.onkeyup=null;
		});
		$("#tag").bind("focus",function(){
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(){
			//document.onkeydown=null;
		});
		//多行文本输入框事件绑定
		$("div.content_def").bind("mouseover",function(){
			$(this).addClass("content_over");
		}).bind("mouseout",function(){
			$(this).removeClass("content_over");
		}).bind("focus",function(){
			$(this).addClass("content_focus");
			tempval = $(this).html();
		}).bind("blur",function(){
			$(this).removeClass("content_focus");
			doUpdate(this,2);
		});
		$("div.feedback_def").bind("mouseover",function(){
			$(this).addClass("feedback_over");
		}).bind("mouseout",function(){
			$(this).removeClass("feedback_over");
		}).bind("focus",function(){
			$(this).html(deffeedback).addClass("feedback_focus");
			$("div.btn_feedback").show();
			$("#fbrelatebtn").show();
			setFBP();
		});

		$("div.btn_feedback").bind("mouseover",function(){
			$(this).addClass("btn_feedback_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("btn_feedback_hover");
		})

		//联想输入框事件绑定
		$("input.add_input").bind("focus",function(){
			if($(this).attr("_init")==1){
				$(this).FuzzyQuery({
					url:"/express/task/data/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:$(this).attr("_searchtype"),
					divwidth: $(this).attr("_searchwidth"),
					updatename:$(this).attr("id"),
					updatetype:"str",
					currentid:"<%=taskId%>",
					intervalTop:4
				});
				$(this).attr("_init",0);
			}
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(e){
			//if($(this).attr("id")=="tag" && $(this).val()!=""){
			//	selectUpdate("tag",$(this).val(),$(this).val(),"str");
			//}
			$(this).val("");
			$(this).hide();
			$(this).nextAll("div.btn_add").show();
			$(this).nextAll("div.btn_browser").show();
			$(this).prevAll("div.showcon").show();
			//document.onkeydown=null;
		});

		//反馈信息内容样式
		$("#feedbacktable").find(".data").live("mouseover",function(){
			$(this).css("background-color","#F7FBFF");
		}).live("mouseout",function(){
			$(this).css("background-color","#fff");
		});

		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				$("table.feedrelate").show();
				$(this).attr("_status",1).css("background", "url('/express/task/images/btn_up_wev8.png') right no-repeat");
			}else{
				$("table.feedrelate").hide();
				$(this).attr("_status",0).css("background", "url('/express/task/images/btn_down_wev8.png') right no-repeat");
			}
			setFBP();
		});

		//关注按钮事件绑定
		$("#div_att_<%=taskId %>").bind("click",function(event) {
			var _special = $(this).attr("_special");
			if(_special==0 || _special==1){
				if(_special==0){
					$(this).removeClass("div_att0").addClass("div_att1").attr("_special",1).attr("title","取消关注");
					$("#<%=taskId %>").parent().nextAll("td.item_att").removeClass("item_att0").addClass("item_att1").attr("_special",1).attr("title","取消关注");
				}else{
					$(this).removeClass("div_att1").addClass("div_att0").attr("_special",0).attr("title","标记关注");
					$("#<%=taskId %>").parent().nextAll("td.item_att").removeClass("item_att1").addClass("item_att0").attr("_special",0).attr("title","标记关注");
				}
				$.ajax({
					type: "post",
				    url: "/express/task/data/Operation.jsp",
				    data:{"operation":"set_special","taskid":<%=taskId%>,"special":_special}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){}
			    });
			}
		});
		
		bindUploaderDiv($("#uploadDiv"),"relatedacc","<%=taskId%>");
		bindUploaderDiv($("#fbUploadDiv"),"fbfileids","");
	});
	function uploadFile(){
		uploader.startUpload();
	}
	function doSaveAfterAccUpload(){
		
		var index = $("#uploadDiv").attr("_index");
		var fieldvalue = $("#relateAccDocids_"+index).val();
		exeUpdate("fileids",fieldvalue,"add");
		$("#fsUploadProgress_"+index).html("");
	}
	function setFBP(){
		var maininfo = document.getElementById("maininfo");
		var hh = $("#fbbottom").offset().top-($("#main").height()-26);
		if(hh>0){
			maininfo.scrollTop += hh;
		}
	}

	//显示删除按钮
	function showdel(obj){
		$(obj).find("div.btn_del").show();
		$(obj).find("div.btn_wh").hide();
	}
	//隐藏删除按钮
	function hidedel(obj){
		$(obj).find("div.btn_del").hide();
		$(obj).find("div.btn_wh").show();
	}

	//回车事件方法
	function keyListener2(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){    
	    	$(foucsobj2).blur();   
	    }    
	}
	//同步名称方法
	function keyListener4(e){
	    e = e ? e : event;   
	    $("#<%=taskId%>").val($(foucsobj2).val()).attr("title",$(foucsobj2).val());  
	}
	//输入框保存方法
	function doUpdate(obj,type){
		var fieldname = $(obj).attr("id");
		var fieldvalue = "";
		if(type==1){
			if($(obj).val()==tempval) return;
			fieldvalue = $(obj).val();
		}
		if(type==2){
			if($(obj).html()==tempval) return;
			fieldvalue = $(obj).html();
		}
		if(fieldname=="name"){
			if($.trim(fieldvalue)==""){
				$("#<%=taskId%>").val(oldname);
				$(obj).val(oldname);
				return;
			}
			$("#<%=taskId%>").val(fieldvalue);
		}
		exeUpdate(fieldname,fieldvalue,"str");
	}
	//删除选择性内容
	function delItem(fieldname,fieldvalue){
		$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
		if(fieldname=="docids"||fieldname=="wfids"||fieldname=="meetingids"||fieldname=="crmids"||fieldname=="projectids"||fieldname=="taskids"||fieldname=="tag"||startWith(fieldname,"_")){
			var vals = $("#"+fieldname+"_val").val();
			var _index = vals.indexOf(","+fieldvalue+",")
			if(_index>-1 && $.trim(fieldvalue)!=""){
				vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
				$("#"+fieldname+"_val").val(vals);
				if(!startWith(fieldname,"_")){
					exeUpdate(fieldname,vals,'str',fieldvalue);
				}
			}
		}else{
			exeUpdate(fieldname,fieldvalue,'del');
		}
		if(fieldname == "principalid") $("#<%=taskId%>").parent().nextAll("td.item_hrm").html("");//设置列表中责任人
	}
	//选择内容后执行更新
	function selectUpdate(fieldname,id,name,type){
		var addtxt = "";
		var addids = "";
		var addvalue = "";
		if(fieldname == "principalid"){
			if(id==$("#principalid_val").val()){
				return;
			}else{
				$("#"+fieldname+"_val").val(id);
				//设置列表中责任人
				$("#<%=taskId%>").parent().nextAll("td.item_hrm").html("<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>");
			}
			addtxt = transName(fieldname,id,name);
			addids = id;
		}else{
			var ids = id.split(",");
			var names = name.split(",");
			var vals = $("#"+fieldname+"_val").val();
			for(var i=0;i<ids.length;i++){
				if(vals.indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
					addids += ids[i] + ",";
					addvalue += ids[i] + ",";
					addtxt += transName(fieldname,ids[i],names[i]);
				}
			}
			$("#"+fieldname+"_val").val(vals+addids);
			if(fieldname != "partnerid" && fieldname != "sharerid") addids = vals+addids;
		}
		if(fieldname == "principalid") $("#"+fieldname).prev("div.txtlink").remove();
		$("#"+fieldname).before(addtxt);
		if(!startWith(fieldname,"_")){
			if(fieldname != "partnerid" && fieldname != "sharerid" && fieldname != "principalid" && addvalue=="") return;
			exeUpdate(fieldname,addids,type,"",addvalue);
		}
	}
	//执行编辑
	function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue){
		if(typeof(delvalue)=="undefined") delvalue = "";
		if(typeof(addvalue)=="undefined") addvalue = "";
		var str = $("#str",parent.document).attr("value");
		var labelId = $("#taskid").attr("value");
		$.post("/express/task/data/Operation.jsp?operation=edit_label&labelId=" + labelId +"&fieldname="+fieldname+"&fieldvalue="+fieldvalue+"&fieldtype="+fieldtype+"&ids="+str,function(data){
			$('#label_name', parent.document).html(fieldvalue);
		});
	}
	//修改紧急程度
	function setLevel(id){
		if($("#level"+id).hasClass("sdlink")) return;
		$("a.slink").removeClass("sdlink");
		$("#level"+id).addClass("sdlink").attr("href","###");
		exeUpdate("level",id,"int");
		//设置列表中图标
		$("#level_<%=taskId%>").css("background","url('/express/task/images/level_0"+id+".png') center no-repeat").attr("title",leveltitle[id]);
		//设置列表中位置
		if(sorttype==3){
			var obj = $("#<%=taskId%>").parent().parent();
			var newtr = $("<tr class='item_tr tr_select'>"+obj.html()+"</tr>");
			newtr.find("#<%=taskId%>").val($("#<%=taskId%>").val());//此处需要重新设置一下标题
			$($($("table.datalist")[id-1]).find(".definput")[0]).parent().parent().before(newtr);
			obj.remove();
		}
	}
	//调整日期
	function resetSort(){
		var begindate = $("#begindate").val();
		var enddate = $("#enddate").val();
		var datetype = 0;
		if(begindate=="" && enddate==""){
			datetype = 4;
		}else if((begindate!="" && enddate!="" && compdate(begindate,currentdate) && compdate(currentdate,enddate))
			||(begindate!="" && enddate=="" && compdate(begindate,currentdate))
			||(begindate=="" && enddate!="" && compdate(currentdate,enddate))){
			datetype = 1;
		}else if(begindate!="" &&  begindate!=currentdate && compdate(currentdate,begindate)){
			datetype = 2;
		}else if(enddate!="" &&  enddate!=currentdate && compdate(enddate,currentdate)){
			datetype = 3;
		}
		if(datetype==1){$("#today_<%=taskId%>").html("今天").attr("title","今天的任务");}else{$("#today_<%=taskId%>").html("&nbsp;").attr("title","");}
		if(sorttype!=2) return; 
		var table = $("#<%=taskId%>").parents("table.datalist")[0];
		if($(table).attr("_datetype")!=datetype){
			var obj = $("#<%=taskId%>").parent().parent();
			var newtr = $("<tr class='item_tr tr_select'>"+obj.html()+"</tr>");
			$($($("table.datalist")[datetype-1]).find("input.definput")[0]).parent().parent().before(newtr);
			obj.remove();
		}
	}
	function showFeedback(){
		$("#content").focus();
	}
	//反馈
	function doFeedback(){
		if($("#content").html()==""||$("#content").html()=="<br>"){
			alert("请输入内容!");
			return;
		}
		try{
			var oUploader=window[$("#fbUploadDiv").attr("oUploaderIndex")];
			if(oUploader.getStats().files_queued==0){ //如果没有选择附件则直接提交
				exeFeedback();  //提交
			}else{ 
 				oUploader.startUpload();
			}
		}catch(e) {
			exeFeedback();
	  	}
	}
	function exeFeedback(){
		$("div.btn_feedback").hide();
		$("#submitload").show();
		$.ajax({
			type: "post",
		    url: "/express/task/data/Operation.jsp",
		    data:{"operation":"add_feedback","taskId":<%=taskId%>,"content":filter(encodeURI($("#content").html())),"docids":$("#_docids_val").val(),"wfids":$("#_wfids_val").val(),"crmids":$("#_crmids_val").val(),"projectids":$("#_projectids_val").val(),"fileids":$("input[name=fbfileids]").val()}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
			    /**
		    	data=$.trim(data.responseText);
		    	if(data!=""){
		    		$("#feedbacktable").prepend(data);
			    }*/
			    if(data!=""){
			    	var txt = $.trim(data.responseText);
			    	$("#feedbacktable").prepend(txt.split("$")[0]);
			    	$("#logdiv").prepend(txt.split("$")[1]);
			    }
			    
		    	$("#submitload").hide();
		    	deffeedback = "";
		    	doCancel();
		    	var fbobj = $("#<%=taskId%>").parent().nextAll("td.item_count");
		    	if(fbobj.length>0){
					var fbcount = $(fbobj[0]).html();
					if(fbcount==""||fbcount=="&nbsp;"){
						$(fbobj[0]).html("(1)").attr("title","1条反馈");
					}else{
						$(fbobj[0]).html("("+(parseInt(fbcount.substring(1,fbcount.length-1))+1)+")").attr("title",(parseInt(fbcount.substring(1,fbcount.length-1))+1)+"条反馈");
					}
			    }
			}
	    });
	}
	//取消反馈
	function doCancel(){
		$("#_crmids_val").val("");$("#_docids_val").val("");$("#_wfids_val").val("");$("#_projectids_val").val("");$("input[name=fbfileids]").val("");

		$("div.feedback_def").html("").removeClass("feedback_focus");
		$("div.btn_feedback").hide();
		if($("#fbrelatebtn").attr("_status")==1){$("#fbrelatebtn").click();}
		$("#fbrelatebtn").hide();
	}
	//获取反馈记录
	function getFeedbackRecord(lastid){
		$("#gettr").children("td").html("<img src='/express/task/images/loading3_wev8.gif' align='absMiddle' />");
		$.ajax({
			type: "post",
		    url: "/express/task/data/Operation.jsp",
		    data:{"operation":"get_feedback","taskId":<%=taskId%>,"lastId":lastid,"viewdate":"<%=viewdate%>"}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	data=$.trim(data.responseText);
		    	$("#gettr").before(data).remove();
			}
	    });
	}
	//获取剩余日志记录
	function getLogRecord(lastid){
		$("#getlog").html("<img src='/express/task/images/loading3_wev8.gif' align='absMiddle' />");
		$.ajax({
			type: "post",
		    url: "/express/task/data/Operation.jsp",
		    data:{"operation":"get_log","taskId":<%=taskId%>,"lastId":lastid}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	data=$.trim(data.responseText);
		    	$("#getlog").before(data).remove();
			}
	    });
	}
	function doOperate1(){
			$.ajax({
				type: "post",
			    url: "/express/TaskOperation.jsp",
			    data:{"operation":"del_label","labelid":<%=taskId%>}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    success: function(data){
			    	$('#select_tr', parent.document).remove();
			    }
	    });	
	    setIndex();
	}
	//状态设置
	function doOperate(status){
		if(status == 10){
			$.ajax({
				type: "post",
			    url: "/express/TaskOperation.jsp",
			    data:{"operation":"del_label","taskId":<%=taskId%>}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){}
	    });		
		}
		if(status==4){
			if(!confirm("确定删除此任务?")){
				return;
			}
		}
		$.ajax({
			type: "post",
		    url: "/express/task/data/Operation.jsp",
		    data:{"operation":"edit_status","taskId":<%=taskId%>,"status":status}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
			    $("#logdiv").prepend($.trim(data.responseText));
			}
	    });

		if(status==1){
			$("div.btn_operate").show();
			$("div.btn_complete").hide();
			$("div.btn_revoke").hide();
			$("#tdstatus").html("进行中");
	    }else if(status==2){
	    	$("div.btn_operate").hide();
	    	$("div.btn_complete").show();
	    	$("#tdstatus").html("完成");
		}else if(status==3){
	    	$("div.btn_operate").hide();
	    	$("div.btn_revoke").show();
	    	$("#tdstatus").html("撤销");
		}else{
			if($(foucsobj).attr("id")=="<%=taskId%>") foucsobj=null;
			$("#<%=taskId%>").parent().parent().remove();
			var upload = document.getElementById("uploadDiv");
			if(upload!=null) upload.innerHTML = "";
			$("#detaildiv").append(loadstr).load("DefaultView.jsp");
		}
    	$("div.btn_delete").show();

    	reSetStatus("<%=taskId%>",status,0);
	}
	
	function showop(obj,classname,txt){
		$(obj).removeClass(classname).html(txt);
	}
	function hideop(obj,classname,txt){
		$(obj).addClass(classname).html(txt);
	}
	
	function onShowHrm(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'add');
	    }
	}
	function onShowHrms(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'add');
	    }
	}
	function onShowDoc(fieldname) {
	    var datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowWF(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowCRM(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowProj(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function changeListName(obj){
		var name = $(obj).attr("value");
		foucsobj=$("#select_tr",parent.parent.document);
		var focustr=$(foucsobj).parents("tr:first");
		$(focustr).children().eq(4).children().attr("value",name);
		$(focustr).children().eq(4).children().attr("title",name);
	}
	
	function transName(fieldname,id,name){
		var delname = fieldname;
		if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
		var restr = "";
		if(fieldname=="principalid"){
			restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}else{
			restr += "<div class='txtlink txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}
		restr += "<div style='float: left;'>";
			
		if(fieldname=="principalid" || fieldname=="partnerid" || fieldname=="sharerid"){
			restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
		}else if(fieldname=="docids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
		}else if(fieldname=="wfids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+id+"') >"+name+"</a>";
		}else if(fieldname=="crmids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
		}else if(fieldname=="projectids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid="+id+"') >"+name+"</a>";
		}else if(fieldname=="taskids"){
			restr += "<a href=javaScript:refreshDetail("+id+") >"+name+"</a>";
		}else if(fieldname=="tag"){
			restr += name;
		}
		
		restr +="</div>"
			+ "<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>"
			+ "<div class='btn_wh'></div>"
			+ "</div>";
		return restr;
	}
	
	function __flash__removeCallback(instance, name) {
		try {
			if (instance) {
				instance[name] = null;
			}
		} catch (flashEx) {
		
		}
	};
</script>
<%!
	public String getFileDoc(String ids,String taskId) throws Exception{
		String returnstr = "";
		String docid = "";
		String docImagefileid = "";
		int docImagefileSize = 0;
		String docImagefilename = "";
		DocImageManager DocImageManager = null;
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				docid = Util.null2String((String)idList.get(i));
				if(!docid.equals("")){
					DocImageManager = new DocImageManager();
					DocImageManager.resetParameter();
		            DocImageManager.setDocid(Integer.parseInt((String)idList.get(i)));
		            DocImageManager.selectDocImageInfo();
		            DocImageManager.next();
		            docImagefileid = DocImageManager.getImagefileid();
		            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
		            docImagefilename = DocImageManager.getImagefilename();
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/express/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/express/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
%>
</body>
</html>