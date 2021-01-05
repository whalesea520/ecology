<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(231,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="language";
int total=0;
int linecolor=0;
%>
<%char separator = Util.getSeparator() ; 
int userid=user.getUID();%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
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

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="15%">
  <COL align=left width="19%">
  <COL align=right width="7%">
  <COL align=right width="10%">
  <COL align=left width="19%">
  <COL align=right width="7%">
  <COL align=right width="9%">
  <COL align=right width="6%">
  <COL align=right width="9%">
  <TBODY>
  <TR class=header>
    <TH colspan=9><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TH><nobr><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TH>
    <TH><nobr><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
    <TH><nobr><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    <TH><nobr><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
    <TH><nobr><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></TH>
    <TH>%</TH>
    <TH><nobr><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
    <TH>%</TH></TR>
<TR class=Line><TD colSpan=9></TD></TR>
	<%  
	RecordSet.executeProc("DocRpsum",optional+separator+userid);
	while(RecordSet.next()){
		if(RecordSet.getInt(1)==0)	continue;
		total+=RecordSet.getInt(2);
	}
	RecordSet.first();
	if(total!=0){
		do{ 
		  String resultid = RecordSet.getString(1);
		  if(resultid.equals("0"))	continue;
		  int resultcount = RecordSet.getInt(2);
		  int replycount=RecordSet.getInt(3);
		  int normalcount=resultcount-replycount;
		  float resultpercent=(float)resultcount*100/(float)total;
		  resultpercent=(float)((int)(resultpercent*100))/100;
		  float normalpercent=(float)normalcount*100/(float)resultcount;
		  normalpercent=(float)((int)(normalpercent*100))/100;
		  float replypercent=(float)replycount*100/(float)resultcount;
		  replypercent=(float)((int)(replypercent*100))/100;
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><%=Util.toScreen(LanguageComInfo.getLanguagename(resultid),user.getLanguage())%></TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=redgraph <%if(resultpercent>1){%>width="<%=resultpercent%>%" <%} else {%> width="1%"<%}%>>&nbsp;</TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD><%=resultcount%></TD>
    <TD><%=resultpercent%>%</TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=bluegraph width="<%=normalpercent%>%" <%if(normalpercent==0.0) out.println("style='display:none'");%>>&nbsp;</TD>
          <TD class=greengraph width="<%=replypercent%>%" <%if(replypercent==0.0) out.println("style='display:none'");%>>&nbsp;</TD>          
         </TR>
        </TBODY>
       </TABLE>
     </TD>
      <TD><%=normalcount%></TD>
      <TD><%=normalpercent%>%</TD>
      <TD><%=replycount%></TD>
      <TD><%=replypercent%>%</TD>
     </TR>
	<%	if(linecolor==0)	linecolor=1;
		else	linecolor=0;
		}while(RecordSet.next());
	 }%>
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
  </BODY></HTML>
