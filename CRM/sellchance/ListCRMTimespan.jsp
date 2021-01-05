
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	RecordSet.executeProc("CRM_SellTimespan_SelectAll","");
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15244,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
if(HrmUserVarify.checkUserRight("CrmSalesChance:Maintenance", user)){
%>
<DIV class=BtnBar style="display:none">
    <%if(RecordSet.getCounts()<=0){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/CRM/sellchance/AddCRMTimespan.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON language=VBS class=BtnNew id=button1 accessKey=N name=button1 onclick="location='/CRM/sellchance/AddCRMTimespan.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
    <%}%>

    <%if(RecordSet.getCounts()>0){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/CRM/sellchance/EditCRMTimespan.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON language=VBS class=BtnNew id=button1 accessKey=N name=button1 onclick="location='/CRM/sellchance/EditCRMTimespan.jsp'"><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON>
    <%}%>  

<%}%>
 </DIV>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="30%">
  <COL width="70%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15237,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15238,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=2 style="padding: 0"></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{  if(!(RecordSet.getString(2).equals(""))){
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%></TD>
	</TR>
<%
    }
	}
%>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
