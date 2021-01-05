<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.pr.util.RightUtil"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CommonTransUtil" class="weaver.workrelate.util.CommonTransUtil" scope="page" />
<jsp:useBean id="SubComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.pr.util.OperateUtil" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");
//所有经理及计划报告确认人有权限查看
String userid = user.getUID()+"";
String year = Util.null2String(request.getParameter("year"));
String type1 = Util.null2String(request.getParameter("type1"));
String type2 = Util.null2String(request.getParameter("type2"));
String planid = Util.null2String(request.getParameter("planid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String isrefresh = Util.null2String(request.getParameter("isrefresh"));
String back = Util.null2String(request.getParameter("back"));
String clienttype = Util.null2String(request.getParameter("clienttype"));
String planname = "";
String status = "";
String auditids = "";
String remark = "";
String fileids = "";
String s_enddate = "";
String shareids = "";
String pshareids = "";

String currentdate = TimeUtil.getCurrentDateString();
String msg = "";
String viewdate = "";
String sql = "";
if(!planid.equals("")){
	sql = "select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
			+",(select top 1 operatedate+' '+operatetime from PR_PlanReportLog where PR_PlanReportLog.planid=PR_PlanReport.id and operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) as viewdate"
			+" from PR_PlanReport where isvalid=1 and id="+planid;
	if("oracle".equals(rs.getDBType())){
		sql = "select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
				+",(select v.viewdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as viewdate,planid from PR_PlanReportLog where operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) v where v.planid=PR_PlanReport.id and rownum=1) as viewdate"
				+" from PR_PlanReport where isvalid=1 and id="+planid;
	}
	rs.executeSql(sql);
	if(rs.next()){
		resourceid = Util.null2String(rs.getString("userid"));
		year = Util.null2String(rs.getString("year"));
		type1 = Util.null2String(rs.getString("type1"));
		type2 = Util.null2String(rs.getString("type2"));
		planname = Util.null2String(rs.getString("planname"));
		status = Util.null2String(rs.getString("status"));
		auditids = Util.null2String(rs.getString("auditids"));
		remark = Util.null2String(rs.getString("remark"));
		s_enddate = Util.null2String(rs.getString("enddate"));
		fileids = Util.null2String(rs.getString("fileids"));
		viewdate = Util.null2String(rs.getString("viewdate"));
		shareids = Util.null2String(rs.getString("shareids"));
	}else{
		out.print("<table width='100%'><tr><td align='center'>暂未开启任何计划报告周期！</td></tr></table>");
		return;
	}
}else{
	if(resourceid.equals("")){
		resourceid = userid;
	}
	//年份、类型取默认值
	if(year.equals("")){
		year = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_YEAR"));
		if(year.equals("")) year = currentdate.substring(0,4);
	}
	if(type1.equals("")){
		type1 = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_TYPE1"));
	}
	if(type2.equals("")){
		type2 = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_TYPE2_"+type1));
	}
}
	
//判断是否能查看
boolean canview = false;
boolean canedit = false;
boolean canaudit = false;
boolean istime = false;
boolean editshare = false;

int isweek = 0;       
int ismonth = 0;    
String reportaudit = "";
String reportview = "";
int wstarttype = 0;      
int wstartdays = 0;      
int wendtype = 0;        
int wenddays = 0;        
int mstarttype = 0;      
int mstartdays = 0;      
int mendtype = 0;        
int menddays = 0;        
String docsecid = "";
rs.executeSql("select * from PR_BaseSetting where resourceid=" + ResourceComInfo.getDepartmentID(resourceid) + " and resourcetype=3");
if(rs.next()){
	reportaudit = Util.null2String(rs.getString("reportaudit"));  
	reportview = Util.null2String(rs.getString("reportview"));
	docsecid = Util.null2String(rs.getString("docsecid")); 
	rs2.executeSql("select * from PR_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
	if(rs2.next()){
		isweek = Util.getIntValue(rs2.getString("isweek"),0);      
		ismonth = Util.getIntValue(rs2.getString("ismonth"),0);   
		wstarttype = Util.getIntValue(rs2.getString("wstarttype"),0);     
		wstartdays = Util.getIntValue(rs2.getString("wstartdays"),0);     
		wendtype = Util.getIntValue(rs2.getString("wendtype"),0);       
		wenddays = Util.getIntValue(rs2.getString("wenddays"),0);       
		mstarttype = Util.getIntValue(rs2.getString("mstarttype"),0);     
		mstartdays = Util.getIntValue(rs2.getString("mstartdays"),0);     
		mendtype = Util.getIntValue(rs2.getString("mendtype"),0);       
		menddays = Util.getIntValue(rs2.getString("menddays"),0); 
		if("".equals(docsecid) || "0".equals(docsecid)) docsecid = Util.null2String(rs2.getString("docsecid")); 
	}
}else{
	rs.executeSql("select * from PR_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
	if(rs.next()){
		isweek = Util.getIntValue(rs.getString("isweek"),0);      
		ismonth = Util.getIntValue(rs.getString("ismonth"),0);   
		reportaudit = Util.null2String(rs.getString("reportaudit"));  
		reportview = Util.null2String(rs.getString("reportview")); 
		wstarttype = Util.getIntValue(rs.getString("wstarttype"),0);     
		wstartdays = Util.getIntValue(rs.getString("wstartdays"),0);     
		wendtype = Util.getIntValue(rs.getString("wendtype"),0);       
		wenddays = Util.getIntValue(rs.getString("wenddays"),0);       
		mstarttype = Util.getIntValue(rs.getString("mstarttype"),0);     
		mstartdays = Util.getIntValue(rs.getString("mstartdays"),0);     
		mendtype = Util.getIntValue(rs.getString("mendtype"),0);       
		menddays = Util.getIntValue(rs.getString("menddays"),0);    
		docsecid = Util.null2String(rs.getString("docsecid")); 
	}
}
if(isweek!=1 && ismonth!=1) {
	out.print("<table width='100%'><tr><td align='center'>暂未开启任何计划报告周期！</td></tr></table>");
	return;//未启用任何考核
}
if(ismonth!=1 && type1.equals("1")) type1 = "";
if(isweek!=1 && type1.equals("2")) type1 = "";
if(type1.equals("")){
	if(isweek==1){ type1 = "2";}
	if(ismonth==1){ type1 = "1";}
}

if(type2.equals("")){
	if(type1.equals("2")) type2 = TimeUtil.getWeekOfYear(new Date())+"";
	if(type1.equals("1")) type2 = currentdate.substring(5,7);
	rs.executeSql("select count(id) from PR_PlanReport where userid="+resourceid+" and year="+year+" and type1="+type1+" and type2="+type2);
	if(rs.next() && rs.getInt(1)==0){
		if(type1.equals("1")){
			if(Integer.parseInt(type2)==1){
				year = (Integer.parseInt(year)-1)+"";
				type2 = "12";
			}else{
				type2 = (Integer.parseInt(type2)-1)+"";
			}
		}else if(type1.equals("2")){
			if(Integer.parseInt(type2)==1){
				year = (Integer.parseInt(year)-1)+"";
				type2 = TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+"";
			}else{
				type2 = (Integer.parseInt(type2)-1)+"";
			}
		}
	}
}

if(resourceid.equals(userid)){
	canview = true;
	canedit = true;
	editshare = true;//本人可编辑共享
}else if(ResourceComInfo.isManager(user.getUID(),resourceid)){
	canview = true;
	editshare = true;//上级可编辑共享
}else if((","+reportaudit+",").indexOf(","+userid+",")>-1){
	canview = true;
	editshare = true;//后台定义的审批人可编辑共享
}else if((","+reportview+",").indexOf(","+userid+",")>-1){
	canview = true;
}


//判断考核起止时间， 考核开始之前，不能查看
String basedate = "";
String begindate = "";
String enddate = "";
String titlestr = "";
int prevyear = Integer.parseInt(year);
int prevtype2 = Integer.parseInt(type2)-1;
int nextyear = Integer.parseInt(year);
int nexttype2 = Integer.parseInt(type2)+1;
String weekdate1 = "";
String weekdate2 = "";
int currentweek = TimeUtil.getWeekOfYear(new Date());
int currentmonth = Integer.parseInt(currentdate.substring(5,7));
if(type1.equals("1")){
	basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),Integer.parseInt(type2));
	begindate = TimeUtil.dateAdd(basedate,mstartdays*mstarttype);
	enddate = TimeUtil.dateAdd(basedate,menddays*mendtype);
	titlestr = "月";
	
	if(type2.equals("1")){
		prevyear = prevyear - 1;
		prevtype2 = 12;
	}
	if(type2.equals("12")){
		nextyear = nextyear + 1;
		nexttype2 = 1;
	}
}else if(type1.equals("2")){
	basedate = TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(Integer.parseInt(year),Integer.parseInt(type2)));
	weekdate1 = TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(Integer.parseInt(year),Integer.parseInt(type2)));
	weekdate2 = basedate;
	begindate = TimeUtil.dateAdd(basedate,wstartdays*wstarttype);
	enddate = TimeUtil.dateAdd(basedate,wenddays*wendtype);
	titlestr = "周";
	
	if(type2.equals("1")){
		prevyear = prevyear - 1;
		prevtype2 = TimeUtil.getMaxWeekNumOfYear(prevyear);
	}
	if(type2.equals(TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+"")){
		nextyear = nextyear + 1;
		nexttype2 = 1;
	}
}
if(planid.equals("")){
	if("oracle".equals(rs.getDBType())){
		sql = "select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
				+",(select v.viewdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as viewdate,planid from PR_PlanReportLog where operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) v where v.planid=PR_PlanReport.id and rownum=1) as viewdate"
				+" from PR_PlanReport"
				+" where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and userid="+resourceid;
	}else{
		sql = "select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
				+",(select top 1 operatedate+' '+operatetime from PR_PlanReportLog where PR_PlanReportLog.planid=PR_PlanReport.id and operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) as viewdate"
				+" from PR_PlanReport"
				+" where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and userid="+resourceid;
	}
	rs.executeSql(sql);
	if(rs.next()){
		planid = Util.null2String(rs.getString("id"));
		planname = Util.null2String(rs.getString("planname"));
		status = Util.null2String(rs.getString("status"));
		auditids = Util.null2String(rs.getString("auditids"));
		remark = Util.null2String(rs.getString("remark"));
		s_enddate = Util.null2String(rs.getString("enddate"));
		fileids = Util.null2String(rs.getString("fileids"));
		viewdate = Util.null2String(rs.getString("viewdate"));
		shareids = Util.null2String(rs.getString("shareids"));
	}
}
if(TimeUtil.dateInterval(currentdate,enddate)>=0) istime = true;
if(planid.equals("")){
	if(TimeUtil.dateInterval(begindate,currentdate)<0){
		msg = "此计划报告将在"+begindate+"开始提交";
	}else if(TimeUtil.dateInterval(currentdate,enddate)<0 || !canedit){
		msg = "此周期无数据";
	}
	
	planname = ResourceComInfo.getLastname(resourceid)+year+"年"+type2+titlestr+"工作总结及"+nextyear+"年"+nexttype2+titlestr+"工作计划";
	
}else{
	if(TimeUtil.dateInterval(currentdate, begindate)>0 || TimeUtil.dateInterval(currentdate,enddate)<0){
		//msg = "此计划报告将在"+begindate+"开始提交";
		canedit = false;
	}
}
String planname1 = year+"年"+type2+titlestr+"工作总结";
String planname2 = nextyear+"年"+nexttype2+titlestr+"工作计划";
String programid = "0";
String subCompanyId = ResourceComInfo.getSubCompanyID(resourceid);
String departmentId = ResourceComInfo.getDepartmentID(resourceid);
String companyId = SubComInfo.getCompanyid(subCompanyId);
String sql_pp = "select id,auditids,shareids from PR_PlanProgram where ("+
" (userid="+resourceid+" and (resourcetype=4 or resourcetype is null))"+
" or (userid="+subCompanyId+" and resourcetype = 2)"+
" or (userid="+departmentId+" and resourcetype = 3)"+
" or (userid="+companyId+" and resourcetype = 1)"+
" ) and programtype="+type1+" order by resourcetype desc";
//System.out.println(sql_pp);
rs.executeSql(sql_pp);
if(rs.next()){
	programid = Util.null2String(rs.getString("id"));
	if(planid.equals("")) auditids = Util.null2String(rs.getString("auditids"));
	pshareids = Util.null2String(rs.getString("shareids"));
}

if(!canview){
	if((","+auditids+",").indexOf(","+userid+",")<0 && (","+shareids+","+pshareids+",").indexOf(","+userid+",")<0){
		if(!planid.equals("")){
			//查询是否审批过
			rs.executeSql("select count(id) from PR_PlanReportlog l where l.planid="+planid+" and l.operatetype in (4,5) and l.operator="+userid);
			if(rs.next() && rs.getInt(1)==0){
				msg = "您暂时无权限查看！";
			}
			//response.sendRedirect("../util/Message.jsp?type=1");
		}else{
			msg = "您暂时无权限查看！";
		}
	}
}
if((","+auditids+",").indexOf(","+userid+",")>-1) editshare = true;//审批人可编辑共享

if(status.equals("1") || status.equals("3")) canedit = false;
if(s_enddate.equals("")) s_enddate = enddate;
canaudit = RightUtil.isCanAuditPlan(planid,userid);


int islog = Util.getIntValue(request.getParameter("islog"),1);
if(!planid.equals("") && islog==1){
	OperateUtil.addPlanLog(userid,planid,0);
}

//非草稿状态下本人可重新编写总结计划
boolean canreset = RightUtil.isCanResetPlan(planid,userid);
//草稿状态下本人可删除总结计划
boolean candel = RightUtil.isCanDelPlan(planid,userid);

boolean canupload = false;//附件上传

int inttype2 = Integer.parseInt(type2);

int index1 = 0;
int index2 = 0;
int showindex = 0;

List showfields1 = new ArrayList();
List hidefields1 = new ArrayList();
List showfields2 = new ArrayList();
List hidefields2 = new ArrayList();
List showstemp = new ArrayList();
List fieldlist = new ArrayList();
String[] feilds = null;
String showname = "";
String fieldname = "";
String ismust="";

boolean hascate1 = false;
boolean hascate2 = false;

//创建任务
boolean createtask = weaver.workrelate.util.TransUtil.istask();
//是否启用绩效考核
boolean isperformance = weaver.workrelate.util.TransUtil.isperformance();

if(planid.equals("")) editshare = false;//未保存过的报告不能进行共享

remark = Util.convertDB2Input(remark);
String spanInfo = "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="author" content="Weaver E-Mobile Dev Group" />
		<meta name="description" content="Weaver E-mobile" />
		<meta name="keywords" content="weaver,e-mobile" />
		<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
		<meta name="format-detection" content="telephone=no"/>
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<!-- ajax提交form表单 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery.form.js'></script>
		<script type='text/javascript' src='/mobile/plugin/task/js/task.js'></script>
		<!-- 多行文本框自动更改高度 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery.textarea.autoheight.js'></script>
		<!--日期时间控件-->
		<link rel="stylesheet" href="/mobile/plugin/widget/mobiscroll/mobiscroll.min_wev8.css" />
		<script type="text/javascript" src="/mobile/plugin/widget/mobiscroll/mobiscroll.min_wev8.js"></script>
		<!-- 遮罩层 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/showLoading/js/jquery.showLoading.js'></script>
		<link rel="stylesheet" href="/mobile/plugin/task/js/showLoading/css/showLoading.css" />
		
		<link rel="stylesheet" href="/mobile/plugin/performance/css/perf.css" />
		<link rel="stylesheet" href="/mobile/plugin/performance/css/add.css" />
		<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
		<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
		<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css"/>
		<style type="text/css">
			#header{display: block;}
			*{font-size:14px;font-family: arial,微软雅黑;}
			.panel{float: left;}
			.week_txt{float: left;line-height: 28px;width: 56px;text-align: center;margin: 0px;padding: 0px;font-weight: normal;font-size: 12px;cursor: pointer;}
			.week_btn1{float: left;width: 16px;height: 28px;margin: 0px;padding: 0px;background: url('images/prev.png') center no-repeat;}
			.week_prev{cursor: pointer;}
			.week_prev_hover{background: url('images/prev_hover.png') center no-repeat;}
			.week_btn2{float: left;width: 16px;height: 28px;;margin: 0px;padding: 0px;background: url('images/next.png') center no-repeat;}
			.week_next{cursor: pointer;}
			.week_next_hover{background: url('images/next_hover.png') center no-repeat;}
			.week_show{width: 160px;line-height: 28px;text-align: center;color: #969696;float: right;font-weight: normal;font-size: 12px;}
			.weekselect{width: 302px;height:auto;border: 1px #ECECEC solid;position: absolute;display: none;background: #fff;z-index: 100;overflow:hidden;}
			.weekoption{width: 50px;line-height:22px;text-align:center;float:left;color:#999999;font-size:12px;}
			.weekoption_current{background: #F8EFEF;}
			.weekoption_hover,.weekoption_select{background: #0080C0;color: #fff;}
			.maintable,.maintable2{width: 100%;border-collapse: collapse;}
			.maintable td{white-space: normal;word-break:break-all;}
			.maintable2 td{border-bottom: 1px #F6F6F6 solid;word-break:break-all;font-size:13px;height:30px;}
			.maintable td.title{background: #DDD9C3;}
			.maintable td.title2{font-weight: bold;background: #F8F8F8;text-align: right;padding-right: 8px;}
			.maintable tr.header1 td,.maintable2 tr.header1 td{border-bottom: 1px #59D445 solid;color: #000000;font-weight: bold;background:#f8f8f8;height:30px;padding-left:5px;padding-top:6px !important;padding-bottom:6px !important;line-height: 28px;cursor: pointer;}
			.maintable td .icheck{margin-bottom: 5px;margin-left: 1px;vertical-align: middle;}
			.head_more{width: auto;padding-left: 5px;font-weight: bold;display: none;}
			.head_more1{width: auto;float:right;padding-right: 3px;font-weight: bold;display: none;}
			.btn_add{width: 20px;height: 20px;background: url('images/add.png');cursor: pointer;float: left;margin-right: 5px;}
			.btn_add_hover{background: url('images/add_hover.png');}
			.btn_del{width: 20px;height: 20px;background: url('images/delete.png');cursor: pointer;float: left;}
			.btn_del_hover{background: url('images/delete_hover.png');}
			.btn_con{width: auto;;height: 20px;float:right;right: 2px;top:6px;}
			.newfb{width: 26px;height: 25px;line-height: 25px;text-align: center;background: #fff;color: red;position: absolute;right: 0px;bottom: 0px;font-style: italic;font-weight: normal;font-size:12px;}
			.controlTdHeader {margin: 10px 0px 0 0px;color: #333;border-bottom: 1px solid #cd682b !important;padding: 2px 10px !important;font-size: 14px;border-top:0 !important}
	</style>
	<title><%=planname %></title>
	</head>
	<body id="body">
		<form id="form1" name="form1" action="/mobile/plugin/workrelate/PlanOperation.jsp" method="post">
		<table class="taskTable" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
					<div id="topmain" class="topmain"><!-- 顶部 -->
						<div id="header">
						   <div id="divCoworkName"><span onclick="doBack();"><%="".equals(planname)?"无计划报告":planname %></span></div>
						   <div id="divCoworkSub" >
						     <span id="spaninfo"></span>
				  	       </div>
						</div>
					</div>
				</td>
			</tr>
		</table>
		<div id="tabblank" class="tabblank"></div><!-- 站位顶部导航FIXED的空白 -->
		<input type="hidden" name="planid" value="<%=planid %>"/>
		<input type="hidden" name="planname" value="<%=planname %>"/>
		<input type="hidden" name="resourceid" value="<%=resourceid %>"/>
		<input type="hidden" name="auditids" value="<%=auditids %>"/>
		<input type="hidden" name="year" value="<%=year %>"/>
		<input type="hidden" name="type1" value="<%=type1 %>"/>
		<input type="hidden" name="type2" value="<%=type2 %>"/>
		<input type="hidden" id="operation" name="operation" value=""/>
		<div class="tabpanel">
			<ul>
			<%if(isweek==1){ %><li class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" tdata="2">周报</li><%} %>
			<%if(ismonth==1){ %><li class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" tdata="1">月报</li><%} %>
		    </ul>
		</div>
	                <%if(!msg.equals("")){ %>
	                    <table class="dtable">
							   <colgroup><col width="50%" /><col width="50%" /></colgroup>
							   <tbody>	
							     <tr>
							     <td>选择年份<span class="Design_FSelect_Fielddom">
							     <select id="syear" class="MADFS_Left_Select">
							       <% 
										int currentyear = Integer.parseInt(currentdate.substring(0,4));
										for(int i=2013;i<(currentyear+3);i++){ %>
										  <option value="<%=i %>" <%if(Integer.parseInt(year)==i){ %>selected<%} %>><%=i %></option>
								  <%} %>
							     </select></span></td>
							     <%if(type1.equals("1")){ %>
							     <td>
							        选择月份<span class="Design_FSelect_Fielddom">
									<select id="smonth" class="MADFS_Left_Select">
									<%for(int i=1;i<13;i++){ %>
									    <option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>月</option>
									<%} %>
									</select></span></td>
									<%}else if(type1.equals("2")){ %>
									<td><span style="float:left;line-height:30px;">选择周</span>
									<div class="panel" style="width: 91px;margin-left:5px;">
									<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>" <%if(inttype2!=1){ %> onclick="changeType2(<%=inttype2-1 %>)" title="上一周" <%} %>></div>
									<div id="weekpanel" class="week_txt" title="<%=weekdate1+" 至 "+weekdate2 %>">第&nbsp;<%=type2 %>&nbsp;周</div>
									<div class="week_btn2 <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %>week_next<%} %>" <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %> onclick="changeType2(<%=inttype2+1 %>)" title="下一周" <%} %>></div>
									</div></td>
									<%}%>
							     </tr>
							   </tbody>
							</table>
					<font style="color: red;font-size: 13px;margin-left: 5px;height:26px;line-height:26px;"><%=msg %></font>
					<%}else{ 
						//读取总结及计划的显示列
						//String sql = "";
						String showsql1 = "select showname,fieldname,customname,showwidth,isshow,ismust from PR_PlanProgramDetail where 1=1";
						String showsql2 = "select showname,fieldname,customname,showwidth2,isshow2,ismust2 from PR_PlanProgramDetail where 1=1";
						if(planid.equals("")){
							showsql1 += " and programid="+programid + " order by showorder";
							showsql2 += " and programid="+programid + " order by showorder2";
							rs.executeSql("select showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2,ismust,ismust2 from PR_PlanProgramDetail where programid="+programid);
							while(rs.next()){
								fieldname = Util.null2String(rs.getString("fieldname"));
								fieldlist.add(new String[]{fieldname,Util.null2String(rs.getString("showname"))
										,Util.null2String(rs.getString("customname")),Util.null2String(rs.getString("isshow"))
										,Util.null2String(rs.getString("showorder")),Util.null2String(rs.getString("showwidth"))
										,Util.null2String(rs.getString("isshow2")),Util.null2String(rs.getString("showorder2"))
										,Util.null2String(rs.getString("showwidth2"))});
					%>
						<input type="hidden" id="fieldname_<%=showindex %>" name="fieldname_<%=showindex %>" value="<%=fieldname %>"/>
						<input type="hidden" id="<%=fieldname %>_showname" name="<%=fieldname %>_showname" value="<%=Util.null2String(rs.getString("showname")) %>"/>
						<input type="hidden" id="<%=fieldname %>_isshow" name="<%=fieldname %>_isshow" value="<%=Util.null2String(rs.getString("isshow")) %>"/>
						<input type="hidden" id="<%=fieldname %>_ismust" name="<%=fieldname %>_ismust" value="<%=Util.null2String(rs.getString("ismust")) %>"/>
						<input type="hidden" id="<%=fieldname %>_showorder" name="<%=fieldname %>_showorder" value="<%=Util.null2String(rs.getString("showorder")) %>"/>
						<input type="hidden" id="<%=fieldname %>_showwidth" name="<%=fieldname %>_showwidth" value="<%=Util.null2String(rs.getString("showwidth")) %>"/>
						<input type="hidden" id="<%=fieldname %>_isshow2" name="<%=fieldname %>_isshow2" value="<%=Util.null2String(rs.getString("isshow2")) %>"/>
						<input type="hidden" id="<%=fieldname %>_ismust2" name="<%=fieldname %>_ismust2" value="<%=Util.null2String(rs.getString("ismust2")) %>"/>
						<input type="hidden" id="<%=fieldname %>_showorder2" name="<%=fieldname %>_showorder2" value="<%=Util.null2String(rs.getString("showorder2")) %>"/>
						<input type="hidden" id="<%=fieldname %>_showwidth2" name="<%=fieldname %>_showwidth2" value="<%=Util.null2String(rs.getString("showwidth2")) %>"/>
						<input type="hidden" id="<%=fieldname %>_customname" name="<%=fieldname %>_customname" value="<%=Util.null2String(rs.getString("customname")) %>"/>
					<%
							showindex++;}
						}else{
							showsql1 += " and planid="+planid + " order by showorder";
							showsql2 += " and planid="+planid + " order by showorder2";
						}
						rs.executeSql(showsql1);
						while(rs.next()){
							if(Util.getIntValue(rs.getString("isshow"),0)==1){
								ismust = Util.null2String(rs.getString("ismust"))!=null && !"".equals(Util.null2String(rs.getString("ismust")))?Util.null2String(rs.getString("ismust")):"0";
								showfields1.add(new String[]{Util.null2String(rs.getString("showname")),Util.null2String(rs.getString("fieldname"))
										,Util.null2String(rs.getString("customname")),Util.null2String(rs.getString("showwidth")),ismust});
							}else{
								hidefields1.add(new String[]{Util.null2String(rs.getString("showname")),Util.null2String(rs.getString("fieldname"))
										,Util.null2String(rs.getString("customname")),Util.null2String(rs.getString("showwidth"))});
							}
						}
						rs.executeSql(showsql2);
						while(rs.next()){
							if(Util.getIntValue(rs.getString("isshow2"),0)==1){
								ismust = Util.null2String(rs.getString("ismust2"))!=null && !"".equals(Util.null2String(rs.getString("ismust2")))?Util.null2String(rs.getString("ismust2")):"0";
								showfields2.add(new String[]{Util.null2String(rs.getString("showname")),Util.null2String(rs.getString("fieldname"))
										,Util.null2String(rs.getString("customname")),Util.null2String(rs.getString("showwidth2")),ismust});
								showstemp.add(Util.null2String(rs.getString("fieldname")));
							}else{
								hidefields2.add(new String[]{Util.null2String(rs.getString("showname")),Util.null2String(rs.getString("fieldname"))
										,Util.null2String(rs.getString("customname")),Util.null2String(rs.getString("showwidth2"))});
							}
						}
					%>
					<table class="dtable">
							   <colgroup><col width="50%" /><col width="50%" /></colgroup>
							   <tbody>	
							     <tr>
							     <td>选择年份<span class="Design_FSelect_Fielddom">
							     <select id="syear" class="MADFS_Left_Select">
							       <% 
										int currentyear = Integer.parseInt(currentdate.substring(0,4));
										for(int i=2013;i<(currentyear+3);i++){ %>
										  <option value="<%=i %>" <%if(Integer.parseInt(year)==i){ %>selected<%} %>><%=i %></option>
								  <%} %>
							     </select></span></td>
							     <%if(type1.equals("1")){ %>
							     <td>
							        选择月份<span class="Design_FSelect_Fielddom">
									<select id="smonth" class="MADFS_Left_Select">
									<%for(int i=1;i<13;i++){ %>
									    <option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>月</option>
									<%} %>
									</select></span></td>
									<%}else if(type1.equals("2")){ %>
									<td><span style="float:left;line-height:30px;">选择周</span>
									<div class="panel" style="width: 91px;margin-left:5px;">
									<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>" <%if(inttype2!=1){ %> onclick="changeType2(<%=inttype2-1 %>)" title="上一周" <%} %>></div>
									<div id="weekpanel" class="week_txt" title="<%=weekdate1+" 至 "+weekdate2 %>">第&nbsp;<%=type2 %>&nbsp;周</div>
									<div class="week_btn2 <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %>week_next<%} %>" <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %> onclick="changeType2(<%=inttype2+1 %>)" title="下一周" <%} %>></div>
									</div></td>
									<%}%>
							     </tr>
							      <%if((status.equals("0") || status.equals("1") || status.equals("2")) && TimeUtil.dateInterval(s_enddate,currentdate)>0){ 
								       spanInfo += "状态: 已过期";
								   }else{
									   spanInfo = "0".equals(status)?"状态: 草稿":"1".equals(status)?"状态: 审批中":"2".equals(status)?"状态: 退回":"3".equals(status)?"状态: 已完成":"";
								   }
							      if(status.equals("1")){ 
							    	  if(!"".equals(spanInfo)) spanInfo +=", "; 
									  spanInfo += "待审批人："+CommonTransUtil.getPerson2(RightUtil.getUnAuditPlanHrm(planid))+", 截止日期："+s_enddate;
								  }else if(!status.equals("3")){
									  if(!"".equals(spanInfo)) spanInfo +=", ";
									  spanInfo +="提交截止日期："+s_enddate;
								  }
								%>
					   </tbody>
					</table>		
					<div id="dtitle0" class="dtitle"><div class="dtxt"><%=planname1 %></div><div class="pullDown"></div></div>
					 <div>
						  <table id="maintable1" class="maintable" cellspacing="0" cellpadding="0" border="0" width="100%">
										<%
										String orderby  = " order by t1.showorder,t1.id";
										String fbdate = "";
										int datatype = 2;
										String datatitle = "计划内";
										String datadesc = "【计划内】工作来源于上一周期的计划，如有其它工作可在【计划外】中添加";
										boolean detailedit = canedit;
										for(int m=0;m<2;m++){ %>
										<%
											if(m==1){
												datatype = 3;
												datatitle = "计划外";
												datadesc = "【计划外】工作表示不属于上一周期计划中的工作内容";
											}
										%>
										<tr class="header1" _tindex="<%=m%>" expand="1">
											<td style="position: relative;"><%=datatitle %>
											<span class="head_more">. . .</span>
											<%if(canedit && m==1){%>
												<div class="btn_con" >
													<div class="btn_add" onclick="doAddRow1()" title="添加"></div>
													<div class="btn_del" onclick="doDelRow1()" title="删除"></div>
												</div>
											<%} %>
											</td>
										</tr>	
										<tr><td>
										  <table id="datatable<%=m%>" class="datatable tr_show<%=m%>" border="0">
										    <colgroup><col width="30%" /><col width="70%" /></colgroup>
											<tbody>
											    <%	
											//读取总结内容
											sql = "select t1.id,t1.name,t1.cate,t1.begindate1,t1.enddate1,t1.begindate2,t1.enddate2,t1.days1,t1.days2,t1.finishrate,t1.target,t1.result,t1.custom1,t1.custom2,t1.custom3,t1.custom4,t1.custom5 ";
											if(planid.equals("")){
												if(m==0){
													sql += " from PR_PlanReportDetail t1 where t1.planid=(select t2.id from PR_PlanReport t2 where t2.userid="+resourceid+" and t2.year="+prevyear+" and t2.type1="+type1+" and t2.type2="+prevtype2+")";//读取上个月的计划内容
												}else{%>
												</tbody></table></td></tr>
													<%break;
												}
											}else{
												if(!viewdate.equals("")){
													if("oracle".equals(rs.getDBType())){
														sql +=",(select v.fbdate from (select CONCAT(CONCAT(fb.createdate,' '),fb.createtime) as fbdate,plandetailid from PR_PlanFeedback fb where fb.hrmid<>"+user.getUID()+" order by fb.createdate desc,fb.createtime desc) v where v.plandetailid=t1.id and rownum=1) as fbdate";
													}else{
														sql +=",(select top 1 fb.createdate+' '+fb.createtime from PR_PlanFeedback fb where fb.plandetailid=t1.id and fb.hrmid<>"+user.getUID()+" order by fb.createdate desc,fb.createtime desc) as fbdate";
													}
												}
												sql += " from PR_PlanReportDetail t1 where t1.datatype="+datatype+" and t1.planid2=" + planid;//读取已保存的内容
											}
											//System.out.println(sql+orderby);
											rs.executeSql(sql+orderby);
										%>
										<%if(rs.getCounts()==0 && m==0){%><tr class="tr_none0"><td colspan="2" style="font-style: italic;color: #808080;padding-left: 3px;border-bottom:0 !important">无</td></tr><%}%>
										<%if(rs.getCounts()==0 && m==1 && !canedit){%><tr class="tr_none1"><td colspan="2" style="font-style: italic;color: #808080;padding-left: 3px;border-bottom:0 !important">无</td></tr><%}%>
										<%
											while(rs.next()){
												fbdate = Util.null2String(rs.getString("fbdate"));
										%>
										<tr id="tr1_<%=index1 %>" class="tr_data tr_must tr_show<%=m%> tr1_<%=index1 %><%if(m==1){ %> tr_show<%} %>" _index="<%=index1 %>" _type="1" style="height:4px;"></tr>
										
										<%
											for(int i=0;i<showfields1.size();i++){ 
												feilds = ((String[])showfields1.get(i));
												fieldname = feilds[1];
												showname = feilds[2];
												ismust = feilds[4];
												if(showname.equals("")) showname = feilds[0];
												//if(fieldname.equals("name") && canedit) showname+="(必填)";
												if(fieldname.equals("finishrate")) showname+="(%)";
												if(fieldname.equals("cate")) hascate1 = true;
												detailedit = canedit;
												if(m==0 && showstemp.indexOf(fieldname)>-1) detailedit = false;
												int rspan = showfields1.size();
												if(canedit){rspan = rspan +1;}
										if(i==0){%>
										<tr class="tr1_<%=index1 %>">
											 <td colspan="2" class="td_show<%=m%> controlTdHeader" onclick="clickHeader(this);">
										   <%if(detailedit){%>
											<span><input class="icheck" type="checkbox" onclick="stopBubbling();" notBeauty="false" _index="<%=index1 %>" /></span><span class="optSpan">计划<%=index1+1 %>:</span>
										   <%}else{%>
											   <span class="optSpan">计划<%=index1+1 %>:</span>
										   <%}%>
										   <span class="head_more1">. . .</span>
										   <input type="hidden" id="s_id_value_<%=index1 %>" name="s_id_value_<%=index1 %>" value="<%=Util.null2String(rs.getString("id")) %>"/>
										   <input type="hidden" name="s_datatype_value_<%=index1 %>" value="<%=datatype %>"/>
										   <input type="hidden" class="value_index" name="s_showorder_value_<%=index1 %>" value=""/>
										   </td></tr>
										<%}%>
										<tr class="tr1_<%=index1 %>">
											<td class="td_font"><%=showname %><%if(("1".equals(ismust) || fieldname.equals("name")) && canedit){ %><font style="vertical-align:middle;color:red;">*</font><%} %></td>
											<td class="td1_<%=fieldname %>">
											<%if(detailedit){%>
												<%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){//多行文本 %>
												<textarea class="area_txt a_intext input_txt <%if(i==0){ %>input_first<%} %>" placeholder="请输入..." id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>"><%=Util.convertDB2Input(rs.getString(fieldname)) %></textarea>
												<%}else if(fieldname.indexOf("date")>-1){//日期 %>
			              						<input type="text" class="scroller_date input_txt intext" placeholder="请选择日期..." id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" readonly="readonly" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
												<%}else{//单行文本 %><input class="input_txt intext <%if(i==0){ %> input_first<%} %>"  placeholder="请输入..."
													id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>" 
													<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
													type="number" onkeypress="ItemNum_KeyPress('s_<%=fieldname %>_value_<%=index1 %>')" onblur="checknumber('s_<%=fieldname %>_value_<%=index1 %>')" maxlength="5"<%}else{%>
														type="text"
													<%} %>
													<%if(fieldname.equals("cate")){%> onchange="seteditspan(1)" <%}%>
													<%if(fieldname.equals("name")||fieldname.equals("cate")){%> maxlength="100" <%} %>/>
												<%} %>
												<span class="must_img"></span>
											<%}else{ %>
												<%if(fieldname.equals("cate")){ %><span style="font-size:13px;"><%=Util.toHtml(rs.getString(fieldname)) %></span>
												<%}else{ %><%=Util.toHtml(rs.getString(fieldname)) %><%} %>
												<input class="input_txt" type="hidden" id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
											<%} %>
											<%if(i==(showfields1.size()-1)){ %>
												<%	if(!fbdate.equals("") && !viewdate.equals("") && TimeUtil.dateInterval(viewdate,fbdate)>0){ %>
													<div id="fbnew_<%=index1 %>_1" class="newfb">new</div>
												<%	} %>
											<%} %>
											</td>
										  </tr>
										<%	} 
										if(canedit){%> 
										  <tr class="tr1_<%=index1 %>"><td colspan="2" _index="<%=index1 %>">
										  <a href="javaScript:void(0);" style="font-size:13px;" onclick="autoAddRow(this)">添加到工作计划</a>
										  </td></tr>
										<%} %>
										<tr class="tr1_<%=index1 %>">
										<%
											for(int i=0;i<hidefields1.size();i++){ 
												feilds = ((String[])hidefields1.get(i));
												fieldname = feilds[1];
										%>
											<input type="hidden" id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
										<%	} %>
										</tr>
										<%	index1++;} %>
										  </tbody>
									    </table>
									</td></tr>
										<%} %>
						</table>
									<table class="maintable2" cellspacing="0" cellpadding="0" border="0">
										<tr class="header1" _tindex="2" expand="1">
											<td style="position: relative;">工作总体分析<span class="head_more">. . .</span></td>
										</tr>
										<tr class="tr_show2">
											<td class="remark" style="<%if(!canedit){%>padding:10px 0 10px 20px;<%} %>" valign="top">
												<%if(canedit){%>
													<textarea id="remark" placeholder="请输入..." name="remark" class="a_intext" style="width: 85%;margin:5px 0 5px 20px;height:40px;"><%=remark%></textarea>
													<span class="must_img" style="height:40px;"></span>
												<%}else{ %>
													<%=remark %>
												<%} %>
											</td>
										</tr>
									</table>
					</div>
							
					<div id="dtitle0" class="dtitle"><div class="dtxt"><%=planname2 %></div><div class="pullDown"></div></div>
					<div>
					  <%if(canedit){%>
						  <div class="btn_con" >
							  <div class="btn_add" onclick="doAddRow2()" title="添加"></div>
							  <div class="btn_del" onclick="doDelRow2()" title="删除"></div>
						  </div>
					  <%} %>
					<table id="maintable2" class="datatable" cellspacing="0" cellpadding="0" border="0">
									<colgroup><col width="30%" /><col width="70%" /></colgroup>
										<tbody><%
											//读取计划内容
											sql = "select t1.id,t1.name,t1.cate,t1.begindate1,t1.enddate1,t1.begindate2,t1.enddate2,t1.days1,t1.days2,t1.finishrate,t1.target,t1.result,t1.custom1,t1.custom2,t1.custom3,t1.custom4,t1.custom5";
											if(planid.equals("")) sql += " from PR_PlanReportDetail t1 where t1.programid=" + programid;//读取模板中的默认内容
											else{
												if(!viewdate.equals("")){
													if("oracle".equals(rs.getDBType())){
														sql +=",(select v.fbdate from (select CONCAT(CONCAT(fb.createdate,' '),fb.createtime) as fbdate,plandetailid from PR_PlanFeedback fb where fb.hrmid<>"+user.getUID()+" order by fb.createdate desc,fb.createtime desc) v where v.plandetailid=t1.id and t1.planid2=0 and rownum=1) as fbdate";
													}else{
														sql +=",(select top 1 fb.createdate+' '+fb.createtime from PR_PlanFeedback fb where fb.plandetailid=t1.id and t1.planid2=0 and fb.hrmid<>"+user.getUID()+" order by fb.createdate desc,fb.createtime desc) as fbdate";
													}
												}
												sql += " from PR_PlanReportDetail t1 where t1.datatype=2 and t1.planid=" + planid;//读取已保存的内容
											}
											rs.executeSql(sql+orderby);
										%>
										<%if(rs.getCounts()==0 && !canedit){%><tr><td colspan="<%=showfields2.size() %>" style="font-style: italic;color: #808080;padding-left: 3px;">无</td></tr><%}%>
										<%
											while(rs.next()){
												fbdate = Util.null2String(rs.getString("fbdate"));
										%>
										<tr id="tr2_<%=index2 %>" class="tr_data tr_show tr2_<%=index2 %>" _index="<%=index2 %>" _type="2" style="height:4px;"></tr>
										<%
											for(int i=0;i<showfields2.size();i++){ 
												feilds = ((String[])showfields2.get(i));
												fieldname = feilds[1];
												showname = feilds[2];
												ismust = feilds[4];
												if(showname.equals("")) showname = feilds[0];
												//if(fieldname.equals("name") && canedit) showname+="(必填)";
												if(fieldname.equals("cate")) hascate2 = true;
										if(i==0){%>
										    <tr class="tr2_<%=index2 %>">
											<td colspan="2" class="td_show controlTdHeader" onclick="clickHeader(this);">
											<%if(canedit){%>
											<span><input class="icheck" type="checkbox" onclick="stopBubbling();" notBeauty="false" _index="<%=index2 %>" /></span><span class="optSpan1">计划<%=index2+1 %>：</span>
										   <%}else{%>
											  <span> 计划<%=index2+1 %>：</span>
										   <%}%>
										   <span class="head_more1">. . .</span>
											<input type="hidden" id="p_id_value_<%=index2 %>" name="p_id_value_<%=index2 %>" value="<%=(!planid.equals(""))?Util.null2String(rs.getString("id")):"" %>"/>
											<input type="hidden" name="p_datatype_value_<%=index2 %>" value="2"/>
											<input type="hidden" class="value_index" name="p_showorder_value_<%=index2 %>" value=""/></td></tr>
										<%}%>
										    <tr class="tr2_<%=index2 %>">
											<td class="td_font"><%=showname %><%if(("1".equals(ismust) || fieldname.equals("name")) && canedit){ %><font style="vertical-align:middle;color:red;">*</font><%} %></td>
											<td class="td2_<%=fieldname %>">
											<%if(canedit){%>
												<%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){ %><textarea 
												class="area_txt a_intext input_txt <%if(i==0){ %>input_first<%} %>" placeholder="请输入..." id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>"><%=Util.convertDB2Input(rs.getString(fieldname)) %></textarea>
												<%}else if(fieldname.indexOf("date")>-1){//日期 %>
			              						<input type="text" class="scroller_date intext input_tx" placeholder="请选择日期..." id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" readonly="readonly" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
												<%}else{ %><input class="input_txt intext <%if(i==0){ %> input_first<%} %>" placeholder="请输入..."
													id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"
													<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
													type="number" onkeypress="ItemNum_KeyPress('p_<%=fieldname %>_value_<%=index2 %>')" onblur="checknumber('p_<%=fieldname %>_value_<%=index2 %>')" maxlength="5" <%} else{%>
														type="text"
													<%}%>
													<%if(fieldname.equals("cate")){%> onchange="seteditspan(2)" <%}%>
													<%if(fieldname.equals("name")||fieldname.equals("cate")){%> maxlength="100" <%} %>/>
												<%} %>
												<span class="must_img"></span>
											<%}else{ %>
												<%if(fieldname.equals("cate")){ %><span style="font-size:13px;"><%=Util.toHtml(rs.getString(fieldname)) %></span>
												<%}else{ %><%=Util.toHtml(rs.getString(fieldname)) %><%} %>
												<input class="input_txt" type="hidden" id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
											<%} %>
											<%if(i==(showfields2.size()-1)){ %>
												<%	if(!fbdate.equals("") && !viewdate.equals("") && TimeUtil.dateInterval(viewdate,fbdate)>0){ %>
													<div id="fbnew_<%=index2 %>_2" class="newfb">new</div>
												<%	}
											  } %>
											  </td>
											</tr>
										<%	} %>
										<tr class="tr2_<%=index2 %>">
										<%
											for(int i=0;i<hidefields2.size();i++){ 
												feilds = ((String[])hidefields2.get(i));
												fieldname = feilds[1];
										%>
											<input type="hidden" id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
										<%	} %>
										</tr>
										<%	index2++;} %>
									</tbody></table>
					</div>
					<div id="dtitle0" class="dtitle" style="margin-top:3px;"><div class="dtxt">相关信息</div><div class="pullDown"></div></div>
					<table class="datatable" style="width: 100%;margin-top:3px;" cellpadding="0" cellspacing="0" border="0">
					    <colgroup><col width="30%" /><col width="70%" /></colgroup>
							<tr><td>相关附件</td><td>
							   <%if(!fileids.equals("")) fileids = fileids.substring(1);
								 List fileidList = Util.TokenizerString(fileids,",");
								 int linknum=-1;
								 for(int j=0;j<fileidList.size();j++){
									if(!"0".equals(fileidList.get(j)) && !"".equals(fileidList.get(j))){
										linknum++;
										DocImageManager.resetParameter();
										DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(j)));
										DocImageManager.selectDocImageInfo();
										DocImageManager.next();
										String docImagefileid = DocImageManager.getImagefileid();
										int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
										String docImagefilename = DocImageManager.getImagefilename();%>	
										<div style="width:auto;font-size:13px;"><%=docImagefilename %>
										&nbsp;<a href='javaScript:void(0);' onclick="plandownload(<%=fileidList.get(j) %>,<%=planid %>,<%=docImagefileid %>,'<%=docImagefilename %>');" style="font-size:13px;">下载(<%=docImagefileSize/1000 %>K)</a>
										<%if(canedit){%>
										<input type="checkbox" notBeauty="false" onclick="onDeleteAcc(this,'<%=fileidList.get(j)%>')"/><U><%=linknum%></U>-删除
										<%} %>
										</div>
										<%}
										}
								 if(canedit){
									if(!docsecid.equals("")&&!docsecid.equals("0")){
										String subid = SecCategoryComInfo.getSubCategoryid(docsecid);
										String mainid = SubCategoryComInfo.getMainCategoryid(subid);
										String maxsize = "0";
										rs2.executeSql("select maxUploadFileSize from DocSecCategory where id=" + docsecid);
										if(rs2.next()) maxsize = Util.null2String(rs2.getString(1));
										   canupload = true;
											%>
											<div id="edit_uploadDiv" style="margin-top: 0px;margin-bottom: 2px;" mainId="<%=mainid%>" subId="<%=subid%>" secId="<%=docsecid%>" maxsize="<%=maxsize%>"></div>
											<%	}else{ %>
											<font color="red">未设置附件上传目录!</font>
											<%	} %>
											<input type="hidden" id="edit_relatedacc" name="edit_relatedacc" value="<%=fileids%>"/>
									     	<input type="hidden" id="delrelatedacc" name="delrelatedacc" value=""/>	
								<%}%>
							</td></tr>
							<tr>
							  <%if(type1.equals("1") && isperformance){ 
									rs.executeSql("select 1 from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2 and ismonth=1");
									if(rs.next()){
								%><td>绩效考核</td>
								<td style="line-height: 180%;"><a id="access" href="javaScript:void(0);" style="font-size:13px;"><%=ResourceComInfo.getLastname(resourceid)%><%=year %>年<%=type2 %>月目标绩效考核</a></td>
								<%	}
								  } 
								%>
							</tr>
							<% 
									if(!shareids.equals("")){
										if(shareids.startsWith(",")) shareids = shareids.substring(1);
										if(shareids.endsWith(",")) shareids = shareids.substring(0,shareids.length()-1);
									}
									String sharenames = ResourceComInfo.getMulResourcename(shareids);
								%>
							<%if(!planid.equals("")){%> 
							  <tr><td>报告共享</td>
							   <td><%if(editshare){%>
										<textarea class="intext" placeholder="请点击后面放大镜选择" id="hrmidsSpan" readonly onclick="selectUser('shareids','hrmidsSpan',1)"><%=sharenames %></textarea>
										<div id="img1" class="btn_browser" style="margin-right:8px !important;margin-top:1px !important;" onclick="selectUser('shareids','hrmidsSpan',1)"></div>
										<input type="hidden" id="shareids" name="shareids" value="<%=shareids %>"/>
										<%}else{ %>
											<%=sharenames %>
											<%if(sharenames.equals("")){ %><font style="color: #808080;font-style: italic;font-size:13px;">无</font><%} %>
										<%} %>
										<%if(!pshareids.equals("")){ %>
											<div style="color: #717171;clear: both;line-height: 30px;float:left;margin-left:3px;font-size:13px;">默认共享：<%=CommonTransUtil.getPerson2(pshareids) %></div>
										<%} %>
							   </td></tr>
							<%}%>
							<tr style="height:6px;"></tr>
					</table>
					<%if(!planid.equals("")){ %>
					   <div id="dtitle0" class="dtitle"><div class="dtxt">意见反馈</div><div class="pullDown"></div></div>
					   <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
					     <tr><td width="100%" valign="top">
					       <div id="exchange" style="width: 100%;border-bottom: 1px #ECECEC solid;overflow: hidden;">
						    <div style="float:left;"><input type="text" class="Design_Reply_content" onfocus="contentFocus()" onblur="contentBlur()" id="content" name="content" placeholder="意见内容..."/></div>
						    <div id="exchangebtn" class="Design_Reply_Btn" style="display: none;" onclick="saveExchange()">保存</div>
						    <div class="mec_refresh_loading" style="margin-top:50px !important;">
								<div class="spinner">
									<div class="bounce1"></div>
									<div class="bounce2"></div>
									<div class="bounce3"></div>
								</div>
							</div>
						  </div>
						  <table cellpadding="0" id="ex_table" cellspacing="0" border="0" style="width: 100%;">
						     <%String operatedate = "";
									  String userimg ="";
									  rs.executeSql("select operator,operatedate,operatetime,content from PR_PlanReportExchange where planid="+planid+" order by operatedate desc,operatetime desc,id desc");
									  while(rs.next()){
										 operatedate = Util.null2String(rs.getString("operatedate")+" "+rs.getString("operatetime"));
										 userimg = ResourceComInfo.getMessagerUrls(rs.getString("operator"));//人头像
								    %>
								    <tr><td class="td_img"><img src="<%=userimg %>" class="exchange_img"/></td>
									<td><div class="exchange_title"><%=ResourceComInfo.getResourcename(rs.getString("operator")) %>&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>
									<%if(!Util.null2String(rs.getString("operator")).equals(user.getUID()+"") 
											&& !viewdate.equals("") && TimeUtil.dateInterval(viewdate,operatedate)>0){ 
									%>
									<font style="color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;">new</font>
									<%} %>
									</div>
									<div class="exchange_content"><%=Util.toHtml(rs.getString("content")) %></div></td></tr>
									<%}%>
						  </table>
					     </td></tr>
					   </table>
					<%}%>
					<table class="datatable">
							<tr id="btn_id"><td  style="padding-top:20px;border-bottom:0 ! important;" align="center">
								<%if(canreset && TimeUtil.dateInterval(currentdate,s_enddate)>=0){ %>
								<div class="btn_feedback2 btn_feed" onclick="doReset();">重新编写</div>
								<%} %>
								<%if(canedit){%>
								<div class="btn_feedback2 btn_feed" onclick="doSave();">保存</div>
								<div class="btn_feedback2 btn_feed" onclick="doSubmit();">提交</div>
								<%} %>
								<%if(candel){%>
								<div class="btn_feedback2 btn_feed" onclick="doDel();">删除</div>
								<%} %>
								<%if(canaudit){ %>
								<div class="btn_feedback2 btn_feed" onclick="doApprove();">批准</div>
								<div class="btn_feedback2 btn_feed" onclick="doReturn();">退回</div>
								<%} %>
								<%if(editshare){%>
								<div class="btn_feedback2 btn_feed" onclick="doShare();">共享</div>
								<%} %>
							</td></tr>
				</table>
				<%}%>
			<input type="hidden" id="index1" name="index1" value="<%=index1 %>" />
			<input type="hidden" id="index2" name="index2" value="<%=index2 %>" />
			<input type="hidden" id="showindex" name="showindex" value="<%=showindex %>" />
		</form>
		<div id="weekselect" class="weekselect">
			<%
				for(int i=1;i<TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+1;i++){
			%>
				<div class="weekoption<%if(currentweek==i){ %> weekoption_current<%} %><%if(inttype2==i){ %> weekoption_select<%} %>" <%if(inttype2!=i){ %> onclick="changeType2(<%=i%>)" style="cursor:pointer;" <%} %>
				 title="<%=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(Integer.parseInt(year),i)) %> 至 <%=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(Integer.parseInt(year),i)) %>">第<%=i %>周</div>
			<%	} %> 
		</div>
		<div id="userChooseDiv">
			<iframe id="userChooseFrame" src="/mobile/plugin/plus/browser/hrmBrowser.jsp" frameborder="0" scrolling="auto">
			</iframe>
		</div>
	<script language="javascript">
	var rowindex = <%=index1%>;
	var rowindex2 = <%=index2%>;
	var rowi1 = 0;
	var rowi2 = <%=index2%>;
	var itemMap = null;
	var _wheight = window.innerHeight;
    var _wwidth = window.innerWidth;
    var _scrolltop = 0;
	$(document).ready(function(){
	    $("#spaninfo").html('<%=spanInfo%>');
		$("#content").width($(body).width()-50);
		$(".tabpanel li.tab").on("click",function(){
		    var datavalue = $(this).attr('tdata');
		    window.location = "PlanView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1="+datavalue+"&back=<%=back%>";
		});
		$('select').each(function(){
		  $(this).css('width',$(this).parent().width()*0.5);
		});
		<%if(canedit){%>
		highEditor("remark",150);
	   <%}%>

		setIndex(1);
		setIndex(2);
		
		$('.scroller_date').mobiscroll().date({
			theme: "Jquery Mobile",
            mode: "Scroller",
            display: "bottom",
	        preset: 'date',
	        dateFormat:'yy-mm-dd',
	        endYear:2050,
	        nowText:'今天',
	        setText:'确定',
	        cancelText:'取消',
	        monthText:'月',
	        yearText:'年',
	        dayText:'日',
	        showNow:true,
	        dateOrder: 'yymmdd',
	        onSelect:function(event,inst) {
	           var inputname = $(this).attr("id");
	           checkMyDate(inputname);
            }
	    }); 
		$("tr.header1").bind("click",function(e){
		    var target=$.event.fix(e).target;
			if(!$(target).hasClass("btn_add") && !$(target).hasClass("btn_del")){
				var _tindex = jQuery(this).attr("_tindex");
				if($(this).attr("expand")=="1"){
					$(this).attr("expand","2");
					$(this).find("span.head_more").show();
					$(this).find(".btn_con").hide();
					$(".tr_show"+_tindex+",.tr_none"+_tindex).hide();
				}else{
					$(this).attr("expand","1");
					$(this).find("span.head_more").hide();
					$(this).find(".btn_con").show();
					$(".tr_show"+_tindex+",.tr_none"+_tindex).show();
				}
			}
		});
	    //控制多行文本框自动伸缩
	    $("textarea[id!='remark']").textareaAutoHeight({minHeight:25});
	    $("#remark").textareaAutoHeight({minHeight:40});
		
		//点击展示隐藏的标签页内容
		$(".dtitle").click(function(){
			$(this).next().toggle();
			if($(this).find(".pullDown").hasClass("pullUp")){
				$(this).find(".pullDown").removeClass("pullUp");
			}else{
				$(this).find(".pullDown").addClass("pullUp");
			}
		});
		$('#smonth').live('change',function(){
		  var data_type = $(this).val();
		  window.location = "PlanView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1=<%=type1%>&type2="+data_type+"&back=<%=back%>";
		});
		
		$('#syear').live('change',function(){
		  var data_type = $(this).val();
		  window.location = "PlanView.jsp?resourceid=<%=resourceid%>&year="+data_type+"&type1=<%=type1%>&type2=<%=type2%>&back=<%=back%>";
		});
		$('#weekpanel').live('click',function(){
		   $("#weekselect").css({top:$(this).offset().top+26,left:$(this).parent().parent().offset().left,width:$(this).parent().parent().width()});
		   $('#weekselect').toggle();
		});
		$('#access').live('click',function(){
		   window.location = "/mobile/plugin/performance/AccessView.jsp?year=<%=year %>&type1=1&back=2&type2=<%=type2 %>&resourceid=<%=resourceid %>";
		});
		$(document).bind("click",function(e){
			var target=$.event.fix(e).target;
			if($(target).attr("id")!="weekpanel"){
				$("#weekselect").hide();
			}
		});
		<%if(index1==0 && canedit){%>doAddRow1();<%}%>
		<%if(index2==0 && canedit){%>doAddRow2();<%}%>
		if($(body).width()>=768){
		   $('*').css('font-size','16px');
		}
		$("#tabblank").height($("#topmain").height());//占位fixed出来的空间
		var checkspans = $('#datatable1').find('.optSpan');
		if(checkspans.length>0){
			checkspans.each(function(i){
			  $(this).html("计划"+(parseInt(i)+parseInt(1))+":");
			});
			rowi1 = checkspans.length;
		}
	});
	function clickHeader(obj){
	  var currentclass = $(obj).parent().attr('class');
	  $('.'+currentclass).toggle();
	  $(obj).parent().show();
	  $(obj).parent().find('.head_more1').toggle();
	}
	function submitOperation(){//提交表单
		
		<%if(canedit){%>
		K.sync("#remark"); //同步内容
	   <%}%>
		$("#form1").ajaxSubmit({
			dataType:"json",
			type:"post",
			success:function(data){
				if(data.planid!=""){
					window.location.href = "/mobile/plugin/workrelate/PlanView.jsp?planid="+data.planid+"&back=<%=back%>";
				}else if(data.operation!="" && data.operation=="delete"){
					window.location.href = "/mobile/plugin/workrelate/PlanView.jsp?resourceid="+data.resourceid+"&year="+data.result_year+"&type1="+data.result_type1+"&type2="+data.result_type2+"&back=<%=back%>";
				}else{
				    alert(data.msg);
				}
			},
			error:function(data){
				alert(data);
			},
			complete:function(){
				hideLoading();
			}
		});
	}
	function stopBubbling(event){
	  var e = event || window.event;
	  if (window.event) {
		 e.cancelBubble=true;
	  } else {
		 e.stopPropagation();
	  }
	}
	function plandownload(id,planid,fileid,filename){
	   $.ajax({
	     type: "post",
		 url: "/mobile/plugin/workrelate/download.jsp",
		 contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		 data:{"id":id,"planid":planid,"fileid":fileid}, 
		 complete:function(){
		   window.location = "/download.do?fileid="+fileid+"&filename="+filename;
		 }
	   });
    }
	function doBack(){
	    <%if("1".equals(back)){%>
	    	window.location = "/mobile/plugin/workrelate/auditMain.jsp";
	    <%}else if("2".equals(back)){%>
	    	window.location = "/mobile/plugin/performance/AccessView.jsp?resourceid=<%=resourceid%>";
	    <%}else{%>
	        window.location = "/mobile/plugin/workrelate/relateMain.jsp";
	    <%}%>
	}
	function filter(str){
		str = str.replace(/\+/g,"%2B");
	    str = str.replace(/\&/g,"%26");
		return str;	
    }
    function changeType2(type){
	    window.location = "PlanView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1=<%=type1%>&type2="+type+"&back=<%=back%>";
	}
	function saveExchange(){
		if(jQuery("#content").val()==""){	
			alert("请填写意见内容！");
		}else{
			$("#exchangebtn").hide();
			$('#exchange .mec_refresh_loading').show();
			jQuery.ajax({
				type: "post",
				url: "PlanOperation.jsp",
			    data:{"operation":"add_exchange","planid":"<%=planid%>","content":filter(encodeURIComponent(jQuery("#content").val()))}, 
				contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				complete: function(data){ 
					if(data!=""){
						var txt = $.trim(data.responseText);
						jQuery("#ex_table").prepend(txt);
					}
				    $("#exchangebtn").show();
					$("#exchange .mec_refresh_loading").hide();
					$("#content").val("").blur();
				}
			});
		}
	}
	function contentFocus(){
		if(jQuery("#content").val()==""){
			jQuery("#exchangebtn").show();
			$("#content").width($(body).width()-$('#exchangebtn').width()-75);
		}
	}
	function contentBlur(){
		if(jQuery("#content").val()==""){
			jQuery("#exchangebtn").hide();
			$("#content").width($(body).width()-50);
		}
	}
	// 设置序号
	function setIndex(tableindex){
		var index=1;
		if(tableindex==2){
			jQuery("#maintable2").find("td.td_show").each(function(){
				jQuery(this).find("input.value_index").val(index);
				index++;
		});
		}else{
			jQuery("#maintable1").find("td.td_show0").each(function(){
				jQuery(this).find("input.value_index").val(index);
				index++;
		    });
			index=1;
			jQuery("#maintable1").find("td.td_show1").each(function(){
				jQuery(this).find("input.value_index").val(index);
				index++;
			});
	   }
}
	<%if(canaudit){ %>
			function doApprove(obj) {
				if(confirm("确定批准此计划报告?")){
					jQuery("#operation").val("approve");
					showLoading();
					submitOperation();
				}
			}
			function doReturn(obj) {
				if(confirm("确定退回此计划报告?")){
					jQuery("#operation").val("return");
					showLoading();
					submitOperation();
				}
			}
			<%}%>
			<%if(canreset){ %>
			function doReset(obj){
				if(confirm("确定重新编写总结计划?")){
					jQuery("#operation").val("reset");
					showLoading();
					submitOperation();
				}
			}
			<%}%>
			<%if(candel){ %>
			function doDel(obj){
				if(confirm("确定删除此总结计划?")){
					jQuery("#operation").val("delete");
					showLoading();
					submitOperation();
				}
			}
			<%}%> 
           <%if(canedit){%>
			function seteditspan(index){
                var s = null;
                $("#maintable"+index).find("td.td"+index+"_cate").each(function() {
                    var td = $(this);
                    if(td.length>0){
                    	var input = td.children("input.input_txt");
                    	if(input.length>0){
                    		var s1 = input.val();
                            if (s1!="" && s1 == s) { 
                            	input.addClass("input_span");
                            }
                            else {
                            	input.removeClass("input_span");
                                s = s1;
                            }
                        }else{
    						s = null;
                        }
                    }else{
						s = null;
                    }
                });
			}
			function doSave(obj) {
			    if(checkIsMust()){
			       alert("请填写:标题不为空计划数据的必填项,红色*号为必填项!");
			       return false;
			    }
				if(confirm("确定保存工作总结?") && checkMust()){
					jQuery(".area_reason").each(function(){
						if(jQuery(this).val()==reasondef){
							jQuery(this).val("");
						}
					});
					showLoading();
					jQuery("#operation").val("save");
					<%if(canupload){%>
						submitform();
					<%}else{%>
						doSaveAfterAccUpload();
					<%}%>
				}
			}
			function doSubmit(obj) {
			    if(checkIsMust()){
			       alert("请填写:标题不为空计划数据的必填项,红色*号为必填项!");
			       return false;
			    }
				if(confirm("确定提交工作总结?") && checkMust()){
					jQuery("#operation").val("submit");
					showLoading();
					<%if(canupload){%>
						submitform();
					<%}else{%>
						doSaveAfterAccUpload();
					<%}%>
				}
			}
			function submitform(){
				var oUploader=window[jQuery("#edit_uploadDiv").attr("oUploaderIndex")];	
				try{
					if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
						doSaveAfterAccUpload();
			   		else 
			     		oUploader.startUpload();
				}catch(e) {
					doSaveAfterAccUpload();
				}	
			}
			function doSaveAfterAccUpload(){
				submitOperation();
			}
			
			function onDeleteAcc(obj,delid){
				 var delrelatedacc=jQuery("#delrelatedacc").val();
				 var relatedacc=jQuery("#edit_relatedacc").val();
				 relatedacc=","+relatedacc;
				 delrelatedacc=","+delrelatedacc;
				 if(jQuery(obj).attr("checked")){
					delrelatedacc=delrelatedacc+delid+",";
					var index=relatedacc.indexOf(","+delid+",");
					relatedacc=relatedacc.substr(0,index+1)+relatedacc.substr(index+delid.length+2);
				 }else{
					var index=delrelatedacc.indexOf(","+delid+",");
					delrelatedacc=delrelatedacc.substr(0,index+1)+delrelatedacc.substr(index+delid.length+2);
					relatedacc=relatedacc+delid+",";
				}
				jQuery("#edit_relatedacc").val(relatedacc.substr(1,relatedacc.length));
				jQuery("#delrelatedacc").val(delrelatedacc.substr(1,delrelatedacc.length));
			} 
			function checkMust(){
				var noname = false;
				for(var i=0;i<rowindex;i++){
					var nameobj = jQuery("#s_name_value_"+i);
					if(nameobj.length>0 && nameobj.val()==""){
						noname = true;
						break;
					}
				}
				if(!noname){
					for(var i=0;i<rowindex2;i++){
						var nameobj = jQuery("#p_name_value_"+i);
						if(nameobj.length>0 && nameobj.val()==""){
							noname = true;
							break;
						}
					}
				}
				
				if(noname){
					return confirm("提示：未填写标题的明细项将不会保存，确定继续执行操作？");
				}else{
					return true;
				}
			}
			function checkIsMust(){
			   var _flag = false;
			   $("tr.tr_must").each(function(){
			      if(_flag){
			           return false;
			      }
			      var _index = $(this).attr("_index");
				  var _names = $("#s_name_value_"+_index);
				  <%
					for(int i=0;i<showfields1.size();i++){
						feilds = ((String[])showfields1.get(i));
						fieldname = feilds[1];
						ismust = feilds[4];
				  %>
					    if(_names.length>0 && _names.val()!="" && <%=ismust%>==1){
					        var _obj = $("#s_"+"<%=fieldname%>"+"_value_"+_index);
					        if(_obj.length>0 && _obj.val()==""){
					           _flag =true;
					        }
					   }    
				  <%
					}
				  %>
			   });
			   if(!_flag){
			      $("#maintable2").find("tr.tr_show").each(function(){
			         if(_flag){
			           return false;
			         }
			         var _index = $(this).attr("_index");
			         var _names = $("#p_name_value_"+_index);
			         <%
					for(int i=0;i<showfields2.size();i++){
						feilds = ((String[])showfields2.get(i));
						fieldname = feilds[1];
						ismust = feilds[4];
					%>
					    if(_names.length>0 && _names.val()!="" && <%=ismust%>==1){
					        var _obj = $("#p_"+"<%=fieldname%>"+"_value_"+_index);
					        if(_obj.length>0 && _obj.val()==""){
					           _flag =true;
					        }
					    }    
					<%
					   }
					%>
			      });
			   }
			   return _flag;
			}
			function bindarea(trid){
				var areaobjs = null;
				if(getVal(trid)!=""){
					areaobjs = jQuery("."+trid).find(".area_txt");
				}else{
					areaobjs = jQuery(".area_txt");
				}
				if(areaobjs.length>0){
					areaobjs.textareaAutoHeight({ minHeight:22 });
					areaobjs.each(function(){
						var textarea= jQuery(this).get(0); 
						//alert(textarea.clientHeight);
						jQuery(this).height(textarea.scrollHeight);
					});
				}
				
			}
			//总结数据添加到工作计划
			function autoAddRow(obj){
				var index = jQuery(obj).parent().attr("_index");
				var trdata = jQuery("#tr1_"+index);
				itemMap = new Map();
			<%
				for(int i=0;i<showfields1.size();i++){ 
					feilds = ((String[])showfields1.get(i));
					fieldname = feilds[1];
			%>
				itemMap.put("<%=fieldname%>",getVal(jQuery("#s_<%=fieldname%>_value_"+index).val()));
			<%	} %>
			<%
				for(int i=0;i<hidefields1.size();i++){ 
					feilds = ((String[])hidefields1.get(i));
					fieldname = feilds[1];
			%>
				itemMap.put("<%=fieldname%>",getVal(jQuery("#s_<%=fieldname%>_value_"+index).val()));
			<%	} %>
				doAddRow2();
			}
			//添加计划外工作总结
			function doAddRow1(insertindex){
				var trstr = "<tr id=\"tr1_"+rowindex+"\" class=\"tr_data tr_show tr_show1 tr1_"+rowindex+"\" _index=\""+rowindex+"\"  style=\"height:4px;\" _type=\"1\"></tr>";
			<%
				for(int i=0;i<showfields1.size();i++){ 
					feilds = ((String[])showfields1.get(i));
					fieldname = feilds[1];
					showname = feilds[2];
					ismust = feilds[4];
					if(showname.equals("")) showname = feilds[0];
					//if(fieldname.equals("name") && canedit) showname+="(必填)";
					if(fieldname.equals("finishrate")) showname+="(%)";
					if(fieldname.equals("cate")) hascate1 = true;
					int rospan = showfields1.size();
					if(canedit) rospan = rospan+1;
			%>
			   
			<%if(i==0){%>
			    trstr +="<tr class=\"tr1_"+rowindex+"\">";
			    trstr +="<td colspan=\"2\" class=\"td_show1 controlTdHeader\" onclick=\"clickHeader(this);\">";
				trstr += "<span><input class=\"icheck\" onclick=\"stopBubbling();\" type=\"checkbox\" notBeauty=\"false\" _index=\""+rowindex+"\" /></span><span class=\"optSpan\">计划"+(parseInt(rowi1)+parseInt(1))+":</span>";
				trstr +="<span class=\"head_more1\">. . .</span>";
				trstr += "<input type=\"hidden\" id=\"s_id_value_"+rowindex+"\" name=\"s_id_value_"+rowindex+"\" value=\"\"/>";
				trstr += "<input type=\"hidden\" name=\"s_datatype_value_"+rowindex+"\" value=\"3\"/>";
				trstr += "<input type=\"hidden\" class=\"value_index\" name=\"s_showorder_value_"+rowindex+"\" value=\"\"/></td></tr>";
			<%}%>
			trstr +="<tr class=\"tr1_"+rowindex+"\">";
			trstr +="<td class=\"td_font\"><%=showname %><%if(("1".equals(ismust) || fieldname.equals("name")) && canedit){ %><font style=\"vertical-align:middle;color:red;\">*</font><%} %></td>";
			trstr +="<td class=\"td1_<%=fieldname %>\">";
			<%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){ %>
				trstr += "<textarea placeholder=\"请输入...\" class=\"area_txt a_intext input_txt <%if(i==0){ %>input_first<%} %>\" id=\"s_<%=fieldname %>_value_"+rowindex+"\" name=\"s_<%=fieldname %>_value_"+rowindex+"\"></textarea>";
			<%}else if(fieldname.indexOf("date")>-1){//日期 %>
				trstr += "<input type=\"text\" placeholder=\"请选择日期...\" class=\"scroller_date intext input_tx scroller_date"+rowindex+"\" id=\"s_<%=fieldname %>_value_"+rowindex+"\" readonly=\"readonly\" name=\"s_<%=fieldname %>_value_"+rowindex+"\" value=\"\">";
			<%}else{%>
				trstr += "<input placeholder=\"请输入...\" class=\"input_txt intext <%if(i==0){%>input_first<%}%>\"  id=\"s_<%=fieldname %>_value_"+rowindex+"\" name=\"s_<%=fieldname %>_value_"+rowindex+"\" ";
				<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
				trstr += " type=\"number\" onkeypress=\"ItemNum_KeyPress('s_<%=fieldname %>_value_"+rowindex+"')\" onblur=\"checknumber('s_<%=fieldname %>_value_"+rowindex+"')\" maxlength=\"5\"";
				<%}else{%>
					trstr +="type=\"text\"";
				<%} %>
				<%if(fieldname.equals("cate")){%>
				//分类字段会自动引用前一行数据的分类
				var catevalue = "";
				if(getVal(insertindex)!=""){
					catevalue = jQuery("#s_cate_value_"+insertindex).val();
				}else{
					if(jQuery("#datatable1").find("tr.tr_show").length>0){
						var lastindex = jQuery("#datatable1").find("tr.tr_show:last").attr("_index");
						catevalue = jQuery("#s_cate_value_"+lastindex).val();
					}
				}
				trstr += " value=\""+catevalue+"\"";
				trstr += " onchange=\"seteditspan(1)\"";
				<%}%>
				<%if(fieldname.equals("name")||fieldname.equals("cate")){%> 
				trstr += " maxlength=\"100\"";
				<%} %>
				trstr += "/>";
			<%}%>
				trstr += "<span class=\"must_img\"></span></td>";
				trstr +="</tr>";
			<%} if(canedit){%>
			    trstr += "<tr class=\"tr1_"+rowindex+"\"><td colspan=\"2\" _index=\""+rowindex+"\">";
			    trstr +="<a href=\"javaScript:void(0);\" style=\"font-size:13px;\" onclick=\"autoAddRow(this)\">添加到工作计划</a></td></tr>";
			
			<%} %>	
				if(getVal(insertindex)!=""){
					jQuery("#tr1_"+insertindex).after(trstr);
				}else{
					jQuery("#datatable1").append(trstr);
				}
				bindarea("tr1_"+rowindex);
				initMdate("scroller_date"+rowindex);
				rowindex++;
				rowi1++;
				jQuery("#index1").val(rowindex);
				setIndex(1);
				<%if(hascate1){%>seteditspan(1);<%}%>
				
			}
			function initMdate(inputc){
			   $('.'+inputc).mobiscroll().date({
					theme: "Jquery Mobile",
		            mode: "Scroller",
		            display: "bottom",
			        preset: 'date',
			        dateFormat:'yy-mm-dd',
			        endYear:2050,
			        nowText:'今天',
			        setText:'确定',
			        cancelText:'取消',
			        monthText:'月',
			        yearText:'年',
			        dayText:'日',
			        showNow:true,
			        dateOrder: 'yymmdd',
			        onSelect:function(event,inst) {
			           var inputname = $(this).attr("id");
			           checkMyDate(inputname);
		            }
	            });
			}
			//删除计划外工作总结
			function doDelRow1(){
				var checks = jQuery("#maintable1").find("input:checked");
				if(checks.length>0){
					if(confirm("确定删除选择明细项?")){
						checks.each(function(){
							var _index = jQuery(this).attr("_index");
							jQuery(".tr1_"+_index).remove();
							rowi1--;
						});
						var checkspan = $('#datatable1').find('.optSpan');
						if(checkspan.length>0){
						  checkspan.each(function(i){
						    $(this).html("计划"+(parseInt(i)+parseInt(1))+":");
						  });
						  rowi1 = checkspan.length;
						}
					}
				}else{
					alert("请选择删除项!");
				}
				setIndex(1);
			}
			//添加工作计划
			function doAddRow2(insertindex){
				var fieldval = "";
				var trstr = "<tr id=\"tr2_"+rowindex2+"\" class=\"tr_data tr_show tr2_"+rowindex2+"\" _index=\""+rowindex2+"\" style=\"height:4px;\" _type='2'></tr>";
			<%
				for(int i=0;i<showfields2.size();i++){ 
					feilds = ((String[])showfields2.get(i));
					fieldname = feilds[1];
					showname = feilds[2];
					ismust = feilds[4];
					if(showname.equals("")) showname = feilds[0];
					//if(fieldname.equals("name") && canedit) showname+="(必填)";
					if(fieldname.equals("cate")) hascate2 = true;
			%>
				fieldval = "";
				if(itemMap!=null) fieldval = getVal(itemMap.get("<%=fieldname%>"));
			<%if(i==0){%>
			    trstr +="<tr class=\"tr2_"+rowindex2+"\">";
			    trstr +="<td colspan=\"2\" class=\"td_show controlTdHeader\" onclick=\"clickHeader(this);\">";
				trstr += "<span><input class=\"icheck\" onclick=\"stopBubbling();\" type=\"checkbox\" notBeauty=\"false\" _index=\""+rowindex2+"\" /></span><span class=\"optSpan1\">计划"+(parseInt(rowi2)+parseInt(1))+":</span>";
				trstr +="<span class=\"head_more1\">. . .</span>";
				trstr += "<input type=\"hidden\" id=\"p_id_value_"+rowindex2+"\" name=\"p_id_value_"+rowindex2+"\" value=\"\"/>";
				trstr += "<input type=\"hidden\" name=\"p_datatype_value_"+rowindex2+"\" value=\"2\"/>";
				trstr += "<input type=\"hidden\" class=\"value_index\" name=\"p_showorder_value_"+rowindex2+"\" value=\"\"/></td></tr>";
			<%}%>
			trstr +="<tr class=\"tr2_"+rowindex2+"\">";
			trstr +="<td class=\"td_font\"><%=showname %><%if(("1".equals(ismust) || fieldname.equals("name")) && canedit){ %><font style=\"vertical-align:middle;color:red;\">*</font><%} %></td>";
			trstr += "<td class=\"td2_<%=fieldname %>\">"
			<%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){ %>
				trstr += "<textarea class=\"area_txt a_intext input_txt <%if(i==0){ %>input_first<%} %>\" placeholder=\"请输入...\" id=\"p_<%=fieldname %>_value_"+rowindex2+"\" name=\"p_<%=fieldname %>_value_"+rowindex2+"\">"+fieldval+"</textarea>";
			<%}else if(fieldname.indexOf("date")>-1){//日期 %>
				trstr += "<input type=\"text\" class=\"scroller_date a_intext input_tx scroller_date"+rowindex2+"\" placeholder=\"请选择日期...\" id=\"p_<%=fieldname %>_value_"+rowindex2+"\" readonly=\"readonly\" name=\"p_<%=fieldname %>_value_"+rowindex2+"\" value=\""+fieldval+"\">";
			<%}else{%>
				trstr += "<input class=\"input_txt a_intext <%if(i==0){%>input_first<%}%>\" placeholder=\"请输入...\"  id=\"p_<%=fieldname %>_value_"+rowindex2+"\" name=\"p_<%=fieldname %>_value_"+rowindex2+"\"";
				<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
				trstr += " type=\"number\" onkeypress=\"ItemNum_KeyPress('p_<%=fieldname %>_value_"+rowindex2+"')\" onblur=\"checknumber('p_<%=fieldname %>_value_"+rowindex2+"')\" maxlength=\"5\"";
				<%}else{%>
					trstr +=" type=\"text\"";
				<%} %>
				<%if(fieldname.equals("cate")){%>
				//分类字段会自动引用前一行数据的分类
				if(itemMap==null){
					if(getVal(insertindex)!=""){
						fieldval = jQuery("#p_cate_value_"+insertindex).val();
					}else{
						if(jQuery("#maintable2").find("tr.tr_show").length>0){
							var lastindex = jQuery("#maintable2").find("tr.tr_show:last").attr("_index");
							fieldval = jQuery("#p_cate_value_"+lastindex).val();
						}
					}
				}
				trstr += " onchange=\"seteditspan(2)\"";
				<%}%>
				<%if(fieldname.equals("name")||fieldname.equals("cate")){%> 
				trstr += " maxlength=\"100\"";
				<%} %>
				trstr += " value=\""+fieldval+"\"/>";
			<%} %>
				trstr += "<span class=\"must_img\"></span></td>";
				trstr +="</tr>";
			<%	} %>
					
				if(getVal(insertindex)!=""){
					jQuery("#tr2_"+insertindex).after(trstr);
				}else{
					jQuery("#maintable2").append(trstr);
				}
				bindarea("tr2_"+rowindex2);
				initMdate("scroller_date"+rowindex2);
				rowindex2++;
				rowi2++;
				jQuery("#index2").val(rowindex2);
				itemMap = null;
				setIndex(2);
				<%if(hascate2){%>seteditspan(2);<%}%>
			}
			//删除工作计划
			function doDelRow2(){
				var checks = jQuery("#maintable2").find("input:checked");
				if(checks.length>0){
					if(confirm("确定删除选择明细项?")){
						checks.each(function(){
							var _index = jQuery(this).attr("_index");
							jQuery(".tr2_"+_index).remove();
							rowi2--;
						});
						var checkspan = $('#maintable2').find('.optSpan1');
						if(checkspan.length>0){
						  checkspan.each(function(i){
						    $(this).html("计划"+(parseInt(i)+parseInt(1))+":");
						  });
						  rowi2 = checkspan.length;
						}
					}
				}else{
					alert("请选择删除项!");
				}
				setIndex(2);
			}
			//插入一行数据
			function insertRow(obj){
				var index = jQuery(obj).parent().attr("_index");
				var type = jQuery(obj).parent().attr("_type");
				if(type==1){
					doAddRow1(index);
				}else{
					doAddRow2(index);
				}
			}
			function checkMyDate(inputname){
				var daysid = "";
				if(inputname.indexOf("begindate1")>-1 || inputname.indexOf("enddate1")>-1){
					var begindate1 = "";
					var enddate1 = "";
					var days1 = "";
					if(inputname.indexOf("begindate1")>-1){
						daysid = inputname.replace("begindate1","days1");
						begindate1 = getVal(jQuery("#"+inputname).val());
						if(jQuery("#"+inputname.replace("begindate1","enddate1")).length>0)
							enddate1 = getVal(jQuery("#"+inputname.replace("begindate1","enddate1")).val());
					}else if(inputname.indexOf("enddate1")>-1){
						daysid = inputname.replace("enddate1","days1");
						if(jQuery("#"+inputname.replace("enddate1","begindate1")).length>0) 
							begindate1 = getVal(jQuery("#"+inputname.replace("enddate1","begindate1")).val());
						enddate1 = getVal(jQuery("#"+inputname).val());
					}
					if(begindate1!="" && enddate1!=""){
						days1 = compdatedays(begindate1,enddate1);
						if(days1<0){
							alert("结束日期不能小于开始日期！");
							jQuery("#"+inputname).val("");
							jQuery("#"+inputname.replace("value","span")).html("");
						}else{
							if(jQuery("#"+daysid).length>0) 
								jQuery("#"+daysid).val(days1);
						}
					}
				}
				else if(inputname.indexOf("begindate2")>-1 || inputname.indexOf("enddate2")>-1){
					var begindate2 = "";
					var enddate2 = "";
					var days2 = "";
					if(inputname.indexOf("begindate2")>-1){
						daysid = inputname.replace("begindate2","days2");
						begindate2 = getVal(jQuery("#"+inputname).val());
						if(jQuery("#"+inputname.replace("begindate2","enddate2")).length>0)
							enddate2 = getVal(jQuery("#"+inputname.replace("begindate2","enddate2")).val());
					}else if(inputname.indexOf("enddate2")>-1){
						daysid = inputname.replace("enddate2","days2");
						if(jQuery("#"+inputname.replace("enddate2","begindate2")).length>0) 
							begindate2 = getVal(jQuery("#"+inputname.replace("enddate2","begindate2")).val());
						enddate2 = getVal(jQuery("#"+inputname).val());
					}
	
					if(begindate2!="" && enddate2!=""){
						days2 = compdatedays(begindate2,enddate2);
						if(days2<0){
							alert("结束日期不能小于开始日期！");
							jQuery("#"+inputname).val("");
							jQuery("#"+inputname.replace("value","span")).html("");
						}else{
							if(jQuery("#"+daysid).length>0) 
								jQuery("#"+daysid).val(days2);
						}
					}
				}
			}
			<%}%>
function getVal(val){
	if(val==null || typeof(val)=="undefined"){
		return "";
	}else{
		return val;
	}
}
function compdatedays(a, b) {
    var arr = a.split("-");
    var starttime = new Date(arr[0], arr[1]-1, arr[2]);
    var starttimes = starttime.getTime();

    var arrs = b.split("-");
    var lktime = new Date(arrs[0], arrs[1]-1, arrs[2]);
    var lktimes = lktime.getTime();

    var days = (lktimes - starttimes)/(3600*1000*24);
    return days;
}
function selectUser(returnIdField,returnShowField,browserType){//选择人员入口
		if(jQuery("#userChooseFrame").length>0){//此判断表示在云桥中访问，支持云桥选择人员方法
		//设置选择人员框参数
		jQuery("#userChooseFrame")[0].contentWindow.resetBrowser({
			"fieldId" : returnIdField, //存储ID值的元素id，一般为input
			"fieldSpanId" : returnShowField, //显示人员名字的元素id，一般为span
			"browserType" : browserType, //类型 1：多选  2：单选
			"showDept": "0", //是否只显示同部门的人员 1：是 0：否 
			"selectedIds" : jQuery("#"+returnIdField).val(), //已选择的值
			"callbackBack" : "onHrmBrowserBack_dt", //选择关闭回调方法
			"callbackOk" : "onBrowserOk" //选择确定回调方法
		});
		
		//打开选择人员框，固定写法，无需修改
		_scrolltop = jQuery(document).scrollTop();
		jQuery("#userChooseDiv").animate({ "left":"0" },400,null,function(){
			setTimeout(function(){
				jQuery(document).scrollTop(0);
			},500);
		});
	}else{
		//非云桥中访问可调用原始方法
	}
	}
	/*关闭选择人员回调*/
	function onHrmBrowserBack_dt(){
		//固定写法，无需修改
		jQuery(document).scrollTop(_scrolltop);
		jQuery("#userChooseDiv").animate({ "left":_wwidth*2 },400,null,function(){});
	}
	function onBrowserOk(result){
		var fieldId = result["fieldId"];
		var fieldSpanId = result["fieldSpanId"];
		var idValue = result["idValue"];
		var nameValue = result["nameValue"];
		if(confirm("确定保存共享设置？")){
			jQuery.ajax({
				type: "post",
				dataType:"json",
				url: "PlanOperation.jsp",
				data:{"operation":"set_share","planid":"<%=planid%>","shareids":idValue}, 
				contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				complete: function(data){ 
					if(idValue!=""){
						$("#"+fieldId).val(idValue);
		                $("#"+fieldSpanId).val(nameValue.replace(/,/g,' '));
					}else{
						$("#"+fieldId).val("");
		                $("#"+fieldSpanId).val("");
					}
				}
		  });
	   }
	   //关闭选择框，固定写法，无需修改
	jQuery(document).scrollTop(_scrolltop);
	jQuery("#userChooseDiv").animate({ "left":_wwidth*2 },400,null,function(){});
	};
	<%if(editshare){%>
		function doShare(){
		    selectUser('shareids','hrmidsSpan',1);
		}
<%}%>
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
function highEditor(remarkid,height){
    height=!height||height<150?150:height;
    
    if(jQuery("#"+remarkid).is(":visible")){

		var  items=[
						'justifyleft', 'justifycenter', 'justifyright','bold','italic','fullscreen'
				   ];
			 
		 K.createEditor({
				id : remarkid,
				height :height+'px',
				themeType:'mobile',
				resizeType:1,
				width:'100%',
				uploadJson:'/weaverEditor/jsp/upload_json.jsp',
			    allowFileManager : false,
                newlineTag:'br',
                filterMode:false,
				imageTabIndex:1,
				langType : 'en',
                items : items,
			    afterCreate : function(id) {
					//KE.util.focus(id);
					this.focus();
			    }
   		});
	}
}
</script>
</body>
</html>