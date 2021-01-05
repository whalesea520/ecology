<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	//读取title
	UsrTemplate.getTemplateByUID(user.getUID(), user.getUserSubCompany1());
	String templateTitle = UsrTemplate.getTemplateTitle();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=templateTitle%> - <%=user.getUsername()%></title>
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all.css" />
		<script language="javascript" src="/sellportal/js/jquery-1.8.3.min.js"></script>
		<script language="javascript" src="/sellportal/js/jquery.fuzzyquery.min.js"></script>
		<script language="javascript" src="/sellportal/js/util.js"></script>
		<script language="javascript" src="/sellportal/js/highcharts.src.js"></script>
		<script language="javascript" src="/sellportal/js/jquery.dragsort.js"></script>
		<style type="text/css">
			html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;padding:0px;}
			*{font-size: 12px;font-family: Arial,'宋体';outline:none;}
			.topmenu{width: 62px;height: 28px;line-height: 25px;margin-top: 5px;float: left;border: 1px;border-bottom: 0px;
				text-align: center;margin-left: 5px;margin-right: 5px;color: #666666;cursor: pointer;}
			.topmenu_click{background: #fff;border: 1px #D6D6D6 solid;border-bottom: 0px;font-weight: bold;}
			.add_btn{width: 14px;height: 14px;background: url('/sellportal/images/icon.png') 0px -25px;float: left;margin-top: 10px;margin-right: 5px;cursor: pointer;}
			.add_btn_hover{background: url('/sellportal/images/icon.png') -25px -25px;}
			.add_line{width:1px;height: 14px;background:#E0E0E0;float: left;margin-top: 10px;margin-left: 0px;}
			.btn_refresh{width: 14px;height: 14px;background: url('/sellportal/images/icon.png') 0px -50px;float: right;top: 12px;right: 5px;cursor: pointer;position: absolute;}
			.btn_refresh_hover{background: url('/sellportal/images/icon.png') -25px -50px;}
			
			.search{width: 326px;height: 26px;background: url('/sellportal/images/search_bg2.png') no-repeat;margin-top: 4px;float: right;margin-right: 24px;}
			.search_blur{background: url('/sellportal/images/search_bg1.png') no-repeat;}
			.s_input{border: 0px;height: 20px;line-height: 20px;width: 290px;margin-top: 2px;margin-left: 2px;background: none;float: left;}
			.s_input_blur{color: #B8B7B7;}
			.s_btn{width: 25px;height: 23px;margin-top: 2px;margin-right: 2px;float: right;background: url('/sellportal/images/search_btn.png') center no-repeat #F7F7F7;cursor: pointer;display: none;}
			
			.datalist{width:100%;table-layout: fixed;}
			.datalist td,.datalist a{empty-cells:show;line-height: 24px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #343434;
				padding-left: 0px;background-color: #fff;}
			.datalist a,.datalist a:ACTIVE,.datalist a:VISITED{text-decoration: none;}
			.datalist a:HOVER{text-decoration: underline;}
			
			.info{color:#B6B6B6 !important;}
			.info a,.info a:ACTIVE,.info a:VISITED{text-decoration: none;color:#B6B6B6;}
			.info a:HOVER{text-decoration: underline;}
			.info_hover{color:#343434 !important;}
			.info_hover a,.info_hover a:ACTIVE,.info_hover a:VISITED{text-decoration: none;color:#343434;}
			.info_hover a:HOVER{text-decoration: underline;color: #0657C3 !important;}
			.point{background: url('/sellportal/images/point.png') center no-repeat;}
			
			a.btn_feedback,a.btn_feedback:ACTIVE,a.btn_feedback:VISITED{text-decoration: none;color: #B2B2B2;}
			a.fd_hover,a.a.fd_hover:ACTIVE,a.a.fd_hover:VISITED{color: #343434 !important;}
			a.btn_feedback:HOVER{text-decoration: underline;color: #0657C3 !important;}
				
			.prev_btn1{width: 20px;height: 205px;position: absolute;top: 15px;left: 0px;background: url('/sellportal/images/icon.png') no-repeat 0px -250px;display: none;cursor: pointer;}
			.next_btn1{width: 20px;height: 205px;position: absolute;top: 15px;right: 0px;background: url('/sellportal/images/icon.png') no-repeat -25px -250px;display: none;cursor: pointer;}
			.show{display: block;}
			.crm_data,.chance_data{width:100%;height:100%;position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;}
			
			.btn_del{width: 18px;height: 18px;background: url('/sellportal/images/icon.png') no-repeat -0px -125px;cursor: pointer;display: none;}
			.btn_del_hover{background: url('/sellportal/images/icon.png') no-repeat -25px -125px;}
			.load{position:absolute;top:0px;left:0px;right:0px;bottom:0px;background:url(/sellportal/images/loading2.gif) center no-repeat #fff;display: none;}
			
			.btn_submit{width: 66px;height: 31px;line-height: 30px;background: url(/sellportal/images/btn_submit.png) left top no-repeat;text-align: center;color: #fff;cursor: pointer;}
			.btn_submit_hover{background: url(/sellportal/images/btn_submit.png) no-repeat -69px 0px;}
			
			.title1{line-height: 33px;font-family: 微软雅黑;font-size: 14px;float: left;margin-right: 7px;}
			.title2{width: 79px;height: 100%;line-height: 31px;font-size: 14px;text-align: center;float: left;cursor: pointer;}
			.title2_click{font-weight: bold;}
			.title2_arrow{width: 9px;height: 5px;background:url(/sellportal/images/icon.png) no-repeat -25px 0px #F6F6F6;position: absolute;top:27px;left: 35px;}
			.title2_line{width:1px;height: 12px;background:#E0E0E0;float: left;margin-top: 12px;}
			.title2_refresh{width: 18px;height: 18px;background:url(/sellportal/images/icon.png) no-repeat 0px -75px;position: absolute;top:22px;left: auto;right:5px;cursor: pointer;}
			.title2_refresh_hover{background:url(/sellportal/images/icon.png) no-repeat -25px -75px;}
			.title2_more{width: 26px;height: 18px;line-height: 18px;position: absolute;top:22px;left: auto;right:5px;color: #7D7D7D;background: #F6F6F6;text-align: center;cursor: pointer;}
			.title2_more_hover{color:#0360AF;}
			.title2_setting{width: 18px;height: 18px;background:url(/sellportal/images/icon.png) no-repeat 0px -100px;position: absolute;top:22px;left: auto;right:5px;cursor: pointer;}
			.title2_setting_hover{background:url(/sellportal/images/icon.png) no-repeat -25px -100px;}
			
			.Econtent table{width: 100%;table-layout: fixed;}
			.Econtent table td,.Econtent table a,.Econtent table a font{empty-cells:show;line-height: 18px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #343434;border: 0px;}
			.Econtent table a,.Econtent table a:ACTIVE,.Econtent table a:VISITED{text-decoration: none;color:#333333;}
			.Econtent table a:HOVER{text-decoration: none;}
			#news .Econtent table{table-layout: auto;}
			
			.result1{height: 70px;background: #E5EEFF;color:#0D5BA6;}
			.result2{height: 70px;background: #DEECD3;color:#326806;}
			.result_data1{font-size: 36px;line-height:30px;font-family: Arial;text-align: center;vertical-align: bottom;cursor: pointer;}
			.result_data2{font-size: 16px;font-family: Arial;text-align: center;vertical-align: bottom;cursor: pointer;}
			.result_line{width:1px;height: 12px;background:#E0E0E0;margin-bottom: 3px;}
			.result_title{width: 100%;line-height: 30px;text-align: center;font-weight: bold;}
			#result_float{width: 174px;height: 76px;background: url('/sellportal/images/float_bg.png') no-repeat;position: absolute;top: 0px;left: 0px;display: none;z-index: 5;}
			
			.btn{display: none}
			
			.tab{width: 58px;height: 100%;line-height: 25px;float: left;text-align: center;cursor: pointer;}
			.tab_icon{width: 20px;height: 2px;background: #1672C8;position: absolute;bottom: 0px;left: 19px;}
			.tabicon1{background: url('/sellportal/images/icon.png') no-repeat 5px -471px;}
			.tabicon2{background: url('/sellportal/images/icon.png') no-repeat -20px -471px;}
			.tabicon3{background: url('/sellportal/images/icon.png') no-repeat -45px -471px;}
			.tabicon4{background: url('/sellportal/images/icon.png') no-repeat -70px -471px;}
			
			.datatable{width:100%;table-layout: fixed;}
			.datatable td,.datatable a{empty-cells:show;line-height: 22px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #666666;
				padding-left: 3px;}
			.datatable a,.datatable a:ACTIVE,.datatable a:VISITED{text-decoration: none;}
			.datatable a:HOVER{text-decoration: underline;}
			.datatable2{width:95%;table-layout: fixed;margin: 0px auto;}
			.datatable2 td,.datatable2 a{empty-cells:show;line-height: 22px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #666666;
				padding-left: 3px;}
			.datatable2 a,.datatable2 a:ACTIVE,.datatable2 a:VISITED{text-decoration: none;}
			.datatable2 a:HOVER{text-decoration: underline;}
			.info2{color:#9B9B9B !important;}
			.info2 a,.info2 a:ACTIVE,.info2 a:VISITED{text-decoration: none;color:#9B9B9B;}
			.info2 a:HOVER{text-decoration: underline;color:#666666 !important;}
			
			.resource a,.resource a:ACTIVE,.resource a:VISITED{text-decoration: none;color:#333333;}
			.resource a:HOVER{text-decoration: underline;}
			
			.drag_table{width: auto;table-layout: fixed;}
			.drag_ul{width:auto;list-style-type:none;margin:0px;padding: 0px;overflow: hidden;table-layout: fixed;position: relative;}
			.drag_li{width: 49%;float: left;height:22px;margin:0px;padding: 0px;border: 1px #F6F6F6 solid;position: relative;}
			.drag_li_blank{width: 185px;float: left;height:22px;margin:0px;padding: 0px;border: 1px #C0C0C0 dashed;}
			.drag_btn{float: left;width: 16px;height: 100%;background: url('/sellportal/images/point2.png') center no-repeat;margin-left: 10px;cursor: move !important;}
			.drag_btn_hover{cursor: move !important;}
			.drag_li,.drag_data,.drag_data a,.drag_table td{empty-cells:show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;}
			.drag_data{float: left;line-height: 22px;height:22px;position: absolute;left: 26px;right: 18px;width: auto;top:0px;}
			.drag_data a,.drag_data a:ACTIVE,.drag_data a:VISITED{text-decoration: none;color: #333333;line-height: 22px;empty-cells:show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;}
			.drag_data a:HOVER{text-decoration: underline;}
			.drag_del{position:absolute;right:0px;top:0px;float: left;width: 18px;height: 18px;margin-top:2px;background: url('/sellportal/images/icon.png') no-repeat -0px -125px;cursor: pointer;display: none;}
			
			
			.btn_prev{width: 14px;height: 44px;background:url(/sellportal/images/icon.png) no-repeat -25px -150px;cursor: pointer;float: left;margin-right: 0px;position: absolute;left: 0px;}
			.btn_prev_hover{background:url(/sellportal/images/icon.png) no-repeat -50px -150px;}
			.btn_prev_dis{background:url(/sellportal/images/icon.png) no-repeat 0px -150px;cursor: default;}
			
			.btn_next{width: 14px;height: 44px;background:url(/sellportal/images/icon.png) no-repeat -25px -200px;cursor: pointer;float: left;margin-left: 0px;position: absolute;right: 0px;}
			.btn_next_hover{background:url(/sellportal/images/icon.png) no-repeat -50px -200px;}
			.btn_next_dis{background:url(/sellportal/images/icon.png) no-repeat 0px -200px;cursor: default;}
			
			.btn_date{width: 5%;height: 44px;background: #2257AE;cursor: pointer;margin-left: 3px;margin-right: 3px;float: left;line-height: 44px;color:#fff;text-align: center;}
			.btn_date_hover{background: #FF8040;}
			.div_date{position: absolute;left: 0px;width: 100%;height: 100%;}
			
			.datatable{width: 100%;}	
			.datatable td{padding-left: 3px;padding-top:1px;padding-bottom:1px;text-align: left;}
			.datatable td.title{font-family: 微软雅黑;color: #999999;vertical-align: top;padding-top: 7px;padding-bottom: 7px;padding-left: 20px;background: #F4F4F4;}
			.datatable td.data{vertical-align: middle;background: #F4F4F4;}
			tr.tr_over td{background: #fff !important;}
			.btn_add{width:40px;height:22px;float: left;margin-left: 10px;margin-top: 1px;margin-bottom: 1px;
				background: url('/sellportal/images/edit.png') center no-repeat;display: none;cursor: pointer;}
			.btn_browser{width:40px;height:22px;float: left;margin-left: 5px;margin-top: 1px;margin-bottom: 1px;display: none;cursor: pointer;
				background: url('/sellportal/images/browser.png') center no-repeat !important;}
			.browser_hrm{background: url('/sellportal/images/browser.png') center no-repeat;}
			.browser_doc{background: url('/sellportal/images/edit_bg.png') no-repeat 0px -22px;}
			.browser_wf{background: url('/sellportal/images/edit_bg.png') no-repeat 0px -22px;}
			.browser_meeting{background: url('/sellportal/images/edit_bg.png') no-repeat 0px -22px;}
			.browser_crm{background: url('/sellportal/images/edit_bg.png') no-repeat 0px -22px;}
			.browser_proj{background: url('/sellportal/images/edit_bg.png') no-repeat 0px -22px;}
			.add_input{width: 100px;height:20px;line-height: 20px;border: 1px #fff solid;padding-left: 2px;display: none;margin-left：5px;
				border: 1px #1A8CFF solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
				box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;float: left;}
			.btn_del2{width: 16px;height: 16px;background: url('/sellportal/images/icon.png') no-repeat -0px -125px;display: none;cursor: pointer;float: left;margin-left: 0px;}
			.btn_wh{width: 16px;height: 16px;float: left;margin-left: 0px;}
			.btn_save{width: 50px;text-align: center;line-height: 18px;cursor: pointer;float: left;font-family: 微软雅黑;
				background-color: #67B5E9;color:#fff;margin-bottom: 5px;margin-top: 20px;
				border: 1px #50A9E4 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
				box-shadow:0px 0px 2px #8EC8EE;-moz-box-shadow:0px 0px 2px #8EC8EE;-webkit-box-shadow:0px 0px 2px #8EC8EE;
				}
			.btn_save_hover{background-color: #1F8DD6;}
			
			
			.his_tab{width: 52px;height: 100%;line-height: 28px;text-align: center;float: left;font-size: 14px;font-family: 微软雅黑;cursor: pointer;}
			.his_tab_click{font-weight: bold;}
			.his_tab_line{width:1px;height: 12px;background:#E0E0E0;float: left;margin-top: 10px;}
			.his_tab2{width: 67px;height: 39px;line-height: 39px;text-align: center;font-family: 微软雅黑;position: absolute;top: 0px;left: 0px;z-index: 10;cursor: pointer;}
			.his_tab2_click{background:url("/sellportal/images/his_tab_bg.png") left no-repeat;}
			.his_list{width: 372px;height: 255px;background:url("/sellportal/images/his_list_bg.png") no-repeat;position: absolute;top: 0px;left: 64px;z-index: 1;overflow: hidden;}
			.his_scroll{position: absolute;top: 3px;bottom: 5px;left: 0px;right:3px;z-index: 1;overflow-x: hidden;overflow-y: auto;}
			.tab_detail{width: 440px;height:265px;left: 10px;top: 85px;overflow: hidden;position: absolute;}
			.tab_table{width: 95%;table-layout: fixed;margin: 0px auto;margin-top: 5px;}
			.tab_table td{border-bottom: 1px #E8E8E8 dashed;}
			.tab_table td.tab_icon2{width:10px;background: url('/sellportal/images/tab_icon.png') center no-repeat;}
			.tab_table td,.tab_table a{empty-cells:show;line-height: 24px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #343434;
				padding-left: 0px;background-color: #fff;}
			.tab_table a,.tab_table a:ACTIVE,.tab_table a:VISITED{text-decoration: none;}
			.tab_table a:HOVER{text-decoration: underline;}
			.tab_none{font-style: italic;}
			.hisdetail{width: 100%;height: 100%;position: relative;}
			
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
			.fuzzyquery_load{background: url('/sellportal/images/loading2.gif') center no-repeat;height: 40px;}
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
			
			::-webkit-scrollbar-track-piece{
				background-color:#F6F6F6;
				-webkit-border-radius:0;
			}
			::-webkit-scrollbar{
				width:12px;
				height:8px;
			}
			::-webkit-scrollbar-thumb{
				height:50px;
				background-color:#F3F3F3;
				-webkit-border-radius:1px;
				outline:0px solid #fff;
				outline-offset:-2px;
				border: 0px solid #fff;
			}
			::-webkit-scrollbar-thumb:hover{
				height:50px;
				background-color:#E4E4E4;
				-webkit-border-radius:1px;
			}
			.scroll1{overflow-y: auto;overflow-x: hidden !important;
				SCROLLBAR-DARKSHADOW-COLOR: #F6F6F6;
			  	SCROLLBAR-ARROW-COLOR: #F6F6F6;
			  	SCROLLBAR-3DLIGHT-COLOR: #F6F6F6;
			  	SCROLLBAR-SHADOW-COLOR: #F6F6F6 ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #F6F6F6;
			  	SCROLLBAR-FACE-COLOR: #F6F6F6;}
			.scroll2{overflow-y: auto;overflow-x: hidden !important;
				SCROLLBAR-DARKSHADOW-COLOR: #F6F6F6;
			  	SCROLLBAR-ARROW-COLOR: #EAEAEA;
			  	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
			  	SCROLLBAR-SHADOW-COLOR: #EAEAEA ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #F3F3F3;
			  	SCROLLBAR-FACE-COLOR: #EAEAEA;}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			
		</style>
		<![endif]-->
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body>
		<div style="width: 100%;height: auto;overflow: hidden;background: #F6F6F6;">
			<!-- 左侧内容开始 -->
			<div style="width: 100%;height:auto;overflow: hidden;">
				<!-- 我的客户开始 -->
				<div class="item" style="width: 100%;height: 275px;margin-top: 0px;margin-left: 0px;overflow: hidden;position: relative;">
					<div style="position: absolute;width: auto;left:0px;top:0px;right:0px;height: 270px;overflow: hidden;border-top: 0px #D6D6D6 solid;border-left: 0px #D6D6D6 solid;background: #fff;">
						<div style="width: 100%;height: 33px;overflow: hidden;background: url('/sellportal/images/con_titlebg.png') repeat-x;position: relative;">
							<div style="width: 14px;height: 12px;float:left;background: url('/sellportal/images/icon.png') 0px 0px;margin-top: 11px;margin-left: 10px;"></div>
							<div class="title1"></div>
							<div class="topmenu topmenu_click" _data="crm" _type="1">重点客户</div>
							<div id="addcrm" class="add_btn" onclick="onAddCRM()" title="添加重点客户"></div>
							<div class="add_line"></div>
							<div class="topmenu" _data="crm" _type="0">所有客户</div>
							<div class="search search_blur"><input id="searchcrm" class="s_input s_input_blur"/><div id="crm_s" class="s_btn" onclick="getCrm(0,1)" title="搜索"></div></div>
							<div class="btn btn_refresh" title="刷新" onclick="getCrm(10,1)"></div>
						</div>
						<div id="crmreport" style="width: 30%;height: 237px;float: left;position: relative;"></div>
						<div id="crmlist" class="divlist" style="width: 69%;height: 237px;float: left;position: relative;">
							<div id="crm_prev" class="prev_btn1" onclick="getCrm(-1)"></div>
							<div id="crm_con" style="position: absolute;top: 10px;bottom: 10px;left: 22px;right: 22px;overflow: hidden;">
								<div class="crm_data"></div>
							</div>
							<div id="crm_next" class="next_btn1" onclick="getCrm(1)"></div>
							<div id="crm_load2" class="load" style="background-color: #fff;"></div>
						</div>
						<div id="crm_load" class="load" style="top:33px;"></div>
					</div>
					<div style="width: 0px;height: 271px;overflow: hidden;float: left;background: url('/sellportal/images/con_right.png') repeat-y;position: absolute;right: 0px;top: 0px;"></div>
					<div style="width: auto;height: 0px;overflow: hidden;float: left;background: url('/sellportal/images/con_bottom.png') repeat-x;position: absolute;left: 0px;bottom: 0px;right:1px;"></div>
				</div>
				<!-- 我的客户结束 -->
				
			</div>
			<!-- 左侧内容结束 -->
			
		</div>
		
		<div id="transbg" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('/sellportal/images/transbg.png') repeat;display: none;"></div>
		
		<!-- 客户联系记录开始 -->
		<div id="crm_contact" style="width: 100%;height: 335px;overflow: hidden;position: absolute;top: 150px;left:0px;display: none;">
			<div style="background: url('/sellportal/images/fk_bg.png') no-repeat;width: 494px;height: 100%;margin: 0px auto;overflow: hidden;">
				<div style="width: 480px;height: 325px;margin-left: 7px;margin-top: 5px;position: relative;">
					<div style="width: auto;line-height: 35px;padding-left: 16px;font-weight: bold;">联系记录</div>
					<table class="datatable" style="width: 100%" cellpadding="0" cellspacing="0" border="0">
						<colgroup><col width="20%"/><col width="80%"/></colgroup>
						<tr>
							<td colspan="2" class="title" style="padding-left: 0px;padding-right: 0px;">
								<textarea id="ContactInfo" style="width: 450px;margin-left: 15px;height: 70px;overflow: auto;outline:none;resize:none;"></textarea>
							</td>
						</tr>
						<tr>
							<td class="title">相关客户</td>
							<td class="data">
								<input id="_crmids" name="_crmids" class="add_input" _init="1" _searchwidth="160" _searchtype="crm"/>
								<div class="btn_add"></div>
								<div class="btn_browser browser_crm" onClick="onShowCRM('_crmids')"></div>
								<input type="hidden" id="_crmids_val" value=","/>
							</td>
						</tr>
						<tr>
							<td class="title">相关文档</td>
							<td class="data">
								<input id="_docids" name="_docids" class="add_input" _init="1" _searchwidth="160" _searchtype="doc"/>
								<div class="btn_add"></div>
								<div class="btn_browser browser_doc" onClick="onShowDoc('_docids')"></div>
								<input type="hidden" id="_docids_val" value=","/>
							</td>
						</tr>
						<tr>
							<td class="title">相关流程</td>
							<td class="data">
								<input id="_wfids" name="_wfids" class="add_input" _init="1" _searchwidth="160" _searchtype="wf"/>
								<div class="btn_add"></div>
								<div class="btn_browser browser_wf" onClick="onShowWF('_wfids')"></div>
								<input type="hidden" id="_wfids_val" value=","/>
							</td>
						</tr>
						<tr>
							<td class="title">相关项目</td>
							<td class="data">
								<input id="_projectids" name="_projectids" class="add_input" _init="1" _searchwidth="160" _searchtype="proj"/>
								<div class="btn_add"></div>
								<div class="btn_browser browser_proj" onClick="onShowProj('_projectids')"></div>
								<input type="hidden" id="_projectids_val" value=","/>
							</td>
						</tr>
					</table>
					<div class="btn_save" style="margin-left: 350px;" onclick="savefeedback();">提交</div>
					<div class="btn_save" style="margin-left: 10px;" onclick="cancelfeedback();">取消</div>
				</div>
			</div>
			<div id="contact_load" class="load" style="background-color: transparent;"></div>
		</div>
		<!-- 客户联系记录结束 -->
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			var showdate = "";
			var resulttype = 0;
			var keyword1 = "请输入名称搜索";
			var loadstr = "<div style='position:absolute;top:0px;left:0px;right:0px;bottom:0px;background:url(/sellportal/images/loading2.gif) center no-repeat;'></div>";
			$(document).ready(function(){
				$("#searchcrm,#searchchance").val(keyword1).bind("focus",function(){
					if(this.value == keyword1){
						this.value = "";
						$(this).removeClass("s_input_blur").next("div.s_btn").show().parent().removeClass("search_blur");
					}
				}).bind("blur",function(){
					if(this.value == ""){
						this.value = keyword1;
						$(this).addClass("s_input_blur").next("div.s_btn").hide().parent().addClass("search_blur");
					}
				});

				$("div.topmenu").bind("click",function(){
					$(this).parent().children("div.topmenu").removeClass("topmenu_click");
					$(this).addClass("topmenu_click");
					var _data = $(this).attr("_data");
					var _type = $(this).attr("_type");
					if(_data=="crm"){
						if(_type==crmtype) return;
						if(_type==1){$("#addcrm").show();}else{$("#addcrm").hide();} 
						crmtype = _type;
						getCrm(0,1);
					}
					if(_data=="chance"){
						if(_type==chancetype) return;
						if(_type==1){$("#addchance").show();}else{$("#addchance").hide();} 
						chancetype = _type;
						getChance(0,1);
					}
				});

				$("div.add_btn").bind("mouseover",function(){
					$(this).addClass("add_btn_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("add_btn_hover");
				});

				$("div.divlist").bind("mouseenter",function(){
					$(this).children("div.showbtn").addClass("show");
				}).bind("mouseleave",function(){
					$(this).children("div.showbtn").removeClass("show");
				});

				$("tr.tr_data").live("mouseenter",function(){
					$(this).find(".btn_feedback").addClass("fd_hover");
					$(this).find(".info").addClass("info_hover");
					$(this).find(".btn_del").show();
				}).live("mouseleave",function(){
					$(this).find(".btn_feedback").removeClass("fd_hover");
					$(this).find(".info").removeClass("info_hover");
					$(this).find(".btn_del").hide();
				});
				$("div.btn_del").live("mouseover",function(){
					$(this).addClass("btn_del_hover");
				}).live("mouseout",function(){
					$(this).removeClass("btn_del_hover");
				});

				$("div.title2").bind("click",function(){
					var _type = $(this).attr("_type");
					var _index = $(this).attr("_index");
					if(_type=="question"){//问题支持
						if(_index==2){
							openFullWindowHaveBar('/workflow/request/AddRequest.jsp?workflowid=6&isagent=0&beagenter=0');//专家支持
						}
					}else{
						var _left = $(this).attr("_left")+"px";
						$(this).parent().children("div.title2").removeClass("title2_click");
						$(this).addClass("title2_click").parent().next("div.title2_arrow").css("left",_left);
						
						if(_type=="knowledge"){
							knowledgeType = _index;
							getKnowledge();
						}
						if(_type=="contract"){
							getData("contract","get_contract",_index);
						}
					}
				});
				$("div.title2_refresh").bind("mouseover",function(){
					$(this).addClass("title2_refresh_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("title2_refresh_hover");
				});
				$("div.title2_more").bind("mouseover",function(){
					$(this).addClass("title2_more_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("title2_more_hover");
				});
				$("div.title2_setting").bind("mouseover",function(){
					$(this).addClass("title2_setting_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("title2_setting_hover");
				});
				$("div.btn_submit").bind("mouseover",function(){
					$(this).addClass("btn_submit_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_submit_hover");
				});
				//刷新等按钮隐藏显示事件绑定
				$("div.item").live("mouseenter",function(){
					$(this).find("div.btn,a.btn").show();
					$(this).find("div.scroll1").addClass("scroll2");
				}).live("mouseleave",function(){
					$(this).find("div.btn,a.btn").hide();
					$(this).find("div.scroll1").removeClass("scroll2");
				});

				$("li.drag_li").live("mouseenter",function(){
					$(this).find("div.drag_del").show();
				}).live("mouseleave",function(){
					$(this).find("div.drag_del").hide();
				});
				
				$("div.btn_prev").bind("mouseover",function(){
					$(this).addClass("btn_prev_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_prev_hover");
				});
				$("div.btn_next").bind("mouseover",function(){
					if(!$(this).hasClass("btn_next_dis")){
						$(this).addClass("btn_next_hover");
					}
				}).bind("mouseout",function(){
					if(!$(this).hasClass("btn_next_dis")){
						$(this).removeClass("btn_next_hover");
					}
				});

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
				$("div.btn_save").bind("mouseover",function(){
					$(this).addClass("btn_save_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_save_hover");
				})
				

				
				
				$("#result_float").bind("mouseenter",function(){
					$(this).show();
				}).bind("mouseleave",function(){
					$(this).hide();
				});

				getCrm(0,1);//客户
				
			});
			$(window).resize(function(){
				setdatewidth();
			});
			
			document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){
			    	var target=$.event.fix(e).target;
			    	if($(target).attr("id")=="searchcrm"){
				    	$("#crm_s").click();
			    	}
			    	if($(target).attr("id")=="searchchance"){
				    	$("#chance_s").click();
			    	}
			    	if($(target).attr("id")=="qtitle"){
			    		doSubmit();
			    	}

			    	//ctrl+enter 直接提交反馈
					if(CustomerID!="" && (event.ctrlKey)){
						savefeedback();
					}
			    }    
			}

			//读取客户信息
			var crmpage = 1;
			var crmname = "";
			var crmtype = 1;
			var crmperpage = 9;
			var crmstatus = "";
			function getCrm(pagetype,init,status){
				if(pagetype==-1) crmpage = parseInt(crmpage) - 1; 
				if(pagetype==1) crmpage = parseInt(crmpage) + 1; 
				if(pagetype==0) crmpage = 1;
				crmname = $("#searchcrm").val();
				if(crmname==keyword1) crmname = "";

				if(pagetype!=-1 && pagetype!=1){
					if(pagetype==20){
						crmstatus = status;
						$("#crm_load2").show();
					}else{
						$("#crm_load").show();
						getCrmReport();
						if(pagetype!=10) crmstatus = "";
					}
				}else{
					$("#crm_load2").show();
				}
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"operation":"get_crm","currentpage":crmpage,"pagesize":crmperpage,"type":crmtype,"name":filter(encodeURI(crmname)),"crmstatus":crmstatus}, 
				    complete: function(data){ 
				    	$("#crm_load").hide();
				    	$("#crm_load2").hide();
					    var txt = $.trim(data.responseText);
						if(pagetype==-1 || pagetype==1){
							var obj1 = $("div.crm_data");
							var obj2 = $("<div class='crm_data'></div");
							var w = obj1.width();
							obj2.html(txt.split("$")[0]).hide();
							$("#crm_con").append(obj2);
							if(pagetype==-1){
								obj2.css("left",w*-1).show().animate({ left:0},200,null,function(){});
								obj1.animate({ left:w},200,null,function(){$(this).remove();});
							}else{
								obj2.css("left",w).show().animate({ left:0},200,null,function(){});
								obj1.animate({ left:w*-1},200,null,function(){$(this).remove();});
							}
						}else{
							$("div.crm_data").html(txt.split("$")[0]);
						}
				    	setCrmBtn(txt.split("$")[1],init);
					}
			    });

			}
			function setCrmBtn(total,init){
				if(crmpage==1){
					$("#crm_prev").removeClass("showbtn");
					if(init!=1) $("#crm_prev").removeClass("show");
				}else{
					$("#crm_prev").addClass("showbtn");
					if(init!=1) $("#crm_prev").addClass("show");
				}
				if(parseInt(total)>crmpage*crmperpage){
					$("#crm_next").addClass("showbtn");
					if(init!=1) $("#crm_next").addClass("show");
				}else{
					$("#crm_next").removeClass("showbtn");
					if(init!=1) $("#crm_next").removeClass("show");
				}
			}
			
			function setChanceBtn(total,init){
				if(chancepage==1){
					$("#chance_prev").removeClass("showbtn");
					if(init!=1) $("#chance_prev").removeClass("show");
				}else{
					$("#chance_prev").addClass("showbtn");
					if(init!=1) $("#chance_prev").addClass("show");
				}
				if(parseInt(total)>crmpage*crmperpage){
					$("#chance_next").addClass("showbtn");
					if(init!=1) $("#chance_next").addClass("show");
				}else{
					$("#chance_next").removeClass("showbtn");
					if(init!=1) $("#chance_next").removeClass("show");
				}
			}

			//替换ajax传递特殊符号
			function filter(str){
				str = str.replace(/\+/g,"%2B");
			    str = str.replace(/\&/g,"%26");
				return str;	
			}
			function getCrmReport(){
				$("#crmreport").html(loadstr);
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"operation":"get_crmreport","type":crmtype,"name":filter(encodeURI(crmname))}, 
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    $("#crmreport").html(txt);
					}
			    });
			}
			function getChanceReport(){
				$("#chancereport").html(loadstr);
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"operation":"get_sellchancereport","type":chancetype,"name":filter(encodeURI(chancename))}, 
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    $("#chancereport").html(txt);
					}
			    });
			}
			function onDelCRM(customerid){
				if(customerid!=""){
			    	$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    data:{"operation":"del_crm","customerid":customerid}, 
					    complete: function(data){ 
					    	getCrm(10,1);
						}
				    });
				}	   
			}
			function onDelChance(sellchanceid){
				if(sellchanceid!=""){
			    	$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    data:{"operation":"del_sellchance","sellchanceid":sellchanceid}, 
					    complete: function(data){ 
					    	getChance(10,1);
						}
				    });
				}	   
			}
			function onAddCRM() {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
			    if (datas) {
				    if(datas.id!=""){
				    	$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    data:{"operation":"add_crm","customerid":datas.id}, 
						    complete: function(data){ 
						    	getCrm(0,1);
							}
					    });
					}
			    }
			}
			function onAddChance() {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sellportal/util/MutiSellChanceBrowser.jsp");
			    if (datas) {
				    if(datas.id!=""){
				    	$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    data:{"operation":"add_sellchance","sellchanceid":datas.id}, 
						    complete: function(data){ 
						    	getChance(0,1);
							}
					    });
					}
			    }
			}
			
			
			function setdatewidth(){
				//var w = Math.round(($("#dateshow").width()-18*6)/18);
				var w = ($("#dateshow").width()-18*6)/18+"";
				if(w.indexOf(".")>-1) w = w.substring(0,w.indexOf("."));
				$("div.btn_date").width(parseInt(w));
			}
			function datehover(obj){$(obj).addClass("btn_date_hover");}
			function dateout(obj){$(obj).removeClass("btn_date_hover");}

			function gotoMoneySet(){
				window.open('/sellportal/base/DataEdit.jsp');
			}

			//客户联系记录
			var CustomerID = "";
			var fbtype = 0;
			function dofeedback(customerid,customername,type){
				controlWheel(0);
				CustomerID = customerid;
				fbtype = type;
				selectUpdate("_crmids",customerid,customername,'str');
				var top = window.parent._scrollTop;
				$("#transbg").show();
				$("#crm_contact").css("top",top+90).show();
				$("#ContactInfo").focus();
			}
			function cancelfeedback(){
				controlWheel(1);
				CustomerID = "";
				$("#contact_load").hide();
				$("#transbg").hide();
				$("#crm_contact").hide();
				$("#ContactInfo").val("");
				$("#_crmids_val").val(",");$("#_docids_val").val(",");$("#_wfids_val").val(",");$("#_projectids_val").val(",");
				$("div.txtlink").remove();
			}
			function savefeedback(){
				var ContactInfo = $("#ContactInfo").val();
				if(ContactInfo==""){
					alert("请填写联系信息!");
					return;
				}
				var relateddoc = $("#_docids_val").val();relateddoc = cutval(relateddoc);
				var relatedwf = $("#_wfids_val").val();relatedwf = cutval(relatedwf);
				var relatedcus = $("#_crmids_val").val();relatedcus = cutval(relatedcus);
				var relatedprj = $("#_projectids_val").val();relatedprj = cutval(relatedprj);
				
				$("#contact_load").show();
				$("#ContactInfo").blur();
				$.ajax({
					type: "post",
					url: "/CRM/data/ContactLogOperation.jsp?log=n",
					contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					data:{"method":"addquick","ContactInfo":encodeURI(ContactInfo),"CustomerID":CustomerID,"relateddoc":relateddoc,"relatedwf":relatedwf,"relatedcus":relatedcus,"relatedprj":relatedprj}, 
					complete: function(data){
						if(fbtype==1){
							getCrm(10,1);
						}
						cancelfeedback();
					}
				});
			}
			function cutval(val){
				if(val==",") val = "";
				if(val!="") val = val.substring(1,val.length-1);
				return val;
			}

			function selectUpdate(fieldname,id,name,type){
				var addtxt = "";
				var addids = "";
				var addvalue = "";
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
				addids = vals+addids;
				$("#"+fieldname).before(addtxt);
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
					+ "<div class='btn_del2' onclick=\"delItem('"+delname+"','"+id+"')\"></div>"
					+ "<div class='btn_wh'></div>"
					+ "</div>";
				return restr;
			}
			//显示删除按钮
			function showdel(obj){
				$(obj).find("div.btn_del2").show();
				$(obj).find("div.btn_wh").hide();
			}
			//隐藏删除按钮
			function hidedel(obj){
				$(obj).find("div.btn_del2").hide();
				$(obj).find("div.btn_wh").show();
			}
			//删除选择性内容
			function delItem(fieldname,fieldvalue){
				$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
				var vals = $("#"+fieldname+"_val").val();
				var _index = vals.indexOf(","+fieldvalue+",")
				if(_index>-1 && $.trim(fieldvalue)!=""){
					vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
					$("#"+fieldname+"_val").val(vals);
					if(!startWith(fieldname,"_")){
						exeUpdate(fieldname,vals,'str',fieldvalue);
					}
				}
			}
		</script>
	</body>
</html>
