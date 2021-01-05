
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String year = TimeUtil.getCurrentDateString().substring(0,4);
	boolean hassub = false;
	rs.executeSql("select id,lastname from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID() + " order by dsporder");
	int ismanager = 0;
	if(rs.getCounts()>0){
		hassub = true;
		ismanager = 1;
	}
	
	//session中存储的查看人员id
	String  viewuserid = (String)request.getSession().getAttribute("CRM_MAIN_USERID");
	if("null".equals(viewuserid) || viewuserid == null) viewuserid = "";
	String viewusername = ResourceComInfo.getLastname(viewuserid);
	int viewismanager = 0;
	if(!viewuserid.equals("")){
		rs.executeSql("select count(id) from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + viewuserid);
		if(rs.next() && rs.getInt(1)>0){
			viewismanager = 1;
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>商机管理</title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/> 
		<script language="javascript" src="../js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.core_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.widget_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.datepicker_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<link type='text/css' rel="stylesheet" href="../css/ui/jquery.ui.all_wev8.css" />
		
		<link type='text/css' rel='stylesheet'  href='/tree/js/treeviewAsync/eui.tree_wev8.css'/>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview_wev8.js'></script>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
		<script language="javascript" src="../js/main_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<link rel="stylesheet" href="../css/Contact_wev8.css" />
		<link type='text/css' rel="stylesheet" href="../css/Main_wev8.css" />
		<style type="text/css">
			<%if(hassub){ %>
				.cond_txt{right:33px;left:auto;}
			<%}%>
			
			.disinput{line-height: 28px !important;height: 28px !important;}
			.toptitle1,.toptitle2{width: 40px;}
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
					<div class="toptitle1" style="border-left: 1px #FFFFFF solid;border-right: 1px #A6A6A6 solid;">商机</div>
					<div class="toptitle2" _url="/CRM/manage/Index.jsp?maintype=4&<%=System.currentTimeMillis() %>"
						style="border-left: 1px #FFFFFF solid;">报表</div>
					<div id="showbtn" class="showbtn" onclick="setlayout()" title="展开" _status="0"></div>
				</div>
				<!-- search -->
				<div style="width: 225px;height: 26px;;margin-top: 5px;margin-bottom: 10px;margin-left: 13px;position: relative;">
					<label for="objname" class="overlabel">按商机名称、客户名称及人员搜索</label>
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
									<div id="leftmine" class="leftmenu" _datatype="1" _subcompanyId="" _deptId="" _creater="<%=user.getUID() %>" _attention="" _sellstatusid="">
										<div class="cond_txt" title="我的商机">我的商机</div>
										<div id="icon1_1" class="cond_icon cond_icon20"></div>
									</div>
									<div class="leftmenu" _datatype="1" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _remind="1">
										<div class="cond_txt" title="被提醒商机">被提醒</div>
										<div id="icon1_2" class="cond_icon cond_icon20"></div>
									</div>
									<div class="leftmenu menuall" _datatype="1" _subcompanyId="" _deptId="" _creater="" _attention="1" _sellstatusid="">
										<div class="cond_txt" title="关注商机">关注商机</div>
										<div id="icon1_3" class="cond_icon cond_icon20"></div>
									</div>
									<!-- <div class="leftmenu" _datatype="1" _subcompanyId="<%=user.getUserSubCompany1() %>" _deptId="" _creater="" _attention="" _sellstatusid="">
										<div class="cond_txt" title="所在分部商机">所在分部</div>
										<div id="icon1_3" class="cond_icon cond_icon20"></div>
									</div> -->
									<!--<div class="leftmenu" _datatype="1" _subcompanyId="" _deptId="<%=user.getUserDepartment() %>" _creater="" _attention="" _sellstatusid="">
										<div class="cond_txt" title="所在部门商机">所在部门</div>
										<div id="icon1_4" class="cond_icon cond_icon20"></div>
									</div> -->
									<div class="leftmenu menuall" _datatype="1" _subcompanyId="" _deptId="" _creater="-1" _attention="" _sellstatusid="">
										<div class="cond_txt" title="非本人商机">非本人商机</div>
										<div id="icon1_4" class="cond_icon cond_icon20"></div>
									</div>
									<div class="leftmenu menuall" _datatype="1" _subcompanyId="" _deptId="" _creater="0" _attention="" _sellstatusid="">
										<div class="cond_txt" title="全部商机">全部商机</div>
										<div id="icon1_5" class="cond_icon cond_icon20"></div>
									</div>
								</div>
							</div>
							
							<div class="lefttitle" style="">
								<div style="line-height: 26px;position: absolute;left: 10px;">商机阶段</div>
							</div>
							<div id="statusdiv" class="scroll2" style="width: 100%;overflow-y: auto;overflow-x: hidden;position: relative;">
								<div style="width: auto;height: 100%;position: relative;">
								<%
									int temp = 5;
									SellstatusComInfo.setTofirstRow();
										while(SellstatusComInfo.next()){
											temp++;
								%>
								<div class="leftmenu menuss" style="display: " _datatype="0" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="<%=SellstatusComInfo.getSellStatusid() %>">
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
								<div class="leftmenu" _datatype="0" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="-4">
									<div class="cond_txt" title="暂停商机">暂停商机</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon10"></div>
								</div>
								<div class="leftmenu" _datatype="0" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="-5">
									<div class="cond_txt" title="培育商机">培育商机</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon10"></div>
								</div>
								</div>
							</div>
							<div class="lefttitle" style="">
								<div class="leftitem leftitem_click contacttitle" style="cursor: pointer;" _index="1" title="查询客户经理未联系">负责人联系</div>
								<div class="leftitem contacttitle" style="cursor: pointer;" _index="2" title="查询所有人未联系">所有人联系</div>
							</div>
							<div id="contactdiv" class="scroll2" style="width: 100%;overflow-y: auto;overflow-x: hidden;position: relative;">
								<div style="width: auto;height: 100%;position: relative;">
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-3) %>">
									<div class="cond_txt" title="三天未联系商机">三天未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7) %>">
									<div class="cond_txt" title="一周未联系商机">一周未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14) %>">
									<div class="cond_txt" title="二周未联系商机">二周未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30) %>">
									<div class="cond_txt" title="一个月未联系商机">一月未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90) %>">
									<div class="cond_txt" title="三个月未联系商机">三月未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180) %>">
									<div class="cond_txt" title="半年未联系商机">半年未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-365) %>">
									<div class="cond_txt" title="一年未联系商机">一年未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								
								
								
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-3) %>">
									<div class="cond_txt" title="三天未联系商机">三天未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7) %>">
									<div class="cond_txt" title="一周未联系商机">一周未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14) %>">
									<div class="cond_txt" title="二周未联系商机">二周未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30) %>">
									<div class="cond_txt" title="一个月未联系商机">一月未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90) %>">
									<div class="cond_txt" title="三个月未联系商机">三月未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180) %>">
									<div class="cond_txt" title="半年未联系商机">半年未联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-365) %>">
									<div class="cond_txt" title="一年未联系商机">一年未联系</div>
									<div id="icon1_<%=temp %>" class="cond_icon cond_icon30"></div>
								</div>
								
								<div id="customdiv" class="leftmenu" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _nocontact="">
									<div class="cond_txt" title="自定义未联系日期" style="left: 10px;width: auto;z-index: 100;cursor: pointer;">
										<input id="customdate" type="text" readonly="readonly" style="width: 100%;height:18px;line-height: 18px;padding-left: 0px;margin-top:3px;
							border: 0px;font-family:'微软雅黑';background:none;color:#3A3A3A;cursor: pointer;" value="自定义未联系日期"/></div>
									<div id="icon1_" class="cond_icon cond_icon30"></div>
								</div>
								
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),0) %>">
									<div class="cond_txt" title="今天联系商机">今天联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7) %>">
									<div class="cond_txt" title="最近一周联系商机">近一周联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30) %>">
									<div class="cond_txt" title="最近一个月联系商机">近一月联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu1" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90) %>">
									<div class="cond_txt" title="最近三个月联系商机">近三月联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),0) %>">
									<div class="cond_txt" title="今天联系商机">今天联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7) %>">
									<div class="cond_txt" title="最近一周联系商机">近一周联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30) %>">
									<div class="cond_txt" title="最近一个月联系商机">近一月联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								<div class="leftmenu contactmenu2" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90) %>">
									<div class="cond_txt" title="最近三个月联系商机">近三月联系</div>
									<div id="icon1_<%=temp++ %>" class="cond_icon cond_icon30"></div>
								</div>
								
								<div id="customdiv2" class="leftmenu" _datatype="2" _subcompanyId="" _deptId="" _creater="" _attention="" _sellstatusid="" _contact="">
									<div class="cond_txt" title="自定义已联系日期" style="left: 10px;width: auto;z-index: 100;cursor: pointer;">
										<input id="customdate2" type="text" readonly="readonly" style="width: 100%;height:18px;line-height: 18px;padding-left: 0px;margin-top:3px;
							border: 0px;font-family:'微软雅黑';background:none;color:#3A3A3A;cursor: pointer;" value="自定义已联系日期"/></div>
									<div id="icon1_" class="cond_icon cond_icon30"></div>
								</div>
								
								<div style="width: 100%;height: 10px;"></div>
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
						<div style="position: absolute;left: 22px;top: 0px;bottom: 0px;overflow: hidden;background: url('../images/title_bg_01_wev8.png') repeat-x;">
						<div id="changebtn1" style="width: 90px;" class="main_btn" onclick="showChange(1,this)" title="商机阶段" _show="商机阶段">
							商机阶段
						</div>
						<div id="changebtn2" class="main_btn" onclick="showChange(2,this)" title="预期年月" _show="预期年月">
							预期年月
						</div>
						<div id="changebtn3" class="main_btn" onclick="showChange(3,this)" title="预期收益" _show="预期收益">
							预期收益
						</div>
						<div id="changebtn4" class="main_btn" onclick="showChange(4,this)" title="可能性" _show="可能性">
							可能性
						</div>
						<div id="changebtn5" class="main_btn" style="border-right: 1px #E4E4E4 solid;" onclick="showChange(5,this)" title="商机类型" _show="商机类型">
							商机类型
						</div>
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
					<div id="changecond5" class="div_cond" style="width:110px;">
						<div class="btn_add_type" onclick="doChange(this,5,1)">终端客户商机</div>
						<div class="btn_add_type" onclick="doChange(this,5,2)">老客户二次商机</div>
						<div class="btn_add_type" onclick="doChange(this,5,3)">代理压货商机</div>
						<div class="btn_add_type" style="border-bottom: 0px;" onclick="doChange(this,5,'')">全部</div>
					</div>
					<div id="listview" class="scroll1" style="position: absolute;top: 66px;bottom: 0px;left: 0px;right: 0px;">
						
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

			var nocontact = "";
			var contact = "";
			var contacttype = "1";
			var subcompanyId = "";//分部id
			var deptId = "";//部门id
			var creater = "<%=user.getUID()+""%>";//人员id
			var creatertype = "";
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
			
			var remind = "";

			var listloadststus = 0;
			var detailloadstatus = 0;

			var _ismanager = <%=ismanager%>;
			var subtype = 0;

			var cc = null;

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
					//if($(this).attr("id")=="customdiv" && $(this).attr("_nocontact")=="") return;
					
					//$("span.org_select").removeClass("org_select");
					$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
					$(this).addClass("leftmenu_select");
					subcompanyId = getVal($(this).attr("_subcompanyId"));
					deptId = getVal($(this).attr("_deptId"));
					creatertype = getVal($(this).attr("_creater"));
					attention = getVal($(this).attr("_attention"));
					sellstatusid = getVal($(this).attr("_sellstatusid"));
					nocontact = getVal($(this).attr("_nocontact"));
					contact = getVal($(this).attr("_contact"));
					remind = getVal($(this).attr("_remind"));
					keyname = "";
					
					datatype = $(this).attr("_datatype");
					if(datatype=="0"){
						sellstatusid2 = "";
						$("#changebtn1").html("商机阶段").hide();
					}else{
						$("#changebtn1").show();
					}

					if(_ismanager==1 && creatertype!="0" && creatertype!="-1" && attention!="1"){
						$("#subdiv").show();
						$(".subtab").removeClass("subtab_click");
						$(".subtab:first").addClass("subtab_click");
					}else{
						$("#subdiv").hide();
					}
					subtype = 0;
					
					var mtitle = $($(this).find("div")[0]).attr("title");
					if($(this).attr("id")=="customdiv") mtitle = $("#customdate").val()+"至今未联系商机";
					$("#mtitle").html(mtitle);
					$("#micon").css("background","url('../images/title_icon_"+datatype+".png') no-repeat");
					loadList();
					if(datatype!=2) loadDefault(mtitle,'0');//未联系类查询不刷新最右侧部分(性能低)
				});

				/**
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
					
				});*/

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
				$( "#customdate2" ).datepicker({
					"onSelect":function(){
						var date = $("#customdate2").val();
						$($("#customdiv2").find("div")[0]).attr("title","自定义已联系："+date);
						$("#customdiv2").attr("_contact",date).click();
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
					$.ajax({
						type: "post",
					    url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":2,"objid":sellchanceid,"settype":_special}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
					    	if(_special==1){
								attobj.removeClass("td_noatt").addClass("td_att").attr("title","取消关注").attr("_special","0").html("&nbsp;");
								$("#btnatt_"+sellchanceid).attr("title","取消关注").attr("_special","0").html("取消关注");	
							}else{
								attobj.removeClass("td_att").addClass("td_noatt").attr("title","标记关注").attr("_special","1").html("&nbsp;");	
								$("#btnatt_"+sellchanceid).attr("title","标记关注").attr("_special","1").html("标记关注");
							}
					    	showMsg();
						}
				    });
				});
				$("div.btn_att").live("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var sellchanceid =  attobj.attr("_sellchanceid");
					$.ajax({
						type: "post",
						url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":2,"objid":sellchanceid,"settype":_special}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
					    	if(_special==1){
								attobj.attr("title","取消关注").attr("_special","0").html("取消关注");
								$("#item"+sellchanceid).children("td.td_move").removeClass("td_noatt").addClass("td_att").attr("title","取消关注").attr("_special","0").html("&nbsp;");	
							}else{
								attobj.attr("title","标记关注").attr("_special","1").html("标记关注");
								var tdobj = $("#item"+sellchanceid).children("td.td_move");
								tdobj.removeClass("td_att").addClass("td_noatt").attr("title","标记关注").attr("_special","1").html(tdobj.attr("_index"));	
							}
					    	showMsg();
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

				$("#feedbacktable").find(".data").live("mouseover",function(){
					$(this).css("background-color","#F7FBFF");
				}).live("mouseout",function(){
					$(this).css("background-color","#fff");
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

				$(document).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).attr("id").indexOf("addtag")==0){
				    		$("#addtagbtn_"+$(target).attr("_index")).click();
				    	}
				    }
				});
				<%if(!"".equals(viewuserid) && !(user.getUID()+"").equals(viewuserid)){%>
					<%if(hassub){%>
						cc = setInterval(clickUser,500);
					<%}else{%>
						doClick("<%=viewuserid %>",4,null,'<%=viewusername%>','<%=viewismanager%>');
					<%}%>
				<%}else{%>
					checknew(1);
					//setInterval(checknew,300000);
					$("#leftmine").click();
				<%}%>
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
			function addSellChance(){
				openFullWindowHaveBar("/CRM/manage/sellchance/SellChanceAdd.jsp");
			}
			function onRefresh(){
				loadList();
			}
			function checknew(init){
				$("div.cond_icon").removeClass("cond_icon_count").html("");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"check_new","creater":creater}, 
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
						//if(i==1 && init==1) $("div.leftmenu")[0].click();//当我的商机个数不为0时默认加载我的商机
						$("#icon1_"+i).addClass("cond_icon_count").html(amount).attr("title",amount);
						//if(!$("#icon1_"+i).parent().hasClass("menuss")){
						//	$("#icon1_"+i).parent().addClass("leftmenu").show();
						//}
					}else{
						//if(i==1 && init==1) $("div.leftmenu")[5].click();//当我的商机个数为0时默认加载全部商机
						//if($("#icon1_"+i).parent().hasClass("menuss")){
						//	$("#icon1_"+i).parent().removeClass("leftmenu").hide();
						//}else{
							$("#icon1_"+i).removeClass("cond_icon_count").html("").attr("title","");
						//}
					}
				}
				setHeight();
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
					"left":$(obj).position().left+22+"px",
					"top":"67px"
				}).show();
			}
			//切换条件
			function doChange(obj,type,val1,val2){
				var _val = $(obj).html();
				if(type==1){//商机阶段
					if(sellstatusid2==val1) return; 
					sellstatusid2 = val1;
					if(val1==""){
						$("#changebtn1").attr("title","商机阶段").html("商机阶段"); 
					}else{
						$("#changebtn1").attr("title",_val).html(_val); 
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
						$("#changebtn3").attr("title","预期收益").html("预期收益"); 
					}else{
						$("#changebtn3").attr("title",_val).html(_val); 
					}
				}else if(type==4){//可能性
					if(posiblemin==val1 && posiblemax==val2) return; 
					posiblemin = val1; posiblemax = val2;
					if(val1==""){
						$("#changebtn4").attr("title","可能性").html("可能性"); 
					}else{
						$("#changebtn4").attr("title",_val).html(_val); 
					}
				}else if(type==5){//商机类型
					if(selltype==val1) return; 
					selltype = val1;
					if(val1==""){
						$("#changebtn5").attr("title","商机类型").html("商机类型"); 
					}else{
						$("#changebtn5").attr("title",_val).html(_val); 
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
					var _show = $("#changebtn"+i).attr("_show")
					$("#changebtn"+i).attr("title",_show).html(_show).removeClass("main_btn_select");
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
				//$("#listview").append(loadstr);
				$("#listload").show();
				$.ajax({
					type: "post",
				    url: "ListView.jsp",
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"subcompanyId":subcompanyId,"deptId":deptId,"creater":creater,"creatertype":creatertype,"attention":attention,"sellstatusid":sellstatusid,"sellstatusid2":sellstatusid2
					    ,"predate":predate,"moneymin":moneymin,"moneymax":moneymax,"posiblemin":posiblemin,"posiblemax":posiblemax,"selltype":selltype,"nocontact":nocontact,"contact":contact,"keyname":filter(encodeURI(keyname))
					    ,"remind":remind,"contacttype":contacttype,"subtype":subtype}, 
				    complete: function(data){ 
					    if(listloadststus==date){
					    	$("#listload").hide();
					    	$("#listview").html(data.responseText);
						}
					}
			    });
			}
			//加载最新反馈部分
			function loadDefault(mtitle,isself,keytype,keyword){
				var _keytype = getVal(keytype);
				var _keyword = getVal(keyword);
				var fbupload = document.getElementById("fbUploadDiv");
				if(fbupload!=null) fbupload.innerHTML = "";
				isself = getVal(isself);
				$("#detaildiv").append(loadstr).load("DefaultView.jsp?mtitle="+mtitle
						+"&subcompanyId="+subcompanyId+"&deptId="+deptId+"&creater="+creater+"&creatertype="+creatertype+"&attention="+attention+"&sellstatusid="+sellstatusid+"&nocontact="+nocontact+"&contact="+contact+"&keyname="+keyname+"&isself="+isself
						+"&keytype="+_keytype+"&keyword="+_keyword
						+"&remind="+remind+"&contacttype="+contacttype);
			}
			//点击树中内容事件
			function doClick(id,type,obj,name,ismanger){
			 	subcompanyId = "";
				deptId = "";
				creater = "";
				sellstatusid = "";
				keyname = "";
				nocontact = "";
				contact = "";
				if(type==2){
					subcompanyId = id;
				}else if(type==3){
					deptId = id;
				}else if(type==4){
					creater = id;
				}
				//$("#mtitle").html(name+"的商机");
				$("#changebtn1").show();
				$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
				$("span.org_select").removeClass("org_select");

				$.ajax({
					type: "post",
				    url: "/CRM/manage/util/SetSession.jsp",
				    data:{"userid":creater}
			    });
				
				if(creater=="<%=user.getUID()%>"){
					$("#mine").addClass("leftitem_click");
					$("#sub").removeClass("leftitem_click");
					$("#subtitle").html("");
					$("#leftmine").children("div.cond_txt").html("我的商机").attr("title","我的商机");
					$("div.menuall").addClass("leftmenu").show();
					_ismanager = <%=ismanager%>;
				}else{
					$("#mine").removeClass("leftitem_click");
					$("#sub").addClass("leftitem_click");
					$("div.menuall").removeClass("leftmenu").hide();

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
					$("#leftmine").children("div.cond_txt").html("所有商机").attr("title",_title+"的商机");
				}
				checknew();
				
				$("#leftmine").click();
				//loadList();
				//loadDefault(name+"的商机");
		 	}
			//通过搜索框查询某人时执行的加载列表部分
			function searchList(id,name,ismanager){
				doClick(id,4,null,name,ismanager);
			}
			//通过搜索框直接回车按名称查询
			function searchByName(){
				keyname = $("#objname").val();
				subcompanyId = "";
				deptId = "";
				creatertype = "0";
				sellstatusid = "-3";
				nocontact = "";
				contact = "";
				attention = "";
				remind = "";
				
				$("#mtitle").html("搜索结果");
				$("span.org_select").removeClass("org_select");
				$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
				//$("div.leftitem").removeClass("leftitem_click");
				//$("#subtitle").html("");
				loadList();
				loadDefault("搜索结果",'0');
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
				var _sellchanceid = $(obj).attr("_sellchanceid");
				var _sellchancename = $(obj).attr("_sellchancename");
				var _customerid = $(obj).attr("_customerid");
				var _contacterid = getVal($(obj).attr("_contacterid"));
				if(_contacterid==""){
					var _status = getVal($(obj).attr("_status"));
					if(_status==""){
						if($("#load_"+_sellchanceid+"_"+_customerid).length>0){
							$("#load_"+_sellchanceid+"_"+_customerid).show();
							$.ajax({
								type: "post",
							    url: "/CRM/manage/contacter/Operation.jsp",
							    data:{"operation":"get_list_contacter","customerid":_customerid,"sellchanceid":_sellchanceid}, 
							    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
							    complete: function(data){ 
							    	$("#load_"+_sellchanceid+"_"+_customerid).before($.trim(data.responseText)).remove();
							    	$("tr.contacter_"+_sellchanceid+"_"+_customerid).show();
								}
						    });
						}else{
							$("tr.contacter_"+_sellchanceid+"_"+_customerid).show();
						}
						$(obj).attr("_status","1");
					}else{
						$("tr.contacter_"+_sellchanceid+"_"+_customerid).hide();
						$(obj).attr("_status","");
					}
					if(getVal($(foucsobj).attr("_contacterid"))=="" && $(foucsobj).attr("_sellchanceid")==_sellchanceid) return;//重复点击时不会加载
					foucsobj = obj;
					
					var _lastdate = getVal($(obj).attr("_lastdate"));
					getDetail(_sellchanceid,_customerid,_lastdate,_sellchancename);
				}else{
					if($(foucsobj).attr("_contacterid")==_contacterid) return;//重复点击时不会加载
					foucsobj = obj;

					getDetail2(_contacterid);	
				}
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
			function getDetail2(contacterid){
				var fbupload = document.getElementById("fbUploadDiv");
				if(fbupload!=null) fbupload.innerHTML = "";
				$("#detaildiv").html("").append(loadstr);
				detailloadstatus = contacterid;
				$.ajax({
					type: "post",
				    url: "/CRM/manage/contacter/DetailView.jsp",
				    data:{"contacterid":contacterid}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	if(detailloadstatus==contacterid){
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
				
				setHeight();
				$("#listview").height($("#main").height()-76-6);
				$("#detaildiv").height($("#main").height()-11-6);
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
<%@ include file="/CRM/manage/util/uploader.jsp" %>