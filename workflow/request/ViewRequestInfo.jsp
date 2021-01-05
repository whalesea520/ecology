<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" rel="STYLESHEET" type="text/css">
<SCRIPT language=VBS>
Sub window_onload()
	wait.style.display="none"
	On Error Resume Next
	Baco.Refresh.focus
End Sub
</SCRIPT>
</HEAD>
<%
String requestid = Util.null2String(request.getParameter("requestid"));
%>
<%
String imagefilename = "/images/hdPRMWorkFlow_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>

<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
<TABLE width="100%" height="100%">
	<TR><TD align=center style="font-size: 36pt;"><%=SystemEnv.getHtmlLabelName(16334,user.getLanguage())%></TD></TR>
</TABLE>
</DIV>
<%
int top0 = 38;

%>
<img src = "/weaver/weaver.workflow.workflow.ShowWorkFlow?requestid=<%=requestid%>" border=0>

<%
int nodexsize = 60;
int nodeysize = 40;
String workflowid="";
String currentnodeid="";
ArrayList operatednode = new ArrayList();
operatednode.clear(); 	

ArrayList operaternode = new ArrayList();
operaternode.clear(); 	

String sql = "select * from workflow_requestbase where requestid = "+requestid;
rs.executeSql(sql);
if(rs.next())
{
	workflowid = Util.null2String(rs.getString("workflowid"));
	currentnodeid = Util.null2String(rs.getString("currentnodeid"));
}
sql = "select * from workflow_requestLog where requestid = "+requestid;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid = Util.null2String(rs.getString("nodeid"));
	String logtype = Util.null2String(rs.getString("logtype"));
	operatednode.add(nodeid+"_"+logtype);
}

sql = "select distinct nodeid,operator,operatortype from workflow_requestLog where requestid = "+requestid;
rs.executeSql(sql);
while(rs.next())
{
	String nodeid = Util.null2String(rs.getString("nodeid"));
	String operator = Util.null2String(rs.getString("operator"));
	String operatortype = Util.null2String(rs.getString("operatortype"));
	operaternode.add(nodeid+"_"+operator+"_"+operatortype);
}

sql = "SELECT * FROM workflow_flownode,workflow_nodebase WHERE (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_flownode.nodeid = workflow_nodebase.id and workflow_flownode.workflowid = "+workflowid;
rs.executeSql(sql);

String bkcol = "#005979";
while(rs.next()){

if(Util.null2String(rs.getString("nodeid")).equals(currentnodeid))
	bkcol = "#005979";
else if(operatednode.indexOf(Util.null2String(rs.getString("nodeid"))+"_2")!=-1)
	bkcol = "#0079A4";
else 
	bkcol = "#00BDFF";
	
int drawxpos = rs.getInt("drawxpos");
int drawypos = rs.getInt("drawypos");
String nodename = Util.null2String(rs.getString("nodename"));
%>
<TABLE cellpadding=1 cellspacing=1 Class=ChartCompany 
	STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;
	TOP:<%=drawypos-nodeysize+top0%>;LEFT:<%=drawxpos-nodexsize%>;
	height:<%=nodeysize*2%>;width:<%=nodexsize*2%>">
<tr height=15px>		
<TD VALIGN=TOP style="padding-left:2px;background-color:<%=bkcol%>;color:white;border:1px solid black">
<B><%=nodename%></B></TD>
</TR><TR>
<%
if(Util.null2String(rs.getString("nodeid")).equals(currentnodeid)){
%>
<TD VALIGN=TOP style="background-color:#F5F5F5;border:4px solid red;padding-left:2px">
<%
}else{
%><TD VALIGN=TOP style="background-color:#F5F5F5;border:1px solid black;padding-left:2px">
<%}%>

<%
for(int i=0;i<operaternode.size();i++){
	String tmp = ""+operaternode.get(i);
	if((tmp).startsWith(""+rs.getString("nodeid")+"_"))
	{
		String tmptype = tmp.substring(tmp.lastIndexOf("_")+1);
		String tmpid = tmp.substring(tmp.indexOf("_")+1,tmp.lastIndexOf("_"));
		
%>
<%if(tmptype.equals("0")){%>
	<a href="javaScript:openhrm(<%=tmpid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(tmpid),user.getLanguage())%></A>
<%}else{%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpid),user.getLanguage())%></a>
<%}%>&nbsp
<%}}%>
&nbsp
</TD></TR></TABLE>
<%}%>
</div>
</body>
</html>
