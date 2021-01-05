<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>	
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(5000,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAll = HrmUserVarify.checkUserRight("WeatherMaintenance:All", user);
int showtype=Util.getIntValue(request.getParameter("showtype"),0);
int year=Util.getIntValue(request.getParameter("year"),0);
String dept_id=Util.null2String(request.getParameter("dept_id"));
Calendar today = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR); 
int fromyear=currentyear-5;
int toyear=currentyear+5;
if(year==0) year=currentyear;
char separator = Util.getSeparator();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<FORM id=weaver name=frmmain method=post >
<div>
<BUTTON class=btnRefresh accessKey=R type="submit" action="Weather.jsp"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
<%
if(CanAll){
%>
<BUTTON class=btnNew accessKey=N onclick="location='WeatherAdd.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}
%>
<TABLE CLASS=FORM>
	<col width=15%>
	<col width=33%>
	<col width=15%>
	<col width=33%>
	
	<TR CLASS=SECTION>
		<TH colspan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
	</TR>	
	<TR Class=separtator>
		<TD CLASS=Sep1 colspan=5></TD>
	</TR>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
		<td><select name="year" size="1">
		<%
		int i=0;
		int j=0;
		for(i=fromyear;i<=toyear;i++){
		%>
		<option value="<%=i%>" <%if(i==year) {%> selected <%}%>><%=Util.add0(i, 4)%></option>
		<%
		}
		%>
		</select></td>
	</tr>
</table>

<%if(showtype==0){%>
<table class=form>
	<TR CLASS=SECTION>
		<TH colspan=32><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
	</TR>	
	<TR Class=separtator>
		<TD CLASS=Sep1 colspan=32></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  <%
	  for(i=0;i<32;i++){
	  	%>
	  	<td height=20px ALIGN=CENTER><%if(i>0){%><%=i%><%} else {%>&nbsp<%}%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr>
	<%
	RecordSet.executeProc("Weather_SelectByYear",""+year);
	RecordSet.next();
	String innertext="";
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	String tempholiday="";
	String nowday="";
	int canlink=1;
	int isholiday=0;
	int totalholiday=0;
	
	for(j=1;j<13;j++){
		for(i=0;i<32;i++){
		canlink=1;
		isholiday=0;
		String id="";
		String thedesc="";
		String picid="";
		bgcolor="white";
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
			else innertext="";
			tempday.clear();
			tempday.set(year,j-1,i);
			if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)&&i>0) bgcolor="lightblue";
//			if(j==2){
//			    if(i==30||i==31) bgcolor="darkblue";
//			    if(i==29){
//			    	if(!((year%400)==0||((year%4)==0&&!((year%100)==0)))) bgcolor="darkblue";
//			    }
//			}
//			if((j==4||j==6||j==9||j==11)&&i==31) { bgcolor="darkblue"; canlink=0;}
			if((tempday.getTime().getMonth()!=(j-1))&&i>0) { bgcolor="darkblue"; canlink=0;}
			if(!bgcolor.equals("darkblue")&&i>0){
				tempholiday=RecordSet.getString("thedate");
				nowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
                     			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
                     			Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
				if(nowday.equals(tempholiday)){
					bgcolor="MEDIUMBLUE";
					if(tempday.getTime().getDay()==0) innertext="S";
					if(tempday.getTime().getDay()==1) innertext="M";
					if(tempday.getTime().getDay()==2) innertext="T";
					if(tempday.getTime().getDay()==3) innertext="W";
					if(tempday.getTime().getDay()==4) innertext="T";
					if(tempday.getTime().getDay()==5) innertext="F";
					if(tempday.getTime().getDay()==6) innertext="S";
					thedesc=RecordSet.getString("thedesc");
					id=RecordSet.getString("id");
					picid=RecordSet.getString("picid");
					RecordSet.next();
					isholiday=1;
					totalholiday+=1;
				}
			}
			%>
			<%if(canlink==1&&isholiday==0&&CanAll&&i>0){%><a style="TEXT-DECORATION: none" href="WeatherAdd.jsp?thedate=<%=nowday%>"><%}%>
			
			<td height=20px ALIGN=CENTER bgcolor="<%=bgcolor%>"
			<%if((i>0)&&!bgcolor.equals("darkblue")){%>style="COLOR:white;CURSOR:HAND" <%} if(bgcolor.equals("MEDIUMBLUE")) {%> ID="<%=thedesc%>:<%=nowday%>"<%}%>>
			<%if(canlink==1&&isholiday==1&&CanAll&&i>0){%><a style="TEXT-DECORATION: none" href="WeatherEdit.jsp?id=<%=id%>"><%}%>
			<% if(picid.equals("1")){%><IMG src="../../images/sun_wev8.gif" align=absMiddle border=0><%}%>
			<% if(picid.equals("2")){%><IMG src="../../images/yun_wev8.gif" align=absMiddle border=0><%}%>
			<% if(picid.equals("3")){%><IMG src="../../images/yin_wev8.gif" align=absMiddle border=0><%}%>
			<% if(picid.equals("4")){%><IMG src="../../images/yu_wev8.gif" align=absMiddle border=0><%}%>
			<%if(canlink==1&&isholiday==1&&CanAll&&i>0){%></a><%}%>
			<%=innertext%>&nbsp</td><%if(canlink==1&&isholiday==0&&CanAll&&i>0){%></a><%}%>
			<%
			if(i==31){%> 
			</tr>
			<%}
		}
	}
	%>
	</table>

</table>
<%}%>
</form>
</body>
</html>
