<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>



<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(15184,user.getLanguage()),user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",InputReportAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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


<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
<!--
  <COL width="20%">
  <COL width="15%">
  <COL width="15%">
-->
  <COL width="25%">
  <COL width="25%">
  <TBODY>
  <TR class=header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15184,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15185,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(18776,user.getLanguage())%></TD>
<!--
	<TD>°üº¬Ô¤Ëã</TD>
    <TD>°üº¬Ô¤²â</TD>
-->
    <TD><%=SystemEnv.getHtmlLabelName(20612,user.getLanguage())%></TD>
  </TR><TR class=Line><TD colspan="4" style="padding: 0"></TD></TR> 
  
<%
      rs.executeProc("T_InputReport_SelectAll","");
      int needchange = 0;
      while(rs.next()){
	    String inprepid = Util.null2String(rs.getString("inprepid")) ;
	  	String inprepname = Util.toScreen(rs.getString("inprepname"),user.getLanguage()) ;
		String inprepfrequence = Util.null2String(rs.getString("inprepfrequence")) ;
		String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
        String inprepforecast = Util.null2String(rs.getString("inprepforecast")) ;
        String isInputMultiLine = Util.null2String(rs.getString("isInputMultiLine")) ;
		
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><a href='InputReportEdit.jsp?inprepid=<%=inprepid%>'><%=inprepname%></a></TD>
    <TD>
	<% if(inprepfrequence.equals("0")) { %><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%>
	<%} else if(inprepfrequence.equals("1")) { %><%=SystemEnv.getHtmlLabelName(20616,user.getLanguage())%>
	<%} else if(inprepfrequence.equals("2")) { %><%=SystemEnv.getHtmlLabelName(20617,user.getLanguage())%>
	<%} else if(inprepfrequence.equals("3")) { %><%=SystemEnv.getHtmlLabelName(20618,user.getLanguage())%>
	<%} else if(inprepfrequence.equals("4")) { %><%=SystemEnv.getHtmlLabelName(20619,user.getLanguage())%>
	<%} else if(inprepfrequence.equals("5")) { %><%=SystemEnv.getHtmlLabelName(20620,user.getLanguage())%>
    <%} else if(inprepfrequence.equals("6")) { %><%=SystemEnv.getHtmlLabelName(20729,user.getLanguage())%>
	<%} else if(inprepfrequence.equals("7")) { %><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%><%}%>

    </TD>
<!--
	<TD>
	<% if(inprepbudget.equals("0")) { %>·ñ
	<%} else { %>ÊÇ<%}%>
	
	</TD>
    <TD>
	<% if(inprepforecast.equals("0")) { %>·ñ
	<%} else { %>ÊÇ<%}%>
	</TD>
-->
    <TD>
	<% if(isInputMultiLine.equals("1")) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	<%} else { %><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
	</TD>
  </TR>
<%
    }
%>  
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
