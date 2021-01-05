<%@ page buffer="1024kb" autoFlush="false"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST,weaver.workflow.request.todo.OfsSettingObject" %>
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
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />

<%
	/*判断页面是否需要显示自己的头部区域，如果需要则跳转处理*/
	String needHeader = request.getParameter("needHeader");
	if( needHeader == null  || needHeader.equals("true") ){
		request.getRequestDispatcher("WFRemind.jsp?needHeader=true&" + request.getQueryString()).forward(request, response);
		return;
	}
	String method="";
	String workflowid = "";
	String mulitwfid = Util.null2String(request.getParameter("multiSubIds"));
	String viewcondition = Util.null2String(request.getParameter("viewcondition"));
	if(!mulitwfid.equals("")) {
		method = Util.null2String(request.getParameter("method"));
		String wftype=Util.null2String(request.getParameter("wftype"));
		int flowAll=Util.getIntValue(Util.null2String(request.getParameter("flowAll")), 0);
		int flowNew=Util.getIntValue(Util.null2String(request.getParameter("flowNew")), 0);
		workflowid = Util.null2String(request.getParameter("workflowid"));
		response.sendRedirect("/workflow/request/RequestListOperation.jsp?multiSubIds="+mulitwfid+"&workflowid="+workflowid+"&method="+method+"&wftype="+wftype+"&flowAll="+flowAll+"&flowNew="+flowNew+"&viewcondition="+viewcondition);
		return;
	}
%>
<!--以下是显示定制组件所需的js -->
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>

		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 
		<script type="text/javascript">
		function taoHong(requestid,overtime,obj){
			openFullWindowHaveBarForWFList("/workflow/request/ViewRequest.jsp?viewdoc=1&seeflowdoc=1&requestid="+requestid+"&isovertime="+overtime,requestid);
		}
		
		function signNature(requestid,overtime,obj){
			openFullWindowHaveBarForWFList("/workflow/request/ViewRequest.jsp?viewdoc=1&seeflowdoc=1&requestid="+requestid+"&isovertime="+overtime,requestid);
		}
		function doEditContent(requestid,overtime,obj){
			openFullWindowHaveBarForWFList("/workflow/request/ViewRequest.jsp?viewdoc=1&seeflowdoc=1&requestid="+requestid+"&isovertime="+overtime,requestid);
		}
		
		var prePrimarykeys = null;
		var prePageNumber = -1;
		function afterDoWhenLoaded (p) {
			parent.window.__optkeys = "";
			var curPrimarykeys = _table.primarykeylist;
			if (prePageNumber == _table.nowPage) {
				if (!!prePrimarykeys && prePrimarykeys.length > 0 && !!curPrimarykeys && curPrimarykeys.length > 0) {
					var optkeys = "";	
					for (var _i=0; _i<prePrimarykeys.length; _i++) {
						if (curPrimarykeys.indexOf(prePrimarykeys[_i]) == -1) {
							optkeys += "," + prePrimarykeys[_i];
						}
					}
					if (optkeys.length > 1) {
						optkeys = optkeys.substr(1);
						parent.window.__optkeys = optkeys;
					}
				}
			} else {
				prePageNumber = _table.nowPage;
			}
			prePrimarykeys = curPrimarykeys;
			__hidloaddingblock();
			if (!!!p) return;
			var recordCount = p.recordCount;
			updateFatherVal(recordCount); 
		}
		
		function updateFatherVal(recordCount){
			parent.reloadLeftNum();
		}
		</script>
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


    OfsSettingObject ofso = requestutil.getOfsSetting();
    boolean isopenos = ofso.getIsuse()==1;//是否开启异构系统待办


	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
	int viewType = Util.getIntValue(Util.null2String(request.getParameter("viewType")), 0);
	int processId = Util.getIntValue(request.getParameter("processId"),0);
	int sysId = Util.getIntValue(request.getParameter("sysId"),0);
	String overtimetype=Util.null2String(request.getParameter("overtimetype"));
	String myrequest=Util.null2String(request.getParameter("myrequest"));
%>
	<BODY>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<FORM id=weaver name=frmmain method=post action="WFSearchResult.jsp?offical=<%=offical %>&officalType=<%=officalType %>&viewType=<%=viewType %>">
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
		String branchid = "";
		String cdepartmentid = "";
		String isFromMessage = Util.null2String(request.getParameter("isFromMessage"));
		String processing = Util.null2String(request.getParameter("processing"));
		String scope = Util.null2String(request.getParameter("viewScope"));
		//System.out.println("类型："+scope);
		String urlType = "";
		if(scope.equals("doing")){
			urlType = "1";
			if(offical.equals("1")){
				urlType = "9";
			}
		}
		else if(scope.equals("done")){
			urlType = "2";
			if(offical.equals("1")){
				urlType = "10";
			}
		}
		else if(scope.equals("complete")){
			urlType = "3";
			if(offical.equals("1")){
				urlType = "11";
			}
		}
		else if(scope.equals("mine")){
			urlType = "4";
			if(offical.equals("1")){
				urlType = "12";
			}
		}
		else 
			urlType = "0";
		//
		String archivestatus = "";
		//add by bpf 2013-11-07
		String flowTitle=getLike(request,"flowTitle");//流程名称
		String workflowtype = "";
		String wfstatu = "";
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
		String fromselfSqlos = Util.null2String(request.getParameter("fromselfSqlos"));
		String isfirst = Util.null2String(request.getParameter("isfirst"));
		String docids = Util.null2String(request.getParameter("docids"));
		String flag = Util.null2String(request.getParameter("flag"));
		int date2during = Util.getIntValue(Util.null2String(request.getParameter("date2during")), 0);
		//增加一个页面时间维度的查询 add by Dracula @2014-1-9
		String timecondition = Util.null2String(request.getParameter("timecondition"));
		//System.out.println(timeCondition);
		
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
			workflowtype = Util.null2String(request.getParameter("workflowtype"));
			wfstatu = Util.null2String(request.getParameter("wfstatu"));
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
		String newsqlos = "";
		if (!workflowid.equals("") && !workflowid.equals("0")) {
            if(workflowid.indexOf("-")!=-1){
                newsql += " and t1.workflowid in (" +workflowid + ") ";
            }else{
                newsql += " and t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ") ";
            }
            newsqlos += " and workflowid="+workflowid ;
        }
		//增加时间维度查询条件 for ecology8 add by Dracula @2014-1-9
		if(!timecondition.equals("")){
			 if("1".equals(timecondition)){
			    newsql += " and t1.createdate>='" + TimeUtil.getToday()+ "'";
				newsqlos += " and createdate>='" + TimeUtil.getToday() + "'";
		     }else if("2".equals(timecondition)){
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfWeek()+ "'";
				newsqlos += " and createdate>='" + TimeUtil.getFirstDayOfWeek() + "'";
		     }else if("3".equals(timecondition)){
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfMonth()+ "'";
				newsqlos += " and createdate>='" + TimeUtil.getFirstDayOfMonth() + "'";
			 }else if("4".equals(timecondition)){
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfSeason()+ "'";
				newsqlos += " and createdate>='" + TimeUtil.getFirstDayOfSeason()+ "'";
			 }else if("5".equals(timecondition)){
			    newsql += " and t1.createdate>='" + TimeUtil.getFirstDayOfTheYear()+ "'";
				newsqlos += " and createdate>='" + TimeUtil.getFirstDayOfTheYear()+ "'";
			 }
		}
		if (date2during > 0 && date2during < 37){
			newsql += WorkflowComInfo.getDateDuringSql(date2during);
			newsqlos += WorkflowComInfo.getDateDuringSql(date2during);
		}
		if (fromself.equals("1")) {
			if (!nodetype.equals("")) {
                newsql += " and t1.currentnodetype='" + nodetype + "'";
                newsqlos += " and 1=2 ";
            }
			if (!fromdate.equals("")) {
                newsql += " and t1.createdate>='" + fromdate + "'";
                newsqlos += " and createdate>='" + fromdate + "'";
            }
			if (!todate.equals("")) {
                newsql += " and t1.createdate<='" + todate + "'";
                newsqlos += " and createdate<='" + todate + "'";
            }
			if (!fromdate2.equals("")) {
                newsql += " and t2.receivedate>='" + fromdate2 + "'";
                newsqlos += " and receivedate>='" + fromdate2 + "'";
            }
			if (!todate2.equals("")) {
                newsql += " and t2.receivedate<='" + todate2 + "'";
                newsqlos += " and receivedate<='" + todate2 + "'";
            }
			//if (!workcode.equals(""))
			//	newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%" + workcode + "%')";
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
				if (!tempWhere.equals("")){
					newsql += " and exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and (" + tempWhere + "))";
					newsqlos += " and exists(select 1 from hrmresource where creatorid=id and (" + tempWhere + "))";
				}
			}

			if (!requestlevel.equals("")) {
				newsql += " and t1.requestlevel=" + requestlevel;
				newsqlos += " and 1=2 ";
			}

			if (!querys.equals("1")) {
				if (!fromselfSql.equals("")&&!fromselfSql.equalsIgnoreCase("null")){
					newsql += " and " + fromselfSql;
				}
				if (!fromselfSqlos.equals("")&&!fromselfSqlos.equalsIgnoreCase("null")){
					newsqlos += " " + fromselfSqlos;
				}
			} else {
				if (fromself.equals("1")){
					newsql += " and  islasttimes=1 ";
                    newsqlos += " and  islasttimes=1 ";
				}
			}

		}

		String resourceid = Util.null2String(request.getParameter("resourceid"));
		String CurrentUser = "".equals(resourceid) ? Util.null2String((String) session.getAttribute("RequestViewResource")) : resourceid;
		resourceid = CurrentUser;
		
		String userID = String.valueOf(user.getUID());
		int userid=user.getUID();
		String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
		//QC235172,如果不是查看自己的代办，主从账号统一显示不需要判断
		if(!"".equals(resourceid) && !("" + userid).equals(resourceid)) belongtoshow = "";
		
		String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
		
															
		String logintype = "" + user.getLogintype();
		int usertype = 0;
		boolean superior = false; //是否为被查看者上级或者本身





		if (logintype.equals("2"))
			usertype = 1;
		if (CurrentUser.equals("")) {
			CurrentUser = "" + user.getUID();
		}
		


		if (userID.equals(CurrentUser)) {
			superior = true;
		} else {
			RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND managerStr LIKE '%," + userID + ",%'");

			if (RecordSet.next()) {
				superior = true;
			}
		}
		
		String sqlwhere = "";
        String sqlwhereos = " where 1=1 ";
		if("1".equals(belongtoshow)){
		if (isovertime == 1) {


			if("0".equals(overtimetype)){
				sqlwhere = "where t1.requestid = t2.requestid "
						//+ " and t2.isremark='0'  AND t2.isprocessed='3' and t2.islasttimes=1 "
						+ " and t2.userid in (" + userIDAll + ") and t2.usertype='" + (Util.getIntValue(logintype, 1) - 1) + "' and t2.islasttimes = 1 "
						+ " and exists (select 1 from workflow_currentoperator c where c.requestid = t2.requestid and c.isremark = '0' and c.isreminded = '1' and (c.isreminded_csh != '1' or c.isreminded_csh is null)) "
						+ " AND exists(select 1 from SysPoppupRemindInfonew z2  "
						+ " where  t1.requestid=z2.requestid and z2.type=10  "
						+ " and z2.userid in ("
						+ userIDAll
						+ ") and z2.usertype='"
						+ (Util.getIntValue(logintype, 1) - 1)
						+ "' )";
			}else{
				sqlwhere = "where t1.requestid = t2.requestid "
						//+ " and t2.isremark = 5 AND (t2.isprocessed = 1 OR t2.isprocessed = 2)  "
						+ " and t2.userid in (" + userIDAll + ") and t2.usertype='" + (Util.getIntValue(logintype, 1) - 1) + "' and t2.islasttimes = 1 "
						+ " and exists (select 1 from workflow_currentoperator c where c.requestid = t2.requestid and c.isremark = '0' and c.isreminded_csh = '1') "
						+ " AND exists(select 1 from SysPoppupRemindInfonew z2  "
						+ " where  t1.requestid=z2.requestid and z2.type=10  "
						+ " and z2.userid in ( "
						+ userIDAll
						+ " )and z2.usertype='"
						+ (Util.getIntValue(logintype, 1) - 1)
						+ "' )";
			}
		} else {
			if (superior && !flag.equals("")){
				CurrentUser = userID;
			}
			sqlwhere = "where  (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.userid in (" + userIDAll + " ) and t2.usertype=" + usertype;
			if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
				sqlwhere += " and " + SearchClause.getWhereClause();
			}
			if (!Util.null2String(SearchClause.getWhereclauseOs()).equals("")) {
                sqlwhereos += " " + SearchClause.getWhereclauseOs();
            }
		}
		if (RecordSet.getDBType().equals("oracle")) {
			sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater in (" + userIDAll + "))) ";
		} else {
			sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater in (" + userIDAll + "))) ";
			//System.out.print("--436--sqlwhere--"+sqlwhere);
		}
		}else{
		if (isovertime == 1) {
			if("0".equals(overtimetype)){
				sqlwhere = "where t1.requestid = t2.requestid "
						//+ " and t2.isremark='0'  AND t2.isprocessed='3' and t2.islasttimes=1 "
						+ " and t2.userid in (" + user.getUID() + ") and t2.usertype='" + (Util.getIntValue(logintype, 1) - 1) + "' and t2.islasttimes = 1 "
						+ " and exists (select 1 from workflow_currentoperator c where c.requestid = t2.requestid and c.isremark = '0' and c.isreminded = '1' and (c.isreminded_csh != '1' or c.isreminded_csh is null)) "
						+ " AND exists(select 1 from SysPoppupRemindInfonew z2  "
						+ " where  t1.requestid=z2.requestid and z2.type=10  "
						+ " and z2.userid in ("
						+ user.getUID()
						+ ") and z2.usertype='"
						+ (Util.getIntValue(logintype, 1) - 1)
						+ "' )";
			}else{
				sqlwhere = "where t1.requestid = t2.requestid "
						//+ " and t2.isremark = 5 AND (t2.isprocessed = 1 OR t2.isprocessed = 2)  "
						+ " and t2.userid in (" + user.getUID() + ") and t2.usertype='" + (Util.getIntValue(logintype, 1) - 1) + "' and t2.islasttimes = 1 "
						+ " and exists (select 1 from workflow_currentoperator c where c.requestid = t2.requestid and c.isremark = '0' and c.isreminded_csh = '1') "
						+ " AND exists(select 1 from SysPoppupRemindInfonew z2  "
						+ " where  t1.requestid=z2.requestid and z2.type=10  "
						+ " and z2.userid in ( "
						+ user.getUID()
						+ " )and z2.usertype='"
						+ (Util.getIntValue(logintype, 1) - 1)
						+ "' )";
			}
		} else {
			if (superior && !flag.equals("")){
				CurrentUser = userID;
			}
			sqlwhere = "where  (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.userid = " + CurrentUser + " and t2.usertype=" + usertype;
			if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
				sqlwhere += " and " + SearchClause.getWhereClause();
			}
			if (!Util.null2String(SearchClause.getWhereclauseOs()).equals("")) {
                sqlwhereos += " " + SearchClause.getWhereclauseOs();
            }
		}
		if (RecordSet.getDBType().equals("oracle")) {
			sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater in (" + user.getUID() + "))) ";
		} else {
			sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater in (" + user.getUID() + "))) ";
		}
		}
		
		if(sqlwhereos.equals("")) {
            sqlwhereos = " and userid=" + user.getUID() + " and islasttimes=1 and isremark=0 ";
        }
		String orderby = "";
        String orderbyos = "";

		//高级搜索条件
	    WfAdvanceSearchUtil  conditionutil=new  WfAdvanceSearchUtil(request,RecordSet);
	   
	    String conditions="";
        String conditionsos="";
	    if(processing.equals("0")){
	    	conditions = conditionutil.getAdVanceSearch4PendingCondition();
			conditionsos = conditionutil.getAdVanceSearch4PendingConditionOs();
	    }else{
	    	conditions = conditionutil.getAdVanceSearch4OtherCondition();
            conditionsos = conditionutil.getAdVanceSearch4OtherConditionOs();
	    }
	    //System.out.println("conditions"+conditions);
	    //System.out.println("newsql"+newsql);
	    //System.out.println("sqlwhere"+sqlwhere);
		
	    if(!conditions.equals("")){
	    	creatertype = "0";
		 	newsql += conditions;
            newsqlos += conditionsos ;
		}	
		sqlwhere += " " + newsql;
		sqlwhereos += " "+newsqlos ;
		//orderby=" t1.createdate,t1.createtime,t1.requestlevel";
		orderby = SearchClause.getOrderClause();
		orderbyos = SearchClause.getOrderclauseOs();
		if (orderby.equals("")) {
			orderby = "t2.receivedate ,t2.receivetime";
		}
		if(orderbyos.equals("")){
            orderbyos = "receivedate ,receivetime";
        }
		//orderby2=" order by t1.createdate,t1.createtime,t1.requestlevel";

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
			} else {
				if (!workflowid.equals("")) {
                    if(workflowid.indexOf("-")!=-1){
                        strworkflowid = " in (" + workflowid + ")";
                    }else {
                        strworkflowid = " in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")";
                    }
                }
			}
		}

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
		//查看其他待办时不出现批量提交按钮
		if (!CurrentUser.equals(userID)) {
		    isMultiSubmit = false;
		}

		int perpage = 10;
             
		boolean hasrequestname = false;
		boolean hascreater = false;
		boolean hascreatedate = false;
		boolean hasworkflowname = false;
		boolean hasrequestlevel = false;
		boolean hasreceivetime = false;
		boolean hasstatus = false;
		boolean hasreceivedpersons = false;
		boolean hascurrentnode = false;
		boolean hashurry = false;
		boolean hasrequestmark = false;
		boolean hasshowsysname = false ;
	
		if(scope.equals("doing")){
				hasrequestname = true;
				hascreater = true;
				hascreatedate = true;
				hasreceivedpersons = true;
				hasshowsysname = true ;
		}else if(scope.equals("done")||scope.equals("complete")){
				hasrequestname = true;
				hasworkflowname = true;
				hascreater = true;
				hasreceivetime = true;
				hascurrentnode = true;
				hasreceivedpersons = true;
				if(ofso.getShowdone().equals("1")){
					hasshowsysname = true ;
				}
		}else if(scope.equals("mine")){
				hasrequestname = true;
				hasworkflowname = true;
				hascreatedate = true;
				hascurrentnode = true;
				hasreceivedpersons = true;
				hasshowsysname = true ;
		}else{
				hasrequestname = true;
				hasworkflowname = true;
				hascreater = true;
				hascreatedate = true;
				hascurrentnode = true;
				hasreceivedpersons = true;
		}

		//update by fanggsh 20060711 for TD4532 begin
		boolean hasSubWorkflow = false;
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
		RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:rightMenuSearch(),_self}";
		RCMenuHeight += RCMenuHeightStep;
		if (isMultiSubmit && iswaitdo == 1 && sysId!=5 && sysId!=8) {
			RCMenu += "{" + SystemEnv.getHtmlLabelName(17598, user.getLanguage()) + ",javascript:OnMultiSubmitNew(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
		
		if("1".equals(isFromMessage)){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(81706, user.getLanguage()) + ",javascript:doAllReadIt(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
		
		String pageId = "";
		
	%>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/wfSearchResult_wev8.js"></script>
		<table id="topTitle" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
				<%if(isMultiSubmit && iswaitdo == 1 && sysId!=5&&sysId!=8){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(17598, user.getLanguage())%>" style="font-size:12px" class="e8_btn_top middle" onclick="OnMultiSubmitNew(this)">
					&nbsp;&nbsp;&nbsp;
					<%} %>
				<%if("1".equals(isFromMessage)){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(81706, user.getLanguage())%>" style="font-size:12px" class="e8_btn_top middle" onclick="doAllReadIt()">
					&nbsp;&nbsp;&nbsp;
				<%} %>
					<input type="text" class="searchInput" value="<%=Util.null2String(request.getParameter("requestname"))%>" name="flowTitle"/>
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

		<wea:layout type="4col">
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
	    	<wea:item>
		    	<input class=InputStyle type="text" name="requestname"  value='<%=Util.null2String(request.getParameter("requestname"))%>'>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" name="wfcode" value='<%=Util.null2String(request.getParameter("wfcode"))%>' ></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(33476, user.getLanguage())+SystemEnv.getHtmlLabelName(18499, user.getLanguage())%></wea:item>
	    	<wea:item>
				<brow:browser viewType="0" name="workflowid"
					browserValue='<%=workflowid %>'
					getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
					isSingle="true" hasBrowser="true" isMustInput="1"
					completeUrl="/data.jsp?type=workflowBrowser&showos=1"
					browserSpanValue='<%=WorkflowComInfo.getWorkflowname(workflowid)%>'>
				</brow:browser>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
	    	<wea:item>
  		    	<span style='float:left;display:inline-block;'>
                        	<select name="createdateselect" id="createdateselect" onchange="changeDate(this,'createdate');" class="inputstyle" size=1>
                        		<option value="0" <% if(datecondition.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
                        		<option value="1" <% if(datecondition.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></option>
                        		<option value="2" <% if(datecondition.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></option>
                        		<option value="3" <% if(datecondition.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></option>
                        		<option value="4" <% if(datecondition.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage()) %></option>
                        		<option value="5" <% if(datecondition.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage()) %></option>
                        		<option value="6" <% if(datecondition.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage()) %></option>
                        	</select>
                       	</span>
				<span style='float:left;margin-left: 10px;padding-top: 5px;'>
                       	<span id="createdate" style="display:<%if(!datecondition.equals("6")) {%>none<%} %>" >
				<button type="button" class="calendar" id="SelectDate" onclick="getDate(createdatefromspan,createdatefrom)"></button>&nbsp;
			 	<span id="createdatefromspan"><%=createdatefrom %></span>
			  	-&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate2" onclick="getDate(createdatetospan,createdateto)"></button>&nbsp;
			  	<span id="createdatetospan"><%=createdateto %></span>
			  	</span>
			  	<input type="hidden" name="createdatefrom" value="<%=createdatefrom %>">
			  	<input type="hidden" name="createdateto" value="<%=createdateto %>">
				</span>
	    	</wea:item>
	    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
	    	<wea:item >
					         <span style="float:left;">
									<select class=inputstyle name=creatertype  style='height:25px;' onchange="changeType(this.value,'createridselspan','createrid2selspan');">
									<%if (!user.getLogintype().equals("2")) {%>
									<option value="0"
											<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%>
												</option>
									<%}%>
									<option value="1"
											<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%>
												</option>
									</select>
							 </span>
						     <span id="createridselspan" style="<%=(creatertype.equals("0") || creatertype.equals(""))?"":"display:none;float:left;" %>">
							   <brow:browser viewType="0" name="createrid" browserValue='<%= createrid+"" %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(createrid+""),user.getLanguage())%>'> 
							   </brow:browser> 
							 </span>
							 <span id="createrid2selspan" style="<%=!(creatertype.equals("0") || creatertype.equals(""))?"":"display:none;float:left;" %>">
									  <brow:browser viewType="0" name="createrid2" browserValue='<%= createrid2+"" %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="150px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=18"  browserSpanValue='<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid2+""),user.getLanguage())%>'> 
									 </brow:browser> 
						    </span>
	    	 </wea:item>
	    	 <wea:item><%=SystemEnv.getHtmlLabelNames("882,714", user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" name="workcode" value='<%=Util.null2String(request.getParameter("workcode"))%>' ></wea:item>
	    </wea:group>
	     <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  attributes="{'itemAreaDisplay':'none'}">
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%= ""+ownerdepartmentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=ownerdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
   			<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
	    	<wea:item>
				<brow:browser viewType="0" name="workflowtype"
					browserValue='<%=workflowtype %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp?showos=1"
					_callback="changeFlowType"
					hasInput="true" isSingle="true" hasBrowser="true"
					isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser&showos=1"
					browserDialogWidth="600px"
					browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(workflowtype)%>'>
				</brow:browser>
	    	</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <select class=inputstyle name=requestlevel size=1>
				            <option value=""></option>
				            <option value="0"
				                    <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%>
				                        </option>
				            <option value="1"
				                    <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%>
				                        </option>
				            <option value="2"
				                    <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%>
				                        </option>
				   </select>
	    	</wea:item>
	    	<wea:item ><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		           <span style='float:left;display:inline-block;'>
                          		<select name="recievedateselect" id="recievedateselect" onchange="changeDate(this,'recievedate');" class="inputstyle" size=1>
	                          		<option value="0" <% if(recievedateselect.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
	                          		<option value="1" <% if(recievedateselect.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></option>
	                          		<option value="2" <% if(recievedateselect.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></option>
	                          		<option value="3" <% if(recievedateselect.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></option>
	                          		<option value="4" <% if(recievedateselect.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage()) %></option>
	                          		<option value="5" <% if(recievedateselect.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage()) %></option>
	                          		<option value="6" <% if(recievedateselect.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage()) %></option>
	                          	</select>
                          	</span>
							<span style='float:left;margin-left: 10px;padding-top: 5px;'>
                          	<span id="recievedate" style="display:<%if(!recievedateselect.equals("6")) {%>none<%} %>">
							<button type="button" class="calendar" id="SelectDate" onclick="getDate(recievedatefromspan,recievedatefrom)"></button>&nbsp;
							<span id="recievedatefromspan"><%=recievedatefrom %></span>
							-&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate1" onclick="getDate(recievedatetospan,recievedateto)"></button>&nbsp;
							<span id="recievedatetospan"><%=recievedateto %></span>
							</span>
							<input type="hidden" name="recievedatefrom" value="<%=recievedatefrom %>">
							<input type="hidden" name="recievedateto" value="<%=recievedateto %>">
							</span>
	    	</wea:item>
	    	
          <%if(!processing.equals("0")) {%>
	
						<wea:item><%=SystemEnv.getHtmlLabelName(32532, user.getLanguage())%></wea:item>
                        <wea:item>
                         	<span style='float:left;display:inline-block;'>
                          		<select name="operatedateselect" id="operatedateselect" onchange="changeDate(this,'operatedate');" class="inputstyle" size=1>
	                          		<option value="0" <% if(operatedateselect.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
	                          		<option value="1" <% if(operatedateselect.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></option>
	                          		<option value="2" <% if(operatedateselect.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></option>
	                          		<option value="3" <% if(operatedateselect.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></option>
	                          		<option value="4" <% if(operatedateselect.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage()) %></option>
	                          		<option value="5" <% if(operatedateselect.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage()) %></option>
	                          		<option value="6" <% if(operatedateselect.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage()) %></option>
	                          	</select>
                          	</span>
							<span style='float:left;margin-left: 10px;padding-top: 5px;'>
                          	<span id="operatedate" style="display:<%if(!operatedateselect.equals("6")) {%>none<%} %>">
							<button type="button" class="calendar" id="SelectDate" onclick="getDate(operatedatefromspan,operatedatefrom)"></button>&nbsp;
							<span id="operatedatefromspan"><%=operatedatefrom %></span>
							-&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate1" onclick="getDate(operatedatetospan,operatedateto)"></button>&nbsp;
							<span id="operatedatetospan"><%=operatedateto %></span>
							</span>
							<input type="hidden" name="operatedatefrom" value="<%=operatedatefrom %>">
							<input type="hidden" name="operatedateto" value="<%=operatedateto %>">
							</span>
                        </wea:item>
			<% }%>

			<%if(!processing.equals("0")) {%>
	
						<wea:item><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></wea:item>
                        <wea:item >
                        	<select class=inputstyle size=1 name=archivestatus>
					            <option value="0"
					                    <% if(archivestatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>
					                        </option>
					            <option value="1"
					                    <% if(archivestatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%>
					                        </option>
					            <option value="2"
					                    <% if(archivestatus.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%>
					                        </option>
					        </select>
                        </wea:item>
			<% }%>
           
		   <wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
		   <wea:item>
		       <select class=inputstyle size=1 name=wfstatu>
								<option value="">&nbsp;</option>
								<option value="1"
										<% if(Util.null2String(request.getParameter("wfstatu")).equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246, user.getLanguage())%>
											</option>
								<option value="0"
										<% if(Util.null2String(request.getParameter("wfstatu")).equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245, user.getLanguage())%>
											</option>
								<option value="2"
										<% if(Util.null2String(request.getParameter("wfstatu")).equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>
											</option>
				</select>
		   </wea:item>
		   <wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
		   <wea:item>
		         <select class=inputstyle size=1 name=nodetype>
            					<option value="">&nbsp;</option>
					            <option value="0"
					                    <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%>
					                        </option>
					            <option value="1"
					                    <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%>
					                        </option>
					            <option value="2"
					                    <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%>
					                        </option>
					            <option value="3"
					                    <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%>
					                        </option>
				 </select>
		   </wea:item>
		   <wea:item><%=SystemEnv.getHtmlLabelName(16354, user.getLanguage())%></wea:item>
		   <wea:item> 
		         <brow:browser viewType="0" name="unophrmid" browserValue='<%= ""+unophrmid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=unophrmid!=0?Util.toScreen(ResourceComInfo.getResourcename(unophrmid+""),user.getLanguage()):""%>'> </brow:browser>
           </wea:item>
		   <wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
		   <wea:item>
		          <brow:browser viewType="0" name="docids" browserValue='<%=Util.null2String(request.getParameter("docids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=9" width="80%" browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(Util.null2String(request.getParameter("docids"))+""),user.getLanguage())%>'> </brow:browser>
		   </wea:item>
		   <wea:item><%=SystemEnv.getHtmlLabelName(792, user.getLanguage())%></wea:item>
		   <wea:item>
		          <brow:browser viewType="0" name="hrmcreaterid" browserValue='<%=Util.null2String(request.getParameter("hrmcreaterid"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(Util.null2String(request.getParameter("hrmcreaterid"))+""),user.getLanguage())%>'> </brow:browser>
		   </wea:item>
		   <wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
		   <wea:item>
		           <brow:browser viewType="0" name="crmids" browserValue='<%=Util.null2String(request.getParameter("crmids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=18" width="80%" browserSpanValue='<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(Util.null2String(request.getParameter("crmids"))+""),user.getLanguage())%>'> </brow:browser>
		   </wea:item>
		   <wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
		   <wea:item  >
		           <brow:browser viewType="0" name="proids" browserValue='<%=Util.null2String(request.getParameter("proids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=135" width="80%" browserSpanValue='<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(Util.null2String(request.getParameter("proids"))+""),user.getLanguage())%>'> </brow:browser>
		   </wea:item>

		   <%
		        boolean custom_show=true;
				String custom_id=null;
				if(!workflowid.equals("")&&false){
					//自定义流程查询






					//获取自定义查询条件






					RecordSet.executeSql("select id,Customname from Workflow_Custom where formID in (select formid from workflow_base where id="+ workflowid +")");	
			%>
		
				<wea:item><%=SystemEnv.getHtmlLabelName(19516, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(527, user.getLanguage())%></wea:item>
				<wea:item attributes="{colspan:3}">
					<select class=inputstyle size=1 name=customname onchange="customtype(this.value)">
						<option value="">&nbsp;</option>
			<%
				
				String id;
				while(RecordSet.next()){
						id=RecordSet.getString("id");
						custom_show=false;
						if(custom_id==null){
							custom_id=id;
						}
			%>
				<option value="<%=id%>" <%if(custom_id.equals(id)){%>selected<%}%>><%=RecordSet.getString("Customname")%></option>
			<%
				  }
			%>
					</select>
				</wea:item>
			<%
				if(custom_show&&false){
			%>
					<script type="text/javascript">
						//没有自定义查询的该tbody不显示






						jQuery("#custom").css("display","none");
					</script>
			<%
				}else if(custom_id!=null&&false){
						//有自定义查询，显示自定义查询内容
			%>
			<!--自定义查询明细内容-->
				<wea:item  attributes="{colspan:4}">
					<iframe src="/workflow/search/workfloeCustom.jsp?custom_id=<%=custom_id%>&<%=customSearch%>" id="customframe" name="customframe"
					class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</wea:item>
			<%
				customSearch="";
				}
			}
			%>

	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="submit" name="submit_1" onClick="OnSearch()" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>"/>
	    		<span class="e8_sep_line">|</span>
				<input class="e8_btn_cancel" type="button" name="reset" onclick="resetCondtion()" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage()) %>"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
 </div>
		
		<!-- bpf end 2013-10-29 -->
		

			<div id='divshowreceivied' style='background: #FFFFFF; padding: 3px; width: 100%' valign='top'></div>
			<input type="hidden" name="fromself" value="<%=fromself%>">
			<input type="hidden" name="isfirst" value="<%=isfirst%>">
			<input type="hidden" name="fromselfSql" value="<%if(!"1".equals(isfirst)){%><%=xssUtil.put(SearchClause.getWhereClause())%><%}else{%><%=xssUtil.put(fromselfSql)%><%}%>">
			<input type="hidden" name="fromselfSqlos" value="<%if(!"1".equals(isfirst)){%><%=xssUtil.put(SearchClause.getWhereclauseOs())%><%}else{%><%=xssUtil.put(fromselfSqlos)%><%}%>">
			<input name="iswaitdo" type="hidden" value="<%=iswaitdo%>">
			<input name="offical" type="hidden" value="<%=offical%>">
			<input name="officalType" type="hidden" value="<%=officalType%>">
			<input name="viewcondition" type="hidden" value="<%=viewcondition%>">
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
					//System.out.println(paramenterName);
					if(paramenterName.equals("pageSizeSel1inputText") || paramenterName.equals("pageSizeSel1") 
							|| paramenterName.equals("submit_1")
							||paramenterName.equals("createdatefrom")||paramenterName.equals("createdateto")
							||paramenterName.equals("recievedatefrom")||paramenterName.equals("recievedateto")
							||paramenterName.equals("operatedatefrom")||paramenterName.equals("operatedateto")
							||paramenterName.equals("fromselfSql")||paramenterName.equals("fromselfSqlos")
					){
					}else{
					%>
						<input type="hidden" id="<%=paramenterName %>" name="<%=paramenterName %>" value="<%=value %>">
					<% 
				}}
			
			%>
			
			

			<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<input name=start type=hidden value="<%=start%>">

									<!--   added by xwj for td2023 on 2005-05-20  begin  -->
									<!-- <FORM id=weaver1 name=frmmain1 method=post action="/workflow/request/RequestListOperation.jsp"> -->
										<input type=hidden name=multiSubIds value="">
									<!--  </form> -->

									<!-- evan start -->
									<TABLE width="100%" cellspacing="0" cellpadding="0">
										<tr>
											<td valign="top" class="_xTableOuter"><%
													String tableString = "";
													if (perpage < 2)
														perpage = 10;
													//-------------------------------------------
													// 处理已办排序 start
													//-------------------------------------------
													String operateDateTimeFieldSql0 = "";
													String operateDateTimeFieldSql = "";
													String operateDateTimeFieldSqlOs = "";
													if (SearchClause.getOrderClause().toLowerCase().indexOf("operatedate") != -1) {
														operateDateTimeFieldSql0 = ",operatedate";
													    operateDateTimeFieldSql = ", (case  WHEN t2.operatedate IS NULL  THEN t2.receivedate ELSE t2.operatedate END) operatedate ";
														operateDateTimeFieldSqlOs = ", (case  WHEN operatedate IS NULL  THEN receivedate ELSE operatedate END) operatedate ";
													}
													
													if (SearchClause.getOrderClause().toLowerCase().indexOf("operatetime") != -1) {
													    operateDateTimeFieldSql0 = ",operatetime";
													    operateDateTimeFieldSql += ", (case  WHEN t2.operatetime IS NULL  THEN t2.receivetime ELSE t2.operatetime END) operatetime ";
                                                        operateDateTimeFieldSqlOs += ", (case  WHEN operatetime IS NULL  THEN receivetime ELSE operatetime END) operatetime ";
													}
													//-------------------------------------------
													// 处理已办排序 end
													//-------------------------------------------
													//最外层查询字段
                                                    String backfields0 = " requestid,requestmark,createdate, createtime,creater, creatertype, workflowid, requestname, requestnamenew, status,requestlevel,currentnodeid,currentnodename,viewtype,userid,receivedate,receivetime,isremark,nodeid,agentorbyagentid,agenttype,isprocessed " + operateDateTimeFieldSql0+",systype,workflowtype";
                                                    //原始查询字段
                                                    String backfields = " t1.requestid,t1.requestmark,t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.requestnamenew, t1.status,t1.requestlevel,t1.currentnodeid,'' as currentnodename,t2.viewtype,t2.userid,t2.receivedate,t2.receivetime,t2.isremark,t2.nodeid,t2.agentorbyagentid,t2.agenttype,t2.isprocessed " + operateDateTimeFieldSql+" ,'0' as systype,t2.workflowtype";
                                                    //异构系统查询字段
                                                    String backfieldsOs = " requestid,'' as requestmark,createdate, createtime,creatorid as creater, 0 as creatertype, workflowid, requestname, requestname as requestnamenew, '' as status,-1 as requestlevel,-1 as currentnodeid,nodename as currentnodename ,viewtype,userid,receivedate,receivetime,isremark,0 as nodeid, -1 as agentorbyagentid,'0' as agenttype,'0' as isprocessed " + operateDateTimeFieldSqlOs +",'1' as systype, sysid as workflowtype";
													
													String fromSql = " from workflow_requestbase t1,workflow_currentoperator t2 ";//xxxxx
													String sqlWhere = sqlwhere;
													String para2 = "column:requestid+column:workflowid+column:viewtype+" + isovertime + "+" + user.getLanguage() + "+column:nodeid+column:isremark+" + user.getUID() + "+column:agentorbyagentid+column:agenttype+column:isprocessed+column:userid+"+myrequest+"+column:creater";
													String para4 = user.getLanguage() + "+" + user.getUID() + "+column:userid";
													if (!docids.equals("")) {
														fromSql = fromSql + ",workflow_form t4 ";
														sqlWhere = sqlWhere + " and t1.requestid=t4.requestid ";
													}

													if (!superior) {
														if("1".equals(belongtoshow)){
														sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid in ("
																+ userIDAll + " ) and workFlowCurrentOperator.usertype = " + usertype + ") ";
														}else{
														sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid in ("
																+ user.getUID() + " ) and workFlowCurrentOperator.usertype = " + usertype + ") ";
														}
													}

													if (!branchid.equals("")) {
														sqlWhere += " AND t1.creater in (select id from hrmresource where subcompanyid1=" + branchid + ")  ";
													}
													sqlWhere+=" and t1.workflowid in (select id from workflow_base where  ";
													//流程类型、流程状态查询条件






													if("0".equals(wfstatu)){
														sqlWhere +=" isvalid='0' ";
													}else{
														sqlWhere +=" (isvalid='1' or isvalid='3') ";
													}
													if(!"".equals(workflowtype)){
														sqlWhere += " and workflowtype="+workflowtype+" ";
														sqlwhereos += " and sysid="+workflowtype+" " ;
													}
													if(offical.equals("1")){
														sqlWhere+= " and isWorkflowDoc=1";
														if(officalType==1){
															sqlWhere += " and officalType in(1,3)";
															if(processId>0){
																String _sql = "select nodeids from workflow_process_relative wpr where officalType in (1,3) and pdid="+processId;
																RecordSet.executeSql(_sql);
																String nodeids = "";
																while(RecordSet.next()){
																	if(nodeids.equals("")){
																		nodeids = Util.null2String(RecordSet.getString("nodeids"));
																	}else{
																		nodeids = nodeids+","+Util.null2String(RecordSet.getString("nodeids"));
																	}
																}
																nodeids = nodeids.replaceAll(",{2,}",",");
																if(nodeids.equals(""))nodeids = "-1";
																sqlWhere += " and t2.nodeid in ("+nodeids+")";
															}
														}else if(officalType==2){
															sqlWhere += " and officalType=2";
															if(processId>0){
																String _sql = "select nodeids from workflow_process_relative wpr where officalType=2 and pdid="+processId;
																RecordSet.executeSql(_sql);
																String nodeids = "";
																while(RecordSet.next()){
																	if(nodeids.equals("")){
																		nodeids = Util.null2String(RecordSet.getString("nodeids"));
																	}else{
																		nodeids = nodeids+","+Util.null2String(RecordSet.getString("nodeids"));
																	}
																}
																nodeids = nodeids.replaceAll(",{2,}",",");
																if(nodeids.equals(""))nodeids = "-1";
																sqlWhere += " and t2.nodeid in ("+nodeids+")";
															}
														}
														
														/*if(viewcondition.equals("5")){
															sqlWhere+=" and t2.nodeid in (select useTempletNode from workflow_createdoc wc where wc.workflowid=t1.workflowid) ";
														}else if(viewcondition.equals("6")){
															sqlWhere+=" and t2.nodeid in (select signatureNodes from workflow_createdoc wc where wc.workflowid=t1.workflowid) ";
														}*/
													}
													sqlWhere+=")";
													if(!customResult.equals("")){
														sqlWhere +=" and t1.requestid in ("+customResult+")";
													}
           
													//add by bpf on 2013-11-14
													String countSql="select count(1) as wfCount "+fromSql+sqlWhere;
													String wfCount="0";
													/*
													RecordSet.executeSql(countSql);
													String wfCount="0";
											        while(RecordSet.next()){
											        	wfCount=RecordSet.getString("wfCount");
											        }
													*/
											        String operateString= "";
											        //流程操作菜单 add by Dracula @2014-1-6 
													
													String temptableString = "";
                                                String temptablerowString = "";
												String os_currentnodeorderby = "t1.currentnodeid";
												String os_currentnodeotherpara = "column:requestid";
                                                if(isopenos && isovertime != 1){
													os_currentnodeorderby = "t1.currentnodename";
													os_currentnodeotherpara = "column:requestid+column:currentnodename";
													if (RecordSet.getDBType().equals("oracle")) {
														backfields = " t1.requestid,t1.requestmark,t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.requestnamenew, t1.status,t1.requestlevel,t1.currentnodeid,to_char(nodeid) as currentnodename,t2.viewtype,t2.userid,t2.receivedate,t2.receivetime,t2.isremark,t2.nodeid,t2.agentorbyagentid,t2.agenttype,t2.isprocessed " + operateDateTimeFieldSql+" ,'0' as systype,t2.workflowtype";
													}else{
														backfields = " t1.requestid,t1.requestmark,t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.requestnamenew, t1.status,t1.requestlevel,t1.currentnodeid,cast(nodeid as nvarchar) as currentnodename,t2.viewtype,t2.userid,t2.receivedate,t2.receivetime,t2.isremark,t2.nodeid,t2.agentorbyagentid,t2.agenttype,t2.isprocessed " + operateDateTimeFieldSql+" ,'0' as systype,t2.workflowtype";
													}
													
	                                                para2 = "column:requestid+column:workflowid+column:viewtype+" + isovertime + "+" + user.getLanguage() + "+column:nodeid+column:isremark+" + user.getUID() + "+column:agentorbyagentid+column:agenttype+column:isprocessed+column:userid+"+myrequest+"+column:creater+column:systype+column:workflowtype";
                                                    fromSql = " from (select "+backfields0+" from (select "+backfields+" "+fromSql+""+sqlWhere+" union (select distinct "+backfieldsOs+" from ofs_todo_data "+sqlwhereos+") ) t1 ) t1 ";
                                                    orderby = " receivedate ,receivetime ";
                                                    //System.out.println(sqlwhereos);
                                                    temptableString = " <sql backfields=\"" + backfields0 + "\" sqlform=\"" + Util.toHtmlForSplitPage(fromSql) + "\" sqlwhere=\"\"  sqlorderby=\"" + orderby	+ "\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />";
                                                    String showname = ofso.getShowsysname();
                                                    if(!showname.equals("0")){
	                                                    if(scope.equals("done")||scope.equals("complete")){
		                                                    if(ofso.getShowdone().equals("1")){
			                                                        temptablerowString = "<col width=\"8%\" display=\""+hasshowsysname+"\" text=\"" + SystemEnv.getHtmlLabelName(22677, user.getLanguage())
			                                                                + "\" column=\"workflowtype\"  orderkey=\"workflowtype\" transmethod=\"weaver.workflow.request.todo.RequestUtil.getSysname\" otherpara=\""+showname+"\" />";
	                                                          }
                                                        }else{
	                                                        temptablerowString = "<col width=\"8%\" display=\""+hasshowsysname+"\" text=\"" + SystemEnv.getHtmlLabelName(22677, user.getLanguage())
		                                                                + "\" column=\"workflowtype\"  orderkey=\"workflowtype\" transmethod=\"weaver.workflow.request.todo.RequestUtil.getSysname\" otherpara=\""+showname+"\" />";
                                                        }
                                                    }
                                                }else{
                                                    temptableString = " <sql backfields=\"" + backfields + "\" sqlform=\"" + fromSql + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\"  sqlorderby=\"" + orderby	+ "\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />";
                                                }
						//System.out.println("-1202--belongtoshow-"+belongtoshow);		
					if(!userIDAll.equals(String.valueOf(user.getUID()))){
											
														String currentUserpara = "column:userid";
											        	String popedomOtherpara = "column:viewtype+column:isremark+column:isprocessed+column:nodeid+column:workflowid+"+scope;
											        	String popedomUserpara = userID + "_" + usertype;
											        	String popedomLogpara = "column:nodeid";
											        	String popedomNewwfgpara = "column:workflowid+column:agenttype";
											        	String popedomNewmsgpara = "column:workflowid+column:nodeid";
											        	operateString = "<operates>";
										        		operateString +=" <popedom async=\"false\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultOperation\" otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomUserpara+"\" ></popedom> ";
									        			if(offical.equals("1") && sysId==5){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:taoHong();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelName(20227, user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==6){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:signNature();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelName(21650, user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==1){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,93", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==2){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,33697", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && (sysId==3||sysId==4)){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,553", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==7){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,257", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && (sysId==9||sysId==14||sysId==15||scope.equals("done")||scope.equals("mine"))){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,553", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}
									        			operateString +="     <operate href=\"javascript:doReadIt();\" otherpara=\""+currentUserpara+"\" text=\"" + SystemEnv.getHtmlLabelName(25419, user.getLanguage()) + "\" index=\"0\"/>";
									        			//QC158666
									        			//客户门户时，不显示转发按钮
									        			if(!user.getLogintype().equals("2")){
									        			    operateString +="     <operate href=\"javascript:doReview();\"  otherpara=\""+currentUserpara+"\" text=\"" + SystemEnv.getHtmlLabelName(6011, user.getLanguage()) + "\" index=\"1\"/>";
									        			}
									 	       			operateString +="     <operate href=\"javascript:doPrint();\" otherpara=\""+currentUserpara+"\" text=\"" + SystemEnv.getHtmlLabelName(257, user.getLanguage()) + "\" index=\"2\"/>";
										 	        	operateString +="     <operate href=\"javascript:doNewwf();\" text=\"" + SystemEnv.getHtmlLabelName(16392, user.getLanguage()) + "\" otherpara=\""+popedomNewwfgpara+"\" index=\"3\"/>";
										 	        	//operateString +="     <operate href=\"javascript:doNewMsg();\" text=\"" + SystemEnv.getHtmlLabelName(16444, user.getLanguage()) + "\" otherpara=\""+popedomNewmsgpara+"\" index=\"4\"/>";
										 	       		operateString +="     <operate href=\"javascript:seeFormLog();\" text=\"" + SystemEnv.getHtmlLabelName(21625, user.getLanguage()) + "\" otherpara=\""+popedomLogpara+"\" index=\"5\"/>";
										 	       		
										 	       		operateString +="</operates>";
											        //System.out.println("sqlWhere_last"+sqlWhere);
											        //System.out.println("sqlForm"+fromSql);
													if (isMultiSubmit && iswaitdo == 1) {
														if( "1".equals(belongtoshow)){
                                                                    tableString = " <table instanceid=\"workflowRequestListTable\" pageId=\""+pageId+"\"   tabletype=\"checkbox\" pagesize=\""
                                                                            + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >"
                                                                            + " <checkboxpopedom  id=\"checkbox\"  popedompara=\"column:workflowid+column:isremark+column:requestid+column:nodeid+column:userid\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox\" />" ;

                                                                    tableString += temptableString ;

                                                                    tableString += operateString + "			<head>";

                                                                    tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
                                                                                + SystemEnv.getHtmlLabelName(1334, user.getLanguage())
                                                                                + "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle2\"  otherpara=\""
                                                                                + para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\" />";
																}else{
														tableString = " <table instanceid=\"workflowRequestListTable\" pageId=\""+pageId+"\"   tabletype=\"checkbox\" pagesize=\""
																+ PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID())
																+ "\" >"
																+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\"column:workflowid+column:isremark+column:requestid+column:nodeid+column:userid\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox\" />";
														tableString += temptableString ;
                                                        tableString += operateString + "<head>";

																	tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
																}
														tableString += "<col width=\"10%\" display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
														tableString += "<col width=\"6%\" display=\""+hascreater +"\"   text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
																+ "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
													
														tableString += " <col width=\"10%\" display=\""+hascreatedate +"\" id=\"createdate\" text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hasrequestlevel +"\"  id=\"quick\" text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";													   												
														tableString += "<col width=\"10%\" display=\""+hasreceivetime +"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hascurrentnode +"\"  id=\"hurry\" text=\"" + SystemEnv.getHtmlLabelName(18564,user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
														
														tableString += "<col width=\"8%\" display=\""+hasstatus +"\"  text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
														tableString += "<col width=\"15%\" display=\""+hasreceivedpersons +"\"  text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\" otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
														tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
														tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\"  text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
														tableString += temptablerowString ;														
														tableString += "			</head>" + "</table>";
													} else if("1".equals(isFromMessage)){
														//System.out.println("--12225----------------------------------------------------------------------------------");
														if( "1".equals(belongtoshow)){
														tableString = " <table instanceid=\"workflowRequestListTable\" pageId=\""+pageId+"\"   tabletype=\"checkbox\" pagesize=\""
																+ PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID())
																+ "\" >"
																+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\"column:viewtype+column:isremark+column:isprocessed\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchRstCkBoxForMsg\" />";
														tableString += temptableString ;
														tableString += operateString + "			<head>";
														
														tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle2\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
																}else{
														tableString = " <table instanceid=\"workflowRequestListTable\" pageId=\""+pageId+"\"   tabletype=\"checkbox\" pagesize=\""
																+ PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID())
																+ "\" >"
																+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\"column:viewtype+column:isremark+column:isprocessed\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchRstCkBoxForMsg\" />";
														tableString += temptableString ;
														tableString += operateString + "<head>";

																	tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"   pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\" />";
																}
														tableString += "<col width=\"10%\" display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
														
														tableString += "<col width=\"6%\" display=\""+hascreater +"\"   text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
																+ "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
													
														tableString += " <col width=\"10%\" display=\""+hascreatedate +"\" id=\"createdate\" text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hasrequestlevel +"\"  id=\"quick\" text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";													   												
														tableString += "<col width=\"10%\" display=\""+hasreceivetime +"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hascurrentnode +"\"  id=\"hurry\" text=\""+ SystemEnv.getHtmlLabelName(18564, user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
														tableString += "<col width=\"8%\" display=\""+hasstatus +"\"  text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
														tableString += "<col width=\"15%\" display=\""+hasreceivedpersons +"\"  text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\" otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
														tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
														tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\"  text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
														tableString += temptablerowString ;
														tableString += "			</head>" + "</table>";
													}else if("myall".equals(myrequest) || "myreqeustbywftype".equals(myrequest) || "myreqeustbywfid".equals(myrequest)){
														if("1".equals(belongtoshow)){
															sqlWhere += " and t1.creater = t2.userid" ;
														tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+pageId+"\" cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >";
														tableString += temptableString ;
                                                        tableString += operateString	+ "			<head>";
														
														tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle2\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
																}else{

														tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+pageId+"\" cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >";
														tableString += temptableString ;
                                                        tableString += operateString	+ "			<head>";
														
																	tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
																}
															tableString += " <col width=\"10%\"  display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
															
															tableString += " <col width=\"6%\" display=\""+hascreater +"\"  text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
																	+ "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";															
															tableString += "<col display=\""+hascreatedate +"\" width=\"10%\"  text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hasrequestlevel +"\"   text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";
															
															tableString += " <col width=\"10%\" display=\""+hasreceivetime +"\"  text=\"" + SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hascurrentnode +"\"   text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
															
																	tableString += " <col width=\"8%\" display=\""+hasstatus +"\"    text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
															tableString += " <col width=\"15%\" display=\""+hasreceivedpersons +"\"   text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\"  otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
															tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
															tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\" text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
															tableString += temptablerowString ;
														tableString += "			</head>" + "</table>";
													}else {
														//System.out.println("--1301----------------------------------------------------------------------------------");
														if( "1".equals(belongtoshow)){
																tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+pageId+"\" cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >";
																tableString += temptableString ;
																tableString  += operateString  + "			<head>";
																
																tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																			+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																			+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle2\"  otherpara=\""
																			+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
														}else{
																tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+pageId+"\" cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >";
																tableString += temptableString ;
																tableString  += operateString  + "			<head>";

																	tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
														}
															tableString += " <col width=\"10%\"  display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
															
															tableString += " <col width=\"6%\" display=\""+hascreater +"\"  text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
																	+ "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";															
															tableString += "<col display=\""+hascreatedate +"\" width=\"10%\"  text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hasrequestlevel +"\"   text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";
															
															tableString += " <col width=\"10%\" display=\""+hasreceivetime +"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hascurrentnode +"\"   text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
															
																	tableString += " <col width=\"8%\" display=\""+hasstatus +"\"    text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
															tableString += " <col width=\"15%\" display=\""+hasreceivedpersons +"\"   text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\"  otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
															tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
															tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\" text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
															tableString += temptablerowString ;
														tableString += "			</head>" + "</table>";
	
													}
												}else{
//System.out.println("-1421--belongtoshow-"+belongtoshow);
														String currentUserpara = "column:userid";
								        	String popedomOtherpara = "column:viewtype+column:isremark+column:isprocessed+column:nodeid+column:workflowid+"+scope;
											        	String popedomUserpara = userID + "_" + usertype;
											        	String popedomLogpara = "column:nodeid";
											        	String popedomNewwfgpara = "column:workflowid+column:agenttype";
											        	String popedomNewmsgpara = "column:workflowid+column:nodeid";
														
											        	operateString = "<operates>";
										        		operateString +=" <popedom async=\"false\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultOperation\" otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomUserpara+"\" ></popedom> ";
									        			if(offical.equals("1") && sysId==5){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:taoHong();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelName(20227, user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==6){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:signNature();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelName(21650, user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==1){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,93", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==2){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,33697", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && (sysId==3||sysId==4)){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,553", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && sysId==7){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,257", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}else if(offical.equals("1") && (sysId==9||sysId==14||sysId==15||scope.equals("done")||scope.equals("mine"))){
										 	       			operateString +="     <operate isalwaysshow=\"true\" href=\"javascript:doEditContent();\" otherpara=\""+isovertime+"\" text=\"" + SystemEnv.getHtmlLabelNames("1265,553", user.getLanguage()) + "\" index=\"6\"/>";
										 	       		}
									        			operateString +="     <operate href=\"javascript:doReadIt();\"  otherpara=\""+currentUserpara+"\" text=\"" + SystemEnv.getHtmlLabelName(25419, user.getLanguage()) + "\" index=\"0\"/>";
									        			//QC158666
                                                        //客户门户时，不显示转发按钮
                                                        if(!user.getLogintype().equals("2")){
                                                            operateString +="     <operate href=\"javascript:doReview();\" otherpara=\""+currentUserpara+"\" text=\"" + SystemEnv.getHtmlLabelName(6011, user.getLanguage()) + "\" index=\"1\"/>";
                                                        }
									 	       			operateString +="     <operate href=\"javascript:doPrint();\" otherpara=\""+currentUserpara+"\" text=\"" + SystemEnv.getHtmlLabelName(257, user.getLanguage()) + "\" index=\"2\"/>";
										 	        	operateString +="     <operate href=\"javascript:doNewwf();\" text=\"" + SystemEnv.getHtmlLabelName(16392, user.getLanguage()) + "\" otherpara=\""+popedomNewwfgpara+"\" index=\"3\"/>";
										 	        	//operateString +="     <operate href=\"javascript:doNewMsg();\" text=\"" + SystemEnv.getHtmlLabelName(16444, user.getLanguage()) + "\" otherpara=\""+popedomNewmsgpara+"\" index=\"4\"/>";
										 	       		operateString +="     <operate href=\"javascript:seeFormLog();\" text=\"" + SystemEnv.getHtmlLabelName(21625, user.getLanguage()) + "\" otherpara=\""+popedomLogpara+"\" index=\"5\"/>";
										 	       		
										 	       		operateString +="</operates>";
											        //System.out.println("sqlWhere_last"+sqlWhere);
											        //System.out.println("sqlForm"+fromSql);
													if (isMultiSubmit && iswaitdo == 1) {
														tableString = " <table instanceid=\"workflowRequestListTable\" pageId=\""+pageId+"\"   tabletype=\"checkbox\" pagesize=\""
																+ PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID())
																+ "\" >"
																+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\"column:workflowid+column:isremark+column:requestid+column:nodeid+column:userid\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox\" />";
														tableString += temptableString ;
														tableString += operateString + "			<head>";
														tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\"  orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
														
														tableString += "<col width=\"10%\" display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
														tableString += "<col width=\"6%\" display=\""+hascreater +"\"   text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
																+ "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
													
														tableString += " <col width=\"10%\" display=\""+hascreatedate +"\" id=\"createdate\" text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hasrequestlevel +"\"  id=\"quick\" text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";													   												
														tableString += "<col width=\"10%\" display=\""+hasreceivetime +"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hascurrentnode +"\"  id=\"hurry\" text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
														
														tableString += "<col width=\"8%\" display=\""+hasstatus +"\"  text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
														tableString += "<col width=\"15%\" display=\""+hasreceivedpersons +"\"  text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\" otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
														tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
														tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\"  text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
														tableString += temptablerowString ;
														tableString += "			</head>" + "</table>";
													} else if("1".equals(isFromMessage)){
														//System.out.println("--12225----------------------------------------------------------------------------------");
														tableString = " <table instanceid=\"workflowRequestListTable\" pageId=\""+pageId+"\"   tabletype=\"checkbox\" pagesize=\""
																+ PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID())
																+ "\" >"
																+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\"column:viewtype+column:isremark+column:isprocessed\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchRstCkBoxForMsg\" />";
														tableString += temptableString ;
														tableString += operateString + "			<head>";
														tableString += "<col width=\"19%\" display=\""+hasrequestname+"\" text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  />";
														tableString += "<col width=\"10%\" display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
														
														tableString += "<col width=\"6%\" display=\""+hascreater +"\"   text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
																+ "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
													
														tableString += " <col width=\"10%\" display=\""+hascreatedate +"\" id=\"createdate\" text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hasrequestlevel +"\"  id=\"quick\" text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";													   												
														tableString += "<col width=\"10%\" display=\""+hasreceivetime +"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
														tableString += "<col width=\"8%\" display=\""+hascurrentnode +"\"  id=\"hurry\" text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
														tableString += "<col width=\"8%\" display=\""+hasstatus +"\"  text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
														tableString += "<col width=\"15%\" display=\""+hasreceivedpersons +"\"  text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\" otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
														tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
														tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\"  text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
														tableString += temptablerowString ;
														tableString += "			</head>" + "</table>";
													}else if("myall".equals(myrequest) || "myreqeustbywftype".equals(myrequest) || "myreqeustbywfid".equals(myrequest)){
														tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+pageId+"\" cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >";
														tableString += temptableString ;
														tableString	+= operateString	+ "			<head>";

															tableString += " <col width=\"19%\" display=\""+hasrequestname+"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"/>";
															tableString += " <col width=\"10%\"  display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
															
															tableString += " <col width=\"6%\" display=\""+hascreater +"\"  text=\"" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
																	+ "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";															
															tableString += "<col display=\""+hascreatedate +"\" width=\"10%\"  text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hasrequestlevel +"\"   text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";
															
															tableString += " <col width=\"10%\" display=\""+hasreceivetime +"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hascurrentnode +"\"   text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
															
																	tableString += " <col width=\"8%\" display=\""+hasstatus +"\"    text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
															tableString += " <col width=\"15%\" display=\""+hasreceivedpersons +"\"   text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\"  otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
															tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
															tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\" text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
															tableString += temptablerowString ;
														tableString += "			</head>" + "</table>";
													}else {
														tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+pageId+"\" cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >";
															tableString	+= temptableString ;
															tableString	+= operateString + "			<head>";
															tableString += " <col width=\"19%\" display=\""+hasrequestname+"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
																	+ "\" column=\"requestname\" orderkey=\"requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""
																	+ para2 + "\"  pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"/>";
															tableString += " <col width=\"10%\"  display=\""+hasworkflowname +"\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
																	+ "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWorkflowname\" />";
															
															tableString += " <col width=\"6%\" display=\""+hascreater +"\"  text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
																	+ "\" column=\"creater\" orderkey=\"creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
															tableString += "<col display=\""+hascreatedate +"\" width=\"10%\"  text=\""
																	+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
																	+ "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hasrequestlevel +"\"   text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
																	+ "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
																	+ user.getLanguage() + "\"/>";
															
															tableString += " <col width=\"10%\" display=\""+hasreceivetime +"\"  text=\""
																	+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
																	+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
															tableString += " <col width=\"8%\" display=\""+hascurrentnode +"\"   text=\"" + SystemEnv.getHtmlLabelName(18564, user.getLanguage())
																	+ "\" column=\"currentnodeid\" otherpara=\""+os_currentnodeotherpara+"\" orderkey=\""+os_currentnodeorderby +"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
															
																	tableString += " <col width=\"8%\" display=\""+hasstatus +"\"    text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
															tableString += " <col width=\"15%\" display=\""+hasreceivedpersons +"\"   text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\"  otherpara=\"" + para4
																	+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
															tableString += "<col width=\"6%\" display=\"false\"  text=\""
																	+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
																	+ "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
																	+ user.getLanguage() + "\"/>";
															tableString += "<col width=\"15%\" display=\""+hasrequestmark +"\" orderkey=\"t1.requestmark\" text=\"" + SystemEnv.getHtmlLabelName( 19502 , user.getLanguage()) + "\" column=\"requestmark\"/>";
															tableString += temptablerowString ;
														tableString += "			</head>" + "</table>";
	
													}


}
														
												%><wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
											</td>
										</tr>
									</TABLE>
									<!--   added by xwj for td2023 on 2005-05-20  end  -->
								</td>
							</tr>
						</TABLE>
					</td>
				</tr>
			</table>
			
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			</FORM>
		<SCRIPT language="javascript">
		function rightMenuSearch(){
			if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
				OnSearch();
			}else{
				try{
					jQuery("span#searchblockspan",parent.document).find("img:first").click();
				}catch(e){
					OnSearch();
				}
			}
		}
		
		jQuery("#topTitle").topMenuTitle({searchFn:searchTitle});
		
		function searchTitle()
		{	
			var value=$("input[name='flowTitle']",parent.document).val();
		    $("input[name='requestname']").val(value);
			$GetEle("fromself").value="1";
			$GetEle("isfirst").value="1";
			$GetEle("frmmain").submit();
			//parent.$(".e8_box").Tabs({method:"set",faNumSpn:'1'});//全部
			//parent.$(".e8_box").Tabs({method:"set",fnNumSpn:'1'});//未读
			//parent.$(".e8_box").Tabs({method:"set",frNumSpn:'1'});//反馈
			//parent.$(".e8_box").Tabs({method:"set",foNumSpn:'1'});//超时
			//parent.$(".e8_box").Tabs({method:"set",fsNumSpn:'1'});//被督办






		}
		function OnChangePage(start){
		        $GetEle("start").value = start;
		        $GetEle("frmmain").submit();
		}
		
		function setWFbyType(obj)
		{
			var selvar = $(obj).val();
			jQuery("#wfidbytype").val("");
			jQuery("span[name='wfidbytypespan']").html("");
			jQuery("#outwfidbytypediv").next().find("button").remove();
			jQuery("#outwfidbytypediv").next().find("span").append("<button class='Browser e8_browflow' type='button' onclick=showModalDialogForBrowser(event,'/workflow/workflow/WFTypeBrowserContenter.jsp?wftypeid="+selvar+"','#','wfidbytype',true,1,'',{name:'wfidbytype',hasInput:true,zDialog:true,dialogTitle:'<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>',arguments:''});></button>")
		}
		
		
		//搜索
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
						//console.dir(item);
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
		    $GetEle("frmmain").submit();
		}
		
		function __displayloaddingblock() {
			try {
				var pTop= parent.document.body.offsetHeight/2+parent.document.body.scrollTop - 50 + jQuery(".e8_boxhead", parent.document).height()/2 ;
     			var pLeft= parent.document.body.offsetWidth/2 - (65);
     			
				//var __top = (jQuery(document.body).height())/2 - 40;
				//var __left = (jQuery(document.body).width() - parseInt(157))/2
				jQuery("#submitloaddingdiv", parent.document).css({"top":pTop, "left":pLeft, "display":"inline-block;"});
				jQuery("#submitloaddingdiv", parent.document).show();
				jQuery("#submitloaddingdiv_out", parent.document).show();
			} catch (e) {}
		}
		
		jQuery(function () {
			
		});
		
		function __hidloaddingblock() {
			try {
				//var __top = (jQuery(document.body).height())/2 - 40;
				//var __left = (jQuery(document.body).width() - parseInt(157))/2
				//jQuery("#submitloaddingdiv", parent.document).css({"top":__top, "left":__left, "display":"inline-block;"});
				jQuery("#submitloaddingdiv", parent.document).hide();
				jQuery("#submitloaddingdiv_out", parent.document).hide();
			} catch (e) {}
		}

		
		function OnMultiSubmitNew(obj){
			var _reqIds = _xtable_CheckedCheckboxId();
		    if(_reqIds!=""){
				return OnMultiSubmitNew1(obj);
			}else{
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		    }
		}
		
		
		function OnMultiSubmitNew1(obj){
		
			<%
			int multisubmitnotinputsign = 0;
			RecordSet.executeSql("select multisubmitnotinputsign from workflow_RequestUserDefault where userId = "+ user.getUID());
			if(RecordSet.next()){
				multisubmitnotinputsign = Util.getIntValue(Util.null2String(RecordSet.getString("multisubmitnotinputsign")), 0);
			}
			if (multisubmitnotinputsign == 0) {
			%>
		
		    if(_xtable_CheckedCheckboxId()!=""){
				//$GetEle("multiSubIds").value = _xtable_CheckedCheckboxId();
			    //$GetEle("frmmain").submit();
				//obj.disabled=true;
				//批量提交签字意见
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/workflow/search/WFSuperviseSignature.jsp?fromtype=1";
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(26039,user.getLanguage())%>";
				dialog.Width = 450;
				dialog.Height = 227;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.callbackfun = function (paramobj, remark) {
					OnMultiSubmitNew2(obj, remark);
				}
				dialog.show();
			}else{
		        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		    }
		    <%} else {%>
		    	OnMultiSubmitNew2(obj);
		    <%}%>
		}
        //取得已选中的checkbox对应的账号信息
		function getbelongtoUserids(){
		  var _CheckboxRequestIds = _xtable_CheckedCheckboxId();
		  var checkedBelongtoUserids = "";
		  if(_CheckboxRequestIds != ""){
            var _CheckboxRequestIdArray = _CheckboxRequestIds.split(",");
            for(var i = 0; i < _CheckboxRequestIdArray.length; i++){
                var CheckboxRequestId = _CheckboxRequestIdArray[i];
                if(CheckboxRequestId == null || CheckboxRequestId == 0){
                    continue;
                }
                jQuery("#_xTable_" + CheckboxRequestId).each(function(){
                    jQuery(this).parent().parent().next().find("a").each(function(){
                        var linkHref = jQuery(this).attr("href");
                        if(linkHref.indexOf("/workflow/request/ViewRequest.jsp") >= 0){
	                        if(linkHref.indexOf("f_weaver_belongto_userid=")<=0){
	                            checkedBelongtoUserids += ",";
	                        }else{
	                            linkHref = linkHref.substring(linkHref.indexOf("f_weaver_belongto_userid=") + ("f_weaver_belongto_userid=").length);
	                            linkHref = linkHref.substring(0,linkHref.indexOf("&"));
	                            checkedBelongtoUserids += linkHref + ",";
	                        }
                        }
                    });
                });
            }
		  }
		  return checkedBelongtoUserids;
		
		}
		
		
		
		function OnMultiSubmitNew2(obj, remark){
		    if(_xtable_CheckedCheckboxId()!=""){
				//$GetEle("multiSubIds").value = _xtable_CheckedCheckboxId();
			    //$GetEle("frmmain").submit();
				//obj.disabled=true;
				__displayloaddingblock();
				//对应一人多岗批量提交无法提交次账号流程的问题
				var belongtoUserids = getbelongtoUserids();
				<%
				if (true) {
					method = Util.null2String(request.getParameter("method"));
					String wftype=Util.null2String(request.getParameter("wftype"));
					int flowAll=Util.getIntValue(Util.null2String(request.getParameter("flowAll")), 0);
					int flowNew=Util.getIntValue(Util.null2String(request.getParameter("flowNew")), 0);
					workflowid = Util.null2String(request.getParameter("workflowid"));
				%>
				var multsuburl = "/workflow/request/RequestListOperation.jsp?multiSubIds=" + _xtable_CheckedCheckboxId() + "&workflowid=<%=workflowid%>&method=<%=method%>&wftype=<%=wftype%>&flowAll=<%=flowAll%>&flowNew=<%=flowNew%>&viewcondition=<%=viewcondition%>&pagefromtype=1";
				if(belongtoUserids != null){
				    multsuburl += "&belongtoUserids=" + belongtoUserids;
				}
				<%
				}
				%>
				jQuery.ajax({
					type: "post",
					cache: false,
					url: multsuburl,
					data:{'remark' : remark},
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(){
					},
				    error:function (XMLHttpRequest, textStatus, errorThrown) {
				    } , 
				    success : function (data, textStatus) {
				    	if(data == 10){
					    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129774,user.getLanguage())%>");
					    }
				    	_xtable_CleanCheckedCheckbox();
				    	_table.reLoad();
				    }
				});
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





		function doReadIt(requestid,otherpara,obj){
			//alert(otherpara);
			//alert(userid);
			var flag = "<%=flag%>";
			$.ajax({ 
		        type: "GET",
		        url: "WFSearchResultReadIt.jsp?f_weaver_belongto_userid="+otherpara+"&f_weaver_belongto_usertype=0&requestid="+requestid+",&userid=<%=userID%>&usertype=<%=usertype%>&logintype=<%=logintype%>&flag=<%=flag%>",
		        success:function(){
		        	if(flag == "newWf"){
		        		parent.window.location.href="/system/sysRemindWfLink.jsp?f_weaver_belongto_userid="+otherpara+"&f_weaver_belongto_usertype=0&flag=newWf";
		        	}else if(flag == "rejectWf"){
		        		parent.window.location.href="/system/sysRemindWfLink.jsp?f_weaver_belongto_userid="+otherpara+"&f_weaver_belongto_usertype=0&flag=rejectWf";
		        	}else if(flag == "overtime"){
		        		parent.window.location.href="/workflow/search/WFTabForOverTime.jsp?f_weaver_belongto_userid="+otherpara+"&f_weaver_belongto_usertype=0&isovertime=1&viewType=<%=viewType%>&isFromMessage=1&flag=overtime&overtimetype=<%=overtimetype%>"
		        	}else if(flag == "endWf"){
		        		parent.window.location.href="/system/sysRemindWfLink.jsp?f_weaver_belongto_userid="+otherpara+"&f_weaver_belongto_usertype=0&flag=endWf";
		        	}else{
		        		_table.reLoad();
		        	}
		        }
	        });
		}
		
		//批量标志为已读






		function doAllReadIt(){
			var requestid = _xtable_CheckedCheckboxId();
			var flag = "<%=flag%>";
		    if(requestid!=""){
				$.ajax({ 
			        type: "GET",
			        url: "WFSearchResultReadIt.jsp?requestid="+requestid+"&userid=<%=userID%>&usertype=<%=usertype%>&logintype=<%=logintype%>&flag=<%=flag%>",
			        success:function(){
			        	if(flag == "newWf"){
			        		parent.window.location.href="/system/sysRemindWfLink.jsp?flag=newWf";
			        	}else if(flag == "rejectWf"){
			        		parent.window.location.href="/system/sysRemindWfLink.jsp?flag=rejectWf";
			        	}else if(flag == "overtime"){
			        		parent.window.location.href="/workflow/search/WFTabForOverTime.jsp?isovertime=1&viewType=<%=viewType%>&isFromMessage=1&flag=overtime&overtimetype=<%=overtimetype%>"
			        	}else if(flag == "endWf"){
			        		parent.window.location.href="/system/sysRemindWfLink.jsp?flag=endWf";
			        	}else{
			        		_table.reLoad();
			        	}
			        }
		        });
			}else{
		        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		    }
			

		}
		
		//打开转发对话框






		function openDialog(title, url) {　
			var dlg = new window.top.Dialog(); //定义Dialog对象
			// dialog.currentWindow = window;
			dlg.Model = false;　　　
			dlg.Width = 1060; //定义长度
			dlg.Height = 500;　　　
			dlg.URL = url;　　　
			dlg.Title = "<%=SystemEnv.getHtmlLabelName(24964,user.getLanguage())%>";
			dlg.maxiumnable = true;　　　
			dlg.show();
			//保留对话框对象






			window.dialog = dlg;
		}
		
		//分页控件 菜单 转发功能
		function doReview(requestid,userid)
		{
			//看原逻辑应该有保存表单签章，暂时不知其逻辑,并还有一个参数



			//alert(userid);

			//目前只要有转发按钮的都打开转发页面
			//参考ManageRequestNoFormIframe.jsp
			//isovertime = parseInt(isovertime);
			//isovertime = !isovertime?0:isovertime;
			var forwardurl = "/workflow/request/Remark.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype=0&requestid="+requestid;
			jQuery.ajax({
				//url:"/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype=0&isovertime="+isovertime+"&requestid="+requestid,
				url:"/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype=0&requestid="+requestid,
				type:"get",
				dataType:"html",
				beforeSend:function(){
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>");
				},
				success:function(data){
					openDialog("",forwardurl);
				},
				complete:function(xhr){
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>",false);
				},
				error:function(){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%>");
				}
			});
			
		}
		
		//分页控件 菜单 打印功能
		function doPrint(requestid,userid)
		{	
			//打印貌似没这么简单，看原始逻辑还需要设置一些信息





			//目前只是把打印页面打开
			//参考ManageRequestNoFormIframe.jsp
			openFullWindowHaveBar("/workflow/request/PrintRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype=0&requestid="+requestid+"&isprint=1&fromFlowDoc=1");
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
			//openFullWindowHaveBar("/workflow/request/RequestModifyLogView.jsp?requestid="+requestid+"&nodeid="+nodeid+"&isAll=0&ismonitor="+_wfmonitor+"&urger=0");
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			var url = "/workflow/request/RequestModifyLogView.jsp?requestid="+requestid+"&nodeid="+nodeid+"&isAll=0&ismonitor="+_wfmonitor+"&urger=0";
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(21625,user.getLanguage())%>";
			dialog.Width = 550;
			dialog.Height = 550;
			dialog.Drag = true;
			dialog.maxiumnable = true;
			dialog.URL = url;
			dialog.show();
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
		
		function changeType(type,span1,span2){
			if(type=="1"){
				jQuery("#"+span1).css("display","none");
				jQuery("#"+span2).css("display","");		
			}else{
				jQuery("#"+span2).css("display","none");
				jQuery("#"+span1).css("display","");
			}
		}
		
		function changeFlowType() {
			_writeBackData('workflowid', 1, {id:'',name:''});
		}
		
		function getFlowWindowUrl(){
			return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("workflowtype").value+"&showos=1";
		}
		</script>
		<SCRIPT language="javascript" src="/js/ecology8/request/wFCommonAdvancedSearch_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<input type="hidden" value="<%=wfCount %>" id="wfCount" />
	</body>
</html>
