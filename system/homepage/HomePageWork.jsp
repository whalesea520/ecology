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
<body>
<%
String userid = ""+user.getUID();
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=6;
int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);
boolean hasNextPage=false;
Calendar today = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String selectDate = nowdate;
today.add(Calendar.WEEK_OF_YEAR,1) ;		
String selectToDate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String sqlStr = "" ;
String workPlanStatus =  Util.null2String(request.getParameter("workPlanStatus"));
String whereStr = "" ;
whereStr += " and t1.status = '0' " ;

spp.setBackFields("t1.id,t1.name" );
spp.setSqlFrom("WorkPlan t1 , WorkPlanShareDetail t2");
spp.setSqlWhere("t1.id = t2.workid and  t2.userid = " + userid + " and ( concat(concat(',',TO_CHAR(t1.resourceid)),',') ) like '%"+(","+userid+",")+"%'" +   
						" and ((t1.begindate < '"+selectToDate+"' and t1.begindate >= '"+selectDate+"') or "+
						" (t1.enddate < '"+selectToDate+"' and t1.enddate >= '"+selectDate+"') or "+
						" (t1.enddate >= '"+selectToDate+"' and t1.begindate < '"+selectDate+"') or (t1.enddate is null and t1.begindate <= '"+selectDate+"'))"+whereStr);
spp.setSqlOrderBy("t1.id");
spp.setPrimaryKey("t1.id");
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

<table class=ListShort id=tblReport cellspacing=1>
    <tbody> 
    <tr class=Header> 
      <th colspan = "2"><%=SystemEnv.getHtmlLabelName(6057,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href = "/workplan/data/WorkPlan.jsp?add=1" target="mainFrame"><%=SystemEnv.getHtmlLabelName(15093,user.getLanguage())%></a></th>
    </tr>
    <colgroup> 
    <col valign=top align=left width="10%"> 
    <col valign=top align=left width="90%"> 
<%
boolean islight=true;
int totalline=1;
RecordSet.afterLast() ;
while(RecordSet.previous()){
	String id=RecordSet.getString("id");
	String workName=RecordSet.getString("name");
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>	
      <td align="center"><li></td>
      <td>
      <a href="/workplan/data/WorkPlan.jsp?workid=<%=id%>" target = "mainFrame"><%=Util.toScreen(workName,user.getLanguage())%></a>
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
   <td><%if(pagenum>1){%><button class=btn accessKey=P onclick="location.href='HomePageWork.jsp?pagenum=<%=pagenum-1%>'"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%></td>
   <td><%if(hasNextPage){%><button class=btn accessKey=N onclick="location.href='HomePageWork.jsp?pagenum=<%=pagenum+1%>'"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
   <td>&nbsp;</td>
   </tr>
</TABLE>
</body>
</html>