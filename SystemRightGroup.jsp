<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head><%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(492,user.getLanguage())+" - CRM";
String needfav ="1";
String needhelp ="1";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(HrmUserVarify.checkUserRight("SystemRightGroupAdd:Add",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",SystemRightGroupAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!--
<BUTTON class=btnSearch accesskey="S" onclick='location.href="SystemRightSearch.jsp"'>
	<U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>
</BUTTON>
-->
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

			<TABLE class="ListStyle" cellspacing="1">
				<TR class="Header">
					<TD><%=SystemEnv.getHtmlLabelName(492,user.getLanguage())%></TD>
					<TD><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD>
				</TR>
				<TR class=Line><TD colspan="2" ></TD></TR> 
			<%
				int i = 0;
				RecordSet.execute("SystemRight_selectRightGroup","");
				while(RecordSet.next()){
					int id=RecordSet.getInt(1);
					String name=Util.toScreen(RecordSet.getString(2),user.getLanguage());
					int count=RecordSet.getInt(3);
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
						<TD><%if(id==-1) {%><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%> <%} else {%><%=name%><%}%></TD>
						<TD><A HREF="SystemRightGroupEdit.jsp?id=<%=id%>"><%=count%></A></TD></TR>
			<%}%>
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