<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
char separator = Util.getSeparator() ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(1504,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/resource/HrmResourceWelfareAdd.jsp?resourceid="+resourceid+",_self} " ;
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
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=8><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
  <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1893,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1894,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1895,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1896,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></TD>
    <TD width="30%"><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></TD>
	<TD width="10%"></TD>
  </TR>
  <TR class=Line><TD colspan="8" ></TD></TR> 
<%
int i=0;
RecordSet.executeProc("HrmWelfare_SelectByResourceId",resourceid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String datefrom = RecordSet.getString("datefrom");
String dateto = RecordSet.getString("dateto");
String basesalary = RecordSet.getString("basesalary");
String homesub = RecordSet.getString("homesub");
String vehiclesub = RecordSet.getString("vehiclesub");
String mealsub = RecordSet.getString("mealsub");
String othersub = RecordSet.getString("othersub");
String adjustreason = RecordSet.getString("adjustreason");
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<td><%=datefrom%>-<%=dateto%></td>
    <td><%=basesalary%></td>
    <td><%=homesub%></td>
    <td><%=vehiclesub%></td>
    <td><%=mealsub%></td>
    <td><%=othersub%></td>
    <td><%=adjustreason%></td>
    <td><a href="HrmResourceWelfareEdit.jsp?paraid=<%=id%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
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
</BODY>
</HTML>