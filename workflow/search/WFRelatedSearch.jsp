<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(522,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
	
<%
String whereclause="";
String orderclause="";
String where="";
String sql="";

String relatedtype=Util.null2String(request.getParameter("relatedtype"));
int relatedid=Util.getIntValue(request.getParameter("relatedid"),0);
String nodetype=Util.null2String(request.getParameter("nodetype"));

ArrayList requestids=new ArrayList();
if(relatedtype.equals("doc")){
	
	sql="select distinct fieldname from workflow_formdict where fieldhtmltype='3' and type=9";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String temp=RecordSet.getString(1);
		if(where.equals(""))	where=" and( t1."+temp+"="+relatedid;
		else	where+=" or t1."+temp+"="+relatedid;
	}
	if(!where.equals("")){
		where+=")";
		sql="select distinct t2.* from workflow_form t1,workflow_requestbase t2 where t1.requestid=t2.requestid";
		sql+=where;
	}
}
if(relatedtype.equals("resource")){
	sql="select distinct fieldname from workflow_formdict where fieldhtmltype='3' and type=1";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String temp=RecordSet.getString(1);
		if(where.equals(""))	where=" and( t1."+temp+"="+relatedid;
		else	where+=" or t1."+temp+"="+relatedid;
	}
	if(!where.equals("")){
		where+=")";
		if(nodetype.equals(""))
			sql="select distinct t2.* from workflow_form t1,workflow_requestbase t2 where t1.requestid=t2.requestid";
		else
			sql="select distinct t2.* from workflow_form t1,workflow_requestbase t2 where t1.requestid=t2.requestid and t2.currentnodetype='"+nodetype+"'";
		sql+=where;
		
	}
}
if(relatedtype.equals("crm")){
	sql="select distinct fieldname from workflow_formdict where fieldhtmltype='3' and type=7";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String temp=RecordSet.getString(1);
		if(where.equals(""))	where=" and( t1."+temp+"="+relatedid;
		else	where+=" or t1."+temp+"="+relatedid;
	}
	if(!where.equals("")){
		where+=")";
		if(nodetype.equals(""))
			sql="select distinct t2.* from workflow_form t1,workflow_requestbase t2 where t1.requestid=t2.requestid";
		else
			sql="select distinct t2.* from workflow_form t1,workflow_requestbase t2 where t1.requestid=t2.requestid and t2.currentnodetype='"+nodetype+"'";
		sql+=where;
		
	}
}
if(relatedtype.equals("proj")){
	sql="select distinct fieldname from workflow_formdict where fieldhtmltype='3' and type=8";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String temp=RecordSet.getString(1);
		if(where.equals(""))	where=" and( t1."+temp+"="+relatedid;
		else	where+=" or t1."+temp+"="+relatedid;
	}
	if(!where.equals("")){
		where+=")";
		if(nodetype.equals(""))
			sql="select distinct t2.* from workflow_form t1,workflow_requestbase t2 where t1.requestid=t2.requestid";
		else
			sql="select distinct t2.* from workflow_form t1,workflow_requestbase t2 where t1.requestid=t2.requestid and t2.currentnodetype='"+nodetype+"'";
		sql+=where;
		
	}
}
if(relatedtype.equals("crmcontract")){
	sql="select t3.* from bill_contract t1,workflow_form t2,workflow_requestbase t3"+
		" where t1.id=t2.billid and t2.requestid=t3.requestid and t2.billformid=4 and t1.crmid="+relatedid; 
	where="0";
}
if(relatedtype.equals("prjcontract")){
	sql="select t3.* from bill_contract t1,workflow_form t2,workflow_requestbase t3"+
		" where t1.id=t2.billid and t2.requestid=t3.requestid and t2.billformid=4 and t1.projectid="+relatedid; 
	where="0";
}
if(relatedtype.equals("itemcontract")){
	sql="select distinct t3.* from bill_contractdetail t0,workflow_form t2,workflow_requestbase t3"+
	" where t0.contractid = t2.billid and t2.requestid=t3.requestid and t2.billformid=4 and t0.assetid= "+relatedid; 
	where="0";
}

if(relatedtype.equals("itemusage")){
	sql="select t3.* from bill_itemusage t0,workflow_form t2,workflow_requestbase t3"+
	" where t0.id = t2.billid and t2.requestid=t3.requestid and t2.billformid=1 and t0.itemid= "+relatedid; 
	where="0";
}

if(where.equals("")){
	%><font color=red size=2><%=SystemEnv.getHtmlLabelName(15535,user.getLanguage())%></font><%
}
else{
	RecordSet.executeSql(sql);
	int totalcounts=RecordSet.getCounts();
	if(totalcounts==0){
	%><font color=red size=2><%=SystemEnv.getHtmlLabelName(15535,user.getLanguage())%></font><%
		return;
	}
	%>
	
	<table class=liststyle cellspacing=1   id=tblReport>
	    <colgroup> 
	    <col valign=top align=left width="15%"> 
	    <col valign=top align=left width="15%"> 
	    <col valign=top align=left width="15%"> 
	    <col valign=top align=left width="25%"> 
	    <col valign=top align=left width="15%"> 
	    <col valign=top align=left width="15%"> 
	    <tbody>     <TR class="header"><TH colspan=6><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%>&nbsp;<%=totalcounts%></TH></TR>
	    <tr class=Header> 
	      <th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
	    </tr><tr class="Line"><th colspan="6"></th></tr>
	<%
	boolean islight=true;
	while(RecordSet.next()){
		String requestid=RecordSet.getString("requestid");
		String createdate=RecordSet.getString("createdate");
		String creater=RecordSet.getString("creater");
		String creatername=ResourceComInfo.getResourcename(creater);
		String workflowid=RecordSet.getString("workflowid");
		String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
		String requestname=RecordSet.getString("requestname");
		String status=RecordSet.getString("status");
	%>
	    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
	      <td><a href="javaScript:openhrm(<%=creater%>);" onclick='pointerXY(event);'><%=Util.toScreen(creatername,user.getLanguage())%></a></td>
	      <td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
	      <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>"><%=Util.toScreen(requestname,user.getLanguage())%></a></td>
	      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
	      <td><%=Util.toScreen(status,user.getLanguage())%></td>
	    </tr>
	<%
		islight=!islight;
	}
	%>
	</table></td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


	<%
}
%>
</body>
</html>