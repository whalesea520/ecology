
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17634,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",CarDriverBasicinfoEdit.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarParameter.jsp,_self} " ;
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="25%"><COL width="25%"><COL width="25%"><COL width="25%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(17636,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17638,user.getLanguage())%></TD>
    <td><%=SystemEnv.getHtmlLabelName(561,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(17639,user.getLanguage())%></td>
  </TR>
   <TR class=Line><TD colspan="4" ></TD></TR>
<%
    String basicsalary="";
    String overtimepara="";
    String receptionpara="" ;
    String basicKM="";
    String basicKMpara="";
    String basictime="";
    String basictimepara="";
    String basicout="";
    String basicoutpara="";
    String publicpara ="";
    
    RecordSet.executeProc("CarDriverBasicinfo_Select","");
    if(RecordSet.next()){
    	basicsalary=RecordSet.getString("basicsalary");
    	overtimepara=RecordSet.getString("overtimepara");
    	receptionpara=RecordSet.getString("receptionpara");
    	basicKM=RecordSet.getString("basicKM");
    	basicKMpara=RecordSet.getString("basicKMpara");
    	basictime=RecordSet.getString("basictime");
    	basictimepara=RecordSet.getString("basictimepara");
    	basicout=RecordSet.getString("basicout");
    	basicoutpara=RecordSet.getString("basicoutpara");
    	publicpara = RecordSet.getString("publicpara");
    }
%>
    <tr class=datalight>
        <TD><%=SystemEnv.getHtmlLabelName(1893,user.getLanguage())%></TD>
        <TD><%=basicsalary%></TD>
        <td><%=SystemEnv.getHtmlLabelName(17640,user.getLanguage())%></td>
        <TD><%=receptionpara%></TD>
    </TR>
    <tr class=datadark>
        <td><%=SystemEnv.getHtmlLabelName(17641,user.getLanguage())%></td>
        <TD><%=overtimepara%></TD>
        <td><%=SystemEnv.getHtmlLabelName(17642,user.getLanguage())%></td>
        <TD><%=publicpara%></TD>
    </TR>
    <tr class=datalight>
        <TD><%=SystemEnv.getHtmlLabelName(17643,user.getLanguage())%></TD>
        <TD><%=basicKM%></TD>
        <TD><%=SystemEnv.getHtmlLabelName(17644,user.getLanguage())%></TD>
        <td><%=basicKMpara%></td>
    </TR>
    <tr class=datadark>
        <TD><%=SystemEnv.getHtmlLabelName(17645,user.getLanguage())%></TD>
        <TD><%=basictime%></TD>
        <TD><%=SystemEnv.getHtmlLabelName(17644,user.getLanguage())%></TD>
        <td><%=basictimepara%></td>
    </TR>
    <tr class=datalight>
        <TD><%=SystemEnv.getHtmlLabelName(17646,user.getLanguage())%></TD>
        <TD><%=basicout%></TD>
        <TD><%=SystemEnv.getHtmlLabelName(17644,user.getLanguage())%></TD>
        <td><%=basicoutpara%></td>
    </TR>
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
