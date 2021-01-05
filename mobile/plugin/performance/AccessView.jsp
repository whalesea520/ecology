<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.util.Map.*"%>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.gp.util.RightUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");
//所有经理及考核成绩评分人、考核成绩确认人有权限查看
String userid = user.getUID()+"";
String year = Util.null2String(request.getParameter("year"));
String type1 = Util.null2String(request.getParameter("type1"));
String type2 = Util.null2String(request.getParameter("type2"));
String scoreid = Util.null2String(request.getParameter("scoreid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String isrefresh = Util.null2String(request.getParameter("isrefresh"));
String back = Util.null2String(request.getParameter("back"));
String scorename = "";
String status = "";
String result = "0.00";
String auditid = "";
String isupdate = "";
String isfirst = "";
String operator = "";
String auditids = "";
String remark = "";
String s_startdate = "";
String s_enddate = "";

String currentdate = TimeUtil.getCurrentDateString();
String msg = "";
String viewdate = "";

String sql = "";
if(!scoreid.equals("")){
	if("oracle".equals(rs.getDBType())){
		sql = "select id,scorename,status,result,userid,year,type1,type2,startdate,enddate,isupdate,isfirst,operator,auditids,remark"
			+",(select v.viewdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as viewdate,scoreid from GP_AccessScoreLog where operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) v where v.scoreid=GP_AccessScore.id and rownum=1) as viewdate"
			+" from GP_AccessScore where isvalid=1 and id="+scoreid;
	}else{
		sql = "select id,scorename,status,result,userid,year,type1,type2,startdate,enddate,isupdate,isfirst,operator,auditids,remark"
			+",(select top 1 operatedate+' '+operatetime from GP_AccessScoreLog where GP_AccessScoreLog.scoreid=GP_AccessScore.id and operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) as viewdate"
			+" from GP_AccessScore where isvalid=1 and id="+scoreid;
	}
	rs.executeSql(sql);
	if(rs.next()){
		resourceid = Util.null2String(rs.getString("userid"));
		year = Util.null2String(rs.getString("year"));
		type1 = Util.null2String(rs.getString("type1"));
		type2 = Util.null2String(rs.getString("type2"));
		scorename = Util.null2String(rs.getString("scorename"));
		status = Util.null2String(rs.getString("status"));
		result = Util.null2String(rs.getString("result"));
		isupdate = Util.null2String(rs.getString("isupdate"));
		isfirst = Util.null2String(rs.getString("isfirst"));
		operator = Util.null2String(rs.getString("operator"));
		auditids = Util.null2String(rs.getString("auditids"));
		remark = Util.null2String(rs.getString("remark"));
		s_startdate = Util.null2String(rs.getString("startdate"));
		s_enddate = Util.null2String(rs.getString("enddate"));
		viewdate = Util.null2String(rs.getString("viewdate"));
	}else{
		out.print("<table width='100%'><tr><td align='center'>您暂未开启任何考核周期！</td></tr></table>");
		return;
	}
}else{
	if(resourceid.equals("")){
		out.print("<table width='100%'><tr><td align='center'>您暂未开启任何考核周期！</td></tr></table>");
		return;//人员不能为空
	}
	//年份、类型取默认值
	if(year.equals("")){
		year = Util.null2String((String)request.getSession().getAttribute("GP_ACCESS_YEAR"));
		if(year.equals("")) year = currentdate.substring(0,4);
	}
	if(type1.equals("")){
		type1 = Util.null2String((String)request.getSession().getAttribute("GP_ACCESS_TYPE1"));
	}
	if(type2.equals("")){
		type2 = Util.null2String((String)request.getSession().getAttribute("GP_ACCESS_TYPE2_"+type1));
	}
}
	
//判断是否能查看
boolean caninit = false;
boolean canview = false;
boolean istime = false;
boolean canedit = false;
boolean canaudit = false;
//boolean canback = false;


int isfyear = 0;       
int ishyear = 0;     
int isquarter = 0;       
int ismonth = 0;    
String accessconfirm = "";
String accessview = "";
int fstarttype = 0;      
int fstartdays = 0;      
int fendtype = 0;        
int fenddays = 0;        
int hstarttype = 0;      
int hstartdays = 0;      
int hendtype = 0;        
int henddays = 0;        
int qstarttype = 0;      
int qstartdays = 0;      
int qendtype = 0;        
int qenddays = 0;        
int mstarttype = 0;      
int mstartdays = 0;      
int mendtype = 0;        
int menddays = 0;        
String docsecid = "";
double scoremin = -5;
double scoremax = 5;
double revisemin = -2;
double revisemax = 2; 
rs.executeSql("select * from GP_BaseSetting where resourceid=" + ResourceComInfo.getDepartmentID(resourceid) + " and resourcetype=3");
if(rs.next()){
	accessconfirm = Util.null2String(rs.getString("accessconfirm"));  
	accessview = Util.null2String(rs.getString("accessview")); 
	docsecid = Util.null2String(rs.getString("docsecid")); 
	scoremin = Util.getDoubleValue(rs.getString("scoremin"),-5);
	scoremax = Util.getDoubleValue(rs.getString("scoremax"),5);
	revisemin = Util.getDoubleValue(rs.getString("revisemin"),-2);
	revisemax = Util.getDoubleValue(rs.getString("revisemax"),2);
	rs2.executeSql("select * from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
	if(rs2.next()){
		isfyear = Util.getIntValue(rs2.getString("isfyear"),0);       
		ishyear = Util.getIntValue(rs2.getString("ishyear"),0);        
		isquarter = Util.getIntValue(rs2.getString("isquarter"),0);      
		ismonth = Util.getIntValue(rs2.getString("ismonth"),0);   
		fstarttype = Util.getIntValue(rs2.getString("fstarttype"),0);     
		fstartdays = Util.getIntValue(rs2.getString("fstartdays"),0);     
		fendtype = Util.getIntValue(rs2.getString("fendtype"),0);       
		fenddays = Util.getIntValue(rs2.getString("fenddays"),0);       
		hstarttype = Util.getIntValue(rs2.getString("hstarttype"),0);     
		hstartdays = Util.getIntValue(rs2.getString("hstartdays"),0);     
		hendtype = Util.getIntValue(rs2.getString("hendtype"),0);       
		henddays = Util.getIntValue(rs2.getString("henddays"),0);       
		qstarttype = Util.getIntValue(rs2.getString("qstarttype"),0);     
		qstartdays = Util.getIntValue(rs2.getString("qstartdays"),0);     
		qendtype = Util.getIntValue(rs2.getString("qendtype"),0);       
		qenddays = Util.getIntValue(rs2.getString("qenddays"),0);       
		mstarttype = Util.getIntValue(rs2.getString("mstarttype"),0);     
		mstartdays = Util.getIntValue(rs2.getString("mstartdays"),0);     
		mendtype = Util.getIntValue(rs2.getString("mendtype"),0);       
		menddays = Util.getIntValue(rs2.getString("menddays"),0);    
		if("".equals(docsecid) || "0".equals(docsecid)) docsecid = Util.null2String(rs2.getString("docsecid")); 
	}
}else{
	rs.executeSql("select * from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
	if(rs.next()){
		isfyear = Util.getIntValue(rs.getString("isfyear"),0);       
		ishyear = Util.getIntValue(rs.getString("ishyear"),0);        
		isquarter = Util.getIntValue(rs.getString("isquarter"),0);      
		ismonth = Util.getIntValue(rs.getString("ismonth"),0);   
		accessconfirm = Util.null2String(rs.getString("accessconfirm"));  
		accessview = Util.null2String(rs.getString("accessview")); 
		fstarttype = Util.getIntValue(rs.getString("fstarttype"),0);     
		fstartdays = Util.getIntValue(rs.getString("fstartdays"),0);     
		fendtype = Util.getIntValue(rs.getString("fendtype"),0);       
		fenddays = Util.getIntValue(rs.getString("fenddays"),0);       
		hstarttype = Util.getIntValue(rs.getString("hstarttype"),0);     
		hstartdays = Util.getIntValue(rs.getString("hstartdays"),0);     
		hendtype = Util.getIntValue(rs.getString("hendtype"),0);       
		henddays = Util.getIntValue(rs.getString("henddays"),0);       
		qstarttype = Util.getIntValue(rs.getString("qstarttype"),0);     
		qstartdays = Util.getIntValue(rs.getString("qstartdays"),0);     
		qendtype = Util.getIntValue(rs.getString("qendtype"),0);       
		qenddays = Util.getIntValue(rs.getString("qenddays"),0);       
		mstarttype = Util.getIntValue(rs.getString("mstarttype"),0);     
		mstartdays = Util.getIntValue(rs.getString("mstartdays"),0);     
		mendtype = Util.getIntValue(rs.getString("mendtype"),0);       
		menddays = Util.getIntValue(rs.getString("menddays"),0);    
		docsecid = Util.null2String(rs.getString("docsecid")); 
		scoremin = Util.getDoubleValue(rs.getString("scoremin"),-5);
		scoremax = Util.getDoubleValue(rs.getString("scoremax"),5);
		revisemin = Util.getDoubleValue(rs.getString("revisemin"),-2);
		revisemax = Util.getDoubleValue(rs.getString("revisemax"),2);
	}
}
if(isfyear!=1 && ishyear!=1 && isquarter!=1 && ismonth!=1) {
	out.print("<table width='100%'><tr><td align='center'>您暂未开启任何考核周期！</td></tr></table>");
	return;//未启用任何考核
}
if(isfyear!=1 && type1.equals("4")) type1 = "";
if(ishyear!=1 && type1.equals("3")) type1 = "";
if(isquarter!=1 && type1.equals("2")) type1 = "";
if(ismonth!=1 && type1.equals("1")) type1 = "";
if(type1.equals("")){
	if(isfyear==1){ type1 = "4";}
	if(ishyear==1){ type1 = "3";}
	if(isquarter==1){ type1 = "2";}
	if(ismonth==1){ type1 = "1";}
}
if(type2.equals("")){
	if(type1.equals("4") || type1.equals("3")) type2 = "0";
	if(type1.equals("2")) type2 = TimeUtil.getCurrentSeason();
	if(type1.equals("1")) type2 = currentdate.substring(5,7);
	rs.executeSql("select count(id) from GP_AccessScore where userid="+resourceid+" and year="+year+" and type1="+type1+" and type2="+type2+" and startdate<='"+currentdate+"'");
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
				type2 = "4";
			}else{
				type2 = (Integer.parseInt(type2)-1)+"";
			}
		}else{
			year = (Integer.parseInt(year)-1)+"";
		}
	}
}
if(resourceid.equals(userid)){
	canview = true;
}else if(ResourceComInfo.isManager(user.getUID(),resourceid)){
	canview = true;
}else if((","+accessconfirm+",").indexOf(","+userid+",")>-1){
	canview = true;
}else if((","+accessview+",").indexOf(","+userid+",")>-1){
	canview = true;
}


//判断考核起止时间， 考核开始之前，不能查看
String basedate = "";
String begindate = "";
String enddate = "";
String titlestr = "";
if(type1.equals("1")){
	basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),Integer.parseInt(type2));
	begindate = TimeUtil.dateAdd(basedate,mstartdays*mstarttype);
	enddate = TimeUtil.dateAdd(basedate,menddays*mendtype);
	titlestr = "下月";
}else if(type1.equals("2")){
	if(type2.equals("1")) basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),3);
	if(type2.equals("2")) basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),6);
	if(type2.equals("3")) basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),9);
	if(type2.equals("4")) basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),12);
	begindate = TimeUtil.dateAdd(basedate,qstartdays*qstarttype);
	enddate = TimeUtil.dateAdd(basedate,qenddays*qendtype);
	titlestr = "下季度";
}else if(type1.equals("3")){
	basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),6);
	begindate = TimeUtil.dateAdd(basedate,hstartdays*hstarttype);
	enddate = TimeUtil.dateAdd(basedate,henddays*hendtype);
	titlestr = (Integer.parseInt(year)+1)+"半年";
}else if(type1.equals("4")){
	basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),12);
	begindate = TimeUtil.dateAdd(basedate,fstartdays*fstarttype);
	enddate = TimeUtil.dateAdd(basedate,fenddays*fendtype);
	titlestr = (Integer.parseInt(year)+1)+"年";
}
if(scoreid.equals("")){
	if("oracle".equals(rs.getDBType())){
		sql = "select id,scorename,status,result,userid,year,type1,type2,startdate,enddate,isupdate,isfirst,operator,auditids,remark"
			+",(select v.viewdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as viewdate,scoreid from GP_AccessScoreLog where operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) v where v.scoreid=GP_AccessScore.id and rownum=1) as viewdate"
			+" from GP_AccessScore"
			+" where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and userid="+resourceid;
	}else{
		sql = "select id,scorename,status,result,userid,year,type1,type2,startdate,enddate,isupdate,isfirst,operator,auditids,remark"
			+",(select top 1 operatedate+' '+operatetime from GP_AccessScoreLog where GP_AccessScoreLog.scoreid=GP_AccessScore.id and operator="+user.getUID()+" and operatetype=0 order by operatedate desc,operatetime desc) as viewdate"
			+" from GP_AccessScore"
			+" where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and userid="+resourceid;
	}
	
	rs.executeSql(sql);
	if(rs.next()){
		scoreid = Util.null2String(rs.getString("id"));
		scorename = Util.null2String(rs.getString("scorename"));
		status = Util.null2String(rs.getString("status"));
		result = Util.getDoubleValue(rs.getString("result"),0)+"";
		isupdate = Util.null2String(rs.getString("isupdate"));
		isfirst = Util.null2String(rs.getString("isfirst"));
		operator = Util.null2String(rs.getString("operator"));
		auditids = Util.null2String(rs.getString("auditids"));
		remark = Util.null2String(rs.getString("remark"));
		s_startdate = Util.null2String(rs.getString("startdate"));
		s_enddate = Util.null2String(rs.getString("enddate"));
		viewdate = Util.null2String(rs.getString("viewdate"));
	}
}
if(TimeUtil.dateInterval(currentdate,enddate)>=0) istime = true;
if(!scoreid.equals("")){
	if(TimeUtil.dateInterval(begindate,currentdate)<0){
		msg = "此考核将在"+begindate+"开始进行";
	}
}else{
	//查找已确定的考核方案
	rs.executeSql("select count(id) from GP_AccessProgram where startdate<='"+begindate+"' and programtype="+type1+" and userid="+resourceid+" and status=3");
	if(rs.next() && rs.getInt(1)>0){
		if(TimeUtil.dateInterval(currentdate, begindate)>0){
			msg = "此考核将在"+begindate+"开始进行";
		}else{
			msg = "此周期暂无数据";
		}
	}else{
		msg = "未设置已确认的考核方案";
	}
}

if(!canview){
	if((","+auditids+",").indexOf(","+userid+",")<0){
		//查询是否评分过
		rs.executeSql("select count(id) from GP_AccessScoreCheck where scoreid="+scoreid+" and userid="+userid);
		if(rs.next() && rs.getInt(1)==0){
			//查询是否审批过
			rs.executeSql("select count(id) from GP_AccessScoreLog where scoreid="+scoreid+" and operatetype in (4,5) and operator="+userid);
			if(rs.next() && rs.getInt(1)==0){
				msg = "您暂时无权限查看此数据！";
			}
			//response.sendRedirect("/performance/util/Message.jsp?type=1");
		    //return ;
		}
	}
}

canaudit = RightUtil.isCanAuditScore(scoreid,userid);
if(isupdate.equals("1") && isfirst.equals("1") && operator.equals(userid)){
	caninit = true;
}
int checksize = 0;

int islog = Util.getIntValue(request.getParameter("islog"),1);
if(!scoreid.equals("") && islog==1){
	OperateUtil.addScoreLog(userid,scoreid,0);
}

boolean canreset = RightUtil.isCanResetScore(scoreid,userid);

boolean canupload = false;

List scoreList = new ArrayList();

boolean hascate = false;
Map countmap = new HashMap();

//是否启用计划报告
boolean isplan = weaver.workrelate.util.TransUtil.isplan();
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
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<!-- ajax提交form表单 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery.form.js'></script>
		<script type='text/javascript' src='/mobile/plugin/task/js/task.js'></script>
		<!-- 多行文本框自动更改高度 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery.textarea.autoheight.js'></script>
		<!-- 遮罩层 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/showLoading/js/jquery.showLoading.js'></script>
		<link rel="stylesheet" href="/mobile/plugin/task/js/showLoading/css/showLoading.css" />
		
		<link rel="stylesheet" href="/mobile/plugin/performance/css/perf.css" />
		<link rel="stylesheet" href="/mobile/plugin/performance/css/add.css" />
		<style type="text/css">
			#header{display: block;}
			*{font-family: arial,微软雅黑;text-shadow:none !important;font-size:14px;}
		    .controlTdHeader {margin: 10px 0px 0 0px;color: #333;border-bottom: 1px #59D445 solid;padding: 5px 10px !important;font-size: 14px !important;}
		    .controlTdHeader {margin: 0px !important;padding: 0px !important;height: 0px !important;}
		    .ctth{border-bottom:1px #59D445 solid !important;}
		    .controlTdRight{border-right:1px solid #f0f0f0;}
		    .head_more{width: auto;float:right;padding-right: 3px;font-weight: bold;display: none;}
		    .formula{color: #AFAFAF;}
		    .controlTdHeader2 {margin: 10px 0px 0 0px;color: #333;border-bottom: 1px solid #ddd;padding: 5px 10px !important;font-size: 14px !important;}
		    .datable td span{font-size:13px;}
		    .edit_title{background: #f5f3f3 !important;}
		</style>
		<title><%=scorename %></title>
	</head>
	<body id="body">
		<form id="form1" name="form1" action="/mobile/plugin/performance/AccessOperation.jsp" method="post">
		<table class="taskTable" cellpadding="0" cellspacing="0">
		   <tr>
			<td valign="top">
				<div id="topmain" class="topmain"><!-- 顶部 -->
					<div id="header">
					   <div id="divCoworkName"><span onclick="doBack();"><%="".equals(scorename)?"无绩效考核":scorename %></span></div>
					   <div id="divCoworkSub" >
						  <span id="spaninfo"></span>
				  	   </div>
					</div>
				</div>
			</td>
		   </tr>
		</table>
		<div id="tabblank" class="tabblank"></div><!-- 站位顶部导航FIXED的空白 -->
		<input type="hidden" id="type1" name="type1" value="<%=type1%>"/>
		<input type="hidden" id="type2" name="type2" value="<%=type2%>"/>
		<input type="hidden" id="year" name="year" value="<%=year%>"/>
		<input type="hidden" id="scoreid" name="scoreid" value="<%=scoreid %>"/>
		<input type="hidden" id="resourceid" name="resourceid" value="<%=resourceid %>"/>
		<input type="hidden" id="back" name="back" value="<%=back %>"/>
		<input type="hidden" id="operation" name="operation" value=""/>
		<div class="tabpanel">
			<ul>
				<%if(isfyear==1){ %><li class="tab <%if(type1.equals("4")){ %>tab_click<%} %>" data-value="4">年度</li><%} %>
				<%if(ishyear==1){ %><li class="tab <%if(type1.equals("3")){ %>tab_click<%} %>" data-value="3">半年</li><%} %>
				<%if(isquarter==1){%><li class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" data-value="2">季度</li><%} %>
				<%if(ismonth==1){ %><li class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" data-value="1">月度</li><%} %>
			</ul>
		</div>
	                
	                <%if(!msg.equals("")){ %>
	                   <table class="dtable">
							   <colgroup><col width="50%" /><col width="50%" /></colgroup>
							   <tbody>	
							     <tr>
							     <td>选择年份<span class="Design_FSelect_Fielddom">
							     <select id="syear" class="sle MADFS_Left_Select">
							       <% 
										int currentyear = Integer.parseInt(currentdate.substring(0,4));
										for(int i=2013;i<(currentyear+3);i++){ %>
										  <option value="<%=i %>" <%if(Integer.parseInt(year)==i){ %>selected<%} %>><%=i %></option>
								  <%} %>
							     </select></span></td>
							     <%if(type1.equals("1")){ %>
							     <td>
							        选择月份<span class="Design_FSelect_Fielddom">
									<select id="smonth" class="sle MADFS_Left_Select">
									<%for(int i=1;i<13;i++){ %>
									    <option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>月</option>
									<%} %>
									</select></span></td>
									<%}else if(type1.equals("2")){ %>
									<td>选择季度<span class="Design_FSelect_Fielddom">
									<select id="squarter" class="sle MADFS_Left_Select">
									<%for(int i=1;i<5;i++){ %>
									  <option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>季度</option>
									<%} %>
									</select></span></td>
									<%}%>
							     </tr>
							   </tbody>
							</table>
					   <font style="color: red;font-size: 13px;margin-left: 5px;"><%=msg %></font>
					<%}else{ 
							int indexnum = 0;
							int itemtype = 0;
							int formula = 0;
							String formuladetail = "";
							String item_target = "";
							String item_result = "";
							String item_result2 = "0";
							String item_next = "";
							String deatilid = "";
							if(!scoreid.equals("")){
								String backfields = "select t.id,t.cate,t.accessitemid,t.description,t.rate,t.target1,t.target2,t.result1,t.result2,t.next1,t.next2";
								String fromsql = " from GP_AccessScoreDetail t";
								String sqlwhere = " where t.scoreid="+scoreid;
								String orderby = " order by t.id";
								String tname = "";
								String detailedit = "";
								int dindex = 0;
								//读取评分信息
								rs.executeSql("select id,scoreid,userid,rate,score,revise,result,remark,status,fileids,reason from GP_AccessScoreCheck where scoreid="+scoreid+" order by exeorder");
								while(rs.next()){
									if("1".equals(rs.getString("status"))) auditid = rs.getString("userid");
									if(userid.equals(rs.getString("userid")) && "1".equals(rs.getString("status")) && istime){
										canedit = true;
										detailedit = "1";
									}else{
										detailedit = "0";
									}
									String[] scoreinfo = {rs.getString("id"),rs.getString("userid"),rs.getString("rate"),rs.getString("score")
												,rs.getString("revise"),rs.getString("result"),rs.getString("remark"),rs.getString("stauts"),detailedit,rs.getString("fileids"),rs.getString("reason")}; 
									scoreList.add(scoreinfo);
									tname = "t"+dindex;
									backfields += ","+tname+".score as score_"+dindex+","+tname+".result as result_"+dindex+","+tname+".remark as remark_"+dindex+","+tname+".id as cdid_"+dindex;
									fromsql += " left join GP_AccessScoreCheckDetail "+tname+" on t.id="+tname+".detailid and "+tname+".checkid="+rs.getString("id");
									dindex++;
								}
									
								checksize = scoreList.size();
								if((status.equals("0") || status.equals("1") || status.equals("2")) && TimeUtil.dateInterval(s_enddate,currentdate)>0){
									 spanInfo ="状态: 已过期";
								}else{ 
									 spanInfo = "0".equals(status)?"状态: 考核中":"1".equals(status)?"状态: 审批中":"2".equals(status)?"状态: 未开始":"3".equals(status)?"状态: 已完成":"";
								} 
							    if(status.equals("0") || status.equals("2")){ 
							    	if(!"".equals(spanInfo)) spanInfo +=", "; 
									spanInfo += "待考核人: "+cmutil.getPerson2(auditid)+", 截止日期: "+s_enddate;
								}else if(status.equals("1")){
									if(!"".equals(spanInfo)) spanInfo +=", "; 
									spanInfo += "待审批人: "+cmutil.getPerson2(RightUtil.getUnAuditScoreHrm(scoreid))+", 截止日期: "+s_enddate;
							    }
							%>
							<table class="dtable">
							   <colgroup><col width="50%" /><col width="50%" /></colgroup>
							   <tbody>	
							     <tr>
							     <td>选择年份
							     <span class="Design_FSelect_Fielddom">
							     <select id="syear" class="sle MADFS_Left_Select">
							       <% 
										int currentyear = Integer.parseInt(currentdate.substring(0,4));
										for(int i=2013;i<(currentyear+3);i++){ %>
										  <option value="<%=i %>" <%if(Integer.parseInt(year)==i){ %>selected<%} %>><%=i %></option>
								  <%} %>
							     </select></span></td>
							     <%if(type1.equals("1")){ %>
							     <td>
							        选择月份<span class="Design_FSelect_Fielddom">
									<select id="smonth" class="sle MADFS_Left_Select">
									<%for(int i=1;i<13;i++){ %>
									    <option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>月</option>
									<%} %>
									</select></span></td>
									<%}else if(type1.equals("2")){ %>
									<td>选择季度<span class="Design_FSelect_Fielddom">
									<select id="squarter" class="sle MADFS_Left_Select">
									<%for(int i=1;i<5;i++){ %>
									  <option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>季度</option>
									<%} %>
									</select></span></td>
									<%}%>
							     </tr>
							   </tbody>
							</table>
							<div id="dtitle0" class="dtitle"><div class="dtxt">考核指标信息</div><div class="pullDown"></div></div>
							<div>
							   <%rs.executeSql(backfields+fromsql+sqlwhere+orderby);
								//System.out.println(backfields+fromsql+sqlwhere);
								String xmyj = "formtable_main_179";//formtable_main_130
								int index1 = 1;
								while(rs.next()){
									if(!Util.null2String(rs.getString("cate")).equals("")) hascate = true;
									deatilid = Util.null2String(rs.getString("id"));
									itemtype = Util.getIntValue(AccessItemComInfo.getType(Util.null2String(rs.getString("accessitemid"))),0);
									formula = Util.getIntValue(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))),0);
									formuladetail = AccessItemComInfo.getFormuladetails(Util.null2String(rs.getString("accessitemid")));
									if(itemtype==1){
										item_target = Util.null2String(rs.getString("target2"));
										item_result = Util.null2String(rs.getString("result2"));
										item_next = Util.null2String(rs.getString("next2"));
									}else{
										item_target = Util.null2String(rs.getString("target1"));
										item_result = Util.null2String(rs.getString("result1"));
										item_next = Util.null2String(rs.getString("next1"));
									}
									//针对项目收款及验收自动获取数据
									if(itemtype==2 && (formula==2 || formula==3)){
										countmap.put(deatilid,formula);
										item_result2 = "";
										rs2.executeSql("select skmbz,sksjz,skyxz,ysmbz,yssjz,ysyxz from "+xmyj+" where xmry="+resourceid+" and yjnf="+year+" and yjyf="+type2);
										if(rs2.next()){
											if(formula==2){
												item_target = Util.getDoubleValue(rs2.getString("skmbz"),0)+"";
												item_result = Util.getDoubleValue(rs2.getString("sksjz"),0)+"";
												item_result2 = Util.getDoubleValue(rs2.getString("skyxz"),0)+"";
											}else{
												item_target = Util.getDoubleValue(rs2.getString("ysmbz"),0)+"";
												item_result = Util.getDoubleValue(rs2.getString("yssjz"),0)+"";
												item_result2 = Util.getDoubleValue(rs2.getString("ysyxz"),0)+"";
											}
										}else{
											item_target = "0";
											item_result = "0";
											item_result2 = "0";
										}
										
										//2014年2月之后采取从两个表中读取数据
										int iyear = Integer.parseInt(year);
										int imonth = Integer.parseInt(type2);
										if((iyear==2014 && imonth>=2) || iyear>2014){
											rs2.executeSql("select skmbz,ysmbz from formtable_main_218 where xmry="+resourceid+" and yjnf="+year+" and yjyf="+type2);
											if(rs2.next()){
												if(formula==2){
													item_target = Util.getDoubleValue(rs2.getString("skmbz"),0)+"";
												}else{
													item_target = Util.getDoubleValue(rs2.getString("ysmbz"),0)+"";
												}
											}else{
												item_target = "0";
											}
										}
									}
							   %>
							   <table class="datable" style="margin-top:1px;">
							   <colgroup><col width="18%" /><col width="12%" /><col width="70%" /></colgroup>
							   <tbody>	
							     <tr>
							       <td class="controlTdHeader" colspan="3"><!--<span style="font-size:14px;">考核指标项<%=index1 %>:</span><span class="head_more">. . .</span>--></td>
							     </tr>
							     <tr class="td_cate">
							       <td style="border-top:0 !important" class="td_font" colspan="2">分类</td><td style="border-top:0 !important"><%=Util.convertDB2Input(rs.getString("cate")) %></td>
							     </tr>
							     <tr>
							        <td colspan="2" class="td_font">指标类型</td><td><%=AccessItemComInfo.getName(Util.null2String(rs.getString("accessitemid")))+this.getFormulaName(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))),AccessItemComInfo.getFormuladetails(Util.null2String(rs.getString("accessitemid")))) %></td>
							     </tr>
							     <tr>
							       <td colspan="2" class="td_font">指标描述</td><td><%=Util.toHtml(rs.getString("description")) %></td>
							     </tr>
							     <tr>
							       <td colspan="2" class="td_font">权重(%)</td><td><%=Util.null2String(rs.getString("rate")) %>
							       <input type="hidden" id="d_rate_<%=deatilid %>" name="d_rate_<%=deatilid %>" value="<%=Util.null2String(rs.getString("rate")) %>"/></td>
							     </tr>
							     <tr>
							       <td colspan="2" class="td_font">目标值</td><td>
							       <%if(itemtype==2 && (formula==2 || formula==3)){ %>
										<input type="hidden" id="target_<%=deatilid %>" name="target_<%=deatilid %>" value="<%=item_target %>"/>  
										<%=item_target %>
									<%}else{ %>
										<%if(canedit){%>
										<input class="input_txt2 intext <%if(itemtype==2){ %>mustinput<%} %>" id="target_<%=deatilid %>" name="target_<%=deatilid %>"
											 value="<%=item_target %>" maxlength="100"  placeholder="请输入..."
											 <%if(itemtype==2){ %>type="number" onKeyPress="ItemNum_KeyPress('target_<%=deatilid %>')" onBlur="checknumber('target_<%=deatilid %>')"<%} else{%>
												 type="text"
											 <%}%>
											 <%if(formula!=0){ %>onchange="doFormula(<%=deatilid %>,<%=formula %>,'<%=formuladetail %>')"<%} %>/><span class="must_img"></span>
										<%}else{ %>
											<%=item_target %>
										<%} %>
									<%} %>
									<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>
							       </td>
							     </tr>
							     <tr>
							       <td colspan="2" class="td_font">完成值</td><td>
							         <%if(itemtype==2 && (formula==2 || formula==3)){ %> 
										<input type="hidden" id="result_<%=deatilid %>" name="result_<%=deatilid %>" value="<%=item_result %>"/> 
										<input type="hidden" id="result2_<%=deatilid %>" name="result2_<%=deatilid %>" value="<%=item_result2 %>"/>   
										实际：<%=item_result %>
										<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %><br/>
										有效：<%=item_result2 %>
										<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>
									<%}else{ %>
										<%if(canedit){%>
										<input class="input_txt2 intext <%if(itemtype==2){ %>mustinput<%} if(formula==12){ %> dofdata<%} %>" id="result_<%=deatilid %>" name="result_<%=deatilid %>"
											 value="<%=item_result %>" maxlength="100" placeholder="请输入..."
											 <%if(itemtype==2){ %>type="number" onKeyPress="ItemNum_KeyPress('result_<%=deatilid %>')" onBlur="checknumber('result_<%=deatilid %>')"<%}else{%>
											    type="text"
											 <%}%>
											 <%if(formula!=0){ %>onchange="doFormula(<%=deatilid %>,<%=formula %>,'<%=formuladetail %>')"<%} %>
											 <%if(formula==12){ %>data-value="<%=deatilid %>,<%=formuladetail %>" <%} %>/><span class="must_img"></span>
										<%}else{ %>
											<%=item_result %>
										<%} %>
										<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>
									<%} %>
							       </td>
							     </tr>
							     <tr>
							       <td colspan="2" class="td_font"><%=titlestr %>目标</td><td><%if(canedit){%>
									<input class="input_txt2 intext  <%if(itemtype==2){ %>mustinput<%} %>" id="next_<%=deatilid %>" name="next_<%=deatilid %>"
										 value="<%=item_next %>" maxlength="100" placeholder="请输入..."
										 <%if(itemtype==2){ %>type="number" onKeyPress="ItemNum_KeyPress('next_<%=deatilid %>')" onBlur="checknumber('next_<%=deatilid %>')"<%}else{%>
										    type="text"
										 <%}%>
										 /><span class="must_img"></span>
									<%}else{ %>
										<%=item_next %>
									<%} %>
									<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %></td>
							     </tr>
							     <!-- 考核人员评分部分 -->
								<%for(int i=0;i<scoreList.size();i++){ 
									String isedit = ((String[])scoreList.get(i))[8];
									String checkid = ((String[])scoreList.get(i))[0];
								%>
							     
							     <tr>
							       <td rowspan="3" class="controlTdRight td_font <%if("1".equals(isedit)){ %>edit_title<%} %>"><%=ResourceComInfo.getResourcename(((String[])scoreList.get(i))[1]) %><br/><%=((String[])scoreList.get(i))[2] %>%</td>
							       <td class="td_font <%if("1".equals(isedit)){ %>edit_title<%} %>">评分</td><td class="<%if("1".equals(isedit)){ %>edit_title<%} %>"><input type="hidden" id="cdid_<%=deatilid %>_<%=checkid %>" name="cdid_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("cdid_"+i)) %>" />
									<%if("1".equals(isedit) && (itemtype==1 || (itemtype==2 && (formula==0||formula==4)))){%>
									<input class="input_txt intext mustinput" type="number" id="d_score_<%=deatilid %>_<%=checkid %>" name="d_score_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("score_"+i)) %>"  maxlength="100" placeholder="请输入..."
										 onKeyPress="ItemNum_KeyPress('d_score_<%=deatilid %>_<%=checkid %>')" onBlur="checknumber('d_score_<%=deatilid %>_<%=checkid %>');"
										 onchange="checkScoreVal('d_score_<%=deatilid %>_<%=checkid %>');countScore(<%=deatilid %>,<%=checkid %>)" <%if(formula==4){ %>_formula4="1"<%} %>/><span class="must_img"></span>
									<%}else{ %>
										<span class="c_scorespan_<%=deatilid %> score_txt" id="d_scorespan_<%=deatilid %>_<%=checkid %>"><%=Util.null2String(rs.getString("score_"+i)) %></span>
										<input type="hidden" class="c_score_<%=deatilid %>" id="d_score_<%=deatilid %>_<%=checkid %>" name="d_score_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("score_"+i)) %>" <%if(formula==4){ %>_formula4="1"<%} %>/>
									<%} %></td>
							     </tr>
							     <tr><td class="td_font <%if("1".equals(isedit)){ %>edit_title<%} %>">得分</td><td class="<%if("1".equals(isedit)){ %>edit_title<%} %>"><span class="c_resultspan_<%=deatilid %> score_txt" id="d_resultspan_<%=deatilid %>_<%=checkid %>"><%=Util.null2String(rs.getString("result_"+i)) %></span>
									<input type="hidden" class="d_result_<%=checkid %> c_result_<%=deatilid %>" id="d_result_<%=deatilid %>_<%=checkid %>" name="d_result_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("result_"+i)) %>" /></td></tr>
								 <tr><td class="td_font <%if("1".equals(isedit)){ %>edit_title<%} %>">说明</td><td class="<%if("1".equals(isedit)){ %>edit_title<%} %>"><%if("1".equals(isedit)){%>
									<textarea class="area_txt a_intext" placeholder="请输入..." id="d_remark_<%=deatilid %>_<%=checkid %>" name="d_remark_<%=deatilid %>_<%=checkid %>"><%=Util.convertDB2Input(rs.getString("remark_"+i)) %></textarea>
									<span class="must_img"></span>
									<%}else{ %>
										<%=Util.toHtml(rs.getString("remark_"+i)) %>
									<%} %></td></tr>
							     <%} %>
							   </tbody>
							</table>
					<%index1++;
						}%></div>
					<div id="dtitle0" class="dtitle" style="margin-top:2px;"><div class="dtxt">评分总结信息</div><div class="pullDown"></div></div>			
					<table class="datable" style="margin-top:1px;">
					   <colgroup><col width="30%" /><col width="70%" /></colgroup>
					   <tbody>
					      <tr><td class="controlTdHeader2">相关说明：</td><td style="border-bottom: 1px solid #ddd;">
					      <%if(remark.equals("")){ %>
								<font style="font-style: italic;color: #C3C3C3;">无</font>
						  <%}else{ %>
							 <%=remark %>
						  <%} %></td></tr>
					   <%for(int i=0;i<scoreList.size();i++){ 
							 String isedit = ((String[])scoreList.get(i))[8];
							 String checkid = ((String[])scoreList.get(i))[0];
							 String fileids = ((String[])scoreList.get(i))[9];
							 double revise = Util.getDoubleValue(((String[])scoreList.get(i))[4],0);%>
							<tr>
							   <td class="controlTdHeader2 ctth" colspan="2" ivals="<%=i %>"><%=ResourceComInfo.getResourcename(((String[])scoreList.get(i))[1]) %>评分：<span class="head_more">. . .</span></td>
							</tr>
							<tr class="trh<%=i %>">
							   <td align="center" class="td_font">考核得分</td>
							   <td><span id="s_scorespan_<%=checkid %>" class="score_txt"><%=((String[])scoreList.get(i))[3] %></span>
									<input type="hidden" id="s_score_<%=checkid %>" name="s_score_<%=checkid %>" value="<%=((String[])scoreList.get(i))[3] %>" />
							   </td>
							</tr> 
							<tr class="trh<%=i %>"><td align="center" class="td_font">修正分数</td><td>
							<%if("1".equals(isedit) && !(revisemax==0&&revisemin==0)){%>
									<input class="input_txt intext" type="number" id="s_revise_<%=checkid %>" name="s_revise_<%=checkid %>"
										 value="<%=((String[])scoreList.get(i))[4] %>" maxlength="100" placeholder="请输入..."
										 onKeyPress="ItemNum_KeyPress('s_revise_<%=checkid %>')" onBlur="checknumber('s_revise_<%=checkid %>');"
										 onchange="checkReviseVal('s_revise_<%=checkid %>');countScore2(<%=checkid %>);changeReason(<%=checkid %>)" /><span class="must_img"></span>
									<%}else{ %>
										<span class="score_txt"><%=((String[])scoreList.get(i))[4] %></span>
										<input type="hidden" id="s_revise_<%=checkid %>" value="<%=((String[])scoreList.get(i))[4] %>"/>
									<%} %>
									<div id="s_reason_div_<%=checkid %>" style="width: 100%;height: auto;<%if(revise==0){ %>display:none;<%} %>" >
									<%if("1".equals(isedit)){%>
									<textarea class="area_txt2 area_reason a_intext <%if(revise!=0){ %>mustinput<%} %>" style="margin-left:-3px;" placeholder="请输入修正理由..." id="s_reason_<%=checkid %>" name="s_reason_<%=checkid %>"><%=Util.convertDB2Input(((String[])scoreList.get(i))[10]) %></textarea>
									<%}else{ %>
										<%=Util.toHtml(((String[])scoreList.get(i))[10]) %>
									<%} %>
									</div>
							</td></tr>
							<tr class="trh<%=i %>"><td align="center" class="td_font">考核评价</td><td>
							<%if("1".equals(isedit)){%>
									<textarea class="area_txt2 a_intext" style="margin-left:-3px;" id="s_remark_<%=checkid %>" placeholder="请输入..." name="s_remark_<%=checkid %>"><%=Util.convertDB2Input(((String[])scoreList.get(i))[6]) %></textarea>
									<span class="must_img"></span>
									<%}else{ %>
										<%=Util.toHtml(((String[])scoreList.get(i))[6]) %>
									<%} %>
							</td></tr>	
							<tr class="trh<%=i %>"><td align="center" class="td_font">相关附件</td><td>
							<%
										if(!fileids.equals("")) fileids = fileids.substring(1);
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
												String docImagefilename = DocImageManager.getImagefilename();
									%>	
									<div style="width:auto"><%=docImagefilename %>
									&nbsp;<a href='javaScript:void(0);' onclick="perfordownload(<%=fileidList.get(j) %>,<%=scoreid %>,<%=docImagefileid %>,'<%=docImagefilename %>');">下载(<%=docImagefileSize/1000 %>K)</a>
									&nbsp;	            
									<%if("1".equals(isedit)){%>
									<input type="checkbox" onclick="onDeleteAcc(this,'<%=fileidList.get(j)%>')"/><U><%=linknum%></U>-删除
									<%} %>
									</div>
									<%		}
										}
									%>
								
									<%if("1".equals(isedit)){
										if(!docsecid.equals("")&&!docsecid.equals("0")){
											String subid = SecCategoryComInfo.getSubCategoryid(docsecid);
											String mainid = SubCategoryComInfo.getMainCategoryid(subid);
											String maxsize = "0";
											rs2.executeSql("select maxUploadFileSize from DocSecCategory where id=" + docsecid);
											if(rs2.next()) maxsize = Util.null2String(rs2.getString(1));
											canupload = true;
									%>
										<div id="edit_uploadDiv" mainId="<%=mainid%>" subId="<%=subid%>" secId="<%=docsecid%>" maxsize="<%=maxsize%>"></div>
									<%	}else{ %>
										<font color="red">未设置附件上传目录!</font>
									<%	} %>
										<input type="hidden" id="edit_relatedacc" name="edit_relatedacc" value="<%=fileids%>"/>
				     					<input type="hidden" id="delrelatedacc" name="delrelatedacc" value=""/>	
									<%}%>
							</td></tr>
							<tr class="trh<%=i %>"><td align="center" class="td_font">月总得分</td><td>
							<span id="s_resultspan_<%=checkid %>" class="score_txt"><%=((String[])scoreList.get(i))[5] %></span>
									<input type="hidden" class="s_result" id="s_result_<%=checkid %>" name="s_result_<%=checkid %>"
										 value="<%=((String[])scoreList.get(i))[5] %>" _rate="<%=((String[])scoreList.get(i))[2] %>"/>
							</td></tr>
					  <% }%>
					  <tr><td class="controlTdHeader2 edit_title" align="right">最终得分：</td><td class="edit_title" style="border-bottom: 1px solid #ddd;">
						  <span id="score_resultspan" class="final"><%=result %></span>
						  <input type="hidden" id="score_result" name="score_result" value="<%=result %>" />
					  </td></tr>
					   </tbody>
					</table>
					<%if(type1.equals("1") && isplan){
									rs.executeSql("select 1 from PR_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2 and ismonth=1");
									if(rs.next()){
								%>
									<div id="dtitle0" class="dtitle"><div class="dtxt">相关链接</div><div class="pullDown"></div></div>
									<table class="datable" style="width: 100%;">
									  <tr><td>计划报告</td>
									    <td>
									      <a id="planviewid" href="javaScript:void(0);" style="font-size:13px;">
											<%=ResourceComInfo.getLastname(resourceid)%><%=year %>年<%=type2 %>月工作总结及计划</a>
									    </td>
									  </tr>
									</table>
								<%		
							}
						}
					%>
					<div id="dtitle0" class="dtitle"><div class="dtxt">意见反馈</div><div class="pullDown"></div></div>
					<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="100%" valign="top">
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
									<table cellpadding="0" id="ex_table" style="width: 100%;" cellspacing="0" border="0">
									<%
										String operatedate = "";
									    String userimg ="";
										rs.executeSql("select operator,operatedate,operatetime,content from GP_AccessScoreExchange where scoreid="+scoreid+" order by operatedate desc,operatetime desc,id desc");
										while(rs.next()){
											operatedate = Util.null2String(rs.getString("operatedate")+" "+rs.getString("operatetime"));
											userimg = ResourceComInfo.getMessagerUrls(rs.getString("operator"));//人头像
									%>  <tr><td class="td_img"><img src="<%=userimg %>" class="exchange_img"/></td>
										<td><div class="exchange_title"><%=ResourceComInfo.getResourcename(rs.getString("operator")) %>&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>
										<%if(!Util.null2String(rs.getString("operator")).equals(user.getUID()+"") 
												&& !viewdate.equals("") && TimeUtil.dateInterval(viewdate,operatedate)>0){ 
										%>
											<font style="color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;" title="新反馈">new</font>
										<%} %>
										</div>
										<div class="exchange_content"><%=Util.toHtml(rs.getString("content")) %></div></td>
										</tr>
									<%		
										}
									%>
								  </table>
								</td>
					       </tr>
					</table>
					<table class="datatable">
							<tr id="btn_id"><td  style="padding-top:20px;border-bottom:0 ! important;" align="center">
								<%if(canreset && TimeUtil.dateInterval(currentdate,s_enddate)>=0){ %>
									<div class="btn_feedback2 btn_feed" onclick="doReset();">重新考核</div>
								<%} %>
								<%if(!isfirst.equals("1") && canedit){ %>
									<div class="btn_feedback2 btn_feed" onclick="doScoreReturn();">退回</div>
								<%} %>
								<%if(caninit){%>
									<div class="btn_feedback2 btn_feed" onclick="doInit();">重置</div>
								<%} %>
								<%if(canedit){%>
									<div class="btn_feedback2 btn_feed" onclick="doSave();">保存</div>
									<div class="btn_feedback2 btn_feed" onclick="doSubmit();">提交</div>
								<%} %>
								<%if(canaudit){ %>
									<div class="btn_feedback2 btn_feed" onclick="doApprove();">批准</div>
									<div class="btn_feedback2 btn_feed" onclick="doReturn();">退回</div>
								<%} %>
							</td></tr>
					</table>		
				<%}}%>
		</form>
	<script language="javascript">
	var reasondef = "请输入修正理由";
	var score_max = <%=scoremax%>;
	$(document).ready(function(){
	    $("#spaninfo").html('<%=spanInfo%>');
		$("#content").width($(body).width()-30);
		$(".tabpanel li.tab").click(function(){
		    var datavalue = $(this).attr('data-value');
		    window.location = "AccessView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1="+datavalue+"&back=<%=back%>";
		});
		if($('select').length==1){
		   $('select').each(function(){
		       $(this).css('width',$(this).parent().width()*0.25);
		   });
		}else if($('select').length==2){
		   $('select').each(function(){
		       $(this).css('width',$(this).parent().width()*0.5);
		   });
		}
		$(".td_cate").each(function(){
		    var tdhtml = $(this).find("td:last-child").html();
		    if(tdhtml=="" || tdhtml==null){
		       $(this).remove();
		    }
		});

		//控制多行文本框自动伸缩
	    $("textarea").textareaAutoHeight({minHeight:24});
		//点击展示隐藏的标签页内容
		$(".dtitle").click(function(){
			$(this).next().toggle();
			if($(this).find(".pullDown").hasClass("pullUp")){
				$(this).find(".pullDown").removeClass("pullUp");
			}else{
				$(this).find(".pullDown").addClass("pullUp");
			}
		});
		$('#syear').live('change',function(){
		  var data_type = $(this).val();
		  window.location = "AccessView.jsp?resourceid=<%=resourceid%>&year="+data_type+"&type1=<%=type1%>&type2=<%=type2%>&back=<%=back%>";
		});
		$('#squarter,#smonth').live('change',function(){
		  var data_type = $(this).val();
		  window.location = "AccessView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1=<%=type1%>&type2="+data_type+"&back=<%=back%>";
		});
		$('.controlTdHeader').click(function(){
		  $(this).parent().siblings().toggle();
		  $(this).find("span.head_more").toggle();
		});
		$('.ctth').click(function(){
		  var ivals = $(this).attr("ivals");
		  $('.trh'+ivals).toggle();
		  $(this).find("span.head_more").toggle();
		});
		$('#planviewid').click(function(){
		  window.location = "/mobile/plugin/workrelate/PlanView.jsp?year=<%=year %>&type1=1&back=2&type2=<%=type2 %>&resourceid=<%=resourceid %>";
		});
		if($(body).width()>=768){
		   $('*').css('font-size','16px');
		}
		$("#tabblank").height($("#topmain").height());//占位fixed出来的空间
		<%if(caninit){%>
			if(confirm("考核方案已变更，是否更新？")){
				doInit();
			}
		<%}%>
		$('.dofdata').each(function(){
			var datavalue = $(this).attr('data-value');
			var dtemp = datavalue.split(',');
			doFormula(dtemp[0],12,dtemp[1]);
		});
		//项目收款及验收需初始进行计算
		<%if(canedit){
			for (Object b : countmap.entrySet()) {  %>
				doFormula(<%=((Entry)b).getKey()%>,<%=((Entry)b).getValue()%>,'');
		<%}}%>
	});
	function submitOperation(){//提交表单
		$("#form1").ajaxSubmit({
			dataType:"json",
			type:"post",
			success:function(data){
				if(data.scoreid!=""){
					window.location.href = "/mobile/plugin/performance/AccessView.jsp?scoreid="+data.scoreid+"&back=<%=back%>";
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
	function perfordownload(id,scoreid,fileid,filename){
	   $.ajax({
	     type: "post",
		 url: "/mobile/plugin/performance/download.jsp",
		 contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		 data:{"id":id,"scoreid":scoreid,"fileid":fileid}, 
		 complete:function(){
		   window.location = "/download.do?fileid="+fileid+"&filename="+filename;
		 }
	   });
    }
	function doBack(){
	    <%if("1".equals(back)){%>
	    	window.location = "/mobile/plugin/performance/accessMain.jsp";
	    <%}else if("2".equals(back)){%>
	        window.location = "/mobile/plugin/workrelate/PlanView.jsp?resourceid=<%=resourceid%>";
	    <%}else{%>
	    	window.location = "/mobile/plugin/performance/perforMain.jsp";
	    <%}%>
	}
	function doYear(){
	   
	}
	function filter(str){
		str = str.replace(/\+/g,"%2B");
	    str = str.replace(/\&/g,"%26");
		return str;	
    }
	function saveExchange(){
				if(jQuery("#content").val()==""){	
					alert("请填写意见内容！");
				}else{
					$("#exchangebtn").hide();
					$('#exchange .mec_refresh_loading').show();
					$.ajax({
						type: "post",
					    url: "/mobile/plugin/performance/AccessOperation.jsp",
					    data:{"operation":"add_exchange","scoreid":"<%=scoreid%>","content":filter(encodeURI($("#content").val()))}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    if(data!=""){
						    	var txt = $.trim(data.responseText);
						    	jQuery("#ex_table").prepend(txt);
						    }
						    $("#exchangebtn").show();
							$('#exchange .mec_refresh_loading').hide();
							$("#content").val("").blur();
						}
				    });
				}
			}
			function contentFocus(){
				if(jQuery("#content").val()==""){
					jQuery("#exchangebtn").show();
					$("#content").width($(body).width()-$('#exchangebtn').width()-55);
				}
			}
			function contentBlur(){
				if(jQuery("#content").val()==""){
					jQuery("#exchangebtn").hide();
					$("#content").width($(body).width()-30);
				}
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
	<%if(canedit){%>
			function doSave(obj) {
			if(confirm("确定保存考核结果?")){
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
				if(confirm("确定提交考核结果?") && checkMust()){
					jQuery("#operation").val("submit");
					//obj.disabled = true;
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
				var cansubmit = true;
				jQuery(".mustinput").each(function(){
					if(jQuery(this).val()==""){
						cansubmit = false;
					}
					if(jQuery(this).hasClass("area_reason") && jQuery(this).val()==reasondef){
						cansubmit = false;
					}
				});
				if(cansubmit==false){
					alert("请完整填写考核分数\n定量指标需填写完成值及<%=titlestr %>目标\n有修正分时需填写修正理由");
				}else{
					jQuery(".area_reason").each(function(){
						if(jQuery(this).val()==reasondef){
							jQuery(this).val("");
						}
					});
				}
				return cansubmit;
			}
			function doFormula(detailid,formula,formuladetail){
				var countscore = true;
				var target = getFloatVal($("#target_"+detailid).val());//目标值
				var result = getFloatVal($("#result_"+detailid).val());//完成值
				var d_score = 0;//得分
				if(formula==1){//公式1  完成值/目标值*5
					if(target!=0){
						d_score = result/target * 5;
					}
					if(d_score>5) d_score = 5;
				}else if(formula==5){//公式5 (目标值-完成值)/目标值*5   -----调整为按比例分段控制得分     ------调整为 目标值/完成值*3.5
					if(result!=0 && target!=0){
						if(result>target){
							var frate = (result-target)/target * 100;//花费比例
							if(frate<=10) d_score = 2;
							else if(frate>10 && frate<=20) d_score = 1;
							else if(frate>20 && frate<=30) d_score = 0;
							else d_score = -1;
						}else{
							d_score = target/result * 3.5;
						}
					}else{
						d_score = 5;
						if(target==0) d_score = 0;
					}
					if(d_score>5) d_score = 5;
				}else if(formula==2){//项目收款
					var result2 = getFloatVal($("#result2_"+detailid).val());//有效值
					var baseval = 70000;
					if(target<baseval){
						d_score = result2/baseval * 5;
						if(d_score>5) d_score = 5;
					}else{
						if(result>target){
							d_score = result2/baseval * 1 * 5;
						}else{
							d_score = result2/baseval * result/target * 5;
						}
					}
				}else if(formula==3){//项目验收
					var result2 = getFloatVal($("#result2_"+detailid).val());//有效值
					var baseval = 120000;
					if(target<baseval){
						d_score = result2/baseval * 5;
						if(d_score>5) d_score = 5;
					}else{
						if(result>target){
							d_score = result2/baseval * 1 * 5;
						}else{
							d_score = result2/baseval * result/target * 5;
						}
					}
				}else if(formula==4){//技术部任务量
					countscore = false;
				}else if(formula==11){
				    if(target!=0){
						d_score = result/target * score_max;
					}
					if(d_score>score_max) d_score = score_max;
				}else if(formula==12){
				    formuladetail = formuladetail.replace(/(gval)/g,target).replace(/(cval)/g,result);
			        try{
			           d_score = eval(formuladetail);
			           if( isNaN(result) || 'Infinity'.indexOf(result) > -1) d_score = 0;
			        }catch(exception){
			           d_score = 0;
			        }
			       if(d_score>score_max) d_score = score_max; 	
				}else if(formula==13){
				   $.ajax({
				          type: "post",
						  dataType:"json",
						  url: "classOperation.jsp",
						  data:{"type1":<%=type1%>,"target":target,"result":result,"jcway":formuladetail},
						  async:false,
						  contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						  success: function(data){
						     if(data.result==0){
						       d_score = 0;
						       alert(data.msg);
						     }else{
						       d_score = data.resultscore;
						     }
						  }
				   });
				   if(d_score>score_max) d_score = score_max; 	
				}
				if(countscore){
					$(".c_score_"+detailid).val(d_score.toFixed(2));
					$(".c_scorespan_"+detailid).html(d_score.toFixed(2));
				}

				<%for(int i=0;i<scoreList.size();i++){ 
					String checkid = ((String[])scoreList.get(i))[0];
				%>
					countScore(detailid,<%=checkid%>);
				<%}%>
			}
			function countScore(detailid,checkid){
				var d_rate2 = 1;
				//针对技术任务量增加相应计算
				var d_formula4 = getFloatVal($("#d_score_"+detailid+"_"+checkid).attr("_formula4"));
				if(d_formula4==1){
					var target = getFloatVal($("#target_"+detailid).val());//目标值
					var result = getFloatVal($("#result_"+detailid).val());//完成值
					if(result<target) d_rate2 = 0.8;
				}
				var d_score = getFloatVal($("#d_score_"+detailid+"_"+checkid).val());
				var d_rate = getFloatVal($("#d_rate_"+detailid).val());
				var d_result = (d_score*d_rate/100*d_rate2).toFixed(2);
				$("#d_result_"+detailid+"_"+checkid).val(d_result);
				$("#d_resultspan_"+detailid+"_"+checkid).html(d_result);

				var s_score = 0;
				$(".d_result_"+checkid).each(function(){
					s_score += getFloatVal($(this).val());
				});
				$("#s_score_"+checkid).val(s_score.toFixed(2));
				$("#s_scorespan_"+checkid).html(s_score.toFixed(2));
				
				var s_revise = getFloatVal($("#s_revise_"+checkid).val());
				var s_result = s_score + s_revise;
				$("#s_result_"+checkid).val(s_result.toFixed(2));
				$("#s_resultspan_"+checkid).html(s_result.toFixed(2));

				var score_result = 0;
				$(".s_result").each(function(){
					score_result += getFloatVal($(this).val())*getFloatVal($(this).attr("_rate"))/100;
				});
				$("#score_result").val(score_result.toFixed(2));
				$("#score_resultspan").html(score_result.toFixed(2));
			}
			function countScore2(checkid){
				var s_score = getFloatVal($("#s_score_"+checkid).val());
				var s_revise = getFloatVal($("#s_revise_"+checkid).val());
				var s_result = s_score + s_revise;
				$("#s_result_"+checkid).val(s_result.toFixed(2));
				$("#s_resultspan_"+checkid).html(s_result.toFixed(2));

				var score_result = 0;
				$(".s_result").each(function(){
					score_result += getFloatVal($(this).val())*getFloatVal($(this).attr("_rate"))/100;
				});
				$("#score_result").val(score_result.toFixed(2));
				$("#score_resultspan").html(score_result.toFixed(2));
			}
			function changeReason(checkid){
				var s_revise = getFloatVal($("#s_revise_"+checkid).val());
				if(s_revise==0){
					$("#s_reason_div_"+checkid).hide();
					$("#s_reason_"+checkid).removeClass("mustinput");
				}else{
					$("#s_reason_div_"+checkid).show();
					$("#s_reason_"+checkid).addClass("mustinput");
				}
			}
			function checkScoreVal(objid){
				var score_val = getFloatVal($("#"+objid).val());
				if(score_val><%=scoremax%> || score_val<<%=scoremin%>){
					alert("评分值需控制在<%=scoremin%>-<%=scoremax%>之间!");
					$("#"+objid).val("");
				}
			}
			function checkReviseVal(objid){
				var revise_val = getFloatVal($("#"+objid).val());
				if(revise_val><%=revisemax%> || revise_val<<%=revisemin%>){
					alert("修正分值需控制在<%=revisemin%>-<%=revisemax%>之间!");
					$("#"+objid).val("");
				}
			}
			<%}%>
		   function getFloatVal(val){
				if(isNaN(parseFloat(val))){
					return 0;
				}else{
					return parseFloat(val);
				}
			}
			<%if(caninit){ %>
			function doInit(obj) {
				if(confirm("确定重置考核项及结果?")){
					jQuery("#operation").val("init");
					showLoading();
					submitOperation();
				}
			}
			<%}%>
			<%if(canaudit){ %>
			function doApprove(obj) {
				if(confirm("确定批准此考核结果?")){
					jQuery("#operation").val("approve");
					showLoading();
					submitOperation();
				}
			}
			function doReturn(obj) {
				if(confirm("确定退回此考核结果?")){
					jQuery("#operation").val("return");
					showLoading();
					submitOperation();
				}
			}
			<%}%>
			<%if(!isfirst.equals("1") && canedit){ %>
			function doScoreReturn(obj){
				if(confirm("确定退回此考核结果?")){
					jQuery("#operation").val("score_return");
					showLoading();
					submitOperation();
				}
			}
			<%}%>
			<%if(canreset){ %>
			function doReset(obj){
				if(confirm("确定重新进行考核评分?")){
					jQuery("#operation").val("reset");
					showLoading();
					submitOperation();
				}
			}
			<%}%>
</script>
</body>
</html>
<%!
	private String getFormulaName(String formula,String formuladetail){
		String formulaName = "";
		if("1".equals(formula)){
			formulaName = "<br><font class='formula'>公式1[完成值/目标值*5]</font>";
		}else if("2".equals(formula)){
			formulaName = "<br><font class='formula'>公式2[项目收款]</font>";
		}else if("3".equals(formula)){
			formulaName = "<br><font class='formula'>公式3[项目验收]</font>";
		}else if("4".equals(formula)){
			formulaName = "<br><font class='formula'>公式4[技术任务量]</font>";
		}else if("5".equals(formula)){
			//formulaName = "<br><font class='formula'>公式5[(目标值-完成值)/目标值*5]</font>";
			formulaName = "<br><font class='formula'>公式5[目标值/完成值*3.5]</font>";
		}else if("11".equals(formula)){
			formulaName = "<br><font class='formula'>公式[完成值/目标值*最大分制]</font>";
		}else if("12".equals(formula)){
			formuladetail = formuladetail.replace("gval","目标值").replace("cval","完成值");
			formulaName = "<br><font class='formula'>公式["+formuladetail+"]</font>";
		}else if("13".equals(formula)){
			String [] farray = formuladetail.split("\\.");
			if(farray!=null && farray.length!=0){
				formuladetail = farray[farray.length-1];
			}
			formulaName = "<br><font class='formula'>类：["+formuladetail+"]</font>";
		}
		return formulaName;
	}
%>