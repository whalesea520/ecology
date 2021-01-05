
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17634,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarDriverBasicinfo.jsp,_self} " ;
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
			
<form name="frmmain" action="CarDriverBasicinfoOperation.jsp">

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
    String receptionpara="";
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
        <TD><INPUT class=inputstyle type=text size=10 name="basicsalary" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=basicsalary%>"></TD>
        <td><%=SystemEnv.getHtmlLabelName(17640,user.getLanguage())%></td>
        <TD><INPUT class=inputstyle type=text size=10 name="receptionpara" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=receptionpara%>"></TD>
    </TR>
    <tr class=datadark>
        <td><%=SystemEnv.getHtmlLabelName(17641,user.getLanguage())%></td>
        <TD><INPUT class=inputstyle type=text size=10 name="overtimepara" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=overtimepara%>"></TD>
        <td><%=SystemEnv.getHtmlLabelName(17642,user.getLanguage())%></td>
        <TD><INPUT class=inputstyle type=text size=10 name="publicpara" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=publicpara%>"></TD>
    </TR>
    <tr class=datalight>
        <TD><%=SystemEnv.getHtmlLabelName(17643,user.getLanguage())%></TD>
        <TD><INPUT class=inputstyle type=text size=10 name="basicKM" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=basicKM%>"></TD>
        <TD><%=SystemEnv.getHtmlLabelName(17644,user.getLanguage())%></TD>
        <TD><INPUT class=inputstyle type=text size=10 name="basicKMpara" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=basicKMpara%>"></TD>
    </TR>
    <tr class=datadark>
        <TD><%=SystemEnv.getHtmlLabelName(17645,user.getLanguage())%></TD>
        <TD><INPUT class=inputstyle type=text size=10 name="basictime" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=basictime%>"></TD>
        <TD><%=SystemEnv.getHtmlLabelName(17644,user.getLanguage())%></TD>
        <TD><INPUT class=inputstyle type=text size=10 name="basictimepara" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=basictimepara%>"></TD>
    </TR>
    <tr class=datalight>
        <TD><%=SystemEnv.getHtmlLabelName(17646,user.getLanguage())%></TD>
        <TD><INPUT class=inputstyle type=text size=10 name="basicout" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=basicout%>"></TD>
        <TD><%=SystemEnv.getHtmlLabelName(17644,user.getLanguage())%></TD>
        <TD><INPUT class=inputstyle type=text size=10 name="basicoutpara" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=basicoutpara%>"></TD>
    </TR>
</TBODY></TABLE>
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

<script language="javascript">
 function onSubmit()
{
	frmmain.submit();
}

</script>
</BODY></HTML>
