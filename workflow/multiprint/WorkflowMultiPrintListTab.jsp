<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <!--added by xwj  for td2903  20051019-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="wfMultiPrintManager" class="weaver.workflow.search.WfMultiPrintManager" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();	
});

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='requestname']").val(typename);
	window.location="/workflow/multiprint/WorkflowMultiPrintListTab.jsp?requestname="+typename;
}
</script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(26382,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(26382,user.getLanguage())+",javascript:onMultiPrint(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<FORM id="weaver" name="weaver" method="post" action="WorkflowMultiPrintListTab.jsp">
<input type="hidden" id="fromself" name="fromself" value="1">
<input type="hidden" id="operation" name="operation" value="">
<input type="hidden" id="ismultiprintinput" name="ismultiprintinput" value="">
<input type="hidden" id="multirequestid" name="multirequestid" value="">
<%
ArrayList canoperaternode = new ArrayList(); //added by xwj  for td2903  20051019

ArrayList monitorWfList = new ArrayList();
String monitorWfStrs = "";


String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;
String requestname ="" ;//added xwj for for td2903  20051019
String requestmark = "";
int ismultiprint = -1;
int nodeid = 0;
int operater = 0;


int fromself = Util.getIntValue(request.getParameter("fromself"), 0);
String operation = Util.null2String(request.getParameter("operation"));

if(fromself==1 && "setprint".equals(operation)){
	int ismultiprintinput = Util.getIntValue(request.getParameter("ismultiprintinput"), -1);
	if(ismultiprintinput==0 || ismultiprintinput==1){
		String multirequestid = Util.null2String(request.getParameter("multirequestid"));
		String sql_tmp = "update workflow_requestbase set ismultiprint="+ismultiprintinput+" where requestid in ("+multirequestid+"0)";
		RecordSet.executeSql(sql_tmp);
	}
}



String formid = "";
String isbill = "";
String fieldsql = "";
boolean hasFieldClause = false;
if(fromself == 1) {
	workflowid = Util.null2String(request.getParameter("workflowid"));
	nodetype = Util.null2String(request.getParameter("nodetype"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
	requestlevel = Util.null2String(request.getParameter("requestlevel"));
	requestname = Util.null2String(request.getParameter("requestname"));//added xwj for for td2903  20051019
	requestmark = Util.null2String(request.getParameter("requestmark"));

	SearchClause.setWorkflowId(workflowid);
	SearchClause.setNodeType(nodetype);
	SearchClause.setFromDate(fromdate);
	SearchClause.setToDate(todate);
	SearchClause.setCreaterType(creatertype);
	SearchClause.setCreaterId(createrid);
	SearchClause.setRequestLevel(requestlevel);
	SearchClause.setRequestName(requestname);//added xwj for for td2903  20051019

	ismultiprint = Util.getIntValue(request.getParameter("ismultiprint"));
	nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	operater = Util.getIntValue(request.getParameter("operater"));

	String[] checkcons = request.getParameterValues("check_con");

	if(!workflowid.equals("")){
		RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowid);
		if(RecordSet.next()){
			formid = RecordSet.getString("formid");
			isbill = RecordSet.getString("isbill");
		}
	}
	String billtable = "workflow_form";
	if(isbill.equals("1")){
		RecordSet.executeSql("select tablename from workflow_bill where id="+formid);
		if(RecordSet.next()) billtable = RecordSet.getString("tablename");
	}
	fieldsql = " and exists(select 1 from "+billtable+" where a.requestid=requestid ";
	if(!workflowid.equals("") && checkcons!=null){
		String fieldsql_tmp = wfMultiPrintManager.getSqlStr(request);
		if(!"".equals(fieldsql_tmp)){
			fieldsql += fieldsql_tmp;
			hasFieldClause = true;
		}
	}//end if(!workflowid.equals("")&&checkcons!=null)
	fieldsql += ")";
}else{
	workflowid = SearchClause.getWorkflowId();
	nodetype = SearchClause.getNodeType();
	fromdate = SearchClause.getFromDate();
	todate = SearchClause.getToDate();
	creatertype = SearchClause.getCreaterType();
	createrid = SearchClause.getCreaterId();
	requestlevel = SearchClause.getRequestLevel();
	requestname = SearchClause.getRequestName();//added xwj for for td2903  20051019
}
//out.print("fieldsql=="+fieldsql+"<br>");

String newsql=" ";

if(fromself != 1){
	newsql += " and 1=2 ";
}else{
	if(!workflowid.equals("")&&!workflowid.equals("0")){
		newsql+=" and a.workflowid in("+workflowid+")" ;
	}

	if(!nodetype.equals("")){
		newsql += " and currentnodetype='"+nodetype+"'";
	}

	if(!fromdate.equals("")){
		newsql += " and createdate>='"+fromdate+"'";
	}

	if(!todate.equals("")){
		newsql += " and createdate<='"+todate+"'";
	}

	if(!createrid.equals("")){
		newsql += " and creater='"+createrid+"'";
		newsql += " and creatertype= '"+creatertype+"' ";
	}

	if(!requestlevel.equals("")){
		newsql += " and requestlevel="+requestlevel;
	}

	if(!requestname.equals("")){
		newsql += " and requestname like '%"+requestname+"%' ";
	}

	if(!requestmark.equals("")){
		newsql += " and requestmark like '%"+requestmark+"%' ";
	}

	if(ismultiprint > -1){
		newsql += " and a.ismultiprint="+ismultiprint;
	}

	if(nodeid > 0){
		newsql += " and exists (select c.id from workflow_currentoperator c where c.requestid=a.requestid and c.nodeid="+nodeid+" and c.userid="+user.getUID()+") ";
	}

	if(operater > 0){
		newsql += " and exists (select c.id from workflow_currentoperator c where c.requestid=a.requestid and c.userid="+operater+") ";
	}

}


String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();
String userlang = ""+user.getLanguage();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")){
		usertype = 1;
	}
}

newsql+=" and a.requestid=b.requestid and b.islasttimes = 1 and userid="+user.getUID()+" and usertype="+usertype+"  ";

if(!"".equals(newsql)){
	newsql = newsql.replaceFirst("and", "");
}
String sqlwhere = "where  " +newsql + "  ";
String orderby =" createdate ,createtime ";

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

%>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(26382 ,user.getLanguage())%>" class="e8_btn_top" onclick="onMultiPrint()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=requestname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347 ,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721 ,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			
		<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span><%=SystemEnv.getHtmlLabelName(26382,user.getLanguage())%></span>
			</span>
		</div>
		
		<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
<wea:layout type="fourCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905 ,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
	    <wea:item>
			<brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false" 
	              		browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
	               		completeUrl="/data.jsp?type=workflowBrowser"  width="150px" browserValue='<%=workflowid%>' browserSpanValue='<%=WorkflowComInfo.getWorkflowname(workflowid)%>'/>	    
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></wea:item>
    	<wea:item>
			<select size=1  class=InputStyle name=nodetype style="width:150px;">
				<option value="">&nbsp;</option>
				<option value="0" <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
				<option value="1" <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
				<option value="2" <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
				<option value="3" <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></wea:item>
    	<wea:item>
			<select name=requestlevel  class=InputStyle style="width:150px;" size=1>
				<option value=""></option>
				<option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
				<option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
				<option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></wea:item>
    	<wea:item><input type="text" name="requestname" value='<%=requestname%>'></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
    	<wea:item>
			<button type=button  class=calendar id=SelectDate  onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
			<SPAN id=fromdatespan ><%=fromdate%></SPAN>
			<span id="fromdatespanimg">
			</span>
			-&nbsp;&nbsp;
			<button type=button  class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
			<SPAN id=todatespan ><%=todate%></SPAN>
			<input type="hidden" name="fromdate" value="<%=fromdate%>" >
			<input type="hidden" name="todate" value="<%=todate%>">    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
    	<wea:item>
			<select name=creatertype  class=InputStyle style="float: left;width: 150px;">
				<%if(!user.getLogintype().equals("2")){%>
					<%if(isgoveproj==0){%>
					<option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
					<%}else{%>
					<option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
					<%}%>
				<%}%>
				<%if(isgoveproj==0){%>
				<option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
				<%}%>
			</select>
			&nbsp;
			<% 
			String tempresource = "";
			if(creatertype.equals("0")){
				tempresource = ResourceComInfo.getResourcename(createrid);
			}else if(creatertype.equals("1")){
		 		tempresource = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage());
			}
			%>
		    <brow:browser name="createrid" viewType="0" hasBrowser="true" hasAdd="false" 
		   				 getBrowserUrlFn="onChangeResource"
	          			 isMustInput="1" isSingle="true" hasInput="true"
	           			 completeUrl="javascript:getajaxurl()"  width="150px" browserValue='<%=createrid%>' browserSpanValue='<%=tempresource %>'/>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(27044,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id="ismultiprint" name="ismultiprint" style="width:150px;">
				<option value="-1"></option>
				<option value="0" <%if(ismultiprint==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(27045,user.getLanguage())%></option>
				<option value="1" <%if(ismultiprint==1){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(27046,user.getLanguage())%></option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id="nodeid" name="nodeid" style="width:150px;">
				<option value="0"></option>
				<%
					if(fromself==1 && !"".equals(workflowid)){
						rs.execute("select f.nodeid, n.nodename from workflow_flownode f left join workflow_nodebase n on f.nodeid=n.id where f.workflowid="+workflowid+" order by f.nodetype, f.nodeid");
						while(rs.next()){
							int nodeid_tmp = Util.getIntValue(rs.getString(1), 0);
							String nodename_tmp = Util.null2String(rs.getString(2));
							String selectStr_tmp = "";
							if(nodeid == nodeid_tmp){
								selectStr_tmp = " selected ";
							}
							out.println("<option value=\""+nodeid_tmp+"\""+selectStr_tmp+">"+nodename_tmp+"</option>");
						}
					}
				%>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(26033,user.getLanguage())%></wea:item>
    	<wea:item>
			<brow:browser name="operater" viewType="0" hasBrowser="true" hasAdd="false" 
	              		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
	               		completeUrl="/data.jsp"  width="150px" browserValue='<%=operater+""%>' browserSpanValue='<%=ResourceComInfo.getResourcename(""+operater)%>'/>    	
    	</wea:item>
<%
if(!workflowid.equals("")){
	if(!formid.equals("")){
		String tempsql="";
		if(isbill.equals("0")){
			tempsql = "select a.id,a.fieldname as name,a.fieldhtmltype as httype,a.fielddbtype as dbtype,a.type as type,b.fieldlable as label from workflow_formdict a, workflow_fieldlable b, workflow_formfield c where a.id=b.fieldid and a.id=c.fieldid and c.formid=b.formid and b.formid="+formid+" order by c.fieldorder";
		}else if(isbill.equals("1")){
			tempsql = "select id,fieldname as name,fieldlabel as label,fielddbtype as dbtype,fieldhtmltype as httype,type as type from workflow_billfield where viewtype=0 and billid="+formid;
		}

		int i=0;
		int tmpcount = 0;
		RecordSet.execute(tempsql);
		int totalfileds = RecordSet.getCounts();
		while (RecordSet.next()){
			tmpcount++;
			i++;
			String name = RecordSet.getString("name");
			String label = RecordSet.getString("label");
			String htmltype = RecordSet.getString("httype");
			String type = RecordSet.getString("type");
			String id = RecordSet.getString("id");
			if(isbill.equals("1"))
				label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
%>
			<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
			<input type=hidden name="con<%=id%>_type" value="<%=type%>">
			<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
			<%if(i==1){%>
			<wea:item><input type='hidden' name='check_con' title='<%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%>' value=""><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item>
			<wea:item><input type="text" name="requestmark" value='<%=requestmark%>'></wea:item>
			<%
				i++;
			}%>
			<wea:item><input type='hidden' name='check_con' title='<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>' value='<%=id%>'> <%=label%></wea:item>
			<%
			if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框

				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>	 <!--等于-->
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
				<%}%>
				<option value="3" <%if(tmpopt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
				<option value="4" <%if(tmpopt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->				
				</select>
				<input type=text class=InputStyle size=12 name="con<%=id%>_value" value="<%=tmpvalue%>"  onfocus="changelevel('<%=tmpcount%>')" >			
			</wea:item>
			<%}else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt1 = ""+Util.null2String(request.getParameter("con"+id+"_opt1"));
				String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+id+"_value1"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:20%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(tmpopt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(tmpopt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(tmpopt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(tmpopt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select><input type=text class=InputStyle size=10 name="con<%=id%>_value" value="<%=tmpvalue%>" onblur="checknumber('con<%=id%>_value1')" onfocus="changelevel('<%=tmpcount%>')" >
				<select class=inputstyle  name="con<%=id%>_opt1" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt1.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt1.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(tmpopt1.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(tmpopt1.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(tmpopt1.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(tmpopt1.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select>
				<input type=text class=InputStyle size=10 name="con<%=id%>_value1" value="<%=tmpvalue1%>" onblur="checknumber('con<%=id%>_value1')" onfocus="changelevel('<%=tmpcount%>')" >			
			</wea:item>
			<%}else if(htmltype.equals("4")){   //check类型
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
			%>
			<wea:item><input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(tmpvalue.equals("1")){%>checked<%}%>></wea:item>
			<%}else if(htmltype.equals("5")){  //选择框

				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select>
				<select class=inputstyle  name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="" ></option>
				<%
				char flag=2;
				rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
				while(rs.next()){
					int tmpselectvalue = rs.getInt("selectvalue");
					String tmpselectname = rs.getString("selectname");
				%>
				<option value="<%=tmpselectvalue%>" <%if(tmpvalue.equals(""+tmpselectvalue)){%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
				<%}%>
				</select>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  条件为多人力 (like not lik)
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
					<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
					<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
				</select>
				<button type=button  class=Browser   onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','<%=type%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  条件为多文挡 (like not lik)
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
				</select>
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','<%=type%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门  条件为多部门 (like not lik)
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
				</select>
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','<%=type%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户  条件为多客户 (like not lik)
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp','<%=type%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目  条件为多项目 (like not lik)
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp','<%=type%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  条件为多请求 (like not lik)
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser onfocus="changelevel('<%=tmpcount%>')"	onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp','<%=type%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别

				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+id+"_value1"));
				String tmpopt1 = ""+Util.null2String(request.getParameter("con"+id+"_opt1"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
					<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
					<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
					<option value="3" <%if(tmpopt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
					<option value="4" <%if(tmpopt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
					<option value="5" <%if(tmpopt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
					<option value="6" <%if(tmpopt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select>
				<input type=text class=InputStyle size=10 name="con<%=id%>_value" value="<%=tmpvalue%>" onfocus="changelevel('<%=tmpcount%>')"  >
				<select class=inputstyle  name="con<%=id%>_opt1" style="width:20%" onfocus="changelevel('<%=tmpcount%>')"  >
					<option value="1" <%if(tmpopt1.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
					<option value="2" <%if(tmpopt1.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
					<option value="3" <%if(tmpopt1.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
					<option value="4" <%if(tmpopt1.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
					<option value="5" <%if(tmpopt1.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
					<option value="6" <%if(tmpopt1.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select>			
				<input type=text class=InputStyle size=10 name="con<%=id%>_value1" value="<%=tmpvalue1%>"  onfocus="changelevel('<%=tmpcount%>')"   >			
			</wea:item>
			<%}else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){	//日期
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+id+"_value1"));
				String tmpopt1 = ""+Util.null2String(request.getParameter("con"+id+"_opt1"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(tmpopt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(tmpopt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(tmpopt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(tmpopt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select>
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
				<%if(type.equals("2")){%>
				 onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
				<%}else{%>
				 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
				<%}%>
				 ></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpvalue%></span>
				<select class=inputstyle  name="con<%=id%>_opt1" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt1.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt1.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(tmpopt1.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(tmpopt1.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(tmpopt1.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(tmpopt1.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
				<%if(type.equals("2")){%>
				 onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
				<%}else{%>
				 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
				<%}%>
				 ></button>
				<input type=hidden name="con<%=id%>_value1" value="<%=tmpvalue1%>">
				<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"> <%=tmpvalue1%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("17")){
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("37")){//浏览框  多选筐条件为单选筐(多文挡)
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("57")){//浏览框  多选筐条件为单选筐（多部门）

				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("135")){//浏览框  多选筐条件为单选筐（多项目 ）

				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）

				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser onfocus="changelevel('<%=tmpcount%>')"   onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%}else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>			
			</wea:item>
			<%}else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")||type.equals("142"))){//浏览框  
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
				
			String urls=BrowserComInfo.getBrowserurl(type);	 // 浏览按钮弹出页面的url
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser onfocus="changelevel('<%=tmpcount%>')"   onclick="onShowBrowser('<%=id%>','<%=urls%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if (htmltype.equals("3")){
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));	
				String urls=BrowserComInfo.getBrowserurl(type);	 // 浏览按钮弹出页面的url
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser onfocus="changelevel('<%=tmpcount%>')"   onclick="onShowBrowser('<%=id%>','<%=urls%>')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%} else if (htmltype.equals("6")){   //附件上传同多文挡
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+id+"_value"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+id+"_opt"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+id+"_name"));
				
				String urls=BrowserComInfo.getBrowserurl(type);	 // 浏览按钮弹出页面的url
			%>
			<wea:item>
				<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')"  >
				<option value="1" <%if(tmpopt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(tmpopt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
				
				<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')"></button>
				<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
				<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
				<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%=tmpname%></span>			
			</wea:item>
			<%}	
}
	}
}
%>
    </wea:group>
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="e8_btn_submit" type="submit" name="submit" value="<%=SystemEnv.getHtmlLabelName(527 ,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(27088 ,user.getLanguage())%>"/>
    	</wea:item>																			
    </wea:group>
</wea:layout>	
</div>	
<input name="start" type="hidden" value="<%=start%>">
<input type="hidden" name="multiRequestIds" value="">
<input type="hidden" name="multiSubIds" id="multiSubIds" value="">
<input type="hidden" name="flag" id="flag" value="">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_MULTIPRINT_WORKFLOWMULTIPRINTLISTTAB %>"/>
<input type="hidden" name="requestidvalue" id="requestidvalue" value="">

<%
String tableString = "";
if(perpage <2) perpage=10;								 
String backfields = " a.requestid, a.currentnodeid, a.createdate, a.createtime,a.lastoperatedate, a.lastoperatetime,a.creater, a.creatertype, a.workflowid, a.requestname, a.status, a.requestlevel, a.ismultiprint,b.receivedate,b.receivetime ";
String fromSql  = " workflow_requestbase a,workflow_currentoperator b";
String sqlWhere = sqlwhere;

if(hasFieldClause == true) sqlWhere += fieldsql;
//out.print("select "+backfields + "from "+fromSql+" "+sqlWhere);
String para2="column:requestid+"+CurrentUser+"+"+logintype+"+"+userlang;
String para11="column:requestname+"+"("+"column:requestid+"+")";
String para1="column:requestid+column:workflowid+column:viewtype+0+"+user.getLanguage();
String para4=userlang+"+"+user.getUID();
String para3="column:workflowid+"+CurrentUser+"+"+logintype;
tableString = "<table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_MULTIPRINT_WORKFLOWMULTIPRINTLISTTAB,user.getUID())+"\" >"+
				"	<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
				"		<head>"+
				"			<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
				"			<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
				"			<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"a.workflowid,a.requestname\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
				"			<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(27044,user.getLanguage())+"\" column=\"ismultiprint\" orderkey=\"a.ismultiprint\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getIsmultiprintStr\" />"+
				"			<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"a.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>"+
				"			<col width=\"22%\" text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\"  otherpara=\""+para1+"\" />"+
				"			<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"b.receivedate,b.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
				"			<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" />"+
				"		</head>"+
				"</table>";
%>
		<TABLE width="100%" cellspacing=0>
			<tr>
				<td valign="top">  
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
				</td>
			</tr>
		</TABLE>
		</td>
		</tr>
		</TABLE>
</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			if (rid.indexOf(",") == 0) {
				rid = rid.substr(1);
				rname = rname.substr(1);
			}
			curl = "#";
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ rid + "'>"
						+ rname + "</a>";
			} else {
				spanobj.innerHTML = rname;
			}
			inputobj.value = rid;
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function getajaxurl() {
	var tmpval = $GetEle("creatertype").value;
	var url = "";	
	if (tmpval == "0") {
		url = "/data.jsp";
	}else {
		url = "/data.jsp?type=18";
	}	
	return url;
}
function onChangeResource(){
	var tmpval = $GetEle("creatertype").value;
	var tempurl1 = "";
	if (tmpval == "0") {
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	}else {
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	return tempurl1;
}
function onShowResource() {
	var tmpval = $GetEle("creatertype").value;
	var id = null;
	if (tmpval == "0") {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}else {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}
	if (id != null) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
        	$G("resourcespan").innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			$G("createrid").value=wuiUtil.getJsonValueByIndex(id, 0);
        } else {
			$G("resourcespan").innerHTML = "";
			$G("createrid").value="";
        }
	}
}


function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}


function onShowOperater() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G("operaterspan"), $G("operater"), false);
}

function onShowWorkFlow(inputname, spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp";
	disModalDialog(url, $G(spanname), $G(inputname), false);
	$G("weaver").submit();
}

function changelevel(tmpindex) {
	document.getElementsByName("check_con")[tmpindex*1].checked = true;
}

function onShowBrowser(id,url) {
	disModalDialog(url, $G("con"+id+"_valuespan"), $G("con"+id+"_value"), false);
	$G("con"+id+"_name").value = $G("con"+id+"_valuespan").innerHTML;
}

function onShowBrowser1(id,url,type1) {
	if (type1 == 1) {
		disModalDialog(url, $G("con"+id+"_valuespan"), $G("con"+id+"_value"), false);
	} else if (type1 == 2) {
		disModalDialog(url, $G("con"+id+"_value1span"), $G("con"+id+"_value1"), false);
	}
}


function onShowBrowser2(id,url,type1) {
	if (type1 == 8) {
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if(type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if(type1 == 1  ) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if(type1 == 4  ) {
		tmpids = $G("con" + id + "_value").value;
		alert(tmpids);
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids);
	} else if(type1 == 16  ) {
		tmpids = $G("con"+id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if(type1 == 7 ) { 
		tmpids =$G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	}

	if (id1 != null && id != undefined) {
		var resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
		var resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
		if (resourceids != null && resourceids != "" ) {
			$G("con" + id + "_valuespan").innerHTML =resourcename;
			$G("con" + id + "_value").value=resourceids;
			$G("con" + id + "_name").value=resourcename;
		} else {
			$G("con"+id+"_valuespan").innerHTML = "";
			$G("con"+id+"_value").value="";
			$G("con"+id+"_name").value="";
		}
	} 
}



function onShowMutiHrm(spanname,inputename) {
		var tmpids = $G(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + tmpids);
		if (id1 != null && id1 != undefined) {
			var rid =  wuiUtil.getJsonValueByIndex(id1, 0);
			var rname = wuiUtil.getJsonValueByIndex(id1, 1);

			if (rid != "") {
				var resourceids = rid.substr(1);
				var resourcename = rname.substr(1);
				$(inputename).value= resourceids
				sHtml = "";

				var idArray = resourceids.split(",");
				var nameArray = resourcename.split(",");

				for (var _i=0; _i<idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml = sHtml + curname + "&nbsp";
				}

				$G(spanname).innerHTML = sHtml;
				if (spanname.indexOf("remindobjectidspan") != -1) {
					$G("isother").checked=true
				} else {
					document.getElementsByName("flownextoperator")[0].checked=false
					document.getElementsByName("flownextoperator")[1].checked=true
				}
			} else {
				$G(spanname).innerHTML ="";
				$G(inputename).value="";

				if (spanname.indexOf("remindobjectidspan") != -1) {
					$G("isother").checked=false
				} else {
					document.getElementsByName("flownextoperator")[0].checked=true
					document.getElementsByName("flownextoperator")[1].checked=false
				}
			}
		}
}
</script>

<script language=vbs>



</script>

<SCRIPT language="javascript">
function OnChangePage(start){
		document.weaver.start.value = start;
		//if(check_form(document.weaver,'fromdate'))
		document.weaver.submit();
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
function onSetPrint(ismultiprint){
	document.getElementById("ismultiprintinput").value = ismultiprint;
	var multirequestid = _xtable_CheckedCheckboxId();
	document.getElementById("multirequestid").value = multirequestid;
	document.getElementById("operation").value = "setprint";
	document.weaver.submit();
}

function onMultiPrint(){
	var multirequestid = _xtable_CheckedCheckboxId();
	//alert(multirequestid);
	if(multirequestid!=null && multirequestid!=""){
		var redirectUrl = "/workflow/multiprint/MultiPrintMode.jsp?multirequestid="+multirequestid;
		var width = screen.availWidth-10 ;
		var height = screen.availHeight-50 ;
		var szFeatures = "top=0," ;
		szFeatures +="left=0," ;
		szFeatures +="width="+width+"," ;
		szFeatures +="height="+height+"," ;
		szFeatures +="directories=no," ;
		szFeatures +="status=yes,toolbar=no,location=no," ;
		szFeatures +="menubar=no," ;
		szFeatures +="scrollbars=yes," ;
		szFeatures +="resizable=yes" ; //channelmode
		window.open(redirectUrl,"",szFeatures) ;
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(26427,user.getLanguage())%>");
	}
	//enableAllmenu();
}

</script>
</body>
</html>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
