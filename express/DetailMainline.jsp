
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/express/task/util/uploader.jsp"%>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<script language="javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
		<script language="javascript"
			src="/express/js/jquery.fuzzyquery.min_wev8.js"></script>
		<script src="/express/js/jquery.textarea.autoheight_wev8.js"></script>
		<script src="/express/js/jquery.ui.datepicker_wev8.js"></script>
		<script src="/express/js/jquery.ui.core_wev8.js"></script>
		<script src="/express/js/jquery.ui.widget_wev8.js"></script>
		<link rel="stylesheet" href="/express/css/base_wev8.css" />
		<script src="/express/js/util_wev8.js"></script>

		<style>
.scroll1 {
	overflow-y: auto;
	overflow-x: hidden;
	SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
	SCROLLBAR-ARROW-COLOR: #EAEAEA;
	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
	SCROLLBAR-SHADOW-COLOR: #E0E0E0;
	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
	SCROLLBAR-FACE-COLOR: #ffffff;
}

.scroll2 {
	overflow-y: auto;
	overflow-x: hidden;
	SCROLLBAR-DARKSHADOW-COLOR: #CDCDCD;
	SCROLLBAR-ARROW-COLOR: #E2E2E2;
	SCROLLBAR-3DLIGHT-COLOR: #CDCDCD;
	SCROLLBAR-SHADOW-COLOR: #CDCDCD;
	SCROLLBAR-HIGHLIGHT-COLOR: #CDCDCD;
	SCROLLBAR-FACE-COLOR: #CDCDCD;
	scrollbar-track-color: #E2E2E2;
}

.div_line {
	height: 50%;
	border-bottom: 2px #EEEFEF solid;
	float: left;
}

:-webkit-scrollbar-track-piece {
	background-color: #E2E2E2;
	-webkit-border-radius: 0;
}

:
:-webkit-scrollbar {
	width: 12px;
	height: 8px;
}

:
:-webkit-scrollbar-thumb {
	height: 50px;
	background-color: #CDCDCD;
	-webkit-border-radius: 1px;
	outline: 0px solid #fff;
	outline-offset: -2px;
	border: 0px solid #fff;
}

:
:-webkit-scrollbar-thumb :hover {
	height: 50px;
	background-color: #BEBEBE;
	-webkit-border-radius: 1px;
}
</style>
	</head>
	<body>
		<%
			String taskId = Util.null2String(request.getParameter("taskId"));
	   		String operator=Util.null2String(request.getParameter("operator"));//查询关键字
			String mainlineid = Util.null2String(request.getParameter("mainlineid"));
	   		 
			String main_name = "";
			String main_date = "";
			String main_modif = "";
			String main_principalid = "";
			String main_partnerids = "";
			String main_remark = "";
			String m_name = "";
			String main_date1 = "";
			String m_creater="";
			rs.executeSql("select * from Task_mainline where id = "+ mainlineid);
			while (rs.next()) {
				main_name = rs.getInt("createor") + "";
				main_date1 = rs.getString("createdate");
				main_date = main_date1.substring(0, 10);
				main_modif = rs.getString("modifydate");
				main_principalid = rs.getInt("principalid") + "";
				main_partnerids = rs.getString("partnerids");
				main_remark = rs.getString("remark");
				m_name = rs.getString("name");
				m_creater = rs.getInt("createor")+"";
			}
			if (mainlineid.equals("0")) {
				m_name = "新建主线";
				main_name = user.getUID() + "";
			}
			taskId = "6";
			int right = cmutil.getRight(taskId, user);
			boolean canedit = false;
			if (main_principalid.equals(user.getUID()+"")||main_name.equals(user.getUID()+"")){
				canedit = true;
			}
		%>
		<style type="text/css">
html,body {
	-webkit-text-size-adjust: none;
	margin: 0px;
	overflow: hidden;
}

* {
	font-size: 12px;
	font-family: Arial, '微软雅黑';
	outline: none;
}

.datatable {
	width: 100%;
}

.datatable td {
	padding-left: 5px;
	padding-top: 1px;
	padding-bottom: 1px;
	text-align: left;
}

.datatable td.title {
	font-family: 微软雅黑;
	color: #999999;
	vertical-align: top;
	padding-top: 7px;
	padding-bottom: 7px;
	padding-left: 20px;
	background: #F6F6F6;
	border-top: 1px #F6F6F6 solid;
	border-bottom: 1px #F6F6F6 solid;
}

.datatable td.data {
	vertical-align: middle;
	border-top: 1px #fff solid;
	border-bottom: 1px #fff solid;
}

.feedrelate {
	display: none;
}

.feedrelate td {
	background: #fff !important;
	border-top: 1px #fff solid !important;
	border-bottom: 1px #fff solid !important;
}

.div_show {
	word-wrap: break-word;
	word-break: break-all;
	width: 90%;
	line-height: 20px;
	min-height: 20px;
}

.div_show p {
	padding: 0px;
	margin: 0px;
	line-height: 20px !important;
}

.input_def {
	word-wrap: break-word;
	word-break: break-all;
	width: 90%;
	height: 23px;
	line-height: 23px;
	border: 1px #fff solid;
	padding-left: 4px;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	behavior: url(/express/css/PIE2.htc);
}

.input_over {
	border: 1px #F0F0F0 solid;
	background: #fff;
}

.input_focus {
	border: 1px #1A8CFF solid;
	background: #fff;
	box-shadow: 0px 0px 2px #1A8CFF;
	-moz-box-shadow: 0px 0px 2px #1A8CFF;
	-webkit-box-shadow: 0px 0px 2px #1A8CFF;
}

.content_def {
	width: 90%;
	min-height: 20px;
	line-height: 20px;
	border: 1px #fff solid;
	padding: 3px;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	text-align: left;
	behavior: url(/express/css/PIE2.htc);
}

.content_def p {
	padding: 0px;
	margin: 0px;
}

.content_over {
	border: 1px #F0F0F0 solid;
	background: #fff;
}

.content_focus {
	border: 1px #1A8CFF solid;
	background: #fff;
	box-shadow: 0px 0px 3px #1A8CFF;
	-moz-box-shadow: 0px 0px 3px #1A8CFF;
	-webkit-box-shadow: 0px 0px 3px #1A8CFF;
}

.feedback_def {
	width: 90%;
	min-height: 30px;
	margin-bottom: 30px;
	line-height: 20px !important;
	border: 1px #D7D7D7 solid;
	padding: 0px;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	text-align: left;
	behavior: url(/express/css/PIE2.htc);
}

.feedback_def p {
	padding: 0px;
	margin: 0px;
	line-height: 20px !important;
}

.feedback_over {
	border: 1px #C8C8C8 solid;
}

.feedback_focus {
	min-height: 50px;
	margin-bottom: 5px;
	border: 1px #1A8CFF solid;
	box-shadow: 0px 0px 3px #1A8CFF;
	-moz-box-shadow: 0px 0px 3px #1A8CFF;
	-webkit-box-shadow: 0px 0px 3px #1A8CFF;
}

a.slink {
	padding-right: 5px;
	border-right: 0px #DBDBDB dashed;
}

a.slink,a.slink:active,a.slink:visited {
	color: #DBDBDB !important;
	text-decoration: none;
}

a.slink:hover {
	color: #1A8CFF !important;
	text-decoration: underline;
}

a.sdlink {
	color: #000 !important;
	text-decoration: none !important;
	cursor: default;
	font-weight: bold;
}

a.sdlink:hover,a.sdlink:active,a.sdlink:visited {
	color: #000 !important;
	text-decoration: none !important;
}

#rightinfo a,#rightinfo a:active,#rightinfo a:visited {
	text-decoration: none;
	color: #000000;
}

#rightinfo a:hover {
	text-decoration: underline;
	color: #0080FF;
}

tr.tr_over td {
	background: #F4F4F4 !important;
	border-top: 1px #E6E9EC solid !important;
	border-bottom: 1px #E6E9EC solid !important;
}

.upload {
	display: ;
	float: left;
}

tr.tr_over .upload {
	display: ;
}

.btn_add {
	width: 40px;
	height: 22px;
	float: left;
	margin-left: 10px;
	margin-top: 1px;
	margin-bottom: 1px;
	background: url('/express/task/images/edit_wev8.png') center no-repeat;
	display: none;
	cursor: pointer;
}

.btn_browser {
	width: 40px;
	height: 22px;
	float: left;
	margin-left: 5px;
	margin-top: 1px;
	margin-bottom: 1px;
	display: none;
	cursor: pointer;
	background: url('/express/task/images/browser_wev8.png') center no-repeat !important;
}

.browser_hrm {
	background: url('/express/task/images/browser_wev8.png') center no-repeat;
}

.browser_doc {
	background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;
}

.browser_wf {
	background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;
}

.browser_meeting {
	background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;
}

.browser_crm {
	background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;
}

.browser_proj {
	background: url('/express/task/images/edit_bg_wev8.png') no-repeat 0px -22px;
}

.add_input {
	width: 100px;
	height: 20px;
	line-height: 20px;
	border: 1px #fff solid;
	padding-left: 2px;
	display: none; margin-left：5px;
	border: 1px #1A8CFF solid;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	box-shadow: 0px 0px 2px #1A8CFF;
	-moz-box-shadow: 0px 0px 2px #1A8CFF;
	-webkit-box-shadow: 0px 0px 2px #1A8CFF;
	float: left;
	behavior: url(/express/css/PIE2.htc);
}

.txtlink {
	line-height: 24px;
	float: left;
	margin-left: 3px;
}

.btn_del {
	width: 16px;
	height: 16px;
	background: url('/express/task/images/mainline_wev8.png') no-repeat -80px -126px;
	display: none;
	cursor: pointer;
	float: left;
	margin-left: 0px;
}

.btn_wh {
	width: 16px;
	height: 16px;
	float: left;
	margin-left: 0px;
}

.dtitle {
	width: 100%;
	height: 31px;
	line-height: 26px;
	font-weight: bold;
	border-bottom: 0px #E8E8E8 solid;
	cursor: pointer;
	background: url('/express/images/title_bg_01_wev8.png') repeat-x;
}

.dtxt {
	height: 26px;
	float: left;
	margin-left: 10px;
	font-family: 微软雅黑;
}

.btn_feedback {
	width: 50px;
	text-align: center;
	line-height: 18px;
	cursor: pointer;
	float: left;
	font-family: 微软雅黑;
	background-color: #67B5E9;
	color: #fff;
	margin-left: 20px;
	margin-bottom: 5px;
	display: none;
	margin-top: 5px;
	border: 1px #50A9E4 solid;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0px 0px 2px #8EC8EE;
	-moz-box-shadow: 0px 0px 2px #8EC8EE;
	-webkit-box-shadow: 0px 0px 2px #8EC8EE;
	behavior: url(/express/css/PIE2.htc);
}

.btn_feedback_hover {
	background-color: #1F8DD6;
}

.fbdata {
	border-bottom: 1px #EFEFEF dashed !important;
}

.feedbackshow {
	width: 90%;
	margin-left: 20px;
	margin-top: 3px;
	margin-bottom: 3px;
	overflow: hidden;
}

.feedbackinfo {
	width: auto;
	line-height: 24px;
	color: #808080;
}

.feedbackinfo a,.feedbackinfo a:active,.feedbackinfo a:visited {
	text-decoration: none !important;
	color: #808080 !important;
}

.feedbackinfo a:hover {
	text-decoration: underline !important;
	color: #0080FF !important;
}

.feedbackrelate {
	width: auto;
	line-height: 24px;
	background: #F9F9F9;
	overflow: hidden;
	padding: 5px;
	border: 1px #E7E7E7 solid;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0px 0px 2px #E7E7E7;
	-moz-box-shadow: 0px 0px 2px #E7E7E7;
	-webkit-box-shadow: 0px 0px 2px #E7E7E7;
	behavior: url(/express/css/PIE2.htc);
}

.feedbackrelate .relatetitle {
	color: #808080
}

.feedbackrelate a,.feedbackrelate a:active,.feedbackrelate a:visited {
	text-decoration: none !important;
	color: #1D76A4 !important;
}

.feedbackrelate a:hover {
	text-decoration: underline !important;
	color: #FF0000 !important;
}

.feedbackshow p {
	padding: 0px;
	margin: 0px;
	line-height: 20px !important;
}

.btn_operate {
	width: 60px;
	text-align: center;
	line-height: 18px;
	cursor: pointer;
	float: left;
	font-family: 微软雅黑;
	color: #808080;
	margin-left: 5px;
	margin-bottom: 0px;
	border: 1px #D2D2D2 solid;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 1px 1px 3px #FDFDFD;
	-moz-box-shadow: 1px 1px 3px #FDFDFD;
	-webkit-box-shadow: 1px 1px 3px #FDFDFD;
	background: -webkit-gradient(linear, 0 0, 0 bottom, from(#FDFDFD),
		to(#EEEEEE) );
	background: -moz-linear-gradient(#FDFDFD, #EEEEEE);
	-pie-background: linear-gradient(#FDFDFD, #EEEEEE);
	behavior: url(/express/css/PIE2.htc);
}

.btn_complete {
	background-color: #34AD00;
	color: #fff;
	border: 1px #34AD00 solid;
	box-shadow: 0px 0px 2px #34AD00;
	-moz-box-shadow: 0px 0px 2px #34AD00;
	-webkit-box-shadow: 0px 0px 2px #34AD00;
	background: -webkit-gradient(linear, 0 0, 0 bottom, from(#34AD00),
		to(#34AD00) );
	background: -moz-linear-gradient(#34AD00, #34AD00);
	-pie-background: linear-gradient(#34AD00, #34AD00);
}

.btn_revoke {
	background-color: #FF6060;
	color: #fff;
	border: 1px #FF6060 solid;
	box-shadow: 0px 0px 2px #FF6060;
	-moz-box-shadow: 0px 0px 2px #FF6060;
	-webkit-box-shadow: 0px 0px 2px #FF6060;
	background: -webkit-gradient(linear, 0 0, 0 bottom, from(#FF6060),
		to(#FF6060) );
	background: -moz-linear-gradient(#FF6060, #FF6060);
	-pie-background: linear-gradient(#FF6060, #FF6060);
}

.btn_hover {
	background: #EEEEEE;
	background: -webkit-gradient(linear, 0 0, 0 bottom, from(#F9F9F9),
		to(#D7D7D7) ) !important;
	background: -moz-linear-gradient(#F9F9F9, #D7D7D7) !important;
	-pie-background: linear-gradient(#F9F9F9, #D7D7D7) !important;
}

.createinfo {
	line-height: 18px;
	font-style: italic;
	font-size: 12px;
	color: #B2B2B2;
	position: absolute;
	right: 10px;
	top: 2px;
}

.createinfo a,.createinfo a:active,.createinfo a:visited {
	text-decoration: none;
	color: #B2B2B2 !important;
}

.createinfo a:hover {
	text-decoration: underline;
	color: #0080FF;
}

</STYLE>
		<div id="rightinfo"
			style="width: 100%; height: 100%; position: relative; overflow: hidden;">
			<input type="hidden" id="taskid" name="taskid" value="<%=taskId%>" />
			<input type="hidden" id="mainlineid" name="mainlineid" value="<%=mainlineid%>" />
			
			<div style="display: block; margin-top: 20px;" class="createinfo"
				title="创建人:<%=ResourceComInfo.getLastname(m_creater)%> 创建时间:<%=main_date1%>"><%=cmutil.getHrm(m_creater)%>
				<%=main_date1%>
				</div>
			<div id="maininfo"
				style="width: 100%; height: auto; position: absolute; top: 40px; left: 0px; bottom: 0px; border-top: 0px #E8E8E8 solid;"
				class="scroll1" align="center">
				<div class="dtitle" title="点击收缩">
					<div class="dtxt">
						主线信息
					</div>
				</div>
				<table class="datatable" cellpadding="0" cellspacing="0" border="0" align="center">
					<col width="20%"/>
					<col width="80%"/>
					<TBODY>
						<tr>
							<td class="title">
								主线名称
							</TD>
							<td class="data">
								<%
									if (canedit) {
								%>
								<textarea class="input_def" id="name"
									style="font-weight: bold; font-size: 16px; overflow: hidden; resize: none;"><%=m_name%></textarea>
								<%
									} else {
								%>
								<div class="div_show"
									style="line-height: 23px; font-weight: bold; font-size: 16px; height: auto; overflow: hidden;"><%=m_name%></div>
								<%
									}
								%>
							</td>
						</tr>
						<tr>
							<td class="title">
								创建人
							</TD>
							<td class="data">
								<label style="width: 100px;" id="begindate" name="begindate"
									size="30"><%=cmutil.getHrm(main_name)%></label>
							</td>
						</tr>
						<tr>
							<td class="title">
								创建日期
							</TD>
							<td class="data">
								<label style="width: 100px;" id="begindate" name="begindate"
									size="30"><%=main_date%></label>
							</td>
						</tr>
						<tr>
							<td class="title">
								修改日期
							</TD>
							<td class="data">
								<label type="text" style="width: 100px;" id="enddate"
									name="enddate" size="30"><%=main_modif%></label>
							</td>
						</tr>

						<tr>
							<td class="title">
								责任人
							</TD>
							<td class="data">
								<input type="hidden" id="principalid_val"
									value="<%=main_principalid%>" />
								<div class="txtlink showcon txtlink<%=main_principalid%>"
									onmouseover="showdel(this)" onmouseout="hidedel(this)">
									<%
										if (!main_principalid.equals("0") && !main_principalid.equals("")) {
									%>
									<div style="float: left;"><%=cmutil.getHrm(main_principalid)%></div>
									<%
										if (canedit) {
									%>
									<div class="btn_del"
										onclick="delItem('principalid',<%=main_principalid%>)"></div>
									<div class="btn_wh"></div>
									<%
										}
									%>
									<%
										}
									%>
								</div>
								<%
									if (canedit) {
								%>
								<input id="principalid" name="principalid" class="add_input"
									_init="1" _searchwidth="80" _searchtype="hrm" />
								<div class="btn_add"></div>
								<div class="btn_browser browser_hrm"
									onClick="onShowHrm('main_principalid')"></div>
								<%
									}
								%>
							</td>
						</tr>
							<tr>
							<td class="title">参与人</TD>
							<td class="data">
								<%
									String partnerid_val = ",";
									String partnerid = "";
									rs.executeSql("select userid from Task_mainlineShare where mainlineid="+mainlineid +" and usertype =2");
									while(rs.next()){
										partnerid = Util.null2String(rs.getString(1));
										if(!partnerid.equals("0") && !partnerid.equals("")){
											partnerid_val += partnerid + ",";
										
								%>
								<div class="txtlink txtlink<%=partnerid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
									<div style="float: left;"><%=cmutil.getHrm(partnerid) %></div>
									<%if(canedit){ %>
									<div class="btn_del" onclick="delItem('partnerid','<%=partnerid %>')"></div>
									<div class="btn_wh"></div>
									<%} %>
								</div>
								<% 		} 
									}
								%>
								<%if(canedit){ %>
						  		<input id="partnerid" name="partnerid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
						  		<div class="btn_add"></div>
						  		<div class="btn_browser browser_hrm" onClick="onShowHrms('partnerid')"></div>
						  		<input type="hidden" id="partnerid_val" value="<%=partnerid_val %>"/>
						  		<%} %>
						  	</td>
						</tr>
						<tr>
							<td class="title">分享人</TD>
							<td class="data">
						<%
							String sharerid_val = ",";
							String sharerid = "";
							rs.executeSql("select userid from Task_mainlineShare where mainlineid="+mainlineid +" and usertype =3");
							while(rs.next()){
								sharerid = Util.null2String(rs.getString(1));
								if(!sharerid.equals("0") && !sharerid.equals("")){
									sharerid_val += sharerid + ",";
								
						%>
						<div class="txtlink txtlink<%=sharerid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getHrm(sharerid) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('sharerid','<%=sharerid %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="sharerid" name="sharerid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_hrm" onClick="onShowHrms('sharerid')"></div>
				  		<input type="hidden" id="sharerid_val" value="<%=sharerid_val %>"/>
				  		<%} %>
				  	</td>
				</tr>
						<tr>
							<td class="title">
								描述
							</TD>
							<td class="data">
								<%
									if (canedit) {
								%>
								<div class="content_def" contenteditable="true" id="remark"><%=main_remark%></div>
								<%
									} else {
								%>
								<div class="div_show"><%=main_remark%></div>
								<%
									}
								%>
							</td>
						</tr>
					</TBODY>
				</table>
			</div>
		</div>
		
<script language="javascript">
	var tempval = "";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var taskid = <%=taskId%>;
	$(document).ready(function(){

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
					intervalTop:4,
					result:function(data,updatename,updatetype){
					  selectUpdate(updatename,data["id"],data["name"],updatetype);
					}
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
	});
	
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
		var mainlineid = $("#mainlineid").attr("value");
		if(typeof(delvalue)=="undefined") delvalue = "";
		if(typeof(addvalue)=="undefined") addvalue = "";
		$.post("/express/task/data/Operation.jsp?operation=edit_main&mainlineid=" + mainlineid +"&fieldname="+fieldname+"&fieldvalue="+fieldvalue+"&fieldtype="+fieldtype,function(data){
			if(fieldname == "name"){
				$('#main_name', parent.document).html(fieldvalue);
			}
		});
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
	
	function changeDetailName(obj,taskid){
		var id = $("#taskid").attr("value");
		if(id == taskid){
			$("#name").html(obj);
			exeUpdate("name",obj,"str");
		}
	}
	
</script>
	</body>
</html>