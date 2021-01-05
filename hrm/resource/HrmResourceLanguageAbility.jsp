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
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(815,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceLanguageAbilityAdd:Add",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",HrmResourceLanguageAbilityAdd.jsp?resourceid="+resourceid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
   <TR class=Header> 
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(1954,user.getLanguage())%></TD>
    <TD width="15%"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
    <TD width="60%"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
	<TD width="10%"></TD>
  </TR>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
int i=0;
RecordSet.executeProc("HrmLanguageAbility_SByResourID",resourceid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String language = RecordSet.getString("language");
String level = RecordSet.getString("level_n");
String memo = RecordSet.getString("memo");
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
	<td><%=language%></td>
    <td>
		<%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
        <%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
		<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%><%}%>
        <%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%><%}%>
	</td>
    <td><%=Util.toScreen(memo,user.getLanguage())%></td>
    <td><a href="HrmResourceLanguageAbilityEdit.jsp?paraid=<%=id%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a></td>
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