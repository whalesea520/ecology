<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16093,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

char flag=2;
String countryid=user.getCountryid();

String resourceid=Util.null2String(request.getParameter("resourceid"));
String basictype=Util.fromScreen(request.getParameter("basictype"),user.getLanguage());
String detailtype=Util.fromScreen(request.getParameter("detailtype"),user.getLanguage());

String dept_id=Util.null2String(request.getParameter("dept_id"));
if(!resourceid.equals(""+user.getUID()) && !ResourceComInfo.getManagerID(resourceid).equals(""+user.getUID()) && !HrmUserVarify.checkUserRight("HrmResource:Plan",user,ResourceComInfo.getDepartmentID(resourceid)) && (user.getSeclevel()).compareTo(ResourceComInfo.getSeclevel(resourceid))<0 ) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int bywhat = Util.getIntValue(request.getParameter("bywhat"),3);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));

Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
}

	
int currentyear=today.get(Calendar.YEAR);
int thisyear=currentyear;
int currentmonth=today.get(Calendar.MONTH);  
int currentday=today.get(Calendar.DATE);  

switch(bywhat) {
	case 1:
		today.set(currentyear,0,1) ;
		if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
		break ;
	case 2:
		today.set(currentyear,currentmonth,1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH,1) ;
		if(movedate.equals("-1")) today.add(Calendar.MONTH,-1) ;
		break ;
	case 3:
		Date thedate = today.getTime() ;
		int diffdate = (-1)*thedate.getDay() ;
		today.add(Calendar.DATE,diffdate) ;
		if(movedate.equals("1")) today.add(Calendar.WEEK_OF_YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.WEEK_OF_YEAR,-1) ;
		today.add(Calendar.DATE,1);
		break;
	case 4:
		if(movedate.equals("1")) today.add(Calendar.DATE,1) ;
		if(movedate.equals("-1")) today.add(Calendar.DATE,-1) ;
		break;
}

	
currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  

currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
temptoday1.set(currentyear,currentmonth-1,currentday) ;
temptoday2.set(currentyear,currentmonth-1,currentday) ;
switch (bywhat) {
	case 1 :
		today.add(Calendar.YEAR,1) ;
		break ;
	case 2:
		today.add(Calendar.MONTH,1) ;
		break ;
	case 3:
		today.add(Calendar.WEEK_OF_YEAR,1) ;
		break;
	case 4:
		today.add(Calendar.DATE,1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  

String currenttodate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
	
String datefrom = "" ;
String dateto = "" ;
String datenow = "" ;

switch (bywhat) {
	case 1 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		temptoday1.add(Calendar.YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4) ;

		temptoday2.add(Calendar.YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4) ;
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		temptoday1.add(Calendar.MONTH,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2) ;
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.WEEK_OF_YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;

		temptoday2.add(Calendar.WEEK_OF_YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		
		Calendar datetos = Calendar.getInstance();
		temptoday2.add(Calendar.DATE,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
}

//得到所有公共假日
ArrayList PubHolidays = new ArrayList();
RecordSet.executeProc("HrmPubHoliday_SelectByYear",thisyear+""+flag+countryid);
while(RecordSet.next()){
	PubHolidays.add(RecordSet.getString("holidaydate"));
}

ArrayList types = new ArrayList();
ArrayList requestids = new ArrayList();
ArrayList begindates = new ArrayList() ;
ArrayList begintimes = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
ArrayList endtimes = new ArrayList() ;
ArrayList delaydates = new ArrayList() ;
ArrayList names = new ArrayList() ;

String querystr = "" ;

if((RecordSet.getDBType()).equals("oracle")) {
    querystr = "select id,basictype,requestid,begindate,begintime,enddate,endtime,name,delaydate," +                " status from Bill_HrmTime " +
				" where (concat(concat(',',TO_CHAR(accepterid)),',')) like '%"+(","+resourceid+",")+"%'"+   
				" and ((begindate < '"+currenttodate+"' and begindate >= '"+currentdate+"') or "+
				" (enddate < '"+currenttodate+"' and enddate >= '"+currentdate+"') or "+
				" (enddate >= '"+currenttodate+"' and begindate < '"+currentdate+"'))"+
				" and (enddate >= '"+nowdate+"') and status='0'";
}
else {
    querystr = "select id,basictype,requestid,begindate,begintime,enddate,endtime,name,delaydate," +                " status from Bill_HrmTime " +
				" where (','+CONVERT(varchar(2000), accepterid)+',') like '%"+(","+resourceid+",")+"%'"+   
				" and ((begindate < '"+currenttodate+"' and begindate >= '"+currentdate+"') or "+
				" (enddate < '"+currenttodate+"' and enddate >= '"+currentdate+"') or "+
				" (enddate >= '"+currenttodate+"' and begindate < '"+currentdate+"'))"+
				" and (enddate >= '"+nowdate+"') and status='0'";
}

if(basictype.equals("")){
    querystr+=" and basictype in (1,3,5)";
}else{
    querystr+=" and basictype ="+basictype;
}
querystr+=" order by begindate,begintime";
RecordSet.executeSql(querystr);
while(RecordSet.next()) {
    types.add(RecordSet.getString("basictype"));
    requestids.add(RecordSet.getString("requestid")) ;
    begindates.add(RecordSet.getString("begindate")) ;
    begintimes.add(RecordSet.getString("begintime")) ;
    enddates.add(RecordSet.getString("enddate")) ;
    endtimes.add(RecordSet.getString("endtime")) ;
    delaydates.add(RecordSet.getString("delaydate")) ;
    names.add(Util.toScreen(RecordSet.getString("name"),user.getLanguage())) ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16096,user.getLanguage())+",javascript:ShowYear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(16097,user.getLanguage())+",javascript:ShowMONTH(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16098,user.getLanguage())+",javascript:ShowWeek(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16099,user.getLanguage())+",javascript:ShowDay(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;	
RCMenu += "{"+SystemEnv.getHtmlLabelName(15090,user.getLanguage())+",/workflow/request/AddRequest.jsp?workflowid="+2+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<FORM id=frmmain name=frmmain method=post action="HrmResourcePlan.jsp">
<input class=inputstyle type=hidden name=currentdate value="<%=currentdate%>">
<input class=inputstyle type=hidden name=bywhat value="<%=bywhat%>">
<input class=inputstyle type=hidden name=movedate value="">
<input class=inputstyle type=hidden name=relatewfid value="<%=relatewfid%>">
    
  <TABLE class=ViewForm>
    <col width=15%> <col width=35%>
    <col width=15%> <col width=35%>
    <TR class=Title> 
      <TH colspan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colspan=4></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class="field"><BUTTON class=Browser id=SelecResourceid onClick="onShowResourceID()"></BUTTON> 
        <span id=resourceidspan> <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A></span> 
        <INPUT class=inputStyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></td>
      <td class="field">
        <select class=inputstyle size=1 style="width:60%" name=basictype onchange="frmmain.submit()">
            <option value="" <%if(basictype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
            <option value=5 <%if(basictype.equals("5")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1038,user.getLanguage())%></option>
            <option value=3 <%if(basictype.equals("3")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(15090,user.getLanguage())%></option>
            <option value=1 <%if(basictype.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(16095,user.getLanguage())%></option>
        </select>
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
  </table>
  <br>
  <div> 
<button title=<%=datefrom%> onclick="getSubdate();" name=But1>&lt;</button>
<BUTTON class=Calendar type="button" id=selectbirthday onclick="getSubTheDate()"></BUTTON> 
<%=datenow%><button title=<%=dateto%> onclick="getSupdate();"  name=But2>&gt;</button>
<style type=text/css>.TH {
	CURSOR: auto; BACKGROUND-COLOR: beige
}
.PARENT {
	CURSOR: auto
}
.TH1 {
	CURSOR: auto; HEIGHT: 25px; BACKGROUND-COLOR: beige
}
.TODAY {
	CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.T_HOUR {
	BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.TI TD {
	BORDER-TOP: 0px; FONT-SIZE: 1px; LEFT: -1px; BORDER-LEFT: 0px; CURSOR: auto; POSITION: relative; TOP: -1px
}
.CU {
	
}
.SD {
	CURSOR: auto; COLOR: white; BACKGROUND-COLOR: mediumblue
}
.L {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.LI {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.L1 {
	BORDER-TOP: white 1px solid; BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.MI TD {
	BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid
}
.WE {
	BORDER-LEFT-WIDTH: 0px
}
.PI TD {
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}
</style>
  </div>
  <br>
<% if(bywhat==1) {%> 
  <table class=MI id=AbsenceCard 
style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(16096,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
    <tr  bgcolor=lightblue>
        <td width=28%><%=SystemEnv.getHtmlLabelName(16096,user.getLanguage())%></td>
<%
    for(int i=1;i<13;i++){
%>      <td width=6% align=center><%=i%></td>
<%  }%>
    </tr>
    <TR class=Line><TD colspan="13" ></TD></TR> 
<%
    for(int i=0;i<requestids.size();i++){
        String tmptype=(String) types.get(i);
        String tmprequestid=(String) requestids.get(i);
        String tmpbegindate=(String) begindates.get(i);
        String tmpbegintime=(String) begintimes.get(i);
        String tmpenddate=(String) enddates.get(i);
        String tmpendtime=(String) endtimes.get(i);
        String tmpdelaydate=(String) delaydates.get(i);
        String tmpname=(String) names.get(i);
        
        if(tmptype.equals("3")){
            RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid="+tmprequestid+" and currentnodetype<>'0'");
            if(!RecordSet.next())  continue;
        }
        
        if(!tmpdelaydate.equals(""))    tmpenddate=tmpdelaydate ;
        int tmpbeginmonth=Util.getIntValue(tmpbegindate.substring(5,7),0);
        int tmpendmonth=Util.getIntValue(tmpenddate.substring(5,7),0);
        String link="";
        if(tmptype.equals("1")) link="/proj/data/ViewProject.jsp?ProjID=";
        if(tmptype.equals("3")) link="/workflow/request/ViewRequest.jsp?requestid=";
        if(tmptype.equals("5")) link="/meeting/data/ViewMeeting.jsp?meetingid=";
%>
    <tr>
        <td width=28%><a href="<%=link%><%=tmprequestid%>"><%=Util.toScreen(tmpname,user.getLanguage())%></a></td>
<%
        for(int j=1;j<13;j++){
            String bgcolor="";
            if(tmpbeginmonth<=j && tmpendmonth>=j){
                if(tmptype.equals("1"))  bgcolor="red";
                if(tmptype.equals("3"))  bgcolor="green";
                if(tmptype.equals("5"))  bgcolor="yellow";
            }
%>       <td width="6%" bgcolor="<%=bgcolor%>">&nbsp;</td>
<%  
        }
%>  </tr>
    <TR class=Line><TD colspan="13" ></TD></TR> 
<%  }%>
	</table>
	</td></tr>
</table>
<%}%>

<% if(bywhat==2) {%> 
  <table class=MI id=AbsenceCard 
style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(16097,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
    <tr  bgcolor=lightblue>
        <td width=38%><%=SystemEnv.getHtmlLabelName(16097,user.getLanguage())%></td>
<%
    for(int i=1;i<32;i++){
%>      <td width=2% align=center><%=i%></td>
<%  }%>
    </tr>
    <TR class=Line><TD colspan="32" ></TD></TR> 
<%
    for(int i=0;i<requestids.size();i++){
        String tmptype=(String) types.get(i);
        String tmprequestid=(String) requestids.get(i);
        String tmpbegindate=(String) begindates.get(i);
        String tmpbegintime=(String) begintimes.get(i);
        String tmpenddate=(String) enddates.get(i);
        String tmpendtime=(String) endtimes.get(i);
        String tmpdelaydate=(String) delaydates.get(i);
        String tmpname=(String) names.get(i);
        
        if(tmptype.equals("3")){
            RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid="+tmprequestid+" and currentnodetype<>'0'");
            if(!RecordSet.next())  continue;
        }
        
        if(!tmpdelaydate.equals(""))    tmpenddate=tmpdelaydate ;
        
        String link="";
        if(tmptype.equals("1")) link="/proj/data/ViewProject.jsp?ProjID=";
        if(tmptype.equals("3")) link="/workflow/request/ViewRequest.jsp?requestid=";
        if(tmptype.equals("5")) link="/meeting/data/ViewMeeting.jsp?meetingid=";
%>
    <tr>
        <td width=28%><a href="<%=link%><%=tmprequestid%>"><%=Util.toScreen(tmpname,user.getLanguage())%></a></td>
<%
        for(int j=1;j<32;j++){
            String bgcolor="";
            int startyear=Util.getIntValue(currentdate.substring(0,4));
            int startmonth=Util.getIntValue(currentdate.substring(5,7));
            int startday=Util.getIntValue(currentdate.substring(8,10));
            
            int tmpday=startday+j-1;
            String tmpdate=Util.add0(startyear,4)+"-"+Util.add0(startmonth,2)+"-"+Util.add0(tmpday,2) ;
            if(tmpdate.compareTo(tmpbegindate)>=0&&tmpdate.compareTo(tmpenddate)<=0){
                if(tmptype.equals("1"))  bgcolor="red";
                if(tmptype.equals("3"))  bgcolor="green";
                if(tmptype.equals("5"))  bgcolor="yellow";
            }
%>       <td width="2%" bgcolor="<%=bgcolor%>">&nbsp;</td>
<%  
        }
%>  </tr>
<%  }%>
	</table>
	</td></tr>
</table>
<%}%>

<% if(bywhat==3) {%> 
  <table class=MI id=AbsenceCard 
style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(16098,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
    <tr  bgcolor=lightblue>
        <td width=30%><%=SystemEnv.getHtmlLabelName(16098,user.getLanguage())%></td>
        <td width=10% align=center><%=SystemEnv.getHtmlLabelName(16100,user.getLanguage())%></td>
        <td width=10% align=center><%=SystemEnv.getHtmlLabelName(16101,user.getLanguage())%></td>
        <td width=10% align=center><%=SystemEnv.getHtmlLabelName(16102,user.getLanguage())%></td>
        <td width=10% align=center><%=SystemEnv.getHtmlLabelName(16103,user.getLanguage())%></td>
        <td width=10% align=center><%=SystemEnv.getHtmlLabelName(16104,user.getLanguage())%></td>
        <td width=10% align=center><%=SystemEnv.getHtmlLabelName(16105,user.getLanguage())%></td>
        <td width=10% align=center><%=SystemEnv.getHtmlLabelName(16106,user.getLanguage())%></td>
    </tr>
        <TR class=Line><TD colspan="8" ></TD></TR> 

<%
    for(int i=0;i<requestids.size();i++){
        String tmptype=(String) types.get(i);
        String tmprequestid=(String) requestids.get(i);
        String tmpbegindate=(String) begindates.get(i);
        String tmpbegintime=(String) begintimes.get(i);
        String tmpenddate=(String) enddates.get(i);
        String tmpendtime=(String) endtimes.get(i);
        String tmpdelaydate=(String) delaydates.get(i);
        String tmpname=(String) names.get(i);
        
        if(tmptype.equals("3")){
            RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid="+tmprequestid+" and currentnodetype<>'0'");
            if(!RecordSet.next())  continue;
        }
        
        if(!tmpdelaydate.equals(""))    tmpenddate=tmpdelaydate ;
        
        String link="";
        if(tmptype.equals("1")) link="/proj/data/ViewProject.jsp?ProjID=";
        if(tmptype.equals("3")) link="/workflow/request/ViewRequest.jsp?requestid=";
        if(tmptype.equals("5")) link="/meeting/data/ViewMeeting.jsp?meetingid=";
%>
    <tr>
        <td width=28%><a href="<%=link%><%=tmprequestid%>"><%=Util.toScreen(tmpname,user.getLanguage())%></a></td>
<%
        for(int j=0;j<7;j++){
            String bgcolor="";
            int startyear=Util.getIntValue(currentdate.substring(0,4));
            int startmonth=Util.getIntValue(currentdate.substring(5,7));
            int startday=Util.getIntValue(currentdate.substring(8,10));
            int tmpday=startday+j;
            String tmpdate=Util.add0(startyear,4)+"-"+Util.add0(startmonth,2)+"-"+Util.add0(tmpday,2) ;

            if(tmpdate.compareTo(tmpbegindate)>=0&&tmpdate.compareTo(tmpenddate)<=0){
                if(tmptype.equals("1"))  bgcolor="red";
                if(tmptype.equals("3"))  bgcolor="green";
                if(tmptype.equals("5"))  bgcolor="yellow";
            }
%>       <td width="10%" bgcolor="<%=bgcolor%>">&nbsp;</td>
        <TR class=Line><TD colspan="8" ></TD></TR> 

<%  
        }
%>  </tr>
<%  }%>
	</table>
	</td></tr>
</table>
<%}%>

<% if(bywhat==4) {%> 
  <table class=MI id=AbsenceCard 
style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(16099,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
    <tr  bgcolor=lightblue>
        <td width=28%><%=SystemEnv.getHtmlLabelName(16099,user.getLanguage())%></td>
<%
    for(int i=0;i<24;i++){
%>      <td width=3% align=center><%=i%></td>
<%  }%>
    </tr>
    <TR class=Line><TD colspan="24" ></TD></TR> 
<%
    for(int i=0;i<requestids.size();i++){
        String tmptype=(String) types.get(i);
        String tmprequestid=(String) requestids.get(i);
        String tmpbegindate=(String) begindates.get(i);
        String tmpbegintime=(String) begintimes.get(i);
        String tmpenddate=(String) enddates.get(i);
        String tmpendtime=(String) endtimes.get(i);
        String tmpdelaydate=(String) delaydates.get(i);
        String tmpname=(String) names.get(i);
        
        if(tmptype.equals("3")){
            RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid="+tmprequestid+" and currentnodetype<>'0'");
            if(!RecordSet.next())  continue;
        }
        
        if(!tmpdelaydate.equals(""))    tmpenddate=tmpdelaydate ;
        
        String link="";
        if(tmptype.equals("1")) link="/proj/data/ViewProject.jsp?ProjID=";
        if(tmptype.equals("3")) link="/workflow/request/ViewRequest.jsp?requestid=";
        if(tmptype.equals("5")) link="/meeting/data/ViewMeeting.jsp?meetingid=";
%>
    <tr>
        <td width=28%><a href="<%=link%><%=tmprequestid%>"><%=Util.toScreen(tmpname,user.getLanguage())%></a></td>
<%
        if(tmpbegintime.equals(""))  tmpbegintime="09:00";
        if(tmpendtime.equals(""))  tmpendtime="18:00";
        int tmpbeginhour=Util.getIntValue(tmpbegintime.substring(0,2));
        int tmpendhour=Util.getIntValue(tmpendtime.substring(0,2));
        for(int j=0;j<24;j++){
            String bgcolor="";
            if(currentdate.equals(tmpbegindate)&&currentdate.equals(tmpenddate)){
                if(tmpbeginhour<=j&&tmpendhour>=j){
                    if(tmptype.equals("1"))  bgcolor="red";
                    if(tmptype.equals("3"))  bgcolor="green";
                    if(tmptype.equals("5"))  bgcolor="yellow";
                }
            }
            if(currentdate.equals(tmpbegindate)&&currentdate.compareTo(tmpenddate)<0){
                if(tmpbeginhour<=j&&j<=18){
                    if(tmptype.equals("1"))  bgcolor="red";
                    if(tmptype.equals("3"))  bgcolor="green";
                    if(tmptype.equals("5"))  bgcolor="yellow";
                }
            }
            if(currentdate.equals(tmpenddate)&&currentdate.compareTo(tmpbegindate)>0){
                if(tmpendhour>=j&&j>=9){
                    if(tmptype.equals("1"))  bgcolor="red";
                    if(tmptype.equals("3"))  bgcolor="green";
                    if(tmptype.equals("5"))  bgcolor="yellow";
                }
            }
            if(currentdate.compareTo(tmpbegindate)>0&&currentdate.compareTo(tmpenddate)<0){
                if(9<=j&&18>=j){
                    if(tmptype.equals("1"))  bgcolor="red";
                    if(tmptype.equals("3"))  bgcolor="green";
                    if(tmptype.equals("5"))  bgcolor="yellow";
                }
            }
%>       <td width="3%" bgcolor="<%=bgcolor%>">&nbsp;</td>
<%  
        }
%>  </tr>
<%  }%>
	</table>
	</td></tr>
</table>
<%}%>
  <br>
</form>
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
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	frmmain.resourceid.value=id(0)
	document.frmmain.submit()
	end if
	end if
end sub
</script>

<script language=javascript>

function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	document.frmmain.submit() ;
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	document.frmmain.submit() ;
}
function ShowYear() {
	document.frmmain.bywhat.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowMONTH() {
	document.frmmain.bywhat.value = "2" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowWeek() {
	document.frmmain.bywhat.value = "3" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowDay() {
	document.frmmain.bywhat.value = "4" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
