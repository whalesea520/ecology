<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179 , user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(515,user.getLanguage()) ; 
String needfav ="1";
String needhelp ="";

String optional="projecttype";
int linecolor=0;
int total=0;
float resultpercent=0;


String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String location=Util.fromScreen(request.getParameter("location"),user.getLanguage());

String sqlwhere="";

if(status.equals("")){
      status = "8";
    }
if(!fromdate.equals("")){
	sqlwhere+=" and t1.startdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.startdate<='"+enddate+"' or t1.startdate is null)";
}

if(!location.equals("")){
	sqlwhere+=" and t1.locationid ="+location;
}
if(!(status.equals("")||status.equals("9"))){
    if(status.equals("8")){
        sqlwhere+=" and t1.status <= 3";
    }else{
	    sqlwhere+=" and t1.status ="+status;
    }
}


String sqlstr="";
if(sqlwhere.equals("")){
sqlstr = "select t1.costcenterid   resultid,COUNT(t1.id)   resultcount from HrmResource  t1,HrmCostcenter  t2 where t1.costcenterid=t2.id  group by t1.costcenterid order by resultcount";
}
else 
sqlstr = "select t1.costcenterid   resultid,COUNT(t1.id)   resultcount from HrmResource  t1,HrmCostcenter  t2 where t1.costcenterid=t2.id "+sqlwhere+" group by t1.costcenterid order by resultcount";

RecordSet.executeSql(sqlstr);

while(RecordSet.next())  { 
      int resultcount = RecordSet.getInt(2);
      total+=resultcount;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
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

<form name=frmmain method=post action="hrmCostcenterRp.jsp">
<table class=viewform>
<tbody>
<TR CLASS=spacing><TD colspan=9 class=line1></TD></TR>
<tr>
    <TD><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
    <TD class=Field>
     <button class=Browser onClick="onShowLocation()"></button> 
     <span class=inputStyle id=locationspan><%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>
     </span> 
     <input id=location type=hidden name=location value="<%=location%>">
   </TD>

     <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
     <TD class=Field> 
      <SELECT class=inputStyle id=status name=status value="<%=status%>"  style="width:100px">
<%    if(status.equals("")){
      status = "9";
    }
%>                                    
           <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>                   
           <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
           <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
           <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
           <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
           <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
           <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
           <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
           <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
           <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>                   
     </SELECT>
     </TD>

    <td width=15%><%=SystemEnv.getHtmlLabelName(1908,user.getLanguage())%></td>
    <td class=field>
    <BUTTON class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</tr>
<TR><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>

<TABLE class=viewForm width="100%">
  <TBODY>
  <TR class=title>
    <TH><%=SystemEnv.getHtmlLabelName(15861,user.getLanguage())%>：<%=total%></TH>
  </TR>
  </TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1  width="100%">
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
    <TR class=Line><TD colspan="4" ></TD></TR> 
<%
   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable (SystemEnv.getHtmlLabelName(15865,user.getLanguage()));
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
	RecordSet.first();
	if(total!=0){
		do{
		String resultid = RecordSet.getString(1);
		int resultcount = RecordSet.getInt(2);
		resultpercent=(float)resultcount*100/(float)total;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;

	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/company/HrmCostcenterDsp.jsp?id=<%=resultid%>"> <%=Util.toScreen(CostcenterComInfo.getCostCentermark(resultid),user.getLanguage())%>-   
    <%=Util.toScreen(CostcenterComInfo.getCostCentername(resultid),user.getLanguage())%></TD>
    <TD height="100%">        
        <TABLE height="100%" cellSpacing=0 
        <%if(resultpercent==100){%>
        class=redgraph 
        <%}else{%>
        class=greengraph 
        <%}%>
        width="<%=resultpercentOfwidth%>%">                       
        <TBODY>
        <TR>
        <TD width="100%" height="100%"><img src="/images/ArrowUpGreen_wev8.gif" width=1 height=1></td>
        </TR>
        </TBODY>
        </TABLE>    
    </TD>
    <TD><%=resultcount%></TD>
    <TD><%=resultpercent%>%</TD>
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		String labelname =Util.toScreen(CostcenterComInfo.getCostCentermark(resultid),user.getLanguage()); 	
      		GraphFile.addConditionlable(labelname) ;		
      		GraphFile.addPiclinevalues ( ""+resultcount , labelname , GraphFile.random , null  );
    		}while(RecordSet.next());
	} %>
  </TBODY>
  </TABLE>
  <br>
<TABLE class=viewform>
  <TBODY>     
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=3'>
    </TD>
  </TR> 
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=4'>
    </TD>
  </TR>    
  </TBODY> 
</TABLE> 
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
<script language=vbs>  
sub onShowLocation()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	locationspan.innerHtml = id(1)
	frmmain.location.value=id(0)
	else
	locationspan.innerHtml = ""
	frmmain.location.value=""
	end if
	end if
end sub
</script>
  </BODY>  
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>