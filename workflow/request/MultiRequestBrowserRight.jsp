
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<LINK rel="stylesheet" type="text/css" href="/css/ereportstyle_wev8.css">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript
			src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type='text/javascript'
			src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
		<script type="text/javascript"
			src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>

<%
String requestname = Util.null2String(request.getParameter("requestname"));
String creater = Util.null2String(request.getParameter("creater"));
String createdatestart = Util.null2String(request.getParameter("createdatestart"));
String createdateend = Util.null2String(request.getParameter("createdateend"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
String userRights=(String)session.getAttribute("flowReport_userRights");
String flowId=Util.null2String(request.getParameter("flowReport_flowId"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String remarks = Util.null2String(request.getParameter("remarks"));
String requestmark = Util.null2String(request.getParameter("requestmark"));   
String prjids=Util.null2String(request.getParameter("prjids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String department =Util.null2String(request.getParameter("department"));
String status = Util.null2String(request.getParameter("status"));
String isfrom = Util.null2String(request.getParameter("isfrom"));
String sqlwhere = "";
if (isrequest.equals("")) isrequest = "1";

String userid = ""+user.getUID() ;
String usertype="0";

if(user.getLogintype().equals("2")) usertype="1";
String check_perss=Util.null2String(request.getParameter("resourceids"));

ArrayList  check_pers=Util.TokenizerString(check_perss,"~");

String check_per ="";
if (check_pers.size()>0&&flowId.equals(""))
flowId=""+check_pers.get(0);

//if (check_pers.size()>=2)
//{
//check_per=Util.null2String(""+check_pers.get(1));
//}

String resourceids = "";
String resourcenames = "";
int index = check_perss.indexOf("-");
if(index >= 0){
	check_perss = check_perss.substring(index+1);
}
//System.out.println("check_perss"+check_perss);
if (!check_perss.equals("")) {
	String strtmp = "select requestid,requestname from workflow_requestbase  where requestid in ("+check_perss+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while (RecordSet.next()) {
		ht.put( Util.null2String(RecordSet.getString("requestid")), Util.null2String(RecordSet.getString("requestname")));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}
	try{
		StringTokenizer st = new StringTokenizer(check_perss,",");

		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的流程此时不存在会出错
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}
	}catch(Exception e){
		resourceids ="";
		resourcenames ="";
	}
}
sqlwhere=" where 1=1 ";
if(!"".equals(flowId) && !"-999".equals(flowId)){
	sqlwhere+=" and workflow_currentoperator.workflowid in ("+ WorkflowVersion.getAllVersionStringByWFIDs(flowId) + ")";
}
if(!userRights.equals("")){
    sqlwhere+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+")) ";
}else{
    sqlwhere+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid) ";
}
if(!nodeid.equals(""))  sqlwhere+=" and workflow_currentoperator.nodeid in ("+nodeid+")  " ;
if(!remarks.equals("")) sqlwhere+=" and workflow_currentoperator.isremark in("+remarks+") ";
if(!requestname.equals("")){

		sqlwhere += " and requestname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
}

if(!creater.equals("")){

		sqlwhere += " and creater =" + creater +" and creatertype=0 " ;
}

if(!createdatestart.equals("")){

		sqlwhere += " and createdate >='" + createdatestart +"' " ;
}

if(!createdateend.equals("")){

		sqlwhere += " and createdate <='" + createdateend +"' " ;
}

if(status.equals("1")){

		sqlwhere += " and currentnodetype < 3 " ;	
}

if(status.equals("2")){

		sqlwhere += " and currentnodetype = 3 " ;	
}

if(!workflowid.equals("")&&!workflowid.equals("0")){

		sqlwhere += " and workflow_requestbase.workflowid in ( " + WorkflowVersion.getAllVersionStringByWFIDs(workflowid)  + ")";	
}

if(!department.equals("")&&!department.equals("0")){

		sqlwhere += " and workflow_requestbase.creater in (select id from hrmresource where departmentid in ("+department+"))";
}

if(!prjids.equals("")&&!prjids.equals("0")){

	if(RecordSet.getDBType().equals("oracle")){
		sqlwhere += " and (concat(concat(',' , To_char(workflow_requestbase.prjids)) , ',') LIKE '%,"+prjids+",%') ";
	}else{
		sqlwhere += " and (',' + CONVERT(varchar,workflow_requestbase.prjids) + ',' LIKE '%,"+prjids+",%') ";
	}
	
}

if(!crmids.equals("")&&!crmids.equals("0")){

	if(RecordSet.getDBType().equals("oracle")){
		sqlwhere += " and (concat(concat(',' , To_char(workflow_requestbase.crmids)) , ',') LIKE '%,"+crmids+",%') ";
	}else{
		sqlwhere += " and (',' + CONVERT(varchar,workflow_requestbase.crmids) + ',' LIKE '%,"+crmids+",%') ";
	}

}

if(!requestmark.equals("")){
		sqlwhere += " and requestmark like '%" + requestmark +"%' " ;
}
if(RecordSet.getDBType().equals("oracle"))
{
	sqlwhere += " and (nvl(workflow_requestbase.currentstatus,-1) = -1 or (nvl(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+")) ";
}
else
{
	sqlwhere += " and (isnull(workflow_requestbase.currentstatus,-1) = -1 or (isnull(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+")) ";
}
String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=50;

if(RecordSet.getDBType().equals("oracle")){
		//sqlstr = "create table "+temptable+"  as select * from (select distinct workflow_requestbase.requestid ,requestname,creater,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc, createtime desc) where rownum<"+ (pagenum*perpage+2);
		sqlstr = "(select * from (select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') order by createdate desc, createtime desc) where rownum<"+ (pagenum*perpage+2) + ") s ";
}else if(RecordSet.getDBType().equals("db2")){
		//sqlstr = "create table "+temptable+"  as (select distinct workflow_requestbase.requestid ,requestname,creater,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base) definition only ";

        //RecordSet.executeSql(sqlstr);

       //sqlstr = "insert  into "+temptable+" (select distinct  workflow_requestbase.requestid ,requestname,creater,createdate,createtime  from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid  and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc fetch  first "+(pagenum*perpage+1)+" rows only )" ;
}else{
		//sqlstr = "select distinct top "+(pagenum*perpage+1)+" workflow_requestbase.requestid ,requestname,creater,createdate,createtime into "+temptable+" from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid  and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc" ;
		sqlstr = "(select distinct top "+(pagenum*perpage+1)+" workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid  and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') order by createdate desc , createtime desc) as s" ;
}


//RecordSet.executeSql(sqlstr);


RecordSet.executeSql("Select count(requestid) RecordSetCounts from "+sqlstr);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+sqlstr+" order by createdate , createtime ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select  * from "+temptable+"  order by createdate , createtime fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+sqlstr+"  order by createdate , createtime ";
}
RecordSet.executeSql(sqltemp);
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   		<jsp:param name="mouldID" value="workflow"/>
  	 	<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%>"/>
	</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:doSearch(),_self"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
	<FORM id=weaver name=SearchForm style="margin-bottom:0" action="MultiRequestBrowserRight.jsp" method=post>
		<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere)%>">
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<input type="hidden" name="flowReport_flowId" value="<%=flowId%>">
		<input type="hidden" name="isrequest" value='<%=isrequest%>'>
        <input type="hidden" name="nodeid" value="<%=nodeid%>">
		<input type="hidden" name="remarks" value="<%=remarks%>">
		<input type="hidden" name="isfrom" value="<%=isfrom%>">
        <!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
			<wea:layout type="4col">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(20331, user
									.getLanguage())%>">
			    <wea:item><%=SystemEnv.getHtmlLabelName(1334, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<input name=requestname class=Inputstyle value="<%=requestname%>">
					</wea:item>
					<wea:item>
						<%
							if (!user.getLogintype().equals("2")) {
						%><%=SystemEnv.getHtmlLabelName(882, user
												.getLanguage())%>
						<%
							}
						%>
					</wea:item>
					<wea:item>
						<%
							if (!user.getLogintype().equals("2")) {
						%>
						<span> <brow:browser viewType="0" name="creater"
								browserValue='<%=creater%>'
								completeUrl="/data.jsp?type=1"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=Util.toScreen(ResourceComInfo
													.getResourcename(creater),
													user.getLanguage())%>'></brow:browser>
						</span>
						<%
							}
						%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(722, user
											.getLanguage())%></wea:item>
					<wea:item>
						<button type="button" class=Calendar id=selectbirthday
							onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
						<SPAN id=createdatestartspan><%=createdatestart%></SPAN>
			  - &nbsp;<button type="button" class=Calendar id=selectbirthday1
							onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
						<SPAN id=createdateendspan><%=createdateend%></SPAN>
						<input type="hidden" id=createdatestart name="createdatestart"
							value="<%=createdatestart%>">
						<input type="hidden" id=createdateend name="createdateend"
							value="<%=createdateend%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19502, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<input name=requestmark class=Inputstyle value="<%=requestmark%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19225, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <%
 	String departments[] = Util.TokenizerString2(
 							department, ",");
 					String departmentnames = "";
 					for (int i = 0; i < departments.length; i++) {
 						if (!departments[i].equals("")
 								&& !departments[i].equals("0")) {
 							departmentnames += (!departmentnames
 									.equals("") ? "," : "")
 									+ DepartmentComInfo
 											.getDepartmentname(departments[i]);
 						}
 					}
 %> <brow:browser viewType="0" name="department"
								browserValue='<%=department%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=4"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=departmentnames%>'>
							</brow:browser> </span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(101, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="prjids"
								browserValue='<%=prjids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								completeUrl="/data.jsp?type=8"
								browserSpanValue='<%=ProjectInfoComInfo
												.getProjectInfoname(prjids)%>'></brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15433, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="workflowid"
								browserValue='<%=workflowid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=WorkflowComInfo
												.getWorkflowname(workflowid)%>'></brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(136, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="crmids"
								browserValue='<%=crmids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=7"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=crmComInfo
												.getCustomerInfoname(crmids)%>'>
							</brow:browser> </span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19061, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<select id=status name=status>
							<OPTION value=""></OPTION>
							<OPTION value="1"
								<%if (status.equals("1"))
							out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23773, user
											.getLanguage())%></OPTION>
							<OPTION value="2"
								<%if (status.equals("2"))
							out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23774, user
											.getLanguage())%></OPTION>
						</select>
					</wea:item>
                </wea:group>
                <wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
				</wea:group>
			</wea:layout>
			<div id="dialog">
				<div id='colShow'></div>
			</div>
			<div style="display: none;">
				<button accessKey=T id=myfun1 type=button onclick="resetCondtion();">
					<U>T</U>-<%=SystemEnv.getHtmlLabelName(199, user.getLanguage())%></BUTTON>
			</div>
	</FORM>
<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		var config = null;
		try {
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		} catch (e) {
		}
		function showMultiRequestDialog(selectids) {
			config = rightsplugingForBrowser.createConfig();
			config.srchead = [ "<%=SystemEnv.getHtmlLabelName(33569, user.getLanguage())%>", "<%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%>", "<%=SystemEnv.getHtmlLabelName(1339, user.getLanguage())%>" ];
			config.container = jQuery("#colShow");
		    config.searchLabel="";
		    config.hiddenfield="requestid";
		    config.saveLazy = true;//取消实时保存
		    config.saveurl= "/workflow/request/MultiRequestBrowserAjax.jsp?src=save";
		    config.srcurl = "/workflow/request/MultiRequestBrowserAjax.jsp?src=src";
		    config.desturl = "/workflow/request/MultiRequestBrowserAjax.jsp?src=dest";
		    config.delteurl= "/workflow/request/MultiRequestBrowserAjax.jsp?src=save";
		    config.pagesize = 10;
		    config.formId = "weaver";
		    config.selectids = selectids;
		    config.searchAreaId = "e8QuerySearchArea";
			try{
				config.dialog = dialog;
			}catch(e){
			   console.log(e);
			}
		   	jQuery("#colShow").html("");
		    rightsplugingForBrowser.createRightsPluing(config);
		
		    jQuery("#btn_Ok").bind("click",function(){
		    	rightsplugingForBrowser.system_btnok_onclick(config);
		    });
		    jQuery("#btn_Clear").bind("click",function(){
				rightsplugingForBrowser.system_btnclear_onclick(config);
		    });
		    jQuery("#btn_Cancel").bind("click",function(){	    	
				rightsplugingForBrowser.system_btncancel_onclick(config);
		    });
		    jQuery("#btn_Search").bind("click",function(){
		    	rightsplugingForBrowser.system_btnsearch_onclick(config);
		    });
		 
		}
		function onClose(){
			try{
				if(dialog){
					jQuery("#btn_Cancel").trigger("click");
				}else{
					window.parent.close();
				}
			}catch(e){
				window.parent.close();
			}
		}
		function onReset(){
			SearchForm.reset();
		}
		function doSearch()
		{
		    document.getElementById("issearch").value="issearch";
			setResourceStr();
		    document.all("resourceids").value = resourceids.substring(1) ;
		    document.SearchForm.submit();
		}
		jQuery(document).ready(function(){
			showMultiRequestDialog("<%=resourceids%>");
		});
		
		function btn_ok(){
	        jQuery("#btn_Ok").trigger("click");
	    }
		function btn_search(){
        	jQuery("#btn_Search").trigger("click");
    	}
		function btn_cancel(){
        	jQuery("#btn_Cancel").trigger("click");
   		}
		function btn_clear(){
        	jQuery("#btn_Clear").trigger("click");
        }
	</script>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom"  style="padding:0px!important;">
		<div style="padding:5px 0px;">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes='{\"groupDisplay\":\"none\"}'>
					<wea:item type="toolbar">
						<%--<input type="button" style="display: none;" class=zd_btn_submit
							accessKey=S id=btn_Search
							value="S-<%=SystemEnv.getHtmlLabelName(197, user
										.getLanguage())%>"></input> --%>
						<input type="button" class=zd_btn_submit accessKey=O id=btn_Ok
							value="O-<%=SystemEnv.getHtmlLabelName(826, user
										.getLanguage())%>"></input>
						<input type="button" class=zd_btn_submit accessKey=2 id=btn_Clear
							value="2-<%=SystemEnv.getHtmlLabelName(311, user
										.getLanguage())%>"></input>
						<input type="button" class=zd_btn_cancle accessKey=T id=btn_Cancel
							value="T-<%=SystemEnv.getHtmlLabelName(201, user
										.getLanguage())%>"></input>
					</wea:item>
				</wea:group>
			</wea:layout>
			</div>
			</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
<script type="text/javascript">
	function selectData(id, name) {
		var returnjson = {id: id,name: name};
		if(dialog){
			try {
				dialog.callback(returnjson);
			}catch(e){}
			try {
				dialog.close(returnjson);
			}catch(e){}
		}else{
			window.parent.parent.returnValue = returnjson;
			window.parent.parent.close();
		}
	}
  var resourceids = "<%=resourceids%>";
  var resourcenames = "<%=resourcenames%>";
  
  function btnclear_onclick(){
     selectData('', '');
  }
  
  function btnok_onclick(){
	 setResourceStr();
	 selectData(resourceids, resourcenames);
  }

  function btncancel_onclick() {
  		if(dialog){
			try {
				dialog.close();
			}catch(e){}
		}else{
			window.parent.parent.close();
		}
  }
  
jQuery(function(){
	jQuery("#btnclear").click(btnclear_onclick);
	jQuery("#btnok").click(btnok_onclick);
});
  
  
  function onShowDepartment(){
		var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#department").val());
		if(results){
		   if(results.id!=""){
		      var department=results.id;
		      var departmentname=results.name;
		      jQuery("#departmentspan").html(departmentname);
		      jQuery("#department").val(department);
		   }else{
		      jQuery("#departmentspan").html("");
		      jQuery("#department").val("");
		   }
		}    
    }
    
    function onShowPrjids(){
		var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
		if(results){
		   if(results.id!=""){
			      jQuery("#prjidsspan").html(results.name);
			      jQuery("#prjids").val(results.id);
			}else{
			      jQuery("#prjidsspan").html("");
			      jQuery("#prjids").val("");
			}
		}
   }
   
   function onShowWorkFlow(inputname, spanname){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	if(results){
	   if(results.id!=""){
		     jQuery("#"+spanname).html(results.name);
		     jQuery("#"+inputname).val(results.id);
		     
		}else{
		     jQuery("#"+spanname).html("");
		     jQuery("#"+inputname).val("");
		}
	}
   }
   
   function onShowCrmids(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if(results){
	   if(results.id!=""){
		     jQuery("#crmidsspan").html(results.name);
		     jQuery("#crmids").val(results.id);
		     
		}else{
		     jQuery("#crmidsspan").html("");
		     jQuery("#crmids").val("");
		}
	}
   } 
</script>
<script language="javascript" >
function overItem(e){
	var eventObj = e.target||e.srcElement;
	if(eventObj.tagName =='TD'){
		var trObj = jQuery(eventObj).parent()[0];
		trObj.className ="Selected";
	}else if (eventObj.tagName == 'A'){
		var trObj = jQuery(eventObj).parent().parent()[0];
		trObj.className = "Selected";
	}
}
function leaveItem(e){
	var eventObj = e.target||e.srcElement ;
	if(eventObj.tagName =='TD'){
		var trObj = jQuery(eventObj).parent()[0];
		if(trObj.rowIndex%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}else if (eventObj.tagName == 'A'){
		var trObj = jQuery(eventObj).parent().parent()[0];
		if(trObj%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}
}
function selectItem(e1){
	var e =  e1.target||e1.srcElement;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = jQuery(jQuery(e).parent()[0].cells[0]).text()+"~"+jQuery(jQuery(e).parent()[0].cells[1]).text();
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect(document.getElementsByName("srcList")[0],newEntry);
			reloadResourceArray();
		}
	}
}

</script>

<script language="javascript">
//var resourceids = "<%=resourceids%>"
//var resourcenames = "<%=resourcenames%>"

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.getElementsByName("srcList")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	jQuery(oOption).text(str.split("~")[1]);
	
}

function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = document.getElementsByName("srcList")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addToList(){
	var str = document.getElementById("forAddSingleClick").value;
	if(!isExistEntry(str,resourceArray)&&str!=""){
		addObjectToSelect(document.getElementsByName("srcList")[0],str);
		document.getElementById("forAddSingleClick").value="";
	}		
	reloadResourceArray();
}
function addAllToList(){
	var table =document.getElementById("BrowseTable");
	//alert(table.rows.length);
	for(var i=0;i<table.rows.length;i++){
		var str = jQuery(table.rows[i].cells[0]).text()+"~"+jQuery(table.rows[i].cells[1]).text();
		//alert(str);
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect(document.getElementsByName("srcList")[0],str);
	}
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = document.getElementsByName("srcList")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = document.getElementsByName("srcList")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = document.getElementsByName("srcList")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.getElementsByName("srcList")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	document.getElementsByName("resourceids")[0].value = resourceids;
}

function doSearch()
{
	setResourceStr();
	flowre="<%=flowId%>";
	flowre=flowre+"-"+ resourceids;
    document.getElementsByName("resourceids")[0].value =flowre;
    document.SearchForm.submit();
}
</SCRIPT>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
