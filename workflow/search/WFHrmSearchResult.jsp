<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
</script>
</head>
<%

int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
String hrmids = Util.null2String(request.getParameter("hrmids"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String nodetype = Util.null2String(request.getParameter("nodetype"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String creatertype = Util.null2String(request.getParameter("creatertype"));
String createrid = Util.null2String(request.getParameter("createrid"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=frmmain name=frmmain method=post  action="WFHrmSearchResult.jsp">
<input type=hidden name=hrmids value="<%=hrmids%>">
<input type=hidden name=start value="1">
<input type=hidden name=totalcounts value="<%=totalcounts%>">

<%

String sql = "" ;
String userid = "" ;
if(hrmids.equals("")){
 userid = ""+user.getUID();
}else {
userid=hrmids ;
}
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2")) usertype= 1;


String tablename = "wrkhrmtablename"+ Util.getNumberRandom() ;

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);


boolean hasNextPage=false;

if(RecordSet.getDBType().equals("oracle")){
	switch (Util.getIntValue(nodetype , -1)) {
		case -1 :
			sql="create table "+tablename+"  as select * from (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate,t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid,t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1, workflow_currentoperator t2  where t2.requestid = t1.requestid and (  (t2.isremark ='2' and exists (select nodeid from workflow_flownode f where f.nodeid=t2.nodeid and f.nodetype in ('0','2'))) or (t1.currentnodetype='3') ) and t2.userid = "+ hrmids +" and t2.usertype=0 and (t1.deleted=0 or t1.deleted is null)" ;
			break ;
		case 0 :
			//sql="create table "+tablename+"  as select * from (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t2.requestid and t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='0' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0 and t2.userid = " + userid + " and t2.usertype="+usertype  ;
			sql="create table "+tablename+"  as select * from (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.userid = " + userid + " and t2.usertype="+usertype+" and exists (select 1 from workflow_requestLog t3 , workflow_flownode t4  where t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='0' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0)"  ;
			break ;
		case 1 :
			sql="create table "+tablename+"  as select * from (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.userid = " + userid + " and t2.usertype="+usertype +" and exists (select 1 from workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='1' and t3.logtype='0' and t3.operator=" + hrmids + " and t3.operatortype =0)";
			break ;
		case 2 :
			sql="create table "+tablename+"  as select * from (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.userid = " + userid + " and t2.usertype="+usertype +" and exists (select 1 from workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='2' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0)";
			break ;
		case 3 :
			sql ="create table "+tablename+"  as select * from (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1 , workflow_currentoperator t2 where t2.userid="+ hrmids + " and t2.usertype=0 and t1.requestid=t2.requestid and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype='3' and t1.requestid in ( select requestid from workflow_currentoperator where userid="+ userid +" and usertype= " + usertype + " ) " ;
			break ;
	}
}else if(RecordSet.getDBType().equals("db2")){
	switch (Util.getIntValue(nodetype , -1)) {
		case -1 :
			sql="create table "+tablename+"  as select * from (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 ) definition only ";
			RecordSet.executeSql(sql);
			sql="insert into "+tablename+" (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 where t1.requestid = t2.requestid and t1.requestid = t3.requestid and ((t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0) or (t1.currentnodetype='3' and (t1.deleted=0 or t1.deleted is null) and t1.requestid in ( select requestid from workflow_currentoperator where userid="+ hrmids +" and usertype= 0))) and t2.userid = " + userid + " and t2.usertype="+usertype  ;
			break ;
		case 0 :
			sql="create table "+tablename+"  as (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 , workflow_flownode t4 )definition only"  ;
			RecordSet.executeSql(sql);
			sql="insert into  "+tablename+" (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t2.requestid and t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='0' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0 and t2.userid = " + userid + " and t2.usertype="+usertype  ;
			break ;
		case 1 :
			sql="create table "+tablename+"  as (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 , workflow_flownode t4 )definition only " ;
			RecordSet.executeSql(sql);
			sql="insert into "+tablename+"  (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t2.requestid and t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='1' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0 and t2.userid = " + userid + " and t2.usertype="+usertype  ;
			break ;
		case 2 :
			sql="create table "+tablename+"  as  (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 , workflow_flownode t4 )definition only ";
			RecordSet.executeSql(sql);
			sql="insert into "+tablename+"  (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1,workflow_currentoperator t2 , workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t2.requestid and t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='2' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0 and t2.userid = " + userid + " and t2.usertype="+usertype  ;
			break ;
		case 3 :
			sql ="create table "+tablename+"  as (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1 , workflow_currentoperator t2 )definition only " ;
			RecordSet.executeSql(sql);
			sql ="insert into "+tablename+"  (select distinct t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel from workflow_requestbase t1 , workflow_currentoperator t2 where t2.userid="+ hrmids + " and t2.usertype=0 and t1.requestid=t2.requestid and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype='3' and t1.requestid in ( select requestid from workflow_currentoperator where userid="+ userid +" and usertype= " + usertype + " ) ) " ;
			break ;
	}
}else{
	switch (Util.getIntValue(nodetype , -1)) {
		case -1 :
			sql="select distinct top "+(start*perpage+1)+" t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate,t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid,t1.requestname, t1.status, t1.requestlevel into "+tablename+" from workflow_requestbase t1, workflow_currentoperator t2  where t2.requestid = t1.requestid and (  (t2.isremark ='2' and exists (select nodeid from workflow_flownode f where f.nodeid=t2.nodeid and f.nodetype in ('0','2'))) or (t1.currentnodetype='3') ) and t2.userid = "+ hrmids +" and t2.usertype=0 and (t1.deleted=0 or t1.deleted is null)";
			break ;
		case 0 :
			sql="select distinct top "+(start*perpage+1)+" t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel into "+tablename+" from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.userid = " + userid + " and t2.usertype="+usertype + " and exists (select 1 from workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='0' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0 )";
			break ;
		case 1 :
			sql="select distinct top "+(start*perpage+1)+" t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel into "+tablename+" from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.userid = " + userid + " and t2.usertype="+usertype +" and exists (select 1 from workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='1' and t3.logtype='0' and t3.operator=" + hrmids + " and t3.operatortype =0)";
			break ;
		case 2 :
			sql="select distinct top "+(start*perpage+1)+" t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel into "+tablename+" from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.userid = " + userid + " and t2.usertype="+usertype +" and exists (select 1 from workflow_requestLog t3 , workflow_flownode t4 where t1.requestid = t3.requestid and t3.nodeid = t4.nodeid and t4.nodetype='2' and t3.logtype='2' and t3.operator=" + hrmids + " and t3.operatortype =0)";
			break ;
		case 3 :
			sql = " select distinct top "+(start*perpage+1)+" t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status, t1.requestlevel into "+tablename+" from workflow_requestbase t1 , workflow_currentoperator t2 where t2.userid="+ hrmids + " and t2.usertype=0 and t1.requestid=t2.requestid and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype='3' and t1.requestid in ( select requestid from workflow_currentoperator where userid="+ userid +" and usertype= " + usertype + " ) " ;

			break ;
	}


}


if(!workflowid.equals(""))
    sql +=" and t1.workflowid in("+workflowid+")" ;

if(!fromdate.equals(""))
    sql += " and t1.createdate>='"+fromdate+"'";

if(!todate.equals(""))
    sql += " and t1.createdate<='"+todate+"'";

                        

if(!createrid.equals("")){
    sql += " and t1.creater='"+createrid+"'";
    sql += " and t1.creatertype= '"+creatertype+"' ";
}

if(!requestlevel.equals(""))
    sql += " and t1.requestlevel="+requestlevel;
if(RecordSet.getDBType().equals("oracle"))
{
	sql += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}
else
{
	sql += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}
String orderby="";
if(RecordSet.getDBType().equals("oracle")){
	orderby=" order by t1.requestlevel desc,t1.lastoperatedate desc,t1.lastoperatetime desc ) where rownum<"+ (start*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
	orderby=" order by t1.requestlevel desc,t1.lastoperatedate desc,t1.lastoperatetime desc fetch first "+(start*perpage+1)+" rows only ) ";
}else{
	orderby=" order by t1.requestlevel desc,t1.lastoperatedate desc,t1.lastoperatetime desc";
}

String orderby2=" order by t1.requestlevel,t1.lastoperatedate,t1.lastoperatetime";

sql += orderby;


RecordSet.executeSql(sql);
RecordSet.executeSql("Select count(requestid) RecordSetCounts from "+tablename);

int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}

if(RecordSetCounts>start*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+tablename+" t1 "+orderby2+") where rownum< "+(RecordSetCounts-(start-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select  * from "+tablename+" t1 "+orderby2+" fetch first "+(RecordSetCounts-(start-1)*perpage)+" rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(start-1)*perpage)+" * from "+tablename+" t1 "+orderby2;
}
RecordSet.executeSql(sqltemp);
RecordSet.executeSql("drop table "+tablename);

%>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
    <wea:item>
     <select class=inputstyle  size=1 name=workflowid style=width:240>
     	<option value="">&nbsp;</option>
     	<%
     	while(WorkflowComInfo.next()){
     		String curwfids=WorkflowComInfo.getWorkflowid();
     		String workflownames=WorkflowComInfo.getWorkflowname();
     	%>
     	<option value="<%=curwfids%>" <% if(workflowid.equals(curwfids)) {%>selected<%}%> ><%=Util.toScreen(workflownames,user.getLanguage())%></option>
     	<%}%>
     </select>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></wea:item>
    <wea:item>
     <select class=inputstyle  size=1 name=nodetype style=width:240>
     <option value="">&nbsp;</option>
     <option value="0" <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<option value="3" <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
     </select>
     </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
    <wea:item><BUTTON class=calendar type="button" id=SelectDate  onclick="getfromDate()"></BUTTON>
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
      -&nbsp;&nbsp;<BUTTON class=calendar type="button" id=SelectDate2 onclick="gettoDate()"></BUTTON>
      <SPAN id=todatespan><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate" value="<%=todate%>">
    </wea:item>

      <wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
	  <wea:item>
	  <select class=inputstyle  name=creatertype>
	  <option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
	  <option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  </select>
	  &nbsp;
	  <button class=browser type="button" onClick="onShowResource()"></button>
		<span id=resourcespan>
		<% if(creatertype.equals("0")){%><%=ResourceComInfo.getResourcename(createrid)%><%}%>
	    <% if(creatertype.equals("1")){%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%><%}%>
    </span>
		<input name=createrid type=hidden value="<%=createrid%>">
	</wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></wea:item>
	<wea:item>
	<select class=inputstyle  name=requestlevel style=width:240 size=1>
	  <option value=""> </option>
	  <option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	  <option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	  <option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	</select>
	</wea:item>
	</wea:group>
</wea:layout>
</form>
<br>
<span style="font-size: 12px;font-weight: bold"><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%>&nbsp;<%=totalcounts%></span>
<table class=ListStyle cellspacing=1   id=tblReport>
    <colgroup> 
    <col valign=top align=left width="10%"> 
    <col valign=top align=left width="10%"> 
    <col valign=top align=left width="15%">
    <col valign=top align=left width="10%">  
    <col valign=top align=left width="30%"> 
    <col valign=top align=left width="15%"> 
    <col valign=top align=left width="10%"> 
    <tr class=HeaderForXtalbe> 
      <th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
<%
boolean islight=true;
int totalline=1;
if(RecordSet.last()){
	do{
	String requestid_rs=RecordSet.getString("requestid");
	String createdate_rs=RecordSet.getString("createdate");
	String creater_rs=RecordSet.getString("creater");
	String creatertype_rs=RecordSet.getString("creatertype");
	String creatername_rs=ResourceComInfo.getResourcename(creater_rs);
	String workflowid_rs=RecordSet.getString("workflowid");
	String workflowname_rs=WorkflowComInfo.getWorkflowname(workflowid_rs);
	String requestname_rs=RecordSet.getString("requestname");
	String status_rs=RecordSet.getString("status");
	String requestlevel_rs=RecordSet.getString("requestlevel");
%>
    <tr <%if(islight){%> class=DataLight <%} else {%> class=DataLight <%}%>>
      <td><%=Util.toScreen(createdate_rs,user.getLanguage())%></td>
      <td>
      <%if(creatertype.equals("0")||creatertype_rs.equals("0")){%>
      <a href="javaScript:openhrm(<%=creater_rs%>);" onclick='pointerXY(event);'><%=Util.toScreen(creatername_rs,user.getLanguage())%></a>
      <%}else if(creatertype_rs.equals("1")||creatertype.equals("1")){%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=creater_rs%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(creater_rs),user.getLanguage())%></a>
      <%}else{%>
      <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
      <%}%>
      </td>
      <td><%=Util.toScreen(workflowname_rs,user.getLanguage())%></td>
      <td>
      <%if(requestlevel_rs.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
      <%if(requestlevel_rs.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
      <%if(requestlevel_rs.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      </td>
      <td>
      <a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid_rs%>"><%=Util.toScreen(requestname_rs,user.getLanguage())%></a>
      </td>
      <td><%=Util.toScreen(createdate_rs,user.getLanguage())%></td>
      <td><%=Util.toScreen(status_rs,user.getLanguage())%></td>
       </tr>
<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
	}while(RecordSet.previous());
}
%>
</table>
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td><%if(start>1){%>
   
   <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:goPrepage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%> <%}%>
   </td>
   <td><%if(hasNextPage){%>
    <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:goNextpage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%></td>
   <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  
	  </td>
		</tr>
		</TABLE>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</form>
      
</body>
<script language=vbs>
sub onShowResource1()
	tmpval = document.all("creatertype").value
	if tmpval = "0" then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	end if
	if NOT isempty(id) then
	        if id(0)<> "" then
		resourcespan.innerHtml = id(1)
		frmmain.createrid.value=id(0)
		else
		resourcespan.innerHtml = ""
		frmmain.createrid.value=""
		end if
	end if
	
end sub
</script> 

<script language=javascript>
function onShowResource(){
	tmpval = jQuery("select[name=creatertype]").val();
	if (tmpval == "0"){
		data =					window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	}else{ 
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	}
	if (data!=null){
	    if (data.id!=""){
			jQuery("#resourcespan").html(data.name);
			jQuery("input[name=createrid]").val(data.id);
		}else{
			jQuery("#resourcespan").html("");
			jQuery("input[name=createrid]").val("");
		}
	}
	
}

function goPrepage() {
    document.frmmain.start.value= "<%=start-1%>" ;
    document.frmmain.submit() ;
}

function goNextpage() {
    document.frmmain.start.value= "<%=start+1%>" ;
    document.frmmain.submit() ;
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
