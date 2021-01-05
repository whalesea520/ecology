<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page"/>
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16371,user.getLanguage())+"："+ SystemEnv.getHtmlLabelName(20828,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%


int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2")){
	usertype = 1;
}
String seclevel = user.getSeclevel();
String sql=null;


ArrayList NewWorkflows = new ArrayList();
String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
sql = "select workflowid from ShareInnerWfCreate t1 where " +  wfcrtSqlWhere;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	NewWorkflows.add(RecordSet.getString("workflowid"));
}

ArrayList AgentWorkflows = new ArrayList();
ArrayList Agenterids = new ArrayList();
//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
String begindate="";
String begintime="";
String enddate="";
String endtime="";
int agentworkflowtype=0;
int agentworkflow=0;
int beagenterid=0;
sql = "select distinct t1.workflowtype,t.workflowid,t.beagenterid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agent t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" order by t1.workflowtype,t.workflowid";
RecordSet.executeSql(sql);
while(RecordSet.next()){
    boolean isvald=false;
    begindate=Util.null2String(RecordSet.getString("begindate"));
    begintime=Util.null2String(RecordSet.getString("begintime"));
    enddate=Util.null2String(RecordSet.getString("enddate"));
    endtime=Util.null2String(RecordSet.getString("endtime"));
    agentworkflowtype=Util.getIntValue(RecordSet.getString("workflowtype"),0);
    agentworkflow=Util.getIntValue(RecordSet.getString("workflowid"),0);
    beagenterid=Util.getIntValue(RecordSet.getString("beagenterid"),0);
    if(!begindate.equals("")){
        if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
            continue;
    }
    if(!enddate.equals("")){
        if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
            continue;
    }
    
	boolean haswfcreateperm = shareManager.hasWfCreatePermission(beagenterid, agentworkflow);
    
	if(haswfcreateperm){
        AgentWorkflows.add(""+agentworkflow);
        Agenterids.add(""+beagenterid);
    }
}


%>


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

      <TABLE  class=liststyle cellspacing=1>
        <COLGROUP>
        <COL width="50%">
        <COL width="25%">
        <COL width="25%">
        <TBODY>
        <TR class=header>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15184,user.getLanguage())%></TH></TR>
        <TR class=Header>
          <TD><%=SystemEnv.getHtmlLabelName(15185,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(18776,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(20612,user.getLanguage())%></TD>
        </TR><TR class=Line><TD colspan=3 ></TD></TR> 
		<%
		this.rs=RecordSet;
		List list1=this.getAllInputReport(String.valueOf(userid));
		int sizes=list1.size();
		Map m0=null;
		String inprepId=null;
		String inprepName=null;
		String inprepfrequence=null;
		String isInputMultiLine=null;
		String trClass="DataLight";
		for(int i=0;i<sizes;i++){
			m0=(Map)list1.get(i);
			inprepId=Util.null2String((String)m0.get("inprepId"));
			inprepName=InputReportComInfo.getinprepname(inprepId);
			inprepfrequence=InputReportComInfo.getinprepfrequence(inprepId);
			isInputMultiLine=InputReportComInfo.getisinputmultiline(inprepId);
		%>
        <tr class="<%=trClass%>"> 
          <td><a href="javascript:onNewWindow('/datacenter/input/InputReportDate.jsp?inprepid=<%=inprepId%>');"><%=inprepName%></a>
		  </td>
          <td>
          <% if(inprepfrequence.equals("0")) { %><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%>
          <%} else if(inprepfrequence.equals("1")) { %><%=SystemEnv.getHtmlLabelName(20616,user.getLanguage())%>
          <%} else if(inprepfrequence.equals("2")) { %><%=SystemEnv.getHtmlLabelName(20617,user.getLanguage())%>
          <%} else if(inprepfrequence.equals("3")) { %><%=SystemEnv.getHtmlLabelName(20618,user.getLanguage())%>
          <%} else if(inprepfrequence.equals("4")) { %><%=SystemEnv.getHtmlLabelName(20619,user.getLanguage())%>
          <%} else if(inprepfrequence.equals("5")) { %><%=SystemEnv.getHtmlLabelName(20620,user.getLanguage())%>
          <%} else if(inprepfrequence.equals("6")) { %><%=SystemEnv.getHtmlLabelName(20729,user.getLanguage())%>
          <%} else if(inprepfrequence.equals("7")) { %><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%><%}%>
          </td>
          <td>
          <% if(isInputMultiLine.equals("1")) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
          <%} else { %><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
          </td>
        </tr>
		<%
			if(trClass.equals("DataLight")){
			    trClass="DataDark";
		    }else{
			    trClass="DataLight";
			}
		}
		%>
	  </TABLE>

<%
boolean hasNewRequest=false;
String tempWorkflowId=null;
RecordSet.executeSql("select id from workflow_base where isvalid='1' and isShowOnReportInput='1' ");
while(RecordSet.next()){
	tempWorkflowId =Util.null2String(RecordSet.getString("id"));
	if(NewWorkflows.indexOf(tempWorkflowId)!=-1||AgentWorkflows.indexOf(tempWorkflowId)!=-1){
		hasNewRequest=true;
		break;
	}
}
if(hasNewRequest){
%>

<br>
<br>

      <TABLE  class=liststyle cellspacing=1>
        <COLGROUP>
        <COL width="50%">
        <COL width="50%">
        <TBODY>
        <TR class=header>
          <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%></TH></TR>
        <TR class=Header>
          <TD><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(19514,user.getLanguage())%></TD>
        </TR><TR class=Line><TD colspan=2 ></TD></TR> 
		<%

		String workflowId=null;
		String workflowName=null;
		String formId=null;
		int billNameLabel=0;
		trClass="DataLight";

		RecordSet.executeSql("select workflowName,id,formId from workflow_base where isvalid='1' and isShowOnReportInput='1' order by workflowname,id");
		while(RecordSet.next()){

		 	workflowId =Util.null2String(RecordSet.getString("id"));
			workflowName=Util.null2String(RecordSet.getString("workflowName"));
			formId=Util.null2String(RecordSet.getString("formId"));
			billNameLabel=Util.getIntValue(BillComInfo.getBillLabel(formId),0);
		    int isagent=0;
		    String agentname="";
		 	if(NewWorkflows.indexOf(workflowId)==-1){
				if(AgentWorkflows.indexOf(workflowId)==-1){
					continue;
				}else{
					agentname="("+ResourceComInfo.getResourcename(""+Agenterids.get(AgentWorkflows.indexOf(workflowId)))+"->"+user.getUsername()+")";
					isagent=1;
				}
		 	}
		%>
			<tr class="<%=trClass%>"> 
			    <td><a href="javascript:onNewWindow('/workflow/request/AddRequest.jsp?workflowid=<%=workflowId%>&isagent=<%=isagent%>');">
			<%=Util.toScreen(workflowName,user.getLanguage())%><%=agentname%></a></td>
			    <td><%=SystemEnv.getHtmlLabelName(billNameLabel,user.getLanguage())%></td>
			</tr>
		<%

			if(trClass.equals("DataLight")){
			    trClass="DataDark";
		    }else{
			    trClass="DataLight";
			}
		}
		%>
	  </TABLE>
<%
}
%>
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

</BODY></HTML>

<script language=javascript>
function onNewWindow(redirectUrl){
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
}
</script>