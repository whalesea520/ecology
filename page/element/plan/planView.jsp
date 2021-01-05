<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.pr.util.RightUtil"%>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="OperateUtil" class="weaver.pr.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:include page="/systeminfo/init_wev8.jsp"></jsp:include>
<%
	String eid = Util.null2String(request.getParameter("eid"));
	String planWeek = Util.null2String(request.getParameter("planWeek"));
	String planMonth = Util.null2String(request.getParameter("planMonth"));
	String planDay = Util.null2String(request.getParameter("planDay"));
	String planType = Util.null2String(request.getParameter("planType"));
	String ifBegindate = Util.null2String(request.getParameter("ifBegindate"));
	String ifEnddate = Util.null2String(request.getParameter("ifEnddate"));
	int perpage = Util.getIntValue(request.getParameter("perpage"),5);
	
	String param = "planType="+planType+"&ifBegindate="+ifBegindate+"&ifEnddate="+ifEnddate+"&eid="+eid+
	"&planWeek="+planWeek+"&planMonth="+planMonth+"&planDay="+planDay+"&perpage="+perpage;

	String currentUserid = user.getUID()+"";
	String year = Util.null2String(request.getParameter("year"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	String planid = Util.null2String(request.getParameter("planid"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	
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
	if(!planid.equals("")){
		if(rs.getDBType().equals("oracle")){
			rs.executeSql("select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
				+",(select max(CONCAT(CONCAT(operatedate,' '),operatetime)) from PR_PlanReportLog where PR_PlanReportLog.planid=PR_PlanReport.id and operator="
				+user.getUID()+" and operatetype=0) as viewdate"
				+" from PR_PlanReport where isvalid=1 and id="+planid);
		}else{
			rs.executeSql("select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
				+",(select max(operatedate+' '+operatetime) from PR_PlanReportLog where PR_PlanReportLog.planid=PR_PlanReport.id and operator="+user.getUID()+" and operatetype=0) as viewdate"
				+" from PR_PlanReport where isvalid=1 and id="+planid);
		}
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
			response.sendRedirect("/workrelate/plan/util/Message.jsp?type=1") ;
			return;
		}
	}else{
		if(resourceid.equals("")){
			resourceid = currentUserid;
		}
		//年份、类型取默认值
		//if(year.equals("")){
		//	year = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_YEAR"));
			if(year.equals("")) year = currentdate.substring(0,4);
		//}
		//if(type1.equals("")){
		//	type1 = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_TYPE1"));
		//}
		//if(type2.equals("")){
		//	type2 = Util.null2String((String)request.getSession().getAttribute("PR_PLANREPORT_TYPE2_"+type1));
		//}
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
	if(isweek!=1 && ismonth!=1){
		response.sendRedirect("/workrelate/plan/util/Message.jsp?type=2") ;
		return;//未启用
	}
	if(!planWeek.equals("1") &&!planMonth.equals("1")){
		response.sendRedirect("/workrelate/plan/util/Message.jsp?type=4") ;
		return;//未启用
	}
	if(!planWeek.equals("1")){
		isweek = 0;
	}
	if(!planMonth.equals("1")){
		ismonth = 0;
	}
	if((ismonth!=1) && type1.equals("1")) type1 = "";
	if(isweek!=1 && type1.equals("2")) type1 = "";
	if(type1.equals("")){
		if(ismonth==1){ type1 = "1";}
		if(isweek==1){ type1 = "2";}
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
	
	if(resourceid.equals(currentUserid)){
		canview = true;
		canedit = true;
		editshare = true;//本人可编辑共享
	}else if(ResourceComInfo.isManager(user.getUID(),resourceid)){
		canview = true;
		editshare = true;//上级可编辑共享
	}else if((","+reportaudit+",").indexOf(","+currentUserid+",")>-1){
		canview = true;
		editshare = true;//后台定义的审批人可编辑共享
	}else if((","+reportview+",").indexOf(","+currentUserid+",")>-1){
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
		titlestr = SystemEnv.getHtmlLabelName(33452,user.getLanguage());
		
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
		titlestr = SystemEnv.getHtmlLabelName(1926,user.getLanguage());
		
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
		if(rs.getDBType().equals("oracle")){
			rs.executeSql("select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
				+",(select max(CONCAT(CONCAT(operatedate,' '),operatetime)) from PR_PlanReportLog where PR_PlanReportLog.planid=PR_PlanReport.id and operator="+user.getUID()+" and operatetype=0) as viewdate"
				+" from PR_PlanReport"
				+" where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and userid="+resourceid);
		}else{
			rs.executeSql("select id,planname,status,userid,year,type1,type2,startdate,enddate,isupdate,auditids,remark,fileids,shareids"
				+",(select max(operatedate+' '+operatetime) from PR_PlanReportLog where PR_PlanReportLog.planid=PR_PlanReport.id and operator="+user.getUID()+" and operatetype=0) as viewdate"
				+" from PR_PlanReport"
				+" where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and userid="+resourceid);
		}
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
			msg = SystemEnv.getHtmlLabelName(83987,user.getLanguage())+begindate;
		}else if(TimeUtil.dateInterval(currentdate,enddate)<0 || !canedit){
			msg = SystemEnv.getHtmlLabelName(83988,user.getLanguage());
		}
		
		planname = ResourceComInfo.getLastname(resourceid)+year+" "+SystemEnv.getHtmlLabelName(26577,user.getLanguage())+type2+titlestr+" "+SystemEnv.getHtmlLabelName(83992,user.getLanguage())+" "+nextyear+" "+SystemEnv.getHtmlLabelName(26577,user.getLanguage())+" "+nexttype2+titlestr+" "+SystemEnv.getHtmlLabelName(83995,user.getLanguage());
	}else{
		if(TimeUtil.dateInterval(currentdate, begindate)>0 || TimeUtil.dateInterval(currentdate,enddate)<0){
			//msg = "此计划报告将在"+begindate+"开始提交";
			canedit = false;
		}
	}
	String programid = "0";
	rs.executeSql("select id,auditids,shareids from PR_PlanProgram where userid="+resourceid+" and programtype="+type1);
	if(rs.next()){
		programid = Util.null2String(rs.getString("id"));
		if(planid.equals("")) auditids = Util.null2String(rs.getString("auditids"));
		pshareids = Util.null2String(rs.getString("shareids"));
	}
	
	if(!canview){
		if((","+auditids+",").indexOf(","+currentUserid+",")<0 && (","+shareids+","+pshareids+",").indexOf(","+currentUserid+",")<0){
			response.sendRedirect("/workrelate/plan/util/Message.jsp?type=1");
		    return ;
		}
	}
	if((","+auditids+",").indexOf(","+currentUserid+",")>-1) editshare = true;//审批人可编辑共享
	
	if(status.equals("1") || status.equals("3")) canedit = false;
	if(s_enddate.equals("")) s_enddate = enddate;
	canaudit = RightUtil.isCanAuditPlan(planid,currentUserid);

	
	//request.getSession().setAttribute("PR_PLANREPORT_YEAR",year);
	//request.getSession().setAttribute("PR_PLANREPORT_TYPE1",type1);
	//request.getSession().setAttribute("PR_PLANREPORT_TYPE2_"+type1,type2);
	
	int islog = Util.getIntValue(request.getParameter("islog"),1);
	if(!planid.equals("") && islog==1){
		OperateUtil.addPlanLog(currentUserid,planid,0);
	}
	int inttype2 = Integer.parseInt(type2);
	
	int showYear = Integer.parseInt(year);
	int showType2 =Integer.parseInt(type2);
	if(type1.equals("1")){//显示月报
		if(showType2==12){
			showType2 = 1;
			showYear = showYear+1;
		}else{
			showType2 = showType2+1;
		}
	}else if(type1.equals("2")){//显示周报
		if(showType2==TimeUtil.getMaxWeekNumOfYear(showYear)){
			showType2 = 1;
			showYear = showYear+1;
		}else{
			showType2 = showType2+1;
		}
	}
%>
<html>
	<head>
		<script src="/page/element/plan/resource/js/jquery-1.8.3.js"></script>
		<link rel="stylesheet" href="/page/element/plan/resource/css/plan.css">
		<link rel="stylesheet" href="/page/element/plan/resource/css/tab.css">
		<link rel="stylesheet" href="/page/element/plan/resource/js/showLoading/css/showLoading.css">
		<script src="/page/element/plan/resource/js/showLoading/js/jquery.showLoading.js"></script>
		<script src="/page/element/plan/resource/js/tab.js"></script>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body id="body">
		<div class="planTab">
			<div class="tabpanel">
				<div id="yearpanel" class="yearpanel" >&nbsp;&nbsp;&nbsp;<%=showYear %></div>
				<%if(isweek==1){%><div class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" onclick="changeType(2)"><%=SystemEnv.getHtmlLabelName(20619,user.getLanguage())%></div><%} %>
				<%if(ismonth==1){%><div class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" onclick="changeType(1)"><%=SystemEnv.getHtmlLabelName(20617,user.getLanguage())%></div><%} %>
				<%if(type1.equals("1")){ %>
				<div class="tab2_panel" style="width: 91px;">
					<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>" <%if(inttype2!=1){ %> onclick="changeType2(<%=inttype2-1 %>)" title="<%=SystemEnv.getHtmlLabelName(84002,user.getLanguage())%>" <%} %>></div>
					<div class="week_txt" title=""><%=showType2 %>&nbsp;<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%></div>
					<div class="week_btn2 <%if(inttype2!=12){ %>week_next<%} %>" <%if(inttype2!=12){ %> onclick="changeType2(<%=inttype2+1 %>)" title="<%=SystemEnv.getHtmlLabelName(84003,user.getLanguage())%>" <%} %>></div>
				</div>
				<%}else if(type1.equals("2")){%>
				<div class="tab2_panel" style="width: 91px;">
					<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>" <%if(inttype2!=1){ %> onclick="changeType2(<%=inttype2-1 %>)" title="<%=SystemEnv.getHtmlLabelName(84004,user.getLanguage())%>" <%} %>></div>
					<div class="week_txt" title="<%=weekdate1+" "+SystemEnv.getHtmlLabelName(83903,user.getLanguage())+" "+weekdate2 %>"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>&nbsp;<%=showType2 %>&nbsp;<%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></div>
					<div class="week_btn2 <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %>week_next<%} %>" 
					<%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %> onclick="changeType2(<%=inttype2+1 %>)" title="<%=SystemEnv.getHtmlLabelName(84005,user.getLanguage())%>" <%} %>></div>
				</div>
				<%}else{ %>
				<div class="tab2_panel" style="width: 1px;border-right: 0px;"></div>
				<%} %>
			</div>
		</div>
		<div class="planShow" id="planShow"></div>
		<div class="planRemind">
			<iframe width="100%" id="remindIframe" frameborder="0" src="/page/element/plan/Remind.jsp"></iframe>
		</div>
		<div id="yearselect" class="yearselect">
		<% 	int currentyear = Integer.parseInt(currentdate.substring(0,4));
			for(int i=2013;i<(currentyear+4);i++){ %>
				<div class="yearoption" _val="<%=i %>">&nbsp;&nbsp;&nbsp;<%=i %></div>
		<%} %>
		</div>
		<script type="text/javascript">
			$(document).ready(function(){
				if("<%=msg%>"==""){
					getPlanList();
				}else{
					$("#planShow").html("<div class='planTips'><%=msg%></div>");
				}
			});
			function changeHeight(height){
				$("div.planRemind").height(height);
				var height = document.body.clientHeight-$("div.planTab").height()-height-15;
				$("div.planShow").css("height",height);
			}
			function getPlanList(){
				$("#body").showLoading();
				$.ajax({
					url:"getPlanList.jsp",
					data:{"planType":"<%=planType%>","ifBegindate":"<%=ifBegindate%>","ifEnddate":"<%=ifEnddate%>",
					"eid":"<%=eid%>","perpage":"<%=perpage%>","programid":"<%=programid%>","planid":"<%=planid%>",
					"planDay":"<%=planDay%>"},
					success:function(data){
						$("#planShow").html(data);
					},
					error:function(data){
						$("#planShow").html("<%=SystemEnv.getHtmlLabelName(84007,user.getLanguage())%>");
					},
					complete:function(){
						$("#body").hideLoading();
					}
				});
			}
			function changeYear(year){
				window.location = "/page/element/plan/planView.jsp?resourceid=<%=resourceid%>&year="+year+"&type1=<%=type1%>&type2=<%=type2%>&<%=param%>";
			}
			function changeType(type){
				window.location = "/page/element/plan/planView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1="+type+"&<%=param%>";
			}
			function changeType2(type){
				window.location = "/page/element/plan/planView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1=<%=type1%>&type2="+type+"&<%=param%>";
			}
		</script>
	</body>
</html>