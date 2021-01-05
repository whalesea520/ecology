<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.*" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="MostExceedFlow" class="weaver.workflow.report.MostExceedFlow" scope="page" />
<jsp:useBean id="userSort" class="weaver.workflow.report.UserExceedSort" scope="page"/>
<jsp:useBean id="userSort1" class="weaver.workflow.report.UserPendingSort" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="OverTime" class="weaver.workflow.report.OverTimeComInfo" scope="page"/>
<jsp:useBean id="spendTimeStatSort" class="weaver.workflow.report.SpendTimeStatSort" scope="page"/>
<jsp:useBean id="mostSpendTimeSort" class="weaver.workflow.report.MostSpendTimeSort" scope="page"/>
<jsp:useBean id="nodeOperatorfficiencySort" class="weaver.workflow.report.NodeOperatorfficiencySort" scope="page"/>
<jsp:useBean id="mostExceedFlow" class="weaver.workflow.report.MostExceedFlow" scope="page"/>

<%
response.setHeader("Expires","0");
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
response.setDateHeader("Expires",0);
%>
<%!
public String getLogType(String logtype,User user){
	char ch=logtype.charAt(0);
	String result="";
	switch(ch){
	case '1':
		result=getHtmlLabel(86,user.getLanguage());
		break;
	case '2':
		result=getHtmlLabel(615,user.getLanguage());
		break;
	case '3':
		result=getHtmlLabel(236,user.getLanguage());
		break;
	case '4':
		result=getHtmlLabel(244,user.getLanguage());
		break;
	case '5':
		result=getHtmlLabel(91,user.getLanguage());
		break;
	case '6':
		result=getHtmlLabel(737,user.getLanguage());
		break;
	case '7':
		result=getHtmlLabel(6011,user.getLanguage());
		break;
	case '9':
		result=getHtmlLabel(1006,user.getLanguage());
		break;
	case '0':
		result=getHtmlLabel(142,user.getLanguage());
		break;
	case 'e':
		result=getHtmlLabel(18360,user.getLanguage());
		break;
	case 't':
		result=getHtmlLabel(2084,user.getLanguage());
		break;
	case 's':
		result=getHtmlLabel(21223,user.getLanguage());
		break;
	}
	return result;
}
public String getHtmlLabel(int id,int language){
	return SystemEnv.getHtmlLabelName(id,language);
}
public String getParamValue(String str,String key){
	String[] param=str.replaceAll(" ","\\+").split("\\+");
	String result="";
	for(int i=0;i<param.length;i++){
		String[] kv=param[i].split("=");
		if(key.equals(kv[0])){
			if(kv.length>1){
				result=kv[1];
				break;
			}
		}
	}
	return result;
}
%>
<%
String strSql = Util.null2String(request.getParameter("sql"));
strSql = strSql.replaceAll("%2B", "\\+");
String exportProcess = Util.null2String(request.getParameter("exportProcess"));
//System.out.println("=============================exportProcess: " + exportProcess);
String title="";
ExcelFile.init();
ExcelSheet es = new ExcelSheet();
ExcelStyle excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelRow er = es.newExcelRow();
if(user == null )  return ;
final String sqlFlag="[sqlwhere]";
er.setHight(30);
if(exportProcess.equals("spendTime")){//流程耗时统计表


	er.addStringValue(getHtmlLabel(16579,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19060,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19079,user.getLanguage()), "Header");
	title=getHtmlLabel(19031,user.getLanguage());
	if(!strSql.equals("")){
		if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
			RecordSet.executeSql(strSql);
		}else{
			int maxrow=Integer.MAX_VALUE;
			String sqlStr_2="",sqlStr_1="";
			sqlStr_1=strSql.substring(0,strSql.indexOf(sqlFlag));
			sqlStr_2=strSql.substring(strSql.indexOf(sqlFlag)+sqlFlag.length());
			String countsql="select  count(*) from workflow_requestbase where exists (select 1 from workflow_currentoperator "+
			" where requestid=workflow_requestbase.requestid and workflow_currentoperator.preisremark='0' "+
			" "+sqlStr_1+" ) and exists (select 1 from workflow_base where id = "+
			" workflow_requestbase.workflowid and (isvalid = 1 or isvalid = 3)) and status is not null and"+
			" status!='' "+sqlStr_2;
			RecordSet.executeSql(countsql);
			RecordSet.next();
			maxrow=RecordSet.getInt(1);
			String sql="select * from (select top "+maxrow+" * from ( select  requestname,workflow_requestbase.requestid,"+
			" workflow_requestbase.workflowid,status, 24 *( convert(float,convert(datetime, case "+
					" lastoperatedate when ''  then convert(char(10),getdate(),20) when null then "+
					" convert(char(10),getdate(),20) else lastoperatedate end + ' ' + "+
					" isnull(lastoperatetime,convert(char(10), getdate(), 108)) ) ) - "+
					" convert(float,convert(datetime, createdate + ' ' + createtime))) as "+
					" spends from workflow_requestbase where exists (select 1 from workflow_currentoperator "+
					" where requestid=workflow_requestbase.requestid and workflow_currentoperator.preisremark='0' "+
					" "+sqlStr_1+" ) and exists (select 1 from workflow_base where id = "+
					" workflow_requestbase.workflowid and (isvalid = 1 or isvalid = 3)) and status is not null and"+
					" status!='' "+sqlStr_2+" ) as t order by spends desc) as t order by spends desc";
			RecordSet.executeSql(sql) ;
		}
		while(RecordSet.next()){
			String theworkflowid = Util.null2String(RecordSet.getString("workflowid"));        
		    String requestName = Util.null2String(RecordSet.getString("requestname"));
			float spends = Util.getFloatValue(RecordSet.getString("spends"),0) ;
			theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
		    if(WorkflowComInfo.getIsValid(theworkflowid).equals("1") || WorkflowComInfo.getIsValid(theworkflowid).equals("3")){
		    	er = es.newExcelRow();
		    	String typeName=WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(theworkflowid));
			    String flowName=WorkflowComInfo.getWorkflowname(theworkflowid);
			    
			    er.addStringValue(typeName, "Border");
				er.addStringValue(flowName, "Border");
				er.addStringValue(requestName, "Border");
				er.addStringValue(mostSpendTimeSort.getSpendsString("" + spends), "Border");
		    }
		    
		}
	}
}else if(exportProcess.equals("viewLog")){//近期读取
	title=getHtmlLabel(16576,user.getLanguage());
	er.addStringValue(getHtmlLabel(1272,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(648,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(271,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(15530,user.getLanguage()), "Header");
	er.addStringValue("IP Address", "Header");
	if(!strSql.equals("")){
		RecordSet.executeSql(strSql);
		RecordSet.executeSql("select creater,viewdate,viewtime,workflowid,requestname,viewer,ipaddress from searchtemp");
		while(RecordSet.next()){
			er = es.newExcelRow();
			String creater=RecordSet.getString("creater");
			String viewdate=RecordSet.getString("viewdate");
			String viewtime=RecordSet.getString("viewtime");
			String workflowid=RecordSet.getString("workflowid");
			String requestname=RecordSet.getString("requestname");
			String curviewer=RecordSet.getString("viewer");
			String clientip=RecordSet.getString("ipaddress");
			
			String curviewername=ResourceComInfo.getResourcename(curviewer);
			String creatername=ResourceComInfo.getResourcename(creater);
			String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
			
			er.addStringValue(Util.toScreen(viewdate,user.getLanguage())+"&nbsp;"+Util.toScreen(viewtime,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(requestname,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(workflowname,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(creatername,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(curviewername,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(clientip,user.getLanguage()), "Border");
		}
		RecordSet.executeSql("drop table searchtemp");
	}
}else if(exportProcess.equals("operateLog")){//近期读取
	title=getHtmlLabel(16578,user.getLanguage());
	er.addStringValue(getHtmlLabel(15502,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(648,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(271,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(15503,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(17484,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		RecordSet.executeSql(strSql);
		RecordSet.executeSql("select creater,operatedate,operatetime,workflowid,requestname,clientip,logtype from searchtemp");
		while(RecordSet.next()){
			er = es.newExcelRow();
			String creater=RecordSet.getString("creater");
			String operatedate=RecordSet.getString("operatedate");
			String operatetime=RecordSet.getString("operatetime");
			String workflowid=RecordSet.getString("workflowid");
			String requestname=RecordSet.getString("requestname");
			String clientip=RecordSet.getString("clientip");
			String logtype=RecordSet.getString("logtype");
			
			String creatername=ResourceComInfo.getResourcename(creater);
			String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
			
			er.addStringValue(Util.toScreen(operatedate,user.getLanguage())+"&nbsp;"+Util.toScreen(operatetime,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(requestname,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(workflowname,user.getLanguage()), "Border");
			er.addStringValue(Util.toScreen(creatername,user.getLanguage()), "Border");
			er.addStringValue(getLogType(logtype,user), "Border");
			er.addStringValue(Util.toScreen(clientip,user.getLanguage()), "Border");
		}
		RecordSet.executeSql("drop table searchtemp");
	}
}else if(exportProcess.equals("mostSpendTime")){//流程办理情况统计表 
	title=getHtmlLabel(19034,user.getLanguage());
	er.addStringValue(getHtmlLabel(19082,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19060,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(16579,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19079,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
			RecordSet.executeSql(strSql);
			//RecordSet.next();
		}else{
			RecordSet.executeProc("SpendTimeStat_Get",strSql) ;
		}
		int i=0;
		while(RecordSet.next()){
			String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
	        String requestName = Util.null2String(RecordSet.getString("requestname")) ;
			float spends = Util.getFloatValue(RecordSet.getString("spends"),0) ;
			theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
	        //if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
	        	i++;
	    		er = es.newExcelRow();
	        	String typeName=WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(theworkflowid));
		        String flowName=WorkflowComInfo.getWorkflowname(theworkflowid);
		        er.addStringValue(""+i, "Border");
				er.addStringValue(requestName, "Border");
				er.addStringValue(flowName, "Border");
				er.addStringValue(typeName, "Border");
				er.addStringValue(spendTimeStatSort.getSpendsString("" + spends), "Border");
		    //}
		    
		}
	}
}else if(exportProcess.equals("nodeOperator")){//节点操作效率人员排名表


	title=getHtmlLabel(19035,user.getLanguage());
	er.addStringValue(getHtmlLabel(19082,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(1867,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19059,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
			String sqls="select userid," +
			"24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
			"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) as spends "+ 
			" from workflow_currentoperator where exists (select 1 from workflow_requestbase where  "+
			" workflow_requestbase.requestid=workflow_currentoperator.requestid "+
			" and status is not null) "+strSql+
			" group by userid order by spends desc ";
			RecordSet.execute(sqls);
		}else{
			RecordSet.executeProc("NodeOperatorTime",strSql) ;
		}
		int i=0;
		while(RecordSet.next()){
			i++;
			er = es.newExcelRow();
			er.addStringValue(""+i, "Border");
			er.addStringValue(resourceComInfo.getLastname(""+RecordSet.getString(1)), "Border");
			er.addStringValue(nodeOperatorfficiencySort.getSpendsString(RecordSet.getString(2)), "Border");
		}
	}
}else if(exportProcess.equals("exceedFlow")){//超期最多流程排名表
	title=getHtmlLabel(19036,user.getLanguage());
	er.addStringValue(getHtmlLabel(19082,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19060,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(16579,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(1982,user.getLanguage()) + getHtmlLabel(277,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		List sortsExceed = new ArrayList();
		ArrayList requestnamelist = new ArrayList();
		ArrayList workflowlist = new ArrayList();
		ArrayList overtimelist = new ArrayList();
		sortsExceed = MostExceedFlow.getMostExceedSort(strSql);
		if(sortsExceed.size() > 0) {
		   requestnamelist = (ArrayList)sortsExceed.get(0);
		   workflowlist = (ArrayList)sortsExceed.get(1);
		   overtimelist = (ArrayList)sortsExceed.get(2);
		}
		
		int i=0;
		for (int j=0;j<overtimelist.size();j++) {
			String theworkflowid = (String)workflowlist.get(j);
			String requestName = (String)requestnamelist.get(j);
			String spends = (String)overtimelist.get(j);			
			theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
			if (WorkflowComInfo.getIsValid(theworkflowid).equals("1")) {
				i++;
				er = es.newExcelRow();
				String typeName = WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(theworkflowid));
				String flowName = WorkflowComInfo.getWorkflowname(theworkflowid);
				er.addStringValue(""+i, "Border");
				er.addStringValue(requestName, "Border");
				er.addStringValue(flowName, "Border");
				er.addStringValue(typeName, "Border");
				er.addStringValue(mostExceedFlow.getSpendsString(spends), "Border");
			}
		}
	}
}else if(exportProcess.equals("exceedPerson")){//超期最多流程排名表
	title=getHtmlLabel(19037,user.getLanguage());
	er.addStringValue(getHtmlLabel(19083,user.getLanguage())+getHtmlLabel(19082,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(1867,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(332,user.getLanguage())+getHtmlLabel(18015,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(1982,user.getLanguage())+getHtmlLabel(18015,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19101,user.getLanguage())+"（100%）", "Header");
	er.addStringValue(getHtmlLabel(18939,user.getLanguage())+getHtmlLabel(19082,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(141,user.getLanguage())+getHtmlLabel(19082,user.getLanguage()), "Header");
	if(!strSql.equals("") && strSql.indexOf(sqlFlag)!=-1){
		String sql=strSql.substring(0,strSql.indexOf(sqlFlag));
		String sqlwhere=strSql.substring(strSql.indexOf(sqlFlag)+sqlFlag.length());
		List sorts=new ArrayList();
		ArrayList totlaSort=new ArrayList();
		ArrayList totlaSortDepartment=new ArrayList();
		ArrayList totlaSortSubCompany=new ArrayList();
		ArrayList users=new ArrayList();
		ArrayList counts=new ArrayList();
		ArrayList sumCounts=new ArrayList();
		ArrayList percentCounts=new ArrayList();
		ArrayList userIds=new ArrayList();
		//System.out.println("sql"+sql);
		RecordSet.execute(sql);  //得到查询人员
		while (RecordSet.next())
		{
			userIds.add(RecordSet.getString(1));
		}
		sorts=userSort.getUserSort(sqlwhere); //得到所有人的超期流程排名


		if(sorts.size() > 0) {
			 totlaSort=(ArrayList)sorts.get(0);
			 users=(ArrayList)sorts.get(1);
			 counts=(ArrayList)sorts.get(2);
			 totlaSortDepartment=(ArrayList)sorts.get(3);
			 totlaSortSubCompany=(ArrayList)sorts.get(4);
			 sumCounts=(ArrayList)sorts.get(5);
			 percentCounts=(ArrayList)sorts.get(6);
		}
		for (int i=0;i<users.size();i++)
	    {
			if (userIds.indexOf(users.get(i))!=-1)
	        {
				er = es.newExcelRow();
				er.addStringValue((String)totlaSort.get(i), "Border");
				er.addStringValue(resourceComInfo.getLastname(""+users.get(i)), "Border");
				er.addStringValue((String)sumCounts.get(i), "Border");
				er.addStringValue((String)counts.get(i), "Border");
				er.addStringValue(Util.round(""+percentCounts.get(i),2), "Border");
				er.addStringValue((""+totlaSortDepartment.get(i)).substring(0,(""+totlaSortDepartment.get(i)).indexOf("$")), "Border");
				er.addStringValue((""+totlaSortSubCompany.get(i)).substring(0,(""+totlaSortSubCompany.get(i)).indexOf("$")), "Border");
	        }
	    }
	}
	
}else if(exportProcess.equals("mostPending")){//待办事宜最多人员排名表
	title=getHtmlLabel(19032,user.getLanguage());
	er.addStringValue(getHtmlLabel(19083,user.getLanguage())+getHtmlLabel(19082,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(1867,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(124,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(141,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(1207,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(18939,user.getLanguage())+getHtmlLabel(19082,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(141,user.getLanguage())+getHtmlLabel(19082,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		String sql=strSql.substring(0,strSql.indexOf(sqlFlag));
		String sqlCondition=strSql.substring(strSql.indexOf(sqlFlag)+sqlFlag.length());
		ArrayList userIds=new ArrayList();
		List sorts=new ArrayList();
		ArrayList totlaSort=new ArrayList();
		ArrayList totlaSortDepartment=new ArrayList();
		ArrayList totlaSortSubCompany=new ArrayList();
		ArrayList users=new ArrayList();
		ArrayList counts=new ArrayList();
		
		sorts=userSort1.getUserSort(sqlCondition,sql); //得到所有人的待办事宜排名

		if (sorts.size()>0)
		{
		 totlaSort=(ArrayList)sorts.get(0);
		 users=(ArrayList)sorts.get(1);
		 counts=(ArrayList)sorts.get(2);
		 totlaSortDepartment=(ArrayList)sorts.get(3);
		 totlaSortSubCompany=(ArrayList)sorts.get(4);
		}
		RecordSet.execute(sql);
		while (RecordSet.next())
		{
		userIds.add(RecordSet.getString(1));
		}
		//System.out.println(sqlCondition+"=="+sql+"=="+sorts);
		for (int i=0;i<users.size();i++)
	    {
			if (userIds.indexOf(users.get(i))!=-1)
	        {
				er = es.newExcelRow();
				er.addStringValue((String)totlaSort.get(i), "Border");
				er.addStringValue(resourceComInfo.getLastname(""+users.get(i)), "Border");
				er.addStringValue(DepartmentComInfo.getDepartmentname(resourceComInfo.getDepartmentID(""+users.get(i))), "Border");
				er.addStringValue(subCompanyComInfo.getSubCompanyname(resourceComInfo.getSubCompanyID(""+users.get(i))), "Border");
				er.addStringValue((String)counts.get(i), "Border");
				er.addStringValue((""+totlaSortDepartment.get(i)).substring(0,(""+totlaSortDepartment.get(i)).indexOf("$")), "Border");
				er.addStringValue((""+totlaSortSubCompany.get(i)).substring(0,(""+totlaSortSubCompany.get(i)).indexOf("$")), "Border");
	        }
	    }
	}
	
}else if(exportProcess.equals("handleRequest")){//人员办理时间分析表


	title=getHtmlLabel(19030,user.getLanguage());
	er.addStringValue(getHtmlLabel(1867,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(16579,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage())+"("+getHtmlLabel(18561,user.getLanguage())+")", "Header");
	er.addStringValue(getHtmlLabel(15586,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19059,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(468,user.getLanguage())+getHtmlLabel(19059,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		String sqlCondition=strSql;
		ArrayList temp = new ArrayList();
		ArrayList wftypes = new ArrayList();
		ArrayList workflows = new ArrayList();
		ArrayList workflowcounts = new ArrayList(); // 总计
		ArrayList userIds = new ArrayList();
		ArrayList wfUsers = new ArrayList();
		ArrayList flowUsers = new ArrayList();
	
		// 得到各个节点的平均时间


	
		ArrayList workFlowNodes = new ArrayList();
		ArrayList workFlowUserIds = new ArrayList();
		ArrayList workFlowNodeCounts = new ArrayList();
		ArrayList nodeIds = new ArrayList();
		ArrayList tempNodeIds = new ArrayList();
		ArrayList tempCounts = new ArrayList();
		// 系统平耗时
	
		ArrayList tempCountsx = new ArrayList();
		ArrayList nodeNames = new ArrayList();
		ArrayList nodeNametemps = new ArrayList();
		ArrayList nodeUserIds = new ArrayList();
		if (RecordSet.getDBType().equals("oracle")
				|| RecordSet.getDBType().equals("db2")) {
	
			String sql = "select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "
					+ " count(distinct workflow_requestbase.requestid) workflowcount from "
					+ " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "
					+ " and (workflow_requestbase.status is not null ) and workflow_currentoperator.workflowtype>1  "
					+ sqlCondition
					+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by "
					+ " workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "
					+ " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	
			RecordSet.executeSql(sql);
		} else {
			String sql = "select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "
					+ " count(distinct workflow_requestbase.requestid) workflowcount from "
					+ " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "
					+ " and (workflow_requestbase.status is not null and workflow_requestbase.status!='') and workflow_currentoperator.workflowtype>1 and preisremark='0' and isremark<>4 "
					+ sqlCondition
					+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "
					+ " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	
			RecordSet.executeSql(sql);
		}
		while (RecordSet.next()) {
			String theworkflowid = Util.null2String(RecordSet
					.getString("workflowid"));
			String theworkflowtype = Util.null2String(RecordSet
					.getString("workflowtype"));
			String userid = Util.null2String(RecordSet.getString("userid"));
			int theworkflowcount = Util.getIntValue(RecordSet
					.getString("workflowcount"), 0);
	
			if (WorkflowComInfo.getIsValid(theworkflowid).equals("1")) {
				workflows.add(theworkflowid);
				workflowcounts.add("" + theworkflowcount);
				flowUsers.add("" + userid);
				int userIndex = userIds.indexOf(userid);
				int tempIndex = temp.indexOf(userid + "$" + theworkflowtype);
				if (userIndex != -1) {
					if (tempIndex != -1) {
					} else {
						temp.add(userid + "$" + theworkflowtype);
						wftypes.add(theworkflowtype);
						wfUsers.add(userid);
					}
				} else {
					userIds.add("" + userid);
					temp.add(userid + "$" + theworkflowtype);
					wftypes.add(theworkflowtype);
					wfUsers.add(userid);
	
				}
			}
		}
		if (RecordSet.getDBType().equals("oracle")
				|| RecordSet.getDBType().equals("db2")) {
	
			String sql = "select workflow_currentoperator.userid,workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),"
					+ "24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"
					+ "-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "
					+ " from workflow_currentoperator,workflow_requestbase "
					+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null  "
					+ "  ) and workflowtype>1 and workflow_currentoperator.isremark <> 0 and isremark<>4 and preisremark='0' "
					+ sqlCondition
					+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "
					+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
					+ "group by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "
					+ "order by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
			RecordSet.execute(sql);
	
		} else {
			RecordSet.executeProc("PersonNodeTime_Get", sqlCondition);
		}
		while (RecordSet.next()) {
			String userId = Util.null2String(RecordSet.getString("userid"));
			String workFlowId = Util.null2String(RecordSet
					.getString("workflowid"));
			String nodeId = Util.null2String(RecordSet.getString("nodeid"));
			String nodeName = Util.null2String(RecordSet.getString(4));
			float avgNode = Util.getFloatValue(RecordSet.getString(5), 0);
			int flowIndex = workFlowUserIds.indexOf(userId + "$" + workFlowId);
			if (flowIndex != -1) {
				tempNodeIds.add(nodeId);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.set(flowIndex, tempCounts);
				nodeIds.set(flowIndex, tempNodeIds);
				nodeNametemps.add(nodeName);
				nodeNames.set(flowIndex, nodeNametemps);
			} else {
				tempNodeIds = new ArrayList();
				tempNodeIds = new ArrayList();
				tempCounts = new ArrayList();
				nodeNametemps = new ArrayList();
				workFlowUserIds.add(userId + "$" + workFlowId);
				tempNodeIds.add(nodeId);
				nodeIds.add(tempNodeIds);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.add(tempCounts);
				nodeNametemps.add(nodeName);
				nodeNames.add(nodeNametemps);
			}
	
		}
		// 系统平均耗时 (是否考虑在其他页面操作，点击时才出现???,by ben 太耗性能了！:（ )
		if (RecordSet.getDBType().equals("oracle")
				|| RecordSet.getDBType().equals("db2")) {
	
			String sql = " select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
					+ "24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"
					+ "-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "
					+ " from workflow_currentoperator,workflow_requestbase "
					+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null ) "
					+ "	and workflowtype>1 and workflow_currentoperator.isremark <> 0 and isremark<>4 and preisremark='0' "
					+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and "
					+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
					+ " group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "
					+ " order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
			RecordSet.execute(sql);
		} else {
			RecordSet.executeProc("WorkFlowSysNodeTime_Get", sqlCondition);
		}
		while (RecordSet.next()) {
	
			workFlowNodes.add(""
					+ Util.null2String(RecordSet.getString("nodeid")));
			tempCountsx.add("" + Util.getFloatValue(RecordSet.getString(4), 0));
	
		}
		String workflowid="";
		String workflowname="";
		
		 for(int i=0;i<userIds.size();i++){
		       String objId=(String)userIds.get(i);
		       if(wftypes.size()>0){
		    	   for(int j=0;j<wftypes.size();j++){
			    	   String tempObjId=""+wfUsers.get(j);
			    	   String wfId=""+wftypes.get(j);
			    	   if (!tempObjId.equals(objId)) continue;
			    	   if(workflows.size()>0){
			    		   for(int k=0;k<workflows.size();k++){
				    		     workflowid=(String)workflows.get(k);
				    		     String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
				    			 String tempUser=""+flowUsers.get(k);
				    			 if(!curtypeid.equals(wfId)||!tempUser.equals(objId))	continue;		
				    		     workflowname=WorkflowComInfo.getWorkflowname(workflowid); 
				    		     String tempNodeCounts=""; 
				    		     String tempNodeIdSend="";
				    		     String tempNodeNameSend="";
				    		     int indexId=workFlowUserIds.indexOf(tempUser+"$"+workflowid);
				    		     if (indexId!=-1){
					    			  ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
					    			  ArrayList nodeNamea=(ArrayList)nodeNames.get(indexId);
					    			  ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
					    			  ArrayList nodeNameas=(ArrayList)nodeNames.get(indexId);
					    			  if(nodeIda.size()>0){
					    				  for (int l=0;l<nodeIda.size();l++){
							    			  tempNodeCounts+=nodeCounta.get(l)+",";
							    			  tempNodeIdSend+=nodeIda.get(l)+",";
							    			  tempNodeNameSend+=nodeNameas.get(l)+",";
						    			  }
						    			  for (int m=0;m<nodeIda.size();m++){
						    				  er = es.newExcelRow();
						 	    			  er.addStringValue(resourceComInfo.getLastname(objId), "Border");
						 	    			  er.addStringValue(WorkTypeComInfo.getWorkTypename(wfId), "Border");
						 	    			  er.addStringValue((String)workflowname+"("+workflowcounts.get(k)+")", "Border");
						 	    			  er.addStringValue((String)nodeNamea.get(m), "Border");
						 	    			  String overTimesbLabel=(String)Util.round(""+nodeCounta.get(m),1)+"("+getHtmlLabel(391,user.getLanguage())+")";
						 	    			  boolean  overT=false;
						 	    			  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(m)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(m)),0);
							    		      float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(m)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(m)),0)/24;
						 	    			  if ((Util.getFloatValue(""+nodeCounta.get(m),0)>overTimes)&&overTimesb!=0) overT=!overT;
						 	    			  if(overT)overTimesbLabel+=getHtmlLabel(19081,user.getLanguage());
						 	    			  er.addStringValue(overTimesbLabel, "Border");
							    		      int indexIds=workFlowNodes.indexOf(""+nodeIda.get(m));
							    		      String sysOverTimeLabel="";
						    		     	  if (indexIds!=-1) {
						    		     		  overT=false;
						    		      		  if ((Util.getFloatValue(""+tempCountsx.get(indexIds),0)>overTimes)&&overTimesb!=0) overT=!overT;
						    		      		  sysOverTimeLabel=Util.round(""+tempCountsx.get(indexIds),1)+"("+getHtmlLabel(391,user.getLanguage())+")";
						    		      		  if(overT)sysOverTimeLabel+="("+getHtmlLabel(19081,user.getLanguage())+")";
						    		      		  er.addStringValue(sysOverTimeLabel, "Border");
						    		     	  }
						    			  }
					    			  }else{
					    				  er = es.newExcelRow();
						    			  er.addStringValue(resourceComInfo.getLastname(objId), "Border");
						    			  er.addStringValue(WorkTypeComInfo.getWorkTypename(wfId), "Border");
						    			  er.addStringValue((String)workflowname+"("+workflowcounts.get(k)+")", "Border");
						    			  er.addStringValue("", "Border");
						    			  er.addStringValue("", "Border");
						    			  er.addStringValue("", "Border");
					    			  }
				    			 }else{
				    				  er = es.newExcelRow();
					    			  er.addStringValue(resourceComInfo.getLastname(objId), "Border");
					    			  er.addStringValue(WorkTypeComInfo.getWorkTypename(wfId), "Border");
					    			  er.addStringValue((String)workflowname+"("+workflowcounts.get(k)+")", "Border");
					    			  er.addStringValue("", "Border");
					    			  er.addStringValue("", "Border");
					    			  er.addStringValue("", "Border");
				    			  }
				    		     workflows.remove(k);
				    		     workflowcounts.remove(k);
				    		     flowUsers.remove(k);
				    		     k--;
				    	   }
			    	   }else{
			    		  er = es.newExcelRow();
		    			  er.addStringValue(resourceComInfo.getLastname(objId), "Border");
		    			  er.addStringValue(WorkTypeComInfo.getWorkTypename(wfId), "Border");
		    			  er.addStringValue("", "Border");
		    			  er.addStringValue("", "Border");
		    			  er.addStringValue("", "Border");
		    			  er.addStringValue("", "Border");
			    	   }
			    	   wftypes.remove(j);
			    	   wfUsers.remove(j);
			    	   j--;
			       }
		       }else{
		    	  er = es.newExcelRow();
	 			  er.addStringValue(resourceComInfo.getLastname(objId), "Border");
	 			  er.addStringValue("", "Border");
				  er.addStringValue("", "Border");
				  er.addStringValue("", "Border");
				  er.addStringValue("", "Border");
				  er.addStringValue("", "Border");
		       }
		 }
	}
}else if(exportProcess.equals("handleTypeTime")){//流程流转时间分析表


	title=getHtmlLabel(19029,user.getLanguage());
	er.addStringValue(getHtmlLabel(1867,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(15433,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19060,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(15586,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19079,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		String sqlCondition=strSql.substring(strSql.indexOf(sqlFlag)+sqlFlag.length(),strSql.indexOf("[userid]"));
		String tempNodeId=strSql.substring(0,strSql.indexOf("[nodeids]"));
		String tempNodeCounts=strSql.substring(strSql.indexOf("[nodename]")+"[nodename]".length(),strSql.indexOf(sqlFlag));
	    String tempNodeName=strSql.substring(strSql.indexOf("[nodeids]")+"[nodeids]".length(),strSql.indexOf("[nodename]"));
	    String userId=strSql.substring(strSql.indexOf("[userid]")+"[userid]".length(),strSql.indexOf("[flowid]"));
	    String flowId=strSql.substring(strSql.indexOf("[flowid]")+"[flowid]".length());
	    String username=resourceComInfo.getLastname(userId);
	    String WorkTypename=WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(flowId));
	    String Workflowname=WorkflowComInfo.getWorkflowname(flowId);
	    tempNodeName=URLDecoder.decode(tempNodeName);
	    
		ArrayList requestIds = new ArrayList();
		ArrayList workFlowNodeCounts = new ArrayList();
		ArrayList nodeIds = new ArrayList();
		ArrayList tempNodeIds = new ArrayList();
		ArrayList tempCounts = new ArrayList();
		ArrayList nodeNametemps = new ArrayList();
		ArrayList requestNames = new ArrayList();
		if (RecordSet.getDBType().equals("oracle")
				|| RecordSet.getDBType().equals("db2")) {
	
			String sql = " select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "
					+ " requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
					+ "24*avg(case when isremark=0 then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"
					+ " when isremark=2 and workflow_currentoperator.operatedate is not null "
					+ " then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "
					+ " -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "
					+ " from workflow_currentoperator,workflow_requestbase,workflow_requestLog "
					+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid "
					+ " and workflow_requestbase.requestid=workflow_requestLog.requestid "
					+ " and workflow_requestLog.operatedate is not null "
					+ " and workflow_requestbase.status is not null "
					+ " and workflowtype>1 and workflow_currentoperator.isremark <> 0 and isremark<>4 and preisremark='0' "
					+ sqlCondition
					+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid "
					+ " and  nodetype<3) "
					+ " group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid "
					+ " order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid ";
			RecordSet.execute(sql);
		} else {
			RecordSet.executeProc("WorkFlowTypeNodeTime_Get", sqlCondition);
		}
		while (RecordSet.next()) {
			String requestId = Util.null2String(RecordSet
					.getString("requestid"));
			String nodeId = Util.null2String(RecordSet.getString("nodeid"));
			String nodeName = Util.null2String(RecordSet.getString(4));
			String requestName = Util.null2String(RecordSet.getString(3));
			float avgNode = Util.getFloatValue(RecordSet.getString(5), 0);
	
			int flowIndex = requestIds.indexOf(requestId);
			if (flowIndex != -1) {
				tempNodeIds.add(nodeId);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.set(flowIndex, tempCounts);
				nodeIds.set(flowIndex, tempNodeIds);
			} else {
				tempNodeIds = new ArrayList();
				tempNodeIds = new ArrayList();
				tempCounts = new ArrayList();
				requestIds.add("" + requestId);
				requestNames.add("" + requestName);
				tempNodeIds.add(nodeId);
				nodeIds.add(tempNodeIds);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.add(tempCounts);
			}
	
		}
		ArrayList nodeCounts=Util.TokenizerString(tempNodeCounts,",");
		ArrayList nodeNames=Util.TokenizerString(tempNodeName,",");
		ArrayList nodeIdss=Util.TokenizerString(tempNodeId,",");
		String requestIdd="";
		for(int i=0;i<requestIds.size();i++){
		       requestIdd=(String)requestIds.get(i);   
		       ArrayList nodeIda=(ArrayList)nodeIds.get(i);
		       ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(i);
		       for (int k=0;k<nodeIdss.size();k++){    
		    	   int tempIdIndex=nodeIda.indexOf(""+nodeIdss.get(k));
		    	   er = es.newExcelRow();
				   er.addStringValue(username, "Border");
				   er.addStringValue(WorkTypename, "Border");
				   er.addStringValue(Workflowname, "Border");
				   er.addStringValue((String)requestNames.get(i), "Border");
		    	   if (tempIdIndex!=-1) {
		    		   int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIdss.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIdss.get(k)),0);
		    		   float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIdss.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIdss.get(k)),0)/24;
		    		   boolean  overT=false;
		    		   if ((Util.getFloatValue(""+nodeCounta.get(tempIdIndex),0)>overTimes)&&overTimesb!=0) overT=!overT;
		    		   String voerTimeLable=Util.round(""+nodeCounta.get(tempIdIndex),1)+"("+getHtmlLabel(391,user.getLanguage())+")";
		    		   if (overT)voerTimeLable+="("+getHtmlLabel(19081,user.getLanguage())+")";
		    		   er.addStringValue((String)nodeNames.get(k), "Border");
		    		   er.addStringValue(voerTimeLable, "Border");
		    	   }else{
		    		   er.addStringValue((String)nodeNames.get(k), "Border");
		    		   er.addStringValue("", "Border");
		    	   }
		       }
		       if(nodeIdss.size()==0){
		    	   er = es.newExcelRow();
				   er.addStringValue(username, "Border");
				   er.addStringValue(WorkTypename, "Border");
				   er.addStringValue(Workflowname, "Border");
				   er.addStringValue((String)requestNames.get(i), "Border");
		    	   er.addStringValue("", "Border");
	    		   er.addStringValue("", "Border");
		       }
		}
		if(requestIds.size()==0){
		   for(int i=0;i<nodeNames.size();i++){
			   er = es.newExcelRow();
			   er.addStringValue(username, "Border");
			   er.addStringValue(WorkTypename, "Border");
			   er.addStringValue(Workflowname, "Border");
			   er.addStringValue("", "Border");
			   er.addStringValue((String)nodeNames.get(i), "Border");
			   er.addStringValue("", "Border");
		   }
		}
	}
}else if(exportProcess.equals("flowTime")){//流程流转时间分析表


	title=getHtmlLabel(19029,user.getLanguage());
	er.addStringValue(getHtmlLabel(16579,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage())+"("+getHtmlLabel(18561,user.getLanguage())+")", "Header");
	er.addStringValue(getHtmlLabel(15586,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19059,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		String sqlCondition=strSql;
		String sql = "select workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,  "
			+ " count(distinct workflow_requestbase.requestid) workflowcount from "
			+ " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "
			+ " and (workflow_requestbase.status is not null and workflow_requestbase.status != ' ') and workflow_currentoperator.workflowtype>1  and preisremark='0' and isremark<>4 "
			+ sqlCondition
			+ " group by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "
			+ " order by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
		ArrayList wftypes=new ArrayList();
		ArrayList wftypecounts=new ArrayList();
		ArrayList workflows=new ArrayList();
		ArrayList workflowcounts=new ArrayList();     //总计
		ArrayList workflowcountst=new ArrayList();     //总计流程类型
		ArrayList nodeTypes=new ArrayList();           //节点类型
	    ArrayList newremarkwfcounts0=new ArrayList(); 
	    ArrayList wftypecounts0=new ArrayList(); 
	 
	    ArrayList wftypess=new ArrayList();
		RecordSet.executeSql(sql);
		
		while (RecordSet.next()) {
			String theworkflowid = Util.null2String(RecordSet
					.getString("workflowid"));
			String theworkflowtype = Util.null2String(RecordSet
					.getString("workflowtype"));
		
			int theworkflowcount = Util.getIntValue(RecordSet
					.getString("workflowcount"), 0);
			if (WorkflowComInfo.getIsValid(theworkflowid).equals("1")) {
				int wfindex = workflows.indexOf(theworkflowid);
				if (wfindex != -1) {
					workflowcounts.set(wfindex, ""
							+ (Util.getIntValue((String) workflowcounts
									.get(wfindex), 0) + theworkflowcount));
				} else {
					workflows.add(theworkflowid);
					workflowcounts.add("" + theworkflowcount);
				}
		
				int wftindex = wftypes.indexOf(theworkflowtype);
				if (wftindex != -1) {
					wftypecounts.set(wftindex, ""
							+ (Util.getIntValue((String) wftypecounts
									.get(wftindex), 0) + theworkflowcount));
				} else {
					wftypes.add(theworkflowtype);
					wftypecounts.add("" + theworkflowcount);
				}
		
			}
		}
		
		// 得到各个节点的平均时间


		
		ArrayList workFlowIds = new ArrayList();
		ArrayList workFlowNodeCounts = new ArrayList();
		ArrayList nodeIds = new ArrayList();
		ArrayList tempNodeIds = new ArrayList();
		ArrayList tempCounts = new ArrayList();
		ArrayList nodeNames = new ArrayList();
		ArrayList nodeNametemps = new ArrayList();
		if (RecordSet.getDBType().equals("oracle")
				|| RecordSet.getDBType().equals("db2")) {
			String sqls = "select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,"
					+ "(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
					+ "24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"
					+ "-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "
					+ "from workflow_currentoperator,workflow_requestbase  where workflow_requestbase.requestid=workflow_currentoperator.requestid "
					+ "and (workflow_requestbase.status is not null) and workflowtype>1 and isremark<>4 and preisremark='0' "
					+ sqlCondition
					+ "and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "
					+ "workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
					+ "group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "
					+ "order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid";
			RecordSet.execute(sqls);
		
		} else {
			RecordSet.executeProc("WorkFlowNodeTime_Get", sqlCondition);
		}
		while (RecordSet.next()) {
			String workFlowId = Util.null2String(RecordSet
					.getString("workflowid"));
			String nodeId = Util.null2String(RecordSet.getString("nodeid"));
			String nodeName = Util.null2String(RecordSet.getString(3));
			float avgNode = Util.getFloatValue(RecordSet.getString(4), 0);
			int flowIndex = workFlowIds.indexOf(workFlowId);
			if (flowIndex != -1) {
				tempNodeIds.add(nodeId);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.set(flowIndex, tempCounts);
				nodeIds.set(flowIndex, tempNodeIds);
				nodeNametemps.add(nodeName);
				nodeNames.set(flowIndex, nodeNametemps);
			} else {
				tempNodeIds = new ArrayList();
				tempNodeIds = new ArrayList();
				tempCounts = new ArrayList();
				nodeNametemps = new ArrayList();
				workFlowIds.add("" + workFlowId);
				tempNodeIds.add(nodeId);
				nodeIds.add(tempNodeIds);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.add(tempCounts);
				nodeNametemps.add(nodeName);
				nodeNames.add(nodeNametemps);
			}
		}
		String typeid="";
		String typecount="";
		String typename="";
		String workflowid="";
		String workflowcount="";
	    String newremarkwfcount0="";
	    String newremarkwfcount1="";
		String workflowname="";
		for(int i=0;i<wftypes.size();i++){
		       typeid=(String)wftypes.get(i);
		       typecount=(String)wftypecounts.get(i);
		       typename=WorkTypeComInfo.getWorkTypename(typeid);
		       for(int j=0;j<workflows.size();j++){
		    	     workflowid=(String)workflows.get(j);
		    	     String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
		    	     if(!curtypeid.equals(typeid))	continue;
		    	     workflowname=WorkflowComInfo.getWorkflowname(workflowid); 
		    	     String tempNodeCounts=""; 
		    	     String tempNodeIdd="";
		    	     int indexId=workFlowIds.indexOf(workflowid);
		    	     if (indexId!=-1){
			    	      ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
			    		  ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
			    		  for (int l=0;l<nodeIda.size();l++){
				    		  tempNodeCounts+=nodeCounta.get(l)+",";
				    		  tempNodeIdd+=nodeIda.get(l)+",";
			    		  }
					      ArrayList nodeNamea=(ArrayList)nodeNames.get(indexId);
					      for (int k=0;k<nodeIda.size();k++){
					    	 int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(k)),0);
				    	  	 float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(k)),0)/24;
				    	  	 boolean  overT=false;
				    	  	 if ((Util.getFloatValue(""+nodeCounta.get(k),0)>overTimes)&&overTimesb!=0) overT=!overT;
				    	 	 String voerTimelable=Util.round(""+nodeCounta.get(k),1)+"("+getHtmlLabel(391,user.getLanguage())+")";
				    	 	 if(overT)voerTimelable+="("+getHtmlLabel(19081,user.getLanguage())+")";
					    	 er = es.newExcelRow();
							 er.addStringValue(typename, "Border");
							 er.addStringValue(workflowname+"("+workflowcounts.get(j)+")", "Border");
					    	 er.addStringValue((String)nodeNamea.get(k), "Border");
					    	 er.addStringValue(voerTimelable, "Border");
					      }
					      if(nodeIda.size()==0){
					    	 er = es.newExcelRow();
							 er.addStringValue(typename, "Border");
							 er.addStringValue(workflowname+"("+workflowcounts.get(j)+")", "Border");
					    	 er.addStringValue("", "Border");
					    	 er.addStringValue("", "Border");
					      }
		    	     }else{
		    	    	 er = es.newExcelRow();
						 er.addStringValue(typename, "Border");
						 er.addStringValue(workflowname+"("+workflowcounts.get(j)+")", "Border");
				    	 er.addStringValue("", "Border");
				    	 er.addStringValue("", "Border");
		    	     }
		    	 workflows.remove(j);
		    	 workflowcounts.remove(j);
		    	 j--;
		    }
		}
	}
}else if(exportProcess.equals("flowTypeTime")){//流程流转时间分析表


	title=getHtmlLabel(19029,user.getLanguage());
	er.addStringValue(getHtmlLabel(15433,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(259,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19060,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(15586,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(19079,user.getLanguage()), "Header");
	if(!strSql.equals("")){
		String sqlCondition=strSql.substring(strSql.indexOf("[flowid]")+"[flowid]".length());
		ArrayList requestIds = new ArrayList();
		ArrayList workFlowNodeCounts = new ArrayList();
		ArrayList nodeIds = new ArrayList();
		ArrayList tempNodeIds = new ArrayList();
		ArrayList tempCounts = new ArrayList();
		ArrayList nodeNames = new ArrayList();
		ArrayList nodeNametemps = new ArrayList();
		ArrayList requestNames = new ArrayList();
		String tempNodeCounts=strSql.substring(strSql.indexOf("[nodeids]")+"[nodeids]".length(),strSql.indexOf("[nodecounts]"));
		String tempNodeIdd=strSql.substring(0,strSql.indexOf("[nodeids]"));
		String typeId=strSql.substring(strSql.indexOf("[nodecounts]")+"[nodecounts]".length(),strSql.indexOf("[typeid]"));
	    String flowId=strSql.substring(strSql.indexOf("[typeid]")+"[typeid]".length(),strSql.indexOf("[flowid]"));
	    String tempNodeIddstr=tempNodeIdd+"-1";
	    ArrayList nodeNamehead=new ArrayList();
		RecordSet.execute("select nodename from workflow_nodebase where id in ("+tempNodeIddstr+") order by id ");
	    while (RecordSet.next())
		{
		nodeNamehead.add(RecordSet.getString(1));
		}
	    if (RecordSet.getDBType().equals("oracle")
				|| RecordSet.getDBType().equals("db2")) {
			String sqls = "select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "
					+ " requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "
					+ "24*avg(case when isremark=0 then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"
					+ " when isremark=2 and workflow_currentoperator.operatedate is not null "
					+ " then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "
					+ " -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "
					+ " from workflow_currentoperator,workflow_requestbase,workflow_requestLog "
					+ " where workflow_requestbase.requestid=workflow_currentoperator.requestid "
					+ " and workflow_requestbase.requestid=workflow_requestLog.requestid "
					+ " and workflow_requestLog.operatedate is not null "
					+ " and workflow_requestbase.status is not null "
					+ " and workflowtype>1  and isremark<>4 and preisremark='0' "
					+ sqlCondition
					+ " and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and   "
					+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "
					+ " group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid"
					+ " order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid";
			RecordSet.execute(sqls);
		} else {
			RecordSet.executeProc("WorkFlowTypeNodeTime_Get", sqlCondition);
		}
		
		while (RecordSet.next()) {
			String requestId = Util.null2String(RecordSet
					.getString("requestid"));
			String nodeId = Util.null2String(RecordSet.getString("nodeid"));
			String nodeName = Util.null2String(RecordSet.getString(4));
			String requestName = Util.null2String(RecordSet.getString(3));
			float avgNode = Util.getFloatValue(RecordSet.getString(5), 0);
	
			int flowIndex = requestIds.indexOf(requestId);
			if (flowIndex != -1) {
				tempNodeIds.add(nodeId);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.set(flowIndex, tempCounts);
				nodeIds.set(flowIndex, tempNodeIds);
				nodeNametemps.add(nodeName);
				nodeNames.set(flowIndex, nodeNametemps);
			} else {
				tempNodeIds = new ArrayList();
				tempCounts = new ArrayList();
				nodeNametemps = new ArrayList();
				requestIds.add("" + requestId);
				requestNames.add("" + requestName);
				tempNodeIds.add(nodeId);
				nodeIds.add(tempNodeIds);
				tempCounts.add("" + avgNode);
				workFlowNodeCounts.add(tempCounts);
				nodeNametemps.add(nodeName);
				nodeNames.add(nodeNametemps);
			}
	
		}
		ArrayList nodeCounts=Util.TokenizerString(tempNodeCounts,",");
		ArrayList nodeTemps=Util.TokenizerString(tempNodeIdd,",");
		String requestIdd="";
	    String WorkTypename=WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(flowId));
	    String Workflowname=WorkflowComInfo.getWorkflowname(flowId);
		for(int i=0;i<requestIds.size();i++){
			   requestIdd=(String)requestIds.get(i);  
		       ArrayList nodeIda=(ArrayList)nodeIds.get(i);
		       ArrayList nodeNamea=(ArrayList)nodeNames.get(i);
		       ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(i);
		       for (int tempnodeIndex=0;tempnodeIndex<nodeTemps.size();tempnodeIndex++){
			    	er = es.newExcelRow();
					er.addStringValue(WorkTypename, "Border");
					er.addStringValue(Workflowname, "Border");
					er.addStringValue((String)requestNames.get(i), "Border");
		    	    String tempnode=(String)nodeTemps.get(tempnodeIndex);
					int k=nodeIda.indexOf(tempnode);
					String nodeName=(String)nodeNamehead.get(tempnodeIndex);
					if (k!=-1){
						  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(k)),0);
						  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(k)),0)/24;
						  boolean  overT=false;
						  if ((Util.getFloatValue(""+nodeCounta.get(k),0)>overTimes)&&overTimesb!=0) overT=!overT;
						  String voerTimeLable=Util.round(""+nodeCounta.get(k),1)+"("+getHtmlLabel(391,user.getLanguage())+")";
						  if(overT)voerTimeLable+="("+getHtmlLabel(19081,user.getLanguage())+")";
						  er.addStringValue(nodeName, "Border");
			    		  er.addStringValue(voerTimeLable, "Border");
					}else{
						er.addStringValue(nodeName, "Border");
			    		er.addStringValue("", "Border");
					}
		       }
		       if(nodeTemps.size()==0){
		    	   er = es.newExcelRow();
				   er.addStringValue(WorkTypename, "Border");
				   er.addStringValue(Workflowname, "Border");
				   er.addStringValue((String)requestNames.get(i), "Border");
		    	   er.addStringValue("", "Border");
			   	   er.addStringValue("", "Border");
		       }
		}
		if(requestIds.size()==0){
			   for(int i=0;i<nodeNames.size();i++){
				   er = es.newExcelRow();
				   er.addStringValue(WorkTypename, "Border");
				   er.addStringValue(Workflowname, "Border");
				   er.addStringValue("", "Border");
				   er.addStringValue((String)nodeNames.get(i), "Border");
				   er.addStringValue("", "Border");
			   }
		}
	}
}else if(exportProcess.equals("docWFReport")){//流程办理情况统计表


	title = getHtmlLabel(21899,user.getLanguage());
	int objType1 = Util.getIntValue(getParamValue(strSql,"objType"), 2);
	String objType = SystemEnv.getHtmlLabelName(124,user.getLanguage());
	switch (objType1) {
		case 1:
			objType = SystemEnv.getHtmlLabelName(1867, user.getLanguage());
		break;
		case 3:
			objType = SystemEnv.getHtmlLabelName(141, user.getLanguage());
		break;
	}
	er.addStringValue(objType, "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(430, user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(22486, user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(84787, user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(21971, user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(26861, user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(22487, user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(21911,user.getLanguage()), "Header");
	er.addStringValue(getHtmlLabel(21912,user.getLanguage()), "Header");
	String objIds = Util.null2String(getParamValue(strSql,"objId"));
	if(!"".equals(strSql) && !"".equals(objIds)){
		String ownDepid = resourceComInfo.getDepartmentID(""+user.getUID());
		String userRights = ReportAuthorization.getUserRights("-11", user);//得到用户查看范围
		if("".equals(objIds)){
			objIds = ownDepid;
		}
		if (!"".equals(objIds)) {		
			if (objIds.startsWith(",")) {
				objIds = objIds.replaceFirst(",", "");
			}
		}
		String sql4Right = "";
		if("".equals(userRights)) {
			sql4Right = objIds;
		} else {
			if (objType1 == 1) {//人力资源
				sql4Right = "select id from hrmresource where departmentid in ("+userRights+") and id in ("+objIds+")";
			} else if(objType1 == 2) {//部门
				sql4Right = "select id from hrmdepartment where id in ("+objIds+") and id in ("+userRights+")";
			} else if(objType1 == 3) {//分部
				sql4Right = "select subcompanyid1 as id from hrmdepartment where id in ("+userRights+") and subcompanyid1 in ("+objIds+")";
			}
		}

		String wfIds = Util.null2String(getParamValue(strSql, "wfId"));
		String sql = "";
		String datefrom = Util.toScreenToEdit(getParamValue(strSql,"datefrom"),user.getLanguage());
		String dateto = Util.toScreenToEdit(getParamValue(strSql,"dateto"),user.getLanguage());

		String sqlIsvalid = " and exists (select 1 from workflow_base where workflow_base.id=c.workflowid and isvalid in ('1','3') ) ";
		String sqlCondition = " and exists (select 1 from hrmresource where id=c.userid and hrmresource.status in (0,1,2,3) )";

		String wfSql = "";
		String timeSql1 = " ";//countType == 1
		String timeSql2 = " ";//countType == 2
		String timeSql3 = " ";//countType == 3
		String timeSql4 = " ";//countType == 4
		String timeSql5 = " ";//countType == 5
		String timeSql6 = " ";//countType == 6
		if(!"".equals(wfIds)){
			wfSql += " and c.workflowid in ("+wfIds + ") ";
		}
		if(!"".equals(datefrom)){
			timeSql2 += " and a.createdate >='"+datefrom+"' ";
			timeSql4 += " and c.receivedate >= '"+datefrom+"' ";
			timeSql5 += " and c.receivedate >= '"+datefrom+"' ";
			timeSql6 += " and c.receivedate >='"+datefrom+"' ";
		}
		if(!"".equals(dateto)){
			timeSql2 += " and a.createdate <='"+dateto+"' ";
			timeSql4 += " and c.receivedate <='"+dateto+"' ";
			timeSql5 += " and c.receivedate <='"+dateto+"' ";
			timeSql6 += " and c.receivedate <='"+dateto+"' ";
		}
		if(!"".equals(datefrom) && !"".equals(dateto)){
			timeSql1 += " and ((c.receivedate <='"+dateto+"' and c.receivedate >= '"+datefrom+"') or (c.operatedate <='"+dateto+"' and c.operatedate >= '"+datefrom+"')) ";
			timeSql3 += " and ((c.receivedate <='"+dateto+"' and c.receivedate >= '"+datefrom+"') or (c.operatedate <='"+dateto+"' and c.operatedate >= '"+datefrom+"')) ";
		}else if(!"".equals(datefrom)){
			timeSql1 += " and (c.receivedate >= '"+datefrom+"' or c.operatedate >= '"+datefrom+"') ";
			timeSql3 += " and (c.receivedate >= '"+datefrom+"' or c.operatedate >= '"+datefrom+"') ";
		}else if(!"".equals(dateto)){
			timeSql1 += " and (c.receivedate <='"+dateto+"' or c.operatedate <='"+dateto+"') ";
			timeSql3 += " and (c.receivedate <='"+dateto+"' or c.operatedate <='"+dateto+"') ";
		}
		if(!"".equals(timeSql6)){
			timeSql6 = " and exists (select c2.requestid from workflow_currentoperator c2 where c2.requestid=c.requestid and c2.isremark='4' ) " + timeSql6;
		}
		switch (objType1){
			case 1:
		        objType=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
		        sql = "(select count(distinct c.requestid) as count1, userid as id from workflow_currentoperator c where c.islasttimes=1 and workflowtype>1 and usertype='0'  and c.userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql1;
				sql += " group by userid) tab1";

				sql += " left join (select count(distinct a.requestid) as count2, a.creater as objid from workflow_currentoperator c, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0'  and a.creater in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql2;
				sql += " group by creater) tab2 on tab1.id=tab2.objid";

				sql += " left join (select count(distinct c.requestid) as count3, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0'  and c.userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql3;
				sql += " group by userid) tab3 on tab1.id=tab3.objid";

				sql += " left join (select count(distinct c.requestid) as count4, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in (0, 1, 5, 8, 9, 7) and viewtype=0 and workflowtype>1 and usertype='0'  and c.userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql4;
				sql += " group by userid) tab4 on tab1.id=tab4.objid";

				sql += " left join (select count(distinct c.requestid) as count5, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in (0, 1, 5, 8, 9, 7) and viewtype in (-1, -2) and workflowtype>1 and usertype='0'  and c.userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql5;
				sql += " group by userid) tab5 on tab1.id=tab5.objid";

				sql += " left join (select count(distinct c.requestid) as count6, userid as objid from workflow_currentoperator c where c.islasttimes=1 and workflowtype>1 and usertype='0'  and userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql6;
				sql += " group by userid) tab6 on tab1.id=tab6.objid";

		        break;
			case 2:
				objType=SystemEnv.getHtmlLabelName(124,user.getLanguage());
				sql = "(select count(distinct c.requestid) as count1, h.departmentid as id from workflow_currentoperator c, hrmresource h  where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql1;
		        sql += " group by h.departmentid) tab1";

				sql += " left join (select count(distinct a.requestid) as count2, h.departmentid as objid from workflow_currentoperator c, hrmresource h, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql2;
		        sql += " group by h.departmentid) tab2 on tab1.id=tab2.objid";

				sql += " left join (select count(distinct c.requestid) as count3, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql3;
		        sql += " group by h.departmentid) tab3 on tab1.id=tab3.objid";

				sql += " left join (select count(distinct c.requestid) as count4, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql4;
		        sql += " group by h.departmentid) tab4 on tab1.id=tab4.objid";

				sql += " left join (select count(distinct c.requestid) as count5, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql5;
		        sql += " group by h.departmentid) tab5 on tab1.id=tab5.objid";

				sql += " left join (select count(distinct c.requestid) as count6, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql6;
		        sql += " group by h.departmentid) tab6 on tab1.id=tab6.objid";

		        break;
			case 3:
		        objType=SystemEnv.getHtmlLabelName(141,user.getLanguage());
		        sql = "(select count(distinct c.requestid) as count1, h.subcompanyid1 as id from workflow_currentoperator c, hrmresource h  where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql1;
				sql += " group by h.subcompanyid1) tab1";

				sql += " left join (select count(distinct a.requestid) as count2, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql2;
				sql += " group by h.subcompanyid1) tab2 on tab1.id=tab2.objid";

				sql += " left join (select count(distinct c.requestid) as count3, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql3;
				sql += " group by h.subcompanyid1) tab3 on tab1.id=tab3.objid";

				sql += " left join (select count(distinct c.requestid) as count4, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql4;
				sql += " group by h.subcompanyid1) tab4 on tab1.id=tab4.objid";

				sql += " left join (select count(distinct c.requestid) as count5, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql5;
				sql += " group by h.subcompanyid1) tab5 on tab1.id=tab5.objid";

				sql += " left join (select count(distinct c.requestid) as count6, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
				sql += wfSql + timeSql6;
				sql += " group by h.subcompanyid1) tab6 on tab1.id=tab6.objid";

		        break;
		}
        //System.err.println("77777777777777777777777sql = "+sql);
		RecordSet.execute("select id,count1,count2,count3,count4,count5,count6 from " + sql + " order by id desc");
		while(RecordSet.next()) {
			er = es.newExcelRow();
			String id = Util.null2String(RecordSet.getString(1));
			int count1 = Util.getIntValue(RecordSet.getString(2), 0);
			int count2 = Util.getIntValue(RecordSet.getString(3), 0);
			int count3 = Util.getIntValue(RecordSet.getString(4), 0);
			int count4 = Util.getIntValue(RecordSet.getString(5), 0);
			int count5 = Util.getIntValue(RecordSet.getString(6), 0);
			int count6 = Util.getIntValue(RecordSet.getString(7), 0);
			double tmp_f;
			String rat1 = "0.00";
			String rat2 = "0.00";
			if(count1 > 0){
				tmp_f = count3 * 100D / count1;
				rat1 = Util.round(Double.toString(tmp_f), 2);
				tmp_f = count6 * 100D / count1;
				rat2 = Util.round(Double.toString(tmp_f), 2);
			}
			switch(objType1){
			case 1:
				er.addStringValue(resourceComInfo.getLastname(id), "Border");
				break;
			case 2:
				er.addStringValue(DepartmentComInfo.getDepartmentname(id), "Border");
				break;
			case 3:
				er.addStringValue(subCompanyComInfo.getSubCompanyname(id), "Border");
				break;				
			}
			er.addStringValue(""+count1, "Border");
			er.addStringValue(""+count2, "Border");
			er.addStringValue(""+count3, "Border");
			er.addStringValue(""+count4, "Border");
			er.addStringValue(""+count5, "Border");
			er.addStringValue(""+count6, "Border");
			er.addStringValue(rat1+"%", "Border");
			er.addStringValue(rat2+"%", "Border");
		}
	}
}
ExcelFile.setFilename(title);
ExcelFile.addSheet(title, es);
%>
<iframe name="ExcelOut" id="ExcelOut"  src="/weaver/weaver.file.ExcelOut" style="display:none" onload="jQuery('#loadingExcel').css('display','none');" onreadystatechange="jQuery('#loadingExcel').css('display','none');"></iframe>