
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="WorkflowSearchCustom" class="weaver.workflow.search.WorkflowSearchCustom" scope="page"/>

<!--以下是显示定制组件所需的js -->
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>

		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 



		<style>

		.demotable{
		 color:#929393;
		}

         .demotable tr{
         /*border-bottom: 1px solid #f6f6f6;*/
		 
		 }

        .demotable tr td{
		  padding:10 15;
		  vertical-align: middle;
          text-align: left;
		}

		.demotable .Spacing td{
		  padding:0;
		  vertical-align: middle;
          text-align: left;
		}

		.demotable tr th{
		  padding:10 15;
          border-bottom: 3px solid #b7e0fe;
		  text-align: left;
		  color:#000000;
		}

        .demotable tbody tr:hover{
		   
		    color:#050505;
/*		    border-bottom: 1px solid #75bbf4;*/
		  
		}
        
	    .menuop
		{
		
		color:#b8b8b8;float:right;text-align:center;width:60px;background:#f6f6f6;height:36px;line-height:36px;cursor: pointer;		
		}
  
       .opinner{
	   
	   text-align:center;
	   margin:0 auto;
	   height:36px;
       width:40px;       
       line-height:36px;
	   color:#75bbf4;
	   }
       
	   .opinner:hover{
	   
	    
		color:#474747;
	   
	   }

	   TABLE.ViewForm TD {
		padding: 0 0 0 5;
		BACKGROUND-COLOR: #ffffff !important;
		}

		.ps-scrollbar-x{
		 width:0px !important;
		}


#div_pager{
	clear:both;
	height:30px;
	line-height:30px;
	margin-top:10px;
	color:#999999;
	font-family:'微软雅黑';
	font-weight:bold;
	float:right;
	width:540px;
}
.advancedSearchDiv .ViewForm {
 border-top: 0px  !important; 
margin-top: 15px !important;
}
#div_pager a{
	padding:4px 8px;
	margin:10px 3px;
	font-size:12px;
	border:1px solid #DFDFDF;
	background-color:#FFF;
	color:#9d9d9d;
	text-decoration:none;
}

#div_pager span{
	padding:4px 8px;
	margin:10px 3px;
	font-size:14px;
}

#div_pager span.disabled{
	padding:4px 8px;
	margin:10px 3px;
	font-size:12px;
	border:1px solid #DFDFDF;
	background-color:#FFF;
	color:#DFDFDF;
}

#div_pager span.curr{
	padding:4px 8px;
	margin:10px 3px;
	font-size:12px;
	border:1px solid #228ade;
	background-color:#228ade;
	color:#FFF;
}

#div_pager a:hover{
	background-color:#FFEEE5;
	border:1px solid #228ade;
}

#div_pager span.normalsize{
	font-size:13px;
}

	  </style>

	</head>
<%!
	private String getLike(HttpServletRequest request,String parameter){
		parameter=request.getParameter(parameter);
		if(parameter==null){
			parameter="'%'";
		}else{
			parameter="'%"+parameter+"%'";
		}
		return parameter;
	}
%>
	
<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统

	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
	<BODY>
	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<FORM id=weaver name=frmmain method=post action="WFSearchResult.jsp">
	<%
		//add by Dracula @2014-1-13
		int ownerdepartmentid = Util.getIntValue(request.getParameter("ownerdepartmentid"),0);
        int creatersubcompanyid=Util.getIntValue(request.getParameter("creatersubcompanyid"),0);
	    int unophrmid=Util.getIntValue(request.getParameter("unophrmid"),0);
		String recievedateselect = "";
		String datecondition = "";
		String recievedatefrom = "";
		String recievedateto = "";
		String createdatefrom = "";
		String createdateto = "";
		String operatedateselect = "";
		String operatedatefrom = "";
		String operatedateto = "";
		String processing = Util.null2String(request.getParameter("processing"));
		String scope = Util.null2String(request.getParameter("viewScope"));
		String urlType = "";
		if(scope.equals("doing"))
			urlType = "1";
		else if(scope.equals("done"))
			urlType = "2";
		else if(scope.equals("complete"))
			urlType = "3";
		else if(scope.equals("mine"))
			urlType = "4";
		else 
			urlType = "0";
		String archivestatus = "";
		//add by bpf 2013-11-07
		String flowTitle=getLike(request,"flowTitle");//流程名称
		String workflowid = "";
		String nodetype = "";
		String fromdate = "";
		String todate = "";
		String creatertype = "";
		String createrid = "";
		String createrid2= Util.null2String(request.getParameter("createrid2"));
		String requestlevel = "";
		String fromdate2 = "";
		String todate2 = "";
		String workcode = "";
		//urlType = Util.null2String(request.getParameter("urlType"));
		String querys = Util.null2String(request.getParameter("query"));
		String fromself = Util.null2String(request.getParameter("fromself"));
		//System.out.println("fromself:"+fromself);
		String fromselfSql = Util.null2String(request.getParameter("fromselfSql"));
		String isfirst = Util.null2String(request.getParameter("isfirst"));
		String docids = Util.null2String(request.getParameter("docids"));
		String flag = Util.null2String(request.getParameter("flag"));
		int date2during = Util.getIntValue(Util.null2String(request.getParameter("date2during")), 0);
		int viewType = Util.getIntValue(Util.null2String(request.getParameter("viewType")), 0);
		//增加一个页面时间维度的查询 add by Dracula @2014-1-9
		String timecondition = Util.null2String(request.getParameter("timecondition"));
		//System.out.println(timeCondition);
		String branchid = "";
		String cdepartmentid = "";
		//out.print(fromselfSql+"******");
		try {
			branchid = Util.null2String((String) session.getAttribute("branchid"));
		} catch (Exception e) {
			branchid = "";
		}
		int olddate2during = 0;
		BaseBean baseBean = new BaseBean();
		String date2durings = "";
		try {
			date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
		} catch (Exception e) {
		}
		String[] date2duringTokens = Util.TokenizerString2(date2durings, ",");
		if (date2duringTokens.length > 0) {
			olddate2during = Util.getIntValue(date2duringTokens[0], 0);
		}
		//add by xhheng @20050414 for TD 1545
		int iswaitdo = Util.getIntValue(request.getParameter("iswaitdo"), 0);
		int isovertime = Util.getIntValue(request.getParameter("isovertime"), 0);
		if (fromself.equals("1")) {
			SearchClause.resetClause(); //added by xwj for td2045 on2005-05-26 
			workflowid = Util.null2String(request.getParameter("workflowid"));
			nodetype = Util.null2String(request.getParameter("nodetype"));
			fromdate = Util.null2String(request.getParameter("fromdate"));
			todate = Util.null2String(request.getParameter("todate"));
			creatertype = Util.null2String(request.getParameter("creatertype"));
			createrid = Util.null2String(request.getParameter("createrid"));
			requestlevel = Util.null2String(request.getParameter("requestlevel"));
			fromdate2 = Util.null2String(request.getParameter("fromdate2"));
			todate2 = Util.null2String(request.getParameter("todate2"));
			workcode = Util.null2String(request.getParameter("workcode"));
			cdepartmentid = Util.null2String(request.getParameter("cdepartmentid"));
			recievedateselect = Util.null2String(request.getParameter("recievedateselect"));
			datecondition = Util.null2String(request.getParameter("createdateselect"));
			recievedatefrom = Util.null2String(request.getParameter("recievedatefrom"));
			recievedateto = Util.null2String(request.getParameter("recievedateto"));
			createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
			createdateto = Util.null2String(request.getParameter("createdateto"));
			operatedateselect = Util.null2String(request.getParameter("operatedateselect"));
			//System.out.println("this is operatedateselect====>"+operatedateselect);
		    operatedatefrom = Util.null2String(request.getParameter("operatedatefrom"));
		    operatedateto = Util.null2String(request.getParameter("operatedateto"));
			archivestatus = Util.null2String(request.getParameter("archivestatus"));
		} else {

			workflowid = SearchClause.getWorkflowId();
			nodetype = SearchClause.getNodeType();
			fromdate = SearchClause.getFromDate();
			todate = SearchClause.getToDate();
			creatertype = SearchClause.getCreaterType();
			createrid = SearchClause.getCreaterId();
			requestlevel = SearchClause.getRequestLevel();
			fromdate2 = SearchClause.getFromDate2();
			todate2 = SearchClause.getToDate2();
			cdepartmentid = SearchClause.getDepartmentid();
		}		

		/**自定义查询条件**/
		String customid=Util.null2String(request.getParameter("customname"));//查询条件id
		String customSearch="";
		String customResult="";
		if(!customid.equals("")){
			//添加了查询条件

			customSearch=WorkflowSearchCustom.getSearchCustomStr(RecordSet,customid,request);
			customResult=WorkflowSearchCustom.getResultCustomStr(RecordSet,customid,request);
		}
 
		String cdepartmentidspan = "";
		ArrayList cdepartmentidArr = Util.TokenizerString(cdepartmentid, ",");
		for (int i = 0; i < cdepartmentidArr.size(); i++) {
			String tempcdepartmentid = (String) cdepartmentidArr.get(i);
			if (cdepartmentidspan.equals(""))
				cdepartmentidspan += DepartmentComInfo.getDepartmentname(tempcdepartmentid);
			else
				cdepartmentidspan += "," + DepartmentComInfo.getDepartmentname(tempcdepartmentid);
		}

		String newsql = "";

		if (!workflowid.equals("") && !workflowid.equals("0"))
			newsql += " and t1.workflowid in(" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")";
		//增加时间维度查询条件 for ecology8 add by Dracula @2014-1-9
		
		if(!timecondition.equals(""))
		{
			 if("1".equals(timecondition))
			    newsql += " and t1.createdate>='" + TimeUtil.getToday()+ "'";
		       else
		       if("2".equals(timecondition))
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfWeek()+ "'";
		       else
		       if("3".equals(timecondition))
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfMonth()+ "'";
			   else
		       if("4".equals(timecondition))
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfSeason()+ "'";
			   else
		       if("5".equals(timecondition))
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfTheYear()+ "'";
				
		}
		if (date2during > 0 && date2during < 37)
			newsql += WorkflowComInfo.getDateDuringSql(date2during);
		if (fromself.equals("1")) {

			if (!nodetype.equals(""))
				newsql += " and t1.currentnodetype='" + nodetype + "'";

			if (!fromdate.equals(""))
				newsql += " and t1.createdate>='" + fromdate + "'";

			if (!todate.equals(""))
				newsql += " and t1.createdate<='" + todate + "'";

			if (!fromdate2.equals(""))
				newsql += " and t2.receivedate>='" + fromdate2 + "'";

			if (!todate2.equals(""))
				newsql += " and t2.receivedate<='" + todate2 + "'";

			if (!workcode.equals(""))
				newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%" + workcode + "%')";

		
			
			if (!cdepartmentid.equals("")) {
				String tempWhere = "";
				ArrayList tempArr = Util.TokenizerString(cdepartmentid, ",");
				for (int i = 0; i < tempArr.size(); i++) {
					String tempcdepartmentid = (String) tempArr.get(i);
					if (tempWhere.equals(""))
						tempWhere += "departmentid=" + tempcdepartmentid;
					else
						tempWhere += " or departmentid=" + tempcdepartmentid;
				}
				if (!tempWhere.equals(""))
					newsql += " and exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and (" + tempWhere + "))";
			}

			if (!requestlevel.equals("")) {
				newsql += " and t1.requestlevel=" + requestlevel;
			}

			if (!querys.equals("1")) {
				if (!fromselfSql.equals(""))
					newsql += " and " + fromselfSql;
			} else {
				if (fromself.equals("1"))
					newsql += " and  islasttimes=1 ";
			}

		}

		String CurrentUser = Util.null2String((String) session.getAttribute("RequestViewResource"));

		String userID = String.valueOf(user.getUID());
		String logintype = "" + user.getLogintype();
		int usertype = 0;
		if (logintype.equals("2"))
			usertype = 1;
		if (CurrentUser.equals("")) {
			CurrentUser = "" + user.getUID();
		}
		boolean superior = false; //是否为被查看者上级或者本身

		if (userID.equals(CurrentUser)) {
			superior = true;
		} else {
			RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND managerStr LIKE '%" + userID + "%'");

			if (RecordSet.next()) {
				superior = true;
			}
		}

		String sqlwhere = "";
		//System.out.println("tablesql-3："+sqlwhere);
		if (isovertime == 1) {
			sqlwhere = "where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.id in (Select max(z1.id) from workflow_currentoperator z1 where exists(select 1 from SysPoppupRemindInfonew z2 where  z1.requestid=z2.requestid and z2.type=10 and z2.userid = "
					+ user.getUID()
					+ " and z2.usertype='"
					+ (Util.getIntValue(logintype, 1) - 1)
					+ "' and exists (select 1 from workflow_currentoperator z3 where z2.requestid=z3.requestid and ((z3.isremark='0' and (z3.isprocessed='2' or z3.isprocessed='3' or z3.isprocessed is null))  or z3.isremark='5') and z3.islasttimes=1)) group by z1.requestid)";
		} else {
			if (superior && !flag.equals(""))
				CurrentUser = userID;
			sqlwhere = "where  (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.userid = " + CurrentUser + " and t2.usertype=" + usertype;
			if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
				sqlwhere += " and " + SearchClause.getWhereClause();
				//out.print("sql***********"+SearchClause.getWhereClause());
			}
		}
		
		if (RecordSet.getDBType().equals("oracle")) {
			sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater=" + user.getUID() + ")) ";
		} else {
			sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater=" + user.getUID() + ")) ";
		}
		String orderby = "";
		//String orderby2 = "";

			//高级搜索条件
	    WfAdvanceSearchUtil  conditionutil=new  WfAdvanceSearchUtil(request,RecordSet);
	   
	    String conditions="";
	    if(processing.equals("0"))
	    {
	    	conditions = conditionutil.getAdVanceSearch4PendingCondition();
	    }else
	    {
	    	conditions = conditionutil.getAdVanceSearch4OtherCondition();
	    }
	   
	
	    if(!conditions.equals(""))
		{
	    	creatertype = "0";
		 	newsql += conditions;
		}
     	
		
		sqlwhere += " " + newsql;
		//System.out.println("tablesql-2："+sqlwhere);
		//orderby=" t1.createdate,t1.createtime,t1.requestlevel";
		orderby = SearchClause.getOrderClause();
		if (orderby.equals("")) {
			orderby = "t2.receivedate ,t2.receivetime";
		}
		//orderby2=" order by t1.createdate,t1.createtime,t1.requestlevel";

		//String tablename = "wrktablename"+ Util.getRandom() ;
		//System.out.println("tablesql-1："+sqlwhere);
		int start = Util.getIntValue(Util.null2String(request.getParameter("start")), 1);
		String sql = "";
		int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")), 0);

		//add by xhheng @ 20050302 for TD 1545
		String strworkflowid = "";
		int startIndex = 0;

		String fromhp = Util.null2String(request.getParameter("fromhp"));
		if (fromhp.equals("1")) {
			String eid = Util.null2String(request.getParameter("eid"));
			String tabid = Util.null2String(request.getParameter("tabid"));
			RecordSet.execute("select count(content) as count from workflowcentersettingdetail where  type = 'flowid' and eid=" + eid + "and tabId = '" + tabid + "'");
			if (RecordSet.next()) {
				if (RecordSet.getInt("count") > 0) {
					strworkflowid = " in (select content from workflowcentersettingdetail where  type = 'flowid' and eid=" + eid + "and tabId = '" + tabid + "' )";
				}
			}
		} else {

			if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
				String tempstr = SearchClause.getWhereClause();
				if (tempstr.indexOf("t1.workflowid") != -1) {
					startIndex = tempstr.indexOf("t1.workflowid") + 13;//added by xwj for td2045 on 2005-05-26
					if (tempstr.indexOf("and") != -1) {
						if (tempstr.indexOf("(t1.deleted=0") != -1) {
							int startIndex1 = tempstr.indexOf("and");
							int startIndex2 = tempstr.indexOf("and", startIndex1 + 1);
							strworkflowid = tempstr.substring(startIndex, startIndex2);
						} else {
							strworkflowid = tempstr.substring(startIndex, tempstr.indexOf("and"));
						}
						if (strworkflowid.indexOf("(") != -1 && strworkflowid.indexOf(")") == -1)
							strworkflowid += ")";
					} else
						strworkflowid = tempstr.substring(startIndex, tempstr.indexOf(")") + 1);
					if (strworkflowid.indexOf("(") != -1 && strworkflowid.indexOf(")") == -1)
						strworkflowid += ")";
				}
				//System.out.println("strworkflowid1 = " + strworkflowid);
			} else {
				if (!workflowid.equals(""))
					strworkflowid = " in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")";
			}
		}
		//System.out.println("tablesql0："+sqlwhere);
		//System.out.println("strworkflowid2 = " + strworkflowid);
		if (strworkflowid.equals("")) {
			RecordSet.executeSql("select count(id) as mtcount from workflow_base where multiSubmit=1");
		} else {
			RecordSet.executeSql("select count(id) as mtcount from workflow_base where id " + strworkflowid + " and multiSubmit=1");
		}
		boolean isMultiSubmit = false;
		if (RecordSet.next()) {
			if (RecordSet.getInt("mtcount") > 0) {
				isMultiSubmit = true;
			}
		}

		int perpage = 10;
		boolean hascreatetime = true;
		boolean hascreater = true;
		boolean hasworkflowname = true;
		boolean hasrequestlevel = true;
		boolean hasrequestname = true;
		boolean hasreceivetime = true;
		boolean hasstatus = true;
		boolean hasreceivedpersons = true;
		boolean hascurrentnode = true;
		RecordSet.executeProc("workflow_RUserDefault_Select", "" + user.getUID());
		if (RecordSet.next()) {
			if (!Util.null2String(RecordSet.getString("hascreatetime")).equals("1"))
				hascreatetime = false;
			if (!Util.null2String(RecordSet.getString("hascreater")).equals("1"))
				hascreater = false;
			if (!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1"))
				hasworkflowname = false;
			if (!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1"))
				hasrequestlevel = false;
			if (!Util.null2String(RecordSet.getString("hasrequestname")).equals("1"))
				hasrequestname = false;
			if (!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1"))
				hasreceivetime = false;
			if (!Util.null2String(RecordSet.getString("hasstatus")).equals("1"))
				hasstatus = false;
			if (!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1"))
				hasreceivedpersons = false;
			if (!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1"))
				hascurrentnode = false;
			perpage = RecordSet.getInt("numperpage");
		} else {
			RecordSet.executeProc("workflow_RUserDefault_Select", "1");
			if (RecordSet.next()) {
				if (!Util.null2String(RecordSet.getString("hascreatetime")).equals("1"))
					hascreatetime = false;
				if (!Util.null2String(RecordSet.getString("hascreater")).equals("1"))
					hascreater = false;
				if (!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1"))
					hasworkflowname = false;
				if (!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1"))
					hasrequestlevel = false;
				if (!Util.null2String(RecordSet.getString("hasrequestname")).equals("1"))
					hasrequestname = false;
				if (!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1"))
					hasreceivetime = false;
				if (!Util.null2String(RecordSet.getString("hasstatus")).equals("1"))
					hasstatus = false;
				if (!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1"))
					hasreceivedpersons = false;
				if (!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1"))
					hascurrentnode = false;
				perpage = RecordSet.getInt("numperpage");
			}
		}
		
		
		//System.out.println("hascreatetime:"+hascreatetime+";hascreater:"+hascreater);

		/*如果所有的列都不显示，那么就显示所有的，避免页面出错*/
		if (!hascreatetime && !hascreater && !hasworkflowname && !hasrequestlevel && !hasrequestname && !hasreceivetime && !hasstatus && !hasreceivedpersons && !hascurrentnode) {
			hascreatetime = true;
			hascreater = true;
			hasworkflowname = true;
			hasrequestlevel = true;
			hasrequestname = true;
			hasreceivetime = true;
			hasstatus = true;
			hasreceivedpersons = true;
			hascurrentnode = true;
		}

		//update by fanggsh 20060711 for TD4532 begin
		boolean hasSubWorkflow = false;
		//System.out.println("tablesql1："+sqlwhere);
		if (workflowid != null && !workflowid.equals("") && workflowid.indexOf(",") == -1) {
			RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId=" + workflowid);
			if (RecordSet.next()) {
				hasSubWorkflow = true;
			}

			RecordSet.executeSql("select id from Workflow_TriDiffWfDiffField where mainWorkflowId=" + workflowid);
			if (RecordSet.next()) {
				hasSubWorkflow = true;
			}
		}
		//System.out.println("tablesql2："+sqlwhere);

		//update by fanggsh 20060711 for TD4532 end

		//RecordSet.executeSql(sqltemp);
		//RecordSet.executeSql("drop table "+tablename);

		RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:OnSearch(),_self}";
		RCMenuHeight += RCMenuHeightStep;
		//RCMenu += "{" + SystemEnv.getHtmlLabelName(364, user.getLanguage()) + ",WFSearch.jsp?iswaitdo=" + iswaitdo + "&date2during=" + olddate2during + ",_self}";
		RCMenuHeight += RCMenuHeightStep;
		if (isMultiSubmit && iswaitdo == 1) {
			RCMenu += "{" + SystemEnv.getHtmlLabelName(17598, user.getLanguage()) + ",javascript:OnMultiSubmitNew(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
		
		String pageId = "";
		
	%>
		<%@ include file="/workflow/search/demo/TopTitle.jsp" %>
		
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />

		<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />

	    <script type="text/javascript" src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
		
		<script type="text/javascript" src="/js/ecology8/request/wfSearchResult_wev8.js"></script>



<link rel="stylesheet" href="/workflow/search/demo/select/style/reset_wev8.css">
	<link rel="stylesheet" href="/workflow/search/demo/select/style/selectForK13_wev8.css">
	<script type="text/javascript" src="/workflow/search/demo/select/script/selectForK13_wev8.js"></script>


	<table id="topTitle" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(17598, user.getLanguage())%>" style="font-size:12px" class="e8_btn_top middle" onclick="OnMultiSubmitNew(this)">
					&nbsp;&nbsp;&nbsp;
					<input type="text" class="searchInput" value="" name="flowTitle"/>
					&nbsp;&nbsp;
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv">
			<span class="toggleLeft" title="<%=SystemEnv.getHtmlLabelName(84031,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></span>
			<span id="hoverBtnSpan"><span doingType="flowAll"><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></span><span doingType="flowNew"><%=SystemEnv.getHtmlLabelName(83697,user.getLanguage())%></span><span doingType="flowResponse"><%=SystemEnv.getHtmlLabelName(31808,user.getLanguage())%></span><span doingType="flowOut"><%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%></span><span doingType="flowIntend"><%=SystemEnv.getHtmlLabelName(33220,user.getLanguage())%></span></span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(17598,user.getLanguage())%>" class="e8_btn_top" />
		</div>
		<div id="dialog" style="display:none;">
			<div id='colShow'></div>
		</div>
		<!-- bpf start 2013-10-29 -->
		<div class="cornerMenuDiv"></div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			<iframe src="./demo/addwf1.jsp.htm" id="" name="" class="flowFrame" frameborder="0" height="285px" width="100%;"></iframe>
		</div>
		
		<!-- bpf end 2013-10-29 -->
		

			<div id='divshowreceivied' style='background: #FFFFFF; padding: 3px; width: 100%' valign='top'></div>
			<input type="hidden" name="fromself" value="<%=fromself%>">
			<input type="hidden" name="isfirst" value="<%=isfirst%>">
			<input type="hidden" name="fromselfSql" value="<%if(!"1".equals(isfirst)){%><%=SearchClause.getWhereClause()%><%}else{%><%=fromselfSql%><%}%>">
			<input name="iswaitdo" type="hidden" value="<%=iswaitdo%>">
			<input name="query" type="hidden" value="<%=querys%>">
			<input type="hidden" name="docids" value="<%=docids%>">
			<input type="hidden" name="isovertime" value="<%=isovertime%>">
			<input type="hidden" name="viewType" value="<%=viewType%>">
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.getWFPageId(urlType) %>"/>
			<%-- add by bpf on 2013-11-13 --%>
			<!-- 
			<input type="hidden" name="viewScope" value="${param.viewScope }">
			<input type="hidden" name="numberType" value="${param.numberType }">
			-->
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>">
					<% 
				}
			
			%>
			
			



          <div>

		    <div>
			<table class='demotable'  width=100%  style='border-collapse: collapse;' cellspacing="0" cellpadding="0">
               <col style='width:15%'>
			   <col style='width:35%'>
			   <col style='width:20%'>
			   <col style='width:10%'>
			   <col style='width:20%'>
			   
			   <thead>
			   <!--
			      <th style="border-bottom:2px solid rgb(102,120,177)!important;">创建人</th>
				  <th style="border-bottom:2px solid rgb(102,120,177)!important;">请求标题</th>
				  <th style="border-bottom:2px solid rgb(102,120,177)!important;">接收日期</th>
				  <th style="border-bottom:2px solid rgb(102,120,177)!important;">当前节点</th>
				  <th style="border-bottom:2px solid rgb(102,120,177)!important;">紧急程度</th>

				  -->
				  <th style="border-width:2px!important;"><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></th>
				  <th style="border-width:2px!important;"><%=SystemEnv.getHtmlLabelName(1334, user.getLanguage())%></th>
				  <th style="border-width:2px!important;"><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%></th>
				  <th style="border-width:2px!important;"><%=SystemEnv.getHtmlLabelName(18564, user.getLanguage())%></th>
				  <th style="border-width:2px!important;"><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></th>
			   </thead>
               <tbody>
<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div style="height:1px!important;"></div></td></tr>
                  <tr><td>张三</td>

					<td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">
					
					<span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span">
					
					
					</span>
					</td>
					<td>2014-09-01</td><td>审批</td><td>正常</td></tr>


<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr>

				<tr><td>李四</td>
				<td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td>
				
				<td>2014-09-01</td><td>审批</td><td>正常</td></tr>
				  <tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr><tr><td>王五</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
				  <tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr><tr><td>老刘</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr>				  <tr><td>校长</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr>				  <tr><td>张三</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr>				   <tr><td>张三</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr>				<tr><td>李四</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr>				  <tr><td>王五</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
<tr class="Spacing" style="height:1px;"><td colspan="5" style="padding-left:10px;"><div class="intervalDivClass"></div></td></tr>				  <tr><td>老刘</td><td align="left" title="kkkkkkkkk" style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;"><span style="cursor:pointer;" onclick="javaScript:openFullWindowHaveBarForWFList('/workflow/search/demo/demo1/addwf0.jsp.htm',477)">内部留言:办公室申请</span><span id="wflist_477span"></span></td><td>2014-09-01</td><td>审批</td><td>正常</td></tr>
				 
				<tr class="Spacing" style="height:1px;"><td class="Line intervalDivClass" colspan="5"></td></tr>
              </tbody>
    


			</table>

           <script>




         



              $(".demotable").mouseout(function(e){

				   //  if($(".itemmenu").length>0 && !isitemmouseover)
                   //       $(".itemmenu").remove();
			      //alert("aaaa");
		     });

 

                     var isopen=false;
					   $(".moredatashow").click(function(){
				            if(!isopen)
					   	   {
							  $(".itemmore").show();
                               isopen=true;
							}
							else
						   {
							 $(".itemmore").hide();
                               isopen=false;
							}
				 	   
					   });
			  

 
 



               $(".demotable tbody tr").not(".Spacing").hover(function(e){
			     
				       if($(".itemmenu").length>0)
                          $(".itemmenu").remove();
		               var offset=$(this).offset();
                       var dwidth=$(this).css("width");
					 //  $(this).addClass("trborder");
                      dwidth=parseFloat(dwidth.substring(0,dwidth.indexOf("p")));
					   
					   var floatdiv=$("<div class='itemmenu' style='position:absolute;background:#def0ff;'><div class='menuop'><div class='opinner'>转发</div></div><div class='menuop'><div class='opinner'>打印</div></div></div>");
                      
					   floatdiv.css("left",(offset.left+dwidth-120));
					   floatdiv.css("top",offset.top);

                       floatdiv.css("width","120px");
                       floatdiv.css("height",($(this).height())+"px");
                       jQuery($(this).children("TD")[0]).append(floatdiv);
					   try  {
					   $(this).next("TR.Spacing").children("TD").children("div").addClass("intervalHoverClass");
					   } catch (e) {}
					   $(this).next("TR.Spacing").children("TD.Line").addClass("intervalHoverClass");
			   
			   }, function (e) {
try { 
										//alert($(this).next("TR.Spacing").html());

				
					
} catch(e) {}
$(".itemmenu").remove();
$(this).next("TR.Spacing").children("TD").children("div").removeClass("intervalHoverClass");
						$(this).next("TR.Spacing").children("TD.Line").removeClass("intervalHoverClass");
			   });
                  

		   </script>




			</div>

			<div id="div_pager2">
			
			<br>
			<style type="text/css">
				.numberspan {
					display:inline-block;width:30px;height:30px;text-align:center;line-height:30px;color:#666666;
					font-size:12px;
					cursor:pointer;
				}
				.currentNumberspan {
					background-color:#5b5b5b;
					color:#fff;
				}
				.jumpbutton {
					display:inline-block;
					width:30px;
					height:30px;
					text-align:center;
					line-height:30px;
					background-color:#e4e4e4;
					color:#2597f0;
					cursor:pointer;
					padding: 0 5px;
				}
				.splitpageinfo {
					display:inline-block;
					TEXT-DECORATION:none;
					height:30px;
					line-height:30px;
					background-color:#4f9726;
					color:#fff;
					padding: 0 10px 0 0;
				}

				.pagenumberinput {
					text-align:right;
					line-height:20px;
					height:20px;
					widht:30px;
					border:none;
					border:1px solid rgb(186, 186, 186);
					background:none;
				}
				.demotable a {
					color:#929393;
				}

				.intervalDivClass {
height:1px!important;background-color:#E6E6E6;
}

.intervalHoverClass {
	background-color:#75bbf4!important;
}
			</style>
			

			<div align="right" style="">
				<span style="display:inline-block; height:30px;border:1px solid #dddddd;padding-left:10px;">
					<span style="font-size:18px;color:#666666;"><</span>
					<span class="numberspan">1</span>
					<span class="numberspan currentNumberspan">2</span>
					<span class="numberspan">3</span>
					<span class="numberspan">4</span>
					<span class="numberspan">5</span>
					<span style="font-size:18px;color:#666666;">></span>&nbsp;&nbsp;
					<span style="TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;">
						第

						
					</span>
					


	
<span id="go_page_wrap" style="display: inline-block; width: 30px; height: 20px; border: 1px solid #fff; margin: 0px 1px; padding: 0px; position: relative; left: 0px; top:-2px;">

&nbsp;
<input type="button" id="btn_go" onclick="" style="cursor:pointer;width: 44px; height: 22px; line-height: 20px; padding: 0px; text-align: center; border: 0px; background-color: rgb(0, 99, 220); color: rgb(255, 255, 255); position: absolute; left: 0px; top: -1px; display: none;" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>">
<input type="text" id="btn_go_input" onfocus="kkpager.focus_gopage()" onkeypress="if(event.keyCode&lt;48 || event.keyCode&gt;57)return false;" onblur="kkpager.blur_gopage()" style="color:#666666;width:30px;height:18px;line-height:18px;text-align:center;border:0px;position:absolute;left:0px;top:0px;outline:none;border:1px solid #fff;" value="2" hidefocus="true"></span>
<span style="TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;">
						
						页

					</span>
<!--
					<span id="pagesize" style="display:inline-block;width:30px;height:30px;line-height:30px;">
							10

						</span>


									<ul id="searchblock" style="position:absolute;">
											
												
												<li>10条</li>
												<li>20条</li>
												<li>50条</li>
												<li>100条</li>
	
											</ul>
-->




					<span class="splitpageinfo">



<select id="pagesize" style="display:none;">
<option value="20" >10</option>
	<option value="20" >20</option>
	<option value="50" selected="selected">50</option>
	<option value="100">100</option>
</select>


条/页


					
					&nbsp;|&nbsp;
					共95条

					<!--
					<select >
						<option>10</option>
						<option>20</option>
						<option>50</option>
					</select>-->
					</span>
				</span>
				<script type="text/javascript">
				
				jQuery(function () {
					
					$("#pagesize").selectForK13({
						"width":"40px"
					});

					$(".numberspan").bind("click", function () {
						$(".numberspan").removeClass("currentNumberspan");
						$(this).addClass("currentNumberspan");
					});
					
				});
				</script>
			
			</div>
<br>
<br>
<div id="zhegaidiv" style="height:340px;width:100%;position: absolute;z-index:1;background:#DCE2F1;filter:alpha(opacity=60);opacity:0.6;left:0px;top:285px;display:none;"></div>
<style type="text/css">
#selectblock ul li {
	height:30px;
	text-align:center;
	border-top:1px solid #dddddd;
	border-left:1px solid #dddddd;
	border-right:1px solid #dddddd;
	line-height:30px;
	background-color:#d7dce0;
}
.lislt {
	background-color:#16bE9b!important;
	color:#fff;
	cursor:pointer;
}
</style>

<script type="text/javascript">
	jQuery(function () {
		jQuery("#selectblock ul li").hover(function () {
			$(this).addClass("lislt");
		}, function () {
			$(this).removeClass("lislt");
		});
		jQuery("#test2").bind("click", function () {
			$("selectblock").show();
		});

	});

</script>
<!--
<span id="test2">10条</span>
<div style="position:absolute;width:50px;border-bottom:1px solid #dddddd;display:none;" id="selectblock">
	<ul>
		<li>10条</li>
		<li>20条</li>
		<li>50条</li>
		<li>100条</li>
	</ul>
</div>
-->

			<script type="text/javascript">
var kkpager = {
		//divID
		pagerid : 'div_pager',
		//当前页码
		pno : 1,
		//总页码

		total : 1,
		//总数据条数

		totalRecords : 0,
		//是否显示总页数

		isShowTotalPage : true,
		//是否显示总记录数
		isShowTotalRecords : true,
		//是否显示页码跳转输入框

		isGoPage : true,
		//链接前部
		hrefFormer : '',
		//链接尾部
		hrefLatter : '',
		/****链接算法****/
		getLink : function(n){
			//这里的算法适用于比如：
			//hrefFormer=http://www.xx.com/news/20131212
			//hrefLatter=.html
			//那么首页（第1页）就是http://www.xx.com/news/20131212.html
			//第2页就是http://www.xx.com/news/20131212_2.html
			//第n页就是http://www.xx.com/news/20131212_n.html
			if(n == 1){
				return this.hrefFormer + this.hrefLatter;
			}else{
				return this.hrefFormer + '_' + n + this.hrefLatter;
			}
		},
		//跳转框得到输入焦点时
		focus_gopage : function (){
			var btnGo = $('#btn_go');
			$('#btn_go_input').attr('hideFocus',true);
			btnGo.show();
			btnGo.css('left','0px');
			$('#go_page_wrap').css('border-color','#6694E3');
			btnGo.animate({left: '+=30'}, 50,function(){
				//$('#go_page_wrap').css('width','88px');
			});
		},
		
		//跳转框失去输入焦点时

		blur_gopage : function(){
			setTimeout(function(){
				var btnGo = $('#btn_go');
				//$('#go_page_wrap').css('width','44px');
				btnGo.animate({
				    left: '-=44'
				  }, 100, function() {
					  $('#btn_go').css('left','0px');
					  $('#btn_go').hide();
					  $('#go_page_wrap').css('border-color','fff');
				  });
			},400);
		},
		//跳转框页面跳转

		gopage : function(){
			var str_page = $("#btn_go_input").val();
			if(isNaN(str_page)){
				$("#btn_go_input").val(this.next);
				return;
			}
			var n = parseInt(str_page);
			if(n < 1 || n >this.total){
				$("#btn_go_input").val(this.next);
				return;
			}
			//这里可以按需改window.open
			window.location = this.getLink(n);
		},
		//分页按钮控件初始化

		init : function(config){
			//赋值

			this.pno = isNaN(config.pno) ? 1 : parseInt(config.pno);
			this.total = isNaN(config.total) ? 1 : parseInt(config.total);
			this.totalRecords = isNaN(config.totalRecords) ? 0 : parseInt(config.totalRecords);
			if(config.pagerid){this.pagerid = pagerid;}
			if(config.isShowTotalPage != undefined){this.isShowTotalPage=config.isShowTotalPage;}
			if(config.isShowTotalRecords != undefined){this.isShowTotalRecords=config.isShowTotalRecords;}
			if(config.isGoPage != undefined){this.isGoPage=config.isGoPage;}
			this.hrefFormer = config.hrefFormer || '';
			this.hrefLatter = config.hrefLatter || '';
			if(config.getLink && typeof(config.getLink) == 'function'){this.getLink = config.getLink;}
			//验证
			if(this.pno < 1) this.pno = 1;
			this.total = (this.total <= 1) ? 1: this.total;
			if(this.pno > this.total) this.pno = this.total;
			this.prv = (this.pno<=2) ? 1 : (this.pno-1);
			this.next = (this.pno >= this.total-1) ? this.total : (this.pno + 1);
			this.hasPrv = (this.pno > 1);
			this.hasNext = (this.pno < this.total);
			
			this.inited = true;
		},
		//生成分页控件Html
		generPageHtml : function(){
			if(!this.inited){
				return;
			}
			
			var str_prv='',str_next='';
			if(this.hasPrv){
				str_prv = '<a href="'+this.getLink(this.prv)+'" title="<%=SystemEnv.getHtmlLabelName(26029,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(26029,user.getLanguage())%></a>';
			}else{
				str_prv = '<span class="disabled"><%=SystemEnv.getHtmlLabelName(26029,user.getLanguage())%></span>';
			}
			
			if(this.hasNext){
				str_next = '<a href="'+this.getLink(this.next)+'" title="<%=SystemEnv.getHtmlLabelName(26028,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(26028,user.getLanguage())%></a>';
			}else{
				str_next = '<span class="disabled"><%=SystemEnv.getHtmlLabelName(26028,user.getLanguage())%></span>';
			}
			
			
			var str = '';
			var dot = '<span>...</span>';
			var total_info='';
			if(this.isShowTotalPage || this.isShowTotalRecords){
				total_info = '<span class="normalsize"><%=SystemEnv.getHtmlLabelName(83698,user.getLanguage())%>';
				if(this.isShowTotalPage){
					total_info += this.total+'<%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>';
					if(this.isShowTotalRecords){
						total_info += '&nbsp;/&nbsp;';
					}
				}
				if(this.isShowTotalRecords){
					total_info += this.totalRecords+'<%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>';
				}
				
				total_info += '</span>';
			}
			
			var gopage_info = '';
			if(this.isGoPage){
				gopage_info = '<span  ><%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%></span><span id="go_page_wrap" style="display:inline-block;width:44px;height:18px;border:1px solid #DFDFDF;margin:0px 1px;padding:0px;position:relative;left:0px;top:5px;">'+
					'<input type="button" id="btn_go" onclick="kkpager.gopage();" style="width:44px;height:20px;line-height:20px;padding:0px;font-family:arial,宋体,sans-serif;text-align:center;border:0px;background-color:#0063DC;color:#FFF;position:absolute;left:0px;top:-1px;display:none;" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" />'+
					'<input type="text" id="btn_go_input" onfocus="kkpager.focus_gopage()" onkeypress="if(event.keyCode<48 || event.keyCode>57)return false;" onblur="kkpager.blur_gopage()" style="width:42px;height:18px;text-align:center;border:0px;position:absolute;left:0px;top:0px;outline:none;" value="'+this.next+'" /></span> <%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>';
			}
			
			//分页处理
			if(this.total <= 8){
				for(var i=1;i<=this.total;i++){
					if(this.pno == i){
						str += '<span class="curr">'+i+'</span>';
					}else{
						str += '<a  title="<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>'+i+'<%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>">'+i+'</a>';
					}
				}
			}else{
				if(this.pno <= 5){
					for(var i=1;i<=7;i++){
						if(this.pno == i){
							str += '<span class="curr">'+i+'</span>';
						}else{
							str += '<a  title="<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>'+i+'<%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>">'+i+'</a>';
						}
					}
					str += dot;
				}else{
					str += '<a  title="<%=SystemEnv.getHtmlLabelName(84558,user.getLanguage())%>">1</a>';
					str += '<a  title="<%=SystemEnv.getHtmlLabelName(84559,user.getLanguage())%>">2</a>';
					str += dot;
					
					var begin = this.pno - 2;
					var end = this.pno + 2;
					if(end > this.total){
						end = this.total;
						begin = end - 4;
						if(this.pno - begin < 2){
							begin = begin-1;
						}
					}else if(end + 1 == this.total){
						end = this.total;
					}
					for(var i=begin;i<=end;i++){
						if(this.pno == i){
							str += '<span class="curr">'+i+'</span>';
						}else{
							str += '<a  title="<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>'+i+'<%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>">'+i+'</a>';
						}
					}
					if(end != this.total){
						str += dot;
					}
				}
			}
			
			str = ""+str_prv + str + str_next  + total_info + gopage_info;
			$("#"+this.pagerid).html(str);
		}
};

function getParameter(name) { 
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); 
	var r = window.location.search.substr(1).match(reg); 
	if (r!=null) return unescape(r[2]); return null;
}

var totalPage = 5;
var totalRecords = 48;
var pageNo = getParameter('pno');
if(!pageNo){
	pageNo = 1;
}
//生成分页控件
kkpager.init({
	pno : pageNo,
	//总页码

	total : totalPage,
	//总数据条数

	totalRecords : totalRecords,
	//链接前部
	hrefFormer : 'pager_test',
	//链接尾部
	hrefLatter : '.html',
	getLink : function(n){

		return this.hrefFormer + this.hrefLatter + "?pno="+n;
	}
});
kkpager.generPageHtml();
</script>

		<div>



			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			</FORM>
		<SCRIPT language="javascript">
		jQuery("#topTitle").topMenuTitle({searchFn:searchTitle});
		
		function searchTitle()
		{	
			var value=$("input[name='flowTitle']",parent.document).val();
		    $("input[name='requestname']").val(value);
			$GetEle("fromself").value="1";
			$GetEle("isfirst").value="1";
			$GetEle("frmmain").submit();
		}
		function OnChangePage(start){
		        $GetEle("start").value = start;
		        $GetEle("frmmain").submit();
		}
		
		function OnSearch(){
			$GetEle("fromself").value="1";
			$GetEle("isfirst").value="1";
			if(jQuery("select[name='customname']").length>0){
				if(jQuery("select[name='customname']").val().length>0){
					//值大于零
					var str="";
					//下拉框

					var frame=jQuery(document.getElementById('customframe').contentWindow.document.body);

					jQuery.each(frame.find("select"),function (i,item){
						console.dir(item);
						str=str+item.name+"="+item.value+"&";
					});
					//input
					jQuery.each(frame.find("input[type!='checkbox']"),function (i,item){
						str=str+item.name+"="+item.value+"&";
					});
					if(str.length>0){
						str=str.substring(0,(str.length-1));
					}
					var form=jQuery("#weaver");
					var url=form.attr("action");
					form.attr("action",url+"?"+str);
				}
			}
			$GetEle("frmmain").submit();
		}
		
		function OnMultiSubmit(){
		
			$GetEle("multiSubIds").value = _xtable_CheckedCheckboxId();
		    //alert (document.frmmain1.multiSubIds.value);
		    $GetEle("frmmain1").submit();
		}
		
		function OnMultiSubmitNew(obj){
		    if(_xtable_CheckedCheckboxId()!=""){
				$GetEle("multiSubIds").value = _xtable_CheckedCheckboxId();
			    //alert (document.frmmain1.multiSubIds.value);
			    $GetEle("frmmain1").submit();
				obj.disabled=true;
			}else{
		        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		    }
		}
		function OnOuterSubmit(requestid)
		{
			$GetEle("multiSubIds").value = requestid;
		    $GetEle("frmmain1").submit();
		}
		function CheckAll(haschecked) {
		
		    len = document.weaver1.elements.length;
		    var i=0;
		    for( i=0; i<len; i++) {
		        if (document.weaver1.elements[i].name.substring(0,13)=='multi_submit_') {
		            document.weaver1.elements[i].checked=(haschecked==true?true:false);
		        }
		    }
		}
		
		var showTableDiv  = $GetEle('divshowreceivied');
		var oIframe = document.createElement('iframe');
		function showreceiviedPopup(content){
		    showTableDiv.style.display='';
		    var message_Div = document.createElement("div");
		     message_Div.id="message_Div";
		     message_Div.className="xTable_message";
		     showTableDiv.appendChild(message_Div);
		     var message_Div1  = $GetEle("message_Div");
		     message_Div1.style.display="inline";
		     message_Div1.innerHTML=content;
		     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
		     var pLeft= document.body.offsetWidth/2-50;
		     message_Div1.style.position="absolute"
		     message_Div1.style.top=pTop;
		     message_Div1.style.left=pLeft;
		
		     message_Div1.style.zIndex=1002;
		
		     oIframe.id = 'HelpFrame';
		     showTableDiv.appendChild(oIframe);
		     oIframe.frameborder = 0;
		     oIframe.style.position = 'absolute';
		     oIframe.style.top = pTop;
		     oIframe.style.left = pLeft;
		     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
		     oIframe.style.width = parseInt(message_Div1.offsetWidth);
		     oIframe.style.height = parseInt(message_Div1.offsetHeight);
		     oIframe.style.display = 'block';
		}
		function displaydiv_1()
		{
			if(WorkFlowDiv.style.display == ""){
				WorkFlowDiv.style.display = "none";
				//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></a>";
				WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></span>";
			}
			else{
				WorkFlowDiv.style.display = "";
				//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154, user.getLanguage())%></a>";
				WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154, user.getLanguage())%></span>";
		
			}
		}
		
		function ajaxinit(){
		    var ajax=false;
		    try {
		        ajax = new ActiveXObject("Msxml2.XMLHTTP");
		    } catch (e) {
		        try {
		            ajax = new ActiveXObject("Microsoft.XMLHTTP");
		        } catch (E) {
		            ajax = false;
		        }
		    }
		    if (!ajax && typeof XMLHttpRequest!='undefined') {
		    ajax = new XMLHttpRequest();
		    }
		    return ajax;
		}
		function showallreceived(requestid,returntdid){
		    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%>");
		    var ajax=ajaxinit();
		    ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
		    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
		    //获取执行状态

		    //alert(ajax.readyState);
			//alert(ajax.status);
		    ajax.onreadystatechange = function() {
		        //如果执行状态成功，那么就把返回信息写到指定的层里

		        if (ajax.readyState==4&&ajax.status == 200) {
		            try{
			             $GetEle(returntdid).innerHTML = ajax.responseText;
			             $GetEle(returntdid).parentElement.title = ajax.responseText.replace(/[\r\n]/gm, "");
		            }catch(e){}
			            showTableDiv.style.display='none';
			            oIframe.style.display='none';
		        } 
		    } 
		}
		
		function onShowWorkFlow(inputname, spanname) {
			onShowWorkFlowBase(inputname, spanname, false);
		}
		
		function onShowWorkFlowNeeded(inputname, spanname) {
			onShowWorkFlowBase(inputname, spanname, true);
		}
		
		function onShowWorkFlowBase(inputname, spanname, needed) {
			var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
			if (retValue != null) {
				if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
					$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
					$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
				} else { 
					$GetEle(inputname).value = "";
					if (needed) {
						$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
					} else {
						$GetEle(spanname).innerHTML = "";
					}
				}
			}
		}
		
		//分页控件 菜单 标志为已读

		function doReadIt(requestid,otherpara,obj)
		{
			$.ajax({ 
		        type: "GET",
		        url: "WFSearchResultReadIt.jsp?requestid="+requestid+"&userid=<%=userID%>&usertype=<%=usertype%>",
		        success:function(){
		        	_table.reLoad();
		        }
	        });
		}
		
		//分页控件 菜单 转发功能
		function doReview(requestid)
		{
			//看原逻辑应该有保存表单签章，暂时不知其逻辑,并还有一个参数

			//目前只要有转发按钮的都打开转发页面
			//参考ManageRequestNoFormIframe.jsp
			var forwardurl = "/workflow/request/Remark.jsp?requestid="+requestid;
			openFullWindowHaveBar(forwardurl);
		}
		
		//分页控件 菜单 打印功能
		function doPrint(requestid)
		{	
			//打印貌似没这么简单，看原始逻辑还需要设置一些信息

			//目前只是把打印页面打开
			//参考ManageRequestNoFormIframe.jsp
			openFullWindowHaveBar("/workflow/request/PrintRequest.jsp?requestid="+requestid+"&isprint=1&fromFlowDoc=1");
		}
		
		// 分页控件 菜单 新建流程
		function doNewwf(requestid,newwfpara)
		{
			var pms = newwfpara.split("+");
			var wfid = pms[0];
			var agent = pms[1];
			openFullWindowHaveBar("/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&reqid="+requestid);
		}
		
		//分页控件 菜单 新建短信
		function doNewMsg(requestid,newmsgpara)
		{
			var pms = newmsgpara.split("+");
			var wfid = pms[0];
			var nodeid = pms[1];
			openFullWindowHaveBar("/sms/SendRequestSms.jsp?workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid);
		}
		
		//分页控件 菜单 查看表单日志
		function seeFormLog(requestid,nodeid)
		{
			var wfmonitor = false;
			var _wfmonitor = 0;
			//流程监控人

			if(wfmonitor) 
				_wfmonitor = 1;
			openFullWindowHaveBar("/workflow/request/RequestModifyLogView.jsp?requestid="+requestid+"&nodeid="+nodeid+"&isAll=0&ismonitor="+_wfmonitor+"&urger=0");
		}
		function customtype(value){
			if(value!=""&&value.length>0){
			//	jQuery("#customdetail").;
				jQuery("#customframe").attr("src","/workflow/search/workfloeCustom.jsp?custom_id="+value);
			//	jQuery("#customdetail").css("width",jQuery("#custom").width());
				setTimeout(function (){
					jQuery("#customdetail").css("display","table-row");
					jQuery("#customframe").css("display","block");
				},500);
			}else{
				jQuery("#customframe").css("display","none");
				jQuery("#customdetail").css("display","none");
			}
		}
		/**
 * 阻止时间冒泡
 * @param e 事件event 
 * @param handler 
 * @return
 */
function isMouseLeaveOrEnter(e, handler) {
	try {
		if (e.type != 'mouseout' && e.type != 'mouseover') return false;
		var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
		while (reltg && reltg != handler)
			reltg = reltg.parentNode;

	} catch (e) {}
    return (reltg != handler);
}
		</script>
		<SCRIPT language="javascript" src="/js/ecology8/request/wFCommonAdvancedSearch_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>