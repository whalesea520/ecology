<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerRatingComInfo" class="weaver.crm.Maint.CustomerRatingComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(139,user.getLanguage());
String needfav ="1";
String needhelp ="";
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String optional="customerrating";
String sqlstr = "";
if(user.getLogintype().equals("1")){
	sqlstr = "select t1.rating AS resultid,COUNT(distinct t1.id) AS resultcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2 where t1.id = t2.relateditemid and t1.deleted = 0 group by t1.rating order by resultcount";
}else{
	sqlstr = "select t1.rating AS resultid,COUNT(t1.id) AS resultcount from CRM_CustomerInfo  t1 where t1.agent="+user.getUID() + "  and t1.deleted = 0 group by t1.rating order by resultcount";
}
int linecolor=0;
int totalcustomer=0;
float resultpercent=0;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
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
<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line><TD colSpan=4></TD></TR>
<%  RecordSet.executeSql(sqlstr);
	while(RecordSet.next())  { 
		  int resultcount = RecordSet.getInt(2);
		  totalcustomer+=resultcount;
	}
	RecordSet.first();
	if(totalcustomer!=0){
		do{
		String resultid = RecordSet.getString(1);
		int resultcount = RecordSet.getInt(2);
		resultpercent=(float)resultcount*100/(float)totalcustomer;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
		
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD>
    <%if(resultid.equals("0")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%>
    <%=Util.toScreen(CustomerRatingComInfo.getCustomerRatingname(resultid),user.getLanguage())%><%}%></TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=redgraph <%if(resultpercent<1){%>width="1%"<%} else {%>
          width="<%=resultpercent%>%"<%}%>>&nbsp;</TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD>
    <%if(resultcount!=0){%><a href="/CRM/search/SearchOperation.jsp?msg=report&settype=customerrating&id=<%=resultid%>"><%=resultcount%></a>
    <%} else {%><%=resultcount%><%}%></TD>
    <TD><%=resultpercent%>%</TD>
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}while(RecordSet.next());
	} %>
  </TBODY></TABLE>
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
  </BODY></HTML>
