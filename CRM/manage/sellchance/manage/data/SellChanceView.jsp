
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<%
	String userid = user.getUID()+"";
	String sellchanceid = Util.null2String(request.getParameter("id"));
	String customerid = "";
	String subject = "";
	String manager = "";
	String agent = "";
	String source = "";
	String predate = "";
	double preyield = 0;
	double probability = 0;
	String fileids = "";
	String fileids2 = "";
	String fileids3 = "";
	String remark = "";
	String sellstatusid = "";
	String endtatusid = "";
	String selltype = "";
	String createuserid = "";
	String createdate = "";
	String createtime = "";
	String updateuserid = "";
	String updatedate = "";
	String updatetime = "";
	String description = "";
	rs.executeSql("select subject,customerid,creater,content,source,predate,preyield,probability,fileids,fileids2,fileids3,remark,sellstatusid,endtatusid,selltype,createuserid,createdate,createtime,updateuserid,updatedate,updatetime,description from CRM_SellChance where id="+sellchanceid);
	if(rs.next()){
		customerid = Util.null2String(rs.getString("customerid"));
		subject = Util.null2String(rs.getString("subject"));
		customerid = Util.null2String(rs.getString("customerid"));
		manager = Util.null2String(rs.getString("creater"));
		agent = Util.null2String(rs.getString("content"));
		source = Util.null2String(rs.getString("source"));
		predate = Util.null2String(rs.getString("predate"));
		preyield = Util.getDoubleValue(rs.getString("preyield"),0)/10000;
		probability = Util.getDoubleValue(rs.getString("probability"),0)*100;
		fileids = Util.null2String(rs.getString("fileids"));
		fileids2 = Util.null2String(rs.getString("fileids2"));
		fileids3 = Util.null2String(rs.getString("fileids3"));
		remark = Util.convertDB2Input(rs.getString("remark"));
		sellstatusid = Util.null2String(rs.getString("sellstatusid"));
		endtatusid = Util.null2String(rs.getString("endtatusid"));
		selltype = Util.null2String(rs.getString("selltype"));
		createuserid = Util.null2String(rs.getString("createuserid"));
		createdate = Util.null2String(rs.getString("createdate"));
		createtime = Util.null2String(rs.getString("createtime"));
		updateuserid = Util.null2String(rs.getString("updateuserid"));
		updatedate = Util.null2String(rs.getString("updatedate"));
		updatetime = Util.null2String(rs.getString("updatetime"));
		description = Util.convertDB2Input(rs.getString("description"));
	}else{
		response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
		return;
	}
	boolean canedit = false;
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		//判断是否有编辑该客户商机权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs.getInt("status")==7 || rs.getInt("status")==8){
			canedit = false;
		}
	}
	
	String docIds1 = "";
	String docIds2 = "";
	String docIds3 = "";
	String docIds4 = "";
	String docIds5 = "";
	String docIds6 = "";
	String mainId = "";
	String subId = "";
	String secId = "";
	String maxsize = "";
	boolean hasPath = false;
	rs.executeSql("select infotype,item from CRM_SellChance_Set where infotype in (11,22,33,44,55,66,111,222,333) order by id "); 
	while(rs.next()){
		if("11".equals(rs.getString("infotype"))) docIds1 = Util.null2String(rs.getString("item"));
		if("22".equals(rs.getString("infotype"))) docIds2 = Util.null2String(rs.getString("item"));
		if("33".equals(rs.getString("infotype"))) docIds3 = Util.null2String(rs.getString("item"));
		if("44".equals(rs.getString("infotype"))) docIds4 = Util.null2String(rs.getString("item"));
		if("55".equals(rs.getString("infotype"))) docIds5 = Util.null2String(rs.getString("item"));
		if("66".equals(rs.getString("infotype"))) docIds6 = Util.null2String(rs.getString("item"));
		if("111".equals(rs.getString("infotype"))) mainId = Util.null2String(rs.getString("item"));
		if("222".equals(rs.getString("infotype"))) subId = Util.null2String(rs.getString("item"));
		if("333".equals(rs.getString("infotype"))) secId = Util.null2String(rs.getString("item"));
	}
	if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
		hasPath = true;
		rs.executeSql("select maxUploadFileSize from DocSecCategory where id=" + secId);
		rs.next();
		maxsize = Util.null2String(rs.getString(1));
	}
	String sql = "";
	String[] otherinfo = {"描述客户方关键需求","简述客户方信息化情况","简述客户方外围资源关系情况"
			,"简述优势点以及强化策略","简述劣势点以及弱化策略","友商名称","上传相关文件"};
	boolean hasProt = false;
	if(Util.getIntValue(sellstatusid,0)>4){
		hasProt = true;
	}
	String[] titles = {"项目决策人","客户高层","内部向导","技术影响人","需求影响人"};
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>查看销售商机-<%=subject %></title>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.core_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.widget_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker_wev8.js"></script>
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all_wev8.css" />
		<style type="text/css">
			html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
			*{font-size: 12px;font-family: Arial,'宋体';outline:none;}
			.clickRightMenu{position: absolute;}
			
			a,a:active,a:visited{text-decoration: none;color: #666666;}
			a:hover{text-decoration: underline;color: #0080FF;}
			
			.item_title{width: auto;height: 20px;font-size: 14px;font-weight: bold;margin-left: 4px;font-family: '微软雅黑';}
			.item_table,.rel_table,.other_table,.product_table{width: 100%;table-layout: fixed;}
			.item_table td,.rel_table td,.other_table td,product_table td{padding-left: 5px;color: #3E3E3E;vertical-align: middle;empty-cells:show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;}
			.item_table td.title{background: #F6F6F6;font-family: '微软雅黑';color: #181818;padding-top: 7px;padding-bottom: 7px;padding-right: 4px;}
			.rel_table td.title2,.other_table td.title2,.product_table td.title2{vertical-align:top;background: #F6F6F6;font-family: '微软雅黑';color: #181818;padding-top: 7px;padding-bottom: 7px;padding-right: 4px;}
			.rel_table td.title2 div,.other_table td.title2 div{font-family: '微软雅黑';}
			.product_table td.title3{vertical-align:top;font-family: '微软雅黑';color: #181818;padding-top: 4px;padding-bottom: 4px;padding-right: 4px;}
			td.td_hover{background: #FAFAFA !important;}
			.other_table td.oppttd{background: #DFDFDF !important;font-family: '微软雅黑';padding-top: 7px;padding-bottom: 7px;padding-right: 4px;color: #333333;font-size: 12px;font-weight: bold;}
			
			.item_table a,.item_table a:active,.item_table a:visited{text-decoration: none;color: #3E3E3E;}
			.item_table a:hover{text-decoration: underline;color: #0080FF;}
			
			.item_line{width: 100%;height: 2px;font-size: 0px;}
			.item_icon1,.item_line1{background: #5A95D1}
			.item_icon2,.item_line2{background: #74BB45}
			.item_icon3,.item_line3{background: #F86E30}
			.item_icon4,.item_line4{background: #A2C40B}
			.item_icon5,.item_line5{background: #E14364}
			.item_icon6,.item_line6{background: #5A95D1}
			.item_icon7,.item_line7{background: #74BB45}
			.item_icon8,.item_line8{background: #F86E30}
			.item_icon10,.item_line10{background: #879DB2}
			
			.item_input{width: 90%;height: 20px;border: 1px #fff solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;padding-left: 3px;resize:none;}
			.item_input_hover{border: 1px #CCCCCC solid;box-shadow:0px 0px 1px #fff;-moz-box-shadow:0px 0px 1px #fff;-webkit-box-shadow:0px 0px 1px #fff;}
			.item_input_focus{border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;resize:both;}
			.btn_browser{width:40px;height:22px;float: left;margin-left: 1px;margin-top: 2px;cursor: pointer;display: none;
				background: url('../images/browser_wev8.png') center no-repeat !important;}
			.txt_browser{width:auto;line-height:22px;float: left;margin-left: 4px;margin-top: 2px;}
			.btn_add{width:40px;height:22px;float: left;margin-left: 1px;margin-top: 2px;
				background: url('../images/edit_wev8.png') center no-repeat;display: none;cursor: pointer;}
			.add_input{width: 100px;height:24px;line-height: 20px;border: 1px #fff solid;padding-left: 2px;display: none;margin-left：5px;
				border: 1px #1A8CFF solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
				box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;float: left;}
			.txtlink{line-height:24px;float: left;margin-left: 3px;}
			.btn_del{width: 16px;height: 16px;background: url('../images/mainline_wev8.png') no-repeat -80px -126px;display: none;cursor: pointer;float: left;margin-left: 0px;margin-top: 2px;}
			.btn_wh{width: 16px;height: 16px;float: left;margin-left: 0px;}
			
			.item_select{position: absolute;display: none;overflow: hidden;background: #F0F0FF;}
			.item_option{line-height: 24px;padding-left: 5px;padding-right: 5px;cursor: pointer;}
			.item_option_hover{background: #0000FF;color: #fff;}
			
			a.slink{padding-right: 5px;border-right: 0px #DBDBDB dashed;}
			a.slink,a.slink:active,a.slink:visited{color: #DBDBDB !important;text-decoration: none;}
			a.slink:hover{color: #1A8CFF !important;text-decoration: underline;}
			a.sdlink{color: #000 !important;text-decoration: none !important;cursor: default;font-weight: bold;}
			a.sdlink:hover,a.sdlink:active,a.sdlink:visited{color: #000 !important;text-decoration: none !important;}
	
			.div_show{padding-left: 3px;}
			.upload{float: left;margin-top: 2px;display: ;position: relative;width: 60px;}
			
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
			.scroll1{overflow-y: auto;overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
			  	SCROLLBAR-ARROW-COLOR: #EAEAEA;
			  	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
			  	SCROLLBAR-SHADOW-COLOR: #E0E0E0 ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
			  	SCROLLBAR-FACE-COLOR: #ffffff;}
			
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
			.logitem{margin-left: 5px;color: #28282F;line-height: 22px;}
			.logitem p{line-height: 20px !important;margin: 0px;padding: 0px;}
			.logitem a,.logitem a:active,.logitem a:visited{text-decoration: none;color: #0080C0 !important;}
			.logitem a:hover{text-decoration: underline;}
			.datetxt{color: #B6A09A;}
			.log_txt{color: #969696;}
			.log_field{color: #2B2B2B;}
			.log_value{color: #FF0000;}
			
			
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
			
			.datamore{width:100%;height:25px;line-height:25px;background: url('../images/more_bg_wev8.png') center repeat-x;cursor: pointer;color: #595959;font-family: '微软雅黑'}
			.datamore_hover{background: url('../images/more_bg_hover_wev8.png') center repeat-x;}
			
			
			/***/
			.btn_save{width: 30px;text-align: center;line-height: 16px;cursor: pointer;float: left;font-family: 微软雅黑;
				background-color: #67B5E9;color:#fff;margin-bottom: 1px;margin-top: 2px;
				border: 1px #50A9E4 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;
				box-shadow:0px 0px 1px #8EC8EE;-moz-box-shadow:0px 0px 1px #8EC8EE;-webkit-box-shadow:0px 0px 1px #8EC8EE;
				}
			.btn_save_hover{background-color: #1F8DD6;}
			.addtable{width: 100%;}	
			.addtable td{padding-left: 3px;text-align: left;}
			.addtable td.title{font-family: 微软雅黑;color: #999999;padding-top:1px;padding-bottom:1px;vertical-align: top;padding-left: 1px;background: #F4F4F4;}
			.addtable td.data{vertical-align: middle;background: none;}
			.info_input{width: 90%;height: 18px;border: 1px #CCCCCC solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;padding-left: 3px;}
			.btn_browser3{width:20px;height:20px;float: left;margin-left: 1px;margin-top: 2px;cursor: pointer;
				background: url('../images/btn_browser_wev8.png') center no-repeat !important;}
			.btn_browser2{width:14px;height:14px;float: left;margin-left: 1px;margin-top: 0px;cursor: pointer;display:none;
				background: url('../images/btn_browser2_wev8.png') center no-repeat !important;}
			.btn_add2{width:14px;height:14px;float: left;margin-left: 2px;margin-top: 0px;cursor: pointer;display:none;
				background: url('../images/btn_add2_wev8.png') center no-repeat !important;}
			.load{width: 60px;height: 16px;margin-top: 2px;float: left;background:url(../images/loading2_wev8.gif) center no-repeat #fff;display: none;}
			.detailinput{width: 90%;height: 18px;border: 1px #F2F2F2 solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;padding-left: 3px;resize:none;}
			.detailinput_hover{border: 1px #CCCCCC solid;}
			.detailinput_focus{border: 1px #1A8CFF solid;resize:both;}
			
			.input_blur{font-style: italic;color: #D7D7D7;}
			.info{color: #8A8A8A !important;}
			.info a,.info a:active,.info a:visited{text-decoration: none !important;color: #1D76A4 !important;}
			.info a:hover{text-decoration: underline !important;color: #FF0000 !important;}
			
			.other_input{margin-top:3px !important;width: 98%;height: 20px;border: 1px #fff solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;padding-left: 3px;resize:none;}
			.other_input_hover{border: 1px #CCCCCC solid;box-shadow:0px 0px 1px #fff;-moz-box-shadow:0px 0px 1px #fff;-webkit-box-shadow:0px 0px 1px #fff;}
			.other_input_focus{border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;resize:both;}
			
			.relatedoc{font-weight: normal;color: #3E3E3E;font-style: italic;}
			
			.selectitem{width:50px;line-height: 21px;cursor: pointer;border-bottom: 0px #F3F3F3 solid;font-family: 微软雅黑;text-align: center;padding-left: 0px;float: left;}
			.selectitem_hover{background-color: #0080C0;color: #FAFAFA;}
			
			.oppt_input{margin-left:3px;background: #F9F9F9 !important;width: 80px;height: 18px;border: 1px #DFDFDF solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;padding-left: 2px;}
			.oppt_input_hover{background: #fff !important;border: 1px #CCCCCC solid;box-shadow:0px 0px 1px #fff;-moz-box-shadow:0px 0px 1px #fff;-webkit-box-shadow:0px 0px 1px #fff;}
			.oppt_input_focus{background: #fff !important;border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;}
			.opptdel{width: 20px;height: 14px;cursor: pointer;float: right;margin-right: 10px;display: none;background: url('../images/del_wev8.png') center no-repeat;}
			
			.btn_addoppt{width: 80px;height: 16px;border: 1px #DFDFDF solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;padding-left: 0px;
				border: 1px #CCCCCC solid;box-shadow:0px 0px 1px #fff;-moz-box-shadow:0px 0px 1px #fff;-webkit-box-shadow:0px 0px 1px #fff;
				float: left;cursor: pointer;margin-left: 5px;margin-top: 0px;font-weight: normal;text-align: center;color: #7F7F7F;font-family: '微软雅黑';}
			.btn_addoppt_hover{border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;}
			.sellstatus{width:90%;line-height: 28px;border: 1px #AFAFAF solid;text-align: center;background: #F0F0F0;color: #808080;font-family: '微软雅黑';}
			.sellstatus_select{background: #7BCD45;;color: #fff;}
			
			.pro_input{width: 90%;height: 20px;border: 1px #fff solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;padding-left: 3px;}
			.pro_input_hover{border: 1px #CCCCCC solid;box-shadow:0px 0px 1px #fff;-moz-box-shadow:0px 0px 1px #fff;-webkit-box-shadow:0px 0px 1px #fff;}
			.pro_input_focus{border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;}
		
			.btn_center{width: 1%;float: left;height: 100%;cursor: pointer;}
			.btn_right{background: url('../images/btn_right_wev8.png') right center no-repeat;}
			.btn_left{background: url('../images/btn_left_wev8.png') right center no-repeat !important;}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
			.item_input,.other_input{line-height: 20px;}
		</style>
		<![endif]-->
	</head>
	<body>
		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div style="width: 98%;height: 100%;margin: 0px auto;text-align: left;">
						<div style="width: 100%;height: 28px;border: 1px #CCCCCC solid;margin-top: 4px;background: url('../images/title_bg_wev8.gif') repeat-x;color:#666666;">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;float: left;">销售商机：</div>
							<div style="line-height: 28px;margin-left: 0px;float: left;"><%=subject %></div>
							<div style="float: right;margin-right: 5px;">
								<div style="line-height: 28px;margin-left: 40px;float: left;">创建人：<%=cmutil.getHrm(createuserid) %>&nbsp;&nbsp;&nbsp;&nbsp;创建时间：<%=createdate %> <%=createtime %></div>
								<div id="lastupdate" style="line-height: 28px;margin-left: 20px;float: left;">最后修改人：<%=cmutil.getHrm(updateuserid) %>&nbsp;&nbsp;&nbsp;&nbsp;最后修改时间：<%=updatedate %> <%=updatetime %></div>
								<%if(canedit){ %>
								<div style="float: left;width: 60px;line-height: 26px;text-align: center;margin-left: 5px;cursor: pointer;"
									onclick="showLog();">日志明细</div>
								<%} %>
							</div>
						</div>
						<!-- 左侧商机信息开始 -->
						<div id="leftdiv" style="width: 70%;overflow: auto;float: left;margin-top: 20px;" class="scroll1">
							<!-- 基本信息开始 -->
							<table style="width: 100%;margin-top: 0px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon1"></td>
									<td></td>
									<td>
										<div class="item_title item_title1">基本信息</div>
										<div class="item_line item_line1"></div>
										<table class="item_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px"/><col width="35%"/><col width="145px"/><col width="*"/></colgroup>
											<tr>
												<td class="title">商机名称</td>
												<td class="data">
													<input type="text" class="item_input" id="subject" name="subject" value="<%=subject %>"/>
												</td>
												<td class="title">销售预期</td>
												<td class="data">
													<input type="text" class="item_input" style="width: 100px;cursor: pointer;" id="predate" name="predate" value="<%=predate %>" readonly="readonly"/>
												</td>
											</tr>
											<tr>
												<td class="title">客户名称</td>
												<td class="data">
													<div class="div_show"><%=cmutil.getCustomer(customerid) %></div>
												</td>
												<td class="title">预期收益(万)</td>
												<td class="data">
													<%if(canedit){ %>
													<input type="text" class="item_input item_num" style="width: 40px;" id="preyield" name="preyield" value="<%=preyield %>" onkeypress="ItemNum_KeyPress()" onblur="checknumber('preyield');"/>万
													<%}else{ %>
													<div class="div_show"><%=preyield %></div>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">客户经理</td>
												<td class="data">
													<input type="hidden" id="manager_val" value="<%=manager %>"/>
													<div class="txtlink showcon txtlink<%=manager %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
														<%if(!manager.equals("0") && !manager.equals("")){ %>
														<div style="float: left;"><%=cmutil.getHrm(manager) %></div>
														<%} %>
													</div>
													<%if(canedit){ %>
											  		<input id="manager" name="manager" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
											  		<div class="btn_add"></div>
											  		<div class="btn_browser" onclick="onShowResource('manager')"></div>
											  		<%} %>
												</td>
												<td class="title">可能性(%)</td>
												<td class="data">
													<%if(canedit){ %>
													<input type="text" class="item_input item_num" style="width: 40px;" maxlength="3" id="probability" name="probability" value="<%=probability %>" onkeypress="ItemNum_KeyPress()" onblur="checknumber('probability');checkval();"/>%
													<%}else{ %>
													<div class="div_show"><%=probability %></div>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">中介机构</td>
												<td class="data">
													<input type="hidden" id="agent_val" value="<%=agent %>"/>
													<div class="txtlink showcon txtlink<%=agent %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
														<%if(!agent.equals("0") && !agent.equals("")){ %>
														<div style="float: left;"><%=cmutil.getCustomer(agent) %></div>
														<%if(canedit){ %>
														<div class="btn_del" onclick="doDelItem('agent',<%=agent %>)"></div>
														<div class="btn_wh"></div>
														<%} %>
														<%} %>
													</div>
													<%if(canedit){ %>
											  		<input id="agent" name="agent" class="add_input" _init="1" _searchwidth="160" _searchtype="agent"/>
											  		<div class="btn_add"></div>
											  		<div class="btn_browser" onClick="onShowAgent('agent')"></div>
											  		<%} %>
												</td>
												<td class="title">启动项目原因及关键需求</td>
												<td id="td_fileids" class="data">
													<%
														List fileidList = Util.TokenizerString(fileids,",");
														if(fileidList.equals("")) fileids = ",";
														for(int i=0;i<fileidList.size();i++){
															if(!"0".equals(fileidList.get(i)) && !"".equals(fileidList.get(i))){
																DocImageManager.resetParameter();
													            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
													            DocImageManager.selectDocImageInfo();
													            DocImageManager.next();
													            String docImagefileid = DocImageManager.getImagefileid();
													            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													            String docImagefilename = DocImageManager.getImagefilename();
													%>
													<div class='txtlink txtlink<%=fileidList.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<a href="javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('fileids','<%=fileidList.get(i) %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
													%>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		 %>
												</td>
											</tr>
											<tr>
												<td class="title">商机来源</td>
												<td class="data">
													<input type="hidden" id="source_val" value="<%=source %>"/>
													<div class="txtlink showcon txtlink<%=source %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
														<%if(!source.equals("0") && !source.equals("")){ %>
														<div style="float: left;"><%=ContactWayComInfo.getContactWayname(source) %></div>
														<%if(canedit){ %>
														<div class="btn_del" onclick="doDelItem('source',<%=source %>)"></div>
														<div class="btn_wh"></div>
														<%} %>
														<%} %>
													</div>
													<%if(canedit){ %>
											  		<input id="source" name="agent" class="add_input" />
											  		<div class="btn_browser" onclick="onShowSource('source')"></div>
											  		<%} %>
												</td>
												<td class="title" rowspan="2" title="本商机要成功的最关键因素以及可能存在的风险">成功关键因素(风险)</td>
												<td rowspan="2" class="data">
													<%if(canedit){ %>
													<textarea id="remark" name="remark" class="item_input" style="height: auto;resize: none;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"><%=remark %></textarea>
													<%}else{ %>
														<%=Util.toHtml(remark) %>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">商机类型</td>
												<td class="data">
													<%if(canedit){ %>
												  		<a id="selltype1" class="slink <%if("1".equals(selltype)){%>sdlink<%}%>" href="javascript:setSellType(1)"><img src="../images/<%if("1".equals(selltype)){%>level_01_wev8.png<%}else{%>level_00_wev8.png<%}%>" border="0" align="absMiddle"/>新签</a>
												  		<a id="selltype2" class="slink <%if("2".equals(selltype)){%>sdlink<%}%>" href="javascript:setSellType(2)"><img src="../images/<%if("2".equals(selltype)){%>level_01_wev8.png<%}else{%>level_00_wev8.png<%}%>" border="0" align="absMiddle"/>二次</a>
											  		<%}else{ %>
											  			<div class="div_show">
											  			<%if("1".equals(selltype)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>新签<%}%>
											  			<%if("2".equals(selltype)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>二次<%}%>
											  			</div>
											  		<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">商机状态</td>
												<td class="data">
													<%if(canedit){ %>
														<a id="endtatusid1" class="slink <%if("0".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(0)"><img src="../images/<%if("0".equals(endtatusid)){%>level_01_wev8.png<%}else{%>level_00_wev8.png<%}%>" border="0" align="absMiddle"/>进行中</a>
												  		<a id="endtatusid2" class="slink <%if("1".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(1)"><img src="../images/<%if("1".equals(endtatusid)){%>level_01_wev8.png<%}else{%>level_00_wev8.png<%}%>" border="0" align="absMiddle"/>成功</a>
												  		<a id="endtatusid3" class="slink <%if("2".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(2)"><img src="../images/<%if("2".equals(endtatusid)){%>level_01_wev8.png<%}else{%>level_00_wev8.png<%}%>" border="0" align="absMiddle"/>失败</a>
											  		<%}else{ %>
											  			<div class="div_show">
											  			<%if("0".equals(endtatusid)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>进行中<%}%>
											  			<%if("1".equals(endtatusid)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>成功<%}%>
											  			<%if("2".equals(endtatusid)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>失败<%}%>
											  			</div>
											  		<%} %>
												</td>
												<td class="title" title="对这个商机的成功与否进行复盘描述：我们是如何赢得这个客户的关键点，或者我们丢失这个客户的具体原因和以后的改进点">复盘文件</td>
												<td id="td_fileids2" class="data">
													<%
														List fileidList2 = Util.TokenizerString(fileids2,",");
														if(fileidList2.equals("")) fileids2 = ",";
														for(int i=0;i<fileidList2.size();i++){
															if(!"0".equals(fileidList2.get(i)) && !"".equals(fileidList2.get(i))){
																DocImageManager.resetParameter();
													            DocImageManager.setDocid(Integer.parseInt((String)fileidList2.get(i)));
													            DocImageManager.selectDocImageInfo();
													            DocImageManager.next();
													            String docImagefileid = DocImageManager.getImagefileid();
													            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													            String docImagefilename = DocImageManager.getImagefilename();
													%>
													<div class='txtlink txtlink<%=fileidList2.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<a href="javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList2.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList2.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('fileids2','<%=fileidList2.get(i) %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
													%>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv2" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		 %>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<!-- 基本信息结束 -->
							<!-- 商机阶段开始 -->
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="10%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/></colgroup>
								<tr>
									<td style="white-space: nowrap"><div style="font-family: '微软雅黑';padding-left: 5px;font-weight: bold;font-size: 14px;">商机阶段：</div></td>
									<%
										boolean selected = false;
										String[] titlestrs = {"意向需求确定：必须建立内部向导人支持我们、必须初步建立我们产品和方案优势、必须挖出竞争对手的弱点；请重点要了解客户需求的来源、预算、策略流程、关键需求、目前接触的厂商、客户行业的特点、客户的管理模式、老板的风格、客户方的组织架构、已有信息化情况"
											,"向导人确定阶段：必须赢得关键决策人的支持、必须引导出我方的产品和方案优势、必须挖掘出友商的致命弱点、以及包装好与该客户对标的泛微成功案例。必须明确我们的方案的优势和劣势、友商的动作、友商的竞争优势和劣势"
											,"决策人支持阶段：必须取得决策人的支持、我们产品的亮点和我们方案的优势已经具有明确文档或者DEMO呈现、建立起对手可能存在的弱点的演示关注点；如果决策人无法决定就必须要求高层演示会"
											,"高层演示成功阶段：必须要关注高层他们关心的需求；DEMO必须准备充分；案例必须准备充分；PPT必须精美；演示会需要带好的资料必须完整：书籍、产品资料、会议议程、公司介绍"
											,"商务谈判阶段：必须明确客户方的最高接受价格和对手的商务价格以及竞争对手目前的报价情况"
											,"合同签约阶段：必须明确我们无法实现的功能和服务不能在合同上文字体系"};
										int titleindex=0;
										SellstatusComInfo.setTofirstRow();
											while(SellstatusComInfo.next()){
												if(sellstatusid.equals(SellstatusComInfo.getSellStatusid())){
													selected = true;
												}else{
													selected = false;
												}
									%>
										<td align="center">
											<div class="sellstatus <%if(selected){%>sellstatus_select<%}%>"
												<%if(!selected && canedit){%> style="cursor: pointer;" onclick="setSellStatus('<%=SellstatusComInfo.getSellStatusid() %>','<%=SellstatusComInfo.getSellStatusname() %>')" 
												title="设置为<%=SellstatusComInfo.getSellStatusname()%>
<%=titlestrs[titleindex] %>"
												<%}%>
											>
												<%=SellstatusComInfo.getSellStatusname() %>
											</div>
										</td>
									<%titleindex++;} %>
								</tr>
							</table>
							<!-- 商机阶段结束 -->
							<%if(selltype.equals("1")){ %>
							<!-- 人员关系开始 -->
							<%
								sql = "select t1.id,t1.contacterid,t1.title,t1.remark,t2.title as gender,t2.fullname,t2.jobtitle,t2.lastname,t2.textfield1,t2.email,t2.phoneoffice,t2.mobilephone,t2.projectrole,t2.attitude,t2.attention"
										+" from CRM_SellChance_Rel t1 left join CRM_CustomerContacter t2 on t1.contacterid=t2.id where t1.sellchanceid="+sellchanceid+" order by t1.id";
								rs.executeSql(sql);
								if(rs.getCounts()==0){
									for(int i=0;i<titles.length;i++){
										rs.executeSql("insert into CRM_SellChance_Rel(sellchanceid,contacterid,title,remark) values("+sellchanceid+",0,'"+titles[i]+"','')");
									}
									rs.executeSql(sql);
								}
							%>
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon2"></td>
									<td></td>
									<td>
										<div class="item_title item_title2">客户方人员关系图</div>
										<div class="item_line item_line2"></div>
										<table id="reltable" class="rel_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/>
											<col width="8%"/><col width="8%"/><col width="10%"/><col width="10%"/>
											<col width="10%"/><col width="10%"/><col width="10%"/><col width="*"/></colgroup>
											<% 
												while(rs.next()){
													String relid = Util.null2String(rs.getString("id"));
											%>
												<tr id="tr_<%=relid %>">
													<td id="operate_<%=relid %>" class="title2">
														<div style="float: left;"><%=Util.null2String(rs.getString("title")) %></div>
														<%if(canedit){ %>
														<div style="float: right;">
															<div title="选择联系人" class="btn_browser2" onclick="onShowContacter('<%=relid %>','<%=Util.null2String(rs.getString("title")) %>')"></div>
															<div title="新建联系人" class="btn_add2" onclick="onAddContacter('<%=relid %>','<%=Util.null2String(rs.getString("title")) %>')"></div>
														</div>
														<%} %>
													</td>
													<td class="info" title="姓名:<%=Util.toScreen(rs.getString("fullname"),user.getLanguage())%>">
														<%if(Util.null2String(rs.getString("contacterid")).equals("")||Util.null2String(rs.getString("contacterid")).equals("0")){ %>
															<div class="input_blur">姓名</div>
														<%}else{ %>
															<a href="###" onclick="openFullWindowForXtable('/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=rs.getString("contacterid")%>&canedit=<%=canedit%>&frombase=1')" target="_self">
									             				<%=Util.toScreen(rs.getString("fullname"),user.getLanguage())%>
									             			</a>
														<%} %>
								             		</td>
								             		<td class="info" title="称呼:<%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("gender")),user.getLanguage())%>">
								             			<%if(Util.null2String(rs.getString("gender")).equals("")||Util.null2String(rs.getString("gender")).equals("0")){ %>
															<div class="input_blur">称呼</div>
														<%}else{ %>
															<%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("gender")),user.getLanguage())%>
														<%} %>
								             		</td>
													<td class="info" title="岗位:<%=Util.null2String(rs.getString("jobtitle"))%>">
														<%if(Util.null2String(rs.getString("jobtitle")).equals("")){ %>
															<div class="input_blur">岗位</div>
														<%}else{ %>
															<%=Util.null2String(rs.getString("jobtitle"))%>
														<%} %>
													</td>
													<td class="info" title="部门:<%=Util.null2String(rs.getString("textfield1"))%>">
														<%if(Util.null2String(rs.getString("textfield1")).equals("")){ %>
															<div class="input_blur">部门</div>
														<%}else{ %>
															<%=Util.null2String(rs.getString("textfield1"))%>
														<%} %>
													</td>
													<td class="info" title="联系方式:<%=Util.null2String(rs.getString("mobilephone"))%>">
														<%if(Util.null2String(rs.getString("mobilephone")).equals("")){ %>
															<div class="input_blur">联系方式</div>
														<%}else{ %>
															<%=Util.null2String(rs.getString("mobilephone"))%>
														<%} %>
													</td>
													<td class="info" title="关注点:<%=Util.null2String(rs.getString("attention"))%>">
														<%if(Util.null2String(rs.getString("attention")).equals("")){ %>
															<div class="input_blur">关注点</div>
														<%}else{ %>
															<%=Util.null2String(rs.getString("attention"))%>
														<%} %>
													</td>
													<td class="info" title="意向判断:<%=Util.null2String(rs.getString("attitude"))%>">
														<%if(Util.null2String(rs.getString("attitude")).equals("")){ %>
															<div class="input_blur">意向判断</div>
														<%}else{ %>
															<%=Util.null2String(rs.getString("attitude"))%>
														<%} %>
													</td>
													<td class="" title="应对策略:<%=Util.null2String(rs.getString("remark"))%>">
														<%if(canedit){ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<input class="detailinput ployinput input_blur" _relid="<%=relid %>" _type="contacter" type="text" value="应对策略" _item="<%=Util.null2String(rs.getString("title")) %>"/>
															<%}else{ %>
																<input class="detailinput ployinput" _relid="<%=relid %>" _type="contacter" type="text" value="<%=Util.null2String(rs.getString("remark"))%>" _item="<%=Util.null2String(rs.getString("title")) %>"/>
															<%} %>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur">应对策略</div>
															<%}else{ %>
																<%=Util.null2String(rs.getString("remark"))%>
															<%} %>
														<%} %>
													</td>
												</tr>
											
											<%	} %>
												<tr>
													<td class="title2">
														综合性描述
													</td>
													<td colspan="8">
														<%if(canedit){ %>
														<textarea id="description" name="description" class="item_input" style="width:98%;height: auto;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"><%=description %></textarea>
														<%}else{ %>
															<%=Util.toHtml(description) %>
														<%} %>
								             		</td>
								             	</tr>
										</table>
									</td>
								</tr>
							</table>
							<!-- 人员关系结束 -->
							<!-- 关键需求开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=1 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon3"></td>
									<td></td>
									<td>
										<div class="item_title item_title3">客户方关键需求分析
											<%if(!docIds1.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds1) %>)</font><%} %>
										</div>
										<div class="item_line item_line3"></div>
										<table id="apply_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",1,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="<%=Util.null2String(rs.getString("item")).trim() %>" _type="1" _setid="<%=setid %>" _index="0" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[0] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[0] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 关键需求结束 -->
							<!-- 优劣势分析开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark,t2.remark2"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.type=2 and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=2 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon4"></td>
									<td></td>
									<td>
										<div class="item_title item_title4">我方的竞争优劣势分析
											<%if(!docIds2.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds2) %>)</font><%} %>
										</div>
										<div class="item_line item_line4"></div>
										<table id="match_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark,remark2) values("+sellchanceid+","+setid+",2,'','')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>优势
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="我方<%=Util.null2String(rs.getString("item")).trim() %>优势" _type="2" _setid="<%=setid %>" _index="3" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[3] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[3] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             		<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>劣势
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply2_<%=setid %>" name="apply_<%=setid %>" _item="我方<%=Util.null2String(rs.getString("item")).trim() %>劣势" _type="21" _setid="<%=setid %>" _index="4" class="other_input <%if(Util.null2String(rs.getString("remark2")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark2")).equals("")){ %><%=otherinfo[4] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark2")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark2")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[4] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark2"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 优劣势分析结束 -->
							<!-- 友商优劣势分析开始 -->
							<%
								//查找友商信息
								rs.executeSql("select id,item,doc from CRM_SellChance_Set where infotype=6 order by id");
							%>
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon5"></td>
									<td></td>
									<td>
										<div class="item_title item_title5">
											<div style="float: left;font-family: '微软雅黑';font-size: 14px;">友商的竞争优劣势分析
											<%if(!docIds6.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds6) %>)</font><%} %>
											</div>
											<%if(canedit){ %>
											<div id="btn_oppt" style="" class="btn_addoppt">
												点击添加友商
											</div>
											<div id="opptselect" style="width: 150px;position: absolute;display: none;background: #F9F9F9;border-bottom: 1px #F3F3F3 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">
												<%while(rs.next()){ %>
												<div class="selectitem" _id="<%=rs.getString("id") %>" _name="<%=rs.getString("item") %>" onclick="doAddOppt(this)">
													<%=rs.getString("item") %>
													<div style="display: none;">
														<%if(!Util.null2String(rs.getString("doc")).equals("")){ %>
															<div style="float: left;"><font class="relatedoc">(参考知识：<%=cmutil.getDocName(Util.null2String(rs.getString("doc"))) %>)</font></div>
														<%} %>
													</div>
												</div>
												<%} %>
											</div>
											<%} %>
										</div>
										<div class="item_line item_line5"></div>
										<table id="oppt_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/><col width="125px;"/><col width="*"/></colgroup>
											<%
												
												sql = "select t1.id,t1.batchid,t1.setid,t1.opptid,t1.opptname,t1.remark,t1.remark2,se.item,oppt.item as opptitem,oppt.doc"
													+" from CRM_SellChance_Other t1,CRM_SellChance_Set se,CRM_SellChance_Set oppt "
													+" where t1.setid=se.id and t1.opptid=oppt.id and t1.sellchanceid="+sellchanceid
													+" and se.infotype=2 and oppt.infotype=6 order by t1.batchid,t1.id";
											
												//sql = "select t2.id,t2.item,t2.doc from CRM_SellChance_Other t1,CRM_SellChance_Set t2 where t1.opptid=t2.id and t2.infotype=6 group by t2.id";
												rs.executeSql(sql);
											%>
												
											<%
												String tempbatchid = "";
												while(rs.next()){ 
													String batchid = Util.null2String(rs.getString("batchid"));
													String setid = Util.null2String(rs.getString("setid"));
													String opptid = Util.null2String(rs.getString("opptid"));
											%>
											<%	if(!tempbatchid.equals(batchid)){ 
													tempbatchid = batchid;
											%>
												<tr class="oppttitle oppt<%=batchid %> opptid<%=opptid %>">
													<td class="oppttd"><%=rs.getString("opptitem") %>
													<%if(rs.getString("opptitem").equals("其他")){ %>
														<%if(canedit){ %>
														<input type="text" class="oppt_input <%if(Util.null2String(rs.getString("opptname")).equals("")){ %>input_blur<%} %>"
														 _index="5" _batchid="<%=batchid %>" value="<%if(Util.null2String(rs.getString("opptname")).equals("")){ %><%=otherinfo[5]%><%}else{%><%=Util.null2String(rs.getString("opptname")) %><%} %>"/>
														<%}else{ %>
															<%=Util.null2String(rs.getString("opptname")) %>
														<%} %>
													<%} %>
													</td>
													<td colspan="3">
														<%if(!Util.null2String(rs.getString("doc")).equals("")){ %>
															<div style="float: left;"><font class="relatedoc">(参考知识：<%=cmutil.getDocName(Util.null2String(rs.getString("doc"))) %>)</font></div>
														<%} %>
														<%if(canedit){ %>
														<div class="opptdel" onclick="delOppt('<%=batchid %>','<%=rs.getString("opptitem") %>')" title="删除"></div>
														<%} %>
													</td>
												</tr>
											<%	} %>
												<tr class="opptitem oppt<%=batchid %>">
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>优势
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="6" _setid="<%=setid %>" _index="3" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																 _item="<%=Util.null2String(rs.getString("opptitem")) %><%=Util.null2String(rs.getString("opptname")) %><%=Util.null2String(rs.getString("item")).trim() %>优势"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[3] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[3] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             		<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>劣势
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="61" _setid="<%=setid %>" _index="4" class="other_input <%if(Util.null2String(rs.getString("remark2")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																 _item="<%=Util.null2String(rs.getString("opptitem")) %><%=Util.null2String(rs.getString("opptname")) %><%=Util.null2String(rs.getString("item")).trim() %>劣势"
																 ><%if(Util.null2String(rs.getString("remark2")).equals("")){ %><%=otherinfo[4] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark2")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark2")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[4] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark2"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 友商优劣势分析结束 -->
							<!-- 信息化情况开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=3 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 49%;margin-top: 20px;float: left;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon6"></td>
									<td></td>
									<td>
										<div class="item_title item_title6">客户方信息化情况
											<%if(!docIds3.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds3) %>)</font><%} %>
										</div>
										<div class="item_line item_line6"></div>
										<table id="info_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",3,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="<%=Util.null2String(rs.getString("item")).trim() %>" _type="3" _setid="<%=setid %>" _index="1" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:96%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[1] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[1] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 信息化情况结束 -->
							<!-- 外围资源关系情况开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=5 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 50%;margin-top: 20px;margin-left: 0px;float: right;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon6"></td>
									<td></td>
									<td>
										<div class="item_title item_title6">客户方外围资源关系情况
											<%if(!docIds5.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds5) %>)</font><%} %>
										</div>
										<div class="item_line item_line6"></div>
										<table id="res_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",5,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="<%=Util.null2String(rs.getString("item")).trim() %>" _type="5" _setid="<%=setid %>" _index="2" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:96%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[2] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[2] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 外围资源关系情况结束 -->
							<!-- 相关文件开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=4 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 100%;margin-top: 20px;margin-left: 0px;float: left;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon8"></td>
									<td></td>
									<td>
										<div class="item_title item_title8">相关文件
											<%if(!docIds4.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds4) %>)</font><%} %>
										</div>
										<div class="item_line item_line8"></div>
										<table id="res_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",4,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td id="filetd_<%=setid %>">
													<%
														List _fileidList = Util.TokenizerString(Util.null2String(rs.getString("remark")),",");
														for(int i=0;i<_fileidList.size();i++){
															if(!"0".equals(_fileidList.get(i)) && !"".equals(_fileidList.get(i))){
																DocImageManager.resetParameter();
													            DocImageManager.setDocid(Integer.parseInt((String)_fileidList.get(i)));
													            DocImageManager.selectDocImageInfo();
													            DocImageManager.next();
													            String docImagefileid = DocImageManager.getImagefileid();
													            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													            String docImagefilename = DocImageManager.getImagefilename();
													%>
													<div class='txtlink txtlink<%=_fileidList.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<a href="javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=_fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=_fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('<%=Util.null2String(rs.getString("item")).trim() %>','<%=_fileidList.get(i) %>','<%=setid %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
														if(_fileidList.size()==0){
													%>
														<div class='txtlink input_blur' style='margin-right: 5px'><%=otherinfo[6] %></div>
													<%	} %>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv<%=setid %>" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>" setid="<%=setid %>"></div>
											  			<script type="text/javascript">$(document).ready(function(){bindUploaderDiv($("#uploadDiv<%=setid %>"),"<%=Util.null2String(rs.getString("item")).trim() %>","<%=sellchanceid%>");});</script>	
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		%>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 相关文件结束 -->
							<%} %>
							
							<%if(hasProt){ %>
							<!-- 产品开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=5 order by t1.id";
								//rs.executeSql(sql);
							%>
							<table style="width: 100%;margin-top: 20px;margin-left: 0px;float: left;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon7"></td>
									<td></td>
									<td>
										<div class="item_title item_title7">
											<div style="float: left;font-family: '微软雅黑';font-size: 14px;"><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></div>
											<%if(canedit){ %>
											<div style="width: 50px;float: right;margin-right: 5px;" class="btn_addoppt" onclick="doAddProduct()">
												新增
											</div>
											<%} %>
										</div>
										<div class="item_line item_line7"></div>
										<table id="product_table" class="product_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="15%"/><col width="12%"/><col width="12%"/><col width="12%"/><col width="12%"/><col width="12%"/><col width="*"/></colgroup>
											<%
												sql = "select id,productid,assetunitid,currencyid,salesprice,salesnum,totelprice from CRM_ProductTable where sellchanceid="+sellchanceid+" order by id";
												rs.executeSql(sql);
												while(rs.next()){ 
													String redid = Util.null2String(rs.getString("id"));
											%>
												<tr id="product_<%=redid %>" class="oppttitle">
													<td class="title3" colspan="2">
														<%if(canedit){ %>
														<div class="btn_browser3" onclick="onShowProduct('<%=redid%>')"></div>
														<%} %>
														<div class="txt_browser" id='productidSpan_<%=redid %>'><a href="/lgc/asset/LgcAsset.jsp?paraid=<%=Util.null2String(rs.getString("productid"))%>" target="_blank">
															<%=Util.toScreen(AssetComInfo.getAssetName(rs.getString("productid")),user.getLanguage())%></a>
														</div>
														<input type=hidden id='productid_<%=redid%>' name='productid_<%=redid%>' value='<%=Util.null2String(rs.getString("productid"))%>' />
													</td>
													<td>
														<span id='assetunitidSpan_<%=redid %>'><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(Util.null2String(rs.getString("assetunitid"))),user.getLanguage())%></span>         			
             											<input type=hidden id='assetunitid_<%=redid%>' name='assetunitid_<%=redid%>' value='<%=Util.null2String(rs.getString("assetunitid"))%>' />
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
								             			<div class="btn_browser3" onclick="onShowCurrency('currencyid_<%=redid%>','currencyidSpan_<%=redid %>')"></div>
														<%} %>
														<div class="txt_browser" id='currencyidSpan_<%=redid %>'>
															<%=Util.toScreen(CurrencyComInfo.getCurrencyname(Util.null2String(rs.getString("currencyid"))),user.getLanguage())%>
														</div>
														<input type=hidden id='currencyid_<%=redid%>' name='currencyid_<%=redid%>' value='<%=Util.null2String(rs.getString("currencyid"))%>' />
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
								             			<input class='pro_input' id='salesprice_<%=redid%>' name='salesprice_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesprice" value='<%=Util.null2String(rs.getString("salesprice"))%>'/>
								             			<%}else{ %>
									             			<%=Util.null2String(rs.getString("salesprice"))%>
									             		<%} %>
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
								             			<input class='pro_input' id='salesnum_<%=redid%>' name='salesnum_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesnum" value='<%=Util.null2String(rs.getString("salesnum"))%>'/>
								             			<%}else{ %>
									             			<%=Util.null2String(rs.getString("salesnum"))%>
									             		<%} %>
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
									             			<span id='totelprice_<%=redid%>' name='totelprice_<%=redid%>'>
									             			<%if(Util.null2String(rs.getString("totelprice")).equals("")){ %>
									             				<font class="input_blur">总价</font>
									             			<%}else{ %>
									             				<%=Util.null2String(rs.getString("totelprice"))%>
									             			<%} %>
									             			</span>
									             		<%}else{ %>
									             			<%=Util.null2String(rs.getString("totelprice"))%>
									             		<%} %>
								             		</td>
								             		<td align="right">
								             			<%if(canedit){ %>
								             				<div class="opptdel" onclick="delProduct('<%=redid %>',this)" title="删除"></div>	
								             			<%} %>
								             		</td>
								             	</tr>
								             <%} %>
								             <%if(canedit){ %>
								             	<tr id="product_add" style="display: none" class="oppttitle">
													<td class="title3" colspan="2">
														<div class="btn_browser3" onclick="onShowProduct('')"></div>
														<div class="txt_browser">
															<font class="input_blur"><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></font>
															<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:0px;'/>
														</div>
													</td>
													<td>
														<font class="input_blur"><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(2019,user.getLanguage())%></font>
								             		</td>
								             		<td align="right">
								             			<div class="opptdel" onclick="delProduct('',this)" title="取消"></div>	
								             		</td>
								             	</tr>
								             <%} %>
								             <tr>
								             	<td class="title2">报价书/合同书</td>
								             	<td id="td_fileids3" colspan="7">
													<%
														List fileidList3 = Util.TokenizerString(fileids3,",");
														for(int i=0;i<fileidList3.size();i++){
															if(!"0".equals(fileidList3.get(i)) && !"".equals(fileidList3.get(i))){
																DocImageManager.resetParameter();
													            DocImageManager.setDocid(Integer.parseInt((String)fileidList3.get(i)));
													            DocImageManager.selectDocImageInfo();
													            DocImageManager.next();
													            String docImagefileid = DocImageManager.getImagefileid();
													            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													            String docImagefilename = DocImageManager.getImagefilename();
													%>
													<div class='txtlink txtlink<%=fileidList3.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<a href="javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList3.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList3.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('fileids3','<%=fileidList3.get(i) %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
													%>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv3" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		 %>
												</td>
								             </tr>
										</table>
									</td>
								</tr>
							</table>
							<!-- 产品结束 -->
							<%} %>
							<div style="width: 100%;height: 20px;float: left;"></div>
						</div>
						<!-- 左侧商机信息结束 -->
						<div id="btn_center" class="btn_center" _status="0" title="收缩"></div>
						<!-- 右侧联系记录开始 -->
						<div id="rightdiv" style="width: 29%;overflow: auto;float: right;">
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon10"></td>
									<td></td>
									<td style="position: relative;">
										<div class="item_title item_title1">联系记录</div>
										<div class="item_line item_line10"></div>
										<div id="contactdiv" style="width: 100%;height: auto;">
											<jsp:include page="DetailView.jsp">
												<jsp:param value="<%=sellchanceid %>" name="sellchanceid"/>
												<jsp:param value="<%=subject %>" name="sellchancename"/>
												<jsp:param value="<%=customerid %>" name="customerid"/>
												<jsp:param value="1" name="hidetitle"/>
											</jsp:include>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<!-- 右侧联系记录结束 -->
					</div>
				</td>
			</tr>
		</table>
		<%if(canedit){ %>
		<div id="pre_select" class="item_select" _inputid="preyield">
			<div class="item_option" _val="5">5万</div>
			<div class="item_option" _val="10">10万</div>
			<div class="item_option" _val="20">20万</div>
			<div class="item_option" _val="30">30万</div>
			<div class="item_option" _val="50">50万</div>
			<div class="item_option" _val="100">100万</div>
			<div class="item_option" _val="200">200万</div>
		</div>
		<div id="pro_select" class="item_select" _inputid="probability">
			<div class="item_option" _val="30">30%   需求满足且客户联系人对泛微有好印象</div>
			<div class="item_option" _val="50">50%   我方产品方案优势确立并得到内部向导支持</div>
			<div class="item_option" _val="70">70%   对手存在客户方不接受的弱点且决策人已支撑我方</div>
			<div class="item_option" _val="90">90%   客户高层已同意确立合作、商务已经谈妥</div>
			<div class="item_option" _val="100">100% 合同已客户已盖章或提交客户方流转</div>
		</div>
		
		<!-- 快速新建联系人开始 -->
		<div id="addContacter" style="width: 800px;height: 30px;overflow: hidden;position: absolute;top: 150px;left:0px;display: none;">
			<div style="background: #fff;width: 100%;height: 100%;margin: 0px auto;overflow: hidden;">
				<div style="width: 100%;height: 100%;margin-left: 0px;margin-top: 3px;position: relative;">
					<form id="quickaddform" name="quickaddform" action="/CRM/data/ContacterOperation.jsp" method=post enctype="multipart/form-data" target="quickaddframe">
					<input type="hidden" name="CustomerID" value="<%=customerid %>"/>
					<input type="hidden" name="quickadd" value="1"/>
					<input type="hidden" name="method" value="add"/>
					<input type="hidden" name="Manager" value="<%=user.getUID()+"" %>"/>
					<input type="hidden" name="status" value="1"/>
					<input type="hidden" name="isneedcontact" value="1"/>
					<input type="hidden" name="Language" value="<%=user.getLanguage() %>"/>
					<table id="addtable" class="addtable" style="width: 100%" cellpadding="0" cellspacing="0" border="0">
						<colgroup><col width="13%"/><col width="12%"/><col width="13%"/><col width="13%"/>
											<col width="13%"/><col width="13%"/><col width="*"/></colgroup>
						<tr>
							<td class="data">
								<input class="info_input" style="width: 80%" maxlength=50 id="FirstName" name="FirstName" onchange='checkinput("FirstName","FirstNameimage")' /><span id=FirstNameimage><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
							</td>
							<td class="data">
								<div class="btn_browser3" onclick="onShowContacterTitle('Title','TitleSpan')"></div>
								<div class="txt_browser" id="TitleSpan"><img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:3px;'/></div>
								<input type="hidden" id="Title" name="Title" value=""/>
							</td>
							<td class="data">
								<input class="info_input" style="width: 80%" maxlength=100  id="JobTitle" name="JobTitle" onchange="checkinput('JobTitle','JobTitleimage')" /><span id="JobTitleimage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
							</td>
							<td class="data">
								<input class="info_input" maxlength=100 id="textfield1" name="textfield1" />
							</td>
							<td class="data">
								<input class="info_input" maxlength=100 id="Mobile" name="Mobile" />
							</td>
							<td class="data">
								<input class="info_input" maxlength=200 id="attention" name="attention" />
							</td>
							<td class="data">
								<div style="width: 146px;overflow: hidden;">
									<select id="attitude" name="attitude" style="float: left;">
						          		<option value=""></option>
						          		<option value="支持我方">支持我方</option>
						          		<option value="未表态">未表态</option>
						          		<option value="未反对">未反对</option>
						          		<option value="反对">反对</option>
				          			</select>
				          			<button id="quickreset" type="reset" style="display: none"/></button>
				          			<div class="btn_save" style="margin-left: 1px;float: left;" onclick="saveContacter();">保存</div>
									<div class="btn_save" style="margin-left: 2px;float: left;" onclick="cancelAddContacter();">取消</div>
									<div id="contact_load" class="load" style="background-color: transparent;"></div>
								</div>
							</td>
						</tr>
					</table>
					</form>
					
				</div>
			</div>
			<iframe id="quickaddframe" name="quickaddframe" style="display: none"></iframe>
		</div>
		<!-- 快速新建联系人结束 -->
		
		<!-- 提示信息 -->
		<div id="msg" style="position: absolute;width: 270px;line-height: 30px;text-align:center;left:100px;top:50px;background:#FBFDFF;color:#808080;font-size:14px;font-family:'微软雅黑';display:none;
			border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;
			border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">操作成功！</div>
			
		<!-- 日志明细开始 -->
		<div id="transbg" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/transbg_wev8.png') repeat;display: none;"></div>
		<div id="log_list" style="width: 100%;height: 471px;overflow: hidden;position: absolute;top: 100px;left:0px;display: none;">
			<div style="background: url('../images/log_bg_wev8.png') no-repeat;width: 590px;height: 100%;margin: 0px auto;overflow: hidden;position: relative;">
				<div style="width: 580px;margin-left: 5px;position: relative;">
					<div style="width: 18px;height: 18px;background: url('../images/log_btn_close_wev8.png');position: absolute;top:15px;right: 10px;cursor: pointer;" onclick="closeLog()" title="关闭"></div>
					<div id="log_title" style="line-height: 45px;padding-left: 10px;color: #fff;font-weight: bold;font-size: 14px;font-family: '微软雅黑'">操作日志</div>
					<div id="log_detail" class="scroll1" style="height: 410px;width: 98%;margin: 0px auto;position: relative;">
						<div id="logmore" class="datamore" style="display: none;text-align: center;" 
							onclick="getListLog(this)" _datalist="logtable" 
							_currentpage="0" _pagesize="30" _total="" title="显示更多数据">更多</div>
						<div id="log_load" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/loading2_wev8.gif') center no-repeat;"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 日志明细结束 -->
		<%} %>
			
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
		
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			var relinfomap = new Map();
			var description = "请描述客户方的决策流程、客户方的内部关系、已经我们如何赢得这些客户方关键人的支持。";
			var otherinfomap = new Map();
			
			$(document).ready(function(){
				//添加查看日志
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"add_log_view","sellchanceid":<%=sellchanceid%>}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){}
			    });
				
				<%if(canedit){%>
				relinfomap.put("FirstName","姓名");
				relinfomap.put("Title","称呼");
				relinfomap.put("JobTitle","岗位");
				relinfomap.put("textfield1","部门");
				relinfomap.put("Mobile","联系方式");
				relinfomap.put("Mobile","联系方式");
				relinfomap.put("attention","关注点");
				relinfomap.put("attitude","意向判断");

				<%for(int i=0;i<otherinfo.length;i++){%>
					otherinfomap.put("otherinfo<%=i%>","<%=otherinfo[i]%>");
				<%}%>
				
				//日期控件
				$.datepicker.setDefaults( {
					"dateFormat": "yy-mm-dd",
					"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
					"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
					"changeMonth": true,
					"changeYear": true} );
				$("#predate").datepicker({
					"onSelect":function(){
						doUpdate($("#predate"),1);
					}
				});

				$(".item_input").bind("focus",function(){
					$(this).addClass("item_input_focus");
					if(this.id=="preyield"){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						$("#pre_select").css({"top":_top,"left":_left}).show();
						$(this).width(100);
					}
					if(this.id=="probability"){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						$("#pro_select").css({"top":_top,"left":_left}).show();
						$(this).width(100);
					}
					if(this.id=="remark" || this.id=="description"){
						$(this).height(70);
					}
					tempval = $(this).val();
					foucsobj2 = this;
				}).bind("blur",function(){
					$(this).removeClass("item_input_focus");
					if(this.id=="preyield"||this.id=="probability"){
						$(this).width(40);
					}
					if(this.id=="remark" || this.id=="description"){
						setRemarkHeight(this.id);
					}
					doUpdate(this,1);
				});

				//输入添加按钮事件绑定
				$("div.btn_add").bind("click",function(){
					$(this).hide();
					$(this).nextAll("div.btn_browser").hide();
					$(this).prevAll("div.showcon").hide();
					$(this).prevAll("input.add_input").show().focus();
					$(this).prevAll("div.btn_select").show();
				});
				
				//表格行背景效果及操作按钮控制绑定
				$("table.item_table").find("td.data").bind("click mouseenter",function(){
					$(".btn_add").hide();$(".btn_browser").hide();
					$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
					$(this).find(".item_input").addClass("item_input_hover");
					//$(this).find(".item_num").width(100);
					if($(this).find("input.add_input").css("display")=="none"){
						$(this).find("div.btn_add").show();
						$(this).find("div.btn_browser").show();
					}
					$(this).find("div.btn_add2").show();
					$(this).find("div.btn_browser2").show();
					//$(this).find("div.upload").show();
				}).bind("mouseleave",function(){
					$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
					$(this).find(".item_input").removeClass("item_input_hover");
					//$(this).find(".item_num").width(40);
					if($(this).find("input.add_input").css("display")=="none"){
						$(this).find("div.btn_add").hide();
						$(this).find("div.btn_browser").hide();
					}
					$(this).find("div.btn_add2").hide();
					$(this).find("div.btn_browser2").hide();
					//$(this).find("div.upload").hide();
				});
				$("table.rel_table").find("tr").bind("click mouseenter",function(){
					$("table.rel_table").find("div.btn_add2").hide();
					$("table.rel_table").find("div.btn_browser2").hide();
					$(this).find("div.btn_add2").show();
					$(this).find("div.btn_browser2").show();
					$(this).find(".item_input").addClass("item_input_hover");
				}).bind("mouseleave",function(){
					$(this).find("div.btn_add2").hide();
					$(this).find("div.btn_browser2").hide();
					$(this).find(".item_input").removeClass("item_input_hover");
				});
				//其他相关信息表格事件绑定
				$("table.other_table").find("td").live("click mouseenter",function(){
					$(this).addClass("td_hover").find(".other_input").addClass("other_input_hover");
					$(this).prev("td.title2").addClass("td_hover");
					//$(this).find("div.upload").show();
				}).live("mouseleave",function(){
					$(this).removeClass("td_hover").find(".other_input").removeClass("other_input_hover");
					$(this).prev("td.title2").removeClass("td_hover");
					//$(this).find("div.upload").hide();
				});
				$(".other_input").live("focus",function(){
					$(this).addClass("other_input_focus");
					tempval = $(this).val();
					foucsobj2 = this;
					var _index = $(this).attr("_index");
					if(this.value == otherinfomap.get("otherinfo"+_index)){
						this.value = "";
						$(this).removeClass("input_blur");
					}
					$(this).height(70);
				}).live("blur",function(){
					$(this).removeClass("other_input_focus");
					setRemarkHeight(this.id);
					doUpdateOther(this);
				}).each(function(){
					setRemarkHeight(this.id);
				});

				$("div.item_option").bind("mouseover",function(){
					$(this).addClass("item_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("item_option_hover");
				}).bind("click",function(){
					var obj = $("#"+$(this).parent().attr("_inputid"));
					tempval = obj.val();
					obj.val($(this).attr("_val"));
					doUpdate(obj,1);
				});


				//联想输入框事件绑定
				$("input.add_input").bind("focus",function(){
					if($(this).attr("_init")==1 && $(this).attr("id")!="source"){
						$(this).FuzzyQuery({
							url:"/CRM/sellchance/manage/data/GetData.jsp",
							record_num:5,
							filed_name:"name",
							searchtype:$(this).attr("_searchtype"),
							divwidth: $(this).attr("_searchwidth"),
							updatename:$(this).attr("id"),
							updatetype:"str"
						});
						$(this).attr("_init",0);
					}
					foucsobj2 = this;
				}).bind("blur",function(e){
					$(this).val("");
					$(this).hide();
					$(this).nextAll("div.btn_add").show();
					$(this).nextAll("div.btn_browser").show();
					$(this).prevAll("div.showcon").show();
				});

				//人员关系应对策略输入框事件绑定
				$("input.detailinput").bind("mouseover",function(){
					$(this).addClass("detailinput_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("detailinput_hover");
				}).bind("focus",function(){
					$(this).removeClass("detailinput_hover").addClass("detailinput_focus");
					tempval = $(this).val();
					foucsobj2 = this;
				}).bind("blur",function(){
					$(this).removeClass("detailinput_focus");
					doUpdateDetail(this);
				});


				$("div.datamore").live("mouseover",function(){
					$(this).addClass("datamore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("datamore_hover");
				});


				$("#addtable").find("input.info_input").bind("focus",function(){
					var _keyword = relinfomap.get(this.id);
					if(this.value == _keyword){
						this.value = "";
						$(this).removeClass("input_blur");
					}
				}).bind("blur",function(){
					var _keyword = relinfomap.get(this.id);
					if(this.value == ""){
						this.value = _keyword;
						$(this).addClass("input_blur");
					}
				});
				$("input.ployinput").bind("focus",function(){
					if(this.value == "应对策略"){
						this.value = "";
						$(this).removeClass("input_blur");
					}
				});
				if($("#description").val()=="") $("#description").val(description).addClass("input_blur");
				$("#description").bind("focus",function(){
					if(this.value == description){
						this.value = "";
						$(this).removeClass("input_blur");
					}
				});

				//选择友商部分事件绑定
				$("div.btn_addoppt").bind("mouseover",function(){
					$(this).addClass("btn_addoppt_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_addoppt_hover");
				});
				$("div.selectitem").bind("mouseover",function(){
					$(this).addClass("selectitem_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("selectitem_hover");
				});
				$("#btn_oppt").bind("click",function(){
					$("#opptselect").css({
						"left":$(this).position().left+"px",
						"top":$(this).position().top+21+"px"
					}).show();
				});
				$("input.oppt_input").live("mouseover",function(){
					$(this).addClass("oppt_input_hover");
				}).live("mouseout",function(){
					$(this).removeClass("oppt_input_hover");
				}).live("focus",function(){
					$(this).addClass("oppt_input_focus");
					tempval = $(this).val();
					foucsobj2 = this;
					var _index = $(this).attr("_index");
					if(this.value == otherinfomap.get("otherinfo"+_index)){
						this.value = "";
						$(this).removeClass("input_blur");
					}
				}).live("blur",function(){
					$(this).removeClass("oppt_input_focus");
					doUpdateOpptname(this);
				});
				$("tr.oppttitle").live("mouseenter",function(){
					$(this).find("div.opptdel").show();
				}).live("mouseleave",function(){
					$(this).find("div.opptdel").hide();
				});
				$("tr.opptitem").live("mouseenter",function(){
					var trtitle = $(this).prevAll("tr.oppttitle")[0];
					$(trtitle).find("div.opptdel").show();
				}).live("mouseleave",function(){
					var trtitle = $(this).prevAll("tr.oppttitle")[0];
					$(trtitle).find("div.opptdel").hide();
				});
				

				$("#leftdiv").scroll(function(){
					$("#pre_select").hide();
					$("#pro_select").hide();
					$("#opptselect").hide();
					if(_relid!="") onAddContacter(_relid);
				});

				<%if(canedit && hasPath){%>
					bindUploaderDiv($("#uploadDiv"),"fileids","<%=sellchanceid%>");
					bindUploaderDiv($("#uploadDiv2"),"fileids2","<%=sellchanceid%>");
					<%if(hasProt){%>
						bindUploaderDiv($("#uploadDiv3"),"fileids3","<%=sellchanceid%>");
					<%}%>
				<%}%>

				<%if(hasProt){ %>
				//产品明细输入框事件绑定
				$("input.pro_input").live("focus",function(){
					$(this).removeClass("pro_input_hover").addClass("pro_input_focus");
					tempval = $(this).val();
					foucsobj2 = this;
				}).live("blur",function(){
					$(this).removeClass("pro_input_focus");

					var redid = $(this).attr("_redid");
					var fieldname = $(this).attr("_fieldname");
					var fieldval = eval(toFloat($(this).val(),0))
					if(fieldval=="" || toFloat(fieldval)==toFloat(tempval)){
						$(this).val(tempval);
						return;
					}
			    	var salesprice = eval(toFloat($("#salesprice_"+redid).val(),0));
			    	var salesnum = eval(toFloat($("#salesnum_"+redid).val(),0));
			        var totelprice = toFloat(salesprice) * toFloat(salesnum);
			    	$("#totelprice_"+redid).html(toPrecision(totelprice,4));
					
					doUpdatePro(fieldname,fieldval,redid,fieldval,toPrecision(totelprice,4));
				});
				$("#product_table").find("tr").live("click mouseenter",function(){
					$(this).find("td").addClass("td_hover").find("input.pro_input").addClass("pro_input_hover");
					//$(this).find("div.upload").show();
				}).live("mouseleave",function(){
					$(this).find("td").removeClass("td_hover").find("input.pro_input").removeClass("pro_input_hover");
					//$(this).find("div.upload").hide();
				});
				<%}%>

				//页面点击及回车事件绑定
				$(document).bind("click",function(e){
					var target=$.event.fix(e).target;
					if($(target).attr("id")!="pre_select" && $(target).attr("id")!="preyield"){
						$("#pre_select").hide();
					}
					if($(target).attr("id")!="pro_select" && $(target).attr("id")!="probability"){
						$("#pro_select").hide();
					}
					if($(target).attr("id")!="btn_oppt"){
						$("#opptselect").hide();
					}
				}).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).hasClass("item_input") && $(target).attr("id")!="remark"){
				    		$(foucsobj2).blur();  
				    		$("div.item_select").hide();
				    	}
						if($(target).hasClass("detailinput") || $(target).hasClass("oppt_input") || $(target).hasClass("pro_input")){
				    		$(foucsobj2).blur();  
				    	}
				    }
				});
				
				cancelAddContacter();
				<%}%>

				$("#btn_center").bind("mouseover",function(){
					$(this).addClass("btn_right");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_right");
				}).bind("click",function(){
					var _status = $(this).attr("_status");
					if(_status==0){
						$(this).attr("_status",1).attr("title","展开").addClass("btn_left");
						$("#rightdiv").hide();
						$("#leftdiv").width("99%");
					}else{
						$(this).attr("_status",0).attr("title","收缩").removeClass("btn_left");
						$("#rightdiv").show();
						$("#leftdiv").width("70%");
					}
				});

				setPosition();
				setRemarkHeight("remark");
				setRemarkHeight("description");
			});

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});

			function setPosition(){
				if($(window).width()<1000){
					$("#main").width(1000);
				}else{
					$("#main").width("100%");
				}
				var wh = $(window).height();
				$("#main").height(wh);
				var _top = $("#contactdiv").offset().top;
				$("#contactdiv").height(wh-_top-5);

				var _top2 = $("#leftdiv").offset().top;
				$("#leftdiv").height(wh-_top2-5);

				if(_relid!="") onAddContacter(_relid);
				//$("#maininfo").height($("#main").height()-_top-$("#fbmain").height()-5);
			}
			function setRemarkHeight(remarkid){
				if($("#"+remarkid).length>0){
					$("#"+remarkid).height("auto");
					var h= document.getElementById(remarkid).scrollHeight; 
					//h = $("#"+remarkid).height();
					//alert(h);alert(document.getElementById(remarkid).clientHeight);
					//alert($("#"+remarkid).val().indexOf("\n"))
					if(h>70){
						$("#"+remarkid).height(70);
						//$("#"+remarkid).height(textarea.scrollHeight);
					}else if(h<20 || ($("#"+remarkid).val().indexOf("\n")<0 && h==34)){
						$("#"+remarkid).height(20);
					}else{
						$("#"+remarkid).height(h);
					}
				}
			}

			<%if(canedit){%>
			//显示日志
			function showLog(){
				$("#transbg").show();
				$("#log_list").show();
				$("#log_load").show();
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_log_count","sellchanceid":<%=sellchanceid%>}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
				    	$("#logmore").attr("_total",txt).attr("_currentpage","0").click();
					}
			    });
			}
			//关闭日志
			function closeLog(){
				$("#transbg").hide();
				$("#log_list").hide();
				$("div.logitem").remove();
			}
			//读取日志更多记录
			function getListLog(obj){
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_log_list","sellchanceid":<%=sellchanceid%>,"currentpage":_currentpage,"pagesize":_pagesize,"total":_total}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	var records = $.trim(data.responseText);
				    	$("#log_load").hide();
				    	$(obj).before(records);
				    	if(_currentpage*_pagesize>=_total){
				    		$(obj).hide();
					    }else{
					    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
						}
					}
			    });
			}
			//添加友商信息
			function doAddOppt(obj){
				var opptid = $(obj).attr("_id");
				var opptname = $(obj).attr("_name");
				if(opptname!="其他" && $("tr.opptid"+opptid).length>0){
					alert("已存在"+opptname+"的相关信息!");
					return;
				}
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"add_oppt","sellchanceid":<%=sellchanceid%>,"opptid":opptid,"opptname":filter(encodeURI(opptname)),"default1":filter(encodeURI("<%=otherinfo[3]%>")),"default2":filter(encodeURI("<%=otherinfo[4]%>"))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    var recd = txt.split("$")[0];
					    var _batchid = txt.split("$")[1];
					    var _opptid = $(obj).attr("_id");
					    var _opptname = $(obj).attr("_name");
					    var docstr = $(obj).find("div").html();

					    var trstr = "<tr class='oppttitle oppt"+_batchid+" opptid"+_opptid+"'>"
							+"<td class='oppttd'>"+_opptname;
					    if(_opptname=="其他"){
					    	trstr += "<input type='text' class='oppt_input input_blur' _index='5' _batchid='"+_batchid+"' value='"+otherinfomap.get("otherinfo5")+"'/>"
						}
					    trstr +="</td>"
							+"<td colspan='3'>"+docstr+"<div class='opptdel' onclick=delOppt('"+_batchid+"','"+_opptname+"') title='删除'></div></td>"
							+"</tr>";
					    
						$("#oppt_table").append(trstr).append(recd);
				    	setLastUpdate();
				    	//$("#logdiv").prepend(log);
					}
			    });
			}
			//删除友商信息
			function delOppt(batchid,opptname){
				if(confirm("确认删除友商信息？")){
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    data:{"operation":"del_oppt","sellchanceid":<%=sellchanceid%>,"batchid":batchid,"opptname":filter(encodeURI(opptname))}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    var txt = $.trim(data.responseText);
						    $("tr.oppt"+batchid).remove();
					    	setLastUpdate();
						}
				    });
				}
			}

			//输入框保存方法
			function doUpdate(obj,type){
				var fieldname = $(obj).attr("id");
				var fieldvalue = "";
				if(type==1){
					if($(obj).val()==tempval) return;
					fieldvalue = $(obj).val();
				}
				if(fieldname=="preyield"||fieldname=="probability"){
					if($(obj).val()-tempval==0) return;
					fieldvalue = $(obj).val();
				}
				if(fieldname=="subject"||fieldname=="preyield"||fieldname=="probability"||fieldname=="predate"){
					if($.trim(fieldvalue)==""){
						$(obj).val(tempval);
						return;
					}
				}
				if(fieldname=="description" && ($.trim(fieldvalue)==description || $.trim(fieldvalue)=="")){
					$(obj).val(description);
					$(obj).addClass("input_blur");
					if(tempval==description) return;
				}
				if(fieldname=="description" && tempval==description){ tempval = ""; }
				exeUpdate(fieldname,fieldvalue,"str");
			}
			//删除选择性内容
			function doDelItem(fieldname,fieldvalue,setid){
				var _fieldvalue = fieldvalue;
				var _setid = getVal(setid);
				if(fieldname!="fileids"&&fieldname!="fileids2"&&fieldname!="fileids3"&&setid==""){
					tempval = $("#"+fieldname+"_val").val();
					_fieldvalue = "0";
					$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
				}
				if(fieldname=="agent") _fieldvalue = "";
				var fieldtype = "num";
				if(fieldname=="agent") fieldtype = "str"; 
				if(fieldname=="fileids"||fieldname=="fileids2"||fieldname=="fileids3"||_setid!=""){
					 fieldtype = "del";
					 $("div.txtlink"+fieldvalue).find("div.btn_del").css("background","url('../images/loading2_wev8.gif') center no-repeat").unbind("click");
				} 
				exeUpdate(fieldname,_fieldvalue,fieldtype,'','',_setid);
			}
			//选择内容后执行更新
			function doSelectUpdate(fieldname,id,name){
				var addtxt = doTransName(fieldname,id,name);
				$("#"+fieldname).prev("div.txtlink").remove();
				$("#"+fieldname).before(addtxt);
				tempval = $("#"+fieldname+"_val").val();
				if(tempval==id) return;
				var fieldtype = "num";
				if(fieldname=="agent") fieldtype = "str"; 
				exeUpdate(fieldname,id,fieldtype);
			}
			//执行编辑
			function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue,setid){
				if(typeof(delvalue)=="undefined") delvalue = "";
				if(typeof(addvalue)=="undefined") addvalue = "";
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_sellchance_field","sellchanceid":<%=sellchanceid%>,"setid":setid,"fieldname":filter(encodeURI(fieldname)),"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
				    	if(fieldname=="fileids" || fieldname=="fileids2" || fieldname=="fileids3"){
				    		$("#td_"+fieldname).find(".txtlink").remove();
				    		$("#td_"+fieldname).prepend(txt);
					    }
					    if(setid!=""){
					    	$("#filetd_"+setid).find(".txtlink").remove();
							$("#filetd_"+setid).prepend($.trim(txt));
							if($.trim(txt)==""){
								$("#filetd_"+setid).prepend("<div class='txtlink input_blur' style='margin-right: 5px'><%=otherinfo[6] %></div>");
							}
							
						}
				    	if(fieldname=="selltype"||fieldname=="endtatusid"||fieldname=="sellstatusid"){
							window.location = "SellChanceView.jsp?id=<%=sellchanceid%>";
				    	}
				    	setLastUpdate();
				    	//$("#logdiv").prepend(log);
					}
			    });
			}
			function setLastUpdate(){
				var currentdate = new Date();
				//var datestr = currentdate.toLocaleString().replace('年','-').replace('月','-').replace('日','');
				datestr = currentdate.format("yyyy-MM-dd hh:mm:ss")
				//alert(currentdate.format("yyyy-MM-dd hh:mm:ss"));
				$("#lastupdate").html("最后修改人：<a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> &nbsp;&nbsp;&nbsp;&nbsp;最后修改时间："+datestr);

				var _left = Math.round(($(window).width()-$("#msg").width())/2);
				$("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
					$(this).fadeOut(800);
				});
			}
			function setSellType(value){
				var typestr = "";	
				if(value==1){
					$.post(
							"/CRM/sellchance/CheckType.jsp",
							{'customerId':<%=customerid%>,"sellchanceId":<%=sellchanceid%>}, 
							function(data){
								data=jQuery.trim(data);
								if(data=="false"){
									alert("此客户已存在进行中的新签销售机会！");
									return;
								}else{
									if(confirm("确定将商机类型更改为新签?")){
										tempval = "<%=selltype%>";
										exeUpdate("selltype",value,"num");
									}
								}
							}
					);
				}else if(value==2){
					if(confirm("确定将商机类型更改为二次?")){
						tempval = "<%=selltype%>";
						exeUpdate("selltype",value,"num");
					}
				}
				
			}
			function setEndStatus(value){
				var typestr = "";	
				if(value==0){
					typestr = "进行中";
				}else if(value==1){
					typestr = "成功";
				}else if(value==2){
					typestr = "失败";
				}
				if((value==1||value==2) && $("#td_fileids2").find("div.txtlink").length==0){
					alert("请上传商机复盘文件!");
					return;
				}
				if(confirm("确定将商机状态更改为"+typestr+"?")){
					tempval = "<%=endtatusid%>";
					exeUpdate("endtatusid",value,"num");
				}
			}
			//调整商机阶段
			function setSellStatus(value,title){
				<%if(selltype.equals("1")){%>
						var _val = parseInt(value);
						if(_val>1){
							if($("#apply_table").find("textarea.input_blur").length==$("#apply_table").find("textarea").length){
								alert("请填写客户方关键需求分析！");
								return;
							}
							if($("#match_table").find("textarea.input_blur").length==$("#match_table").find("textarea").length){
								alert("请填写我方的竞争优劣势分析！");
								return;
							}
							if($("#oppt_table").find("textarea.input_blur").length==$("#oppt_table").find("textarea").length){
								alert("请填写友商的竞争优劣势分析！");
								return;
							}
							if($("#info_table").find("textarea.input_blur").length==$("#info_table").find("textarea").length){
								alert("请填写客户方信息化情况！");
								return;
							}
							//if($("#res_table").find("textarea.input_blur").length==$("#res_table").find("textarea").length){
							//	alert("请填写外围资源关系情况！");
							//	return;
							//}
						}
						//检测向导人是否关联
						if(_val>2){
							if($($("#reltable").find("tr")[2]).find("a").length==0){
								alert("请填写<%=titles[2]%>！");
								return;
							}
							//var att = $($($("#reltable").find("tr")[2]).find("td")[7]).html();
							//if($.trim(att)!="支持我方"){
							//	alert("请确认<%=titles[2]%>已支持我方！");
							//	return;
							//}
						}
						//检测决策人是否关联
						if(_val>3){
							if($($("#reltable").find("tr")[0]).find("a").length==0){
								alert("请填写<%=titles[0]%>！");
								return;
							}
							//var att = $($($("#reltable").find("tr")[0]).find("td")[7]).html();
							//if($.trim(att)!="支持我方"){
							//	alert("请确认<%=titles[0]%>已支持我方！");
							//	return;
							//}
						}
						//检测高层是否关联
						if(_val>4){
							if($($("#reltable").find("tr")[1]).find("a").length==0){
								alert("请填写<%=titles[1]%>！");
								return;
							}
							//var att = $($($("#reltable").find("tr")[1]).find("td")[7]).html();
							//if($.trim(att)!="支持我方"){
							//	alert("请确认<%=titles[1]%>已支持我方！");
							//	return;
							//}
						}
						//检测标书合同是否关联
						if(_val>5){
							if($("#td_fileids3").find("div.txtlink").length==0){
								alert("请上传客户报价书或者合同书！");
								return;
							}
						}
				<%}%>
				if(confirm("确定将商机阶段更改为"+title+"?")){
					tempval = "";
					exeUpdate("sellstatusid",value,"num");
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

			function checkval(){
				var _val = $("#probability").val();
				if(parseInt(_val)>100 || parseInt(_val)<0){
					$("#probability").val("");
				}
			}

			//明细输入框保存方法
			function doUpdateDetail(obj){
				var fieldvalue = $(obj).val();
				_reltitle = $(obj).attr("_item");
				if(fieldvalue==tempval) return;
				if($(obj).hasClass("ployinput") && ($.trim(fieldvalue)=="应对策略" || $.trim(fieldvalue)=="")){
					$(obj).val("应对策略");
					$(obj).addClass("input_blur");
					if(tempval=="应对策略") return;
				}
				var _oldvalue = tempval;
				if($(obj).hasClass("ployinput") && $.trim(_oldvalue)=="应对策略"){
					_oldvalue = "";
				}
				
				var _type = $(obj).attr("_type");
				var _relid = $(obj).attr("_relid");
				var _batchid = getVal($(obj).attr("_batchid"));
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_sellchance_detail","relid":_relid,"batchid":_batchid,"reltitle":filter(encodeURI(_reltitle)),"sellchanceid":<%=sellchanceid%>,"type":_type,"oldvalue":filter(encodeURI(_oldvalue)),"newvalue":filter(encodeURI(fieldvalue))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	if($(obj).hasClass("ployinput")){
				    		$(obj).parent().attr("title","应对策略:"+$(obj).val());
					    }
					    var txt = $.trim(data.responseText);
					    var log = txt;
				    	setLastUpdate();
					}
			    });
			}
			//其他信息输入框保存方法
			function doUpdateOther(obj){
				var fieldvalue = $(obj).val();
				if(fieldvalue==tempval) return;
				var _setid = $(obj).attr("_setid");
				var _type = $(obj).attr("_type");
				var _item = $(obj).attr("_item");
				var _index = $(obj).attr("_index");
				var _batchid = getVal($(obj).attr("_batchid"));
				var _oldvalue = tempval;
				if($.trim(fieldvalue)=="" && tempval!=otherinfomap.get("otherinfo"+_index)){
					$(obj).val(tempval);
					return;
				}
				if($.trim(fieldvalue)==otherinfomap.get("otherinfo"+_index) || $.trim(fieldvalue)==""){
					$(obj).val(otherinfomap.get("otherinfo"+_index));
					$(obj).addClass("input_blur");
					if(tempval==otherinfomap.get("otherinfo"+_index)) return;
				}
				if(_oldvalue == otherinfomap.get("otherinfo"+_index)){
					_oldvalue = "";
				}
				
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_sellchance_other","setid":_setid,"batchid":_batchid,"index":_index,"sellchanceid":<%=sellchanceid%>,"type":_type,"item":filter(encodeURI(_item)),"oldvalue":filter(encodeURI(_oldvalue)),"newvalue":filter(encodeURI(fieldvalue))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    var log = txt;
				    	setLastUpdate();
					}
			    });
			}
			//友商名称输入框保存方法
			function doUpdateOpptname(obj){
				var fieldvalue = $(obj).val();
				if(fieldvalue==tempval) return;
				var _batchid = $(obj).attr("_batchid");
				var _index = $(obj).attr("_index");
				if($.trim(fieldvalue)==otherinfomap.get("otherinfo"+_index) || $.trim(fieldvalue)==""){
					$(obj).val(otherinfomap.get("otherinfo"+_index));
					$(obj).addClass("input_blur");
					if(tempval==otherinfomap.get("otherinfo"+_index)) return;
				}
				var _oldvalue = tempval;
				if(_oldvalue == otherinfomap.get("otherinfo"+_index)){
					_oldvalue = "";
				}
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_opptname","batchid":_batchid,"sellchanceid":<%=sellchanceid%>,"oldvalue":filter(encodeURI(_oldvalue)),"newvalue":filter(encodeURI(fieldvalue))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    var log = txt;
				    	setLastUpdate();
					}
			    });
			}
			function onShowAgent(fieldname) {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)");
			    if (datas) {
				    if(datas.id!=""){
					    doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			function onShowResource(fieldname) {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
			    if (datas) {
			    	if(datas.id!=""){
			    		doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			function onShowSource(fieldname) {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp");
			    if (datas) {
				    if(datas.id!=""){
				    	doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			function onShowContacter(relid,reltitle) {
				cancelAddContacter();
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactBrowser.jsp?customer=<%=CustomerInfoComInfo.getCustomerInfoname(customerid)%>");
			    if (datas) {
				    if(datas.id!=""){
				    	executeContacterRel(relid,reltitle,datas.id);
					}
			    }
			    $("#div.btn_browser2").hide();
			    $("#div.btn_add2").hide();
			}
			function executeContacterRel(relid,reltitle,contacterid){
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"add_contacter_rel","sellchanceid":<%=sellchanceid%>,"relid":relid,"reltitle":filter(encodeURI(reltitle)),"contacterid":contacterid}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    var log = txt;
				    	log = txt.split("$")[0];
				    	$("#operate_"+relid).nextAll("td.info").remove();
				    	$("#operate_"+relid).after(log);
				    	setLastUpdate();
				    	//$("#logdiv").prepend(log);
					}
			    });
			}
			var _relid = "";
			var _reltitle = "";
			function onAddContacter(relid,reltitle){
				_relid = relid;
				_reltitle = reltitle;
				//$("#transbg").show();
				var _left = $("#operate_"+relid).offset().left+125;
				var _top = $("#operate_"+relid).offset().top;
				var _width = $("#reltable").width()-125;
				$("#addContacter").css({"top":_top,"left":_left}).width(_width).show();
			}
			function saveContacter(){
				if($("#Title").val()=="" || $("#Title").val()== relinfomap.get("Title") 
						|| $("#FirstName").val()=="" || $("#FirstName").val()==relinfomap.get("FirstName") 
						|| $("#JobTitle").val()=="" || $("#JobTitle").val()==relinfomap.get("JobTitle") ){
					alert("必要信息不完整!");
					return;
				}
				if($("#textfield1").val()== relinfomap.get("textfield1")) $("#textfield1").val("");
				if($("#Mobile").val()== relinfomap.get("Mobile")) $("#Mobile").val("");
				if($("#attention").val()== relinfomap.get("attention")) $("#attention").val("");
				$("#contact_load").show();
				$("div.btn_save").hide();
				$("#quickaddform").submit();
			}
			function cancelAddContacter(){
				$("#contact_load").hide();
				$("div.btn_save").show();
				$("#addContacter").hide();
				$("#quickreset").click();

				$("#addtable").find("input.info_input").each(function(){
					$(this).addClass("input_blur").val(relinfomap.get(this.id));
				});
				$("#Title").val("");
				$("#TitleSpan").html("<font class='input_blur'>"+relinfomap.get("Title")+"</font><img src='/images/BacoError_wev8.gif' align=absMiddle />");
				_relid = "";
				_reltitle = "";
			}
			function quickcomplete(contacterId){
				$("#contact_load").hide();
				executeContacterRel(_relid,_reltitle,contacterId);
				cancelAddContacter();
			}
			function onShowContacterTitle(inputid,spanid) {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp");
			    if (datas) {
			    	if(datas.id!="" && datas.id!="0"){
				    	$("#"+inputid).val(datas.id);
				    	$("#"+spanid).html(datas.name);
			    	}else{
			    		$("#"+inputid).val("");
				    	$("#"+spanid).html("<font class='input_blur'>"+relinfomap.get("Title")+"</font><img src='/images/BacoError_wev8.gif' align=absMiddle />");
				    }
			    }
			}
			function doAddProduct(){
				$("#product_add").show();
			}
			function delProduct(redid,obj){
				if(redid==""){
					$("#product_add").hide();
				}else{
					if(confirm("确定删除产品明细？")){
						var newvalue = $("#productidSpan_"+redid).find("a").html();
						$(obj).css("background","url('../images/loading2_wev8.gif') center no-repeat").unbind("click");
						$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    data:{"operation":"del_product_detail","sellchanceid":<%=sellchanceid%>
				    			,"redid":redid,"newvalue":filter(encodeURI(newvalue))
					    	}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){ 
							    var txt = $.trim(data.responseText);
							    $("#product_"+redid).remove();
						    	setLastUpdate();
							}
					    });
					}
				}
			}
			
			function onShowProduct(redid){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp");
			    if (datas) {
			    	if(datas.id!="" && datas.id!="0"){
				    	var salenum = "1";
				    	var oldname = "";
				    	if(redid!=""){
				    		$("#productid_"+redid).val(datas.id);
					    	$("#productidSpan_"+redid).html("<a href='/lgc/asset/LgcAsset.jsp?paraid="+datas.id+"' target='_blank'>"+$.trim(datas.name)+"</a>");
					    	$("#assetunitid_"+redid).val(datas.other1);
					    	$("#assetunitidSpan_"+redid).html(datas.other2);
					    	$("#currencyid_"+redid).val(datas.other3);
					    	$("#currencyidSpan_"+redid).html(datas.other4);
					    	$("#salesprice_"+redid).val(datas.other5);
					    	var salesprice = eval(toFloat(datas.other5,0));
					    	salenum = eval(toFloat($("#salesnum_"+redid).val(),0));
					        var totelprice = toFloat(salesprice) * toFloat(salenum);
					    	$("#totelprice_"+redid).html(toPrecision(totelprice,4));
					    	oldname = $("#productidSpan_"+redid).find("a").html();
					    }

				    	$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    data:{"operation":"edit_product_detail","sellchanceid":<%=sellchanceid%>
				    			,"redid":redid
				    			,"productid":datas.id,"assetunitid":datas.other1,"currencyid":datas.other3,"salesprice":datas.other5,"salesnum":salenum
				    			,"oldvalue":filter(encodeURI(oldname)),"newvalue":filter(encodeURI($.trim(datas.name)))
					    	}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){ 
							    var txt = $.trim(data.responseText);
							    if(redid==""){
							    	$("#product_add").before(txt).hide();
								}
						    	setLastUpdate();
							}
					    });
			    	}
			    }
			}
			function onShowCurrency(redid){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp");
			    if (datas) {
			    	if(datas.id!="" && datas.id!="0"){
					    if($("#currencyid_"+redid).val()!=datas.id){
					    	tempval = $("#currencyidSpan_"+redid).html();
					    	$("#currencyid_"+redid).val(datas.id);
						    $("#currencyidSpan_"+redid).html(datas.name);
					    	doUpdatePro(fieldname,datas.id,redid,datas.name);
						}
			    	}
			    }
			}
			function doUpdatePro(fieldname,fieldvalue,redid,newvalue,totalvalue){
				var _totalvalue = getVal(totalvalue);
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_product_field","sellchanceid":<%=sellchanceid%>
		    			,"redid":redid
		    			,"fieldname":fieldname,"fieldvalue":fieldvalue,"totalvalue":_totalvalue
		    			,"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(newvalue))
			    	}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	setLastUpdate();
					}
			    });
			}
			function mailValid() {
				var emailStr = jQuery("#CEmail").val();
				emailStr = emailStr.replace(" ","");
				if (!checkEmail(emailStr)) {
					alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
					jQuery("#CEmail").focus();
					return;
				}
			}
					
			function doTransName(fieldname,id,name){
				var delname = fieldname;
				if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
				var restr = "";
				restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
				restr += "<div style='float: left;'>";
					
				if(fieldname=="manager"){
					restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
				}else if(fieldname=="agent"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
				}else if(fieldname=="source"){
					restr += name;
				}
				
				restr +="</div>";
				if(fieldname=="source"||fieldname=="agent")
				restr += "<div class='btn_del' onclick=\"doDelItem('"+delname+"','"+id+"')\"></div>"
					   + "<div class='btn_wh'></div>";
				restr += "</div>";
				return restr;
			}
			<%}%>
		</script>
	</body>
</html>
<%if(canedit){ %>
<%@ include file="/CRM/sellchance/manage/util/uploader.jsp" %>
<%}%>