<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(734,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String startdate1=Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());
String startdate2=Util.fromScreen(request.getParameter("startdate2"),user.getLanguage());
int workflowtype=Util.getIntValue(request.getParameter("workflowtype"),0);
String state=Util.fromScreen(request.getParameter("state"),user.getLanguage());
if(state.equals(""))	state="2";
%>
<form name=frmmain method=post action="RequestQualityRp.jsp">
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



<table class="viewform">
   <tr class="Title"><th colspan=2><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></tr>
   <TR class="Spacing"><TD colspan=2 class=sep2></TD></TR>
<tr>
   <td width="15%"><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></td>
   <td width="85%"><BUTTON type='button'  class=calendar onclick=getStartDate1()></BUTTON>&nbsp;
      	<SPAN id=startdatespan1 ><%=startdate1%></SPAN>
      	-&nbsp;&nbsp;<BUTTON type='button' class=calendar onclick="getStartDate2()"></BUTTON>&nbsp;
      	<SPAN id=startdatespan2 " ><%=startdate2%></SPAN>
	<input type="hidden" name="startdate1" value=<%=startdate1%>><input type="hidden" name="startdate2" value=<%=startdate2%>>
   </td>
</tr>
<tr>
   <td width="15%"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
   <td width="85%">
   <select class=inputstyle  size=1 name=workflowytype style=width:240>
<%   	while(WorkTypeComInfo.next()){
		String selected="";
		String curtype=WorkTypeComInfo.getWorkTypeid();
		String curtypename=WorkTypeComInfo.getWorkTypename();
		if((workflowtype+"").equals("curtype"))	selected="selected";
		if(workflowtype==0)	workflowtype=Util.getIntValue(curtype,0);
%>
	<option value=<%=curtype%> <%=selected%>><%=Util.toScreen(curtypename,user.getLanguage())%></option>
<%	}
%>
   </select>
   </td>
</tr>
<tr>
   <td width="15%"><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
   <td width="85%">
   <select class=inputstyle  size=1 name=state style=width:240>
	<option value=1 <%if(state.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
	<option value=2 <%if(state.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></option>
   </select>
   </td>
</tr>
</table>
<%
ArrayList workflowids=new ArrayList();
RecordSet.executeProc("workflow_base_SelectByType",workflowtype+"");
while(RecordSet.next()){
	workflowids.add(RecordSet.getString("id"));
}
ArrayList arraycount1=new ArrayList();//<=1
ArrayList arraycount2=new ArrayList();//>1 & <=3
ArrayList arraycount3=new ArrayList();//>3 & <=5
ArrayList arraycount4=new ArrayList();//>5
ArrayList arraycount5=new ArrayList();//longest
ArrayList arraycount6=new ArrayList();//ping jun time
ArrayList arrayall=new ArrayList();//the total count of every workflow

for(int i=0;i<workflowids.size();i++){
	arraycount1.add("0");
	arraycount2.add("0");
	arraycount3.add("0");
	arraycount4.add("0");
	arraycount5.add("0");
	arraycount6.add("0.0");
}
String sql="select count(*) count,t1.workflowid from workflow_requestbase t1,workflow_base t2"+
	" where t1.workflowid =t2.id and t2.workflowtype="+workflowtype+" and deleted=0";
if(state.equals("1"))	sql+=" and currentnodetype='3'";
if(state.equals("2"))	sql+=" and currentnodetype<>'3'";
if(!startdate1.equals(""))	sql+=" and createdate>='"+startdate1+"'";
if(!startdate2.equals(""))	sql+=" and createdate<='"+startdate2+"'";

String querysql= "" ;
if((RecordSet.getDBType()).equals("oracle")) {
    querysql= sql+ " and (to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD')) <=1 group by workflowid";
}
else {
    querysql= sql+ " and (convert(datetime,lastoperatedate)-convert(datetime,createdate))<=1 group by workflowid";
}

RecordSet.executeSql(querysql);
while(RecordSet.next()){
	String curcount=RecordSet.getString("count");
	String curworkflowid=RecordSet.getString("workflowid");
	int index=workflowids.indexOf(curworkflowid);
    	if(index!=-1)	arraycount1.add(index,curcount);
}

if((RecordSet.getDBType()).equals("oracle")) {
    querysql=sql+ " and (to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD'))>1"+
            " and (to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD'))<=3 group by workflowid";
}
else {
    querysql=sql+ " and (convert(datetime,lastoperatedate)-convert(datetime,createdate))>1"+
            " and (convert(datetime,lastoperatedate)-convert(datetime,createdate))<=3 group by workflowid";
}

RecordSet.executeSql(querysql);
while(RecordSet.next()){
	String curcount=RecordSet.getString("count");
	String curworkflowid=RecordSet.getString("workflowid");
	int index=workflowids.indexOf(curworkflowid);
    	if(index!=-1)	arraycount2.add(index,curcount);
}
if((RecordSet.getDBType()).equals("oracle")) {
    querysql=sql+ " and (to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD'))>3"+
            " and (to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD'))<=5 group by workflowid";
}
else {
    querysql=sql+ " and (convert(datetime,lastoperatedate)-convert(datetime,createdate))>3"+
            " and (convert(datetime,lastoperatedate)-convert(datetime,createdate))<=5 group by workflowid";
}

RecordSet.executeSql(querysql);
while(RecordSet.next()){
	String curcount=RecordSet.getString("count");
	String curworkflowid=RecordSet.getString("workflowid");
	int index=workflowids.indexOf(curworkflowid);
    	if(index!=-1)	arraycount3.add(index,curcount);
}
if((RecordSet.getDBType()).equals("oracle")) {
    querysql=sql+ " and (to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD'))>5 group by workflowid";
}
else {
    querysql=sql+ " and (convert(datetime,lastoperatedate)-convert(datetime,createdate))>5 group by workflowid";
}

RecordSet.executeSql(querysql);
while(RecordSet.next()){
	String curcount=RecordSet.getString("count");
	String curworkflowid=RecordSet.getString("workflowid");
	int index=workflowids.indexOf(curworkflowid);
    	if(index!=-1)	arraycount4.add(index,curcount);
}
if((RecordSet.getDBType()).equals("oracle")) {
    sql="select max(to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD')) maxtime,t1.workflowid"+ 
        " from workflow_requestbase t1,workflow_base t2 where t1.workflowid =t2.id and t2.workflowtype="+workflowtype+
        " and deleted=0";
}
else {
    sql="select max(convert(int,(convert(datetime,lastoperatedate)-convert(datetime,createdate)))) maxtime,t1.workflowid"+ 
        " from workflow_requestbase t1,workflow_base t2 where t1.workflowid =t2.id and t2.workflowtype="+workflowtype+
        " and deleted=0";
}

if(state.equals("1"))	sql+=" and currentnodetype='3'";
if(state.equals("2"))	sql+=" and currentnodetype<>'3'";
if(!startdate1.equals(""))	sql+=" and createdate>='"+startdate1+"'";
if(!startdate2.equals(""))	sql+=" and createdate<='"+startdate2+"'";
sql+=" group by workflowid";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String curmaxtime=RecordSet.getString("maxtime");
	String curworkflowid=RecordSet.getString("workflowid");
	int index=workflowids.indexOf(curworkflowid);
    	if(index!=-1)	arraycount5.add(index,curmaxtime);
}
if((RecordSet.getDBType()).equals("oracle")) {
    sql="select sum(to_date(lastoperatedate,'YYYY-MM-DD')-to_date(createdate,'YYYY-MM-DD'))/count(*)  pjtime,t1.workflowid"+ 
        " from workflow_requestbase t1,workflow_base t2 where t1.workflowid =t2.id and t2.workflowtype="+workflowtype+
        " and deleted=0";
}
else {
    sql="select sum(convert(float,(convert(datetime,lastoperatedate)-convert(datetime,createdate))))/convert(float,count(*)) pjtime,t1.workflowid"+ 
        " from workflow_requestbase t1,workflow_base t2 where t1.workflowid =t2.id and t2.workflowtype="+workflowtype+
        " and deleted=0";
}


if(state.equals("1"))	sql+=" and currentnodetype='3'";
if(state.equals("2"))	sql+=" and currentnodetype<>'3'";
if(!startdate1.equals(""))	sql+=" and createdate>='"+startdate1+"'";
if(!startdate2.equals(""))	sql+=" and createdate<='"+startdate2+"'";
sql+=" group by workflowid";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String curpjtime=RecordSet.getString("pjtime");
	String curworkflowid=RecordSet.getString("workflowid");
	int index=workflowids.indexOf(curworkflowid);
    	if(index!=-1)	arraycount6.add(index,curpjtime);
}

%>
<table class=liststyle cellspacing=1  >
   <colgroup>
   <col width="30%">
   <col width="10%">
   <col width="10%">
   <col width="10%">
   <col width="10%">
   <col width="10%">
   <col width="10%">
   <col width="10%">
   <tr class="header"><th colspan=8><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></tr>
   <TR ><TD colspan=8 class=line></TD></TR>
   <tr class=header>
   	<td><%=SystemEnv.getHtmlLabelName(15522,user.getLanguage())%></td>
   	<td><=1</td>
   	<td>>1,<=3</td>
   	<td>>3,<=5</td>
   	<td>>5</td>
   	<td><%=SystemEnv.getHtmlLabelName(15523,user.getLanguage())%></td>
   	<td><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%></td>
   	<td><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td>
   </tr>
   <tr class="line"><th colspan=8></th></tr>
<%
boolean islight=true;
for(int i=0;i<workflowids.size();i++){
	String workflowid=(String)workflowids.get(i);
	String curcount1=(String)arraycount1.get(i);
	String curcount2=(String)arraycount2.get(i);
	String curcount3=(String)arraycount3.get(i);
	String curcount4=(String)arraycount4.get(i);
	String curcount5=(String)arraycount5.get(i);
	String curcount6=(String)arraycount6.get(i);
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
	int allcount=Util.getIntValue(curcount1,0)+Util.getIntValue(curcount2,0)+Util.getIntValue(curcount3,0)+Util.getIntValue(curcount4,0);
	arrayall.add(allcount+"");
%>
<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	<td><%=workflowname%></td>
	<td align=right><%if(!curcount1.equals("0")){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=workflowid%>&subday2=1&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=curcount1%><%if(!curcount1.equals("0")){%></a><%}%></td>
	<td align=right><%if(!curcount2.equals("0")){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=workflowid%>&subday1=1&subday2=3&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=curcount2%><%if(!curcount2.equals("0")){%></a><%}%></td>
	<td align=right><%if(!curcount3.equals("0")){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=workflowid%>&subday1=3&subday2=5&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=curcount3%><%if(!curcount3.equals("0")){%></a><%}%></td>
	<td align=right><%if(!curcount4.equals("0")){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=workflowid%>&subday1=5&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=curcount4%><%if(!curcount4.equals("0")){%></a><%}%></td>
	<td align=right><%if(!curcount5.equals("0")){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=workflowid%>&maxday=<%=curcount5%>&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=curcount5%><%if(!curcount5.equals("0")){%></a><%}%></td>
	<td align=right><%=curcount6%></td>
	<td align=right><%if(allcount!=0){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=workflowid%>&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=allcount%><%if(allcount!=0){%></a><%}%></td>
</tr>
<%
	islight=!islight;
}
int totalcount1=0;
int totalcount2=0;
int totalcount3=0;
int totalcount4=0;
int maxcount=0;
int totalallcount=0;
int totaldays=0;
float avidays=0;
String wfidstr="";
for(int i=0;i<workflowids.size();i++){
	totalcount1+=Util.getIntValue((String)arraycount1.get(i),0);
	totalcount2+=Util.getIntValue((String)arraycount2.get(i),0);
	totalcount3+=Util.getIntValue((String)arraycount3.get(i),0);
	totalcount4+=Util.getIntValue((String)arraycount4.get(i),0);
	if(Util.getIntValue((String)arraycount5.get(i),0)>maxcount)	
		maxcount=Util.getIntValue((String)arraycount5.get(i),0);
	totalallcount+=Util.getIntValue((String)arrayall.get(i),0);
	totaldays+=Util.getIntValue((String)arrayall.get(i),0)*Util.getFloatValue((String)arraycount6.get(i),0);
	wfidstr+=(String)workflowids.get(i)+",";
}
if(totaldays!=0){
	avidays=(float)totalallcount/totaldays;
	avidays=(float)((int)(avidays*100))/(float)100;
}
wfidstr=wfidstr.substring(0,wfidstr.length()-1);
%>
<tr class=total>
	<td><%=SystemEnv.getHtmlLabelName(523, user.getLanguage())%></td>
	<td align=right><%if(totalcount1!=0){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=wfidstr%>&subday2=1&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=totalcount1%><%if(totalcount1!=0){%></a><%}%></td>
	<td align=right><%if(totalcount2!=0){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=wfidstr%>&subday1=1&subday2=3&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=totalcount2%><%if(totalcount2!=0){%></a><%}%></td>
	<td align=right><%if(totalcount3!=0){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=wfidstr%>&subday1=3&subday2=5&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=totalcount3%><%if(totalcount3!=0){%></a><%}%></td>
	<td align=right><%if(totalcount4!=0){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=wfidstr%>&subday1=5&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=totalcount4%><%if(totalcount4!=0){%></a><%}%></td>
	<td align=right><%if(maxcount!=0){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=wfidstr%>&maxday=<%=maxcount%>&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=maxcount%><%if(maxcount!=0){%></a><%}%></td>
	<td align=right><%=avidays%></td>
	<td align=right><%if(totalallcount!=0){%>
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=wfidstr%>&state=<%=state%>&fromdate=<%=startdate1%>&todate=<%=startdate2%>"><%}%>
	<%=totalallcount%><%if(totalallcount!=0){%></a><%}%></td>
</tr>
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


</form>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>