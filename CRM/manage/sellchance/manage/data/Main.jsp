
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<%
	String year = TimeUtil.getCurrentDateString().substring(0,4);
	String month = TimeUtil.getCurrentDateString().substring(5,7);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>商机管理</title>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.core_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.widget_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<script src="../js/util_wev8.js"></script>
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all_wev8.css" />
		
		<link type='text/css' rel='stylesheet'  href='/tree/js/treeviewAsync/eui.tree_wev8.css'/>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview_wev8.js'></script>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
		
		<style type="text/css">
			html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
			*{font-size: 12px;font-family: Arial,'宋体';outline:none;}
			
			.calendar{width:100%;cursor:default;background: #F1F1F1;}
			.calendar td{background: #fff;vertical-align: top;text-align: left;height: 65px;padding-left: 0px;position: relative;}
			tr.header td{height: 23px;text-align: center;vertical-align: middle;}
			
			.datalist{width:100%;table-layout: fixed;}
			.datalist td{empty-cells:show;height: 28px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #999999;
				padding-left: 0px;background-color: #fff;border-bottom: 1px #EFEFEF solid;border-top: 1px #ffffff solid;}
			.datalist td.td1{border-bottom: 0px;background: #F7F7F7;text-align: center;}
			.datalist td.td_icon{background: url('../images/point_02_wev8.png') center no-repeat;background-color: #fff;}
			.datalist td.td_icon2{background: url('../images/li_wev8.png') center no-repeat;}
			.datalist tr{cursor: pointer;}
			.datalist tr.tr_blank{height: 0px !important;}
			.datalist tr.tr_blank td{height: 0px !important;border-width: 0px !important;}
			
			.datalist2{width:100%;table-layout: fixed;}
			.datalist2 td{height: 25px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #999999;;background-color: #fff;}
			.datalist2 td.td_icon2{background: url('../images/li_wev8.png') right no-repeat;}
			.datalist2 tr{cursor: pointer;}
			
			tr.data_hover td{background-color: #F6F6F6;}
			tr.data_hover2 td{background: #75B5DF;color: #FAFAFA;}
			tr.data_hover2 td.td_icon{background: url('../images/point_01_wev8.png') center no-repeat;background-color: #75B5DF;}
			
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
			.leftmenu_over input,.leftmenu_select input{color:#fff !important;}
			.leftmenu_select{background: url('../images/left_menu_wev8.png') left no-repeat;color:#fff;font-weight: bold;}
			 
			.input_inner{height:26px;width:220px;margin-left:0px;margin-right:0px;border:0px;font-size:12px;margin-top: 0px;margin-bottom: 0px;font-family:微软雅黑;
				border: 1px #B4B4B4 solid;box-shadow:0px 0px 2px #B4B4B4;-moz-box-shadow:0px 0px 2px #B4B4B4;-webkit-box-shadow:0px 0px 2px #B4B4B4;
				border-radius: 4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;padding-left: 2px;}
			label.overlabel {line-height:20px;position:absolute;top:5px;left:5px;color:#999;font-family: 微软雅黑;z-index:1;}
		
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
			.fuzzyquery_load{background: url('../images/loading2_wev8.gif') center no-repeat;height: 40px;}
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
			.fuzzyquery_query_tab2 td.t_status{color: #D7D7D7;width: 120px;text-align: right;padding-right: 2px;}
			
			.fuzzyquery_query_title td{border:0px;color:#393939;}
			.fuzzyquery_query_row_hover{background-color:#2F9AE1;}/*行移上去的样式*/
			.fuzzyquery_query_row_hover td,.fuzzyquery_query_row_hover td font{color: #fff !important;}
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
		
			.btn_add_type{width: 92%;line-height: 21px;cursor: pointer;border-bottom: 1px #F3F3F3 solid;font-family: 微软雅黑;text-align: left;padding-left: 8%;}
			.btn_add_type img{margin-top: -1px;}
			.btn_add_type_over{background-color: #0080C0;color: #FAFAFA;}
			.type_btn_select{color: #fff;cursor: default !important;}
			
			.disinput{border: 0px;width: 100%;background: none;height: 100%;line-height:100%;cursor: pointer;padding-left: 4px;}
			
			.addinput{color: #C0C0C0;font-style: italic;}
			
			.cond_txt{line-height: 26px;position: absolute;left: 10px;}
			.cond_icon{width: 20px;height: 26px;position: absolute;right: 8px;background: url('../images/menu_icon_2_wev8.png') center no-repeat;text-align: center;line-height: 26px;}
			.cond_icon10{background: url('../images/menu_icon_2_wev8.png') center no-repeat;}
			.cond_icon11{background: url('../images/menu_icon_2_hover_wev8.png') center no-repeat;}
			.cond_icon20{background: url('../images/menu_icon_1_wev8.png') center no-repeat;}
			.cond_icon21{background: url('../images/menu_icon_1_hover_wev8.png') center no-repeat;}
			.cond_icon30{background: url('../images/menu_icon_3_wev8.png') center no-repeat;}
			.cond_icon31{background: url('../images/menu_icon_3_hover_wev8.png') center no-repeat;}
			.cond_icon_count{background: none;}
			.lefttitle{background: url('../images/left_title_wev8.png') repeat-x;color: #818181;font-weight: bold;
				width: 100%;height: 26px;margin-top: 0px;position: relative;}
			.lefttitle_select{font-weight: bold;color: #818181;}
			.leftitem{width: 50px;text-align: center;margin-left: 0px;float: left;color: #B7B7B7;line-height: 26px;cursor: pointer;font-weight: normal;}
			.leftitem_hover{color: #818181;}
			.leftitem_click{color: #818181;font-weight: bold;}
			.leftitemline{width: 1px;height: 12px;font-size: 0px;float: left;margin-top: 7px;background: #CECECE;}
			
			#divmenu div{font-family: '微软雅黑' !important;}
			.main_btn{width: 70px;text-align: center;float:left;line-height: 26px;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;
				background: url('../images/pull_wev8.png') right no-repeat;font-family: '微软雅黑' !important;}
			.main_btn_hover{color:#004080;background: url('../images/pull_hover_wev8.png') right no-repeat;}
			.main_btn_select{color:#0080FF;}
			.div_cond{position: absolute;width: 69px;height: auto;text-align: center;z-index: 999;top: 83px;left: 803px;
						background: #fff;border: 1px #CACACA solid;display: none;
						border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
						box-shadow:0px 0px 3px #CACACA;-moz-box-shadow:0px 0px 3px #CACACA;-webkit-box-shadow:0px 0px 3px #CACACA;
    					behavior:url(/workrelate/css/PIE2.htc);}
    		.cond_year{width: 100%;background: #fff;}
    		.cond_year td{background: #FBFBFF;line-height: 20px;cursor: pointer;}
    		.cond_month{width: 100%;background: #fff;}
    		.cond_month td{background: #FBFBFF;line-height: 20px;cursor: pointer;}
    		.cond_td_hover{background: #E1E1FF !important;}
    		.cond_td_click{background: #0080C0 !important;color: #fff !important;}
    		.btn_prev{width: 20px;height: 20px;background: url('../images/btn_page_wev8.png') no-repeat 0px 0px;float: left;}
    		.btn_prev_hover{background: url('../images/btn_page_wev8.png') no-repeat -25px 0px;}
    		.btn_next{width: 20px;height: 20px;background: url('../images/btn_page_wev8.png') no-repeat 0px -25px;float: left;}
    		.btn_next_hover{background: url('../images/btn_page_wev8.png') no-repeat -25px -25px;}
	
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
			
			/**列表部分样式*/
			.sorttitle{width: 100%;cursor: pointer;padding-left: 0px;height: 28px;color: #000;overflow:hidden;
				border-bottom: 0px #F2F2F2 dashed;margin-top: 0px;}
			.sorthead{font-weight: bold;font-size: 13px;line-height: 28px;margin-left: 5px;float: left;font-family: 微软雅黑;}
			.sorticon{width: 23px;height: 100%;float: left;background: #EFEFEF;}
			.tr_select td{background-color: #CEE4FF !important;border-bottom-color: #75B4FF !important;}
			.tr_blur td{background-color: #F7F7F7 !important;}
			.tr_hover td{background-color: #F9F9F9;}
			.tr_hover div.status1{background: url('../images/ing_wev8.png') center no-repeat;}
			
			.td_move,.td_blank{background-color: #EFEFEF !important;text-align: center;padding: 0px !important;border-top-color: #EFEFEF !important;border-bottom-color: #EFEFEF !important;border-right: 1px #EFEFEF solid;}
			.td_move div,.td_blank div{width: 100%;height: 100%;line-height: 28px;margin: 0px !important;padding: 0px !important;border: 0px !important;}
			.td_att{padding: 0px;margin: 0px;background: url('../images/icon_special2_wev8.png') center no-repeat !important;}
			
			.td_drag{cursor: move !important;}
			.tr_hover .td_move{background: url('../images/icon_special_wev8.png') center no-repeat;}
			.tr_hover .td_move,.tr_hover .td_blank{background-color: #F9F9F9 !important;border-right-color: #F9F9F9;border-top-color: #fff !important;}
			.tr_hover .td_drag div{display: none;}
			
			.tr_select .td_drag{background: url('../images/sprite_wev8.png') no-repeat -97px -748px;background-color: #CEE4FF !important;border-right-color: #CEE4FF;border-top-color: #fff !important;border-bottom-color: #75B4FF !important;}
			.tr_select .td_move,.tr_select .td_blank{background-color: #CEE4FF !important;border-right-color: #CEE4FF;border-top-color: #fff !important;border-bottom-color: #75B4FF !important;}
			.tr_select .td_drag div{display: none;}
			.tr_select div.status1{background: url('../images/ing_wev8.png') center no-repeat;}
			
			.status{width: 20px;height: 17px;}
			.status1{}
			.status1_hover{background: url('../images/ing_hover_wev8.png') center no-repeat !important;}
			.status2{background: url('../images/complete_wev8.png') center no-repeat;}
			.status2_hover{background: url('../images/complete_hover_wev8.png') center no-repeat ;}
			.status3{background: url('../images/revoke_wev8.png') center no-repeat;}
			.status3_hover{background: url('../images/revoke_hover_wev8.png') center no-repeat;}
			
			.item_hrm{}
			.item_hrm a,.item_hrm a:hover,.item_hrm a:active,.item_hrm a:visited{color: #929292 !important;text-decoration: none !important;}
			.item_hrm a:hover{text-decoration: underline !important;}
			
			.div_level{width: 100%;height: 100%;}
			.div_today{width: 100%;height: 100%;text-align: center;color: #990000;line-height: 28px;}
			.listicon{width: 23px;height: 21px;float: left;background: #EFEFEF;}
			.listmore{cursor: pointer;width: 70px;height: 21px;line-height: 19px;margin-right: 4px;text-align: center;background:url('../images/morebg_wev8.png') top no-repeat;float: right;color:#696969; }
			.listmore_hover{color:#004080;}
			.datamore{width:100%;height:25px;line-height:25px;background: url('../images/more_bg_wev8.png') center repeat-x;cursor: pointer;color: #595959;font-family: '微软雅黑'}
			.datamore_hover{background: url('../images/more_bg_hover_wev8.png') center repeat-x;}
			.item_count{padding-left: 0px !important;text-align: center;}
			.item_count_new{color: #FF0000 !important;font-weight: bold;}
			.newinput{font-weight: bold;color:#800000}
			.item_att{}
			.item_att0{background: url('../images/icon_special_wev8.png') left no-repeat;}
			.item_att1{background: url('../images/icon_special2_wev8.png') left no-repeat;}
			
			/**明细部分样式*/
			.datatable{width: 100%;}	
			.datatable td{padding-left: 5px;padding-top:1px;padding-bottom:1px;text-align: left;}
			.datatable td.title{font-family: 微软雅黑;color: #999999;vertical-align: top;padding-top: 7px;padding-bottom: 7px;padding-left: 12px;background: #F6F6F6;border-top: 1px #F6F6F6 solid;border-bottom: 1px #F6F6F6 solid;}
			.datatable td.data{vertical-align: middle;border-top: 1px #fff solid;border-bottom: 1px #fff solid;}
			.feedrelate{display: none;}
			.feedrelate td{background: #fff !important;border-top: 1px #fff solid !important;border-bottom: 1px #fff solid !important;}
			
			.div_show{word-wrap:break-word;word-break:break-all;width: 90%;line-height: 20px;min-height:20px;}
			.div_show p{padding: 0px;margin: 0px;line-height: 20px !important;}
			.input_def{word-wrap:break-word;word-break:break-all;width: 90%;height:23px;line-height: 23px;border: 1px #fff solid;padding-left: 4px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;behavior:url(/workrelate/css/PIE2.htc);}
			.input_over{border: 1px #F0F0F0 solid;background: #fff;}
			.input_focus{border: 1px #1A8CFF solid;background: #fff;box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;}
			.content_def{width: 90%;min-height:20px;line-height: 20px;border: 1px #fff solid;padding: 3px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;text-align: left;behavior:url(/workrelate/css/PIE2.htc);}
			.content_def p{padding: 0px;margin: 0px;}
			.content_over{border: 1px #F0F0F0 solid;background: #fff;}
			.content_focus{border: 1px #1A8CFF solid;background: #fff;box-shadow:0px 0px 3px #1A8CFF;-moz-box-shadow:0px 0px 3px #1A8CFF;-webkit-box-shadow:0px 0px 3px #1A8CFF;}
			.feedback_def{width: 90%;min-height:30px;margin-bottom:30px;line-height: 20px !important;border: 1px #D7D7D7 solid;padding: 0px;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;text-align: left;behavior:url(/workrelate/css/PIE2.htc);}
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
				background: url('../images/edit_wev8.png') center no-repeat;display: none;cursor: pointer;}
			.btn_browser{width:40px;height:22px;float: left;margin-left: 5px;margin-top: 1px;margin-bottom: 1px;display: none;cursor: pointer;
				background: url('../images/browser_wev8.png') center no-repeat !important;}
			.browser_hrm{background: url('../images/browser_wev8.png') center no-repeat;}
			.browser_doc{background: url('../images/edit_bg_wev8.png') no-repeat 0px -22px;}
			.browser_wf{background: url('../images/edit_bg_wev8.png') no-repeat 0px -22px;}
			.browser_meeting{background: url('../images/edit_bg_wev8.png') no-repeat 0px -22px;}
			.browser_crm{background: url('../images/edit_bg_wev8.png') no-repeat 0px -22px;}
			.browser_proj{background: url('../images/edit_bg_wev8.png') no-repeat 0px -22px;}
			.add_input{width: 100px;height:20px;line-height: 20px;border: 1px #fff solid;padding-left: 2px;display: none;margin-left：5px;
				border: 1px #1A8CFF solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
				box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;float: left;
				behavior:url(/workrelate/css/PIE2.htc);}
				
			.txtlink{line-height:24px;float: left;margin-left: 3px;}
			
			.btn_del{width: 16px;height: 16px;background: url('../images/mainline_wev8.png') no-repeat -80px -126px;display: none;cursor: pointer;float: left;margin-left: 0px;}
			.btn_wh{width: 16px;height: 16px;float: left;margin-left: 0px;}
			
			.dtitle{width: 100%;height: 26px;line-height: 26px;font-weight: bold;border-bottom: 0px #E8E8E8 solid;cursor: pointer;
				background: url('../images/titlebg_wev8.png') repeat-x;}
			.dtxt{height: 26px;float: left;margin-left: 10px;font-family: 微软雅黑;}
			
			.btn_feedback{width: 50px;text-align: center;line-height: 18px;cursor: pointer;float: left;font-family: 微软雅黑;display:none;
				background-color: #67B5E9;color:#fff;margin-left: 10px;margin-bottom: 5px;margin-top: 5px;
				border: 1px #50A9E4 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
				box-shadow:0px 0px 2px #8EC8EE;-moz-box-shadow:0px 0px 2px #8EC8EE;-webkit-box-shadow:0px 0px 2px #8EC8EE;
				behavior:url(/workrelate/css/PIE2.htc);
			}
			.btn_feedback_hover{background-color: #1F8DD6;}
			
			.fbdata1{border-bottom: 1px #EFEFEF dashed !important;}
			.fbdata2{background: #F8F8F8 !important;}
			.feedbackshow{width: 96%;margin-left: 10px;margin-top: 0px;margin-bottom: 3px;overflow: hidden;}
			.feedbackinfo{width: auto;line-height: 24px;color: #B3A6B3;}
			.feedbackinfo a,.feedbackinfo a:active,.feedbackinfo a:visited{text-decoration: none !important;color: #95B3D7 !important;}
			.feedbackinfo a:hover{text-decoration: underline !important;color: #FF0000 !important;}
			.feedbackrelate{width: auto;line-height: 24px;background: #fff;overflow:hidden;padding:5px;color:#595959;
				border: 1px #BFBFBF solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
				box-shadow:0px 0px 2px #E7E7E7;-moz-box-shadow:0px 0px 2px #E7E7E7;-webkit-box-shadow:0px 0px 2px #E7E7E7;
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
		    	behavior:url(/workrelate/css/PIE2.htc);}
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
			.div_att0{background: url('../images/icon_special_wev8.png') center no-repeat;}
			.div_att1{background: url('../images/icon_special2_wev8.png') center no-repeat;}
			
			.dateArea {text-align: center;color: #999999;background: #A6A6A6;width: 45px;height: 35px;color: #fff;margin-top: 5px;}
			.dateArea .day {font-size: 12px;padding-top:1px;height:16px;font-family: '微软雅黑';}
			.dateArea .yearAndMonth{margin-top: 0px;font-family: '微软雅黑';}
			.blur_text{color: #DFDFDF;font-style: italic;height: 30px !important;resize:none;border: 1px #DFDFDF solid;margin-bottom: 5px;}
			
			
			.feedbackinfo a.a1,.feedbackinfo a.a1:active,.feedbackinfo a.a1:visited{text-decoration: none !important;color: #D1D1D1 !important;}
			.feedbackinfo a.a1:hover{text-decoration: underline !important;color: #0080FF !important;}
			.feedbackinfo a.a2,.feedbackinfo a.a2:active,.feedbackinfo a.a2:visited{text-decoration: none !important;color: #808080 !important;}
			.feedbackinfo a.a2:hover{text-decoration: underline !important;color: #0080FF !important;}
			
			
			span.file,span.folder{cursor: pointer !important;}
			#itemdiv2 span{background: none;padding: 0px !important;padding-left: 10px !important;}
			
			#itemdiv2 li{width: 100%;line-height: 26px;margin-top: 0px;color:#3A3A3A !important;padding: 0px !important;
				background: url('../images/menu_icon_1_wev8.png') right top no-repeat;}
			#itemdiv2 li.hover{background-color: #CECECE !important}
			#itemdiv2 li.collapsable,#itemdiv2 li.expandable{background: url('../images/menu_icon_1_hover_wev8.png') right top no-repeat;}
			#itemdiv2 a{color:#3A3A3A !important;font-family: '微软雅黑' !important;}
			#itemdiv2 ul{margin: 0px !important;margin-left: 10px !important;padding: 0px !important;}
			
			#itemdiv2 span.org_hover a{color:#fff !important;}
			
			#itemdiv2 span.org_select a{color:#fff !important;font-weight: bold !important;}
			#itemdiv2 span.org_select{background: url('../images/left_menu_wev8.png') left top no-repeat !important;}
			#itemdiv2 .hitarea{background: none !important;}
			
			#itemdiv3 span a{color: #3A3A3A;font-family: '微软雅黑' !important;}
			#itemdiv3 span a:hover{color:#FF0000;}
			#itemdiv3 span.org_select a{background-color: #fff !important;}
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
		<div id="main" style="width: 100%;height: 100%;background: url('../images/bg_wev8.png') top left no-repeat;background-color: #d9d9d9;position: absolute;top: 0px;left: 0px;right: 0px;bottom: 0px;">
			<!-- 左侧菜单 -->
			<div id="divmenu" style="width: 252px;height: 100%;" >
				<div style="width:100%;height: 40px;overflow: hidden;">
					<!--<img style="width:44px;height:44px;;margin-top: 6px;margin-left: 13px;
						float: left;" src="../images/ecology_wev8.png"/>-->
					<div style="font-size: 16px;color: #818181;margin-top: 18px;margin-left: 15px;
						font-weight: bold;font-family: 黑体;float: left;" >商机管理</div>
				</div>
				<!-- search -->
				<div style="width: 225px;height: 26px;;margin-top: 5px;margin-bottom: 10px;margin-left: 13px;position: relative;">
					<label for="objname" class="overlabel">按商机名称、客户名称及人员搜索</label>
					<input type="text" id="objname" name="objname" class="input_inner" />
				</div>
				
				<div class="lefttitle lefttitle_select" style="">
					<div class="leftitem leftitem_click" _index="1">本人</div>
					<div class="leftitemline"></div>
					<%
						rs.executeSql("select id,lastname from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID() + " order by dsporder");
						if(rs.getCounts()>0){
					%>
					<div class="leftitem" _index="2">下属</div>
					<div class="leftitemline"></div>
					<%  } %>
					<div class="leftitem" _index="3">组织</div>
				</div>
				<div id="condiv" class="scroll2">
					<div id="itemdiv1" class="itemdiv" style="width: 100%;height: 100%">
						<div class="leftmenu" _datatype="1" _subcompanyId="" _deptId="" _creater="<%=user.getUID() %>" _attention="" _sellstatusid="">
							<div class="cond_txt" title="我的商机">我的商机</div>
							<div id="icon1_1" class="cond_icon cond_icon20"></div>
						</div>
						<div class="leftmenu" _datatype="1" _subcompanyId="" _deptId="" _creater="" _attention="1" _sellstatusid="">
							<div class="cond_txt" title="关注商机">关注商机</div>
							<div id="icon1_2" class="cond_icon cond_icon20"></div>
						</div>
						<div class="leftmenu" _datatype="1" _subcompanyId="<%=user.getUserSubCompany1() %>" _deptId="" _creater="" _attention="" _sellstatusid="">
							<div class="cond_txt" title="所在分部商机">所在分部</div>
							<div id="icon1_3" class="cond_icon cond_icon20"></div>
						</div>
						<div class="leftmenu" _datatype="1" _subcompanyId="" _deptId="<%=user.getUserDepartment() %>" _creater="" _attention="" _sellstatusid="">
							<div class="cond_txt" title="所在部门商机">所在部门</div>
							<div id="icon1_4" class="cond_icon cond_icon20"></div>
						</div>
						<div class="leftmenu" _datatype="1" _subcompanyId="" _deptId="" _creater="-<%=user.getUID() %>" _attention="" _sellstatusid="">
							<div class="cond_txt" title="非本人商机">非本人商机</div>
							<div id="icon1_6" class="cond_icon cond_icon20"></div>
						</div>
						<div class="leftmenu" _datatype="1" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="">
							<div class="cond_txt" title="全部商机">全部商机</div>
							<div id="icon1_5" class="cond_icon cond_icon20"></div>
						</div>
					</div>
					<div id="itemdiv2" class="itemdiv" style="width: 100%;height: 100%;display: none;">
						
					</div>
					<div id="itemdiv3" class="itemdiv" style="width: 100%;height: 100%;display: none;">
					
					</div>
				</div>
				
				<div class="lefttitle" style="">
					<div style="line-height: 26px;position: absolute;left: 10px;">商机阶段</div>
				</div>
				<div id="statusdiv" class="scroll2" style="width: 100%;overflow-y: auto;overflow-x: hidden;">
					<%
						int temp = 6;
						SellstatusComInfo.setTofirstRow();
							while(SellstatusComInfo.next()){
								temp++;
					%>
					<div class="leftmenu" _datatype="0" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="<%=SellstatusComInfo.getSellStatusid() %>">
						<div class="cond_txt" title="<%=SellstatusComInfo.getSellStatusname() %>商机"><%=SellstatusComInfo.getSellStatusname() %></div>
						<div id="icon1_<%=temp %>" class="cond_icon cond_icon10"></div>
					</div>
					<%	}
						temp++;
					%>
					<div class="leftmenu" _datatype="0" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="-1">
						<div class="cond_txt" title="成功结案商机">成功结案</div>
						<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon10"></div>
					</div>
					<div class="leftmenu" _datatype="0" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="-2">
						<div class="cond_txt" title="失败结案商机">失败结案</div>
						<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon10"></div>
					</div>
				</div>
				<div class="lefttitle" style="">
					<div style="line-height: 26px;position: absolute;left: 10px;">商机联系</div>
				</div>
				<div id="contactdiv" class="scroll2" style="width: 100%;overflow-y: auto;overflow-x: hidden;">
					<div class="leftmenu" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7) %>">
						<div class="cond_txt" title="一周未联系商机">一周未联系</div>
						<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
					</div>
					<div class="leftmenu" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14) %>">
						<div class="cond_txt" title="二周未联系商机">二周未联系</div>
						<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
					</div>
					<div class="leftmenu" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30) %>">
						<div class="cond_txt" title="一个月未联系商机">一个月未联系</div>
						<div id="icon1_<%=temp %>" class="cond_icon cond_icon30"></div>
					</div>
					<div id="customdiv" class="leftmenu" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="">
						<div class="cond_txt" title="自定义未联系日期" style="right: 0px;width: auto;z-index: 100;cursor: pointer;">
							<input id="customdate" type="text" readonly="readonly" style="width: 100%;height:18px;line-height: 18px;padding-left: 0px;margin-top:3px;
				border: 0px;font-family:'微软雅黑';background:none;color:#3A3A3A;cursor: pointer;" value="自定义未联系日期"/></div>
						<div id="icon1_" class="cond_icon cond_icon30"></div>
					</div>
					<div style="width: 100%;height: 10px;"></div>
				</div>
				
				
			</div>
			
			<!-- 中心视图 -->
			<div id="view" style="width:auto;height:auto;position: absolute;top: 5px;left:252px;right: 460px;bottom: 1px;z-index: 9999">
				<div style="position: absolute;width: 11px;height: 11px;top:0px;left:0px;background: url('../images/bg_upleft_01_wev8.png') no-repeat;"></div>
				<div style="position: absolute;width: auto;height: 11px;top:0px;left:11px;right:0px;background: url('../images/bg_upcenter_01_wev8.png') repeat-x;">
					<div style="position: absolute;width: auto;height: 5px;top: 6px;right: 0px;border-right: 1px #BFC5CC solid;"></div>
				</div>
				<div style="position: absolute;width: 6px;height: auto;top:11px;bottom:0px;left:0px;background: url('../images/bg_centerleft_01_wev8.png') repeat-y;"></div>
				
				<div style="position: absolute;width: auto;height: auto;top:11px;bottom:0px;left:6px;right:0px;background: #fff;border-right: 1px #BFC5CC solid;">
					<div style="width: 100%;height: 40px;position: relative;">
						<div id="micon" style="position: absolute;left: 14px;top: 7px;width: 25px;height: 25px;background: url('../images/title_icon_0_wev8.png') no-repeat;"></div>
						<div id="mtitle" style="position: absolute;left: 46px;top: 0px;line-height: 38px;font-size: 16px;font-weight: bold;font-family: 微软雅黑"></div>
						<div id="stat" style="width: auto;line-height: 22px;position: absolute;right: 10px;top: 8px;z-index:1001;font-family: 微软雅黑">
						
						</div>
					</div>
					<div style="width: 100%;height: 26px;background: url('../images/title_bg_01_wev8.png') repeat-x;position: relative;">
						<div style="width: 22px;height: 100%;float: left;"></div>
						<div id="changebtn1" style="width: 90px;" class="main_btn" onclick="showChange(1,this)" title="商机阶段">
							商机阶段
						</div>
						<div id="changebtn2" class="main_btn" onclick="showChange(2,this)" title="预期年月">
							预期年月
						</div>
						<div id="changebtn3" class="main_btn" onclick="showChange(3,this)" title="预期收益">
							预期收益
						</div>
						<div id="changebtn4" class="main_btn" onclick="showChange(4,this)" title="可能性">
							可能性
						</div>
						<div id="changebtn5" class="main_btn" style="border-right: 1px #E4E4E4 solid;" onclick="showChange(5,this)" title="商机类型">
							商机类型
						</div>
						
						<div id="doadd" style="width: 60px;text-align: center;float:right;line-height: 26px;top: 0px;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;"
							onclick="addSellChance()" title="新建">
							<div class="c_img" style="float:left;width:20px;height:26px;background:url('../images/New_wev8.png') center no-repeat;margin-left: 5px;" title="新建"></div>
							<div style="float: left;margin-left: 2px;font-family: 微软雅黑;">新建</div>
						</div>
						<div id="btnrefresh" style="width: 18px;height: 100%;background: url('../images/icon_refresh_wev8.png') center no-repeat;cursor: pointer;float: right;margin-right: 4px;"
							onclick="loadList()" title="刷新"></div>
						<div id="btnreturn" style="width: 18px;height: 100%;background: url('../images/icon_return_wev8.png') center no-repeat;cursor: pointer;float: right;margin-right: 4px;"
							onclick="resetCond()" title="重置"></div>
					</div>
					<div id="changecond1" class="div_cond" style="width: 89px;">
    				<%
						SellstatusComInfo.setTofirstRow();
							while(SellstatusComInfo.next()){
					%>
						<div class="btn_add_type" onclick="doChange(this,1,<%=SellstatusComInfo.getSellStatusid() %>)"><%=SellstatusComInfo.getSellStatusname() %></div>
					<%	} %>
						<div class="btn_add_type" style="border-bottom: 0px;" onclick="doChange(this,1,'')">全部</div>
					</div>
					<div id="changecond2" class="div_cond" style="width: 120px;">
						<table class="cond_year" cellpadding="0" cellspacing="1" border="0">
							<tr>
								<td align="center">
									<div class="btn_prev" onclick="prevYear()"></div>
									<div id="year" style="float: left;width: 78px;line-height: 20px;cursor: default"><%=year %></div>
									<div class="btn_next" onclick="nextYear()"></div>
								</td>
							</tr>
						</table>
						<table class="cond_month" cellpadding="0" cellspacing="1" border="0">
							<tr><td>01</td><td>02</td><td>03</td></tr>
							<tr><td>04</td><td>05</td><td>06</td></tr>
							<tr><td>07</td><td>08</td><td>09</td></tr>
							<tr><td>10</td><td>11</td><td>12</td></tr>
						</table>
						<table style="width: 100%;background: #ECECFF;" cellpadding="0" cellspacing="1" border="0">
							<tr><td><div id="clearym" style="width: 100%;height: 18px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D;">全部</div></td></tr>
						</table>
					</div>
					<div id="changecond3" class="div_cond">
						<div class="btn_add_type" onclick="doChange(this,3,'0',50000)">0-5万</div>
						<div class="btn_add_type" onclick="doChange(this,3,50000,100000)">5-10万</div>
						<div class="btn_add_type" onclick="doChange(this,3,100000,200000)">10-20万</div>
						<div class="btn_add_type" onclick="doChange(this,3,200000,500000)">20-50万</div>
						<div class="btn_add_type" onclick="doChange(this,3,500000,1000000)">50-100万</div>
						<div class="btn_add_type" onclick="doChange(this,3,1000000,'')">100万以上</div>
						<div class="btn_add_type" style="border-bottom: 0px;" onclick="doChange(this,3,'')">全部</div>
					</div>
					<div id="changecond4" class="div_cond">
						<div class="btn_add_type" onclick="doChange(this,4,'0',0.3)">0-30%</div>
						<div class="btn_add_type" onclick="doChange(this,4,0.3,0.5)">30-50%</div>
						<div class="btn_add_type" onclick="doChange(this,4,0.5,0.7)">50-70%</div>
						<div class="btn_add_type" onclick="doChange(this,4,0.7,0.9)">70-90%</div>
						<div class="btn_add_type" onclick="doChange(this,4,0.9,'')">90%以上</div>
						<div class="btn_add_type" style="border-bottom: 0px;" onclick="doChange(this,4,'')">全部</div>
					</div>
					<div id="changecond5" class="div_cond">
						<div class="btn_add_type" onclick="doChange(this,5,1)">新签</div>
						<div class="btn_add_type" onclick="doChange(this,5,2)">二次</div>
						<div class="btn_add_type" style="border-bottom: 0px;" onclick="doChange(this,5,'')">全部</div>
					</div>
					<div id="listview">
						
					</div>
					
				</div>
			</div>
			
			<!-- 明细视图 -->
			<div id="detail" style="width:450px;height:auto;position: absolute;top: 5px;right: 10px;bottom: 1px;z-index: 2;">
				<div style="position: absolute;width: 11px;height: 11px;top:0px;right:0px;background: url('../images/bg_upright_01_wev8.png') no-repeat;"></div>
				<div style="position: absolute;width: auto;height: 11px;top:0px;right:11px;left:0px;background: url('../images/bg_upcenter_02_wev8.png') repeat-x;">
					<div style="position: absolute;width: auto;height: 5px;top: 6px;left: 0px;border-left: 1px #BFC5CC solid;"></div>
				</div>
				<div style="position: absolute;width: 6px;height: auto;top:11px;bottom:0px;right:0px;background: url('../images/bg_centerright_01_wev8.png') right repeat-y;"></div>
			
				<div id="detaildiv" style="position: absolute;width: auto;height: auto;top:11px;bottom:0px;left:0px;right:6px;background: #fff;border-left: 1px #BFC5CC solid;overflow: hidden;">
				</div>
			</div>
		</div>
		<div id="checknew"></div>
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			var newMap = new Map();
			var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp_wev8.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1_wev8.gif) center no-repeat'></div></div>";

			var nocontact = "";
			var subcompanyId = "";//分部id
			var deptId = "";//部门id
			var creater = "";//人员id
			var attention = "";
			var sellstatusid = "";
			var sellstatusid2 = "";
			var predate = "";
			var moneymin = "";
			var moneymax = "";
			var posiblemin = "";
			var posiblemax = "";
			var selltype = "";

			var keyname = "";
			var datatype = "";
			


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

				//组织结构树初始化
				$("#itemdiv3").addClass("hrmOrg"); 
			    $("#itemdiv3").treeview({
			    	url:"/tree/hrmOrgTree.jsp"
			    });
			  	//下属人员树初始化
			    $("#itemdiv2").addClass("hrmOrg"); 
			    $("#itemdiv2").treeview({
			        url:"/tree/hrmOrgTree.jsp",
			        root:"hrm|<%=user.getUID()%>"
			    });

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

				//左侧菜单事件绑定
				$("div.leftmenu").bind("mouseover",function(){
					$("div.leftmenu").removeClass("leftmenu_over");
					$(this).addClass("leftmenu_over");
				}).bind("mouseout",function(){
					$(this).removeClass("leftmenu_over");
				}).bind("click",function(e){
					var target=$.event.fix(e).target;
					if($(target).attr("id")=="customdate") return;
					//if($(this).attr("id")=="customdiv" && $(this).attr("_nocontact")=="") return;
					
					$("span.org_select").removeClass("org_select");
					$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
					$(this).addClass("leftmenu_select");
					subcompanyId = $(this).attr("_subcompanyId");
					deptId = $(this).attr("_deptId");
					creater = $(this).attr("_creater");
					attention = $(this).attr("_attention");
					sellstatusid = $(this).attr("_sellstatusid");
					nocontact = getVal($(this).attr("_nocontact"));
					keyname = "";
					
					datatype = $(this).attr("_datatype");
					if(datatype=="0"){
						sellstatusid2 = "";
						$("#changebtn1").html("商机阶段").hide();
					}else{
						$("#changebtn1").show();
					}
					var mtitle = $($(this).find("div")[0]).attr("title");
					$("#mtitle").html(mtitle);
					$("#micon").css("background","url('../images/title_icon_"+datatype+".png') no-repeat");
					loadList();
					loadDefault(mtitle);
				});

				$("div.leftitem").bind("mouseover",function(){
					$(this).addClass("leftitem_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("leftitem_hover");
				}).bind("click",function(){
					var _index = $(this).attr("_index");
					$("div.leftitem").removeClass("leftitem_click")
					$(this).addClass("leftitem_click");
					$("div.itemdiv").hide();
					$("#itemdiv"+_index).show();
				});

				$("div.btn_add_type").bind("mouseover",function(){
					$("div.btn_add_type").removeClass("btn_add_type_over");
					$(this).addClass("btn_add_type_over");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_add_type_over");
				});

				$("div.main_btn").bind("mouseover",function(){
					$(this).addClass("main_btn_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("main_btn_hover");
				});
				$("#btnrefresh").bind("mouseover",function(){
					$(this).css("background","url('../images/icon_refresh_hover_wev8.png') center no-repeat");
				}).bind("mouseout",function(){
					$(this).css("background","url('../images/icon_refresh_wev8.png') center no-repeat");
				});
				$("#btnreturn").bind("mouseover",function(){
					$(this).css("background","url('../images/icon_return_hover_wev8.png') center no-repeat");
				}).bind("mouseout",function(){
					$(this).css("background","url('../images/icon_return_wev8.png') center no-repeat");
				});

				//搜索框事件绑定
				$("#objname").FuzzyQuery({
					url:"GetData.jsp",
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

				$("div.listmore").live("mouseover",function(){
					$(this).addClass("listmore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("listmore_hover");
				});
				$("div.datamore").live("mouseover",function(){
					$(this).addClass("datamore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("datamore_hover");
				});

				//日期控件
				$.datepicker.setDefaults( {
					"dateFormat": "yy-mm-dd",
					"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
					"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
					"changeMonth": true,
					"changeYear": true} );
				$( "#customdate" ).datepicker({
					"onSelect":function(){
						var nodate = $("#customdate").val();
						$($("#customdiv").find("div")[0]).attr("title","自定义未联系："+nodate);
						$("#customdiv").attr("_nocontact",nodate).click();
					}
				});

				//初始加载我的商机
				//$("div.leftmenu")[0].click();
				//$("#detaildiv").append(loadstr).load("DefaultView.jsp");

				//列表页中事件绑定
				$("tr.item_tr").live("mouseover",function(){
					$(this).addClass("tr_hover").find("td.td_noatt").html("");
				}).live("mouseout",function(){
					$(this).removeClass("tr_hover");
					var obj = $(this).find("td.td_noatt");
					obj.html(obj.attr("_index"));
				}).live("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("status") && !$(target).hasClass("td_move") && !$(target).parent().hasClass("item_hrm")){
						$("tr.item_tr").removeClass("tr_select tr_blur");
						$(this).addClass("tr_select");
						doClickItem($(this));
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

				//绑定关注事件
				$("td.td_move").live("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var sellchanceid =  attobj.attr("_sellchanceid");
					var url = "/CRM/sellchance/SearchAttention.jsp?sellchanceId="+sellchanceid+"&settype="+_special;
					$.post(url,function(data){
						if(_special==1){
							attobj.removeClass("td_noatt").addClass("td_att").attr("title","取消关注").attr("_special","0").html("&nbsp;");	
						}else{
							attobj.removeClass("td_att").addClass("td_noatt").attr("title","标记关注").attr("_special","1").html("&nbsp;");	
						}
					});
				});

				$("table.cond_month").find("td").bind("mouseover",function(){
					$(this).addClass("cond_td_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("cond_td_hover");
				}).bind("click",function(){
					$(this).parents("table").find("td").removeClass("cond_td_click");
					$(this).addClass("cond_td_click");
					predate = $("#year").html()+"-"+$("table.cond_month").find("td.cond_td_click").html();
					$("#changebtn2").addClass("main_btn_select").html(predate); 
					$("#changecond2").hide();
					loadList();
				});
				$("#clearym").bind("click",function(){
					$("table.cond_month").find("td").removeClass("cond_td_click");
					doChange(this,2,'');
				}).bind("mouseover",function(){
					$(this).css({"color":"#F4F4FF","background":"#0080C0"});
				}).bind("mouseout",function(){
					$(this).css({"color":"#6D6D6D","background":"#fff"});
				});
				$("div.btn_prev").bind("mouseover",function(){
					$(this).addClass("btn_prev_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_prev_hover");
				});
				$("div.btn_next").bind("mouseover",function(){
					$(this).addClass("btn_next_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_next_hover");
				});

				//树形搜索中点击直接展开搜索并展开下属
				$("span.file,span.folder").live("click",function() {
					var a = $(this).children("a")[0];
					var click = $(a).attr("onclick");
					click = click.substring(0,click.indexOf(";"));
					orgobj = a;
					setTimeout(click,0);
					setTimeout("orgselect()",0);
				}).live("mouseover",function(){
					$(this).addClass("org_hover").parent("li").addClass("hover");
				}).live("mouseout",function(){
					$(this).removeClass("org_hover").parent("li").removeClass("hover");
				});

				checknew(1);
				setInterval(checknew,300000);
				//$('.scroll1').jScrollPane();
				setPosition();
			});
			var orgobj = null; 
			function orgselect(){
				$(orgobj).parent().addClass("org_select");
			}
			function getVal(val){
				if(val==null || typeof(val)=="undefined"){
					return "";
				}else{
					return val;
				}
			}
			function addSellChance(){
				openFullWindowHaveBar("/CRM/sellchance/manage/data/SellChanceAdd.jsp");
			}
			function onRefresh(){
				loadList();
			}
			function checknew(init){
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"check_new"}, 
				    complete: function(data){
						$("#checknew").html($.trim(data.responseText));
						setnew(init);
					}
			    });
			}
			function setnew(init){
				for(var i=1;i<<%=temp+1%>;i++){
					var amount = newMap.get("cond"+i);
					if(parseInt(amount)>0){
						if(i==1 && init==1) $("div.leftmenu")[0].click();//当我的商机个数不为0时默认加载我的商机
						$("#icon1_"+i).addClass("cond_icon_count").html(amount);
					}else{
						if(i==1 && init==1) $("div.leftmenu")[5].click();//当我的商机个数为0时默认加载全部商机
						$("#icon1_"+i).removeClass("cond_icon_count").html("");
					}
				}
				/**
				if(mynew){
					$("#icon1_1").removeClass("cond_icon10").addClass("cond_icon11").attr("title","有新任务或新反馈");
				}else{
					$("#icon1_1").removeClass("cond_icon11").addClass("cond_icon10").attr("title","");
				}*/
			}

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});

			//控制状态分类下拉菜单的控制
			$(document).bind("click",function(e){
				var target=$.event.fix(e).target;
				for(var i=1;i<6;i++){
					if($(target).attr("id")!=("changebtn"+i) 
							&& $(target).parents("div").attr("id")!=("changecond2")){
						$("#changecond"+i).hide();
					}
				}
			});
			$(document).bind("keydown",function(e){
				var target=$.event.fix(e).target;
				e = e ? e : event;   
			    if(e.keyCode == 13 && $(target).attr("id")=="objname" && $(".fuzzyquery_query_row_hover").length==0){
					searchByName();
			    }  
			});

			function hideSearch(){
				$("#fuzzyquery_query_div").slideUp("fast",function() {});
			}
			//显示下拉菜单
			function showChange(type,obj){
				$("#changecond"+type).css({
					"left":$(obj).position().left+"px",
					"top":"67px"
				}).show();
			}
			//切换条件
			function doChange(obj,type,val1,val2){
				if(type==1){//商机阶段
					if(sellstatusid2==val1) return; 
					sellstatusid2 = val1;
					if(val1==""){
						$("#changebtn1").html("商机阶段"); 
					}else{
						$("#changebtn1").html($(obj).html()); 
					}
				}else if(type==2){//预期年月
					//$("table.cond_year,table.cond_month").find("td").removeClass("cond_td_click");
					$("#changecond2").hide();
					if(predate=="") return;
					$("#changebtn2").html("预期年月"); 
					predate="";
				}else if(type==3){//预期收益
					if(moneymin==val1 && moneymax==val2) return; 
					moneymin = val1; moneymax = val2;
					if(val1==""){
						$("#changebtn3").html("预期收益"); 
					}else{
						$("#changebtn3").html($(obj).html()); 
					}
				}else if(type==4){//可能性
					if(posiblemin==val1 && posiblemax==val2) return; 
					posiblemin = val1; posiblemax = val2;
					if(val1==""){
						$("#changebtn4").html("可能性"); 
					}else{
						$("#changebtn4").html($(obj).html()); 
					}
				}else if(type==5){//商机类型
					if(selltype==val1) return; 
					selltype = val1;
					if(val1==""){
						$("#changebtn5").html("商机类型"); 
					}else{
						$("#changebtn5").html($(obj).html()); 
					}
				}
				if(val1==""){
					$("#changebtn"+type).removeClass("main_btn_select");
				}else{
					$("#changebtn"+type).addClass("main_btn_select");
				}
				
				
				loadList();
			}
			//重置查询条件
			function resetCond(){
				for(var i=1;i<6;i++){
					$("#changebtn"+i).html($("#changebtn"+i).attr("title")).removeClass("main_btn_select");
				}
				sellstatusid2 = "";
				predate = "";
				moneymin = "";
				moneymax = "";
				posiblemin = "";
				posiblemax = "";
				selltype = "";
				loadList();
			}
			function prevYear(){
				$("#year").html(parseInt($("#year").html())-1);
			}
			function nextYear(){
				$("#year").html(parseInt($("#year").html())+1);
			}
			//加载列表部分
			function loadList(){
				var date = new Date();
				listloadststus = date;
				$("#listview").append(loadstr);
				$.ajax({
					type: "post",
				    url: "ListView.jsp",
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"subcompanyId":subcompanyId,"deptId":deptId,"creater":creater,"attention":attention,"sellstatusid":sellstatusid,"sellstatusid2":sellstatusid2
					    ,"predate":predate,"moneymin":moneymin,"moneymax":moneymax,"posiblemin":posiblemin,"posiblemax":posiblemax,"selltype":selltype,"nocontact":nocontact,"keyname":filter(encodeURI(keyname))}, 
				    complete: function(data){ 
					    if(listloadststus==date){
					    	$("#listview").html(data.responseText);
						}
					}
			    });
			}
			//加载最新反馈部分
			function loadDefault(mtitle,isself){
				var fbupload = document.getElementById("fbUploadDiv");
				if(fbupload!=null) fbupload.innerHTML = "";
				isself = getVal(isself);
				$("#detaildiv").append(loadstr).load("DefaultView.jsp?mtitle="+mtitle
						+"&subcompanyId="+subcompanyId+"&deptId="+deptId+"&creater="+creater+"&attention="+attention+"&sellstatusid="+sellstatusid+"&nocontact="+nocontact+"&keyname="+keyname+"&isself="+isself);
			}
			//点击树中内容事件
			function doClick(id,type,obj,name){
			 	subcompanyId = "";
				deptId = "";
				creater = "";
				sellstatusid = "";
				keyname = "";
				nocontact = "";
				if(type==2){
					subcompanyId = id;
				}else if(type==3){
					deptId = id;
				}else if(type==4){
					creater = id;
				}
				$("#mtitle").html(name+"的商机");
				$("#changebtn1").show();
				$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
				$("span.org_select").removeClass("org_select");
				if(obj!=null) $(obj).parents().addClass("org_select");
				loadList();
				loadDefault(name+"的商机");
		 	}
			//通过搜索框查询某人时执行的加载列表部分
			function searchList(id,name){
				doClick(id,4,null,name)
			}
			//通过搜索框直接回车按名称查询
			function searchByName(){
				keyname = $("#objname").val();
				subcompanyId = "";
				deptId = "";
				creater = "";
				sellstatusid = "";
				nocontact = "";
				$("#mtitle").html("搜索结果");
				$("span.org_select").removeClass("org_select");
				$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
				loadList();
				loadDefault("搜索结果");
				$("#objname").blur();
			}
			//通过搜索框查询某商机时执行
			function searchDetail(_sellchanceid,_customerid,_lastdate,_sellchancename){
				if($("#item"+_sellchanceid).length>0){
					$("#item"+_sellchanceid).click();
				}else{
					$("tr.item_tr").removeClass("tr_select tr_blur");
					foucsobj = null;
					getDetail(_sellchanceid,_customerid,_lastdate,_sellchancename);
				}
			}
			//标题点击事件
			function doClickItem(obj){
				if($(foucsobj).attr("_sellchanceid")==$(obj).attr("_sellchanceid")) return;//重复点击时不会加载
				foucsobj = obj;
				var _sellchanceid = $(obj).attr("_sellchanceid");
				var _sellchancename = $(obj).attr("_sellchancename");
				var _customerid = $(obj).attr("_customerid");
				var _lastdate = $(obj).attr("_lastdate");
				getDetail(_sellchanceid,_customerid,_lastdate,_sellchancename);
			}
			//刷新明细部分
			function getDetail(sellchanceid,customerid,lastdate,sellchancename){
				var fbupload = document.getElementById("fbUploadDiv");
				if(fbupload!=null) fbupload.innerHTML = "";
				
				$("#detaildiv").html("").append(loadstr);
				detailloadstatus = sellchanceid;
				$.ajax({
					type: "post",
				    url: "DetailView.jsp",
				    data:{"sellchanceid":sellchanceid,"customerid":customerid,"lastdate":lastdate,"sellchancename":encodeURI(sellchancename)}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	if(detailloadstatus==sellchanceid){
						    $("#detaildiv").html($.trim(data.responseText));
						    $("#ContactInfo").focus();//焦点落在添加联系记录上
				    	}
					}
			    });
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
				if(width>1220){//窗口宽度大于1220时 右侧视图不会浮动在左侧菜单上
					
					width -= 256; 
					w1 = Math.round(width*5/9)+1;
					w2 = width-w1+1;
					$("#detail").animate({ width:w2 },speed,null,function(){
						
						$("#view").animate({ width:w1 },speed,null,function(){
							$("#view").animate({ left:246 },speed,null,function(){
							});
						});
					});
					
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
				var m = $("#main").height()-52-$("#condiv").offset().top;
				var m2 = Math.round(m/3);
				
				if($("#statusdiv").height()>=m2) $("#statusdiv").height(m2);
				if($("#contactdiv").height()>=m2) $("#contactdiv").height(m2);
				//var h = $("#main").height()-($("#statusdiv").height()+$("#contactdiv").height()+52+$("#condiv").offset().top);
				//var h = $("#main").height()-(182+182+52+$("#condiv").offset().top);
				var h = m - $("#statusdiv").height()-$("#contactdiv").height();
				$("#condiv").height(h);

				$("#detaildiv").height($("#detail").height()-11);
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
		</script>
	</body>
</html>
<%@ include file="/CRM/sellchance/manage/util/uploader.jsp" %>