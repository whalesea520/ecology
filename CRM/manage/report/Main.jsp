
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<%
	boolean hassub = false;
	rs.executeSql("select count(id) from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID());
	int ismanager = 0;
	if(rs.next() && rs.getInt(1)>0){
		hassub = true;
		ismanager = 1;
	}
	
	//session中存储的查看人员id
	String viewuserid = (String)request.getSession().getAttribute("CRM_MAIN_USERID");
	if("null".equals(viewuserid) || viewuserid == null) viewuserid = "";
	if(!viewuserid.equals("") && !ResourceComInfo.isManager(user.getUID(),viewuserid)){
		viewuserid = "";
	}
	String viewusername = ResourceComInfo.getLastname(viewuserid);
	int viewismanager = 0;
	if(!viewuserid.equals("")){
		rs.executeSql("select count(id) from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + viewuserid);
		if(rs.next() && rs.getInt(1)>0){
			viewismanager = 1;
		}
	}
	
	String year = TimeUtil.getCurrentDateString().substring(0,4);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>统计报表</title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/> 
		<script language="javascript" src="../js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.core_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.widget_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.datepicker_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<script language="javascript" src="/sellportal/js/highcharts.src_wev8.js"></script>
		<link type='text/css' rel="stylesheet" href="../css/ui/jquery.ui.all_wev8.css" />
		
		<link type='text/css' rel='stylesheet'  href='/tree/js/treeviewAsync/eui.tree_wev8.css'/>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview_wev8.js'></script>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
		
		<link type='text/css' rel="stylesheet" href="../css/Main_wev8.css" />
		<style type="text/css">
			<%if(hassub){ %>
				.cond_txt{right:33px;left:auto;}
			<%}%>
			*{font-family: '微软雅黑' !important;;}
			
			.disinput{line-height: 28px !important;height: 28px !important;}
			
			.reporttable,.listtable{width: 100%;background: #C4D0DC;table-layout: fixed;border-collapse: collapse;}
			.reporttable td{height:24px;background: #FAFBFC;text-align: center;border: 1px #C0D0E0 solid;}
			.reporttable td.title{font-weight: bold;border-right: 0px;}
			.reporttable td.current{background: #D7E1EC;}
			.title1{width: 100%;padding-left:0px;line-height: 30px;height: 30px;background: #C9D5E0;font-size: 14px;margin-top: 0px;margin-bottom: 0px;font-weight: bold;}
			.mini_title{line-height: 30px;font-size: 14px;margin-left: 5px;margin-right: 5px;float: left;}
			.mini_tab,.main_tab{width:60px;line-height:30px;cursor:pointer;font-weight: normal;color: #575757;float: left;margin-left: 5px;text-align: center;}
			.mini_tab_click,.main_tab_click{font-weight:bold !important;background: #DFDFDF;}
			
			.mini_btn{width: 40px;line-height: 24px;background: #BACAD8;color: #666666;text-align: center;margin-top: 3px;float: left;margin-right: 2px;cursor: pointer;}
			.mini_btn_click{background: #7795B0;color: #000;}
			
			.listtable td{height:24px;background: #FAFBFC;text-align: center;border: 1px #C0D0E0 solid;padding-left: 2px;}
			.listtable td div{line-height: 24px;float: left;width: 20%;text-align: left;color: #666666;empty-cells:show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;}
			.listtable td div.listplace{width: 8%;color: #E14A4C;font-weight: bold;text-align: center;}
			.listtable a,.listtable a:active,.listtable a:visited{text-decoration: none;color: #666666;}
			.listtable a:hover{text-decoration: none;color: #0080C0;}
			
			.detaillist{width: 100%;table-layout: fixed;border-collapse: collapse;}
			.detaillist td{line-height:24px;padding-left: 2px;color: #9D9D9D}
			.detaillist tr.hover td{background: #F0F0F0;}
			.detaillist td,.detaillist td div,.detaillist td font{line-height: 24px;color: #666666;empty-cells:show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;}
			
			.leftmenu2 {
				width: 100%;
				height: 26px;
				margin-top: 0px;
				position: relative;
				color: #AAAAAA;
			}
			.toptitle1,.toptitle2{width: 40px;}
			
			.cond_type,.cond_status {width: 100%;background: #fff;}
			.cond_type td,.cond_status td {background: #FBFBFF;line-height: 20px;cursor: pointer;}
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
					<div class="toptitle2" _url="/CRM/manage/Index.jsp?maintype=1&<%=System.currentTimeMillis() %>"
						style="border-right: 1px #A6A6A6 solid;margin-left: 10px;">客户</div>
					<div class="toptitle2" _url="/CRM/manage/Index.jsp?maintype=2&<%=System.currentTimeMillis() %>"
						style="border-left: 1px #FFFFFF solid;border-right: 1px #A6A6A6 solid;">伙伴</div>
					<div class="toptitle2" _url="/CRM/manage/Index.jsp?maintype=5&<%=System.currentTimeMillis() %>"
						style="border-left: 1px #FFFFFF solid;border-right: 1px #A6A6A6 solid;">人脉</div>
					<div class="toptitle2" _url="/CRM/manage/Index.jsp?maintype=3&<%=System.currentTimeMillis() %>" 
						style="border-left: 1px #FFFFFF solid;border-right: 1px #A6A6A6 solid;">商机</div>
					<div class="toptitle1" style="border-left: 1px #FFFFFF solid;">报表</div>
					<div id="showbtn" class="showbtn" onclick="setlayout()" title="展开" _status="0"></div>
				</div>
				<!-- search -->
				<div style="width: 225px;height: 26px;;margin-top: 5px;margin-bottom: 10px;margin-left: 13px;position: relative;">
					<label for="objname" class="overlabel">按下属人员搜索</label>
					<input type="text" id="objname" name="objname" class="input_inner" />
				</div>
				
				<div class="lefttitle lefttitle_select" style="">
					<%if(hassub){%><div id="sub" class="leftitem" _index="2">下属</div><%}%>
					<div id="subtitle" class="leftitem leftitem_click" style="margin-left: 57px;margin-right: 0px;<%if(!hassub){%>float: right;<%}%>"></div>
					<div id="mine" class="leftitem leftitem_click" _index="1" style="<%if(hassub){%>float: right;margin-left: 0px;<%}%>cursor: pointer;" onclick="doClick(<%=user.getUID() %>,4,null,'')">
						本人<%if(hassub){%>(含下属)<%}%>
					</div>
				</div>
				<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
					<%if(hassub){ %><colgroup><col width="37%"/><col width="63%"/></colgroup><%} %>
					<tr>
						<%if(hassub){ %>
						<td valign="top" style="border-right: 1px #A6A6A6 solid;">
							<div id="itemdiv2" class="itemdiv scroll2" style="width: 100%;height: 100%;overflow-y: auto;overflow-x: hidden;padding-bottom: 0px;position: relative;">
								<div id="itemdiv2inner" style="width: auto;height: 100%;position: relative;">
								</div>
							</div>
						</td>
						<%} %>
						<td valign="top" style="border-left: 1px #fff solid;">
							<div id="condiv" class="scroll2" style="width: 100%;overflow-y: auto;overflow-x: hidden;position: relative;">
								<div id="itemdiv1" class="itemdiv" style="width: auto;height: 100%;position: relative;">
									<div id="leftmine" class="leftmenu" _datatype="0" _reporttype="1">
										<div class="cond_txt" title="我的商机按月统计">商机按月统计</div>
										<div id="icon1_1" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu menuall" _datatype="0" _reporttype="2">
										<div class="cond_txt" title="我的客户跟进统计">客户按月统计</div>
										<div id="icon1_2" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu menuall" _datatype="0" _reporttype="11">
										<div class="cond_txt" title="我的人脉跟进统计">人脉按月统计</div>
										<div id="icon1_2" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu menuall" _datatype="0" _reporttype="3">
										<div class="cond_txt" title="我的全部客户分析">全部客户分析</div>
										<div id="icon1_3" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu menuall" _datatype="0" _reporttype="10">
										<div class="cond_txt" title="我的客户数量分析">客户数量分析</div>
										<div id="icon1_10" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu menuall" _datatype="0" _reporttype="4">
										<div class="cond_txt" title="我的伙伴数量分析">伙伴数量分析</div>
										<div id="icon1_4" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu menuall" _datatype="0" _reporttype="5">
										<div class="cond_txt" title="我的人脉数量分析">人脉数量分析</div>
										<div id="icon1_5" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu menuall" _datatype="0" _reporttype="6">
										<div class="cond_txt" title="我的商机数量分析">商机数量分析</div>
										<div id="icon1_6" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu2 menuall" _datatype="0" _reporttype="7">
										<div class="cond_txt" title="我的销售合同额">销售合同额</div>
										<div id="icon1_7" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu2 menuall" _datatype="0" _reporttype="8">
										<div class="cond_txt" title="我的有效回款额">有效回款额</div>
										<div id="icon1_8" class="cond_icon cond_icon10"></div>
									</div>
									<div class="leftmenu2 menuall" _datatype="0" _reporttype="9">
										<div class="cond_txt" title="我的费用成本">费用成本</div>
										<div id="icon1_9" class="cond_icon cond_icon10"></div>
									</div>
								</div>
							</div>
						</td>
					</tr>
				</table>
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
						<div style="width: auto;line-height: 22px;position: absolute;right: 10px;top: 8px;z-index:1001;font-family: 微软雅黑">
							<div id="stat" style="width: auto;line-height: 22px;float: right;font-family: 微软雅黑"></div>
							<div id="subdiv" style="width: auto;line-height: 22px;float: right;font-family: 微软雅黑;margin-right: 10px;<%if(ismanager==0){ %>display:none<%}%>">
								[<font class="subtab subtab_click" _index="0">含下属</font>|<font class="subtab" _index="1">仅本人</font>|<font class="subtab" _index="2">仅下属</font>]
							</div>
						</div>
					</div>
					<div style="width: 100%;height: 26px;background: url('../images/title_bg_01_wev8.png') repeat-x;position: relative;">
						<div id="conddiv" style="position: absolute;left: 0px;top: 0px;bottom: 0px;overflow: hidden;background: url('../images/title_bg_01_wev8.png') repeat-x;">
							<div style="float: left;width: 50px;text-align: center;line-height: 26px;font-weight: bold;">年份</div>
							<div id="changebtn1" style="width: 70px;border-right: 1px #E4E4E4 solid;" class="main_btn" onclick="showChange(1,this)" title="统计年份 <%=TimeUtil.getCurrentDateString().substring(0,4) %>" _show="统计年份">
								<%=TimeUtil.getCurrentDateString().substring(0,4) %>
							</div>
							
							<div class="selectstatus" style="float: left;width: 50px;text-align: center;line-height: 26px;font-weight: bold;">状态</div>
							<div id="changebtn3" style="width: 70px;border-right: 1px #E4E4E4 solid;" class="main_btn selectstatus" onclick="showChange(3,this)" title="" _show="商机状态">
								全部
							</div>
							
							<div class="selectstatus" style="float: left;width: 50px;text-align: center;line-height: 26px;font-weight: bold;">纬度</div>
							<div id="changebtn4" style="width: 70px;border-right: 1px #E4E4E4 solid;" class="main_btn selectstatus" onclick="showChange(4,this)" title="" _show="商机状态">
								创建时间
							</div>
							
							<div class="selectstatus" style="float: left;width: 50px;text-align: center;line-height: 26px;font-weight: bold;">联系</div>
							<div id="changebtn5" style="width: 70px;border-right: 1px #E4E4E4 solid;" class="main_btn selectstatus" onclick="showChange(5,this)" title="" _show="">
								全部
							</div>
							<div class="selectstatus" style="float: left;width: auto;z-index: 100;cursor: pointer;">
								<input id="contactdate" type="text" readonly="readonly" style="width: 70px;height:18px;line-height: 18px;padding-left: 20px;padding-top: 1px;margin-top:4px;margin-left:2px;
									border: 0px;font-family:'微软雅黑';background:none;color:#3A3A3A;cursor: pointer;background: url('/images/collapse-all_wev8.gif') left top no-repeat" value="" title="自定义联系或未联系日期"/>
							</div>
							
							<div class="selectcrm" style="float: left;width: 50px;text-align: center;line-height: 26px;font-weight: bold;">类型</div>
							<div id="changebtn6" style="width: 70px;border-right: 1px #E4E4E4 solid;" class="main_btn selectcrm" onclick="showChange(6,this)" title="" _show="">
								全部
							</div>
							<div class="selectcrm" style="float: left;width: 50px;text-align: center;line-height: 26px;font-weight: bold;">状态</div>
							<div id="changebtn7" style="width: 70px;border-right: 1px #E4E4E4 solid;" class="main_btn selectcrm" onclick="showChange(7,this)" title="" _show="">
								全部
							</div>
						</div>
						
						<div id="conddiv2" style="position: absolute;left: 0px;top: 0px;bottom: 0px;overflow: hidden;background: url('../images/title_bg_01_wev8.png') repeat-x;display: none;">
							<div style="float: left;width: 50px;text-align: center;line-height: 26px;font-weight: bold;">年月</div>
							<div id="changebtn2" style="width: 100px;border-right: 1px #E4E4E4 solid;" class="main_btn" onclick="showChange(2,this)" title="" _show="">
								全部
							</div>
							<div style="float: left;width: auto;z-index: 100;cursor: pointer;">
								<input id="sdate1" type="text" readonly="readonly" style="width: 70px;height:18px;line-height: 18px;padding-left: 20px;padding-top: 1px;margin-top:4px;margin-left:2px;
									border: 0px;font-family:'微软雅黑';background:none;color:#3A3A3A;cursor: pointer;background: url('/images/collapse-all_wev8.gif') left top no-repeat" value="" title="自定义统计开始日期"/>
								<input id="sdate2" type="text" readonly="readonly" style="width: 70px;height:18px;line-height: 18px;padding-left: 20px;padding-top: 1px;margin-top:4px;margin-left:2px;
									border: 0px;font-family:'微软雅黑';background:none;color:#3A3A3A;cursor: pointer;background: url('/images/collapse-all_wev8.gif') left top no-repeat" value="" title="自定义统计结束日期"/>	
							</div>
						</div>
						
						<div id="btnrefresh" style="width: 18px;height: 100%;background: url('../images/icon_refresh_wev8.png') center no-repeat;cursor: pointer;float: right;margin-right: 4px;"
							onclick="loadList()" title="刷新"></div>
					</div>
					<div id="changecond1" class="div_cond" style="width: 69px;">
						<div class="btn_add_type" onclick="doChange(this,1,2010)">2010</div>
						<div class="btn_add_type" onclick="doChange(this,1,2011)">2011</div>
						<div class="btn_add_type" onclick="doChange(this,1,2012)">2012</div>
						<div class="btn_add_type" onclick="doChange(this,1,2013)">2013</div>
						<div class="btn_add_type" onclick="doChange(this,1,2014)">2014</div>
						<div class="btn_add_type" onclick="doChange(this,1,2015)">2015</div>
						<div class="btn_add_type" onclick="doChange(this,1,2016)">2016</div>
						<div class="btn_add_type" onclick="doChange(this,1,2017)">2017</div>
						<div class="btn_add_type" onclick="doChange(this,1,2018)">2018</div>
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
							<tr>
								<td>
									<div id="confirmym" style="width: 100%;height: 18px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D;">确定</div>
								</td>
								<td>
									<div id="clearym" style="width: 100%;height: 18px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D;">全部</div>
								</td>
							</tr>
						</table>
					</div>
					<div id="changecond3" class="div_cond" style="width: 69px;">
						<div class="btn_add_type" onclick="doChange(this,3,4)">培育</div>
						<div class="btn_add_type" onclick="doChange(this,3,0)">紧跟</div>
						<div class="btn_add_type" onclick="doChange(this,3,1)">成功</div>
						<div class="btn_add_type" onclick="doChange(this,3,2)">失败</div>
						<div class="btn_add_type" onclick="doChange(this,3,3)">暂停</div>
						<div class="btn_add_type" onclick="doChange(this,3,-1)">全部</div>
					</div>
					<div id="changecond4" class="div_cond" style="width: 69px;">
						<div class="btn_add_type" onclick="doChange(this,4,1)">创建时间</div>
						<div class="btn_add_type" onclick="doChange(this,4,2)">结案时间</div>
					</div>
					<div id="changecond5" class="div_cond" style="width: 69px;">
						<div class="btn_add_type" onclick="doChange(this,5,1)">未联系</div>
						<div class="btn_add_type" onclick="doChange(this,5,2)">已联系</div>
						<div class="btn_add_type" onclick="doChange(this,5,-1)">全部</div>
					</div>
					<div id="changecond6" class="div_cond" style="width: 240px;">
						<table class="cond_type" cellpadding="0" cellspacing="1" border="0">
						<%
					     int index=0;
						 CustomerTypeComInfo.setTofirstRow();
						 while(CustomerTypeComInfo.next()){
						%>
						<%if(index%2==0){ %><tr><%} %>
								<td _val="<%=CustomerTypeComInfo.getCustomerTypeid() %>"><%=CustomerTypeComInfo.getCustomerTypename() %></td>
						<%if(index%2!=0){ %></tr><%} %>
						<%index++;} %>
						<%if(index%2==0){ %></tr><%} %>
						</table>
						<table style="width: 100%;background: #ECECFF;" cellpadding="0" cellspacing="1" border="0">
							<tr>
								<td>
									<div id="confirmtype" style="width: 100%;height: 18px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D;">确定</div>
								</td>
								<td>
									<div id="cleartype" style="width: 100%;height: 18px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D;">全部</div>
								</td>
							</tr>
						</table>
					</div>
					<div id="changecond7" class="div_cond" style="width: 240px;">
						<table class="cond_status" cellpadding="0" cellspacing="1" border="0">
						<%index=0;
						 CustomerStatusComInfo.setTofirstRow();
						 while(CustomerStatusComInfo.next()){
						%>
						<%if(index%2==0){ %><tr><%} %>
							<td _val="<%=CustomerStatusComInfo.getCustomerStatusid() %>"><%=CustomerStatusComInfo.getCustomerStatusname() %></td>
						<%if(index%2!=0){ %></tr><%} %>
						<%index++;} %>
						<%if(index%2==0){ %></tr><%} %>
						</table>
						<table style="width: 100%;background: #ECECFF;" cellpadding="0" cellspacing="1" border="0">
							<tr>
								<td>
									<div id="confirmstatus" style="width: 100%;height: 18px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D;">确定</div>
								</td>
								<td>
									<div id="clearstatus" style="width: 100%;height: 18px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D;">全部</div>
								</td>
							</tr>
						</table>
					</div>
					
					<div id="listview" class="scroll1" style="position: absolute;top: 66px;bottom: 0px;left: 0px;right: 0px;overflow-x: hidden;">
						
					</div>
					<div id="listload" style='position: absolute;top: 66px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp_wev8.png) repeat;' align='center'>
						<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1_wev8.gif) center no-repeat'></div>
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
			
			<div id="show" style="width:450px;height:auto;position: absolute;top: 11px;right: 10px;bottom: 1px;z-index: 10000;display: none;background: #fff;
				border-left: 1px #BFC5CC solid;">
				<iframe id="showframe" style="width: 100%;height: 100%;" frameborder="0"></iframe>
			</div>
		</div>
		<div id="checknew"></div>
		<!-- 提示信息 -->
		<div id="msg" style="position: absolute;width: 270px;line-height: 30px;text-align:center;left:100px;top:50px;background:#FBFDFF;color:#808080;font-size:14px;font-family:'微软雅黑';display:none;
			border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;
			border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;z-index: 10000">操作成功！</div>
		<script type="text/javascript">
			var dounload = 1;
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			var newMap = new Map();
			var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp_wev8.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1_wev8.gif) center no-repeat'></div></div>";

			var creater = "<%=user.getUID()+""%>";//人员id
			var reporttype = 1;
			var viewtype = 1;
			var datatype = "";
			var _ismanager = <%=ismanager%>;
			var subtype = 0;
			var year = "<%=TimeUtil.getCurrentDateString().substring(0,4) %>";
			var userid = "<%=user.getUID()%>";
			
			var cc = null;

			var init = 1;

			var syear = "";
			var smonth = "";
			var sdate1 = "";
			var sdate2 = "";
			var sellstatus = "";
			var selllat = "";
			var sellcontact = "";
			var contactdate = "";
			var crmtype = "";
			var crmstatus = "";

			var titles = null;
			var titles3 = null;
			var chart = null;
			var detailtype = null;
			var stattype = 1;
			var ordertype = 1;
			var showall = 0;
			var ym = null;

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
				$("div.toptitle2").bind("click",function(){
					dounload = 0;
					var _url = $(this).attr("_url");
					window.location = _url;
				});

				//组织结构树初始化
				/**
				$("#itemdiv3").addClass("hrmOrg"); 
			    $("#itemdiv3").treeview({
			    	url:"/tree/hrmOrgTree.jsp"
			    });*/
			    <%if(hassub){%>
			  	//下属人员树初始化
			    $("#itemdiv2").addClass("hrmOrg"); 
			    $("#itemdiv2inner").treeview({
			        url:"/tree/hrmOrgTree.jsp",
			        root:"hrm|<%=user.getUID()%>"
			    });
			    <%}%>

			    $(".subtab").bind("click",function(){
			    	$(".subtab").removeClass("subtab_click");
					$(this).addClass("subtab_click");
					subtype = $(this).attr("_index");
					loadList();
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
					$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
					$(this).addClass("leftmenu_select");
					reporttype = getVal($(this).attr("_reporttype"));
					viewtype = 1;
					keyname = "";
					
					datatype = $(this).attr("_datatype");
					
					if(reporttype==1 || reporttype==2 || reporttype==11){
						$("#conddiv").show();
						$("#conddiv2").hide();
					}else{
						$("#conddiv").hide();
						$("#conddiv2").show();
					}

					if(reporttype==1){
						$("div.selectstatus").show();
						$("div.selectcrm").hide();
					}else if(reporttype==2){
						$("div.selectstatus").hide();
						$("div.selectcrm").show();
					}else{
						$("div.selectstatus").hide();
						$("div.selectcrm").hide();
					}

					if(_ismanager==1){
						$("#subdiv").show();
						$(".subtab").removeClass("subtab_click");
						$(".subtab:first").addClass("subtab_click");
					}else{
						$("#subdiv").hide();
					}
					
					subtype = 0;
					
					var mtitle = $($(this).find("div")[0]).attr("title");
					$("#mtitle").html(mtitle);
					$("#micon").css("background","url('../images/title_icon_"+datatype+".png') no-repeat");
					loadList();
					loadDetail(year);

					closeDetail();
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
					url:"/CRM/manage/util/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:'subhrm',
					divwidth: 200,
					updatename:'objname',
					updatetype:''
				});

				$("label.overlabel").overlabel();

				$("#objname").blur(function(e){
					$(this).val("");
					$("label.overlabel").css("text-indent",0);
				});

				//树形搜索中点击直接展开搜索并展开下属
				$("span.file,span.folder").live("click",function() {
					/**var a = $(this).children("a")[0];
					var click = $(a).attr("onclick");
					click = click.substring(0,click.indexOf(";"));
					orgobj = a;
					setTimeout(click,0);
					setTimeout("orgselect()",0);*/
				}).live("mouseover",function(){
					$(this).addClass("org_hover").parent("li").addClass("hover");
				}).live("mouseout",function(){
					$(this).removeClass("org_hover").parent("li").removeClass("hover");
				});

				//联系类型切换
				$("div.contacttitle").bind("click",function(){
					$("div.contacttitle").removeClass("leftitem_click");
					$(this).addClass("leftitem_click");
					var _index = $(this).attr("_index");
					var temp = "";
					if(_index==1){
						contacttype = 1;
						$("div.contactmenu1").show();
						$("div.contactmenu2").hide().each(function(){
							if($(this).hasClass("leftmenu_select")){
								temp = $(this).index()-7;
							}
						});
						if(temp!="") $("div.contactmenu1")[temp].click();
					}else{
						contacttype = "";
						$("div.contactmenu2").show();
						$("div.contactmenu1").hide().each(function(){
							if($(this).hasClass("leftmenu_select")){
								temp = $(this).index();
							}
						});
						if(temp!="") $("div.contactmenu2")[temp].click();
					}
				});

				$("#showbtn").bind("mouseover",function(){
					var _status = $(this).attr("_status");
					if(_status==0){
						$(this).css("background","url('../images/show_left_hover_wev8.png') no-repeat");
					}else{
						$(this).css("background","url('../images/show_right_hover_wev8.png') no-repeat");
					}
				}).bind("mouseout",function(){
					var _status = $(this).attr("_status");
					if(_status==0){
						$(this).css("background","url('../images/show_left_wev8.png') no-repeat");
					}else{
						$(this).css("background","url('../images/show_right_wev8.png') no-repeat");
					}
				});

				$("table.detaillist").find("tr").live("mouseover",function(){
					$(this).addClass("hover");
				}).live("mouseout",function(){
					$(this).removeClass("hover");
				});

				$("table.cond_month,table.cond_type,table.cond_status").find("td").bind("mouseover",function(){
					$(this).addClass("cond_td_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("cond_td_hover");
				}).bind("click",function(){
					//$(this).parents("table").find("td").removeClass("cond_td_click");
					if($(this).hasClass("cond_td_click")){
						$(this).removeClass("cond_td_click");
					}else{
						$(this).addClass("cond_td_click");
					}
					
					//predate = $("#year").html()+"-"+$("table.cond_month").find("td.cond_td_click").html();
					//$("#changebtn2").addClass("main_btn_select").html(predate); 
					//$("#changecond2").hide();
					//loadList();
				});
				$("#confirmym").bind("click",function(){
					syear = $("#year").html();
					smonth = "";
					sdate1 = "";
					sdate2 = "";
					$("table.cond_month").find("td.cond_td_click").each(function(){
						smonth += "," + $(this).html();
					});
					var predate = $("#year").html();
					if(smonth!=""){
						smonth = smonth.substring(1);
						predate += "-" + smonth
					}
					$("#changebtn2").addClass("main_btn_select").html(predate); 
					$("#changecond2").hide();
					
					$("#sdate1").val("");$("#sdate2").val("");
					
					loadList();
				}).bind("mouseover",function(){
					$(this).css({"color":"#F4F4FF","background":"#0080C0"});
				}).bind("mouseout",function(){
					$(this).css({"color":"#6D6D6D","background":"#fff"});
				});
				$("#clearym").bind("click",function(){
					$("table.cond_month").find("td").removeClass("cond_td_click");
					doChange(this,2,'');
				}).bind("mouseover",function(){
					$(this).css({"color":"#F4F4FF","background":"#0080C0"});
				}).bind("mouseout",function(){
					$(this).css({"color":"#6D6D6D","background":"#fff"});
				});
				$("#confirmtype").bind("click",function(){
					crmtype = "";
					var crmtypeshow = "";
					$("table.cond_type").find("td.cond_td_click").each(function(){
						crmtype += "," + $(this).attr("_val");
						crmtypeshow += "," + $(this).html();
					});
					if(crmtype!=""){
						crmtype = crmtype.substring(1);
						crmtypeshow = crmtypeshow.substring(1);
					}
					$("#changebtn6").addClass("main_btn_select").attr("title",crmtypeshow).html(crmtypeshow); 
					$("#changecond6").hide();
					loadList();
				}).bind("mouseover",function(){
					$(this).css({"color":"#F4F4FF","background":"#0080C0"});
				}).bind("mouseout",function(){
					$(this).css({"color":"#6D6D6D","background":"#fff"});
				});
				$("#cleartype").bind("click",function(){
					$("table.cond_type").find("td").removeClass("cond_td_click");
					doChange(this,6,'');
				}).bind("mouseover",function(){
					$(this).css({"color":"#F4F4FF","background":"#0080C0"});
				}).bind("mouseout",function(){
					$(this).css({"color":"#6D6D6D","background":"#fff"});
				});
				$("#confirmstatus").bind("click",function(){
					crmstatus = "";
					var crmstatusshow = "";
					$("table.cond_status").find("td.cond_td_click").each(function(){
						crmstatus += "," + $(this).attr("_val");
						crmstatusshow += "," + $(this).html();
					});
					if(crmstatus!=""){
						crmstatus = crmstatus.substring(1);
						crmstatusshow = crmstatusshow.substring(1);
					}
					$("#changebtn7").addClass("main_btn_select").attr("title",crmstatusshow).html(crmstatusshow); 
					$("#changecond7").hide();
					loadList();
				}).bind("mouseover",function(){
					$(this).css({"color":"#F4F4FF","background":"#0080C0"});
				}).bind("mouseout",function(){
					$(this).css({"color":"#6D6D6D","background":"#fff"});
				});
				$("#clearstatus").bind("click",function(){
					$("table.cond_status").find("td").removeClass("cond_td_click");
					doChange(this,7,'');
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

				//日期控件
				$.datepicker.setDefaults( {
					"dateFormat": "yy-mm-dd",
					"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
					"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
					"changeMonth": true,
					"changeYear": true} );
				$( "#sdate1" ).datepicker({
					"onSelect":function(){
						syear = "";
						smonth = "";
						sdate1 = $("#sdate1").val();
						$("#changebtn2").html("全部"); 
						loadList();
					}
				});
				$( "#sdate2" ).datepicker({
					"onSelect":function(){
						syear = "";
						smonth = "";
						sdate2 = $("#sdate2").val();
						$("#changebtn2").html("全部"); 
						loadList();
					}
				});
				$( "#contactdate" ).datepicker({
					"onSelect":function(){
						contactdate = $("#contactdate").val();
						loadList();
					}
				});

				$(document).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
				    }
				});
				//$('.scroll1').jScrollPane();
				setPosition();
			});
			function clickUser(){
				if($("#itemdiv2").html()!=""){
					clearInterval(cc);
					doClick("<%=viewuserid %>",4,null,'<%=viewusername%>','<%=viewismanager%>');
				}
			}
			
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
			function onRefresh(){
				loadList();
			}
			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});

			//控制状态分类下拉菜单的控制
			$(document).bind("click",function(e){
				var target=$.event.fix(e).target;
				for(var i=1;i<8;i++){
					if($(target).attr("id")!=("changebtn"+i)
							&& $(target).parents("div").attr("id")!=("changecond"+i)){
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
					"left":$(obj).position().left+0+"px",
					"top":"67px"
				}).show();
			}
			//切换条件
			function doChange(obj,type,val1,val2){
				var _val = $(obj).html();
				if(type==1){//统计年份
					if(year==val1) return; 
					year = val1;
					$("#changebtn1").attr("title","统计年份 "+_val).html(_val); 
				}else if(type==2){//统计年月
					//$("table.cond_year,table.cond_month").find("td").removeClass("cond_td_click");
					$("#changecond2").hide();
					$("#changebtn2").html("全部"); 
					syear="";
					smonth="";
					sdate1="";
					sdate2="";
					$("#sdate1").val("");$("#sdate2").val("");
				}else if(type==3){//商机状态
					if(sellstatus===val1) return; 
					sellstatus = val1;
					$("#changebtn3").attr("title","商机状态 "+_val).html(_val); 
				}else if(type==4){//商机统计纬度
					if(selllat===val1) return; 
					selllat = val1;
					$("#changebtn4").attr("title","统计纬度 "+_val).html(_val); 
				}else if(type==5){//商机联系
					if(sellcontact===val1) return; 
					sellcontact = val1;
					if(sellcontact==-1){
						$("#contactdate").val("");
						contactdate = "";
					}
					$("#changebtn5").html(_val); 
				}else if(type==6){//客户类型
					$("#changecond6").hide();
					$("#changebtn6").attr("title","全部").html("全部"); 
					crmtype = "";
				}else if(type==7){//客户状态
					$("#changecond7").hide();
					$("#changebtn7").attr("title","全部").html("全部"); 
					crmstatus = "";
				}
				
				if(val1==""){
					$("#changebtn"+type).removeClass("main_btn_select");
				}else{
					$("#changebtn"+type).addClass("main_btn_select");
				}
				
				
				loadList();
				loadDetail(year);
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
				//$("#listview").append(loadstr);
				$("#listload").show();
				$.ajax({
					type: "post",
				    url: "ReportMain.jsp",
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"reporttype":reporttype,"viewtype":viewtype,"subtype":subtype,"year":year,"userid":userid,"syear":syear,"smonth":smonth,"sdate1":sdate1,"sdate2":sdate2,"sellstatus":sellstatus,"selllat":selllat
				    	,"sellcontact":sellcontact,"contactdate":contactdate,"crmtype":crmtype,"crmstatus":crmstatus}, 
				    complete: function(data){ 
					    if(listloadststus==date){
					    	$("#listload").hide();
					    	//alert($.trim(data.responseText));
					    	$("#listview").html($.trim(data.responseText));
						}
					}
			    });
			}
			//加载明细
			function loadDetail(ym,_detailtype){
				$("#detaildiv").append(loadstr).load("DetailView.jsp?reporttype="+reporttype+"&viewtype="+viewtype+"&subtype="+subtype+"&ym="+ym+"&userid="+userid+"&sellstatus="+sellstatus+"&detailtype="+_detailtype+"&selllat="+selllat
						+"&sellcontact="+sellcontact+"&contactdate="+contactdate+"&crmtype="+crmtype+"&crmstatus="+crmstatus);
			}
			//加载明细
			function loadDetail2(ym,hrmid,_detailtype){
				$("#detaildiv").append(loadstr).load("DetailView.jsp?reporttype="+reporttype+"&viewtype="+viewtype+"&subtype=1&ym="+ym+"&userid="+hrmid+"&sellstatus="+sellstatus+"&detailtype="+_detailtype+"&selllat="+selllat
						+"&sellcontact="+sellcontact+"&contactdate="+contactdate+"&crmtype="+crmtype+"&crmstatus="+crmstatus);
			}
			function loadDetail4(ym,departmentid,_detailtype){
				$("#detaildiv").append(loadstr).load("DetailView.jsp?reporttype="+reporttype+"&viewtype="+viewtype+"&subtype=1&ym="+ym+"&departmentid="+departmentid+"&sellstatus="+sellstatus+"&detailtype="+_detailtype+"&selllat="+selllat
						+"&sellcontact="+sellcontact+"&contactdate="+contactdate+"&crmtype="+crmtype+"&crmstatus="+crmstatus);
			}
			//加载明细
			function loadDetail3(condtype){
				$("#detaildiv").append(loadstr).load("DetailView.jsp?reporttype="+reporttype+"&viewtype="+viewtype+"&condtype="+condtype+"&subtype="+subtype+"&ym="+ym+"&userid="+userid+"&detailtype="+detailtype+"&syear="+syear+"&smonth="+smonth+"&sdate1="+sdate1+"&sdate2="+sdate2);
			}
			//点击树中内容事件
			function doClick(id,type,obj,name,ismanger){
				userid = id;
				//$("#mtitle").html(name+"的商机");
				$("#changebtn1").show();
				$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
				$("span.org_select").removeClass("org_select");

				$.ajax({
					type: "post",
				    url: "/CRM/manage/util/SetSession.jsp",
				    data:{"userid":userid}
			    });
				
				if(userid=="<%=user.getUID()%>"){
					$("#mine").addClass("leftitem_click");
					$("#sub").removeClass("leftitem_click");
					$("#subtitle").html("");
					$("div.leftmenu").each(function(){
						var cond = $(this).children("div.cond_txt");
						var txt = cond.html();
						cond.attr("title","我的"+txt);
					});
					
					//$("div.menuall").addClass("leftmenu").show();
					_ismanager = <%=ismanager%>;
				}else{
					$("#mine").removeClass("leftitem_click");
					$("#sub").addClass("leftitem_click");
					//$("div.menuall").removeClass("leftmenu").hide();

					var _title = name;
					if(obj!=null){
						$(obj).parent().addClass("org_select");
						if($(obj).parent().nextAll("ul").length>0){
							//_title += "(含下属)";
							_ismanager = 1;
						}else{
							_ismanager = 0;
						}
					}else{
						$("#itemdiv2").find("li").each(function(){
							var liid = $(this).attr("id");
							if(liid.split("|").length>1){
								if(liid.split("|")[1]==id){
									$(this).children("span").addClass("org_select");
									return;
								}
							}
						});
						$("#sub").removeClass("leftitem_click");
						$("#subtitle").addClass("leftitem_click");
						if(ismanger==1){
							_title += "(含下属)";
							_ismanager = 1;
						}else{
							_ismanager = 0;
						}
					}
					$("#subtitle").html(_title);
					$("div.leftmenu").each(function(){
						var cond = $(this).children("div.cond_txt");
						var txt = cond.html();
						cond.attr("title",_title+"的"+txt);
					});
				}
				$("#leftmine").click();
				//loadList();
				//loadDefault(name+"的商机");
		 	}
			//通过搜索框查询某人时执行的加载列表部分
			function searchList(id,name,ismanager){
				doClick(id,4,null,name,ismanager);
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
			var minwidth = 1000;

			function setlayout(){
				if(minwidth==10000){
					minwidth = 1000;
					$("#showbtn").attr("_status",0).attr("title","展开").css("background","url('../images/show_left_hover_wev8.png') no-repeat");
				}else{
					minwidth = 10000;
					$("#showbtn").attr("_status",1).attr("title","收缩").css("background","url('../images/show_right_hover_wev8.png') no-repeat");
				}
				setPosition();
			}
			//设置各部分内容大小及位置
			function setPosition(){
				var width = $("#main").width();
				if(width>minwidth){//窗口宽度大于设定值时 右侧视图不会浮动在左侧菜单上
					
					width -= 256; 
					w1 = Math.round(width*6/9)+1;
					w2 = width-w1+1;
					$("#detail").animate({ width:w2 },speed,null,function(){
						
						$("#view").animate({ width:w1 },speed,null,function(){
							$("#view").animate({ left:246 },speed,null,function(){
								if(init==1){
									init=0;
									<%if(!"".equals(viewuserid) && !(user.getUID()+"").equals(viewuserid)){%>
										<%if(hassub){%>
											cc = setInterval(clickUser,500);
										<%}else{%>
											doClick("<%=viewuserid %>",4,null,'<%=viewusername%>','<%=viewismanager%>');
										<%}%>
									<%}else{%>
										$("#leftmine").click();
									<%}%>
								}
							});
						});
					});
					
				}else{
					width -= 40; 
					w1 = Math.round(width*6/9)+1;
					w2 = width-w1+1;
					$("#detail").animate({ width:w2 },speed,null,function(){
						
						$("#view").animate({ width:w1 },speed,null,function(){
							$("#view").animate({ left:30 },speed,null,function(){
								if(init==1){
									init=0;
									<%if(!"".equals(viewuserid) && !(user.getUID()+"").equals(viewuserid)){%>
										<%if(hassub){%>
											cc = setInterval(clickUser,500);
										<%}else{%>
											doClick("<%=viewuserid %>",4,null,'<%=viewusername%>','<%=viewismanager%>');
										<%}%>
									<%}else{%>
										$("#leftmine").click();
									<%}%>
								}
							});
						});
					});
				} 
				
				//setHeight();
				$("#listview").height($("#main").height()-76-6);
				$("#detaildiv").height($("#main").height()-11-6);

				closeDetail();
			}
			function setHeight(){
				var m = $("#main").height()-52-$("#condiv").offset().top;
				$("#itemdiv2").height(m+26*2);
				var m2 = Math.round(m/3);

				var h1 = ($("#condiv").find("div.leftmenu").length+1)*26;
				if(h1<m2){
					$("#condiv").height(h1);
				}else{
					$("#condiv").height(m2);
				}
				var h2 = ($("#statusdiv").find("div.leftmenu").length+1)*26;
				if(h2<m2){
					$("#statusdiv").height(h2);
				}else{
					$("#statusdiv").height(m2);
				}
				var h = m - $("#statusdiv").height()-$("#condiv").height();
				$("#contactdiv").height(h);
			}
			//var aa;
			//显示左侧菜单
			function showMenu(){
				if($(window).width()<=minwidth){
					$("#view").stop().animate({ left:246 },speed,null,function(){});
					//clearTimeout(aa);
				}
				$("#addbtn").hide();
			}
			//遮挡左侧菜单
			function hideMenu(){
				//判断宽度 以及搜索框是否显示
				if($(window).width()<=minwidth && ($("#fuzzyquery_query_div").length==0 || $("#fuzzyquery_query_div").css("display")=="none")){
					//aa = setTimeout(doHide,100);
					doHide();
				}
			}
			function doHide(){
				$("#view").stop().animate({ left:30 },speed,null,function(){});
				$("#addbtn").hide();
			}

			//显示操作成功提示信息
			function showMsg(){
				var _left = Math.round(($(window).width()-$("#msg").width())/2);
				$("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
					$(this).fadeOut(800);
				});
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

			//读取排名更多记录
			function getPlaceData(obj){
				var _datalist = $(obj).attr("_datalist");
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				var _querysql = $(obj).attr("_querysql");
				var _iscommafy = $(obj).attr("_iscommafy");
				var _dp = $(obj).attr("_dp");
				var _ym = $(obj).attr("_ym");
				var _detailtype = $(obj).attr("_detailtype");
				var _reporttype = $(obj).attr("_reporttype");
				var _ordertype = $(obj).attr("_ordertype");
				var _stattype = $(obj).attr("_stattype");
				$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_place","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"querysql":filter(encodeURI(_querysql))
				    	,"iscommafy":_iscommafy,"dp":_dp,"ym":_ym,"detailtype":_detailtype,"reporttype":_reporttype,"ordertype":_ordertype,"stattype":_stattype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	var records = $.trim(data.responseText);
				    	$("#"+_datalist).append(records);
				    	if(_currentpage*_pagesize>=_total){
				    		$(obj).hide();
					    }else{
					    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
						}
					}
			    });
			}


			/**
			 * 数字格式转换成千分位
			 *@param{Object}num
			 */
			function commafy(num){
				num = getVal(num);
				if($.trim(num+"")==""){
					return"";
				}
				if(isNaN(num)){
					return"";
				}
				num = num+"";
				if(/^.*\..*$/.test(num)){
					var pointIndex =num.lastIndexOf(".");
					var intPart = num.substring(0,pointIndex);
					var pointPart =num.substring(pointIndex+1,num.length);
					intPart = intPart +"";
					var re =/(-?\d+)(\d{3})/
					while(re.test(intPart)){
						intPart =intPart.replace(re,"$1,$2")
					}
					num = intPart+"."+pointPart;
				}else{
					num = num +"";
					var re =/(-?\d+)(\d{3})/
					while(re.test(num)){
						num =num.replace(re,"$1,$2")
					}
				}
				
				var start = num.indexOf(".");
				if(start<0){
					num += ".00";
				}else if(start==num.length-2){
					num += "0";
				}
				
				return num;
			}

			/**
			 * 去除千分位
			 *@param{Object}num
			 */
			function delcommafy(num){
				num = getVal(num);
				if($.trim(num+"")==""){
					return"";
				}
				num=num.replace(/,/gi,'');
				return num;
			}
			function openFullWindowHaveBar(url){
				  var redirectUrl = url ;
				  var width = screen.availWidth-10 ;
				  var height = screen.availHeight-50 ;
				  //if (height == 768 ) height -= 75 ;
				  //if (height == 600 ) height -= 60 ;
				   var szFeatures = "top=0," ;
				  szFeatures +="left=0," ;
				  szFeatures +="width="+width+"," ;
				  szFeatures +="height="+height+"," ;
				  szFeatures +="directories=no," ;
				  szFeatures +="status=yes,toolbar=no,location=no," ;
				  szFeatures +="menubar=no," ;
				  szFeatures +="scrollbars=yes," ;
				  szFeatures +="resizable=yes" ; //channelmode
				  window.open(redirectUrl,"",szFeatures) ;
			}
			function showDetail(url){
				$("#showframe").attr("src","").attr("src",url);
				var right = $("#detail").width()+10;
				$("#show").css("right",right).show();
			}
			function closeDetail(){
				$("#show").attr("src","").hide();
			}
			window.onbeforeunload=function(){
				if(dounload==1){
					//显示主题页面的左侧菜单
					var parentbtn = window.parent.jQuery("#leftBlockHiddenContr");
					//alert(parentbtn.length);
					if(parentbtn.length>0){
						if(window.parent.jQuery("#leftBlockTd").width()==0){
							parentbtn.click();
						}
					}else{
						parentbtn = window.parent.parent.jQuery("#LeftHideShow");
						if(parentbtn.length>0){
							if(parentbtn.attr("title")=="<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>"){
								parentbtn.click();
							}
						}
					}
				}
			}
		</script>
	</body>
</html>
