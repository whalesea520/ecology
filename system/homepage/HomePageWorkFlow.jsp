<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>

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
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String CurrentUser = ""+user.getUID();
String resourceid=""+user.getUID();

String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
char flag = Util.getSeparator();

ArrayList wftypecounts0=new ArrayList(); //待办
ArrayList wftypecounts1=new ArrayList();	//已办
ArrayList Mywftypecounts0=new ArrayList(); //待办
ArrayList Mywftypecounts1=new ArrayList();	//已办
ArrayList wftypeid=new ArrayList();
while(WorkTypeComInfo.next()){	
 		wftypeid.add(WorkTypeComInfo.getWorkTypeid());
		wftypecounts0.add("0");
		wftypecounts1.add("0");
		Mywftypecounts0.add("0");
		Mywftypecounts1.add("0");
		}
//待办事宜
//RecordSet.executeProc("workflow_currentoperator_SWft",resourceid+flag+usertype);

RecordSet.executeSql("select t1.workflowid , count(distinct t1.requestid) workflowcount   from   workflow_currentoperator t1 where   (t1.isremark='0' or t1.isremark='1' or t2.isremark='5' or  t2.isremark='8' or  t2.isremark='9' or  t2.isremark='7')  and t1.userid=" +  resourceid  + " and t1.usertype= " + usertype +"   group by t1.workflowid order by t1.workflowid " ) ;

while(RecordSet.next()){
    String theworkflowtypeid = WorkflowComInfo.getWorkflowtype(Util.null2String(RecordSet.getString("workflowid"))) ;
	int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
	int tempindex = wftypeid.indexOf(theworkflowtypeid) ;
	if( tempindex != -1 ) 
		wftypecounts0.set(tempindex,""+(Util.getIntValue((String)wftypecounts0.get(tempindex),0)+theworkflowcount)) ;
}

RecordSet.executeSql("select t1.workflowid , count(distinct t1.requestid) workflowcount   from   workflow_currentoperator t1 where   t1.isremark='4'   and t1.userid=" +  resourceid  + " and t1.usertype= " + usertype +"   group by t1.workflowid order by t1.workflowid " ) ;

while(RecordSet.next()){
    String theworkflowtypeid = WorkflowComInfo.getWorkflowtype(Util.null2String(RecordSet.getString("workflowid"))) ;
	int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
	int tempindex = wftypeid.indexOf(theworkflowtypeid) ;
	if( tempindex != -1 ) wftypecounts1.set(tempindex,""+(Util.getIntValue((String)wftypecounts1.get(tempindex),0)+theworkflowcount)) ; 	
}


//我的请求
RecordSet.executeProc("workflow_requestbase_SWftype",resourceid+flag+usertype+flag+"0");
while(RecordSet.next()){
	int tempindex = wftypeid.indexOf(RecordSet.getString("workflowtype")) ;
    if( tempindex != -1 ) Mywftypecounts0.set(tempindex,RecordSet.getString("typecount")) ;
	}
RecordSet.executeProc("workflow_requestbase_SWftype",resourceid+flag+usertype+flag+"1");
while(RecordSet.next()){
	int tempindex = wftypeid.indexOf(RecordSet.getString("workflowtype")) ;
    if( tempindex != -1 ) Mywftypecounts1.set(tempindex,RecordSet.getString("typecount")) ;
	}

int totalcounts0 = 0;
int totalcounts1 = 0;
int Mytotalcounts0 = 0;
int Mytotalcounts1 = 0;
int i=0 ;
for(i=0;i<wftypeid.size();i++){ 
	 String wftypecounts0Str = (String)wftypecounts0.get(i);
	 String wftypecounts1Str = (String)wftypecounts1.get(i);
	 totalcounts0 +=Util.getIntValue(wftypecounts0Str,0)+Util.getIntValue(wftypecounts1Str,0) ;
	 totalcounts1 +=Util.getIntValue(wftypecounts0Str,0) ;
	}
for(i=0;i<wftypeid.size();i++){ 
	 String Mywftypecount0Str = (String)Mywftypecounts0.get(i);
	 String Mywftypecount1Str = (String)Mywftypecounts1.get(i);
	 Mytotalcounts0 +=Util.getIntValue(Mywftypecount0Str,0)+Util.getIntValue(Mywftypecount1Str,0) ;
	 Mytotalcounts1 +=Util.getIntValue(Mywftypecount0Str,0) ;
	}
%>

<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
	<colgroup>
  <col width="50%">
  <col width="1">
  <col width="50%">
    <tr class=Header> 
      <th colspan = 3><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></th>
    </tr>
	 <tr class="datalight"> 
      <td><a href= "/workflow/request/RequestView.jsp" target ="mainFrame"><%=Util.toScreen("待办事宜",user.getLanguage(),"0")%>(<%=totalcounts0+"/"+totalcounts1%>)</a><BR><BR></td>
	  <td bgcolor= "#A4A4A4"></td>
	  <td><a href= "/workflow/request/MyRequestView.jsp" target ="mainFrame"><%=Util.toScreen("我的请求",user.getLanguage(),"0")%>(<%=Mytotalcounts0+"/"+Mytotalcounts1%>)</a><BR><BR></td>
    </tr>
	
	<tr class="datalight"> 
      <td><%
	  for(i=0;i<wftypeid.size();i++){ %>
	  <a href = "/workflow/search/WFSearchTemp.jsp?method=reqeustbywftype&wftype=<%=(String)wftypeid.get(i)%>&complete=0" target = "mainFrame"><%=WorkTypeComInfo.getWorkTypename((String)wftypeid.get(i))%></a>
	  <% 
		String wftypecounts0Str = (String)wftypecounts0.get(i);
	    String wftypecounts1Str = (String)wftypecounts1.get(i);
	  %>	  (<%=(Util.getIntValue(wftypecounts0Str,0)+Util.getIntValue(wftypecounts1Str,0))+"/"+wftypecounts0Str%>)<BR>
	  <%}%></td>
	  <td bgcolor= "#A4A4A4"></td>
	  <td><%
	  for(int j=0;j<wftypeid.size();j++){ %> 
	  <a href = "/workflow/search/WFSearchTemp.jsp?method=myreqeustbywftype&wftype=<%=(String)wftypeid.get(j)%>&complete=0" target = "mainFrame"><%=WorkTypeComInfo.getWorkTypename((String)wftypeid.get(j))%></a>
	  <% 
		String Mywftypecount0Str = (String)Mywftypecounts0.get(j);
	    String Mywftypecount1Str = (String)Mywftypecounts1.get(j);
	  %>	  (<%=(Util.getIntValue(Mywftypecount0Str,0)+Util.getIntValue(Mywftypecount1Str,0))+"/"+Mywftypecount0Str%>)<BR>
	  <%}%></td>
    </tr>

</table>

</body>
</html>