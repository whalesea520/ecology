<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.pr.util.RightUtil"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.pr.util.OperateUtil" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<% 
	//所有经理及计划报告确认人有权限查看
	String userid = user.getUID()+"";
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
			response.sendRedirect("../util/Message.jsp?type=1") ;
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
		response.sendRedirect("../util/Message.jsp?type=2") ;
		return;//未启用
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

	
	request.getSession().setAttribute("PR_PLANREPORT_YEAR",year);
	request.getSession().setAttribute("PR_PLANREPORT_TYPE1",type1);
	request.getSession().setAttribute("PR_PLANREPORT_TYPE2_"+type1,type2);
	
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
	String titlename = planname;
%>
<HTML>
	<HEAD>
		<title><%=planname %></title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="../../js/util.js"></script>
		<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language="javascript" src="/workrelate/js/jquery.textarea.autoheight.js"></script>
		<SCRIPT language="javascript" src="../js/jquery.dragsort.js"></script>
		<link rel="stylesheet" type="text/css" href="../css/tab.css" />
		<style type="text/css">
			.maintable,.maintable2{width: 100%;border-collapse: collapse;}
			.maintable td{line-height: 180%;padding-left: 2px;padding-right: 4px;padding-top: 4px;padding-bottom: 4px;border-bottom: 1px #F6F6F6 solid;white-space: normal;height: 28px;word-break:break-all;}
			.maintable2 td{line-height: 180%;border-bottom: 1px #F6F6F6 solid;word-break:break-all;}
			.maintable td.title{background: #DDD9C3;}
			.maintable td.title2{font-weight: bold;background: #F8F8F8;text-align: right;padding-right: 8px;}
			.maintable tr.header td,.maintable2 tr.header td{font-weight: normal;background: #fff;text-align: left;line-height: 28px;padding: 0px;padding-left: 2px;color: #999999;}
			.maintable tr.header1 td,.maintable2 tr.header1 td{border-bottom-color: #59D445;color: #000000;font-weight: bold;background:#f8f8f8;height:30px;padding-left:5px;padding-top:4px !important;padding-bottom:0px !important;line-height: 28px;cursor: pointer;}
			.maintable tr.header2 td{border-bottom-color: #CD682B;}
			.maintable td.edit_title{background: #EAEAEA !important;}
			.maintable td .icheck{margin-bottom: 5px;margin-right: 5px;vertical-align: middle;}
			td.td_index{white-space: nowrap;color: #525252;}
			<%if(canedit){%>td.td_index{cursor: move !important;}<%}%>
			.tr_data td{position: relative;}
			.input_span{color: #C9C9C9;}
			.td_spancate{border-bottom-color: #fff !important;}
			.td_index_span{border-bottom-color:#fff !important;}
			.tr_data_hover td{background: #EBF1DE;}
			.tr_data_hover td{border-bottom-color: #4f95e4 !important;}
			.tr_data_hover td .input_txt{color:#000;border-bottom-color: #EBF1DE;}
			.tr_blank td{font-size: 0px;border: 0px;height: 2px;}
			
			.btn_panel{width: auto;height: 26px;background: #4f95e4;position: absolute;top: 0px;right: 0px;overflow: hidden;display: none;}
			.btn_opt{width: 26px;height: 26px;float: left;cursor: pointer;}
			.btn_copy{background: url('../images/btn_copy.png') center no-repeat;}
			.btn_insert{background: url('../images/btn_insert.png') center no-repeat;}
			.btn_create{background: url('../images/btn_create.png') center no-repeat;}
			.btn_detail{background: url('../images/btn_detail.png') center no-repeat;}
			.btn_detail_new{background-color: red}
			.newfb{width: 26px;height: 25px;line-height: 25px;text-align: center;background: #fff;color: red;position: absolute;right: 0px;bottom: 0px;font-style: italic;font-weight: normal;}
			
			.title_panel{width: 100%;height: 24px;margin-top: 10px;position: relative;}
			.cate_panel{cursor: pointer;}
			.tag1{width: 5px;height: 25px;background: #59D445;font-size: 0px;float: left;margin-right: 7px;}
			.tag2{width: 5px;height: 25px;background: #CD682B;font-size: 0px;float: left;margin-right: 7px;}
			.tag3{width: 5px;height: 25px;background: #0080FF;font-size: 0px;float: left;margin-right: 7px;}
			.tag4{width: 5px;height: 25px;background: #808080;font-size: 0px;float: left;margin-right: 7px;}
			.tag5{width: 5px;height: 25px;background: #808080;font-size: 0px;float: left;margin-right: 7px;}
			.tag6{width: 5px;height: 25px;background: #808080;font-size: 0px;float: left;margin-right: 7px;}
			.title_txt{width: auto;line-height: 25px;float: left;font-weight: bold;font-size: 13px;}
			.cate_more{width: auto;line-height: 25px;float: left;padding-left: 5px;font-weight: bold;display: none;}
			.head_more{width: auto;padding-left: 5px;font-weight: bold;display: none;}
			.btn_con{width: auto;;height: 20px;position: absolute;right: 2px;top:6px;}
			.btn_add{width: 20px;height: 20px;background: url('../images/add.png');cursor: pointer;float: left;margin-right: 5px;}
			.btn_add_hover{background: url('../images/add_hover.png');}
			.btn_del{width: 20px;height: 20px;background: url('../images/delete.png');cursor: pointer;float: left;}
			.btn_del_hover{background: url('../images/delete_hover.png');}
			.btn1{width: 55px;line-height: 20px;height: 20px;padding: 0px !important;text-align: center;border: 1px #C5C5C5 solid;color:#808080;cursor: pointer;margin-left: 5px;float: left;font-weight: normal !important;font-size: 12px !important;}
			
			.btn2{width: 40px;line-height: 20px;height: 20px;padding: 0px !important;text-align: center;border: 1px #B0B0B0 solid;cursor: pointer;margin-left: 5px;float: left;}
			
			.btn_browser{width:25px;height:22px;float: left;margin-left: 0px;margin-top: 2px;cursor: pointer;
				background: url('../images/btn_browser.png') center no-repeat !important;}
			.btn_hover{background: #5581DA;color: #fff;border-color: #5581DA !important;}	
			.txt_browser{width:200px;height:22px;line-height:22px;float: left;margin-top: 2px;}	
				
			.input_txt{width: 96%;font-size: 12px;background: none;padding-left: 0px;margin-left: 0px;border: 0px !important;border-bottom: 1px #ffffff solid !important;outline: none;height: 23px;padding-top: 3px;padding-bottom: 0px;word-break:break-all;}
			.input_txt_hover{border-bottom-color: #D1D1D1 !important;}
			.input_txt_focus{border-bottom-color: #FF8040 !important;}
			.input_txt2{width: 96%;font-size: 12px;}
			.input_first{width: 70%;}
			.area_txt{overflow-x: hidden;overflow-y: hidden;resize:none;word-break:break-all;min-height: 22px;line-height: 22px;}
			.area_txt2{width: 98%;height: 70px;margin-top: 2px;margin-bottom: 2px;overflow-x: hidden;overflow-y: auto;}
			.area_reason{height: 50px;}
			.area_blur{font-style: italic;color: #C3C3C3;}
			.score_txt{font-size: 12px !important;}
			.final{font-weight: bold;font-size: 13px;}
			
			.formula{color: #AFAFAF;}
			
			.status{width: 30px;height: 20px;margin-right: 10px;display:-moz-inline-box;display:inline-block;float: left;}
			.status0{background: url('../images/pstatus0.png') center no-repeat;}
			.status1{background: url('../images/status5.png') center no-repeat;}
			.status2{background: url('../images/pstatus2.png') center no-repeat;}
			.status3{background: url('../images/status3.png') center no-repeat;}
			.status6{background: url('../images/status6.png') center no-repeat;}
			.status_txt{line-height: 20px;display:-moz-inline-box;display:inline-block;float: left;}
			
			.btn_exchange{width: 70px;height: 20px;line-height: 20px;text-align: center;border:1px #C0C0C0 solid;cursor: pointer;margin-top: 2px;margin-bottom: 2px;}
			.exchange_title{width: 100%;line-height: 22px;color: #808080;}
			.exchange_content{width: 100%;height: auto;overflow: hidden;line-height: 20px;border-bottom: 1px #C0C0C0 dashed;margin-bottom: 5px;padding-bottom: 3px;}
			.content_blur{width: 100%;height: 30px;resize:none;}
			.content_focus{width: 100%;height: 80px;resize:auto;}
			
			.progressBarStatus{width: 100%;}
			.remark{padding:0px;line-height: 180%;}
			.remark p{margin: 0px;}
			
			.cke_skin_v2 .cke_top,.cke_skin_v2 .cke_contents{border-color: #fff !important;}
			button.Calendar{height: 22px !important;background-position: bottom left;}
			button.Calendar_d{background-image: none !important;}
			.logview{display: none;}
			.scroll{
				SCROLLBAR-DARKSHADOW-COLOR: #EBEBEB;
				SCROLLBAR-ARROW-COLOR: #F7F7F7;
				SCROLLBAR-3DLIGHT-COLOR: #EBEBEB;
				SCROLLBAR-SHADOW-COLOR: #EBEBEB;
				SCROLLBAR-HIGHLIGHT-COLOR: #EBEBEB;
				SCROLLBAR-FACE-COLOR: #EBEBEB;
				scrollbar-track-color: #F7F7F7;
				background: #FCFCFC;
				overflow-x: hidden; 
			}
			.cke_wrapper{background:none !important;}
			.opttd{vertical-align:bottom;}
			.optshow {background-image: url("/workrelate/plan/images/optshow.png");background-repeat: no-repeat;width: 16px;background-position: 50% 50%;height: 25px;cursor: pointer;float:right;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	<SCRIPT language="javascript" src="/workrelate/js/pointout.js"></script>
	</head>
	<BODY style="overflow: auto">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			if(canreset && TimeUtil.dateInterval(currentdate,s_enddate)>=0){
				RCMenu += "{重新编写,javascript:doReset(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canedit){
				RCMenu += "{保存,javascript:doSave(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{提交,javascript:doSubmit(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(candel){
				RCMenu += "{删除,javascript:doDel(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canaudit){
				RCMenu += "{批准,javascript:doApprove(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{退回,javascript:doReturn(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(editshare){
				RCMenu += "{共享,javascript:doShare(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="form1" name="form1" action="PlanOperation.jsp" method="post">
			<input type="hidden" name="planid" value="<%=planid %>">
			<input type="hidden" name="planname" value="<%=planname %>">
			<input type="hidden" name="resourceid" value="<%=resourceid %>">
			<input type="hidden" name="auditids" value="<%=auditids %>">
			<input type="hidden" name="year" value="<%=year %>">
			<input type="hidden" name="type1" value="<%=type1 %>">
			<input type="hidden" name="type2" value="<%=type2 %>">
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
					<td valign="top" style="position: relative;">
						<div class="tabpanel">
							<div id="yearpanel" class="yearpanel" >&nbsp;&nbsp;&nbsp;<%=year %></div>
									
									<%if(isweek==1){%><div class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" onclick="changeType(2)">周报</div><%} %>
									<%if(ismonth==1){ %><div class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" onclick="changeType(1)">月报</div><%} %>
									<%if(type1.equals("1")){ %>
									<div class="tab2_panel" style="width: 91px;">
										<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>" <%if(inttype2!=1){ %> onclick="changeType2(<%=inttype2-1 %>)" title="上一月" <%} %>></div>
										<div id="monthpanel" class="week_txt" title=""><%=type2 %>&nbsp;月</div>
										<div class="week_btn2 <%if(inttype2!=12){ %>week_next<%} %>" <%if(inttype2!=12){ %> onclick="changeType2(<%=inttype2+1 %>)" title="下一月" <%} %>></div>
									</div>
									<%}else if(type1.equals("2")){ 
									%>
									<div class="tab2_panel" style="width: 91px;">
										<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>" <%if(inttype2!=1){ %> onclick="changeType2(<%=inttype2-1 %>)" title="上一周" <%} %>></div>
										<div id="weekpanel" class="week_txt" title="<%=weekdate1+" 至 "+weekdate2 %>">第&nbsp;<%=type2 %>&nbsp;周</div>
										<div class="week_btn2 <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %>week_next<%} %>" <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %> onclick="changeType2(<%=inttype2+1 %>)" title="下一周" <%} %>></div>
									</div>
									<%}else{ %>
									<div class="tab2_panel" style="width: 1px;border-right: 0px;"></div>
									<%} %>
							
							<%if(msg.equals("")){ %>
							<div id="operate_panel" style="width: auto;height: 28px;float: right;margin-top: 4px;">
								<%if(canreset && TimeUtil.dateInterval(currentdate,s_enddate)>=0){ %>
								<div class="btn1 btn" onclick="doReset();" title="重新编写计划报告">重新编写</div>
								<%} %>
								<%if(canedit){%>
								<div class="btn1 btn" onclick="doSave();" title="保存为草稿">保存</div><div class="btn1 btn" onclick="doSubmit();" title="保存并提交">提交</div>
								<%} %>
								<%if(candel){%>
								<div class="btn1 btn" onclick="doDel();" title="删除计划报告">删除</div>
								<%} %>
								<%if(canaudit){ %>
								<div class="btn1 btn" onclick="doApprove();" title="批准计划报告">批准</div><div class="btn1 btn" onclick="doReturn();" title="退回计划报告">退回</div>
								<%} %>
								<%if(editshare){%>
								<div class="btn1 btn" onclick="doShare();" title="共享计划报告">共享</div>
								<%} %>
							</div>
							<div style="width: auto;height: 28px;float: right;font-size: 12px;font-weight: normal;margin-top: 5px;color: #999999;">
								
								<%if((status.equals("0") || status.equals("1") || status.equals("2")) && TimeUtil.dateInterval(s_enddate,currentdate)>0){ %>
								<span class="status status6"></span>
								<%}else{ %>
								<span class="status status<%=status %>"></span>
								<%} %>
								<%if(status.equals("1")){ %>
									<span class="status_txt">待审批人：<%=cmutil.getPerson(RightUtil.getUnAuditPlanHrm(planid)) %>&nbsp;&nbsp;截止日期：<%=s_enddate %></span>
								<%}else if(!status.equals("3")){%>
									<span class="status_txt">提交截止日期：<%=s_enddate %></span>
								<%}%>
							</div>
							<%} %>
							<div class="maintitle"><%=cmutil.getPerson(resourceid) %>工作计划报告
							<%if(programid.equals("0") && canedit){ %><font style="font-size: 12px;font-weight: normal;font-style: italic;" title="您可自定义计划报告模板"><a href="../program/ProgramFrame.jsp?resourceid=<%=resourceid %>&programtype=<%=type1 %>" target="_blank"> [定义模板]</a></font><%} %></div>
						</div>
						<%if(!msg.equals("")){ %>
							<font style="color: red;font-size: 13px;margin-left: 5px;"><%=msg %></font>
						<%}else{ %>
						<%
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
						<div class="title_panel cate_panel" title="点击收缩">
							<div class="tag1"></div>
							<div class="title_txt"><%=year+"年"+type2+titlestr %>工作总结</div>
							<div class="cate_more">. . .</div>
						</div>
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="12px;"></td>
								<td width="*">
									<table id="maintable1" class="maintable" cellspacing="0" cellpadding="0" border="0">
										<tr class="header">
											<td width="2%"></td>
											<%
												for(int i=0;i<showfields1.size();i++){ 
													feilds = ((String[])showfields1.get(i));
													fieldname = feilds[1];
													showname = feilds[2];
													ismust = feilds[4];
													if(showname.equals("")) showname = feilds[0];
													if(fieldname.equals("finishrate")) {
														if("1".equals(ismust) && canedit){
															showname+="(% 必填)";
														}else{
														    showname+="(%)";
														}
													}else{
														if(("1".equals(ismust) || fieldname.equals("name")) && canedit) showname+="(必填)";
													}
													if(fieldname.equals("cate")) hascate1 = true;
											%>
											<td id="column1_<%=fieldname %>" class="td_title1" _width="<%=feilds[3] %>"
											 	<%if(canedit&&i==0){ %> style="padding-left: 25px;"<%} %>>
												<%=showname %>
											</td>
											<%} %>
											<td width="2%"></td>
										</tr>
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
										<tr class="header1" _tindex="<%=m%>" title="点击收缩">
											<td colspan="<%=showfields1.size()+2 %>" style="position: relative;" title="<%=datadesc %>"><%=datatitle %>
											<span class="head_more">. . .</span>
											<%if(canedit && m==1){%>
												<div class="btn_con" >
													<div class="btn_add" onclick="doAddRow1()" title="添加"></div>
													<div class="btn_del" onclick="doDelRow1()" title="删除"></div>
												</div>
											<%} %>
											</td>
										</tr>							
										<!-- <tr class="tr_blank<%if(m==1){ %> tr_show<%} %>"><td class="td_blank" colspan="<%=showfields1.size()+1%>"></td></tr> -->
										<%	
											//读取总结内容
											sql = "select t1.id,t1.name,t1.cate,t1.begindate1,t1.enddate1,t1.begindate2,t1.enddate2,t1.days1,t1.days2,t1.finishrate,t1.target,t1.result,t1.custom1,t1.custom2,t1.custom3,t1.custom4,t1.custom5 ";
											if(planid.equals("")){
												if(m==0){
													sql += " from PR_PlanReportDetail t1 where t1.planid=(select t2.id from PR_PlanReport t2 where t2.userid="+resourceid+" and t2.year="+prevyear+" and t2.type1="+type1+" and t2.type2="+prevtype2+")";//读取上个月的计划内容
												}else{
													break;
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
										<%if(rs.getCounts()==0 && m==0){%><tr class="tr_none0"><td colspan="<%=showfields1.size() %>" style="font-style: italic;color: #808080;padding-left: 3px;">无</td></tr><%}%>
										<%if(rs.getCounts()==0 && m==1 && !canedit){%><tr class="tr_none1"><td colspan="<%=showfields1.size() %>" style="font-style: italic;color: #808080;padding-left: 3px;">无</td></tr><%}%>
										<%
											while(rs.next()){
												fbdate = Util.null2String(rs.getString("fbdate"));
										%>
										<tr id="tr1_<%=index1 %>" class="tr_data tr_must tr_show<%=m%><%if(m==1){ %> tr_show<%} %>" _index="<%=index1 %>" _type="1">
											<td width="2%" class="td_index" valign="top" title="拖动调整排序"></td>
										<%
											for(int i=0;i<showfields1.size();i++){ 
												feilds = ((String[])showfields1.get(i));
												fieldname = feilds[1];
												detailedit = canedit;
												if(m==0 && showstemp.indexOf(fieldname)>-1) detailedit = false;
										%>
											<td valign="top" class="td1_<%=fieldname %>" <%if(canedit && i==0 && !detailedit){%>style="padding-left: 20px !important"<%} %>>
											<%if(detailedit){%>
												<%if(i==0){ %><input class="icheck" type="checkbox" notBeauty="false" _index="<%=index1 %>" 
												/><%} %><%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){//多行文本 %><textarea 
												class="area_txt input_txt <%if(i==0){ %>input_first<%} %>" id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>"><%=Util.convertDB2Input(rs.getString(fieldname)) %></textarea>
												<%}else if(fieldname.indexOf("date")>-1){//日期 %><button 
												type="button" class="Calendar Calendar_d" onclick="getMyDate('s_<%=fieldname %>_value_<%=index1 %>','s_<%=fieldname %>_span_<%=index1 %>')">
												</button><span id="s_<%=fieldname %>_span_<%=index1 %>" class="datespan" title="<%=Util.null2String(rs.getString(fieldname)) %>"><%=this.convertdate(rs.getString(fieldname)) %></span>
			              						<input type="hidden" id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>">
												<%}else{//单行文本 %><input class="input_txt<%if(i==0){ %> input_first<%} %>" type="text" 
													id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>" 
													<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
													onkeypress="ItemNum_KeyPress('s_<%=fieldname %>_value_<%=index1 %>')" onblur="checknumber('s_<%=fieldname %>_value_<%=index1 %>')" maxlength="5"<%} %>
													<%if(fieldname.equals("cate")){%> onchange="seteditspan(1)" <%}%>
													<%if(fieldname.equals("name")||fieldname.equals("cate")){%> maxlength="100" <%} %>/>
												<%} %>
											<%}else{ %>
												<%//if(canedit && i==0){ &nbsp;&nbsp;&nbsp;&nbsp;} %>
												<%if(fieldname.equals("cate")){ %><span><%=Util.toHtml(rs.getString(fieldname)) %></span>
												<%}else{ %><%=Util.toHtml(rs.getString(fieldname)) %><%} %>
												<input class="input_txt" type="hidden" id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
											<%} %>
											<%if(i==0){ %>
												<input type="hidden" id="s_id_value_<%=index1 %>" name="s_id_value_<%=index1 %>" value="<%=Util.null2String(rs.getString("id")) %>"/>
												<input type="hidden" name="s_datatype_value_<%=index1 %>" value="<%=datatype %>"/>
												<input type="hidden" class="value_index" name="s_showorder_value_<%=index1 %>" value=""/>
											<%} %>
											<%if(i==(showfields1.size()-1)){ %>
												<%	if(!fbdate.equals("") && !viewdate.equals("") && TimeUtil.dateInterval(viewdate,fbdate)>0){ %>
													<div id="fbnew_<%=index1 %>_1" class="newfb">new</div>
												<%	} %>
											<%} %>
											</td>
										<%	} %>
										<%
											for(int i=0;i<hidefields1.size();i++){ 
												feilds = ((String[])hidefields1.get(i));
												fieldname = feilds[1];
										%>
											<input type="hidden" id="s_<%=fieldname %>_value_<%=index1 %>" name="s_<%=fieldname %>_value_<%=index1 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
										<%	} %>
										<td width="2%" class="opttd"><div class="optshow">&nbsp;</div></td>
										</tr>
										<%	index1++;} %>
										<%} %>
									</table>
									<table class="maintable2" style="margin-top: 0px;" cellspacing="0" cellpadding="0" border="0">
										<tr class="header1" _tindex="2" title="点击收缩">
											<td style="position: relative;">工作总体分析<span class="head_more">. . .</span></td>
										</tr>
										<tr class="tr_show2">
											<td class="remark" style="<%if(!canedit){%>padding-top:4px;padding-bottom:4px;<%} %>" valign="top">
												<%if(canedit){%>
													<%=remark %>
													<textarea id="remark" name="remark"><%=remark%></textarea>
												<%}else{ %>
													<%=remark %>
												<%} %>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						
						
						<div class="title_panel cate_panel" title="点击收缩">
							<div class="tag2"></div>
							<div class="title_txt"><%=nextyear+"年"+nexttype2+titlestr %>工作计划</div>
							<div class="cate_more">. . .</div>
							<%if(canedit){%>
								<div class="btn_con" >
									<div class="btn_add" onclick="doAddRow2()" title="添加"></div>
									<div class="btn_del" onclick="doDelRow2()" title="删除"></div>
								</div>
							<%} %>
						</div>
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="12px;"></td>
								<td width="*" valign="top">
									<table id="maintable2" class="maintable" cellspacing="0" cellpadding="0" border="0">
										<tr class="header header2">
											<td width="2%"></td>
											<%
												for(int i=0;i<showfields2.size();i++){ 
													feilds = ((String[])showfields2.get(i));
													fieldname = feilds[1];
													showname = feilds[2];
													ismust = feilds[4];
													if(showname.equals("")) showname = feilds[0];
													if(("1".equals(ismust) || fieldname.equals("name")) && canedit) showname+="(必填)";
													if(fieldname.equals("cate")) hascate2 = true;
											%>
											<td id="column2_<%=fieldname %>" class="td_title2" _width="<%=feilds[3] %>"
												<%if(canedit&&i==0){ %> style="padding-left: 25px;"<%} %>>
												<%=showname %>
											</td>
											<%} %>
											<td width="2%"></td>
										</tr>
										<!-- <tr class="tr_show tr_blank"><td class="td_blank" colspan="<%=showfields2.size()+1%>"></td></tr>-->
										<%
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
										<tr id="tr2_<%=index2 %>" class="tr_data tr_show" _index="<%=index2 %>" _type="2">
											<td width="2%" class="td_index" valign="top" title="拖动调整排序"></td>
										<%
											for(int i=0;i<showfields2.size();i++){ 
												feilds = ((String[])showfields2.get(i));
												fieldname = feilds[1];
										%>
											<td valign="top" class="td2_<%=fieldname %>" <%if(canedit&&1==2){%>style="white-space: nowrap"<%} %>>
											<%if(canedit){%>
												<%if(i==0){ %><input class="icheck" type="checkbox" notBeauty="false" _index="<%=index2 %>" 
												/><%} %><%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){ %><textarea 
												class="area_txt input_txt <%if(i==0){ %>input_first<%} %>" id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>"><%=Util.convertDB2Input(rs.getString(fieldname)) %></textarea>
												<%}else if(fieldname.indexOf("date")>-1){//日期 %><button 
												type="button" class="Calendar Calendar_d" onclick="getMyDate('p_<%=fieldname %>_value_<%=index2 %>','p_<%=fieldname %>_span_<%=index2 %>')">
												</button><span id="p_<%=fieldname %>_span_<%=index2 %>" class="datespan" title="<%=Util.null2String(rs.getString(fieldname)) %>"><%=this.convertdate(rs.getString(fieldname)) %></span>
			              						<input type="hidden" id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>">
												<%}else{ %><input class="input_txt<%if(i==0){ %> input_first<%} %>" type="text" 
													id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"
													<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
													onkeypress="ItemNum_KeyPress('p_<%=fieldname %>_value_<%=index2 %>')" onblur="checknumber('p_<%=fieldname %>_value_<%=index2 %>')" maxlength="5" <%} %>
													<%if(fieldname.equals("cate")){%> onchange="seteditspan(2)" <%}%>
													<%if(fieldname.equals("name")||fieldname.equals("cate")){%> maxlength="100" <%} %>/>
												<%} %>
											<%}else{ %>
												<%if(fieldname.equals("cate")){ %><span><%=Util.toHtml(rs.getString(fieldname)) %></span>
												<%}else{ %><%=Util.toHtml(rs.getString(fieldname)) %><%} %>
												<input class="input_txt" type="hidden" id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
											<%} %>
											<%if(i==0){ %>
												<input type="hidden" id="p_id_value_<%=index2 %>" name="p_id_value_<%=index2 %>" value="<%=(!planid.equals(""))?Util.null2String(rs.getString("id")):"" %>"/>
												<input type="hidden" name="p_datatype_value_<%=index2 %>" value="2"/>
												<input type="hidden" class="value_index" name="p_showorder_value_<%=index2 %>" value=""/>
											<%} %>
											<%if(i==(showfields2.size()-1)){ %>
												<%	if(!fbdate.equals("") && !viewdate.equals("") && TimeUtil.dateInterval(viewdate,fbdate)>0){ %>
													<div id="fbnew_<%=index2 %>_2" class="newfb">new</div>
												<%	} %>
											<%} %>
											</td>
										<%	} %>
										<%
											for(int i=0;i<hidefields2.size();i++){ 
												feilds = ((String[])hidefields2.get(i));
												fieldname = feilds[1];
										%>
											<input type="hidden" id="p_<%=fieldname %>_value_<%=index2 %>" name="p_<%=fieldname %>_value_<%=index2 %>" value="<%=Util.null2String(rs.getString(fieldname)) %>"/>
										<%	} %>
										<td width="2%" class="opttd"><div class="optshow">&nbsp;</div></td>
										</tr>
										<%	index2++;} %>
									</table>
								</td>
							</tr>
						</table>
						<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="50%" valign="top">
									<div class="title_panel" style="margin-top: 20px;">
										<div class="tag3"></div>
										<div class="title_txt">相关附件</div>
									</div>
									<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="12px;"></td>
											<td width="*">
												<table class="maintable" cellspacing="0" cellpadding="0" border="0">
													<tr>
													<td style="white-space: normal;line-height: 180%;">
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
														<div style="width:auto;height: 30px;"><a href="javaScript:openFullWindowHaveBar('../util/ViewDoc.jsp?id=<%=fileidList.get(j) %>&planid=<%=planid %>')"><%=docImagefilename %></a>
														&nbsp;<a href='../util/ViewDoc.jsp?id=<%=fileidList.get(j) %>&planid=<%=planid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>&nbsp;
														&nbsp;<%=weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,2,(String)fileidList.get(j),planid,"") %>
														<%if(canedit){%>
														<input type="checkbox" notBeauty="false" onclick="onDeleteAcc(this,'<%=fileidList.get(j)%>')"/><U><%=linknum%></U>-删除
														<%} %>
														</div>
														<%		}
															}
														%>
													
														<%if(canedit){
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
															<input type="hidden" id="edit_relatedacc" name="edit_relatedacc" value="<%=fileids%>">
									     					<input type="hidden" id="delrelatedacc" name="delrelatedacc" value="">	
														<%}%>
													</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
								<td width="3%"></td>
								<td width="47%" valign="top">
								<%if(type1.equals("1") && isperformance){ 
									rs.executeSql("select 1 from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2 and ismonth=1");
									if(rs.next()){
								%>
									<div class="title_panel" style="margin-top: 20px;">
										<div class="tag3" style="background: #FF00FF"></div>
										<div class="title_txt">绩效考核</div>
									</div>
									<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="12px;"></td>
											<td width="*">
												<table class="maintable" cellspacing="0" cellpadding="0" border="0">
													<tr>
														<td style="white-space: normal;line-height: 180%;">
															<div style="color: #808080;line-height: 30px">
																<a href="javaScript:openFullWindowHaveBar('/performance/access/AccessView.jsp?year=<%=year %>&type1=1&type2=<%=type2 %>&resourceid=<%=resourceid %>')">
																<%=ResourceComInfo.getLastname(resourceid)%><%=year %>年<%=type2 %>月目标绩效考核</a>
															</div>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								<%	}
								  } 
								%>
								</td>
							</tr>
						</table>
						
						<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="50%" valign="top">
								<%if(!planid.equals("")){ %>
									<div class="title_panel">
										<div class="tag4"></div>
										<div class="title_txt" style="color: #808080;">意见反馈</div>
									</div>
									<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="12px;"></td>
											<td width="*">
												<table id="maintable2" class="maintable" cellspacing="0" cellpadding="0" border="0">
													<tr>
														<td>
														<div id="exchange" style="width: 100%;border-bottom: 1px #ECECEC solid;overflow: hidden;">
															<textarea id="content" name="content" class="content_blur" onfocus="contentFocus()" onblur="contentBlur()"></textarea>
															<div id="exchangebtn" class="btn btn_exchange" style="display: none;" onclick="saveExchange()">保存</div>
															<div id="exchangeload" style="height: 22px;display: none;"><img style="margin-top: 4px;margin-right: 2px;" src='../images/loading2.gif'/></div>
														</div>
														<%
															String operatedate = "";
															rs.executeSql("select operator,operatedate,operatetime,content from PR_PlanReportExchange where planid="+planid+" order by operatedate desc,operatetime desc,id desc");
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
													</tr>
												</table>
											</td>
										</tr>
									</table>
								<% 
									if(!shareids.equals("")){
										if(shareids.startsWith(",")) shareids = shareids.substring(1);
										if(shareids.endsWith(",")) shareids = shareids.substring(0,shareids.length()-1);
									}
									String sharenames = cmutil.getPerson(shareids);
								%>
									<div id="sharetitle" class="title_panel">
										<div class="tag6"></div>
										<div class="title_txt" style="color: #808080;">报告共享</div>
									</div>
									<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="12px;"></td>
											<td width="*">
											<%if(editshare){%>
												<div class="btn_browser" onclick="onShowMutiHrm('shareids','shareidsSpan')"></div>
												<div class="txt_browser" id="shareidsSpan"><%=sharenames %></div>
												<input type="hidden" id="shareids" name="shareids" value="<%=shareids %>"/>
											<%}else{ %>
												<%=sharenames %>
												<%if(sharenames.equals("")){ %><font style="color: #808080;font-style: italic;">无</font><%} %>
											<%} %>
											<%if(!pshareids.equals("")){ %>
												<div style="color: #717171;clear: both;line-height: 30px;">默认共享：<%=cmutil.getPerson(pshareids) %></div>
											<%} %>
											</td>
										</tr>
									</table>
								<%} %>
								</td>
								<td width="3%"></td>
								<td width="47%" valign="top">
								<%if(!planid.equals("")){ %>
									<div class="title_panel">
										<div class="tag5"></div>
										<div class="title_txt" style="color: #808080;">操作日志 </div>
									</div>
									<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="12px;"></td>
											<td width="*">
												<table id="maintable2" class="maintable" cellspacing="0" cellpadding="0" border="0">
													<tr>
														<td>
														<%
															rs.executeSql("select operator,operatedate,operatetime,operatetype from PR_PlanReportLog where operatetype<>0 and planid="+planid+" order by operatedate desc,operatetime desc,id desc");
															if(rs.getCounts()>0){
														%>
														<%		String logoperator = "";
																while(rs.next()){
																	logoperator = Util.null2String(rs.getString("operator"));
																	if(logoperator.equals("0")){
																		logoperator = "系统";
																	}else{
																		logoperator = cmutil.getPerson(logoperator);
																	}
														%>
															<div class="log_op" style="color: #808080;"><%=logoperator %>&nbsp;&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>&nbsp;&nbsp;&nbsp;<%=cmutil.getPlanOperateType(rs.getString("operatetype")) %>
															</div>
														<%		}
															}else{
														%>
															<font style="font-style: italic;color: #C3C3C3;">暂无</font>
														<%	}%>
														<div style="line-height:22px;font-style: italic;font-weight: normal;cursor: pointer;font-size: 12px;color: #A0A0A0;" onclick="showLog(this)" title="显示包括查看在内的所有日志记录">显示所有</div>
														<%
															int _pagesize = 10;
															int _total = 0;//总数
															rs.executeSql("select count(id) from PR_PlanReportLog where planid="+planid);
															if(rs.next()){
																_total = rs.getInt(1);
															}
														%>
															<div id="btnmore" style="cursor: pointer;width: 70px;height: 20px;line-height: 20px;margin-right: 0px;text-align: left;
																color: #696969;display: none;font-weight: bold;letter-spacing: 8px;padding-left: 2px;font-size: 14px;" 
																onclick="getMoreLog(this)" _currentpage="0" _pagesize="<%=_pagesize %>" _total="<%=_total %>" title="加载更多日志">...</div>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								<%} %>
								</td>
							</tr>
							<tr>
								<td width="100%" colspan="3" valign="top">
								
								</td>
							</tr>
						</table>
						<%} %>
						
						<div style="width: 100%;height: 10px;font-size: 0px;"></div>
						
						<div id="btn_panel" class="btn_panel" _index="0" _type="0">
							<div class="btn_opt btn_copy" style="display: none;" onclick="autoAddRow(this)" title="添加到工作计划"></div>
							<div class="btn_opt btn_insert" style="display: none;" onclick="insertRow(this)" title="插入一行数据"></div>
							<%if(createtask){ %><div class="btn_opt btn_create" onclick="createTask(this)" title="创建任务"></div><%} %>
							<div id="btn_detail" class="btn_opt btn_detail" onclick="showDetail(this)" title="查看明细"></div>
						</div>
					</td>
					<td></td>
				</tr>
			</table>
			<input type="hidden" id="index1" name="index1" value="<%=index1 %>" />
			<input type="hidden" id="index2" name="index2" value="<%=index2 %>" />
			<input type="hidden" id="showindex" name="showindex" value="<%=showindex %>" />
		</form>
		<div id="yearselect" class="yearselect">
		<% 
			int currentyear = Integer.parseInt(currentdate.substring(0,4));
			for(int i=2013;i<(currentyear+3);i++){ %>
			<div class="yearoption" _val="<%=i %>">&nbsp;&nbsp;&nbsp;<%=i %></div>
		<%	} %>
		</div>
		<div id="monthselect" class="weekselect">
			<%
				for(int i=1;i<13;i++){
			%>
				<div class="weekoption<%if(currentmonth==i){ %> weekoption_current<%} %><%if(inttype2==i){ %> weekoption_select<%} %>" <%if(inttype2!=i){ %> onclick="changeType2(<%=i%>)" style="cursor:pointer;" <%} %>><%=i %>月</div>
			<%	} %> 
		</div>
		<div id="weekselect" class="weekselect">
			<%
				for(int i=1;i<TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+1;i++){
			%>
				<div class="weekoption<%if(currentweek==i){ %> weekoption_current<%} %><%if(inttype2==i){ %> weekoption_select<%} %>" <%if(inttype2!=i){ %> onclick="changeType2(<%=i%>)" style="cursor:pointer;" <%} %>
				 title="<%=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(Integer.parseInt(year),i)) %> 至 <%=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(Integer.parseInt(year),i)) %>">第<%=i %>周</div>
			<%	} %> 
		</div>
		
		
		<div id="plandetail" style="width: 500px;height: 600px;position: absolute;top: 40px;right: 80px;display: none;background: #75ACEA">
			<iframe id="detailframe" class="scroll" style="width: 496px;height: 596px;margin: 2px" src="" scrolling="auto" frameborder="0"></iframe>
		</div>
		
		<%if(canedit){ %>
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
		<%} %>
		<script type="text/javascript" src="../js/tab.js"></script>  
		<script type="text/javascript">
			var loadstr = "<img src='../images/loading2.gif' align='absMiddle'/>";
			var itemMap = null;
			var rowindex = <%=index1%>;
			var rowindex2 = <%=index2%>;
			jQuery(document).ready(function(){
				<%if(isrefresh.equals("1")){%>
					refreshOpener();
				<%}%>
				<%if(msg.equals("")){%>
				jQuery("div.btn").bind("mouseover",function(){
					jQuery(this).addClass("btn_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_hover");
				});
				jQuery("div.btn_add").bind("mouseover",function(){
					jQuery(this).addClass("btn_add_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_add_hover");
				});
				jQuery("div.btn_del").bind("mouseover",function(){
					jQuery(this).addClass("btn_del_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_del_hover");
				});
				jQuery("div.cate_panel").bind("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("btn_add") && !$(target).hasClass("btn_del")){
						if(jQuery(this).attr("title")=="点击收缩"){
							jQuery(this).attr("title","点击展开");
							jQuery(this).children("div.cate_more").show();
							jQuery(this).find(".btn_con").hide();
							jQuery(this).next("table").hide();
						}else{
							jQuery(this).attr("title","点击收缩");
							jQuery(this).children("div.cate_more").hide();
							jQuery(this).find(".btn_con").show();
							jQuery(this).next("table").show();
						}
					}
				});
				jQuery("tr.header1").bind("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("btn_add") && !$(target).hasClass("btn_del")){
						var _tindex = jQuery(this).attr("_tindex");
						if(jQuery(this).attr("title")=="点击收缩"){
							jQuery(this).attr("title","点击展开");
							jQuery(this).find("span.head_more").show();
							jQuery(this).find(".btn_con").hide();
							jQuery("tr.tr_show"+_tindex+",tr.tr_none"+_tindex).hide();
						}else{
							jQuery(this).attr("title","点击收缩");
							jQuery(this).find("span.head_more").hide();
							jQuery(this).find(".btn_con").show();
							jQuery("tr.tr_show"+_tindex+",tr.tr_none"+_tindex).show();
						}
					}
				});

				<%if(canedit){%>
				jQuery(".input_txt").live("focus",function(){
					jQuery(this).addClass("input_txt_focus");
				}).live("blur",function(){
					jQuery(this).removeClass("input_txt_focus");
				});

				<%}%>
				
				setwidth(1);
				setwidth(2);
				setIndex(1);
				setIndex(2);

				<%if(canedit && canupload){%>
					bindUploaderDiv(jQuery("#edit_uploadDiv"),"newrelatedacc");
				<%}%>
				<%if(canedit){ %>
				bindarea();//绑定多行文本框自动伸缩事件
				//初始化编辑器
				CkeditorExt.initEditor("form1","remark","<%=user.getLanguage()%>","",150);
				<%if(index1==0){%>doAddRow1();doAddRow1();<%}%>
				<%if(index2==0){%>doAddRow2();doAddRow2();doAddRow2();<%}%>

				//拖动排序事件绑定
				$("#maintable1").dragsort({
					itemSelector: "tr.tr_show",
					dragSelector: "td.td_index", 
					dragBetween: false, 
					dragStart: function(){},
					dragEnd: function(){
						setIndex(1);
						<%if(hascate1){%>seteditspan(1);<%}%>
					},
					placeHolderTemplate: "<tr class='tr_data'><td colspan='<%=showfields1.size()+2%>'></td></tr>",
					scrollSpeed: 5
				});
				$("#maintable2").dragsort({
					itemSelector: "tr.tr_show",
					dragSelector: "td.td_index", 
					dragBetween: false, 
					dragStart: function(){},
					dragEnd: function(){
						setIndex(2);
						<%if(hascate2){%>seteditspan(2);<%}%>
					},
					placeHolderTemplate: "<tr class='tr_data'><td colspan='<%=showfields2.size()+2%>'></td></tr>",
					scrollSpeed: 5
				});

				<%if(hascate1){%>seteditspan(1);setrowspan(0);<%}%>
				<%if(hascate2){%>seteditspan(2);<%}%>
				
				<%}else{%>
				
				<%if(hascate1){%>setrowspan(1);<%}%>
				<%if(hascate2){%>setrowspan(2);<%}%>
				<%}%>

				jQuery("#btn_panel").bind("mouseenter",function(){
					jQuery(this).show();
					var _index = jQuery(this).attr("_index");
					var _type = jQuery(this).attr("_type");
					jQuery("#tr"+_type+"_"+_index).addClass("tr_data_hover");
				}).bind("mouseleave",function(){
					jQuery(this).hide();
					var _index = jQuery(this).attr("_index");
					var _type = jQuery(this).attr("_type");
					jQuery("#tr"+_type+"_"+_index).removeClass("tr_data_hover");
				});
				jQuery("tr.tr_data").live("mouseenter",function(){
					jQuery(this).addClass("tr_data_hover");
					<%if(canedit){%>jQuery(this).find(".input_txt").addClass("input_txt_hover");jQuery(this).find("button.Calendar").removeClass("Calendar_d");<%}%>
				}).live("mouseleave",function(){
					jQuery(this).removeClass("tr_data_hover");
					<%if(canedit){%>jQuery(this).find(".input_txt").removeClass("input_txt_hover");jQuery(this).find("button.Calendar").addClass("Calendar_d");<%}%>
				});
				$(".optshow").live("mouseenter",function(){
					var h = jQuery(this).parent().parent().height();
					if(h>39){
					   jQuery("#btn_panel").height(39);
					   $(".btn_opt").height(39);
					}else{
					   jQuery("#btn_panel").height(h);
					   $(".btn_opt").height(h);
					}
					var t = jQuery(this).parent().parent().offset().top + h -1 -jQuery("#btn_panel").height();
					var _index = jQuery(this).parent().parent().attr("_index");
					var _type = jQuery(this).parent().parent().attr("_type");
					<%if(canedit){%>
					//控制添加到工作计划按钮是否显示
					if(_type==1){
						jQuery("div.btn_copy").show();
					}else{
						jQuery("div.btn_copy").hide();
					}
					//控制插入一行数据按钮是否显示
					if(jQuery(this).parent().parent().hasClass("tr_show")){
						jQuery("div.btn_insert").show();
					}else{
						jQuery("div.btn_insert").hide();
					}
					<%}%>
					if(jQuery(this).parent().parent().find("div.newfb").length>0){
						jQuery("#btn_detail").addClass("btn_detail_new").attr("title","有新反馈");
					}else{
						jQuery("#btn_detail").removeClass("btn_detail_new").attr("title","查看明细");
					}
					jQuery("#btn_panel").attr("_index",_index).attr("_type",_type).css({"top":t}).show();
				}).live("mouseleave",function(){
					jQuery("#btn_panel").hide();
				});
				<%}%>
			});
			jQuery(document).bind("click",function(e){
				var target=$.event.fix(e).target;
				if($(target).attr("id")!="plandetail" && $(target).attr("id")!="btn_detail" && $(target).parents("#plandetail").length==0){
					closeDetail();
				}
			});
			jQuery(window).scroll(function(){
				var t = jQuery(document).scrollTop()+40;
				jQuery("#plandetail").css("top",t);
			});
			
			function setrowspan(index){
				var s = null;
                var prevTd = null;
                var trobjs = null;
                if(index==0){
                	trobjs = $("tr.tr_show0");
                	index = 1;
                	//alert(trobjs.length);
                }else{
                	trobjs = $("#maintable"+index).find('tr');
                }
                trobjs.each(function() {
                    var td = $(this).find("td.td"+index+"_cate");
                    if(td.length>0){
                    	var s1 = td.text();
                        if (s1 == s) { //相同即执行合并操作
                            //td.hide(); //hide() 隐藏相同的td ,remove()会让表格错位 此处用hide
                            td.children("span").html("");
                            prevTd.addClass("td_spancate").parent("tr").find("td.td_index").addClass("td_index_span");
                            //prevTd.addClass("td_spancate");//.attr('rowspan', prevTd.attr('rowspan') ? parseInt(prevTd.attr('rowspan')) + 1 : 2); //赋值rowspan属性
                        }
                        else {
                            s = s1;
                        }
                        prevTd = td;
                    }else{
						s = null;
						prevTd = null;
                    }
                });
			}
			function setwidth(type){
				var sumwidth = 0;
				var sumrate = 0;
				var lastid = "";
				var lastrate = 0;
				var columns = jQuery("td.td_title"+type).length;
				jQuery("td.td_title"+type).each(function(){
					sumwidth += getFloatVal(jQuery(this).attr("_width"));
				});
				for(var i=0;i<columns;i++){
					var tdobj = jQuery("td.td_title"+type).eq(i);
					var cwidth = getFloatVal(tdobj.attr("_width"));
					var rate = 0;
					if(sumwidth!=0) rate = (getFloatVal(cwidth/sumwidth*100)).toFixed(0);
					sumrate += getIntVal(rate);
					lastid = tdobj.attr("id");
					lastrate = getIntVal(rate);
					jQuery(tdobj).attr("width",(rate+"%"));
				}
				lastrate = 96 - (sumrate-lastrate);
				jQuery("#"+lastid).attr("width",lastrate+"%");
			}
			<%if(canedit){%>
			function seteditspan(index){
                var s = null;
                $("#maintable"+index).find('tr').each(function() {
                    var td = $(this).find("td.td"+index+"_cate");
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
			      alertStyle("请填写:标题不为空计划数据的必填项!");
			      return false;
			    }
				if(checkMust()){
				    confirmStyle("提示：未填写标题的明细项将不会保存，确定继续执行操作？",function(){
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
			         });
				}else{
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
			}
			function doSubmit(obj) {
			    if(checkIsMust()){
			      alertStyle("请填写:标题不为空计划数据的必填项!");
			      return false;
			    }
			    confirmStyle("确定提交工作总结?",function(){
			      if(checkMust()){
			        confirmStyle("提示：未填写标题的明细项将不会保存，确定继续执行操作？",function(){
			           jQuery("#operation").val("submit");
					   //obj.disabled = true;
					   showload(obj);
					   <%if(canupload){%>
						 submitform();
					   <%}else{%>
						 doSaveAfterAccUpload();
					   <%}%>
			        });
			      }else{
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
				return noname;
			}
			function checkIsMust(){
			   var _flag = false;
			   $("#maintable1").find("tr.tr_must").each(function(){
			        if(_flag){
			           return false;
			        }
					var _index = $(this).attr("_index");
					var _names = $(this).find("#s_name_value_"+_index);
					<%
					for(int i=0;i<showfields1.size();i++){
						feilds = ((String[])showfields1.get(i));
						fieldname = feilds[1];
						ismust = feilds[4];
					%>
					    if(_names.length>0 && _names.val()!="" && <%=ismust%>==1){
					        var _obj = $(this).find("#s_"+"<%=fieldname%>"+"_value_"+_index);
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
					var _names = $(this).find("#p_name_value_"+_index);
					<%
					for(int i=0;i<showfields2.size();i++){
						feilds = ((String[])showfields2.get(i));
						fieldname = feilds[1];
						ismust = feilds[4];
					%>
					    if(_names.length>0 && _names.val()!="" && <%=ismust%>==1){
					        var _obj = $(this).find("#p_"+"<%=fieldname%>"+"_value_"+_index);
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
				/**
				var areaobjs = null;
				if(getVal(trid)!=""){
					areaobjs = jQuery("#"+trid).find(".area_txt");
				}else{
					areaobjs = jQuery(".area_txt");
				}
				if(areaobjs.length>0){
					areaobjs.autogrow({
				    	minLines: 1,
						lineHeight: 24,
						overflow: 'hidden',
						restore: false
				    });
				}*/

				var areaobjs = null;
				if(getVal(trid)!=""){
					areaobjs = jQuery("#"+trid).find(".area_txt");
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
				var trstr = "<tr id=\"tr1_"+rowindex+"\" class=\"tr_data tr_must tr_show tr_show1\" _index=\""+rowindex+"\" _type='1'>";
				trstr += "<td width='2%' class='td_index' valign=\"top\" title=\"拖动调整排序\"></td>"
			<%
				for(int i=0;i<showfields1.size();i++){ 
					feilds = ((String[])showfields1.get(i));
					fieldname = feilds[1];
			%>
				trstr += "<td valign=\"top\" class=\"td1_<%=fieldname %>\">"
			<%if(i==0){%>
				trstr += "<input class=\"icheck\" type=\"checkbox\" notBeauty=\"false\" _index=\""+rowindex+"\" />";
				trstr += "<input type=\"hidden\" id=\"s_id_value_"+rowindex+"\" name=\"s_id_value_"+rowindex+"\" value=\"\"/>";
				trstr += "<input type=\"hidden\" name=\"s_datatype_value_"+rowindex+"\" value=\"3\"/>";
				trstr += "<input type=\"hidden\" class=\"value_index\" name=\"s_showorder_value_"+rowindex+"\" value=\"\"/>";
			<%}%>
			<%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){ %>
				trstr += "<textarea class=\"area_txt input_txt <%if(i==0){ %>input_first<%} %>\" id=\"s_<%=fieldname %>_value_"+rowindex+"\" name=\"s_<%=fieldname %>_value_"+rowindex+"\"></textarea>";
			<%}else if(fieldname.indexOf("date")>-1){//日期 %>
				trstr += "<button type=\"button\" class=\"Calendar Calendar_d\" onclick=\"getMyDate('s_<%=fieldname %>_value_"+rowindex+"','s_<%=fieldname %>_span_"+rowindex+"')\"></button>";
				trstr += "<span id=\"s_<%=fieldname %>_span_"+rowindex+"\" class=\"datespan\"></span>";
				trstr += "<input type=\"hidden\" id=\"s_<%=fieldname %>_value_"+rowindex+"\" name=\"s_<%=fieldname %>_value_"+rowindex+"\" value=\"\">";
			<%}else{%>
				trstr += "<input class=\"input_txt <%if(i==0){%>input_first<%}%>\"  type=\"text\" id=\"s_<%=fieldname %>_value_"+rowindex+"\" name=\"s_<%=fieldname %>_value_"+rowindex+"\" ";
				<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
				trstr += " onkeypress=\"ItemNum_KeyPress('s_<%=fieldname %>_value_"+rowindex+"')\" onblur=\"checknumber('s_<%=fieldname %>_value_"+rowindex+"')\" maxlength=\"5\"";
				<%} %>
				<%if(fieldname.equals("cate")){%>
				//分类字段会自动引用前一行数据的分类
				var catevalue = "";
				if(getVal(insertindex)!=""){
					catevalue = jQuery("#s_cate_value_"+insertindex).val();
				}else{
					if(jQuery("#maintable1").find("tr.tr_show").length>0){
						var lastindex = jQuery("#maintable1").find("tr.tr_show:last").attr("_index");
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
				trstr += "</td>";
			<%	} %>
				trstr +="<td width=\"2%\" class=\"opttd\"><div class=\"optshow\">&nbsp;</div></td>";
				trstr +="</tr>";
					
				if(getVal(insertindex)!=""){
					jQuery("#tr1_"+insertindex).after(trstr);
				}else{
					jQuery("#maintable1").append(trstr);
				}
				bindarea("tr1_"+rowindex);
				rowindex = rowindex*1.0+1;
				jQuery("#index1").val(rowindex);
				setIndex(1);
				<%if(hascate1){%>seteditspan(1);<%}%>
			}
			//删除计划外工作总结
			function doDelRow1(){
				var checks = jQuery("#maintable1").find("input:checked");
				if(checks.length>0){
				    confirmStyle("确定删除选择明细项?",function(){
				      checks.each(function(){
							var _index = jQuery(this).attr("_index");
							jQuery("#tr1_"+_index).remove();
						});
						setIndex(1);
				    });
				}else{
					alertStyle("请选择删除项!");
				}
			}
			//添加工作计划
			function doAddRow2(insertindex){
				var fieldval = "";
				var trstr = "<tr id=\"tr2_"+rowindex2+"\" class=\"tr_data tr_show\" _index=\""+rowindex2+"\" _type='2'>";
				trstr += "<td width='2%' class='td_index' valign=\"top\" title=\"拖动调整排序\"></td>"
			<%
				for(int i=0;i<showfields2.size();i++){ 
					feilds = ((String[])showfields2.get(i));
					fieldname = feilds[1];
			%>
				fieldval = "";
				if(itemMap!=null) fieldval = getVal(itemMap.get("<%=fieldname%>"));
				trstr += "<td valign=\"top\" class=\"td2_<%=fieldname %>\">"
			<%if(i==0){%>
				trstr += "<input class=\"icheck\" type=\"checkbox\" notBeauty=\"false\" _index=\""+rowindex2+"\" />";
				trstr += "<input type=\"hidden\" id=\"p_id_value_"+rowindex2+"\" name=\"p_id_value_"+rowindex2+"\" value=\"\"/>";
				trstr += "<input type=\"hidden\" name=\"p_datatype_value_"+rowindex2+"\" value=\"2\"/>";
				trstr += "<input type=\"hidden\" class=\"value_index\" name=\"p_showorder_value_"+rowindex2+"\" value=\"\"/>";
			<%}%>
			<%if(fieldname.equals("name")||fieldname.equals("target")||fieldname.equals("result")||fieldname.startsWith("custom")){ %>
				trstr += "<textarea class=\"area_txt input_txt <%if(i==0){ %>input_first<%} %>\" id=\"p_<%=fieldname %>_value_"+rowindex2+"\" name=\"p_<%=fieldname %>_value_"+rowindex2+"\">"+fieldval+"</textarea>";
			<%}else if(fieldname.indexOf("date")>-1){//日期 %>
				trstr += "<button type=\"button\" class=\"Calendar Calendar_d\" onclick=\"getMyDate('p_<%=fieldname %>_value_"+rowindex2+"','p_<%=fieldname %>_span_"+rowindex2+"')\"></button>";
				trstr += "<span id=\"p_<%=fieldname %>_span_"+rowindex2+"\" class=\"datespan\">"+fieldval+"</span>";
				trstr += "<input type=\"hidden\" id=\"p_<%=fieldname %>_value_"+rowindex2+"\" name=\"p_<%=fieldname %>_value_"+rowindex2+"\" value=\""+fieldval+"\">";
			
			<%}else{%>
				trstr += "<input class=\"input_txt <%if(i==0){%>input_first<%}%>\" type=\"text\" id=\"p_<%=fieldname %>_value_"+rowindex2+"\" name=\"p_<%=fieldname %>_value_"+rowindex2+"\"";
				<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
				trstr += " onkeypress=\"ItemNum_KeyPress('p_<%=fieldname %>_value_"+rowindex2+"')\" onblur=\"checknumber('p_<%=fieldname %>_value_"+rowindex2+"')\" maxlength=\"5\"";
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
				trstr += "</td>";
			<%	} %>
			    trstr +="<td width=\"2%\" class=\"opttd\"><div class=\"optshow\">&nbsp;</div></td>";
				trstr +="</tr>";
					
				if(getVal(insertindex)!=""){
					jQuery("#tr2_"+insertindex).after(trstr);
				}else{
					jQuery("#maintable2").append(trstr);
				}
				bindarea("tr2_"+rowindex2);
				rowindex2 = rowindex2*1.0+1;
				jQuery("#index2").val(rowindex2);
				itemMap = null;
				setIndex(2);
				<%if(hascate2){%>seteditspan(2);<%}%>
			}
			//删除工作计划
			function doDelRow2(){
				var checks = jQuery("#maintable2").find("input:checked");
				if(checks.length>0){
				    confirmStyle("确定删除选择明细项?",function(){
				      checks.each(function(){
							var _index = jQuery(this).attr("_index");
							jQuery("#tr2_"+_index).remove();
						});
						setIndex(2);
				    });
				}else{
					alertStyle("请选择删除项!");
				}
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
			<%}%>
			<%if(canaudit){ %>
			function doApprove(obj) {
			    confirmStyle("确定批准此计划报告?",function(){
				    jQuery("#operation").val("approve");
					showload(obj);
					jQuery("#form1").submit();
				});
			}
			function doReturn(obj) {
			    confirmStyle("确定退回此计划报告?",function(){
				    jQuery("#operation").val("return");
					showload(obj);
					jQuery("#form1").submit();
				});
			}
			<%}%>
			<%if(canreset){ %>
			function doReset(obj){
			    confirmStyle("确定重新编写总结计划?",function(){
				    jQuery("#operation").val("reset");
					showload(obj);
					jQuery("#form1").submit();
				});
			}
			<%}%>
			<%if(candel){ %>
			function doDel(obj){
			    confirmStyle("确定删除此总结计划?",function(){
				    jQuery("#operation").val("delete");
					showload(obj);
					jQuery("#form1").submit();
				});
			}
			<%}%>
			function changeYear(year){
				window.location = "PlanView.jsp?resourceid=<%=resourceid%>&year="+year+"&type1=<%=type1%>&type2=<%=type2%>";
			}
			function changeType(type){
				window.location = "PlanView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1="+type;
			}
			function changeType2(type){
				window.location = "PlanView.jsp?resourceid=<%=resourceid%>&year=<%=year%>&type1=<%=type1%>&type2="+type;
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
					    url: "PlanOperation.jsp",
					    data:{"operation":"add_exchange","planid":"<%=planid%>","content":filter(encodeURIComponent(jQuery("#content").val()))}, 
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
			function showDetail(obj){
				var index = jQuery(obj).parent().attr("_index");
				var type = jQuery(obj).parent().attr("_type");
				showDetail2(index,type);
			}
			function showDetail2(index,type){
				var detailid_id = "s_id_value_"+index;
				if(type==2) detailid_id = "p_id_value_"+index;
				var detailid = getVal(jQuery("#"+detailid_id).val());
				if(detailid==""){
					savedetail(index,type);
				}else{
					<%if(canedit){%>
					savedetail(index,type,2,detailid);
					<%}else{%>
					openDetail(index,type,detailid);
					<%}%>
				}
			}
			function openDetail(index,type,detailid){
				var viewdate = "";
				if(jQuery("#fbnew_"+index+"_"+type).length>0){
					jQuery("#fbnew_"+index+"_"+type).remove();
					viewdate = "<%=viewdate%>";
				}
				var h = jQuery(window).height()-100;
				jQuery("#detailframe").height(h-4).attr("src","/workrelate/plan/data/DetailView.jsp?viewdate="+viewdate+"&fromplan=1&parentindex="+index+"&parenttype="+type+"&plandetailid="+detailid+"&"+new Date().getTime());
				jQuery("#plandetail").height(h).show();
				jQuery("body").css("overflow","hidden");
			}
			function closeDetail(){
				jQuery("#plandetail").hide();
				jQuery("#detailframe").attr("src","");
				jQuery("body").css("overflow","");
			}
			// 设置序号
			function setIndex(tableindex){
				var index=1;
				if(tableindex==2){
					jQuery("#maintable2").find("tr.tr_show").each(function(){
						if(!jQuery(this).hasClass("tr_blank")){
							jQuery(this).find("td.td_index").html(index);
							jQuery(this).find("input.value_index").val(index);
							index++;
						}
					});
				}else{
					jQuery("#maintable1").find("tr.tr_show0").each(function(){
						if(!jQuery(this).hasClass("tr_blank")){
							jQuery(this).find("td.td_index").html(index);
							jQuery(this).find("input.value_index").val(index);
							index++;
						}
					});
					index=1;
					jQuery("#maintable1").find("tr.tr_show1").each(function(){
						if(!jQuery(this).hasClass("tr_blank")){
							jQuery(this).find("td.td_index").html(index);
							jQuery(this).find("input.value_index").val(index);
							index++;
						}
					});
				}
				
			}

			function createTask(obj){
				var index = jQuery(obj).parent().attr("_index");
				var type = jQuery(obj).parent().attr("_type");
				var name = getVal(jQuery("#"+((type==1)?"s":"p")+"_name_value_"+index).val());
				if(name==""){
					alertStyle("请填写标题！");
					return;
				} 
				confirmStyle("确定创建任务？",function(){
				    var detailid_id = "s_id_value_"+index;
					if(type==2) detailid_id = "p_id_value_"+index;
					var detailid = getVal(jQuery("#"+detailid_id).val());
					if(detailid==""){
						savedetail(index,type);
					}else{
						saveTask(index,type);
					}
				});
			}
			function saveTask(index,type){
				var begindate = "";
				var enddate = "";
				var tag = "s";
				var detailid_id = "s_id_value_"+index;
				if(type==1){
					begindate = getVal(jQuery("#s_begindate2_value_"+index).val());
					enddate = getVal(jQuery("#s_enddate2_value_"+index).val());
				}else{
					tag = "p";
					detailid_id = "p_id_value_"+index;
					begindate = getVal(jQuery("#p_begindate1_value_"+index).val());
					enddate = getVal(jQuery("#p_enddate1_value_"+index).val());
				}
				var detailid = getVal(jQuery("#"+detailid_id).val());
				jQuery.ajax({
					type: "post",
				    url: "/workrelate/task/data/Operation.jsp",
				    data:{"operation":"add","plandetailid":detailid,"principalid":"<%=resourceid%>"
				    	,"taskName":getsaveval(jQuery("#"+tag+"_name_value_"+index).val())
				    	,"begindate":begindate
				    	,"enddate":enddate
				    }, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    if(txt!=""){
					    	var taskid = txt.split("$")[0];
					    	showTask(taskid);
						}
					}
			    });
			}

			<%if(canedit){%>
			//保存明细信息
			function savedetail(index,type,callback,detailid){
				var _detailid = getVal(detailid);
				var operation = "save_detail";
				if(callback==2) operation = "edit_detail";
				var tag = "s";
				if(type==2) tag = "p";
				jQuery.ajax({
					type: "post",
				    url: "/workrelate/plan/data/Operation.jsp",
				    data:{"operation":operation,"planid":"<%=planid%>","type":type,"resourceid":"<%=resourceid%>","plandetailid":_detailid
				    	,"name":getsaveval(jQuery("#"+tag+"_name_value_"+index).val())
				    	,"cate":getsaveval(jQuery("#"+tag+"_cate_value_"+index).val())
				    	,"begindate1":getsaveval(jQuery("#"+tag+"_begindate1_value_"+index).val())
				    	,"enddate1":getsaveval(jQuery("#"+tag+"_enddate1_value_"+index).val())
				    	,"begindate2":getsaveval(jQuery("#"+tag+"_begindate2_value_"+index).val())
				    	,"enddate2":getsaveval(jQuery("#"+tag+"_enddate2_value_"+index).val())
				    	,"days1":getsaveval(jQuery("#"+tag+"_days1_value_"+index).val())
				    	,"target":getsaveval(jQuery("#"+tag+"_target_value_"+index).val())
				    	,"begindate2":getsaveval(jQuery("#"+tag+"_begindate2_value_"+index).val())
				    	,"enddate2":getsaveval(jQuery("#"+tag+"_enddate2_value_"+index).val())
				    	,"days2":getsaveval(jQuery("#"+tag+"_days2_value_"+index).val())
				    	,"finishrate":getsaveval(jQuery("#"+tag+"_finishrate_value_"+index).val())
				    	,"result":getsaveval(jQuery("#"+tag+"_result_value_"+index).val())
				    	,"custom1":getsaveval(jQuery("#"+tag+"_custom1_value_"+index).val())
				    	,"custom2":getsaveval(jQuery("#"+tag+"_custom2_value_"+index).val())
				    	,"custom3":getsaveval(jQuery("#"+tag+"_custom3_value_"+index).val())
				    	,"custom4":getsaveval(jQuery("#"+tag+"_custom4_value_"+index).val())
				    	,"custom5":getsaveval(jQuery("#"+tag+"_custom5_value_"+index).val())
				    }, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    _detailid = txt;
					    //alert(_detailid);
					    jQuery("#"+tag+"_id_value_"+index).val(txt);
				    	if(callback==1){
				    		saveTask(index,type);
					    }else{
					    	openDetail(index,type,_detailid);
					    	//showDetail2(index,type);
						}	
					}
			    });
			}

			function getMyDate(inputname,spanname){
			    WdatePicker({el:spanname,onpicked:function(dp){
					var returnvalue = dp.cal.getDateStr();
					var spanvalue = returnvalue.substring(5).replace("-",".");
					jQuery("#"+spanname).html(spanvalue).attr("title",returnvalue);
					$dp.$(inputname).value = returnvalue;
					checkMyDate(inputname);
				},oncleared:function(dp){$dp.$(inputname).value = ''}});
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
							alertStyle("结束日期不能小于开始日期！");
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
							alertStyle("结束日期不能小于开始日期！");
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
				    url: "/workrelate/plan/data/Operation.jsp",
				    data:{"operation":"get_more_log","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"planid":"<%=planid%>"}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
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
			<%if(editshare){%>
			function doShare(){
				var t = jQuery("#sharetitle").offset().top;
				jQuery('html, body').scrollTop(t);
				onShowMutiHrm('shareids','shareidsSpan');
			}
			function onShowMutiHrm(inputid,inputspan) {
				var resourceids = $("#"+inputid).val();
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
				    diag.Title = "选择共享人员";
					diag.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+resourceids;
					diag.Width = 660;
					diag.Height = 600;
					diag.callback=function(datas){
					  if (datas) {
				    	confirmStyle("确定保存共享设置？",function(){
				        jQuery.ajax({
							type: "post",
						    url: "PlanOperation.jsp",
						    data:{"operation":"set_share","planid":"<%=planid%>","shareids":datas.id}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){ 
						    	if(datas.id!=""){
						    		$("#"+inputid).val(datas.id);
								    //$("#"+inputspan).html(datas.name.substring(1));
								    var ids = datas.id.split(",");
								    var names = datas.name.split(",");
								    var showname = "";
								    for(var i=0;i<ids.length;i++){
									    if(ids[i]!="") showname += "<a href='javaScript:openhrm("+ids[i]+ ");' onclick='pointerXY(event);'>"+names[i]+"</a> ";
									}
								    $("#"+inputspan).html(showname);
								}else{
									$("#"+inputid).val("");
								    $("#"+inputspan).html("");
								}

						    	var txt = $.trim(data.responseText);
						    	jQuery("div.log_op:first").before(txt);
							}
					    });
				      });
				      }
					};
					diag.show();
			}

			<%}%>
		</script>
	</BODY>
</HTML>
<%@ include file="/workrelate/plan/util/uploader.jsp" %>
<%!
	private String convertdate(String datestr){
		datestr = Util.null2String(datestr);
		if(datestr.length()==10){
			datestr = datestr.substring(5).replace("-",".");
		}
		return datestr;
	}
%>