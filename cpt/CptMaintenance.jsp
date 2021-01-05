<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(60,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps>
<%if(!software.equals("ALL")){%>
<%
String mainttype = Util.null2String(request.getParameter("mainttype"));
%>
<TABLE class="Form">
	<TR>
		<TD align=right>
	<SELECT name=mainttype onchange="changetype()">
		<OPTION value=S <%if(mainttype.equals("S")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></OPTION>
		<OPTION value=W <%if(mainttype.equals("W")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></OPTION>
		<OPTION value=D <%if(mainttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
		<OPTION value=H <%if(mainttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
<%if(software.equals("ALL") || software.equals("CRM")){%>
		<OPTION value=C <%if(mainttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
		<OPTION value=R <%if(mainttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM")){%>
		<OPTION value=I <%if(mainttype.equals("I")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){%>
		<OPTION value=F <%if(mainttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
<%}%>
	</SELECT>
	<script language=javascript>
		function changetype(){
		if(document.all("mainttype").value=="S") location = "/system/SystemMaintenance.jsp?mainttype=S";
		if(document.all("mainttype").value=="W") location = "/workflow/WFMaintenance.jsp?mainttype=W";
		if(document.all("mainttype").value=="D") location = "/docs/DocMaintenance.jsp?mainttype=D";
		if(document.all("mainttype").value=="H") location = "/hrm/HrmMaintenance.jsp?mainttype=H";
		if(document.all("mainttype").value=="C") location = "/CRM/CRMMaintenance.jsp?mainttype=C";
		if(document.all("mainttype").value=="R") location = "/proj/ProjMaintenance.jsp?mainttype=R";
		if(document.all("mainttype").value=="F") location = "/fna/FnaMaintenance.jsp?mainttype=F";
		if(document.all("mainttype").value=="I") location = "/cpt/CptMaintenance.jsp?mainttype=I";
	}
	</script>
		</TD>
	</TR>
</TABLE>
<%}%>
</DIV>
<TABLE class=Form>
  <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%"> <TBODY> 
  <TR> 
    <TD vAlign=top> 
      <TABLE width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></TH>
        </TR>
        <TR class=Separator> 
          <TD class=sep1></TD>
        </TR>
        <tr> 
          <td><a 
            href="capital/CptCapitalAdd.jsp"><%=SystemEnv.getHtmlLabelName(1509,user.getLanguage())%></a></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/CptAssortment.jsp"><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></a></td>
		  </tr>		
		<tr> 
          <td><a 
          href="/cpt/capital/CptCapitalManage.jsp"><%=SystemEnv.getHtmlLabelName(2116,user.getLanguage())%></a></td>
        </tr>

		<!--tr> 
          <td><a 
          href="/workflow/request/RequestType.jsp"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())+SystemEnv.getHtmlLabelName(129,user.getLanguage())%></a></td>
        </tr -->

        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top> 
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td><a 
          href="/base/ffield/ListCptFreeField.jsp"><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></a></td>
        </tr>
        </tbody> 
      </table>
    </TD>
  </TR>
  <TR> 
    <TD vAlign=top> 
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td><a href="maintenance/CptCapitalType.jsp"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></a></td>
       </tr>
        <tr> 
          <td><a href="maintenance/CptCapitalState.jsp"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></a></td>
        </tr>
        <tr> 
          <td><a href="../lgc/maintenance/LgcAssetUnit.jsp"><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></a></td>
        </tr>
        <!--tr> 
          <td><a href="maintenance/CptDepreMethod.jsp"><%=SystemEnv.getHtmlLabelName(1359,user.getLanguage())%></a></td>
        </tr-->
        </tbody> 
      </table>
    </TD>
    <TD></TD>
    <TD vAlign=top> </TD>
  </TR>
  
  </TBODY> 
</TABLE>
</BODY>
</html>
