<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1315,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String sqlstr = "select  t1.departmentid,t3.name,t3.mark,t3.capitalspec,t2.number_n,t2.unitprice,t2.amount,t2.purpose,t3.id as cptid  from bill_CptPlanMain  t1,bill_CptPlanDetail  t2,CptCapital  t3  where t1.id = t2.cptplanid and t2.cptid=t3.id and t1.groupid=2  order by t1.departmentid desc" ;
RecordSet.executeSql(sqlstr);
%>
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

<table class=liststyle cellspacing=1  >
<colgroup>

  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15478,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15479,user.getLanguage())%></td>
  </tr>
      <TR class=Line><TD colspan="6" ></TD></TR> 
<%
boolean islight=true;
float totalamount=0;
while(RecordSet.next()){
	String department=DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid"));
	String name=RecordSet.getString("name");
	String mark=RecordSet.getString("mark");
	String capitalspec=RecordSet.getString("capitalspec");
	String number=RecordSet.getString("number_n");
	String unitprice=RecordSet.getString("unitprice");
	String amount=RecordSet.getString("amount");	
	String purpose=RecordSet.getString("purpose");
	totalamount += Util.getFloatValue(Util.null2String(amount),0);
%>

<TR  CLASS=DataDark>

  <td><%=mark%></td>
  <td><%=name%></td>
  <td><%=capitalspec%></td>
  <td><%=number%></td>
  <td><%=unitprice%></td>
  <td><%=amount%></td>
</TR>
<%
	islight=!islight;
}
%>
<TR CLASS=DataDark>

  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td CLASS=fontred><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>：</td>
  <td CLASS=fontred><%=totalamount%></td>
</TR>
</table>
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