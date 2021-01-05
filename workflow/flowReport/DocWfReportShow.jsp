
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="docWfReportSort" class="weaver.workflow.report.DocWfReportSort" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="timeUtil" class="weaver.general.TimeUtil" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />

		<style>
			.sbSelector:link {
				color: #000;
			}
			
			.e8_showNameClass a:link,.sbOptions a:link {
				color: #000;
			}
		</style>
	</head>

	<BODY>

<%
	String titlename = SystemEnv.getHtmlLabelName(21899,user.getLanguage());
	String userRights = ReportAuthorization.getUserRights("-11", user);//得到用户查看范围
	if(userRights.equals("-100")){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String isfrom = Util.null2String(request.getParameter("isfrom"));
	String objIds = Util.null2String(request.getParameter("objId"));
	String objType = SystemEnv.getHtmlLabelName(124,user.getLanguage());
	int objType1 = Util.getIntValue(request.getParameter("objType"), 2);
	if("".equals(objIds) && objType1 == 2){
		String ownDepid = resourceComInfo.getDepartmentID("" + user.getUID());
		objIds = ownDepid;
	}

	String objnameShow = "";
	if (!"".equals(objIds)) {
		if (objIds.startsWith(",")) {
			objIds = objIds.replaceFirst(",", "");
		}
		String[] objIdArr = objIds.split(",");
		switch (objType1){
			case 1:
				if (objIdArr.length == 1) {
					objnameShow = Util.toScreen(resourceComInfo.getLastname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(resourceComInfo.getLastname(objIdArr[i]), user.getLanguage()));
					}
					objnameShow = sb.toString();
				}
		      	break;
			case 2:
				if (objIdArr.length == 1) {
					objnameShow = Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[i]), user.getLanguage()));
					}
					objnameShow = sb.toString();
				}
				break;
			case 3:
				if (objIdArr.length == 1) {
					objnameShow = Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[i]), user.getLanguage()));
					}
					objnameShow = sb.toString();
				}
				break;
		}
	}

	String sql4Right = "";
	//==================================选的人员直接多于1000个处理=begin==================================
	StringBuffer sqlAppendIn = new StringBuffer("");
	String[] strArry = objIds.split(",");
	String sqlAppend = "";
	if(objType1 == 1 || objType1 == 2){
		if (strArry != null) {
			sqlAppendIn.append("id").append (" in ( ");
			for (int y = 0; y < strArry.length; y++) {
				sqlAppendIn.append("'").append(strArry[y] + "',");
				if ((y + 1) % 1000 == 0 && (y + 1) < strArry.length) {
					sqlAppendIn.deleteCharAt(sqlAppendIn.length() - 1);
					sqlAppendIn.append(" ) or ").append("id").append (" IN (");
				}
			}
			sqlAppendIn.deleteCharAt(sqlAppendIn.length() - 1);
			sqlAppendIn.append(" )");
		}
		sqlAppend = sqlAppendIn.toString();
	}else if(objType1 == 3){
		if (strArry != null) {
			sqlAppendIn.append("subcompanyid1").append (" in ( ");
			for (int y = 0; y < strArry.length; y++) {
				sqlAppendIn.append("'").append(strArry[y] + "',");
				if ((y + 1) % 1000 == 0 && (y + 1) < strArry.length) {
					sqlAppendIn.deleteCharAt(sqlAppendIn.length() - 1);
					sqlAppendIn.append(" ) or ").append("subcompanyid1").append (" IN (");
				}
			}
			sqlAppendIn.deleteCharAt(sqlAppendIn.length() - 1);
			sqlAppendIn.append(" )");
		}
		sqlAppend = sqlAppendIn.toString();
	}
	//RecordSet.writeLog(sqlAppend);
	//================================选的人员直接多于1000个处理=end=====================================
	if("".equals(userRights)) {
		sql4Right = objIds;
	} else {
		if(objType1 == 1){//人力资源
			sql4Right = "select id from hrmresource where departmentid in ("+userRights+") and "+sqlAppend;
		}else if(objType1 == 2){//部门
			sql4Right = "select id from hrmdepartment where id in ("+userRights+") and "+sqlAppend;
		}else if(objType1 == 3){//分部
			sql4Right = "select subcompanyid1 from hrmdepartment where id in ("+userRights+") and "+sqlAppend;
		}
	}

	String wfIds = Util.null2String(request.getParameter("wfId"));
	String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(wfIds);
	String wfNames = "";
	if (!"".equals(wfIds)) {
		if (wfIds.startsWith(",")) {
			wfIds = wfIds.replaceFirst(",", "");
		}
		String[] wfIdArr = wfIds.split(",");
		if (wfIdArr.length == 1) {
			wfNames = Util.toScreen(workflowComInfo.getWorkflowname(wfIdArr[0]), user.getLanguage());
		} else {
			StringBuilder sb = new StringBuilder();
			for(int i = 0; i < wfIdArr.length; i++) {
				if(i > 0){
					sb.append(",");
				}
				sb.append(Util.toScreen(workflowComInfo.getWorkflowname(wfIdArr[i]), user.getLanguage()));
			}
			wfNames = sb.toString();
		}
	}
	String sql = "";
	
	String datefrom = Util.toScreenToEdit(request.getParameter("datefrom"),user.getLanguage());
	String dateto = Util.toScreenToEdit(request.getParameter("dateto"),user.getLanguage());
	if("".equals(datefrom) && "".equals(dateto) && !"self".equals(isfrom)){
		datefrom = timeUtil.getDateByOption("3","0");
		dateto = timeUtil.getDateByOption("3","1");
	}
	
	String exportSQL = "wfId="+versionsIds+"+datefrom="+datefrom+"+dateto="+dateto+"+objType="+objType1+"+objId="+objIds;
	exportSQL = exportSQL.replaceAll("\\+", "%2B");

	String sqlCondition = " and exists (select 1 from hrmresource where id=c.userid and hrmresource.status in (0,1,2,3) )";
	String sqlIsvalid = " and exists (select 1 from workflow_base where workflow_base.id=c.workflowid and isvalid in ('1','3') ) ";

	String wfSql = "";
	String timeSql1 = " ";//countType == 1
	String timeSql2 = " ";//countType == 2
	String timeSql3 = " ";//countType == 3
	String timeSql4 = " ";//countType == 4
	String timeSql5 = " ";//countType == 5
	String timeSql6 = " ";//countType == 6
	String linkSql1 = "";
	String linkSql2 = "";
	String linkSql3 = "";
	String linkSql4 = "";
	String linkSql5 = "";
	String linkSql6 = "";
	if(!"".equals(versionsIds)){
		wfSql += " and c.workflowid in ("+ versionsIds + ") ";
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
			sql += " group by userid)  tab1";
			linkSql1 += " c.requestid=a.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql1 + " and c.userid=";

			sql += " left join (select count(distinct a.requestid) as count2, a.creater as objid from workflow_currentoperator c, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0'  and a.creater in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql2;
			sql += " group by creater)  tab2 on tab1.id=tab2.objid";
			linkSql2 += " c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql2 + " and a.creater=";

			sql += " left join (select count(distinct c.requestid) as count3, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in ('2', '4') and workflowtype>1 and usertype='0'  and c.userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql3;
			sql += " group by userid)  tab3 on tab1.id=tab3.objid";
			linkSql3 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in ('2', '4') and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql3 + " and c.userid=";

			sql += " left join (select count(distinct c.requestid) as count4, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in ('0', '1', '5', '8', '9', '7') and viewtype=0 and workflowtype>1 and usertype='0'  and c.userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql4;
			sql += " group by userid)  tab4 on tab1.id=tab4.objid";
			linkSql4 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in ('0', '1', '5', '8', '9', '7') and viewtype=0 and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql4 + " and c.userid=";

			sql += " left join (select count(distinct c.requestid) as count5, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in ('0', '1', '5', '8', '9', '7') and viewtype in (-1, -2) and workflowtype>1 and usertype='0'  and c.userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql5;
			sql += " group by userid)  tab5 on tab1.id=tab5.objid";
			linkSql5 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in ('0', '1', '5', '8', '9', '7') and viewtype in (-1, -2) and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql5 + " and c.userid=";

			sql += " left join (select count(distinct c.requestid) as count6, userid as objid from workflow_currentoperator c where c.islasttimes=1 and workflowtype>1 and usertype='0'  and userid in ("+sql4Right+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql6;
			sql += " group by userid)  tab6 on tab1.id=tab6.objid";
			linkSql6 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql6 + " and c.userid=";

	        break;
		case 2:
			objType=SystemEnv.getHtmlLabelName(124,user.getLanguage());
			sql = "(select count(distinct c.requestid) as count1, h.departmentid as id from workflow_currentoperator c, hrmresource h  where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql1;
	        sql += " group by h.departmentid)  tab1";
			linkSql1 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql1 + " and h.departmentid="; 

			sql += " left join (select count(distinct a.requestid) as count2, h.departmentid as objid from workflow_currentoperator c, hrmresource h, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql2;
	        sql += " group by h.departmentid)  tab2 on tab1.id=tab2.objid";
			linkSql2 += " c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater " + sqlCondition + " " + wfSql + timeSql2 + " and h.departmentid=";

			sql += " left join (select count(distinct c.requestid) as count3, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in ('2', '4') and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql3;
	        sql += " group by h.departmentid)  tab3 on tab1.id=tab3.objid";
			linkSql3 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in ('2', '4') and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql3 + " and h.departmentid=";

			sql += " left join (select count(distinct c.requestid) as count4, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in ('0', '1', '8', '9','7') and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql4;
	        sql += " group by h.departmentid)  tab4 on tab1.id=tab4.objid";
			linkSql4 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in ('0', '1', '8', '9','7') and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql4 + " and h.departmentid=";

			sql += " left join (select count(distinct c.requestid) as count5, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in ('0', '1', '8', '9','7') and viewtype in (-1, -2) and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql5;
	        sql += " group by h.departmentid)  tab5 on tab1.id=tab5.objid";
			linkSql5 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in ('0', '1', '8', '9','7') and viewtype in (-1, -2) and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql5 + " and h.departmentid=";

			sql += " left join (select count(distinct c.requestid) as count6, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql6;
	        sql += " group by h.departmentid)  tab6 on tab1.id=tab6.objid";
			linkSql6 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql6 + " and h.departmentid=";

	        break;
		case 3:
	        objType=SystemEnv.getHtmlLabelName(141,user.getLanguage());
	        sql = "(select count(distinct c.requestid) as count1, h.subcompanyid1 as id from workflow_currentoperator c, hrmresource h  where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql1;
			sql += " group by h.subcompanyid1)  tab1";
			linkSql1 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql1 + " and h.subcompanyid1 in ("+sql4Right+") and h.subcompanyid1=";

			sql += " left join (select count(distinct a.requestid) as count2, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql2;
			sql += " group by h.subcompanyid1)  tab2 on tab1.id=tab2.objid";
			linkSql2 += " c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater " + sqlCondition + " " + wfSql + timeSql2 + " and h.subcompanyid1 in ("+sql4Right+") and h.subcompanyid1=";

			sql += " left join (select count(distinct c.requestid) as count3, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in ('2', '4') and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql3;
			sql += " group by h.subcompanyid1)  tab3 on tab1.id=tab3.objid";
			linkSql3 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in ('2', '4') and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql3 + " and h.subcompanyid1 in ("+sql4Right+") and h.subcompanyid1=";

			sql += " left join (select count(distinct c.requestid) as count4, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in ('0', '1', '8', '9','7') and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql4;
			sql += " group by h.subcompanyid1)  tab4 on tab1.id=tab4.objid";
			linkSql4 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in ('0', '1', '8', '9','7') and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql4 + " and h.subcompanyid1 in ("+sql4Right+") and h.subcompanyid1=";

			sql += " left join (select count(distinct c.requestid) as count5, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in ('0', '1', '8', '9','7') and viewtype in (-1, -2) and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql5;
			sql += " group by h.subcompanyid1)  tab5 on tab1.id=tab5.objid";
			linkSql5 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in ('0', '1', '8', '9','7') and viewtype in (-1, -2) and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql5 + " and h.subcompanyid1 in ("+sql4Right+") and h.subcompanyid1=";

			sql += " left join (select count(distinct c.requestid) as count6, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.subcompanyid1 in ("+sql4Right+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql6;
			sql += " group by h.subcompanyid1)  tab6 on tab1.id=tab6.objid";
			linkSql6 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql6 + " and h.subcompanyid1 in ("+sql4Right+") and h.subcompanyid1=";

	        break;
	}

	String backfields = " id,count1,count2,count3,count4,count5,count6 ";
	String fromsqltemp = "workflow_requestbase a, workflow_currentoperator c, hrmresource h";
	String fromSQL = sql;
	if ("".equals(objIds)) {
		backfields = " 1 as id ";
		fromSQL = " from workflow_currentoperator where 1=2";
		exportSQL = "objType="+objType1;
	}
	String tableString = ""+
	"<table pageId=\""+PageIdConst.WF_FLOWREPORT_DOCWFREPORTSHOW+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FLOWREPORT_DOCWFREPORTSHOW,user.getUID())+"\" tabletype=\"none\">"+
	"<sql backfields=\""+backfields+"\" showCountColumn=\"false\" sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlorderby=\"id\" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqldistinct=\"true\" />"+
	"<head>"+
			 "<col width=\"20%\" text=\""+objType+"\" column=\"id\" transmethod=\"weaver.workflow.report.DocWfReportSort.getObjName\" otherpara=\""+objType1+"\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(430,user.getLanguage())+"\" column=\"count1\" transmethod=\"weaver.workflow.report.DocWfReportSort.getNumString\" href=\"DocWfList.jsp?gridTabletype=none&amp;fromsql="+docWfReportSort.replaceSql(xssUtil.put(fromsqltemp))+"&amp;sql=" + docWfReportSort.replaceSql(xssUtil.put(linkSql1)) + "\" linkkey=\"objId\" linkvaluecolumn=\"id\" target=\"_newlist\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(22486, user.getLanguage())+"\" column=\"count2\" transmethod=\"weaver.workflow.report.DocWfReportSort.getNumString\" href=\"DocWfList.jsp?gridTabletype=none&amp;fromsql="+docWfReportSort.replaceSql(xssUtil.put(fromsqltemp))+"&amp;sql=" + docWfReportSort.replaceSql(xssUtil.put(linkSql2)) + "\" linkkey=\"objId\" linkvaluecolumn=\"id\" target=\"_newlist\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(84787, user.getLanguage())+"\" column=\"count3\" transmethod=\"weaver.workflow.report.DocWfReportSort.getNumString\" href=\"DocWfList.jsp?gridTabletype=none&amp;fromsql="+docWfReportSort.replaceSql(xssUtil.put(fromsqltemp))+"&amp;sql=" + docWfReportSort.replaceSql(xssUtil.put(linkSql3)) + "\" linkkey=\"objId\" linkvaluecolumn=\"id\" target=\"_newlist\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(21971, user.getLanguage())+"\" column=\"count4\" transmethod=\"weaver.workflow.report.DocWfReportSort.getNumString\" href=\"DocWfList.jsp?gridTabletype=none&amp;fromsql="+docWfReportSort.replaceSql(xssUtil.put(fromsqltemp))+"&amp;sql=" + docWfReportSort.replaceSql(xssUtil.put(linkSql4)) + "\" linkkey=\"objId\" linkvaluecolumn=\"id\" target=\"_newlist\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(26861, user.getLanguage())+"\" column=\"count5\" transmethod=\"weaver.workflow.report.DocWfReportSort.getNumString\" href=\"DocWfList.jsp?gridTabletype=none&amp;fromsql="+docWfReportSort.replaceSql(xssUtil.put(fromsqltemp))+"&amp;sql=" + docWfReportSort.replaceSql(xssUtil.put(linkSql5)) + "\" linkkey=\"objId\" linkvaluecolumn=\"id\" target=\"_newlist\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(22487, user.getLanguage())+"\" column=\"count6\" transmethod=\"weaver.workflow.report.DocWfReportSort.getNumString\" href=\"DocWfList.jsp?gridTabletype=none&amp;fromsql="+docWfReportSort.replaceSql(xssUtil.put(fromsqltemp))+"&amp;sql=" + docWfReportSort.replaceSql(xssUtil.put(linkSql6)) + "\" linkkey=\"objId\" linkvaluecolumn=\"id\" target=\"_newlist\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(21911,user.getLanguage())+"\" column=\"count3\" transmethod=\"weaver.workflow.report.DocWfReportSort.getPercentString\" otherpara=\"column:count1\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(124830,user.getLanguage())+"\" />"+
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(21912,user.getLanguage())+"\" column=\"count6\" transmethod=\"weaver.workflow.report.DocWfReportSort.getPercentString\" otherpara=\"column:count1\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(124831,user.getLanguage())+"\" />"+
	"</head>"+
	"</table>";
%>

		<!-- start -->
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
					+ ",javascript:submitData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343, user.getLanguage()) +",javascript:doExportExcel(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage())%>" onClick="submitData();" />
					<input type="button" class="e8_btn_top" value=" <%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>" onClick="doExportExcel();" />
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div>
			<FORM id="frmMain" name="frmMain" action="DocWfReportShow.jsp?isfrom=self" method="post">
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FLOWREPORT_DOCWFREPORTSHOW %>"/>
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item>
							<%if (objType1==2) {%>
								<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>
							<%} else if (objType1==3) {%>
								<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>
							<%} else {%>
								<%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())%>
							<%}%>
							<input type="hidden" id="objType" name="objType" value="<%=objType1%>" />
						</wea:item>
						<wea:item>
							<brow:browser width="200px" viewType="0" name="objId" browserValue='<%=objIds%>' 
							    getBrowserUrlFn="getObjWindowUrl"
							    completeUrl="javascript:getAjaxUrl();"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput="2"
								browserSpanValue='<%=objnameShow%>'></brow:browser>
						</wea:item>
						
						<wea:item><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="wfId" 
								browserValue='<%=wfIds %>' 
					        	browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids=" 
					        	idKey="id" nameKey="name"  hasInput="true" width="80%" isSingle="false" 
					        	hasBrowser="true" isMustInput='1' completeUrl="/data.jsp?type=workflowBrowser"  
					        	browserSpanValue='<%=wfNames %>'>
					        </brow:browser>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(81517, user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="doccreatedateselect">
								<input class=wuiDateSel type="hidden" name="datefrom" value="<%=datefrom%>">
								<input class=wuiDateSel type="hidden" name="dateto" value="<%=dateto%>">
							</span>
						</wea:item>
					</wea:group>

					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	
						</wea:item>
					</wea:group>
				</wea:layout>
	
			</FORM>
		</div>

		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="docWFReport"></jsp:param>
			<jsp:param name="exportSQL" value="<%=exportSQL%>"></jsp:param>
		</jsp:include>
		<!-- end -->

	</body>

		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<script type="text/javascript">
	function doExportExcel() {
		exportExcel();
	}

	function getObjWindowUrl() {
		var objType1 = <%=objType1%>;
		if (objType1 == 2) {
			var tmpids = document.all('objId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else if (objType1 == 3) {
			var tmpids = document.all('objId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else {
			return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G('objId').value;
		}
	}

	function submitData() {
		if (check_form($G("frmMain"), 'objId')) {
			$G("frmMain").submit();
		}
	}

	function getAjaxUrl(){
		var objType1 = jQuery('#objType').val();
		var url = "";
		if (objType1 == 2) {
			url = "/data.jsp?type=4";
		} else if (objType1 == 3) {
			url = "/data.jsp?type=164";
		} else {
			url = "/data.jsp";
		}
		return url;
	}
</script>
</html>
