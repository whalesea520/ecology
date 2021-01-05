
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
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17633,user.getLanguage());
String needfav ="1";
String needhelp ="";



%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CarParameterAdd.jsp,_self} " ;
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
        <COL width="40%">
        <COL width="10%">
        <COL width="50%">


		<TR class=Header >
			<TH colspan="3"><%=SystemEnv.getHtmlLabelName(17636,user.getLanguage())%></TH>
		</TR>

        <TR class=Header>
              <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
              <TD><%=SystemEnv.getHtmlLabelName(17637,user.getLanguage())%></TD>
              <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
        </TR>
        <TR class=Line><TD colspan="3" ></TD></TR>
        <%
            boolean islight=true ;
            RecordSet.executeProc("CarParameter_Select","");
            while(RecordSet.next()){
                String	name=RecordSet.getString("name");
                String	description=RecordSet.getString("description");
                String  paravalue=RecordSet.getString("paravalue");
        %>
            <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
                <TD><a href="CarParameterEdit.jsp?id=<%=RecordSet.getString("id")%>"><%=name%></a></TD>
                <TD><%=paravalue%></TD>
                <TD><%=description%></TD>
            </TR>
        <%
                islight=!islight ; 
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

</TBODY>
</TABLE>
</BODY>
</HTML>
