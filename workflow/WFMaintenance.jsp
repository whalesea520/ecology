
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

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
<%if(!software.equals("ALL")){%>
<%
String mainttype = Util.null2String(request.getParameter("mainttype"));
%>
	
<TABLE class="viewform">
	<TR>
		<TD align=right>
	<select class=inputstyle  name=mainttype onchange="changetype()">
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

<TABLE class="viewform" width="100%">
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR vAlign=top>
    <TD>
     <TABLE class="viewform">
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class="Title">
          <TH><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH></TR>
        <TR class="Spacing">
          <TD class="Line1"></TD>
        <TR>
          <TD><A HREF="/workflow/field/managefield.jsp"><%=SystemEnv.getHtmlLabelName(684,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A HREF="/workflow/form/manageform.jsp"><%=SystemEnv.getHtmlLabelName(699,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A HREF="/workflow/workflow/ListWorkType.jsp"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></A></TD></TR>
        <tr>
          <td><a href="/workflow/request/RequestType.jsp"><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></a></td></tr>
        <tr>
          <td><a href="/workflow/request/RequestUserDefault.jsp"><%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%></a></td></tr>
</TBODY></TABLE>
      <table class="viewform">
        <colgroup> <col width="100%"> <tbody> 
        <tr class="Title"> 
          <th><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></th>
        </tr>
        <tr class="Spacing"> 
          <td class="Line1"></td>
        <tr> 
          <td><a href="/workflow/report/ReportTypeManage.jsp"><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></a></td>
        </tr>
        <tr> 
          <td><a href="/workflow/report/ReportManage.jsp"><%=SystemEnv.getHtmlLabelName(15435,user.getLanguage())%></a></td>
        </tr>
<!--
        <tr> 
          <td><a href="/workflow/report/StaticReportManage.jsp"><%=SystemEnv.getHtmlLabelName(15436,user.getLanguage())%></a></td>
        </tr>
-->
        </tbody> 
      </table>
    </TD>
    <TD></TD>
    <TD>
      <TABLE class="viewform">
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class="Title">
          <TH><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TR>
        <TR class="Spacing">
          <TD class="Line1"></TD>
        <TR>
          <TD><A HREF="/workflow/workflow/managewf.jsp"><%=SystemEnv.getHtmlLabelName(15437,user.getLanguage())%></A></TD>
        </TR>
        <TR>
          <TD><A HREF="/workflow/request/WorkflowLayoutEdit.jsp"><%=SystemEnv.getHtmlLabelName(15438,user.getLanguage())%></A></TD>
        </TR>
<!--
        <TR>
          <TD><A HREF="/base/ffield/ListFreeField.jsp?tablename=b1">空闲字段:物品使用申请单</A></TD></TR>
          <TR>
          <TD><A HREF="/base/ffield/ListFreeField.jsp?tablename=b2">空闲字段:入库单</A></TD></TR>
          <TR>
          <TD><A HREF="/base/ffield/ListFreeField.jsp?tablename=b3">空闲字段:出库单</A></TD></TR>
          <TR>
          <TD><A HREF="/base/ffield/ListFreeField.jsp?tablename=b4">空闲字段:合同</A></TD></TR>
-->
</TBODY></TABLE>
<!--
      <table class="viewform">
        <colgroup> <col width="100%"> <tbody> 
        <tr class="Title"> 
          <th>费用月结</th>
        </tr>
        <tr class="Spacing"> 
          <td class="Line1"></td>
        <tr> 
          <td><a href="/workflow/monthfee/MonthFeeNamecard.jsp">名片印制</a></td>
        </tr>
        <tr> 
          <td><a href="/workflow/monthfee/MonthFeePlane.jsp">机票预定</a></td>
        </tr>
        <tr> 
          <td><a href="/workflow/monthfee/MonthFeeSNKD.jsp">市内快递</a></td>
        </tr>
        <tr> 
          <td><a href="/workflow/monthfee/MonthFeeEMS.jsp">特快专递</a></td>
        </tr>
        </tbody> 
      </table>
-->
</TD></TR>
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
