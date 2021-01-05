<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();

int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
String sqlwhere="where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t1.currentnodetype != 3 and t2.usertype=" + usertype;
if(RecordSet.getDBType().equals("oracle"))
{
	sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}
else
{
	sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}
String orderby = "";
String orderby2 = "";
if (Util.null2String(request.getParameter("comefrom")).equals("homepage")) SearchClause.resetClause();
if(!Util.null2String(SearchClause.getWhereClause()).equals("")){
	sqlwhere += " and "+SearchClause.getWhereClause();
}
if (Util.null2String(request.getParameter("comefrom")).equals("homepage")){
    sqlwhere += " and t1.creater<>"+CurrentUser ;
}
orderby=" order by t1.createdate desc,t1.requestlevel desc,t1.createtime desc";
orderby2=" order by t1.createdate,t1.requestlevel,t1.createtime";

String tablename = "wrktablename"+ Util.getNumberRandom() ;

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

boolean hasNextPage=false;
if(totalcounts==0){
	sql="select count(distinct t1.requestid) from workflow_requestbase t1,workflow_currentoperator t2 ";
	sql+=sqlwhere;
	RecordSet.executeSql(sql);
	if(RecordSet.next())
		totalcounts = RecordSet.getInt(1);
}
if(RecordSet.getDBType().equals("oracle")){
	sql="create table "+tablename+"  as select * from (select distinct t1.requestid, createdate, createtime,lastoperatedate, lastoperatetime,creater, creatertype, t1.workflowid, requestname, status,requestlevel from workflow_requestbase t1,workflow_currentoperator t2 ";
	sql+=sqlwhere;
	sql+= " "+orderby;
	sql+= " ) where rownum<"+ (start*perpage+2);
}else{
	sql="select distinct top "+(start*perpage+1)+" t1.requestid, createdate, createtime,lastoperatedate, lastoperatetime,creater, creatertype, t1.workflowid, requestname, status,requestlevel into "+tablename+" from workflow_requestbase t1,workflow_currentoperator t2 ";
	sql+=sqlwhere;
	sql+= " "+orderby;
}

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
}else{
	sqltemp="select top "+(RecordSetCounts-(start-1)*perpage)+" * from "+tablename+" t1 "+orderby2;
}
RecordSet.executeSql(sqltemp);
RecordSet.executeSql("drop table "+tablename);

%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(start>1){%>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",HomePageWFSearchResult.jsp?start="+(start-1)+"&totalcounts="+totalcounts+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;}
%>
<%if(hasNextPage){%>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",HomePageWFSearchResult.jsp?start="+(start+1)+"&totalcounts="+totalcounts+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class=liststyle cellspacing=1   id=tblReport cellspacing=1>
    <tbody> 
    <tr class=Header> 
      <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>      
      <th><%=SystemEnv.getHtmlLabelName(15532,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
    </tr>
	<TR class=Line><Th colspan="4" ></Th></TR> 
<%
boolean islight=true;
int totalline=1;
if(RecordSet.last()){
	do{
	String requestid=RecordSet.getString("requestid");
	String createdate=RecordSet.getString("createdate");
	String creater=RecordSet.getString("creater");
	String creatertype=RecordSet.getString("creatertype");
	String creatername=ResourceComInfo.getResourcename(creater);
	String workflowid=RecordSet.getString("workflowid");
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
	String requestname=RecordSet.getString("requestname");
	String status=RecordSet.getString("status");
	String requestlevel=RecordSet.getString("requestlevel");
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
      <td><%=Util.toScreen(createdate,user.getLanguage())%></td> 
      <td>
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      </td>
      <td>
      <a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>" target="mainFrame"><%=Util.toScreen(requestname,user.getLanguage())%></a>
      </td>
<!--	  <td><%=Util.toScreen(workflowname,user.getLanguage())%></td>  -->
      <td><%=Util.toScreen(status,user.getLanguage())%></td>
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
	  	</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</body>
</html>