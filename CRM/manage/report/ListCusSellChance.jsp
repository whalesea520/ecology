
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
String hrmid = request.getParameter("hrmid");
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

RecordSet.executeSql("SELECT * FROM CRM_SellChance where customerid in (select id from CRM_CustomerInfo where manager = "+hrmid+") order by customerid desc,predate desc");
%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

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
		<%if(!isfromtab){ %>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<% }%>
		<tr>
		<td valign="top">

<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="30%">
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(2249,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=7 style="padding: 0"></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{ 
	if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
	<TD><a href="/CRM/sellchance/ViewSellChance.jsp?id=<%=RecordSet.getString(1)%>&CustomerID=<%=RecordSet.getString("customerid")%>"><%=Util.toScreen(RecordSet.getString("subject"),user.getLanguage())%></a></TD>
	<TD>
	<%=Util.toScreen(RecordSet.getString("predate"),user.getLanguage())%>
	</TD>
	 <TD>
	<%=Util.toScreen(RecordSet.getString("preyield"),user.getLanguage())%>
	</TD>
	<TD>
	<%=Util.toScreen(RecordSet.getString("probability"),user.getLanguage())%>
	</TD>
	<TD>
	<%=Util.toScreen(RecordSet.getString("createdate"),user.getLanguage())%>
	</TD>   
	<TD>
	<%
		String sellstatusid = Util.null2String(RecordSet.getString("sellstatusid"));

		if (!sellstatusid.equals("")) {
			String sql="select * from CRM_SellStatus where id ="+sellstatusid;
			rs.executeSql(sql);
			rs.next();
	%>
	 
	<%=Util.toScreen(Util.null2String(rs.getString("fullname")),user.getLanguage())%>
	<%}%>
	</TD> 
	<TD>
	<%
	   String  endtatusid =RecordSet.getString("endtatusid");         
	%>
		<%if(endtatusid.equals("0")){%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><%}%>
		<%if(endtatusid.equals("1")){%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%><%}%>
		<%if(endtatusid.equals("2")){%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%><%}%>
	</TD>            
	</TR>
<%
	}
%>
 </TABLE>
		</td>
		</tr>
		</TABLE>
	<td></td>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
