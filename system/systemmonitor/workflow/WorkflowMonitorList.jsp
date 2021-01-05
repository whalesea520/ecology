<%@ page language="java" contentType="text/html; charset=UTF-8" %> <!--added by xwj  for td2903  20051019-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="page" />
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<jsp:useBean id="WorkflowVersion" class="weaver.workflow.workflow.WorkflowVersion" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="xss" class="weaver.filter.XssUtil" scope="page" />
<!--以下是显示定制组件所需的js -->
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
 <SCRIPT type="text/javascript" src="../../js/weaver_wev8.js"></script>


</head>

<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("ovfail".equals(info)){%>
  top.Dialog.alert(<%=SystemEnv.getHtmlLabelName(18566,user.getLanguage())%>)
 <%}
 else if("rbfail".equals(info)){%>
 top.Dialog.alert(<%=SystemEnv.getHtmlLabelName(18567,user.getLanguage())%>)
 <%}
 else{
 
 }
 }%>
 

</script>
<%----xwj for td3665 20060301 end---%>


<script type="text/javascript">
        jQuery(function(){
				jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	  		 	//jQuery("#hoverBtnSpan").hoverBtn();	  		 	
		});
		function onBtnSearchClick(){
			var requestName=jQuery("#searchInput",parent.document).val();
			jQuery("input[name='requestname']").val(requestName);
			jQuery('#weaver').submit();
		}
		
		function rightMenuSearch(){
			if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
				jQuery('#weaver').submit();
			}else{
				try{
					jQuery("span#searchblockspan",parent.document).find("img:first").click();
				}catch(e){
					jQuery('#weaver').submit();
				}
			}
		}
</script>


<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16758,user.getLanguage());
String needfav ="1";
String needhelp ="";
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:rightMenuSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deleteWorkflow(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(RecordSet.getDBType().equals("db2")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=" + xss.put("where int(operateitem)=85 and operatesmalltype=1") + ",_self} " ;
}else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=" + xss.put("where operateitem=85 and operatesmalltype=1") + ",_self} " ;
}
if(false)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+",javascript:doStop(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+",javascript:doCancel(this)(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+",javascript:doRestart(this)(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doOverBackMutil(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<FORM id=weaver name=weaver method=get action="WorkflowMonitorList.jsp?offical=<%=offical %>&officalType=<%=officalType %>"><%--xwj for td2978 20051108--%>
<input type=hidden name=fromself value="1">
<input type=hidden name=operation>
<input type=hidden name=offical id = offical value="<%=offical%>">
<input type=hidden name=officalType id = officalType value="<%=officalType%>">
<div style="display:none">
<%
if(false)
{
%>
<BUTTON type="button" class=btnDelete accessKey=D onclick="doStop(this)"><U>S</U>-<%=SystemEnv.getHtmlLabelName(20387,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btnDelete accessKey=D onclick="doCancel(this)"><U>C</U>-<%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btnDelete accessKey=D onclick="doRestart(this)"><U>R</U>-<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></BUTTON>
<%
}
%>
<BUTTON type="button" class=btnRefresh accessKey=R type="button" onclick="OnChangePage(1)"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btnDelete accessKey=D onclick="deleteWorkflow(this)"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btn accessKey=R onClick="location.href='/system/SystemMaintenance.jsp'"><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
</div>
<%
ArrayList canoperaternode = new ArrayList(); //added by xwj  for td2903  20051019

/* --- added by xwj  for td2903  20051019 --  B E G I N ---*/
ArrayList monitorWfList = new ArrayList();
String monitorWfStrs = "";
//RecordSet.executeSql("select * from workflow_monitor_bound where monitorhrmid = " + user.getUID());
//if(RecordSet.next()){
//	monitorWfStrs="1";
//monitorWfList.add(RecordSet.getString("workflowid"));
//}

/* --- added by xwj  for td2903  20051019 --  E N D ---*/

String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String typeid ="" ;
String createrid2 =Util.null2String(request.getParameter("createrid2"));
String requestlevel ="" ;
String requestname ="" ;//added xwj for for td2903  20051019
int requestid = -1;
String gdzt = "";
String tszt = "";

int ownerdepartmentid = Util.getIntValue(request.getParameter("ownerdepartmentid"),0);
int creatersubcompanyid=Util.getIntValue(request.getParameter("creatersubcompanyid"),0);
int unophrmid=Util.getIntValue(request.getParameter("unophrmid"),0);

String fromself =Util.null2String(request.getParameter("fromself"));
String fromquery =Util.null2String(request.getParameter("fromquery"));


//if(fromself.equals("1")) {
	//String creatertype = Util.null2String(request.getParameter("creatertype"));
	//String createrid = Util.null2String(request.getParameter("createrid"));
	//String createrid2 = Util.null2String(request.getParameter("createrid2"));
	workflowid = Util.null2String(request.getParameter("workflowid"));
	nodetype = Util.null2String(request.getParameter("nodetype"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
	requestlevel = Util.null2String(request.getParameter("requestlevel"));
	typeid = Util.null2String(request.getParameter("typeid"));
	requestname = Util.null2String(request.getParameter("requestname"));//added xwj for for td2903  20051019
	gdzt = Util.null2String(request.getParameter("gdzt"));
	tszt = Util.null2String(request.getParameter("tszt"));
	String createdateselect = Util.null2String(request.getParameter("createdateselect"));
	
	String wfid =  Util.null2String(request.getParameter("wfid"));
	String wftypeid  = Util.null2String(request.getParameter("wftypeid"));
	//修复流程监控时原页面搜索，在高级搜索换条件搜索时，列表为空的问题
	if(!"".equals(fromself)){
		wfid = workflowid;
		wftypeid = typeid;
	}
	
	String typename = "";
	if(!"".equals(typeid)){
		RecordSet.execute("select typename from workflow_type where id = " + typeid);
		RecordSet.next();
		typename = RecordSet.getString(1);
	}
	
	String flowname = "";
	if(!"".equals(workflowid)){
		RecordSet.execute("select workflowname from workflow_base where id = " + workflowid);
		RecordSet.next();
		flowname = RecordSet.getString(1);
	}
	//System.out.println("======"+request.getParameter("flowTitle"));
	if("".equals(requestname)){
        //流程标题
		requestname = Util.null2String(request.getParameter("flowTitle"));
	}
	requestid = Util.getIntValue(Util.null2String(request.getParameter("requestid")),-1);

    SearchClause.setWorkflowId(workflowid);
    SearchClause.setNodeType(nodetype);
    SearchClause.setFromDate(fromdate);
    SearchClause.setToDate(todate);
    SearchClause.setCreaterType(creatertype);
    SearchClause.setCreaterId(createrid);
    SearchClause.setRequestLevel(requestlevel);
    SearchClause.setRequestName(requestname);//added xwj for for td2903  20051019
//}
//else {
//	workflowid = Util.null2String(request.getParameter("workflowid"));///SearchClause.getWorkflowId();
//	nodetype = SearchClause.getNodeType();
//	fromdate = "2013-01-01";//SearchClause.getFromDate();
//	todate = SearchClause.getToDate();
//	creatertype = SearchClause.getCreaterType();
//	createrid = SearchClause.getCreaterId();
//	requestlevel = SearchClause.getRequestLevel();
//	requestname = SearchClause.getRequestName();//added xwj for for td2903  20051019
//	if("".equals(requestname)){
        //流程标题
//		requestname = Util.null2String(request.getParameter("flowTitle"));
//	}
//}

String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;

String logintype = ""+user.getLogintype();
String userlang = ""+user.getLanguage();
int usertype = 0;

if(CurrentUser.equals("")) {
    CurrentUser = ""+user.getUID();
    if(logintype.equals("2")) usertype= 1;
}

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

String pageIdStr = "6";

Map<String,String> sqlMap = Monitor.getWorkFlowRightSql(request,user,CurrentUser);
String sqlwhere = sqlMap.get("sqlwhere");

String orderby = sqlMap.get("orderby");

String tablename = sqlMap.get("tablename");

String backfields = sqlMap.get("backfields");

String fromSql = sqlMap.get("fromSql");

%>
<input type='hidden' name='wfid' value='<%=wfid %>' />
<input type='hidden' name='wftypeid' value='<%=wftypeid %>' />
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/workflowMonitor_wev8.js"></script>
		<table id="topTitle" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>" style="font-size:12px" class="e8_btn_top middle" onclick="deleteWorkflow(this)">
					&nbsp;&nbsp;&nbsp;
					<input type="text" id="searchInput" class="searchInput" value="<%=Util.null2String(request.getParameter("requestname")) %>"/>
					&nbsp;&nbsp;
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347, user.getLanguage())%></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
		int flowAll=100;
		int flowNew=101;
		int flowResponse=102;
		int flowOut=103;
		%>
		
		<div id="tabDiv">
			<span id="hoverBtnSpan">
			<span class="selectedTitle" doingType="flowAll">全部
			</span><span doingType="flowNew">今天
			</span><span doingType="flowResponse">本周
			</span><span doingType="flowOut">本月
			</span><span doingType="flowOut">本季
			</span><span doingType="flowOut">本年
			</span>
			</span>
			
			<input type="button" value="批量删除" class="e8_btn_top" />
		</div>
		
		
		
		
  <!--高级搜索-->		
<div class="advancedSearchDiv" id="advancedSearchDiv">



   <wea:layout type="4col">
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
		    	<wea:item>
					 <input type="text" style='width:80%;' name="requestname"  value="<%=Util.null2String(request.getParameter("requestname"))%>">
					<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.getWFPageId(pageIdStr) %>"/>
		    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%></wea:item>
	    	<wea:item> <input type="text" name="workcode" style='width:80%;'  value='<%=Util.null2String(request.getParameter("workcode"))%>' ></wea:item>
	    	
	    	<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
	    	<wea:item>
	    	<brow:browser viewType="0" name="typeid" browserValue='<%=typeid %>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser2.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser2"
								browserDialogWidth="600px"
								browserSpanValue='<%=typename %>'></brow:browser>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(26361, user.getLanguage())%></wea:item>
	    	<wea:item>
				<% String wfbytypeBrowserURL = "/workflow/workflow/WFTypeBrowserContenter2.jsp";%>
		    	<brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid %>'  browserOnClick="" browserUrl='<%=wfbytypeBrowserURL %>' hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=workflowBrowser2" width="80%" browserSpanValue='<%=flowname %>'> </brow:browser>
	    	</wea:item>
	    	
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<select class=inputstyle name=requestlevel style='width:80%' size=1>
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
	    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
	    	<wea:item >
	    		 <span style='float:left;width:100px'>
						<select class=inputstyle name=creatertype  style='height:25px;width:100px' onchange="changeType(this.value,'createrid','createrid2');">
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
			   
                   <brow:browser viewType="0" name="createrid" browserValue='<%= createrid+"" %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(createrid+""),user.getLanguage())%>'> 
				   </brow:browser> 

                </span>
	   
				 <span id="createrid2selspan" style="<%=!(creatertype.equals("0") || creatertype.equals(""))?"":"display:none;float:left;" %>">

	                      <brow:browser viewType="0" name="createrid2" browserValue='<%= createrid2+"" %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=7"  browserSpanValue='<%=Util.toScreen(CustomerInfo.getCustomerInfoname(createrid2+""),user.getLanguage())%>'> 
				         </brow:browser> 

				</span>
	    	</wea:item>
	    	
	    </wea:group>
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  attributes="{'itemAreaDisplay':'none'}">
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%= ""+ownerdepartmentid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=ownerdepartmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%= ""+creatersubcompanyid %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=creatersubcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
	    	 <wea:item >
	    		<span class="wuiDateSpan" selectId="createdateselect"  selectValue="<%=createdateselect%>">
					<input class=wuiDateSel type="hidden" name="createdatefrom" value="<%=Util.null2String(request.getParameter("createdatefrom"))%>">
					<input class=wuiDateSel type="hidden" name="createdateto" value="<%=Util.null2String(request.getParameter("createdateto"))%>">
				</span>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(18376, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		  <input type="text" name="requestid" onkeyup="value=value.replace(/[^\d]/g,'')" style='width:80%' value="<%=Util.null2String(request.getParameter("requestid"))%>">
	    	</wea:item>
             <wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
			 <wea:item>
			       <select class=inputstyle size=1 name=nodetype style='width:80%'>
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
			 <wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%> </wea:item>
			 <wea:item>
			        <brow:browser viewType="0" name="docids" browserValue='<%=Util.null2String(request.getParameter("docids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(Util.null2String(request.getParameter("docids"))+""),user.getLanguage())%>'> </brow:browser>
			 </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		  <select class=inputstyle size=1 name=gdzt style='width:80%'>
						<option value="0" <%if("0".equals(gdzt)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%> </option>
						<option value="1" <%if("1".equals(gdzt)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%> </option>
						<option value="2" <%if("2".equals(gdzt)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%> </option>
			      </select>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(82819, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		  <select class=inputstyle size=1 name=tszt style='width:80%'>
						<option value="">&nbsp;</option>
						<option value="0" <%if("0".equals(tszt)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(18360, user.getLanguage())%> </option>
						<option value="1" <%if("1".equals(tszt)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(20387, user.getLanguage())%> </option>
						<option value="2" <%if("2".equals(tszt)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(16210, user.getLanguage())%> </option>
			      </select>
	    	</wea:item>
	    	
			  <wea:item><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></wea:item>
			  <wea:item>
			         <brow:browser viewType="0" name="hrmids" browserValue='<%=Util.null2String(request.getParameter("hrmids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(Util.null2String(request.getParameter("hrmids"))+""),user.getLanguage())%>'> </brow:browser>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
			  <wea:item>
			          <brow:browser viewType="0" name="crmids" browserValue='<%=Util.null2String(request.getParameter("crmids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=Util.toScreen(CustomerInfo.getCustomerInfoname(Util.null2String(request.getParameter("crmids"))+""),user.getLanguage())%>'> </brow:browser>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
			  <wea:item>
			         <brow:browser viewType="0" name="proids" browserValue='<%=Util.null2String(request.getParameter("proids"))%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="33%" browserSpanValue='<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(Util.null2String(request.getParameter("proids"))+""),user.getLanguage())%>'> 
			         </brow:browser>
            </wea:item>
		
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_submit"/>
					<span class="e8_sep_line">|</span>
				<input type="button"  value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();">
					<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>


</div>	




						<input name="start" type="hidden" value="<%=start%>">
						<input type="hidden" name="multiRequestIds" value="">
						<input type="hidden" name="multiSubIds" id="multiSubIds" value="">
						<input type="hidden" name="flag" id="flag" value="">
						<input type="hidden" name="requestfrom" id="requestfrom" value="">
						<input type="hidden" name="requestidvalue" id="requestidvalue" value="">
						<%
						String tableString = "";
						if(perpage <2) perpage=10;                                 
						//String backfields = " a.requestid, a.currentnodeid, a.createdate, a.createtime,a.lastoperatedate, a.lastoperatetime,a.creater, a.creatertype, a.workflowid, a.requestname, a.status, a.requestlevel,b.isview ";
						
						//String fromSql  = " workflow_requestbase a,(select max(isview) isview,workflowid,monitorhrmid from workflow_monitor_bound where monitorhrmid="+user.getUID()+" group by workflowid,monitorhrmid) b ,workflow_base wb , workflow_type wt ";
						sqlwhere += " and (a.deleted <> 1 or a.deleted is null or a.deleted = '')";
						String sqlWhere = sqlwhere;

						//System.out.print("select "+backfields + "from "+fromSql+" "+sqlWhere);
						//String para2="column:requestid+"+CurrentUser+"+"+logintype+"+"+userlang;
						String para2="column:requestid+"+CurrentUser+"+"+logintype+"+"+userlang+"+column:currentstatus+column:creater+column:currentnodetype+column:workflowid";
						String para11="column:requestname+"+"("+"column:requestid+"+")";
						//String para1="column:requestid+column:isview";
						String para1="column:requestid+column:workflowid+"+userlang+"+"+CurrentUser+"+column:creater";
						String para4=userlang+"+"+user.getUID();
						String para3="column:workflowid+"+CurrentUser+"+column:creater+"+logintype;
						String requestidpara = "column:requestid";
						
						String operateString= "";
			        	operateString = "<operates>";
		        		operateString +=" <popedom transmethod=\"weaver.workflow.monitor.Monitor.getWFMonitorListOperation\" otherpara=\""+para2+"\"></popedom> ";
	        			operateString +="     <operate href=\"javascript:deleteWorkflowByRequestID();\" text=\""+SystemEnv.getHtmlLabelName(23777, user.getLanguage())+"\" otherpara=\""+requestidpara+"\" index=\"0\"/>";
	        			operateString +="     <operate href=\"javascript:doMonitorRequestSignle();\" text=\""+SystemEnv.getHtmlLabelName(20387, user.getLanguage())+"\" otherpara=\"stop\"  index=\"1\"/>";
	 	       			operateString +="     <operate href=\"javascript:doMonitorRequestSignle();\" text=\""+SystemEnv.getHtmlLabelName(16210, user.getLanguage())+"\" otherpara=\"cancel\" index=\"2\"/>";
		 	        	operateString +="     <operate href=\"javascript:doMonitorRequestSignle();\" text=\""+SystemEnv.getHtmlLabelName(18095, user.getLanguage())+"\" otherpara=\"restart\" index=\"3\"/>";
		 	        	operateString +="     <operate href=\"javascript:doMonitorRequestSignle();\" text=\""+SystemEnv.getHtmlLabelName(18360, user.getLanguage())+"\" otherpara=\"ovm\"  index=\"4\"/>";
		 	       		operateString +="     <operate href=\"javascript:doMonitorRequestSignle();\" text=\""+SystemEnv.getHtmlLabelName(18359, user.getLanguage())+"\" otherpara=\"rbm\"  index=\"5\"/>";
		 	       	    operateString +="     <operate href=\"javascript:showInterventionWindow();\" text=\""+SystemEnv.getHtmlLabelName(18913, user.getLanguage())+"\" otherpara=\""+requestidpara+"\"  index=\"6\"/>";
		 	       		operateString +="</operates>";
		 	       		
		 	       		//System.out.println("================");
		 	       		//System.out.println("select " + backfields + " from " + fromSql + " " + sqlWhere);
		 	       		//System.out.println("================");
						
						tableString =   " <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.getWFPageId(pageIdStr),user.getUID())+"\" >"+
						                " <checkboxpopedom    popedompara=\""+para3+"\" showmethod=\"weaver.workflow.monitor.Monitor.getWFMonitorCheckBox\" />"+
						                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"   sqlprimarykey=\"a.requestid\" sqlsortway=\"Desc\"  />"+
						                operateString+" <head>"+
						                "           <col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"weaver.workflow.monitor.Monitor.getWFSearchResultFlowName\"  otherpara=\""+para1+"\" />"+
						                "           <col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"a.workflowid,a.requestname\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
						                "           <col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
						                "           <col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
						                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" orderkey=\"currentnodeid\"  transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\" />"+
						                "           <col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(18565,user.getLanguage())+"\" column=\"requestid\"  otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getMUnOperators\" />"+
						                "           <col width=\"8%\" display=\"false\" text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" />"+
						               // "           <col width=\"8%\" height='120' text=\""+SystemEnv.getHtmlLabelName(18361,user.getLanguage())+"\" column=\"workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getMonitorLink\" otherpara=\""+para2+"\" />"+
						                "       </head>"+
						                " </table>";
						%>
						
						<TABLE width="100%" cellspacing="0" cellpadding="0">
						    <tr>
						        <td valign="top">  
						            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
						        </td>
						    </tr>
						</TABLE>
	
					    <%
					    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
					    RCMenuHeight += RCMenuHeightStep ;
					    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
					    RCMenuHeight += RCMenuHeightStep ;
					    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
					    RCMenuHeight += RCMenuHeightStep ;
					    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
					    RCMenuHeight += RCMenuHeightStep ;
					    %>

</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<SCRIPT type="text/javascript">

try{
	<%if(!"".equals(workflowid) && !"0".equals(workflowid)){%>
		parent.__tabNamespace__.setTabObjName("<%=WorkflowComInfo.getWorkflowname(workflowid)%>");
	<%}else if(!"".equals(typeid) && !"0".equals(typeid)){%>
		parent.__tabNamespace__.setTabObjName("<%=typename%>");
	<%}%>
}catch(e){}

onCreatertypeChange();
function onCreatertypeChange(){
	var tmpval = $("select[name=creatertype]").val();
	if(tmpval=="0")
		$("input[name=createrid]").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	else
		$("input[name=createrid]").attr("_url","/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
}

/**
*清空搜索条件
*/
function resetCondtion(selector){
	jQuery('#searchInput',parent.document).val('');
	resetCondition(selector);
}

function showInterventionWindow(requestid){
	openFullWindowHaveBar("/workflow/request/ViewRequest.jsp?isintervenor=1&requestid="+requestid);
}

function deleteWorkflowByRequestID(requestid){
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(124824,user.getLanguage())%>", function (){
		requestid = requestid+",";
    	jQuery.ajax({
			url:"/system/systemmonitor/MonitorOperation.jsp",
			type:"post",
			data:{
				operation:"deleteworkflow",
				multiRequestIds:requestid,
			},
			beforeSend:function(xhr){
				try{
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024,user.getLanguage())%>",true);
				}catch(e){}
			},
			complete:function(xhr){
				e8showAjaxTips("",false);
			},
			success:function(data){
				//window.location="WorkflowMonitorList.jsp?"+data;
				_xtable_CleanCheckedCheckbox();
				_table.reLoad();
			}
		});
    }, function () {}, 320, 90,true);
	
	 //requestid = requestid+",";
     //document.weaver.multiRequestIds.value = requestid;
     //document.weaver.operation.value='deleteworkflow';
     //document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
     //document.weaver.submit();
}

function doMonitorRequestSignle(requestid, flag){
	var tips = "";
	if(flag=="stop")
	{
		tips = "<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?";
	}
	else if(flag=="cancel")
	{
		tips = "<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?";
	}
	else if(flag=="restart")
	{
		tips = "<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?";
	}
	if(tips!="")
	{
		if(!confirm(tips))
		{
			return false;
		}
	}
	document.weaver.requestidvalue.value = requestid;
	document.weaver.method = "post";
	document.weaver.flag.value = flag;
	document.weaver.requestfrom.value = "mo";
	document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
	document.weaver.submit();
}
function OnChangePage(start){
        document.weaver.start.value = start;
        document.weaver.method = "post";
        if(check_form(document.weaver,'fromdate'))
		document.weaver.submit();
}
function doOverBackMutil(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	document.weaver.method = "post";
		document.weaver.multiRequestIds.value = requestids;
		document.weaver.flag.value = "ovmwfm";
		document.weaver.requestfrom.value = "mo";
		document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
		obj.disabled = true;
		document.weaver.submit();
	}else{
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}

function doStop(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	//您确定要暂停当前流程吗?
		if(confirm("<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?")){
	    	document.weaver.method = "post";
			document.weaver.multiRequestIds.value = requestids;
			document.weaver.flag.value = "mostop";
			document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
			obj.disabled = true;
			document.weaver.submit();
		}
		else
		{
			return false;
		}
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function doCancel(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	//您确定要撤销当前流程吗?
		if(confirm("<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?"))
		{
	    	document.weaver.method = "post";
			document.weaver.multiRequestIds.value = requestids;
			document.weaver.flag.value = "mocancel";
			document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
			obj.disabled = true;
			document.weaver.submit();
		}
		else
		{
			return false;
		}
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function doRestart(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	//您确定要启用当前流程吗?
		if(confirm("<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?")){
	    	document.weaver.method = "post";
			document.weaver.multiRequestIds.value = requestids;
			document.weaver.flag.value = "morestart";
			document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
			obj.disabled = true;
			document.weaver.submit();
		}
		else
		{
			return false;
		}
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function deleteWorkflow(obj){
    if(_xtable_CheckedCheckboxId()!=""){
        //if(isdel()) {
        //    obj.disabled=true;
        //    document.weaver.multiRequestIds.value = _xtable_CheckedCheckboxId();
        //    document.weaver.operation.value='deleteworkflow';
       //     document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
       //     document.weaver.submit();
       // }
        
        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
        	jQuery.ajax({
				url:"/system/systemmonitor/MonitorOperation.jsp",
				type:"post",
				data:{
					operation:"deleteworkflow",
					multiRequestIds:_xtable_CheckedCheckboxId(),
				},
				beforeSend:function(xhr){
					try{
						e8showAjaxTips("正在删除数据，请稍候...",true);
					}catch(e){}
				},
				complete:function(xhr){
					e8showAjaxTips("",false);
				},
				success:function(data){
					//window.location="WorkflowMonitorList.jsp?"+data;
					_xtable_CleanCheckedCheckbox();
					_table.reLoad();
				}
			});
        }, function () {}, 320, 90,true);
        
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}



var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

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
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

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
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
	
    ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
    //获取执行状态


    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里


        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}
function getDateForDocMonitor(){
	var language=readCookie("languageidweaver");
		if(language==8)
			languageStr ="en";
		else if(language==9)
			languageStr ="zh-tw";
		else
			languageStr ="zh-cn";
	WdatePicker({lang:languageStr,el:$('#fromdatespan')[0],onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$($('input[name=fromdate]')[0]).value = returnvalue;
	},oncleared:function(dp){
		$dp.$($('input[name=fromdate]')[0]).value="";
		$('#fromdatespan').html("<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">");
		
	}});
} 

jQuery(document).ready(function(){
	reSelectTab();
});

function reSelectTab(){
	var createdateselect = jQuery("#createdateselect");
	if(createdateselect.length>0){
		if(createdateselect.val()=="1"){
			jQuery("li.current",parent.document).removeClass("current");
			jQuery("#li_a_2",parent.document).parent().addClass("current");
		}else if(createdateselect.val()=="2"){
			jQuery("li.current",parent.document).removeClass("current");
			jQuery("#li_a_3",parent.document).parent().addClass("current");
		}else if(createdateselect.val()=="3"){
			jQuery("li.current",parent.document).removeClass("current");
			jQuery("#li_a_4",parent.document).parent().addClass("current");
		}else if(createdateselect.val()=="4"){
			jQuery("li.current",parent.document).removeClass("current");
			jQuery("#li_a_5",parent.document).parent().addClass("current");
		}else if(createdateselect.val()=="5"){
			jQuery("li.current",parent.document).removeClass("current");
			jQuery("#li_a_6",parent.document).parent().addClass("current");
		}else{
			jQuery("li.current",parent.document).removeClass("current");
			jQuery("#li_a_1",parent.document).parent().addClass("current");
		}
	}else{
		setTimeout(function(){
			reSelectTab();
		},50);
	}
}
</script>
</body>
</html>
<SCRIPT language="javascript" src="/js/ecology8/request/wFCommonAdvancedSearch_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>
