<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String curyear=Util.null2String(request.getParameter("curyear"));
String curmonth=Util.null2String(request.getParameter("curmonth"));
if(!curmonth.equals("") && curmonth.length()==1) curmonth="0"+curmonth;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;

if(curyear.equals("") || curyear.length()<4) curyear=(timestamp.toString()).substring(0,4);
if(curmonth.equals("")) curmonth=(timestamp.toString()).substring(5,7);

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1307,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String sqlstr = "select  t1.departmentid,t3.name,t3.capitalspec,t2.number_n,t2.unitprice,t2.amount,t2.purpose,t2.cptdesc,t2.needdate,t3.id as cptid  from bill_CptApplyMain  t1,bill_CptApplyDetail  t2,CptCapital  t3  where ( t1.id = t2.cptapplyid and t2.cptid=t3.id and substring(t2.needdate,1,4)='"+curyear+"' and substring(t2.needdate,6,2)='"+curmonth+"' ) order by t1.departmentid desc" ;
RecordSet.executeSql(sqlstr);
%>
<form name=weaver method=post action="CptApplyDeptRp.jsp">
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


<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
  <tr>
	<td align=center><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
	<td >
	  <input id=curyear class=Inputstyle size=6 name="curyear" value="<%=curyear%>" onKeyPress="ItemCount_KeyPress()" maxlength=4>-<input id=curmonth class=Inputstyle size=3 name="curmonth" value="<%=curmonth%>" onKeyPress="ItemCount_KeyPress()" maxlength=2>
	</td>
	<td align=center></td>
	<td >
	  
	</td>
  </tr>
</tbody>
</table>

<table class=liststyle cellspacing=1  >
<colgroup>

  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15474,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15475,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15476,user.getLanguage())%></td>
  </tr>
  <TR class=Line><TD colspan="9" ></TD></TR> 
<%
boolean islight=true;
float totalamount=0;
float totaldeptamount=0;
String curdept="";
while(RecordSet.next()){
	String department=DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid"));
	String name=RecordSet.getString("name");
	String cptdesc=RecordSet.getString("cptdesc");
	String capitalspec=RecordSet.getString("capitalspec");
	String number=RecordSet.getString("number_n");
	String unitprice=RecordSet.getString("unitprice");
	String amount=RecordSet.getString("amount");	
	String purpose=RecordSet.getString("purpose");
	String needdate=RecordSet.getString("needdate");
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
  <td></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>：</td>
  <td class=fontred><%=totaldeptamount%></td>
  <td></td>
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
  <td><%=cptdesc%></td>
  <td><%=capitalspec%></td>
  <td><%=unitprice%></td>
  <td><%=number%></td>
  <td><%=amount%></td>
  <td><%=purpose%></td>
  <td><%=needdate%></td>
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
  <td></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>：</td>
  <td class=fontred><%=totaldeptamount%></td>
  <td></td>
  <td></td>
</TR>
<TR CLASS=DataDark>

  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15477,user.getLanguage())%>：</td>
  <td class=fontred><%=totalamount%></td>
  <td></td>
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


</form>
</body>
</html>