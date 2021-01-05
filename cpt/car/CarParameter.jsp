
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17632,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
		<COL width="100%">



		<TR class=Header>
			<TH><%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%></TH>
		</TR>

		<TR class=Line>
			<TD colSpan=3></TD>
		</TR>


		<TR class=DataDark>
			<TD><a href="CarParameterList.jsp"><%=SystemEnv.getHtmlLabelName(17633,user.getLanguage())%></a></TD>
		</TR>
		<TR class=DataLight>	
			<TD><a href="CarDriverBasicinfo.jsp"><%=SystemEnv.getHtmlLabelName(17634,user.getLanguage())%></a></TD>
		</TR>
			
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
    
  </body>
</html>
