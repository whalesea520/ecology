<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="java.util.Map.*"%>
<%@ page import="weaver.file.Prop" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.gp.util.RightUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%@ include file="/performance/util/uploader.jsp" %>
<% 
	//所有经理及考核成绩评分人、考核成绩确认人有权限查看
	String userid = user.getUID()+"";
	String year = Util.null2String(request.getParameter("year"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	String scoreid = Util.null2String(request.getParameter("scoreid"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	
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
			response.sendRedirect("../util/Message.jsp?type=1") ;
			return;
		}
	}else{
		if(resourceid.equals("")){
			response.sendRedirect("../util/Message.jsp?type=1") ;
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
		response.sendRedirect("../util/Message.jsp?type=2") ;
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
	
	request.getSession().setAttribute("GP_ACCESS_YEAR",year);
	request.getSession().setAttribute("GP_ACCESS_TYPE1",type1);
	request.getSession().setAttribute("GP_ACCESS_TYPE2_"+type1,type2);
	
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
	String titlename = scorename;
%>
<HTML>
	<HEAD>
		<title><%=scorename %></title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="../js/util.js"></script>
		<link rel="stylesheet" type="text/css" href="../css/tab.css" />
		<style type="text/css">
			.maintable{width: 100%;border-collapse: collapse;}
			.maintable td{line-height: 28px;padding-left: 4px;padding-right: 4px;border: 1px #DCDCDC solid;white-space: nowrap;word-break: break-all;}
			.maintable td.title{background: #DDD9C3;}
			.maintable td.title2{font-weight: bold;background: #F8F8F8;text-align: right;padding-right: 8px;}
			.maintable tr.header td{font-weight: bold;background: #F8F8F8;text-align: center;line-height: 22px;padding: 0px;}
			.maintable tr.header2 td{font-weight: bold;background: #F8F8F8;text-align: center;line-height: 22px;padding: 0px;}
			.maintable td.edit_title{background: #EAEAEA !important;}
			
			.title_panel{width: 100%;height: 24px;margin-top: 10px;}
			.title_txt{width: auto;line-height: 20px;float: left;font-weight: bold;font-size: 13px;}
			
			.btn1{width: 60px;line-height: 20px;height: 20px;text-align: center;border: 1px #B0B0B0 solid;cursor: pointer;margin-left: 5px;float: left;padding: 0px !important}
			.btn2{width: 40px;line-height: 20px;height: 20px;text-align: center;border: 1px #B0B0B0 solid;cursor: pointer;margin-left: 5px;float: left;padding: 0px !important}
			
			.btn_browser{width:25px;height:22px;float: left;margin-left: 0px;margin-top: 2px;cursor: pointer;
				background: url('../images/btn_browser.png') center no-repeat !important;}
			.btn_hover{background: #5581DA;color: #fff;border-color: #5581DA !important;}	
				
			.input_txt{width: 40px;font-size: 12px;}
			.input_txt2{width: 90px;font-size: 12px;}
			.area_txt{width: 98%;height: 50px;margin-top: 2px;margin-bottom: 2px;overflow-x: hidden;overflow-y: auto;}
			.area_txt2{width: 98%;height: 70px;margin-top: 2px;margin-bottom: 2px;overflow-x: hidden;overflow-y: auto;}
			.area_reason{height: 50px;}
			.area_blur{font-style: italic;color: #C3C3C3;}
			.score_txt{font-size: 12px !important;}
			.final{font-weight: bold;font-size: 13px;}
			
			.formula{color: #AFAFAF;}
			
			.status{width: 30px;height: 20px;margin-right: 10px;display:-moz-inline-box;display:inline-block;float: left;}
			.status0{background: url('../images/status4.png') center no-repeat;}
			.status1{background: url('../images/status5.png') center no-repeat;}
			.status2{background: url('../images/pstatus2.png') center no-repeat;}
			.status3{background: url('../images/status3.png') center no-repeat;}
			.status6{background: url('../images/status6.png') center no-repeat;}
			.status_txt{line-height: 20px;display:-moz-inline-box;display:inline-block;float: left;}
			
			.btn_exchange{width: 70px;height: 20px;line-height: 20px;text-align: center;border:1px #C0C0C0 solid;cursor: pointer;margin-top: 2px;margin-bottom: 2px;padding: 0px !important}
			.exchange_title{width: 100%;line-height: 22px;color: #808080;}
			.exchange_content{width: 100%;height: auto;overflow: hidden;line-height: 20px;border-bottom: 1px #C0C0C0 dashed;margin-bottom: 5px;padding-bottom: 3px;}
			.content_blur{width: 100%;height: 30px;resize:none;}
			.content_focus{width: 100%;height: 80px;resize:auto;}
			
			.progressBarStatus{width: 100%;}
			.t_left{width:80%; height:auto; float:left;}
			.t_right{width:19.5%; height:auto; float:left;}
            .t_r_content{width:100%; height:auto; background:#fff; overflow:auto;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	<SCRIPT language="javascript" src="/workrelate/js/pointout.js"></script>
	</head>
	<BODY style="overflow: auto">
		<form id="form1" name="form1" action="AccessOperation.jsp" method="post">
			<input type="hidden" name="scoreid" value="<%=scoreid %>">
			<input type="hidden" name="resourceid" value="<%=resourceid %>">
			<input type="hidden" name="year" value="<%=year %>">
			<input type="hidden" name="type1" value="<%=type1 %>">
			<input type="hidden" name="type2" value="<%=type2 %>">
			<input type="hidden" id="operation" name="operation" value="">
			<table id="main" width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
							<div id="yearpanel" class="yearpanel" >&nbsp;&nbsp;&nbsp;<%=year %></div>
									<%if(isfyear==1){ %><div class="tab <%if(type1.equals("4")){ %>tab_click<%} %>" onclick="changeType(4)">年度</div><%} %>
									<%if(ishyear==1){ %><div class="tab <%if(type1.equals("3")){ %>tab_click<%} %>" onclick="changeType(3)">半年</div><%} %>
									<%if(isquarter==1){%><div class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" onclick="changeType(2)">季度</div><%} %>
									<%if(ismonth==1){ %><div class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" onclick="changeType(1)">月度</div><%} %>
									<%if(type1.equals("1")){ %>
									<div class="tab2_panel" style="width: 422px;">
									<%for(int i=1;i<13;i++){ %>
										<div class="tab2 <%if(Integer.parseInt(type2)==i){ %>tab2_click<%} %>" onclick="changeType2(<%=i %>)"><%=i %>月</div>
									<%} %>
									</div>
									<%}else if(type1.equals("2")){ %>
									<div class="tab2_panel" style="width: 142px;">
									<%for(int i=1;i<5;i++){ %>
										<div class="tab2 <%if(Integer.parseInt(type2)==i){ %>tab2_click<%} %>" onclick="changeType2(<%=i %>)"><%=i %>季度</div>
									<%} %>
									</div>
									<%}else{ %>
									<div class="tab2_panel" style="width: 1px;border-right: 0px;"></div>
									<%} %>
							<div class="maintitle"><%=cmutil.getPerson(resourceid) %>目标绩效考核</div>
						</div>
						<%if(!msg.equals("")){ %>
							<font style="color: red;font-size: 13px;margin-left: 5px;"><%=msg %></font>
						<%}else{ %>
						
							<%
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
							%>
						<div style="width: 100%;height: 28px;">
							<div style="width: auto;height: 28px;float: left;">
								<div style="font-size: 13px;font-weight: bold;float: left;margin-right: 10px;"><%=scorename %></div>
								<%if((status.equals("0") || status.equals("1") || status.equals("2")) && TimeUtil.dateInterval(s_enddate,currentdate)>0){ %>
								<span class="status status6"></span>
								<%}else{ %>
								<span class="status status<%=status %>"></span>
								<%} %>
								<%if(status.equals("0") || status.equals("2")){ %>
									<span class="status_txt">待考核人：<%=cmutil.getPerson(auditid) %>&nbsp;&nbsp;截止日期：<%=s_enddate %></span>
								<%}else if(status.equals("1")){ %>
									<span class="status_txt">待审批人：<%=cmutil.getPerson(RightUtil.getUnAuditScoreHrm(scoreid)) %>&nbsp;&nbsp;截止日期：<%=s_enddate %></span>
								<%}%>
							</div>
							<div id="operate_panel" style="width: auto;height: 28px;float: right;">
								<%if(!isfirst.equals("1") && canedit){ %>
								<div class="btn1 btn" onclick="doScoreReturn();" title="退回考核结果">退回</div>
								<%} %>
								<%if(canreset && TimeUtil.dateInterval(currentdate,s_enddate)>=0){ %>
								<div class="btn1 btn" onclick="doReset();" title="重新进行考核评分">重新考核</div>
								<%} %>
								<%if(caninit){%>
								<div class="btn1 btn" onclick="doInit();" title="重置考核方案">重置</div>
								<%} %>
								<%if(canedit){%>
								<div class="btn1 btn" onclick="doSave();" title="保存为草稿">保存</div><div class="btn1 btn" onclick="doSubmit();" title="保存并提交">提交</div>
								<%} %>
								<%if(canaudit){ %>
								<div class="btn1 btn" onclick="doApprove();" title="批准考核结果">批准</div><div class="btn1 btn" onclick="doReturn();" title="退回考核结果">退回</div>
								<%} %>
							</div>
						</div>
						<div style="width:100%">
						    <div class="t_left">
						       <table id="maintable1" class="maintable" cellspacing="0" cellpadding="0" border="0">
							<tr class="header" style="height:62px;">
								<td width="80" style="width: 80px;" class="td_cate">分类</td><td class="td_type" width="100" style="width: 100px;">指标类型</td><td class="td_desc" width="*">指标描述</td><td width="60">权重(%)</td>
								<td class="td_value" width="120">目标值</td><td class="td_value" width="120">完成值</td><td class="td_value" width="120"><%=titlestr %>目标</td>
							</tr>
							<%	
									rs.executeSql(backfields+fromsql+sqlwhere+orderby);
									//System.out.println(backfields+fromsql+sqlwhere);
									String xmyj = "formtable_main_179";//formtable_main_130
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
							<tr id="tr1_<%=indexnum %>">
								<td class="td_cate" style="white-space: normal;line-height: 150%;" title="<%=Util.convertDB2Input(rs.getString("cate")) %>">
									<%=Util.convertDB2Input(rs.getString("cate")) %>
								</td>
								<td style="line-height: 150%;">
									<%=AccessItemComInfo.getName(Util.null2String(rs.getString("accessitemid")))+this.getFormulaName(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))),AccessItemComInfo.getFormuladetails(Util.null2String(rs.getString("accessitemid")))) %>
								</td>
								<td style="white-space: normal;line-height: 150%;" title="<%=Util.toHtml(rs.getString("description")) %>">
									<%=Util.toHtml(rs.getString("description")) %>
								</td>
								<td>
									<%=Util.null2String(rs.getString("rate")) %>
									<input type="hidden" id="d_rate_<%=deatilid %>" name="d_rate_<%=deatilid %>" value="<%=Util.null2String(rs.getString("rate")) %>"/>
								</td>
								<td class="td_value">
									<%if(itemtype==2 && (formula==2 || formula==3)){ %>
										<input type="hidden" id="target_<%=deatilid %>" name="target_<%=deatilid %>" value="<%=item_target %>"/>  
										<%=item_target %>
									<%}else{ %>
										<%if(canedit){%>
										<input class="input_txt2 <%if(itemtype==2){ %>mustinput<%} %>" type="text" id="target_<%=deatilid %>" name="target_<%=deatilid %>"
											 value="<%=item_target %>" maxlength="100"
											 <%if(itemtype==2){ %>onKeyPress="ItemNum_KeyPress('target_<%=deatilid %>')" onBlur="checknumber('target_<%=deatilid %>')"<%} %>
											 <%if(formula!=0){ %>onchange="doFormula(<%=deatilid %>,<%=formula %>,'<%=formuladetail %>')"<%} %>/>
										<%}else{ %>
											<%=item_target %>
										<%} %>
									<%} %>
									<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>
								</td>
								<td class="td_value" width="">
									<%if(itemtype==2 && (formula==2 || formula==3)){ %> 
										<input type="hidden" id="result_<%=deatilid %>" name="result_<%=deatilid %>" value="<%=item_result %>"/> 
										<input type="hidden" id="result2_<%=deatilid %>" name="result2_<%=deatilid %>" value="<%=item_result2 %>"/>   
										实际：<%=item_result %>
										<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %><br>
										有效：<%=item_result2 %>
										<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>
									<%}else{ %>
										<%if(canedit){%>
										<input class="input_txt2 <%if(itemtype==2){ %>mustinput<%} %>" type="text" id="result_<%=deatilid %>" name="result_<%=deatilid %>"
											 value="<%=item_result %>" maxlength="100"
											 <%if(itemtype==2){ %>onKeyPress="ItemNum_KeyPress('result_<%=deatilid %>')" onBlur="checknumber('result_<%=deatilid %>')"<%} %>
											 <%if(formula!=0){ %>onchange="doFormula(<%=deatilid %>,<%=formula %>,'<%=formuladetail %>')"<%} %>/>
										<%}else{ %>
											<%=item_result %>
										<%} %>
										<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>
									<%} %>
								</td>
								<td class="td_value" width="">
									<%if(canedit){%>
									<input class="input_txt2 <%if(itemtype==2){ %>mustinput<%} %>" type="text" id="next_<%=deatilid %>" name="next_<%=deatilid %>"
										 value="<%=item_next %>" maxlength="100"
										 <%if(itemtype==2){ %>onKeyPress="ItemNum_KeyPress('next_<%=deatilid %>')" onBlur="checknumber('next_<%=deatilid %>')"<%} %>
										 />
									<%}else{ %>
										<%=item_next %>
									<%} %>
									<%=AccessItemComInfo.getUnit(Util.null2String(rs.getString("accessitemid"))) %>
								</td>
							</tr>
							<%			
								}
							%>
							<tr>
								<td id="td_desc" colspan="5" rowspan="6" valign="top" style="line-height: 150%;white-space: normal;">
									<div style="font-weight: bold;line-height: 28px;">相关说明</div>
									<%if(remark.equals("")){ %>
										<font style="font-style: italic;color: #C3C3C3;">无</font>
									<%}else{ %>
										<%=remark %>
									<%} %>
								</td>
								<td colspan="2" class="title2">考核得分</td>
							</tr>
							<tr>
								<td colspan="2" class="title2" id="upscore">修正分数</td>
							</tr>
							<tr>
								<td colspan="2" class="title2">考核评价</td>
							</tr>
							<tr>
								<td colspan="2"  class="title2">相关附件</td>
							</tr>
							<tr>
								<td colspan="2" class="title2">月总得分</td>
							</tr>
							<tr>
								<td colspan="2" class="title2">最终得分</td>
							</tr>
							
						</table>
						    </div>
						    <div class="t_right">
						    <div class="t_r_content">
						        <table id="maintable2" class="maintable" cellspacing="0" cellpadding="0" border="0">
							<tr class="header" style="height:35px;">
								<%for(int i=0;i<scoreList.size();i++){ 
									String isedit = ((String[])scoreList.get(i))[8];
								%>
								<td class="td_check <%if(isedit.equals("1")){ %>edit_title<%} %>" colspan="3" style="width:300px;"><%=cmutil.getPerson(((String[])scoreList.get(i))[1]) %>(<%=((String[])scoreList.get(i))[2] %>%)</td>
								<%} %>
							</tr>
							<tr class="header2" style="height:27px;">
								<%for(int i=0;i<scoreList.size();i++){ 
									String isedit = ((String[])scoreList.get(i))[8];
								%>
								<td class="td_score <%if(isedit.equals("1")){ %>edit_title<%} %>">评分</td>
								<td class="td_result <%if(isedit.equals("1")){ %>edit_title<%} %>">得分</td>
								<td class="td_remark <%if(isedit.equals("1")){ %>edit_title<%} %>">说明</td>
								<%} %>
							</tr>
							<%	
									rs.executeSql(backfields+fromsql+sqlwhere+orderby);
									while(rs.next()){
										if(!Util.null2String(rs.getString("cate")).equals("")) hascate = true;
										deatilid = Util.null2String(rs.getString("id"));
										itemtype = Util.getIntValue(AccessItemComInfo.getType(Util.null2String(rs.getString("accessitemid"))),0);
										formula = Util.getIntValue(AccessItemComInfo.getFormula(Util.null2String(rs.getString("accessitemid"))),0);
							%>
							<tr id="tr1_<%=indexnum %>">
								<!-- 考核人员评分部分 -->
								<%for(int i=0;i<scoreList.size();i++){ 
									String isedit = ((String[])scoreList.get(i))[8];
									String checkid = ((String[])scoreList.get(i))[0];
								%>
								<td>
									<input type="hidden" id="cdid_<%=deatilid %>_<%=checkid %>" name="cdid_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("cdid_"+i)) %>" />
									<%if("1".equals(isedit) && (itemtype==1 || (itemtype==2 && (formula==0||formula==4)))){%>
									<input class="input_txt mustinput" type="text" id="d_score_<%=deatilid %>_<%=checkid %>" name="d_score_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("score_"+i)) %>"  maxlength="100"
										 onKeyPress="ItemNum_KeyPress('d_score_<%=deatilid %>_<%=checkid %>')" onBlur="checknumber('d_score_<%=deatilid %>_<%=checkid %>');"
										 onchange="checkScoreVal('d_score_<%=deatilid %>_<%=checkid %>');countScore(<%=deatilid %>,<%=checkid %>)" <%if(formula==4){ %>_formula4="1"<%} %>/>
									<%}else{ %>
										<span class="c_scorespan_<%=deatilid %> score_txt" id="d_scorespan_<%=deatilid %>_<%=checkid %>"><%=Util.null2String(rs.getString("score_"+i)) %></span>
										<input type="hidden" class="c_score_<%=deatilid %>" id="d_score_<%=deatilid %>_<%=checkid %>" name="d_score_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("score_"+i)) %>" <%if(formula==4){ %>_formula4="1"<%} %>/>
									<%} %>
								</td>
								<td>
									<span class="c_resultspan_<%=deatilid %> score_txt" id="d_resultspan_<%=deatilid %>_<%=checkid %>"><%=Util.null2String(rs.getString("result_"+i)) %></span>
									<input type="hidden" class="d_result_<%=checkid %> c_result_<%=deatilid %>" id="d_result_<%=deatilid %>_<%=checkid %>" name="d_result_<%=deatilid %>_<%=checkid %>"
										 value="<%=Util.null2String(rs.getString("result_"+i)) %>" />
								</td>
								<td style="white-space: normal;line-height: 150%;">
									<%if("1".equals(isedit)){%>
									<textarea class="area_txt" id="d_remark_<%=deatilid %>_<%=checkid %>" name="d_remark_<%=deatilid %>_<%=checkid %>"><%=Util.convertDB2Input(rs.getString("remark_"+i)) %></textarea>
									<%}else{ %>
										<%=Util.toHtml(rs.getString("remark_"+i)) %>
									<%} %>
								</td>
								<%} %>
							</tr>
							<%			
								}
							%>
							<tr>
								<%for(int i=0;i<scoreList.size();i++){ 
									String checkid = ((String[])scoreList.get(i))[0];
								%>
								<td colspan="3">
									<span id="s_scorespan_<%=checkid %>" class="score_txt"><%=((String[])scoreList.get(i))[3] %></span>
									<input type="hidden" id="s_score_<%=checkid %>" name="s_score_<%=checkid %>"
										 value="<%=((String[])scoreList.get(i))[3] %>" />
								</td>
								<%} %>
							</tr>
							<tr>
								<%for(int i=0;i<scoreList.size();i++){ 
									String checkid = ((String[])scoreList.get(i))[0];
									String isedit = ((String[])scoreList.get(i))[8];
									double revise = Util.getDoubleValue(((String[])scoreList.get(i))[4],0);
								%>
								<td colspan="3" style="white-space: normal;line-height: 150%;" class="upvalue">
									<%if("1".equals(isedit) && !(revisemax==0&&revisemin==0)){%>
									<input class="input_txt" style="margin-top: 2px" type="text" id="s_revise_<%=checkid %>" name="s_revise_<%=checkid %>"
										 value="<%=((String[])scoreList.get(i))[4] %>" maxlength="100"
										 onKeyPress="ItemNum_KeyPress('s_revise_<%=checkid %>')" onBlur="checknumber('s_revise_<%=checkid %>');"
										 onchange="checkReviseVal('s_revise_<%=checkid %>');countScore2(<%=checkid %>);changeReason(<%=checkid %>)" />
									<%}else{ %>
										<span class="score_txt"><%=((String[])scoreList.get(i))[4] %></span>
										<input type="hidden" id="s_revise_<%=checkid %>" value="<%=((String[])scoreList.get(i))[4] %>"/>
									<%} %>
									<div id="s_reason_div_<%=checkid %>" style="width: 100%;height: auto;<%if(revise==0){ %>display:none;<%} %>" >
									<%if("1".equals(isedit)){%>
									<textarea class="area_txt2 area_reason <%if(revise!=0){ %>mustinput<%} %>" id="s_reason_<%=checkid %>" name="s_reason_<%=checkid %>"><%=Util.convertDB2Input(((String[])scoreList.get(i))[10]) %></textarea>
									<%}else{ %>
										<%=Util.toHtml(((String[])scoreList.get(i))[10]) %>
									<%} %>
									</div>
								</td>
								<%} %>
							</tr>
							<tr>
								<%for(int i=0;i<scoreList.size();i++){ 
									String checkid = ((String[])scoreList.get(i))[0];
									String isedit = ((String[])scoreList.get(i))[8];
								%>
								<td colspan="3" style="white-space: normal;line-height: 150%;">
									<%if("1".equals(isedit)){%>
									<textarea class="area_txt2" id="s_remark_<%=checkid %>" name="s_remark_<%=checkid %>"><%=Util.convertDB2Input(((String[])scoreList.get(i))[6]) %></textarea>
									<%}else{ %>
										<%=Util.toHtml(((String[])scoreList.get(i))[6]) %>
									<%} %>
								</td>
								<%} %>
							</tr>
							<tr>
								<%for(int i=0;i<scoreList.size();i++){ 
									String fileids = ((String[])scoreList.get(i))[9];
									String isedit = ((String[])scoreList.get(i))[8];
								%>
								<td colspan="3" width="300px" class="td_check" style="white-space: normal;line-height: 150%;">
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
									<div style="width:auto"><a href="javaScript:openFullWindowHaveBar('../util/ViewDoc.jsp?id=<%=fileidList.get(j) %>&scoreid=<%=scoreid %>')"><%=docImagefilename %></a>
									&nbsp;<a href='../util/ViewDoc.jsp?id=<%=fileidList.get(j) %>&scoreid=<%=scoreid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
									&nbsp;<%=weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,4,(String)fileidList.get(j),scoreid,"") %>			            
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
										<input type="hidden" id="edit_relatedacc" name="edit_relatedacc" value="<%=fileids%>">
				     					<input type="hidden" id="delrelatedacc" name="delrelatedacc" value="">	
									<%}%>
								</td>
								<%} %>
							</tr>
							<tr>
								<%for(int i=0;i<scoreList.size();i++){ 
									String checkid = ((String[])scoreList.get(i))[0];
									String isedit = ((String[])scoreList.get(i))[8];
								%>
								<td colspan="3">
									<span id="s_resultspan_<%=checkid %>" class="score_txt"><%=((String[])scoreList.get(i))[5] %></span>
									<input type="hidden" class="s_result" id="s_result_<%=checkid %>" name="s_result_<%=checkid %>"
										 value="<%=((String[])scoreList.get(i))[5] %>" _rate="<%=((String[])scoreList.get(i))[2] %>"/>
								</td>
								<%} %>
							</tr>
							<tr>
								<td colspan="<%=scoreList.size()*3 %>" id="totalscore">
									<span id="score_resultspan" class="final"><%=result %></span>
									<input type="hidden" id="score_result" name="score_result" value="<%=result %>" />
								</td>
							</tr>
						</table>
						    </div>
						 </div>
						</div>
						<%}%>
						
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="50%" valign="top">
									<div class="title_panel">
										<div class="title_txt" style="color: #808080;">意见反馈</div>
									</div>
									<div id="exchange" style="width: 100%;border-bottom: 1px #ECECEC solid;overflow: hidden;">
										<textarea id="content" name="content" class="content_blur" onfocus="contentFocus()" onblur="contentBlur()"></textarea>
										<div id="exchangebtn" class="btn btn_exchange" style="display: none;" onclick="saveExchange()">保存</div>
										<div id="exchangeload" style="height: 22px;display: none;"><img style="margin-top: 4px;margin-right: 2px;" src='../images/loading2.gif'/></div>
									</div>
									<%
										String operatedate = "";
										rs.executeSql("select operator,operatedate,operatetime,content from GP_AccessScoreExchange where scoreid="+scoreid+" order by operatedate desc,operatetime desc,id desc");
										while(rs.next()){
											operatedate = Util.null2String(rs.getString("operatedate")+" "+rs.getString("operatetime"));
									%>
										<div class="exchange_title"><%=cmutil.getPerson(rs.getString("operator")) %>&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>
										<%if(!Util.null2String(rs.getString("operator")).equals(user.getUID()+"") 
												&& !viewdate.equals("") && TimeUtil.dateInterval(viewdate,operatedate)>0){ 
										%>
											<font style="color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;" title="新反馈">new</font>
										<%} %>
										</div>
										<div class="exchange_content"><%=Util.toHtml(rs.getString("content")) %></div>
									<%		
										}
									%>
								</td>
								<td width="3%"></td>
								<td width="47%" valign="top">
									<div class="title_panel">
										<div class="title_txt" style="color: #808080;">相关链接</div>
									</div>
									<div style="width: 100%;height: 24px;">
									<div style="color: #808080;float: left;white-space: nowrap;margin-right: 20px;">
										<a href="javaScript:openFullWindowHaveBar('/blog/viewBlog.jsp?blogid=<%=resourceid %>')">
											<%=ResourceComInfo.getLastname(resourceid)%>的工作微博</a>
									</div>
								<%if(type1.equals("1") && isplan){
									rs.executeSql("select 1 from PR_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2 and ismonth=1");
									if(rs.next()){
								%>
									
									<div style="color: #808080;float: left;white-space: nowrap">
										<a href="javaScript:openFullWindowHaveBar('/workrelate/plan/data/PlanView.jsp?year=<%=year %>&type1=1&type2=<%=type2 %>&resourceid=<%=resourceid %>')">
											<%=ResourceComInfo.getLastname(resourceid)%><%=year %>年<%=type2 %>月工作总结及计划</a>
									</div>
								<%		
									}
								}
								%>
									</div>
								
								<%if(!userid.equals(resourceid)){ //本人不能查看日志%>
									<div class="title_panel">
										<div class="title_txt" style="color: #808080;">操作日志</div>
									</div>
								<%
									rs.executeSql("select operator,operatedate,operatetime,operatetype,result from GP_AccessScoreLog where operatetype<>0 and scoreid="+scoreid+" order by operatedate desc,operatetime desc,id desc");
									if(rs.getCounts()>0){
								%>
								<%		String logoperator = "";
										String logresult = "";
										while(rs.next()){
											logresult = Util.null2String(rs.getString("result"));
											logoperator = Util.null2String(rs.getString("operator"));
											if(logoperator.equals("0")){
												logoperator = "系统";
											}else{
												logoperator = cmutil.getPerson(logoperator);
											}
								%>
									<div class="log_op" style="color: #808080;"><%=logoperator %>&nbsp;&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>&nbsp;&nbsp;&nbsp;<%=cmutil.getSocreOperateType(rs.getString("operatetype")) %>
									<%if(!logresult.equals("")){ %>&nbsp;&nbsp;&nbsp;最终得分：<%=logresult%><%} %>
									</div>
								<%		}
									}else{
								%>
									<font id="nolog" style="font-style: italic;color: #C3C3C3;">暂无</font>
								<%	}%>
								<div style="line-height:22px;font-style: italic;font-weight: normal;cursor: pointer;font-size: 12px;color: #A0A0A0;" onclick="showLog(this)" title="显示包括查看在内的所有日志记录">显示所有</div>
								<%
									int _pagesize = 10;
									int _total = 0;//总数
									rs.executeSql("select count(id) from GP_AccessScoreLog where scoreid="+scoreid);
									if(rs.next()){
										_total = rs.getInt(1);
									}
								%>
									<div id="btnmore" style="cursor: pointer;width: 70px;height: 20px;line-height: 20px;margin-right: 0px;text-align: left;
										color: #696969;display: none;font-weight: bold;letter-spacing: 8px;padding-left: 2px;font-size: 14px;" 
										onclick="getMoreLog(this)" _currentpage="0" _pagesize="<%=_pagesize %>" _total="<%=_total %>" title="加载更多日志">...</div>
								<%} %>
								</td>
							</tr>
						</table>
						<%} %>
						
						<div style="width: 100%;height: 10px;font-size: 0px;"></div>
					</td>
					<td></td>
				</tr>
			</table>
		</form>
		<div id="yearselect" class="yearselect">
		<% 
			int currentyear = Integer.parseInt(currentdate.substring(0,4));
			for(int i=2013;i<(currentyear+3);i++){ %>
			<div class="yearoption" _val="<%=i %>">&nbsp;&nbsp;&nbsp;<%=i %></div>
		<%	} %>
		</div>
		<script type="text/javascript" src="../js/tab.js"></script>  
		<script type="text/javascript">
			var loadstr = "<img src='../images/loading2.gif'/>";
			var reasondef = "请输入修正理由";
			var score_max = <%=scoremax%>;
			jQuery(document).ready(function(){
				<%if(isrefresh.equals("1")){%>
					refreshOpener();
				<%}%>

				jQuery("div.btn").live("mouseover",function(){
					jQuery(this).addClass("btn_hover");
				}).live("mouseout",function(){
					jQuery(this).removeClass("btn_hover");
				});
				<%if(hascate){%>
				var s = null;
                var prevTd = null;
                $("#maintable1").find('tr').each(function() {
                    var td = $(this).find('td').eq(0);
                    var s1 = td.text();
                    if (s1 == s) { //相同即执行合并操作
                        td.hide(); //hide() 隐藏相同的td ,remove()会让表格错位 此处用hide
                        prevTd.attr('rowspan', prevTd.attr('rowspan') ? parseInt(prevTd.attr('rowspan')) + 1 : 2); //赋值rowspan属性
                    }
                    else {
                        s = s1;
                        prevTd = td;
                    }
                });
                <%}else{%>
				$(".td_cate").width(0).hide();
				$("#td_desc").attr("colspan",4);
				if(navigator.userAgent.indexOf('MSIE') >= 0 && navigator.userAgent.toLowerCase().match(/msie ([\d.]+)/)[1]=="8.0"){
				   $('#maintable1').css("display","inline-table");
                   window.setTimeout(function(){$('#maintable1').css("display","");},0);
				}
                <%}%>
                
                <%if(caninit){%>
                    confirmStyle("考核方案已变更，是否更新？",function(){
			            doInit();
			        });
				<%}%>

				<%if(canedit && canupload){%>
					bindUploaderDiv(jQuery("#edit_uploadDiv"),"newrelatedacc");
				<%}%>

				<%
				//项目收款及验收需初始进行计算
				if(canedit){
					for (Object b : countmap.entrySet()) {  
				%>
					doFormula(<%=((Entry)b).getKey()%>,<%=((Entry)b).getValue()%>);
				<%		       
					}
				%>

				if($(".area_reason").val()==""){
					$(".area_reason").val(reasondef).addClass("area_blur");
				}
				$(".area_reason").bind("focus",function(){
					if($(this).val()==reasondef){
						$(this).val("").removeClass("area_blur");
					}
				}).bind("blur",function(){
					if($(this).val()=="" || $(this).val()==reasondef){
						$(this).val(reasondef).addClass("area_blur");
					}
				});
				
				<%
				}
				%>
				$(".t_r_content").scroll(function(){
				    var tleft=$(".t_r_content").scrollLeft();
				    $(this).find("#totalscore span").css({"position":"relative","left":tleft,"z-idex":"10"});
				});

				setWidth();
				$("#maintable2").find('tr').each(function() {
				    var td2 = $(this).find('td').eq(0);
				    td2.css("border-left",0);
				});
				<%if(checksize==1){%>
                    $(".t_left").width("75%");
                    $(".t_right").width("24.5%");
                    $(".td_score").css({"min-width":$("body").width()*0.245*0.2-9,"max-width":$("body").width()*0.245*0.2-9});
                    $(".td_result").css({"min-width":$("body").width()*0.245*0.2-9,"max-width":$("body").width()*0.245*0.2-9});
                    $(".td_remark").css({"min-width":$("body").width()*0.245*0.57-10,"max-width":$("body").width()*0.245*0.57-10});
                <%}%>
                <%if(checksize==2){%>
                    $(".t_left").width("60%");
                    $(".t_right").width("39.5%");
                    $(".td_score").css({"min-width":$("body").width()*0.395*0.1-9,"max-width":$("body").width()*0.395*0.1-9});
                    $(".td_result").css({"min-width":$("body").width()*0.395*0.1-9,"max-width":$("body").width()*0.395*0.1-9});
                    $(".td_remark").css({"min-width":$("body").width()*0.395*0.288-10,"max-width":$("body").width()*0.395*0.288-10});
					$(".td_check").width(240);
					//$(".td_remark").width(110);
					//$(".area_txt").width("100%");
					$(".input_txt2").width(60);
					$(".td_value").width(70);
					$(".td_type").width(60);
					$(".td_desc").width(100);
                <%}%>

                <%if(checksize>2){%>
                	$(".t_left").width("60%");
                    $(".t_right").width("39.5%");
                    if(navigator.userAgent.indexOf('MSIE') >= 0 && navigator.userAgent.toLowerCase().match(/msie ([\d.]+)/)[1]=="8.0"){
				       $(".td_score").css({"min-width":$("body").width()*0.395*0.1,"max-width":$("body").width()*0.395*0.1});
	                   $(".td_result").css({"min-width":$("body").width()*0.395*0.1,"max-width":$("body").width()*0.395*0.1});
	                   $(".td_remark").css({"min-width":$("body").width()*0.395*0.293,"max-width":$("body").width()*0.395*0.293});
				    }else{
				       $(".td_score").css({"min-width":$("body").width()*0.395*0.1,"max-width":$("body").width()*0.395*0.1});
	                   $(".td_result").css({"min-width":$("body").width()*0.395*0.1,"max-width":$("body").width()*0.395*0.1});
	                   $(".td_remark").css({"min-width":$("body").width()*0.395*0.288,"max-width":$("body").width()*0.395*0.288});
				    }
					$(".td_check").width(240);
					$(".input_txt2").width(60);
					$(".td_value").width(70);
					$(".td_type").width(60);
					$(".td_desc").width(100);
                <%}%>
                inittable();
			});
			$(window).resize(function(){
				setWidth();
			});
			function inittable(){
			    $("#maintable1").children('tbody').children('tr').each(function(h) {
                    if(h!=0){
                        var td1 = $(this).children('td').eq(0);
	                    if(td1.attr("id")=="td_desc" || td1.hasClass("td_cate")){
	                        td1 = $(this).children('td').eq(1);
	                    }
	                    var tdhight = td1.outerHeight();
	                    var mtr = $("#maintable2").find('tr').eq(Number(h)+1);
	                    var hight = mtr.find('td').eq(0).outerHeight();
	                    if(tdhight<hight){
	                       $(this).children('td').height(hight);
	                       mtr.find('td').height(hight);
	                    }else{
	                       mtr.find('td').height(tdhight);
	                       $(this).children('td').height(tdhight);
	                    }
                    }
                });
			}
			function setWidth(){
				if(jQuery(window).width()<1100){
					jQuery("#main").width(1100);
				}else{
					jQuery("#main").width("100%");
				}
			}
			<%if(canedit){%>
			function doSave(obj) {
				jQuery(".area_reason").each(function(){
					if(jQuery(this).val()==reasondef){
						jQuery(this).val("");
					}
				});
				showload(obj);
				jQuery("#operation").val("save");
				//obj.disabled = true;
				<%if(canupload){%>
					submitform();
				<%}else{%>
					doSaveAfterAccUpload();
				<%}%>
			}
			function doSubmit(obj) {
			    confirmStyle("确定提交考核结果?",function(){
			        if(checkMust()){
			           jQuery("#operation").val("submit");
					   //obj.disabled = true;
					   showload(obj);
					   <%if(canupload){%>
						  submitform();
					   <%}else{%>
						 doSaveAfterAccUpload();
					  <%}%>
			        }
			    });
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
				jQuery("#form1").submit();
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
					alertStyle("请完整填写考核分数\n定量指标需填写完成值及<%=titlestr %>目标\n有修正分时需填写修正理由");
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
					/**
					if(target!=0){
						d_score = (target-result)/target * 5;
					}
					if(d_score>5) d_score = 5;
					
					if(target!=0){
						var frate = result/target * 100;//花费比例
						if(frate<70) d_score = 5;
						else if(frate>=70 && frate<75) d_score = 4.1;
						else if(frate>=75 && frate<80) d_score = 3.6;
						else if(frate>=80 && frate<85) d_score = 3.1;
						else if(frate>=85 && frate<90) d_score = 2.6;
						else if(frate>=90 && frate<95) d_score = 2.1;
						else if(frate>=95 && frate<100) d_score = 1.6;
						else if(frate==100) d_score = 0;
						else if(frate>100) d_score = -1;
					}else if(result>target){
						d_score = -1;
					}
					*/
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
						       alertStyle(data.msg);
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
				/**
				var d_rate = getFloatVal($("#d_rate_"+detailid).val());
				var d_result = (d_score*d_rate/100).toFixed(2);

				$(".c_result_"+detailid).val(d_result);
				$(".c_resultspan_"+detailid).html(d_result);
				*/
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
					$(".upvalue").height("30px");
					$("#upscore").height("30px");
				}else{
					$("#s_reason_div_"+checkid).show();
					$("#s_reason_"+checkid).addClass("mustinput");
				}
				inittable();
			}
			function checkScoreVal(objid){
				var score_val = getFloatVal($("#"+objid).val());
				if(score_val><%=scoremax%> || score_val<<%=scoremin%>){
					alertStyle("评分值需控制在<%=scoremin%>-<%=scoremax%>之间!");
					$("#"+objid).val("");
				}
			}
			function checkReviseVal(objid){
				var revise_val = getFloatVal($("#"+objid).val());
				if(revise_val><%=revisemax%> || revise_val<<%=revisemin%>){
					alertStyle("修正分值需控制在<%=revisemin%>-<%=revisemax%>之间!");
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
			    confirmStyle("确定重置考核项及结果?",function(){
			        jQuery("#operation").val("init");
					showload(obj);
					jQuery("#form1").submit();
			    });
			}
			<%}%>
			<%if(canaudit){ %>
			function doApprove(obj) {
			    confirmStyle("确定批准此考核结果?",function(){
			        jQuery("#operation").val("approve");
					showload(obj);
					jQuery("#form1").submit();
			    });
			}
			function doReturn(obj) {
			    confirmStyle("确定退回此考核结果?",function(){
			        jQuery("#operation").val("return");
					showload(obj);
					jQuery("#form1").submit();
			    });
			}
			<%}%>
			<%if(!isfirst.equals("1") && canedit){ %>
			function doScoreReturn(obj){
			    confirmStyle("确定退回此考核结果?",function(){
			        jQuery("#operation").val("score_return");
					showload(obj);
					jQuery("#form1").submit();
			    });
			}
			<%}%>
			<%if(canreset){ %>
			function doReset(obj){
			    confirmStyle("确定重新进行考核评分?",function(){
			        jQuery("#operation").val("reset");
					showload(obj);
					jQuery("#form1").submit();
			    });
			}
			<%}%>
			function changeYear(year){
				window.location = "AccessView.jsp?resourceid=<%=resourceid%>&year="+year+"&type1=<%=type1%>&type2=<%=type2%>";
			}
			function changeType(type){
				window.location = "AccessView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1="+type;
			}
			function changeType2(type){
				window.location = "AccessView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1=<%=type1%>&type2="+type;
			}
			function showload(obj){
				if(obj!=null && typeof(obj)!="undefined"){
					obj.disabled = true;
				}
				jQuery("#operate_panel").html(loadstr);
			}
			document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){
					if(event.ctrlKey){
						saveExchange()
					}
			    	 
			    }    
			}
			function saveExchange(){
				if(jQuery("#content").val()==""){	
					alertStyle("请填写意见内容！");
				}else{
					jQuery("#exchangebtn").hide();
					jQuery("#exchangeload").show();
					jQuery.ajax({
						type: "post",
					    url: "AccessOperation.jsp",
					    data:{"operation":"add_exchange","scoreid":"<%=scoreid%>","content":filter(encodeURI(jQuery("#content").val()))}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    if(data!=""){
						    	var txt = $.trim(data.responseText);
						    	jQuery("#exchange").after(txt);
						    }
						    jQuery("#exchangebtn").show();
							jQuery("#exchangeload").hide();
							jQuery("#content").val("").blur();
						}
				    });
				}
			}
			function contentFocus(){
				if(jQuery("#content").val()==""){
					jQuery("#content").addClass("content_focus");
					jQuery("#exchangebtn").show();
					var st = jQuery(document).scrollTop();
					jQuery(document).scrollTop(st+80);
				}
			}
			function contentBlur(){
				if(jQuery("#content").val()==""){
					jQuery("#content").removeClass("content_focus");
					jQuery("#exchangebtn").hide();
				}
			}
			Number.prototype.toFixed=function (d) 
			{ 

			  var s=this+""; 
			  if(!d)d=0;     
			  if(s.indexOf(".")==-1)s+="."; 
			  s+=new Array(d+1).join("0");     
			  if(new RegExp("^(-|\\+)?(\\d+(\\.\\d{0,"+(d+1)+"})?)\\d*$").test(s)) 
			  { 

			    var s="0"+RegExp.$2,pm=RegExp.$1,a=RegExp.$3.length,b=true;       
			    if(a==d+2){ 
			      a=s.match(/\d/g); 
			      if(parseInt(a[a.length-1])>4) 
			      { 

			        for(var i=a.length-2;i>=0;i--){ 
			          a[i]=parseInt(a[i])+1;             
			          if(a[i]==10){ 
			            a[i]=0; 
			            b=i!=1; 

			          }else break; 

			        } 

			      } 
			      s=a.join("").replace(new RegExp("(\\d+)(\\d{"+d+"})\\d$"),"$1.$2");         

			    }if(b)s=s.substr(1); 
			    return (pm+s).replace(/\.$/,""); 

			  }return this+"";     

			}; 

			function showLog(obj){
				jQuery(obj).remove();
				//jQuery("div.logview").show();
				jQuery("#btnmore").html("<img src='../images/loading2.gif' align='absMiddle'/>").show();
				jQuery("div.log_op").hide();
				getMoreLog(jQuery("#btnmore"));
			}
			//读取更多日志
			function getMoreLog(obj){
				var btnobj = jQuery(obj);
				var _currentpage = parseInt(btnobj.attr("_currentpage"))+1;
				var _pagesize = btnobj.attr("_pagesize");
				var _total = btnobj.attr("_total");
				btnobj.html("<img src='../images/loading2.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "/performance/access/AccessOperation.jsp",
				    data:{"operation":"get_more_log","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"scoreid":"<%=scoreid%>"}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    if($("#nolog").length>0) $("#nolog").remove();
				    	var txt = $.trim(data.responseText);
				    	btnobj.before(txt);
				    	var st = document.body.scrollTop;
						jQuery("html, body").scrollTop(st+210);
				    	if(_currentpage*_pagesize>=_total){
				    		btnobj.hide();
					    }else{
					    	btnobj.attr("_currentpage",_currentpage).html("...").show();
						}
					}
			    });
			}
		</script>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			if(!isfirst.equals("1") && canedit){
				RCMenu += "{退回,javascript:doScoreReturn(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canreset && TimeUtil.dateInterval(currentdate,s_enddate)>=0){
				RCMenu += "{重新考核,javascript:doReset(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(caninit){
				RCMenu += "{重置,javascript:doInit(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canedit){
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
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
	</BODY>
</HTML>
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