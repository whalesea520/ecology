<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
if("FnaSystemSetEditInner".equals(operation)){//来自财务设置页面的保存请求
	if(!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int fnaBudgetOAOrg = Util.getIntValue(request.getParameter("fnaBudgetOAOrg"),0);
	int fnaBudgetCostCenter = Util.getIntValue(request.getParameter("fnaBudgetCostCenter"),0);
	int enableGlobalFnaCtrl = Util.getIntValue(request.getParameter("enableGlobalFnaCtrl"),0);
	String alertvalue = Util.null2String(request.getParameter("alertvalue")).trim();
	String agreegap = Util.null2String(request.getParameter("agreegap")).trim();
	int showHiddenSubject = Util.getIntValue(request.getParameter("showHiddenSubject"),0);
	int cancelFnaEditCheck = Util.getIntValue(request.getParameter("cancelFnaEditCheck"),0);
	int enableRuleSet = Util.getIntValue(request.getParameter("enableRuleSet"),0);
	int wfForceOverLogic = Util.getIntValue(request.getParameter("wfForceOverLogic"),0);
	int recursiveSubOrg = Util.getIntValue(request.getParameter("recursiveSubOrg"),0);
	int fnaWfSysWf = Util.getIntValue(request.getParameter("fnaWfSysWf"),0);
	int fnaWfCustom = Util.getIntValue(request.getParameter("fnaWfCustom"),0);
	int subjectFilter = Util.getIntValue(request.getParameter("subjectFilter"),0);
	int subjectBrowseDefExpanded = Util.getIntValue(request.getParameter("subjectBrowseDefExpanded"),0);//单科目浏览框默认展开
	int enableRptCtrl = Util.getIntValue(request.getParameter("enableRptCtrl"),0);//启用报表权限控制
	int cancelBudgetPeriodCheck = Util.getIntValue(request.getParameter("cancelBudgetPeriodCheck"),0);
	int cancelCostLimitedCheck = Util.getIntValue(request.getParameter("cancelCostLimitedCheck"),0);
	int subjectCodeUniqueCtrl = Util.getIntValue(request.getParameter("subjectCodeUniqueCtrl"),0);//科目编码校验规则（预算科目编码）
	int subjectCodeUniqueCtrl2 = Util.getIntValue(request.getParameter("subjectCodeUniqueCtrl2"),0);//科目编码校验规则（会计科目编码）
	if(subjectFilter!=1){
		if(subjectCodeUniqueCtrl==2 || subjectCodeUniqueCtrl==3){//按科目应用范围唯一（分部级/部门级）
			subjectCodeUniqueCtrl = 0;//全局唯一
		}
		if(subjectCodeUniqueCtrl2==2 || subjectCodeUniqueCtrl2==3){//按科目应用范围唯一（分部级/部门级）
			subjectCodeUniqueCtrl2 = 0;//全局唯一
		}
	}

	int ifbottomtotop = 0;
	int budgetControlType = 0;//1:下级独立预算;
	int budgetControlType1 = 1;//1:不允许费用超标;2:允许费用超标;
	int budgetControlType2 = 0;//1:开启上下级独立预算;

	int budgetCtrlType = Util.getIntValue(request.getParameter("budgetCtrlType"),1);
	if(budgetCtrlType==1){//1：上下级独立编制；
		budgetControlType2 = 1;
	}else if(budgetCtrlType==2){//2：下级独立编制；
		budgetControlType = 1;
		budgetControlType1 = Util.getIntValue(request.getParameter("budgetControlType1"),1);//1:不允许费用超标;2:允许费用超标;
	}else if(budgetCtrlType==3){//3：自下而上编辑预算；
		ifbottomtotop = 1;
	}else{//0：无效果；
	}
	
	if(enableGlobalFnaCtrl == 0){
		cancelBudgetPeriodCheck = 0;
		cancelCostLimitedCheck = 0;
	}
	
	int fnaBackgroundValidator = Util.getIntValue(request.getParameter("fnaBackgroundValidator"),0);
	
	int enableDispalyAll = Util.getIntValue(request.getParameter("enableDispalyAll"),0);
	String separator = Util.null2String(request.getParameter("separator"));
	
	if(Util.getIntValue(alertvalue, -987654) == -987654){
		alertvalue = "NULL";
	}
	if(Util.getIntValue(agreegap, -987654) == -987654){
		agreegap = "NULL";
	}
	
	String separator_colName = "separator";
	if("mysql".equalsIgnoreCase(rs.getDBType())){
		separator_colName = "`separator`";
	}
	
	rs.executeSql("select * from FnaSystemSet where id = 1");
	if(rs.next()){
		rs.executeSql("update FnaSystemSet "+
				" set ifbottomtotop="+ifbottomtotop+", "+
				" enableGlobalFnaCtrl="+enableGlobalFnaCtrl+", "+
				" alertvalue="+alertvalue+", "+
				" agreegap="+agreegap+", "+
				" showHiddenSubject='"+showHiddenSubject+"', "+
				" cancelFnaEditCheck="+cancelFnaEditCheck+", "+
				" enableRuleSet="+enableRuleSet+", "+
				" fnaBudgetOAOrg="+fnaBudgetOAOrg+", "+
				" fnaBudgetCostCenter="+fnaBudgetCostCenter+", "+
				" wfForceOverLogic="+wfForceOverLogic+", "+
				" recursiveSubOrg="+recursiveSubOrg+", "+
				" fnaWfSysWf="+fnaWfSysWf+", "+
				" fnaWfCustom="+fnaWfCustom+", "+
				" subjectFilter="+subjectFilter+", "+
				" budgetControlType="+budgetControlType+", "+
				" budgetControlType1="+budgetControlType1+", "+
				" budgetControlType2="+budgetControlType2+", "+
				" enableDispalyAll="+enableDispalyAll+", "+
				" "+separator_colName+"='"+StringEscapeUtils.escapeSql(separator)+"', "+
				" subjectBrowseDefExpanded="+subjectBrowseDefExpanded+", "+
				" enableRptCtrl="+enableRptCtrl+", "+
				" fnaBackgroundValidator="+fnaBackgroundValidator+", "+
				" cancelBudgetPeriodCheck="+cancelBudgetPeriodCheck+", "+
				" subjectCodeUniqueCtrl="+subjectCodeUniqueCtrl+", "+
				" subjectCodeUniqueCtrl2="+subjectCodeUniqueCtrl2+", "+
				" cancelCostLimitedCheck="+cancelCostLimitedCheck+" "+ 
				" where id = 1");
		
	}else{
		rs.executeSql("insert into FnaSystemSet (id, ifbottomtotop, enableGlobalFnaCtrl, alertvalue, agreegap, "+
			" showHiddenSubject, cancelFnaEditCheck, enableRuleSet, fnaBudgetOAOrg, fnaBudgetCostCenter, wfForceOverLogic, recursiveSubOrg, "+
			" fnaWfSysWf, fnaWfCustom, subjectFilter, budgetControlType, budgetControlType1, budgetControlType2, enableDispalyAll, "+separator_colName+", "+
			" subjectBrowseDefExpanded, enableRptCtrl, fnaBackgroundValidator,cancelBudgetPeriodCheck,subjectCodeUniqueCtrl,subjectCodeUniqueCtrl2,cancelCostLimitedCheck) "+
		" values (1,"+ifbottomtotop+", "+enableGlobalFnaCtrl+", "+alertvalue+", "+agreegap+", "+
			" '"+showHiddenSubject+"', "+cancelFnaEditCheck+", "+enableRuleSet+", "+fnaBudgetOAOrg+", "+fnaBudgetCostCenter+", "+wfForceOverLogic+", "+recursiveSubOrg+", "+
			" "+fnaWfSysWf+", "+fnaWfCustom+", "+subjectFilter+", "+budgetControlType+", "+budgetControlType1+", "+budgetControlType2+", "+enableDispalyAll+", '"+StringEscapeUtils.escapeSql(separator)+"', "+
			" "+subjectBrowseDefExpanded+", "+enableRptCtrl+", "+fnaBackgroundValidator+", "+cancelBudgetPeriodCheck+", "+subjectCodeUniqueCtrl+", "+subjectCodeUniqueCtrl2+", "+cancelCostLimitedCheck+")");
		
	}
	new FnaSystemSetComInfo().removeFnaSystemSetCache();
	response.sendRedirect("/fna/budget/FnaSystemSetEditInner.jsp");
	
}else if("FnaJzSetInner".equals(operation)){//来自预算结转页面的保存请求
	if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int ifbudgetmove = Util.getIntValue(request.getParameter("ifbudgetmove"),0);
	int mBudgetMove = Util.getIntValue(request.getParameter("mBudgetMove"),0);
	int qBudgetMove = Util.getIntValue(request.getParameter("qBudgetMove"),0);
	int hBudgetMove = Util.getIntValue(request.getParameter("hBudgetMove"),0);
	String movetypes = mBudgetMove+","+qBudgetMove+","+hBudgetMove;
	if(ifbudgetmove!=1){
		movetypes = 0+","+0+","+0;
	}
	int budgetAutoMovePending = Util.getIntValue(request.getParameter("budgetAutoMovePending"),0);
	int timeModul = Util.getIntValue(request.getParameter("timeModul"),0);
	int dayTime1 = Util.getIntValue(request.getParameter("dayTime1"),1);
	int fer = Util.getIntValue(request.getParameter("fer"),1);
	int dayTime2 = Util.getIntValue(request.getParameter("dayTime2"),1);
	int autoMoveMinusAmt = Util.getIntValue(request.getParameter("autoMoveMinusAmt"),0);//是否结转超额费用
	
	rs.executeSql("select * from FnaSystemSet where id = 1");
	if(rs.next()){
		rs.executeSql("update FnaSystemSet "+
				" set ifbudgetmove="+ifbudgetmove+", "+
				" movetypes='"+StringEscapeUtils.escapeSql(movetypes)+"', "+
				" budgetAutoMovePending="+budgetAutoMovePending+", "+
				" timeModul="+timeModul+", "+
				" dayTime1="+dayTime1+", "+
				" fer="+fer+", "+
				" autoMoveMinusAmt="+autoMoveMinusAmt+", "+
				" dayTime2="+dayTime2+" "+
				" where id = 1");
		
	}else{
		rs.executeSql("insert into FnaSystemSet (id, ifbudgetmove, movetypes, budgetAutoMovePending, timeModul, dayTime1, fer, autoMoveMinusAmt, dayTime2) "+
		" values (1,"+ifbudgetmove+",'"+StringEscapeUtils.escapeSql(movetypes)+"', "+budgetAutoMovePending+", "+timeModul+", "+dayTime1+", "+fer+", "+autoMoveMinusAmt+", "+dayTime2+")");
		
	}
	new FnaSystemSetComInfo().removeFnaSystemSetCache();
	//response.sendRedirect("/fna/BudgetAutoMove/FnaJzSetInner.jsp");
	
	if(true){//更新：集成中心》计划任务配置信息；/WEB-INF/service/schedule.xml
		String scheduleid = "BudgetAutoMove";
		String ClassName = "weaver.fna.budget.BudgetAutoMove";
		String CronExpr = "";
		
		if(timeModul==0){//自定义结转周期
		}else if(timeModul==1){//每天
			//0 0 12 * * ? 每天中午12点触发
			CronExpr = "0 0 "+dayTime1+" * * ?";//每天N点
		}else if(timeModul==2){//每月
			CronExpr = "0 0 "+dayTime2+" "+fer+" * ?";
		}

		if(timeModul==1 || timeModul==2){
			ScheduleXML scheduleXML = new ScheduleXML();
			/*
			ArrayList pointArrayList = scheduleXML.getPointArrayList();
			ArrayList pointArrayList_dataHST = new ArrayList();
			
			Hashtable dataHST_old = scheduleXML.getDataHST();
			for(int i=0;i<pointArrayList.size();i++){
			    String pointid = (String)pointArrayList.get(i);
			    if(pointid.equals("")){
			    	continue;
			    }
			    Hashtable thisDetailHST = (Hashtable)dataHST_old.get(pointid);
			    if(thisDetailHST==null){
			    	thisDetailHST = new Hashtable();
			    	dataHST_old.put(pointid, thisDetailHST);
				}
			    if(pointid.equals(scheduleid)){
			        thisDetailHST.put("construct", ClassName);
			        thisDetailHST.put("cronExpr", CronExpr);
			    }
			    
			    pointArrayList_dataHST.add(thisDetailHST);
			}
		    
		    if(!pointArrayList.contains(scheduleid)){
		    	Hashtable thisDetailHST = new Hashtable();
		        thisDetailHST.put("construct", ClassName);
		        thisDetailHST.put("cronExpr", CronExpr);
		    	pointArrayList.add(scheduleid);
			    pointArrayList_dataHST.add(thisDetailHST);
			}*/
			Hashtable hst = new Hashtable();
			hst.put("construct",ClassName);
			hst.put("cronExpr",CronExpr);
		    new ScheduleXML().writeToScheduleXMLAdd(scheduleid,hst);
			//new ScheduleXML().writeToScheduleXMLEdit(pointArrayList, pointArrayList_dataHST);
		    new ResetXMLFileCache().resetCache();
		}
	}
%>

<%@page import="weaver.servicefiles.ScheduleXML"%>
<%@page import="weaver.servicefiles.ResetXMLFileCache"%><html>
<head>
<script type="text/javascript">
	window.parent.location.href = "/fna/BudgetAutoMove/FnaJz.jsp";
</script>
</head>
<body></body>
</html>
<%
	
}else{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

































%>