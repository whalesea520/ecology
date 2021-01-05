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
String titlename = SystemEnv.getHtmlLabelName(1312,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String sqlstr = "select  t1.departmentid,t3.name,t3.capitalspec,t2.number_n,t2.unitprice,t2.amount,t2.purpose,t3.id as cptid  from bill_CptPlanMain  t1,bill_CptPlanDetail  t2,CptCapital  t3  where t1.id = t2.cptplanid and t2.cptid=t3.id and t1.groupid=11  order by t1.departmentid desc" ;
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
  <td><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15478,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15479,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
  </tr>
    <TR class=Line><TD colspan="7" ></TD></TR> 
<%
boolean islight=true;
float totalamount=0;
float totaldeptamount=0;
String curdept="";
while(RecordSet.next()){
	String department=DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid"));
	String name=RecordSet.getString("name");
	String capitalspec=RecordSet.getString("capitalspec");
	String number=RecordSet.getString("number_n");
	String unitprice=RecordSet.getString("unitprice");
	String amount=RecordSet.getString("amount");	
	String purpose=RecordSet.getString("purpose");
	totalamount += Util.getFloatValue(Util.null2String(amount),0);
	if(department.equals(curdept)){
		totaldeptamount += Util.getFloatValue(Util.null2String(amount),0);
		department="";
	}else{
		if(!curdept.equals("")) {
%>
<TR CLASS=DataDark>

  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td CLASS=fontred><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>：</td>
  <td CLASS=fontred><%=totaldeptamount%></td>
  <td></td>
</TR>
<%
		}
		totaldeptamount = Util.getFloatValue(Util.null2String(amount),0);	
		curdept = department;
	}
%>
<TR CLASS=DataDark>

  <td><%=department%></td>
  <td><%=name%></td>
  <td><%=capitalspec%></td>
  <td><%=number%></td>
  <td><%=unitprice%></td>
  <td><%=amount%></td>
  <td><%=purpose%></td>
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
  <td CLASS=fontred><%=totaldeptamount%></td>
  <td></td>
</TR>
<TR CLASS=DataDark>

  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td CLASS=fontred><%=SystemEnv.getHtmlLabelName(15477,user.getLanguage())%>：</td>
  <td CLASS=fontred><%=totalamount%></td>
  <td></td>
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