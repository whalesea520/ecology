<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String assetid =Util.null2String(request.getParameter("relatedid"));
int bywhat = Util.getIntValue(request.getParameter("bywhat"),1);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));

Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();

if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
}

	
int currentyear=today.get(Calendar.YEAR);
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

/* if(!resourceid.equals(""+user.getUID()) && !ResourceComInfo.getManagerID(resourceid).equals(""+user.getUID()) && !HrmUserVarify.checkUserRight("HrmResource:Plan",user,ResourceComInfo.getDepartmentID(resourceid))) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
} */

ArrayList ids = new ArrayList() ;
ArrayList assetids = new ArrayList() ;
ArrayList resourceids = new ArrayList() ;
ArrayList startdates = new ArrayList() ;
ArrayList starttimes = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
ArrayList endtimes = new ArrayList() ;
ArrayList subjects = new ArrayList() ;
ArrayList usestatus = new ArrayList() ;
ArrayList status = new ArrayList() ;

String querystr = "";
if(relatewfid.equals("1")) 
	querystr = "select a.requestid as id,c.requestname as subject, c.status as status , b.itemid as assetid,b.resourceid as resourceid,b.begindate as startdate,b.begintime as starttime,"+
				"b.enddate , b.endtime ,b.usestatus from workflow_form a, bill_itemusage b ,workflow_requestbase c  "+
				"where a.billformid='1' and a.billid=b.id and a.requestid = c.requestid and b.itemid = "+assetid+
				" and ((b.begindate < '"+currenttodate+"' and b.begindate >= '"+currentdate+"') or "+
				" (b.enddate < '"+currenttodate+"' and b.enddate >= '"+currentdate+"') or (b.enddate >= '"+currenttodate+"' and b.begindate < '"+currentdate+"')) and ( b.usestatus != '2' or b.usestatus is null)  "+
				" order by b.begindate ,b.begintime" ;

if(relatewfid.equals("2")) 
	querystr = "select a.requestid as id,c.requestname as subject, c.status as status , b.meetroomid as assetid,b.applicant as resourceid,b.startdate as startdate,b.starttime as starttime,"+
				"b.enddate , b.endtime ,b.usestatus from workflow_form a, Bill_Meetingroom b ,workflow_requestbase c  "+
				"where a.billformid='5' and a.billid=b.id and a.requestid = c.requestid and b.meetroomid = "+assetid+
				" and ((b.startdate < '"+currenttodate+"' and b.startdate >= '"+currentdate+"') or "+
				" (b.enddate < '"+currenttodate+"' and b.enddate >= '"+currentdate+"') or (b.enddate >= '"+currenttodate+"' and b.startdate < '"+currentdate+"')) and ( b.usestatus != '2' or b.usestatus is null)  "+
				" order by b.startdate,b.starttime " ;


RecordSet.executeSql(querystr);
while(RecordSet.next()) {
ids.add(Util.null2String(RecordSet.getString("id"))) ;
assetids.add(Util.null2String(RecordSet.getString("assetid"))) ;
resourceids.add(Util.null2String(RecordSet.getString("resourceid"))) ;
startdates.add(Util.null2String(RecordSet.getString("startdate"))) ;
starttimes.add(Util.null2String(RecordSet.getString("starttime"))) ;
enddates.add(Util.null2String(RecordSet.getString("enddate"))) ;
endtimes.add(Util.null2String(RecordSet.getString("endtime"))) ;
subjects.add(Util.toScreen(RecordSet.getString("subject"),user.getLanguage())) ;
usestatus.add(Util.null2String(RecordSet.getString("usestatus"))) ;
status.add(Util.toScreen(RecordSet.getString("status"),user.getLanguage())) ;
}  
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<FORM id=frmmain name=frmmain method=post action="LgcAssetUse.jsp">
  <div> <BUTTON class=btnRefresh accessKey=R type="submit"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
    <BUTTON class=btnNew accessKey=N onclick="location='/workflow/request/RequestType.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON> </div> 
    
	<input type=hidden name=currentdate value="<%=currentdate%>">
    <input type=hidden name=bywhat value="<%=bywhat%>">
	<input type=hidden name=movedate value="">
	<input type=hidden name=relatewfid value="<%=relatewfid%>">
	
    
  <TABLE class=ViewForm>
    <col width=10%> <col width=90%>  
    <TR class=Title> 
      <TH colspan=2><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR Class=separtator> 
      <TD class=Line1 colspan=2></TD>
    </TR>
    <tr> 
      <td>资产</td>
      <td class="field"><button class=Browser onClick="onShowItemID(relatedid,assetidspan)"></button> 
        <span id=assetidspan> <A href='/lgc/asset/LgcAsset.jsp?paraid=<%=assetid%>'><%=Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage())%></a> 
        </span> 
        <input type=hidden id=relatedid name=relatedid value="<%=assetid%>">
      </td>
      
    </TR><tr><td class=Line colspan=2></td></tr>
  </table>

  <br>
  <div> 
<button title=<%=datefrom%> onclick="getSubdate();" 
name=But1>&lt;</button><BUTTON class=Calendar id=selectbirthday onclick="getSubTheDate()"></BUTTON> 
<%=datenow%><button title=<%=dateto%> onclick="getSupdate();"  
name=But2>&gt;</button><button class=Btn id=btnYear accesskey=6 onClick=ShowYear() 
name=btnYear><u>6</u>-年</button><button class=Btn id=btnMONTH accesskey=7 
onClick=ShowMONTH() name=btnMONTH><u>7</u>-月份</button><button class=Btn id=btnWeek 
accesskey=8 onClick=ShowWeek() name=btnWeek><u>8</u>-周</button><button class=Btn 
id=btnDay accesskey=9 onClick=ShowDay() name=btnDay><u>9</u>-日</button>

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
      <TH align="left">图示</TH>
	</TR>	
	<TR Class=separtator>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  <%
	  int i=0;
	  int j=0;
	  for(i=0;i<32;i++){
	  	%>
	  	<td height=20px ALIGN=CENTER><%if(i>0){%><%=i%><%} else {%>&nbsp<%}%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr>
	<%

	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;
	ArrayList tempids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	ArrayList tempusestatus = new ArrayList() ;
	ArrayList tempstatus = new ArrayList() ;
	int canlink = 0 ;
	for(j=1;j<13;j++){
		for(i=0;i<32;i++){
		canlink=0 ;
		bgcolor="white";
		tempids.clear() ;
		tempusestatus.clear() ;
		tempstartdates.clear() ;
		tempenddates.clear() ;
		tempstarttimes.clear() ;
		tempendtimes.clear() ;
		tempsubjects.clear() ;
		tempstatus.clear() ;
		
			if(i==0){
			    bgcolor="white";
			    canlink=0;
			    if(j==1) innertext="Jan";
			    if(j==2) innertext="Feb";
			    if(j==3) innertext="Mac";
			    if(j==4) innertext="Apr";
			    if(j==5) innertext="May";
			    if(j==6) innertext="Jun";
			    if(j==7) innertext="Jul";
			    if(j==8) innertext="Aug";
			    if(j==9) innertext="Sep";
			    if(j==10) innertext="Oct";
			    if(j==11) innertext="Nov";
			    if(j==12) innertext="Dec";
			}
			else  {
				innertext="&nbsp;";
				tempday.clear();
				tempday.set(Util.getIntValue(currentdate.substring(0,4)),j-1,i);
				if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)&&i>0) {bgcolor="lightblue";}
				if((tempday.getTime().getMonth()!=(j-1))&&i>0) { bgcolor="darkblue";canlink=1;}
				if(!bgcolor.equals("darkblue")){
					thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
									Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
									Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
				
					for(int k=0 ; k<ids.size() ; k++) {
						String tempdatefrom = (String)startdates.get(k) ;
						String tempdateto = (String)enddates.get(k) ;
						if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
						tempids.add((String)ids.get(k)) ;
						tempusestatus.add((String)usestatus.get(k)) ;
						tempstartdates.add((String)startdates.get(k)) ;
						tempenddates.add((String)enddates.get(k)) ;
						tempstarttimes.add((String)starttimes.get(k)) ;
						tempendtimes.add((String)endtimes.get(k)) ;
						tempsubjects.add((String)subjects.get(k)) ;
						tempstatus.add((String)status.get(k)) ;
					}
				}
			}
			if(tempids.size() > 0){%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempids.size() ; t++) {%>
			<TR>
          	<a href="/workflow/request/ViewRequest.jsp?requestid=<%=tempids.get(t)%>"><TD 
          title="起始: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;结束: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;说明: <%=tempsubjects.get(t)%>&#13;状态: <%=tempstatus.get(t)%>" 
          bgColor=<%if(((String)tempusestatus.get(t)).equals("1")) {%>#7edf20<%} else {%>#ff0000<%}%> height=12></TD></a></TR><tr><td bgColor=<%=bgcolor%> height=2></td></tr><%}%></TBODY></TABLE></TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> <% if(canlink==0) { if(i!=0) {%> title=<%=thenowday%> <%}} else {%> title="无效的日期" <%}%>><%=innertext%></TD><%}%>	
			<%
			if(i==31){%> 
			</tr><tr>
			<%}
		}
	}
	%>
	</table>
	</td></tr>
</table>
<%}%>


<% if(bywhat==2) {%> 
  <table class=MI id=AbsenceCard 
style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left">图示</TH>
	</TR>	
	<TR Class=separtator>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  	<td height=20px ALIGN=CENTER>星期日</td>
		<td height=20px ALIGN=CENTER>星期一</td>
		<td height=20px ALIGN=CENTER>星期二</td>
		<td height=20px ALIGN=CENTER>星期三</td>
		<td height=20px ALIGN=CENTER>星期四</td>
		<td height=20px ALIGN=CENTER>星期五</td>
		<td height=20px ALIGN=CENTER>星期六</td>

	</tr>
	<tr>
	<%
	int i=0;
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	tempday.set(Util.getIntValue(currentdate.substring(0,4)),Util.getIntValue(currentdate.substring(5,7))-1,Util.getIntValue(currentdate.substring(8,10))) ;
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;
	
	Date thedate = tempday.getTime() ;
	int diffdate = thedate.getDay() ;
	for(i=0 ; i<diffdate;i++) {%>
	<TD bgColor=<%=bgcolor%>>&nbsp;</TD>
	<%}

	ArrayList tempids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	ArrayList tempusestatus = new ArrayList() ;
	ArrayList tempstatus = new ArrayList() ;

	for(i=0;i<31;i++){

		bgcolor="white";
		tempids.clear() ;
		tempusestatus.clear() ;
		tempstartdates.clear() ;
		tempenddates.clear() ;
		tempstarttimes.clear() ;
		tempendtimes.clear() ;
		tempsubjects.clear() ;
		tempstatus.clear() ;
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		
		innertext = ""+tempday.get(Calendar.DAY_OF_MONTH) ;
				
		for(int k=0 ; k<ids.size() ; k++) {
			String tempdatefrom = (String)startdates.get(k) ;
			String tempdateto = (String)enddates.get(k) ;
			if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
			tempids.add((String)ids.get(k)) ;
			tempusestatus.add((String)usestatus.get(k)) ;
			tempstartdates.add((String)startdates.get(k)) ;
			tempenddates.add((String)enddates.get(k)) ;
			tempstarttimes.add((String)starttimes.get(k)) ;
			tempendtimes.add((String)endtimes.get(k)) ;
			tempsubjects.add((String)subjects.get(k)) ;
			tempstatus.add((String)status.get(k)) ;
		}
			
			if(tempids.size() > 0){%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempids.size() ; t++) {%>
			<TR>
          	<a href="/workflow/request/ViewRequest.jsp?requestid=<%=tempids.get(t)%>"><TD 
          title="起始: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;结束: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;说明: <%=tempsubjects.get(t)%>&#13;状态: <%=tempstatus.get(t)%>" 
          bgColor=<%if(((String)tempusestatus.get(t)).equals("1")) {%>#7edf20<%} else {%>#ff0000<%}%>>&nbsp;</TD></a></TR><%}%></TBODY></TABLE></TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> title=<%=thenowday%> align=center valign=middle><%=innertext%></TD><%}%>	
			<%
			thedate = tempday.getTime() ;
			diffdate = thedate.getDay() ;
			int tempmonth = tempday.getTime().getMonth() ;
			tempday.add(Calendar.DATE,1) ;
			if(tempmonth != tempday.getTime().getMonth()) {bgcolor="white"; break ;}
			if(diffdate==6){%> 
			</tr><tr>
			<%}
		}
		for(i=diffdate;i<6;i++) {%>
		<TD bgColor=<%=bgcolor%>>&nbsp;</TD>
		<%} %>
		</tr>
	</table>
	</td></tr>
</table>
<%}%>


<% if(bywhat==3) {%> 
  <table class=MI id=AbsenceCard 
style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left">图示</TH>
	</TR>	
	<TR Class=separtator>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	
	
	<%
	int i=0;
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	tempday.set(Util.getIntValue(currentdate.substring(0,4)),Util.getIntValue(currentdate.substring(5,7))-1,Util.getIntValue(currentdate.substring(8,10))) ;

	String thenowday="";
	String innertext = "" ;

	ArrayList tempids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	ArrayList tempusestatus = new ArrayList() ;
	ArrayList tempstatus = new ArrayList() ;

	for(i=0;i<7;i++){

		bgcolor="white";
		tempids.clear() ;
		tempusestatus.clear() ;
		tempstartdates.clear() ;
		tempenddates.clear() ;
		tempstarttimes.clear() ;
		tempendtimes.clear() ;
		tempsubjects.clear() ;
		tempstatus.clear() ;
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";
		
		Date thedate = tempday.getTime() ;
		int diffdate = thedate.getDay() ;

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		
		innertext = thenowday ;
				
		for(int k=0 ; k<ids.size() ; k++) {
			String tempdatefrom = (String)startdates.get(k) ;
			String tempdateto = (String)enddates.get(k) ;
			if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
			tempids.add((String)ids.get(k)) ;
			tempusestatus.add((String)usestatus.get(k)) ;
			tempstartdates.add((String)startdates.get(k)) ;
			tempenddates.add((String)enddates.get(k)) ;
			tempstarttimes.add((String)starttimes.get(k)) ;
			tempendtimes.add((String)endtimes.get(k)) ;
			tempsubjects.add((String)subjects.get(k)) ;
			tempstatus.add((String)status.get(k)) ;
		}
		%>	
		<tr>
		<td width=15% align=center valign=middle >
		<% if(diffdate == 0) {%>星期日
		<%} else if(diffdate == 1) {%>星期一
		<%} else if(diffdate == 2) {%>星期二
		<%} else if(diffdate == 3) {%>星期三
		<%} else if(diffdate == 4) {%>星期四
		<%} else if(diffdate == 5) {%>星期五
		<%} else if(diffdate == 6) {%>星期六<%}%></td>
		
		<%	if(tempids.size() > 0){%>
			<TD width=85%>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempids.size() ; t++) {%>
			<TR>
          	<a href="/workflow/request/ViewRequest.jsp?requestid=<%=tempids.get(t)%>"><TD 
          title="起始: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;结束: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;说明: <%=tempsubjects.get(t)%>&#13;状态: <%=tempstatus.get(t)%>" 
          bgColor=<%if(((String)tempusestatus.get(t)).equals("1")) {%>#7edf20<%} else {%>#ff0000<%}%>  rowspan="2">&nbsp;</TD></a>
		  <td>起始: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%></td>
		  <td>结束: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%></td>
		  </tr>
		  <tr>
		  <td>说明: <%=tempsubjects.get(t)%></td>
		  <td>状态: <%=tempstatus.get(t)%></td>
		  </TR><%}%></TBODY></TABLE></TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> title=<%=thenowday%> width=85% height=20><%=innertext%></TD><%}%>
			</tr>	
			<%
			tempday.add(Calendar.DATE,1) ;
		}
		%>
		
	</table>
	</td></tr>
</table>
<%}%>


<% if(bywhat==4) {%> 
  <table class=MI id=AbsenceCard 
style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left">图示</TH>
	</TR>	
	<TR Class=separtator>
		<TD class=Line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  <%
	  int i=0;
	  for(i=0;i<24;i++){
	  	%>
	  	<td height=20px ALIGN=CENTER><%=i%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr>
	<%
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	tempday.set(Util.getIntValue(currentdate.substring(0,4)),Util.getIntValue(currentdate.substring(5,7))-1,Util.getIntValue(currentdate.substring(8,10))) ;
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;


	ArrayList tempids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	ArrayList tempusestatus = new ArrayList() ;
	ArrayList tempstatus = new ArrayList() ;

	for(i=0;i<24;i++){

		bgcolor="white";
		tempids.clear() ;
		tempusestatus.clear() ;
		tempstartdates.clear() ;
		tempenddates.clear() ;
		tempstarttimes.clear() ;
		tempendtimes.clear() ;
		tempsubjects.clear() ;
		tempstatus.clear() ;
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		String thenowtimefrom = thenowday+" "+Util.add0(i,2)+":00" ;
		String thenowtimeto = thenowday+" "+Util.add0(i+1,2)+":00" ;
		
		innertext = thenowday+ " "+Util.add0(i,2)+":00 - "+Util.add0(i+1,2)+":00" ;
				
		for(int k=0 ; k<ids.size() ; k++) {
			String tempdatefrom = (String)startdates.get(k) ;
			String tempdateto = (String)enddates.get(k) ;
			String temptimefrom = (String)starttimes.get(k) ;
			String temptimeto = (String)endtimes.get(k) ;
			if(temptimefrom.length() <5 || temptimeto.length() <5) continue ;
			String tempallfrom = tempdatefrom + " " + temptimefrom.substring(0,5) ;
			String tempallto = tempdateto + " " +temptimeto.substring(0,5) ;
			
			if((tempallfrom.compareToIgnoreCase(thenowtimefrom) < 0 && tempallto.compareToIgnoreCase(thenowtimeto)>0) ||
			 (thenowtimefrom.compareToIgnoreCase(tempallfrom) <= 0 && thenowtimeto.compareToIgnoreCase(tempallfrom)>0) ||
			 (thenowtimefrom.compareToIgnoreCase(tempallto) < 0 && thenowtimeto.compareToIgnoreCase(tempallto)>=0)) {
				tempids.add((String)ids.get(k)) ;
				tempusestatus.add((String)usestatus.get(k)) ;
				tempstartdates.add((String)startdates.get(k)) ;
				tempenddates.add((String)enddates.get(k)) ;
				tempstarttimes.add((String)starttimes.get(k)) ;
				tempendtimes.add((String)endtimes.get(k)) ;
				tempsubjects.add((String)subjects.get(k)) ;
				tempstatus.add((String)status.get(k)) ;
			}
			
		}
			
			if(tempids.size() > 0){%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempids.size() ; t++) {%>
			<TR>
          	<a href="/workflow/request/ViewRequest.jsp?requestid=<%=tempids.get(t)%>"><TD 
          title="起始: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;结束: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;说明: <%=tempsubjects.get(t)%>&#13;状态: <%=tempstatus.get(t)%>" 
          bgColor=<%if(((String)tempusestatus.get(t)).equals("1")) {%>#7edf20<%} else {%>#ff0000<%}%>>&nbsp;</TD></a></TR><%}%></TBODY></TABLE></TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> title=<%=innertext%> align=center valign=middle>&nbsp;</TD><%} }%>	
		</tr>
	</table>
	</td></tr>
</table>
  <%}%>
  <br>
  <br>
  <table class=ListStyle cellspacing=1>
    <colgroup> <col width="30%"> <col width="15%"> <col width="20%"> <col width="20%"> <col width="25%">
    <tbody> 
    <tr class=header> 
      <th colspan=5>详细</th>
    </tr>
    <tr class=Header> 
      <td>说明</td>
      <td>申请人</td>
      <td>开始时间</td>
      <td>结束时间</td>
	  <td>当前状态</td>
    </tr>
<TR class=Line><TD colSpan=5></TD></TR>
    <%
  int i=0;
	for(int d=0 ; d< ids.size() ; d++) {
  	
  	if(i==0){
  		i=1;
  %>
    <tr class=datalight> 
      <%
  	}else{
  		i=0;
  %>
    <tr class=datadark> 
      <%  	}
  	%>
      <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=ids.get(d)%>"><%=subjects.get(d)%></a></td>
      <td><A 
href="/hrm/resource/HrmResource.jsp?id=<%=resourceids.get(d)%>"><%=Util.toScreen(ResourceComInfo.getResourcename((String)resourceids.get(d)),user.getLanguage())%></A></td>
      <td><%=startdates.get(d)%> <%=starttimes.get(d)%></td>
      <td><%=enddates.get(d)%> <%=endtimes.get(d)%></td>
	  <td><%=status.get(d)%></td>
    </tr>
    <%}%>
    </tbody>
  </table>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=vbs>
sub onShowItemID(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	inputname.value=id(0)
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
//	alert(document.frmmain.bywhat.value) ;
//	alert(document.frmmain.currentdate.value) ;
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
