
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CapitalGroupComInfo" class="weaver.cpt.maintenance.CapitalGroupComInfo" scope="page" />
<%
	String parentid = Util.null2String(request.getParameter("parentid"));
	if(parentid.equals("")) parentid="0";
	RecordSet.executeProc("CptCapitalGroup_SelectByID",parentid);
	RecordSet.first();
	String pparent = RecordSet.getString("parentid");
	
	RecordSet.executeProc("CptCapitalGroup_SelectAll",parentid);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(831,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(HrmUserVarify.checkUserRight("CptCapitalGroupAdd:add", user)){
%>
<DIV class=BtnBar>
<BUTTON language=VBS class=BtnNew id=button1 accessKey=N name=button1 onclick="location='/cpt/maintenance/CptCapitalGroupAdd.jsp?parentid=<%=parentid%>'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
<%}%>

<%if(!parentid.equals("0")){%>
<BUTTON language=VBS class=Btn id=button2 accessKey=P name=button1 onclick="location='/cpt/maintenance/CptCapitalGroup.jsp?parentid=<%=pparent%>'"><U>P</U>-<%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%></BUTTON>
<%}%>
</DIV>

<TABLE class=ListShort>
  <COLGROUP>
  <COL width="20%">
  <COL width="40%">
  <%if (!parentid.equals("0")) {%>
  <COL width="40%">
  <%} else {%>
  <COL width="20%">
  <COL width="10%">
  <COL width="10%">
  <%}%>
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></th>
  <%if (parentid.equals("0")) {%>
  <th colspan=2><%=SystemEnv.getHtmlLabelName(832,user.getLanguage())%></th>
  <%}%>	
  </tr>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<TD><a href="/cpt/maintenance/CptCapitalGroupEdit.jsp?id=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("description"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(CapitalGroupComInfo.getCapitalGroupname(RecordSet.getString("parentid")),user.getLanguage())%>&nbsp;</TD>
<%if (parentid.equals("0")) {%>
		<TD><a href="/cpt/maintenance/CptCapitalGroupAdd.jsp?parentid=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></a></TD>
		<TD><a href="/cpt/maintenance/CptCapitalGroup.jsp?parentid=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></a></TD>
<%}%>  
	</TR>
<%
	}
%>
 </TABLE>

</BODY>
</HTML>
