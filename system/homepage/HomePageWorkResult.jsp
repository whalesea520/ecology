<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="spp" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDoc_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;

	workflowid = SearchClause.getWorkflowId();
	nodetype = SearchClause.getNodeType();
	fromdate = SearchClause.getFromDate();
	todate = SearchClause.getToDate();
	creatertype = SearchClause.getCreaterType();
	createrid = SearchClause.getCreaterId();
	requestlevel = SearchClause.getRequestLevel();

String newsql="";
//out.print(newsql);
String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

String sqlwhere="where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype;
String orderby = "";
String orderby2 = "";
if(!Util.null2String(SearchClause.getWhereClause()).equals("")){
	sqlwhere += " and "+SearchClause.getWhereClause()+" "+newsql;
}


orderby=" order by t1.lastoperatedate desc,t1.requestlevel desc,t1.lastoperatetime desc";
orderby2=" order by t1.lastoperatedate,t1.requestlevel,t1.lastoperatetime";

String tablename = "wrktablename"+ Util.getRandom() ;

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

boolean hasNextPage=false;
spp.setBackFields("t1.requestid, createdate, createtime,lastoperatedate, lastoperatetime,creater, creatertype, t1.workflowid, requestname, status,requestlevel" );
spp.setSqlFrom("workflow_requestbase t1,workflow_currentoperator t2");
spp.setSqlWhere(sqlwhere);
spp.setSqlOrderBy(orderby);
spp.setPrimaryKey("t1.requestid");
spp.setDistinct(true);
spp.setSortWay(spp.DESC);

spu.setSpp(spp);       
RecordSet = spu.getCurrentPageRs(pagenum,perpage);      

if(TotalCount==0){
	TotalCount = spu.getRecordCount();
}
if(TotalCount>pagenum*perpage){
	hasNextPage=true;
}

%>

<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
    <tr class=Header> 
      <th colspan = "2">今日工作&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href = "/workflow/request/AddRequest.jsp?workflowid=2" target="mainFrame"><font color="FFFFFF"><%=SystemEnv.getHtmlLabelName(15093,user.getLanguage())%></font></a></th>
    </tr>
    <colgroup> 
    <col valign=top align=left width="40%"> 
    <col valign=top align=left width="60%"> 
<%
boolean islight=true;
int totalline=1;

RecordSet.afterLast() ;
while(RecordSet.previous()){
	String requestid_rs=RecordSet.getString("requestid");
	String createdate_rs=RecordSet.getString("createdate");
	String requestname_rs=RecordSet.getString("requestname");
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>	
      <td><%=Util.toScreen(createdate_rs,user.getLanguage())%></td>
      <td>
      <a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid_rs%>" target = "mainFrame"><%=Util.toScreen(requestname_rs,user.getLanguage())%></a>
      </td>
       </tr>
<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}
%>
</table>
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td><%if(start>1){%><button class=btn accessKey=P onclick="location.href='HomePageWorkResult.jsp?start=<%=start-1%>&totalcounts=<%=totalcounts%>'"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%></td>
   <td><%if(hasNextPage){%><button class=btn accessKey=N onclick="location.href='HomePageWorkResult.jsp?start=<%=start+1%>&totalcounts=<%=totalcounts%>'"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
   <td>&nbsp;</td>
   </tr>
	  </TABLE>
</body>
</html>