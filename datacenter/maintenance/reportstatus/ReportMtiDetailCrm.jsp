<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=GBK">
</head>
<%
String thetable=Util.null2String(request.getParameter("thetable"));
String crmid =Util.null2String(request.getParameter("crmid"));
String inprepid =Util.null2String(request.getParameter("inprepid"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));


String imagefilename = "/images/hdMaintenance.gif";
String titlename = Util.toScreen("报表输入状态",user.getLanguage(),"0") + ": " + Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage()) ;
String needfav ="1";
String needhelp ="";


int bywhat = Util.getIntValue(request.getParameter("bywhat"),1);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));

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


ArrayList inputids = new ArrayList() ;
ArrayList reportdates = new ArrayList() ;
ArrayList inputstatuss = new ArrayList() ;
ArrayList dspdates=new ArrayList();

String querystr = "select distinct reportdate ,inputstatus,inprepdspdate from " + thetable + " where modtype='0' and reportdate >='" + currentdate + "' and reportdate <='" + currenttodate + "' and crmid = " + crmid + " and inputstatus<>'9' order by reportdate " ;

RecordSet.executeSql(querystr);
while(RecordSet.next()) {
    inputids.add("0") ;
    reportdates.add(Util.null2String(RecordSet.getString("reportdate"))) ;
    inputstatuss.add(Util.null2String(RecordSet.getString("inputstatus"))) ;
	dspdates.add(Util.null2String(RecordSet.getString("inprepdspdate")));
}
querystr = "select crmid from T_InputReportHrm where inprepid = " + inprepid  ;
RecordSet.executeSql(querystr);
String crmids="";
while(RecordSet.next()){
    if(crmids.equals("")) crmids=RecordSet.getString(1);
    else crmids+=","+RecordSet.getString(1);
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>



<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",ReportDetailStatus.jsp?inprepid="+inprepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(445,user.getLanguage())+",javascript:ShowYear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(887,user.getLanguage())+",javascript:ShowMONTH(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1926,user.getLanguage())+",javascript:ShowWeek(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><!--button class=Btn 
id=btnDay accesskey=9 onClick=ShowDay() name=btnDay><u>9</u>-<%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></button -->

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmmain name=frmmain method=post action="ReportMtiDetailCrm.jsp">
	<input type=hidden name=currentdate value="<%=currentdate%>">
    <input type=hidden name=bywhat value="<%=bywhat%>">
	<input type=hidden name=movedate value="">
    <input type=hidden name=thetable value="<%=thetable%>">
	<input type=hidden name=inprepid value="<%=inprepid%>">
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

 	
    
  <TABLE class=viewform>
    <col width=10%> <col width=90%>
    <TR class=title> 
      <TH colspan=2>条件</TH>
    </TR>
    <TR Class=separtator> 
      <TD class=line1 colspan=2></TD>
    </TR>
    <tr> 
      <td>CRM</td>
      <td class="field"><BUTTON class=Browser id=SelecResourceid onClick="onShowCustomer(crmidspan,crmid,'<%=crmids%>')"></BUTTON>
        <span id=crmidspan> <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></span> 
        <INPUT id=crmid type=hidden name=crmid value="<%=crmid%>">
      </td>
    </tr>
  </table>

  <br>
  <div> 
<button title=<%=datefrom%> onclick="getSubdate();" 
name=But1>&lt;</button><BUTTON class=Calendar id=selectbirthday onclick="getTheDate()"></BUTTON> 
<%=datenow%><button title=<%=dateto%> onclick="getSupdate();"  
name=But2>&gt;</button><!--button class=Btn 
id=btnDay accesskey=9 onClick=ShowDay() name=btnDay><u>9</u>-<%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></button -->

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
	<TR class=title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR Class=separtator>
		<TD class=line1></TD>
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
    
	ArrayList tempinputids = new ArrayList() ;
	ArrayList tempreportdates = new ArrayList() ;
	ArrayList tempinputstatuss = new ArrayList() ;
	ArrayList tempdspdates = new ArrayList() ;
	
	int canlink = 0 ;
	for(j=1;j<13;j++){
		for(i=0;i<32;i++){
		canlink=0 ;
		bgcolor="white";
		tempinputids.clear() ;
		tempreportdates.clear() ;
		tempinputstatuss.clear() ;
		tempdspdates.clear() ;
		
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
				
					for(int k=0 ; k<inputids.size() ; k++) {
						String tempdatereport = (String)reportdates.get(k) ;
						if(thenowday.compareToIgnoreCase(tempdatereport) != 0 ) continue ;
						tempinputids.add((String)inputids.get(k)) ;
						tempreportdates.add(tempdatereport) ;
						tempinputstatuss.add((String)inputstatuss.get(k)) ;
						tempdspdates.add((String)dspdates.get(k)) ;
					}  
				}
			}
			if(tempinputids.size() > 0){%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempinputids.size() ; t++) {
                String tempinputstatus = (String)tempinputstatuss.get(t) ;
                String tempinputdates = (String)tempreportdates.get(t) ;
				String dspdate = (String)tempdspdates.get(t) ;
            %>
			<TR>
          	<a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><TD
          <% if( tempinputstatus.equals("9") ) {%> title="已输入" bgColor=white
          <% } else if( tempinputstatus.equals("0") ) {%> title="待审核" bgColor=white
          <% } else if( tempinputstatus.equals("4") ) {%> title="已审核" bgColor=white <%}%>
           height=16>
              <% if( tempinputstatus.equals("9") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a>
              <% } else if( tempinputstatus.equals("0") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\BacoCheck.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a>
              <% } else if( tempinputstatus.equals("4") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a><%}%>
           </TD></a></TR><tr><td bgColor=<%=bgcolor%> height=2></td></tr><%}%></TBODY></TABLE></TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> <% if(canlink==0) { if(i!=0) {%> title=<%=thenowday%> <%}} else {%> title="<%=SystemEnv.getHtmlLabelName(1928,user.getLanguage())%>" <%}%>><%=innertext%></TD><%}%>	
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
	<TR class=title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR Class=separtator>
		<TD class=line1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  	<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></td>

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

	ArrayList tempinputids = new ArrayList() ;
	ArrayList tempreportdates = new ArrayList() ;
	ArrayList tempinputstatuss = new ArrayList() ;
	ArrayList tempdspdates = new ArrayList() ;

	for(i=0;i<31;i++){

		bgcolor="white";
		tempinputids.clear() ;
		tempreportdates.clear() ;
		tempinputstatuss.clear() ;
		tempdspdates.clear() ;
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		
		innertext = ""+tempday.get(Calendar.DAY_OF_MONTH) ;
				
		for(int k=0 ; k<inputids.size() ; k++) {
			String tempdatereport = (String)reportdates.get(k) ;
						
            if(thenowday.compareToIgnoreCase(tempdatereport) != 0 ) continue ;
            tempinputids.add((String)inputids.get(k)) ;
            tempreportdates.add(tempdatereport) ;
            tempinputstatuss.add((String)inputstatuss.get(k)) ;
			tempdspdates.add((String)dspdates.get(k)) ;
		}
			
			if(tempinputids.size() > 0){%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempinputids.size() ; t++) {
                String tempinputstatus = (String)tempinputstatuss.get(t) ;
                String tempinputdates = (String)tempreportdates.get(t) ;
				String dspdate = (String)tempdspdates.get(t) ;
            %>
			<TR>
          	<a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><TD
          <% if( tempinputstatus.equals("9") ) {%> title="已输入" bgColor=white
          <% } else if( tempinputstatus.equals("0") ) {%> title="待审核" bgColor=white
          <% } else if( tempinputstatus.equals("4") ) {%> title="已审核" bgColor=white <%}%>
           height=16>
              <% if( tempinputstatus.equals("9") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a>
              <% } else if( tempinputstatus.equals("0") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\BacoCheck.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a>
              <% } else if( tempinputstatus.equals("4") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a><%}%>
           </TD></a></TR><tr><td bgColor=<%=bgcolor%> height=2></td></tr><%}%></TBODY></TABLE></TD>
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
	<TR class=title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR Class=separtator>
		<TD class=line1></TD>
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

	ArrayList tempinputids = new ArrayList() ;
	ArrayList tempreportdates = new ArrayList() ;
	ArrayList tempinputstatuss = new ArrayList() ;
	ArrayList tempdspdates = new ArrayList() ;

	for(i=0;i<7;i++){

		bgcolor="white";
		tempinputids.clear() ;
		tempreportdates.clear() ;
		tempinputstatuss.clear() ;
		tempdspdates.clear() ;
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";
		
		Date thedate = tempday.getTime() ;
		int diffdate = thedate.getDay() ;

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		
		innertext = thenowday ;
				
		for(int k=0 ; k<inputids.size() ; k++) {
			String tempdatereport = (String)reportdates.get(k) ;
						
            if(thenowday.compareToIgnoreCase(tempdatereport) != 0 ) continue ;
            tempinputids.add((String)inputids.get(k)) ;
            tempreportdates.add(tempdatereport) ;
            tempinputstatuss.add((String)inputstatuss.get(k)) ;
			tempdspdates.add((String)dspdates.get(k)) ;
		}
		%>	
		<tr>
		<td width=15% align=center valign=middle >
		<% if(diffdate == 0) {%><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%>
		<%} else if(diffdate == 1) {%><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%>
		<%} else if(diffdate == 2) {%><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%>
		<%} else if(diffdate == 3) {%><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%>
		<%} else if(diffdate == 4) {%><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%>
		<%} else if(diffdate == 5) {%><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%>
		<%} else if(diffdate == 6) {%><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%><%}%></td>
		
		<%	if(tempinputids.size() > 0){%>
			<TD width=85%>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempinputids.size() ; t++) {
                String tempinputstatus = (String)tempinputstatuss.get(t) ;
                String tempinputdates = (String)tempreportdates.get(t) ;
				String dspdate = (String)tempdspdates.get(t) ;
            %>
			<TR>
          	<a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><TD
          <% if( tempinputstatus.equals("9") ) {%> title="已输入" bgColor=white
          <% } else if( tempinputstatus.equals("0") ) {%> title="待审核" bgColor=white
          <% } else if( tempinputstatus.equals("4") ) {%> title="已审核" bgColor=white <%}%>
           height=16>
              <% if( tempinputstatus.equals("9") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a>
              <% } else if( tempinputstatus.equals("0") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\BacoCheck.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a>
              <% } else if( tempinputstatus.equals("4") ) {%><a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><IMG SRC="\images\BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"></a><%}%>
           </TD></a></TR><tr><td bgColor=<%=bgcolor%> height=2></td></tr><%}%></TBODY></TABLE></TD>
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
	<TR class=title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR Class=separtator>
		<TD class=line1></TD>
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


	ArrayList tempinputids = new ArrayList() ;
	ArrayList tempreportdates = new ArrayList() ;
	ArrayList tempinputstatuss = new ArrayList() ;
	ArrayList tempdspdates = new ArrayList() ;

	for(i=0;i<24;i++){

		bgcolor="white";
		tempinputids.clear() ;
		tempreportdates.clear() ;
		tempinputstatuss.clear() ;
		tempdspdates.clear() ;
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		String thenowtimefrom = thenowday+" "+Util.add0(i,2)+":00" ;
		String thenowtimeto = thenowday+" "+Util.add0(i+1,2)+":00" ;
		
		innertext = thenowday+ " "+Util.add0(i,2)+":00 - "+Util.add0(i+1,2)+":00" ;
		
        for(int k=0 ; k<inputids.size() ; k++) {
			String tempdatereport = (String)reportdates.get(k) ;
						
            if(thenowday.compareToIgnoreCase(tempdatereport) != 0 ) continue ;
            tempinputids.add((String)inputids.get(k)) ;
            tempreportdates.add(tempdatereport) ;
            tempinputstatuss.add((String)inputstatuss.get(k)) ;
			tempdspdates.add((String)dspdates.get(k)) ;
		}

			if(tempinputids.size() > 0){%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempinputids.size() ; t++) {
                String tempinputstatus = (String)tempinputstatuss.get(t) ;
                String tempinputdates = (String)tempreportdates.get(t) ;
				String dspdate = (String)tempdspdates.get(t) ;
            %>
			<TR>
          	<a href="ReportConfirmMtiDetail.jsp?thetable=<%=thetable%>&thedate=<%=tempinputdates%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>"><TD
          <% if( tempinputstatus.equals("9") ) {%> title="已输入" bgColor=white
          <% } else if( tempinputstatus.equals("0") ) {%> title="待审核" bgColor=white
          <% } else if( tempinputstatus.equals("4") ) {%> title="已审核" bgColor=white <%}%>
           height=16>
              <% if( tempinputstatus.equals("9") ) {%><IMG SRC="\images\iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">
              <% } else if( tempinputstatus.equals("0") ) {%><IMG SRC="\images\BacoCheck.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">
              <% } else if( tempinputstatus.equals("4") ) {%><IMG SRC="\images\BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"><%}%>
           </TD></a></TR><tr><td bgColor=<%=bgcolor%> height=2></td></tr><%}%></TBODY></TABLE></TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> title=<%=innertext%> align=center valign=middle>&nbsp;</TD><%} }%>	
		</tr>
	</table>
	</td></tr>
</table>
  <%}%>
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
<jsp:useBean id="xss" class="weaver.filter.XssUtil" scope="page" />
<script language=vbs>
sub onShowCustomer(tdname,inputename,thevalue)
	if thevalue = "" then
	    url="/systeminfo/BrowserMain.jsp?url=/datacenter/input/CustomerBrowser.jsp?sqlwhere=<%=xss.put("where 1=2")%>%26isSecurity=false"
    else
		url="/systeminfo/BrowserMain.jsp?url=/datacenter/input/CustomerBrowser.jsp?sqlwhere=where t1.id in ("&thevalue&")%26isSecurity=false"
    end if
    id = window.showModalDialog(url)
	if NOT isempty(id) then
        if id(0)<> "" then
            tdname.innerHtml = id(1)
            inputename.value = id(0)
		end if
	end if
end sub

sub getTheDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returndate)) then
		if returndate <> "" then
			document.frmmain.currentdate.value = returndate
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
</html>
