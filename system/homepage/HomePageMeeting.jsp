
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="spp" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />

<%
MeetingSearchComInfo.resetSearchInfo();
if(user.getLogintype().equals("1")){
	MeetingSearchComInfo.sethrmids(""+user.getUID());
}else{
	MeetingSearchComInfo.setcrmids(""+user.getUID());
}

String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),1);
boolean hasNextPage=false;

if(perpage<=1 )	perpage=10;

String temptable = "meetingtemptable"+ Util.getNumberRandom() ;
String SearchSql = "";
String SqlWhere = "";
String FromWhere = "";

SqlWhere = MeetingSearchComInfo.FormatSQLSearch(user.getLanguage())  ;

if(!SqlWhere.equals("")){
	SqlWhere +=" and (";
    SqlWhere +=" (t1.id=t2.meetingid) and ";
	SqlWhere +=" ((t2.userid=" + userid + " and t2.sharelevel=1)" ;
	SqlWhere +=" or ( t1.isapproved in('2','3','4') and (t2.userid=" + userid + ")))";
	SqlWhere +=") ";
}else{
	SqlWhere =" where ";
    SqlWhere +=" (t1.id=t2.meetingid) and ";
	SqlWhere +=" ((t2.userid=" + userid + " and t2.sharelevel=1)" ;
	SqlWhere +=" or ( t1.isapproved in('2','3','4') and (t2.userid=" + userid + ")))";
}

FromWhere = " from Meeting  t1, Meeting_ShareDetail  t2 ";

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);

spp.setBackFields("t1.id,t1.name,t1.address,t1.caller,t1.contacter,t1.begindate,t1.begintime" );
spp.setSqlFrom(FromWhere);
spp.setSqlWhere(SqlWhere);
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
<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
    <tr class=Header> 
      <th colspan = 2><%=SystemEnv.getHtmlLabelName(2102,user.getLanguage())%></th>
    </tr>
<%
     
boolean isLight = false;
int totalline=1;
if(RecordSet.last()){
	do{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
	<TD><%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%></TD>
    <TD><a href="/meeting/data/ViewMeeting.jsp?meetingid=<%=RecordSet.getString("id")%>" target = "mainFrame"><%=RecordSet.getString("name")%></a></TD>
    
  </TR>
<%
	isLight = !isLight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
}
%>  
 </TBODY>
 </TABLE>
 	<TABLE align=right>
   <tr>
   <td>&nbsp;</td>
   <td><%if(pagenum>1){%><button class=btn accessKey=P onclick="location.href='HomePageMeeting.jsp?pagenum=<%=pagenum-1%>&TotalCount=<%=TotalCount%>'"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%></td>
   <td><%if(hasNextPage){%><button class=btn accessKey=N onclick="location.href='HomePageMeeting.jsp?pagenum=<%=pagenum+1%>&TotalCount=<%=TotalCount%>'" ><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
   <td>&nbsp;</td>
   </tr>
	  </TABLE>

</body>
</html>