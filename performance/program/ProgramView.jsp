<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.gp.util.RightUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
	//所有经理及考核方案制定人、考核方案确认人有权限查看
	String userid = user.getUID()+"";
	String programid = Util.null2String(request.getParameter("programid"));
	String oldprogramid = Util.null2String(request.getParameter("oldprogramid"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String managerid = "";
	String managername = "";
	String viewtype = Util.null2String(request.getParameter("viewtype"));
	String programtype = Util.null2String(request.getParameter("programtype"));
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	if(programtype.equals("")) programtype = Util.null2String((String)request.getSession().getAttribute("GP_PROGRAM_TYPE"));
	boolean self = false;
	boolean manager = false;
	boolean canview = false;
	boolean canedit = false;
	boolean canadd = false;
	boolean canback = false;
	
	String sql = "";
	
	String programname = "";
	String startdate = "";
	String status = "";
	String auditids = "";
	String remark = "";
	if(!programid.equals("")){
		rs.executeSql("select programname,userid,startdate,programtype,status,auditids,remark from GP_AccessProgram where id="+programid);
		if(rs.next()){
			programtype = Util.null2String(rs.getString("programtype"));
			programname = Util.null2String(rs.getString("programname"));
			startdate = Util.null2String(rs.getString("startdate"));
			status = Util.null2String(rs.getString("status"));
			resourceid = Util.null2String(rs.getString("userid"));
			auditids = Util.null2String(rs.getString("auditids"));
			remark = Util.null2String(rs.getString("remark"));
		}else{
			response.sendRedirect("../util/Message.jsp?type=1");
		    return ;
		}
	}else if(resourceid.equals("")){
		resourceid = userid;
		//response.sendRedirect("../util/Message.jsp?type=1");
	    //return ;
	}
	
	//查询基础设置
	int isfyear = 0;       
	int ishyear = 0;     
	int isquarter = 0;       
	int ismonth = 0;      
	int fstarttype = 0;
	int fstartdays = 0;
	int hstarttype = 0;
	int hstartdays = 0;
	int qstarttype = 0;
	int qstartdays = 0;
	int mstarttype = 0;
	int mstartdays = 0;
	
	String programcreate = "";
	String programaudit = "";   
	int isself = 0;           
	int ismanager = 0;
	rs.executeSql("select * from GP_BaseSetting where resourceid=" + ResourceComInfo.getDepartmentID(resourceid) + " and resourcetype=3");
	if(rs.next()){
		programcreate = Util.null2String(rs.getString("programcreate"));  
		programaudit = Util.null2String(rs.getString("programaudit"));  
		isself = Util.getIntValue(rs.getString("isself"),0);         
		ismanager = Util.getIntValue(rs.getString("ismanager"),0);
		RecordSet rs2 = new RecordSet();
		rs2.executeSql("select * from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
		if(rs2.next()){
			isfyear = Util.getIntValue(rs2.getString("isfyear"),0);       
			ishyear = Util.getIntValue(rs2.getString("ishyear"),0);        
			isquarter = Util.getIntValue(rs2.getString("isquarter"),0);      
			ismonth = Util.getIntValue(rs2.getString("ismonth"),0);   
			
			fstarttype = Util.getIntValue(rs2.getString("fstarttype"),0);       
			fstartdays = Util.getIntValue(rs2.getString("fstartdays"),0);       
			hstarttype = Util.getIntValue(rs2.getString("hstarttype"),0);       
			hstartdays = Util.getIntValue(rs2.getString("hstartdays"),0);       
			qstarttype = Util.getIntValue(rs2.getString("qstarttype"),0);       
			qstartdays = Util.getIntValue(rs2.getString("qstartdays"),0);   
			mstarttype = Util.getIntValue(rs2.getString("mstarttype"),0);       
			mstartdays = Util.getIntValue(rs2.getString("mstartdays"),0);
		}
	}else{
		rs.executeSql("select * from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
		if(rs.next()){
			isfyear = Util.getIntValue(rs.getString("isfyear"),0);       
			ishyear = Util.getIntValue(rs.getString("ishyear"),0);        
			isquarter = Util.getIntValue(rs.getString("isquarter"),0);      
			ismonth = Util.getIntValue(rs.getString("ismonth"),0);   
			programcreate = Util.null2String(rs.getString("programcreate"));  
			programaudit = Util.null2String(rs.getString("programaudit"));  
			isself = Util.getIntValue(rs.getString("isself"),0);         
			ismanager = Util.getIntValue(rs.getString("ismanager"),0);
			
			fstarttype = Util.getIntValue(rs.getString("fstarttype"),0);       
			fstartdays = Util.getIntValue(rs.getString("fstartdays"),0);       
			hstarttype = Util.getIntValue(rs.getString("hstarttype"),0);       
			hstartdays = Util.getIntValue(rs.getString("hstartdays"),0);       
			qstarttype = Util.getIntValue(rs.getString("qstarttype"),0);       
			qstartdays = Util.getIntValue(rs.getString("qstartdays"),0);   
			mstarttype = Util.getIntValue(rs.getString("mstarttype"),0);       
			mstartdays = Util.getIntValue(rs.getString("mstartdays"),0);   
		}
	}
	if(isfyear!=1 && ishyear!=1 && isquarter!=1 && ismonth!=1) {
		response.sendRedirect("../util/Message.jsp?type=2") ;
		return;//未启用任何考核
	}
	
	if(programid.equals("")){
		if(isfyear!=1 && programtype.equals("4")) programtype = "";
		if(ishyear!=1 && programtype.equals("3")) programtype = "";
		if(isquarter!=1 && programtype.equals("2")) programtype = "";
		if(ismonth!=1 && programtype.equals("1")) programtype = "";
		
		if(viewtype.equals("add")){
			canadd = false;
			canback = true;
		}else{
			if(programtype.equals("")){
				if(isfyear==1) programtype = "4";
				if(ishyear==1) programtype = "3";
				if(isquarter==1) programtype = "2";
				if(ismonth==1) programtype = "1";
			}
			//查看最新的方案
			if("oracle".equals(rs.getDBType())){
				sql = "select * from (select id,programname,userid,startdate,programtype,status,auditids,remark from GP_AccessProgram where userid="+resourceid+" and programtype="+programtype+" order by startdate desc,id desc) t where rownum=1";
			}else{
				sql = "select top 1 id,programname,userid,startdate,programtype,status,auditids,remark from GP_AccessProgram where userid="+resourceid+" and programtype="+programtype+" order by startdate desc,id desc";
			}
			rs.executeSql(sql);
			if(rs.next()){
				programid = Util.null2String(rs.getString("id"));
				programname = Util.null2String(rs.getString("programname"));
				startdate = Util.null2String(rs.getString("startdate"));
				status = Util.null2String(rs.getString("status"));
				resourceid = Util.null2String(rs.getString("userid"));
				auditids = Util.null2String(rs.getString("auditids"));
				remark = Util.null2String(rs.getString("remark"));
			}
		}
	}
	String managerid2 = ResourceComInfo.getManagerID(ResourceComInfo.getManagerID(resourceid));
	String managername2 = "上级的上级-"+cmutil.getPerson(ResourceComInfo.getManagerID(ResourceComInfo.getManagerID(resourceid)));
	String auditnames = "";
	if(auditids.equals("-1")){
		auditnames = managername2;
	}else{
		auditnames = cmutil.getPerson(auditids);
	}
	
	managerid = ResourceComInfo.getManagerID(resourceid);
	managername = "直接上级-"+cmutil.getPerson(managerid);
	
	if(resourceid.equals(userid)){
		self = true;
		canview = true;
	}else if(ResourceComInfo.isManager(user.getUID(),resourceid)){
		manager = true;
		canview = true;
	}
	
	if((self && isself==1) || (manager && ismanager==1)){
		canedit = true;
	}else if((","+programcreate+",").indexOf(","+userid+",")>-1){
		canview = true;
		canedit = true;
	}else if((","+programaudit+",").indexOf(","+userid+",")>-1){
		canview = true;
	}
	if(!canview){
		response.sendRedirect("/performance/util/Message.jsp?type=1");
	    return ;
	}
	
	canadd = canedit;
	
	if(status.equals("1")){
		canedit = false;
	}
	if(programid.equals("")){
		canadd = false;
	}
	boolean canaudit = RightUtil.isCanAuditProgram(programid,userid);
	
	int indexnum = 0;
	int indexnum2 = 0;
	int itemtype = 0;
	
	
	request.getSession().setAttribute("GP_PROGRAM_TYPE",programtype);
	
	
	//判断当前周期是否有确认的考核方案
	boolean noprogram = false;
	String nomsg = "";
	String basedate = "";
	String pstartdate = "";
	int year = Util.getIntValue(TimeUtil.getCurrentDateString().substring(0,4));//当前年份
	int month = Util.getIntValue(TimeUtil.getCurrentDateString().substring(5,7));//当前月份
	int season = Util.getIntValue(TimeUtil.getCurrentSeason());//当前季度
	if(programtype.equals("4")){
		nomsg = "提示：暂无已通过的"+year+"年年度考核方案！";
		basedate = TimeUtil.getYearMonthEndDay(year,12);
		pstartdate = TimeUtil.dateAdd(basedate, fstarttype*fstartdays);
	}else if(programtype.equals("3")){
		nomsg = "提示：暂无已通过的"+year+"年半年度考核方案！";
		basedate = TimeUtil.getYearMonthEndDay(year,6);
		pstartdate = TimeUtil.dateAdd(basedate, hstarttype*hstartdays);
	}else if(programtype.equals("2")){
		nomsg = "提示：暂无已通过的"+year+"年第"+season+"季度考核方案！";
		if(season==1) basedate = TimeUtil.getYearMonthEndDay(year,3);
		if(season==2) basedate = TimeUtil.getYearMonthEndDay(year,6);
		if(season==3) basedate = TimeUtil.getYearMonthEndDay(year,9);
		if(season==4) basedate = TimeUtil.getYearMonthEndDay(year,12);
		pstartdate = TimeUtil.dateAdd(basedate, qstarttype*qstartdays);
	}else if(programtype.equals("1")){
		nomsg = "提示：暂无已通过的"+year+"年"+month+"月考核方案！";
		basedate = TimeUtil.getYearMonthEndDay(year,month);
		pstartdate = TimeUtil.dateAdd(basedate, mstarttype*mstartdays);
	}
	rs.executeSql("select count(id) as amount from GP_AccessProgram where startdate<='"+pstartdate+"' and programtype="+programtype+" and userid="+resourceid+" and status=3");
	if(rs.next() && rs.getInt(1)==0){
		noprogram = true;
	}	
	boolean canquoteindex = false;
	if(canedit && !"".equals(programid)){
		canquoteindex = true;
	}
	String titlename = "执行力-"+ResourceComInfo.getLastname(resourceid) +"绩效考核方案设置";
%>
<HTML>
	<HEAD>
		<title><%=ResourceComInfo.getLastname(resourceid) %>绩效考核方案设置</title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="../js/util.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="../css/tab.css" />
		<style type="text/css">
			.input{height: 28px;}
			.area_txt{width:98%;height: 70px;margin-top: 2px;margin-bottom: 2px;overflow-x: hidden;overflow-y: auto;}
		
			.maintable{width: 100%;border-collapse: collapse;}
			.maintable td{min-height: 28px;line-height: 28px;padding-left: 5px;border: 1px #DCDCDC solid;}
			.maintable td.title{background: #DDD9C3;}
			.maintable tr.header td{font-weight: bold;background: #F8F8F8;;}
			
			.title_panel{width: 100%;height: 24px;margin-top: 10px;}
			.title_txt{width: auto;line-height: 20px;float: left;font-weight: bold;font-size: 13px;}
			
			.btn1{width: 60px;line-height: 20px;height: 20px;text-align: center;border: 1px #B0B0B0 solid;cursor: pointer;margin-left: 5px;float: left;padding: 0px !important}
			.btn2{width: 40px;line-height: 20px;height: 20px;text-align: center;border: 1px #B0B0B0 solid;cursor: pointer;margin-left: 5px;float: left;padding: 0px !important}
			
			.btn_browser{width:22px;height:22px;float: left;margin-left: 0px;margin-top: 2px;cursor: pointer;
				background: url('../images/btn_browser.png') center no-repeat !important;}
			.btn_browser2{width:20px;height:20px;float: left;margin-left: 0px;margin-top: 2px;margin-right: 2px;cursor: pointer;
				background: url('../images/btn_browser.png') center no-repeat !important;}
			.txt_browser{width:200px;height:22px;line-height:22px;float: left;margin-top: 2px;}
			.txt_browser2{width:80px;height:20px;line-height:18px;float: left;margin-top: 2px;}
			.btn_manager{width:65px;height: 20px;line-height: 20px;text-align: center;border:1px #C0C0C0 solid;float: right;cursor: pointer;margin-top: 1px;margin-right: 2px;padding: 0px !important}
			.btn_hover{background: #5581DA;color: #fff;border-color: #5581DA;}
				
			.status{width: 30px;height: 20px;margin-right: 10px;display:-moz-inline-box;display:inline-block;float: left;}
			.status0{background: url('../images/pstatus0.png') center no-repeat;}
			.status1{background: url('../images/pstatus1.png') center no-repeat;}
			.status2{background: url('../images/pstatus2.png') center no-repeat;}
			.status3{background: url('../images/pstatus3.png') center no-repeat;}
			.status4{background: url('../images/pstatus4.png') center no-repeat;}
			.status13{background: url('../images/pstatus13.png') center no-repeat;}
			.status_txt{line-height: 20px;display:-moz-inline-box;display:inline-block;float: left;}
			.status_link{cursor: pointer;}
			
			.cke_wrapper{background:none !important;}
			.cke_editor td{min-height: 0px;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	<SCRIPT language="javascript" src="/workrelate/js/pointout.js"></script>
	</head>
	<%
		
	%>
	<BODY style="overflow: auto">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			if(canadd){
				RCMenu += "{新建,javascript:doAdd(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canquoteindex){
				RCMenu += "{引用指标,javascript:doQuoteIndex(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canedit){
				RCMenu += "{引用方案,javascript:doQuote(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				if(!"".equals(status) && "13".equals(status)){
					RCMenu += "{启用,javascript:doStart(this),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}else if(!"".equals(status) && !"0".equals(status)){
					RCMenu += "{禁用,javascript:doForbidden(this),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
				RCMenu += "{保存,javascript:doSave(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				
				RCMenu += "{提交,javascript:doSubmit(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canaudit){
				RCMenu += "{批准,javascript:doApprove(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				
				RCMenu += "{退回,javascript:doReturn(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canback){
				RCMenu += "{取消,javascript:doBack(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="form1" name="form1" action="ProgramOperation.jsp" method="post">
			<input type="hidden" name="programid" value="<%=programid %>">
			<input type="hidden" name="resourceid" value="<%=resourceid %>">
			<input type="hidden" name="programtype" value="<%=programtype %>">
			<input type="hidden" id="quoteid" name="quoteid" value="">
			<input type="hidden" id="operation" name="operation" value="">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				</colgroup>
				<tr>
					<td height="1" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<div class="tabpanel">
							<%if(ismonth==1){ %><div class="tab <%if(programtype.equals("1")){ %>tab_click<%} %>" onclick="changeType(1)">月度</div><%} %>
							<%if(isquarter==1){%><div class="tab <%if(programtype.equals("2")){ %>tab_click<%} %>" onclick="changeType(2)">季度</div><%} %>
							<%if(ishyear==1){ %><div class="tab <%if(programtype.equals("3")){ %>tab_click<%} %>" onclick="changeType(3)">半年</div><%} %>
							<%if(isfyear==1){ %><div class="tab <%if(programtype.equals("4")){ %>tab_click<%} %>" onclick="changeType(4)">年度</div><%} %>
							<div class="tab2_panel" style="width: 1px;border-right: 0px;"></div>
							<div class="maintitle"><%=cmutil.getPerson(resourceid) %>绩效考核方案设置</div>
						</div>
						<%if(programid.equals("") && !canedit){ %>
						<font style="color: red;font-size: 13px;margin-left: 5px;">暂未设置相应考核方案！</font>
						<%}else{ %>
						<div style="width: 100%;height: 28px;border-bottom: 1px #E7E7E7 solid;">
							<div style="width: auto;height: 28px;float: left;line-height:20px;">
								<%if(canedit){%>
									<div style="float: left;font-size: 13px;font-weight: bold;">生效日期：</div>
									<div class="btn_browser2" style="margin-top: 0px;" onclick="onShowDate('startdateSpan','startdate')"></div>
			              			<div id="startdateSpan" class="txt_browser2">
			              				<%if(!startdate.equals("")){%><%=startdate %><%}else{ %>
			              				<IMG src="/images/BacoError_wev8.gif" align="absMiddle" />
			              				<%} %>
			              			</div>
			              			<input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate %>">
								<%}else{ %><font style="font-size: 13px;font-weight: bold;"><%=programname %></font><%} %>
							</div>
							<div style="width: auto;height: 28px;float: left;margin-left: 10px;">
								<%if(status.equals("")){ %>
									<span class="status status4"></span>
								<%}else{ %>
									<span class="status status<%=status %>"></span>
								<%} %>
								<%if(status.equals("1")){ %>
									<span class="status_txt">待审批人：<%=cmutil.getPerson(RightUtil.getUnAuditProgramHrm(programid)) %></span>
								<%} %>
							</div>
							<%if(noprogram){ %>
							<div style="width: auto;line-height: 20px;float: left;margin-left: 10px;color:red;">
								<%=nomsg %>
							</div>
							<%} %>
							<div id="operate_panel" style="width: auto;height: 28px;float: right;">
								<%if(canadd){%>
								<div class="btn1 btn" onclick="doAdd();" title="建立新考核方案">新建</div>
								<%} %>
								<%if(canquoteindex){%>
								<div class="btn1 btn" onclick="doQuoteIndex();" title="引用其他方案指标">引用指标</div>
								<%} %>
								<%if(canedit){%>
								<div class="btn1 btn" onclick="doQuote();" title="引用其他方案">引用方案</div>
								<%if(!"".equals(status) && "13".equals(status)){%>
									<div class="btn1 btn" onclick="doStart();" title="启用方案">启用</div>
								<%} else if(!"".equals(status) && !"0".equals(status)){%>
									<div class="btn1 btn" onclick="doForbidden();" title="禁用方案">禁用</div>
								<%}%>
								<div class="btn1 btn" onclick="doSave();" title="保存为草稿">保存</div>
								<div class="btn1 btn" onclick="doSubmit();" title="保存并提交">提交</div>
								<%} %>
								<%if(canaudit){ %>
								<div class="btn1 btn" onclick="doApprove();" title="批准考核方案">批准</div>
								<div class="btn1 btn" onclick="doReturn();" title="退回考核方案">退回</div>
								<%} %>
								<%if(canback){%>
								<div class="btn1 btn" onclick="doBack();" title="取消新建考核方案">取消</div>
								<%} %>
							</div>
						</div>
						<div class="title_panel">
							<div class="title_txt">考核明细</div>
							<%if(canedit){%><div style="width: auto;float: right;"><div class="btn2 btn" onclick="doAddRow1()">添加</div><div class="btn2 btn" onclick="doDelRow1()">删除</div></div><%} %>
						</div>
						<table id="maintable1" class="maintable" cellspacing="0" cellpadding="0" border="0">
							<colgroup><%if(canedit){%><col width="4%"/><col width="12%"/><%}else{ %><col width="16%"/><%} %><col width="20%"/><col width="47%"/><col width="8%"/><col width="9%"/></colgroup>
							<tr class="header">
								<%if(canedit){%><td></td><%} %><td>分类</td><td>指标类型</td><td>指标描述</td><td>权重(%)</td><td>目标值</td>
							</tr>
							<%
								indexnum = 0;
								itemtype = 0;
								if(!programid.equals("")){
									rs.executeSql("select cate,accessitemid,description,rate,target1,target2 from GP_AccessProgramDetail where programid="+programid+" order by id");
									while(rs.next()){
							%>
							<tr id="tr1_<%=indexnum %>">
								<%if(canedit){%>
								<td>
									<input type="checkbox" _index="<%=indexnum %>"/>
								</td>
								<%} %>
								<td>
									<%if(canedit){%>
									<input class="input_txt" type="text" id="cate_<%=indexnum %>" name="cate_<%=indexnum %>" value="<%=Util.null2String(rs.getString("cate")) %>" maxlength="50" style="width: 95%"/>
									<%}else{ %>
									<%=Util.null2String(rs.getString("cate")) %>
									<%} %>
								</td>
								<td>
									<%if(canedit){%>
										<select id="accessitemid_<%=indexnum %>" name="accessitemid_<%=indexnum %>" onchange="targetBlur('<%=indexnum %>')">
										<%
											AccessItemComInfo.setTofirstRow();
											while(AccessItemComInfo.next()){
												if(AccessItemComInfo.getIsvalid().equals("1")){
										%>
											<option value="<%=AccessItemComInfo.getId() %>"
											<%if(Util.null2String(rs.getString("accessitemid")).equals(AccessItemComInfo.getId())){ 
												itemtype=Util.getIntValue(AccessItemComInfo.getType(),0); %> selected="selected" <%} %>
											><%=AccessItemComInfo.getName() %>
											<%if(!"".equals(AccessItemComInfo.getUnit())){ %>[<%=AccessItemComInfo.getUnit() %>]<%} %>
											<%if(!"".equals(AccessItemComInfo.getFormula()) && !"0".equals(AccessItemComInfo.getFormula())){
												if("11".equals(AccessItemComInfo.getFormula())){
													%>[完成值/目标值*最大分制]
												<%}else if("12".equals(AccessItemComInfo.getFormula())){
													%>[<%=AccessItemComInfo.getFormuladetails().replace("gval","目标值").replace("cval","完成值")%>]
												<%}else if("13".equals(AccessItemComInfo.getFormula())){
													String fd = AccessItemComInfo.getFormuladetails();
													String[] farray = fd.split("\\.");
													if(farray!=null && farray.length!=0){
														fd = farray[farray.length-1];
													}
													%>[类:<%=fd%>]
												<%}else{
													%>[公式<%=AccessItemComInfo.getFormula() %>]
												<%}
											} %>
											</option>
										<%	}} %>
										</select>
									<%}else{ itemtype=Util.getIntValue(AccessItemComInfo.getType(Util.null2String(rs.getString("accessitemid"))),0);%>
										<%=AccessItemComInfo.getName(Util.null2String(rs.getString("accessitemid"))) %>
										<%if(!"".equals(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid")))) && !"0".equals(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))))){
											if("11".equals(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))))){
												%>[完成值/目标值*最大分制]
											<%}else if("12".equals(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))))){
												%>[<%=AccessItemComInfo.getFormuladetails(Util.null2String(rs.getString("accessitemid"))).replace("gval","目标值").replace("cval","完成值")%>]
											<%}else if("13".equals(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))))){
												String fd = AccessItemComInfo.getFormuladetails(Util.null2String(rs.getString("accessitemid")));
												String[] farray = fd.split("\\.");
												if(farray!=null && farray.length!=0){
													fd = farray[farray.length-1];
												}
												%>[类:<%=fd%>]
											<%}else{
												%>[公式<%=AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))) %>]
											<%}
										} %>
									<%} %>
								</td>
								<td>
									<%if(canedit){%>
										<textarea class="area_txt" id="desc_<%=indexnum %>" name="desc_<%=indexnum %>" ><%=Util.convertDB2Input(rs.getString("description")) %></textarea>
									<%}else{ %>
										<%=Util.toHtml(rs.getString("description")) %>
									<%} %>
								</td>
								<td>
									<%if(canedit){%>
									<input class="input_txt" type="text" id="rate_<%=indexnum %>" name="rate_<%=indexnum %>" value="<%=Util.null2String(rs.getString("rate")) %>"
										 onKeyPress="ItemNum_KeyPress('rate_<%=indexnum %>')" onBlur="checknumber('rate_<%=indexnum %>')" maxlength="100" style="width: 95%"/>
									<%}else{ %>
										<%=Util.null2String(rs.getString("rate")) %>
									<%} %>
								</td>
								<td>
									<%if(canedit){%>
									<input class="input_txt <%if(itemtype==2){%>mustinput<%} %>" type="text" id="target_<%=indexnum %>" name="target_<%=indexnum %>" value="<%if(itemtype==1){%><%=Util.null2String(rs.getString("target2")) %><%}else{ %><%=Util.null2String(rs.getString("target1")) %><%} %>" maxlength="100" style="width: 95%"
										onKeyPress="targetKeyPress('<%=indexnum %>')" onBlur="targetBlur('<%=indexnum %>')" />
									<%}else{ %>
										<%if(itemtype==1){%><%=Util.null2String(rs.getString("target2")) %><%}else{ %><%=Util.null2String(rs.getString("target1")) %><%} %><%if(!"".equals(AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))))){ %>(<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>)<%} %>
									<%} %>
								</td>
							</tr>
							<%			indexnum++;
									} 
								}
							%>
						</table>
						<table class="maintable" style="margin-top: 10px;" cellspacing="0" cellpadding="0" border="0">
							<tr class="header">
								<td style="text-align: left;">说明</td>
							</tr>
							<tr>
								<td style="padding:2px;height: 26px;" valign="top">
									<%if(canedit){%>
										<textarea id="remark" name="remark"><%=remark%></textarea>
									<%}else{ %>
										<%=remark %>
									<%} %>
								</td>
							</tr>
						</table>
						
						<div class="title_panel">
							<div class="title_txt">考核评分</div>
							<%if(canedit){%><div style="width: auto;float: right;"><div class="btn2 btn" onclick="doAddRow2()">添加</div><div class="btn2 btn" onclick="doDelRow2()">删除</div></div><%} %>
						</div>
						<table id="maintable2" class="maintable" cellspacing="0" cellpadding="0" border="0">
							<colgroup><%if(canedit){%><col width="4%"/><col width="46%"/><%}else{ %><col width="50%"/><%} %><col width="50%"/></colgroup>
							<tr class="header">
								<%if(canedit){%><td></td><%} %><td>评分人</td><td>权重(%)</td>
							</tr>
							<%
								indexnum2 = 0;
								String checkuserid = "";
								String checkusername = "";
								if(!programid.equals("")){
									rs.executeSql("select userid,rate from GP_AccessProgramCheck where programid="+programid);
									while(rs.next()){
										checkuserid = Util.null2String(rs.getString("userid"));
										if(checkuserid.equals("-1")){
											checkusername = managername;
										}else{
											checkusername = cmutil.getPerson(checkuserid);
										}
							%>
							<tr id="tr2_<%=indexnum2 %>">
								<%if(canedit){%>
								<td>
									<input type="checkbox" _index="<%=indexnum2 %>"/>
								</td>
								<%} %>
								<td>
									<%if(canedit){%>
									<div class="btn_browser" onclick="onShowHrm('userid_<%=indexnum2 %>','useridSpan_<%=indexnum2 %>')"></div>
									<div class="txt_browser" id="useridSpan_<%=indexnum2 %>"><%=checkusername %></div>
									<div class="btn_manager btn" onclick="selectManager('userid_<%=indexnum2 %>','useridSpan_<%=indexnum2 %>')">直接上级</div>
									<input type="hidden" id="userid_<%=indexnum2 %>" name="userid_<%=indexnum2 %>" value="<%=checkuserid %>"/>
									<%}else{ %>
										<%=checkusername %>
									<%} %>
								</td>
								<td>
									<%if(canedit){%>
									<input class="input_txt" type="text" id="crate_<%=indexnum2 %>" name="crate_<%=indexnum2 %>" value="<%=Util.null2String(rs.getString("rate")) %>"
										onKeyPress="ItemNum_KeyPress('crate_<%=indexnum2 %>')" onBlur="checknumber('crate_<%=indexnum2 %>')" maxlength="100" style="width: 95%"/>
									<%}else{ %>
										<%=Util.null2String(rs.getString("rate")) %>
									<%} %>
								</td>
							</tr>
							<%			indexnum2++;
									} 
								}
							%>
						</table>
						
						<div class="title_panel">
							<div class="title_txt">考核审批</div>
						</div>
						<table class="maintable" cellspacing="0" cellpadding="0" border="0">
							<tr>
								<td width="50%" style="height: 28px;">
									<%if(canedit){%>
									<div class="btn_browser" onclick="onShowMutiHrm('auditids','auditidsSpan')"></div>
									<div class="txt_browser" id="auditidsSpan"><%=auditnames %></div>
									<div class="btn_manager btn" onclick="selectManager2('auditids','auditidsSpan')">上级的上级</div>
									<input type="hidden" id="auditids" name="auditids" value="<%=auditids %>"/>
									<%}else{ %>
										<%=auditnames %>
									<%} %>
								</td>
								<td width="50%"></td>
							</tr>
						</table>
						
						<div style="width: 100%;height: 10px;font-size: 0px;"></div>
						<%if(!programid.equals("")){  %>
						<div style="width: 50%;float: left;">
						<%
							rs.executeSql("select operator,operatedate,operatetime,operatetype from GP_AccessProgramLog where programid="+programid+" order by operatedate desc,operatetime desc,id desc");
							if(rs.getCounts()>0){
						%>
							<div class="title_panel">
								<div class="title_txt" style="color: #808080;">操作日志</div>
							</div>
						<%		String logoperator = "";
								while(rs.next()){
									logoperator = Util.null2String(rs.getString("operator"));
									if(logoperator.equals("0")){
										logoperator = "系统";
									}else{
										logoperator = cmutil.getPerson(logoperator);
									}
						%>
							<div style="color: #808080;"><%=logoperator %>&nbsp;&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>&nbsp;&nbsp;&nbsp;<%=cmutil.getProgramOperateType(rs.getString("operatetype")) %></div>
						<%		}
							}
						%>
						</div>
						<div style="width: 40%;float: left;">
						<%
							rs.executeSql("select id,programname,userid,startdate,programtype,status from GP_AccessProgram where userid="+resourceid+" and programtype="+programtype+" and id<>"+programid+" order by startdate desc");
							if(rs.getCounts()>0){
						%>
							<div class="title_panel">
								<div class="title_txt">其他考核方案</div>
							</div>
						<%
								while(rs.next()){
						%>
							<div><a href="ProgramView.jsp?resourceid=<%=resourceid %>&programid=<%=rs.getString("id") %>"><%=Util.null2String(rs.getString("programname")) %></a></div>
						<%		}
							}
						%>
						</div>
						<%} %>
						
						<%} %>
					</td>
					<td></td>
				</tr>
			</table>
			<input type="hidden" id="indexnum" name="indexnum" value="<%=indexnum %>" />
			<input type="hidden" id="indexnum2" name="indexnum2" value="<%=indexnum2 %>" />
		</form>
		<%if(canedit){ %>
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
		<%} %>
		<script type="text/javascript" defer="defer">
			var loadstr = "<img src='../images/loading2.gif'/>";
			var itemMap = new Map();
			jQuery(document).ready(function(){
				<%
					AccessItemComInfo.setTofirstRow();
					while(AccessItemComInfo.next()){
				%>
					itemMap.put("<%=AccessItemComInfo.getId()%>","<%=AccessItemComInfo.getType() %>");
				<%	} %>
				
				<%if(isrefresh.equals("1")){%>
					refreshOpener();
				<%}%>

				jQuery("div.btn").live("mouseover",function(){
					jQuery(this).addClass("btn_hover");
				}).live("mouseout",function(){
					jQuery(this).removeClass("btn_hover");
				});

				<%if(canedit){ %>
				//初始化编辑器
				CkeditorExt.initEditor("form1","remark","<%=user.getLanguage()%>","",150);
				<%}%>
			});
			<%if(canaudit){ %>
			function doApprove(obj) {
			    confirmStyle("确定批准此考核方案?",function(){
			        jQuery("#operation").val("approve");
					showload(obj);
					jQuery("#form1").submit();
			    });
			}
			function doReturn(obj) {
			    confirmStyle("确定退回此考核方案?",function(){
			        jQuery("#operation").val("return");
					showload(obj);
					jQuery("#form1").submit();
			    });
			}
			<%}%>
			
			<%if(canquoteindex){ %>
			    function doQuoteIndex(obj){
				    var diag;
				    try{
						var _parentWin = window;
					    while (_parentWin != _parentWin.parent) {
						   if (_parentWin.parent.document.getElementsByTagName("FRAMESET").length > 0 && _parentWin == _parentWin.parent) break;
							     _parentWin = _parentWin.parent;
						   }
						   if(_parentWin.document.getElementsByTagName("FRAMESET").length > 0){
							    diag = new Dialog();
						   }else{
							    diag = new _parentWin.Dialog();
						   }
				    }catch(e){
						diag = new Dialog();
				    }
				    diag.Title = "引用方案指标";
					diag.URL = "/systeminfo/BrowserMain.jsp?url=/performance/program/ProgramBrowser.jsp?param=<%=programtype%>_<%=programid%>";
					diag.Width = 700;
					diag.Height = 600;
					diag.callback=function(datas){
					  if (datas) {
				    	if(datas.id!="" && datas.id!="0"){
				    	    confirmStyle("确定引用"+datas.name+"的考核指标?",function(){
					                jQuery("#quoteid").val(datas.id);
									jQuery("#operation").val("quoteindex");
									showload(obj);
									jQuery("#form1").submit();
					        });
						}
				      }
					};
					diag.show();
				  }
			<%}%>
			
			<%if(canedit){ %>
			function doSave(obj) {
				if(checkRate()){
					jQuery("#operation").val("save");
					//obj.disabled = true;
					showload(obj);
					jQuery("#form1").submit();
				}
			}
			function doForbidden(obj){
			    confirmStyle("确定禁用考核方案?",function(){
			       if(checkRate()){
			         jQuery("#operation").val("forbidden");
					 //obj.disabled = true;
					 showload(obj);
					 jQuery("#form1").submit();
			       }
			    });
			}
			function doStart(obj) {
			    confirmStyle("确定启用考核方案?",function(){
			       if(checkRate()){
			         jQuery("#operation").val("start");
					 //obj.disabled = true;
					 showload(obj);
					 jQuery("#form1").submit();
			       }
			    });
			}
			function doSubmit(obj) {
			    confirmStyle("确定提交考核方案?",function(){
			       if(checkRate()){
			         jQuery("#operation").val("submit");
					 //obj.disabled = true;
					 showload(obj);
					 jQuery("#form1").submit();
			       }
			    });
			}
			function checkRate(){
				if(jQuery("#startdate").val()==""){
					alertStyle("请选择生效日期!");
					return false;
				}  
				var ratesum1 = 0;
				var num1 = jQuery("#indexnum").val();
				for(var i=0;i<num1;i++){
					var rateobj = jQuery("#rate_"+i);
					if(rateobj.length>0){
						ratesum1 += isNaN(parseFloat(rateobj.val()))?0:parseFloat(rateobj.val());
					}
				}
				if(ratesum1!=100){
					alertStyle("考核项权重设置不正确,权重总和需等于100!");
					return false;
				}
				var ratesum2 = 0;
				var num2 = jQuery("#indexnum2").val();
				for(var i=0;i<num2;i++){
					var rateobj = jQuery("#crate_"+i);
					if(rateobj.length>0){
						ratesum2 += isNaN(parseFloat(rateobj.val()))?0:parseFloat(rateobj.val());
					}
				}
				if(ratesum2!=100){
					alertStyle("评分人权重设置不正确,权重总和需等于100!");
					return false;
				}

				var items = new Array();
				var descs = new Array();
				for(var i=0;i<num1;i++){
					var itemobj = jQuery("#accessitemid_"+i);
					var descobj = jQuery("#desc_"+i);
					if(itemobj.length>0){
						for(var j=0;j<items.length;j++){
							if(itemobj.val()==items[j] && descobj.val()==descs[j]){
								alertStyle("相同指标类型的指标描述不能相同!");
								return false;
							}
						}
						items.push(itemobj.val());
						descs.push(descobj.val());
					}
				}

				var cansubmit = true;
				jQuery("input.mustinput").each(function(){
					if(jQuery(this).val()==""){
						cansubmit = false;
					}
				});
				if(cansubmit==false){
					alertStyle("定量指标需填写目标值！");
					return false;
				}
				return true;
			}
			var rowindex = <%=indexnum%>;
			function doAddRow1(){
				var trstr = ""
				+"<tr id=\"tr1_"+rowindex+"\">"
				+"	<td>"
				+"		<input type=\"checkbox\" _index=\""+rowindex+"\" />"
				+"	</td>"
				+"	<td>"
				+"		<input class=\"input_txt\" type=\"text\" id=\"cate_"+rowindex+"\" name=\"cate_"+rowindex+"\"  maxlength=\"50\" style=\"width: 95%\"/>"
				+"	</td>"
				+"	<td>"
				+"		<select id=\"accessitemid_"+rowindex+"\" name=\"accessitemid_"+rowindex+"\"  onchange=\"targetBlur('"+rowindex+"')\">"
					<%
							AccessItemComInfo.setTofirstRow();
							while(AccessItemComInfo.next()){
								if(AccessItemComInfo.getIsvalid().equals("1")){
						%>
				+"			<option value=\"<%=AccessItemComInfo.getId() %>\""
							<%if(Util.null2String(rs.getString("accessitemid")).equals(AccessItemComInfo.getId())){ 
								itemtype=Util.getIntValue(AccessItemComInfo.getType(),0); %> 
				+"		selected=\"selected\"" 
							<%}} %>
				+"><%=AccessItemComInfo.getName() %>"
							<%if(!"".equals(AccessItemComInfo.getUnit())){ %>
				+"[<%=AccessItemComInfo.getUnit() %>]"
							<%} %>
							<%if(!"".equals(AccessItemComInfo.getFormula()) && !"0".equals(AccessItemComInfo.getFormula())){
								if("11".equals(AccessItemComInfo.getFormula())){				
				%>
				+"[完成值/目标值*最大分制]"
				<%} else if("12".equals(AccessItemComInfo.getFormula())){%>
				+"[<%=AccessItemComInfo.getFormuladetails().replace("gval","目标值").replace("cval","完成值")%>]"
				<%} else if("13".equals(AccessItemComInfo.getFormula())){
					String fd = AccessItemComInfo.getFormuladetails();
					String[] farray = fd.split("\\.");
					if(farray!=null && farray.length!=0){
						fd = farray[farray.length-1];
					}
				%>
				+"[类:<%=fd%>]"	
				<%}else{%>
				+"[公式<%=AccessItemComInfo.getFormula() %>]"
							<%}} %>
				+"</option>"
						<%	} %>
				+"		</select>"
				+"	</td>"
				+"	<td>"
				+"		<textarea class=\"area_txt\" id=\"desc_"+rowindex+"\" name=\"desc_"+rowindex+"\" ></textarea>"
				+"	</td>"
				+"	<td>"
				+"		<input class=\"input_txt\" type=\"text\" id=\"rate_"+rowindex+"\" name=\"rate_"+rowindex+"\" onKeyPress=\"ItemNum_KeyPress('rate_"+rowindex+"')\" onBlur=\"checknumber('rate_"+rowindex+"')\" maxlength=\"100\" style=\"width: 95%\"/>"
				+"	</td>"
				+"	<td>"
				+"		<input class=\"input_txt\" type=\"text\" id=\"target_"+rowindex+"\" name=\"target_"+rowindex+"\" onKeyPress=\"targetKeyPress('"+rowindex+"')\" onBlur=\"targetBlur('"+rowindex+"')\" maxlength=\"100\" style=\"width: 95%\"/>"
				+"	</td>"
				+"</tr>";
				
				jQuery("#maintable1").append(trstr);
				targetBlur(rowindex);
				rowindex++;
				jQuery("#indexnum").val(rowindex);
				
			}
			function doDelRow1(){
				var checks = jQuery("#maintable1").find("input:checked");
				if(checks.length>0){
				    confirmStyle("确定删除选择明细项?",function(){
			          checks.each(function(){
							var _index = jQuery(this).attr("_index");
							jQuery("#tr1_"+_index).remove();
						});
			        });
				}else{
					alertStyle("请选择删除项!");
				}
			}
			var rowindex2 = <%=indexnum2%>;
			function doAddRow2(){
				var trstr = ""
				+"<tr id=\"tr2_"+rowindex2+"\">"
				+"	<td>"
				+"		<input type=\"checkbox\" _index=\""+rowindex2+"\" />"
				+"	</td>"
				+"	<td>"
				+"		<div class=\"btn_browser\" onclick=\"onShowHrm('userid_"+rowindex2+"','useridSpan_"+rowindex2+"')\"></div>"
				+"		<div class=\"txt_browser\" id=\"useridSpan_"+rowindex2+"\"><img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/></div>"
				+"      <div class=\"btn_manager btn\" onclick=\"selectManager('userid_"+rowindex2+"','useridSpan_"+rowindex2+"')\">直接上级</div>"
				+"		<input type=\"hidden\" id=\"userid_"+rowindex2+"\" name=\"userid_"+rowindex2+"\" />"
				+"	</td>"
				+"	<td>"
				+"		<input class=\"input_txt\" type=\"text\" id=\"crate_"+rowindex2+"\" name=\"crate_"+rowindex2+"\" onKeyPress=\"ItemNum_KeyPress('crate_"+rowindex2+"')\" onBlur=\"checknumber('crate_"+rowindex2+"')\" maxlength=\"100\" style=\"width: 95%\" value=\"100\"/>"
				+"	</td>"
				+"</tr>";

				rowindex2++;
				jQuery("#indexnum2").val(rowindex2);
				jQuery("#maintable2").append(trstr);
			}
			function doDelRow2(){
				var checks = jQuery("#maintable2").find("input:checked");
				if(checks.length>0){
				    confirmStyle("确定删除选择考核人?",function(){
			          checks.each(function(){
							var _index = jQuery(this).attr("_index");
							jQuery("#tr2_"+_index).remove();
						});
			        });
				}else{
					alertStyle("请选择删除项!");
				}
			}
			function doQuote(obj){
			    var diag;
			    try{
					var _parentWin = window;
				    while (_parentWin != _parentWin.parent) {
					   if (_parentWin.parent.document.getElementsByTagName("FRAMESET").length > 0 && _parentWin == _parentWin.parent) break;
						     _parentWin = _parentWin.parent;
					   }
					   if(_parentWin.document.getElementsByTagName("FRAMESET").length > 0){
						    diag = new Dialog();
					   }else{
						    diag = new _parentWin.Dialog();
					   }
			    }catch(e){
					diag = new Dialog();
			    }
			    diag.Title = "引用方案";
				diag.URL = "/systeminfo/BrowserMain.jsp?url=/performance/program/ProgramBrowser.jsp?param=<%=programtype%>_<%=programid%>";
				diag.Width = 700;
				diag.Height = 600;
				diag.callback=function(datas){
				  if (datas) {
			    	if(datas.id!="" && datas.id!="0"){
			    	    confirmStyle("确定引用"+datas.name+"?",function(){
			                jQuery("#quoteid").val(datas.id);
							jQuery("#operation").val("quote");
							showload(obj);
							jQuery("#form1").submit();
			            });
					}
			      }
				};
				diag.show();
			}
			function onShowHrm(inputid,inputspan) {
			    var diag;
				    try{
						var _parentWin = window;
					    while (_parentWin != _parentWin.parent) {
						   if (_parentWin.parent.document.getElementsByTagName("FRAMESET").length > 0 && _parentWin == _parentWin.parent) break;
							     _parentWin = _parentWin.parent;
						   }
						   if(_parentWin.document.getElementsByTagName("FRAMESET").length > 0){
							    diag = new Dialog();
						   }else{
							    diag = new _parentWin.Dialog();
						   }
				    }catch(e){
						diag = new Dialog();
				    }
				    diag.Title = "选择评分人员";
					diag.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
					diag.Width = 555;
					diag.Height = 600;
					diag.callback=function(datas){
					  if (datas) {
				    	if(datas.id!=""){
				    	var canselect = false;
						if(datas.id=='<%=managerid%>'){
							canselect = checkUser(-1,inputid);
						}else{
							canselect = checkUser(datas.id,inputid);
						}
				    	
				    	if(canselect){
				    		$("#"+inputid).val(datas.id);
						    $("#"+inputspan).html(datas.name);
					    }else{
					    	$("#"+inputid).val("");
							$("#"+inputspan).html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
						}
					}else{
						$("#"+inputid).val("");
						$("#"+inputspan).html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
					}
				      }
					};
					diag.show();
			}
			function checkUser(selectid,inputid){
				var num = jQuery("#indexnum2").val();
				for(var i=0;i<num;i++){
					var userobj = jQuery("#userid_"+i);
					if(userobj.length>0 && userobj.attr("id")!=inputid){
						if(selectid==userobj.val()){
							alertStyle("评分人已存在!");
							return false;
						}
					}
				}
				return true;
			}
			function selectManager(inputid,inputspan){
				if('<%=managerid%>'!=''){
				   if(checkUser(-1,inputid)){
						if(checkUser('<%=managerid%>',inputid)){
							$("#"+inputid).val(-1);
				    		$("#"+inputspan).html("<%=managername%>");
						}
			   	   }
				}else{
				   alertStyle("直接上级不存在,请重新选择!");
				}
			}
			function onShowMutiHrm(inputid,inputspan) {
				var resourceids = $("#"+inputid).val();
				if(resourceids=="-1") resourceids = "<%=managerid2%>";
			    var diag;
				    try{
						var _parentWin = window;
					    while (_parentWin != _parentWin.parent) {
						   if (_parentWin.parent.document.getElementsByTagName("FRAMESET").length > 0 && _parentWin == _parentWin.parent) break;
							     _parentWin = _parentWin.parent;
						   }
						   if(_parentWin.document.getElementsByTagName("FRAMESET").length > 0){
							    diag = new Dialog();
						   }else{
							    diag = new _parentWin.Dialog();
						   }
				    }catch(e){
						diag = new Dialog();
				    }
				    diag.Title = "选择审批人员";
					diag.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+resourceids;
					diag.Width = 660;
					diag.Height = 600;
					diag.callback=function(datas){
					  if (datas) {
				    	if(datas.id!=""){
			    		    $("#"+inputid).val(datas.id);
					        $("#"+inputspan).html(datas.name);
						}else{
							$("#"+inputid).val("");
						    $("#"+inputspan).html("");
						}
				      }
					};
					diag.show();
			}
			function selectManager2(inputid,inputspan){
				if('<%=managerid2%>'!=''){
				   $("#"+inputid).val(-1);
	    		   $("#"+inputspan).html("<%=managername2%>");
				}else{
				   alertStyle("直接上级的上级不存在,请重新选择!");
				}
			}
			function targetKeyPress(_index){
				var itemid = $("#accessitemid_"+_index).val();
				var itemtype = itemMap.get(itemid);
				if(itemtype==2){
					ItemNum_KeyPress("target_"+_index);
				}
			}
			function targetBlur(_index){
				var itemid = $("#accessitemid_"+_index).val();
				var itemtype = itemMap.get(itemid);
				if(itemtype==2){
					checknumber("target_"+_index);
					$("#target_"+_index).addClass("mustinput");
				}else{
					$("#target_"+_index).removeClass("mustinput");
				}
			}
			<%}%>
			<%if(canadd){%>
			function doAdd(){
				window.location = "ProgramView.jsp?resourceid=<%=resourceid%>&programtype=<%=programtype%>&oldprogramid=<%=programid%>&viewtype=add";
			}
			<%}%>
			<%if(canback){%>
			function doBack(){
				window.location = "ProgramView.jsp?resourceid=<%=resourceid%>&programtype=<%=programtype%>&programid=<%=oldprogramid%>";
			}
			<%}%>
			
			function changeType(type){
				window.location = "ProgramView.jsp?resourceid=<%=resourceid%>&programtype="+type;
			}
			function showload(obj){
				if(obj!=null && typeof(obj)!="undefined"){
					obj.disabled = true;
				}
				jQuery("#operate_panel").html(loadstr);
			}
		</script>
	</BODY>
</HTML>