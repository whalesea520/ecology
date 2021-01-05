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
String type=Util.null2String(request.getParameter("type"));
if(type.equals("")) type="1";
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1302,user.getLanguage());
if(type.equals("2")){
	titlename = SystemEnv.getHtmlLabelName(1303,user.getLanguage());
}else if(type.equals("3")){
	titlename = SystemEnv.getHtmlLabelName(1304,user.getLanguage());
}
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




<%
int Department=Util.getIntValue(request.getParameter("Department"),0);
int OldDepartment=Util.getIntValue(request.getParameter("OldDepartment"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;

String sqlwhere="";
if(Department!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.departmentid="+Department;
	else	sqlwhere+=" and t1.departmentid="+Department;
}
if(OldDepartment!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.olddepartmentid="+OldDepartment;
	else	sqlwhere+=" and t1.olddepartmentid="+OldDepartment;
}

/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.agentid!='' and  t1.agentid!='0'";
	else 	sqlwhere+=" and  t1.agentid!='' and  t1.agentid!='0'";
}
*/
String sqlstr = "";
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}

String temptable = "temptable"+ Util.getNumberRandom() ;
if(RecordSet.getDBType().equals("oracle")){
	sqlstr = "create table "+temptable+"  as select * from (select  t1.departmentid,t1.olddepartmentid,t3.name,t3.mark,t3.capitalspec,t2.number_n,t3.startprice,t3.stateid,t2.purpose,t1.relatereq,t3.id as cptid from bill_CptAdjustMain  t1,bill_CptAdjustDetail  t2,CptCapital  t3  " + sqlwhere + " and t1.id = t2.cptadjustid and t2.cptid=t3.id order by t1.relatereq desc ) where rownum<"+ (pagenum*perpage+2);
}else{
	sqlstr = "select top "+(pagenum*perpage+1)+" t1.departmentid,t1.olddepartmentid,t3.name,t3.mark,t3.capitalspec,t2.number_n,t3.startprice,t3.stateid,t2.purpose,t1.relatereq,t3.id as cptid into "+temptable+" from bill_CptAdjustMain  t1,bill_CptAdjustDetail  t2,CptCapital  t3  " + sqlwhere + " and t1.id = t2.cptadjustid and t2.cptid=t3.id order by t1.relatereq desc" ;
}

RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(*) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by relatereq) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by relatereq ";
}
RecordSet.executeSql(sqltemp);
%>
<form name=weaver method=post action="CptTransRp.jsp">
  <input type="hidden" name="pagenum" value=''>
  <input type="hidden" name="type" value='<%=type%>'>

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
  <%if(!user.getLogintype().equals("2")){%>
	<%if(!type.equals("2")){%>
	<td align=center><%=SystemEnv.getHtmlLabelName(15480,user.getLanguage())%></td>
	<td class=field>
	  <button type='button' class=Browser id=SelectDeparment onClick="onShowDepartment()"></button>   
	             <span class=Inputstyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+Department),user.getLanguage())%></span>              <input id=Department type=hidden name="Department" value="<%=Department%>">
	</td>
	<%}%>
	<%if(!type.equals("3")){%>
	<td align=center><%=SystemEnv.getHtmlLabelName(15481,user.getLanguage())%></td>
	<td class=field>
	  <button type='button' class=Browser id=SelectOldDeparment onClick="onShowOldDepartment()"></button>              <span class=Inputstyle id=olddepartmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+OldDepartment),user.getLanguage())%></span>              <input id=OldDepartment type=hidden name="OldDepartment" value="<%=OldDepartment%>">
	</td>
	<%}%>
  <%}%>
  </tr>
</tbody>
</table>
<table class=liststyle cellspacing=1  >
<colgroup>

  <tr class=header>
<%if(!type.equals("2")){%>
  <td><%=SystemEnv.getHtmlLabelName(15480,user.getLanguage())%></td>
<%}%>
<%if(!type.equals("3")){%>
  <td><%=SystemEnv.getHtmlLabelName(15481,user.getLanguage())%></td>
<%}%>
  <td><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(903,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15482,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15483,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15484,user.getLanguage())%></td>
  </tr>
  <TR class=Line><TD colspan="9" ></TD></TR> 
<%
boolean islight=true;
int totalline=1;
if(RecordSet.last()){
	do{
	String department=DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid"));
	String olddepartment=DepartmentComInfo.getDepartmentname(RecordSet.getString("olddepartmentid"));
	String name=RecordSet.getString("name");
	String mark=RecordSet.getString("mark");
	String capitalspec=RecordSet.getString("capitalspec");
	String number=RecordSet.getString("number_n");
	String startprice=RecordSet.getString("startprice");
	String state=CapitalStateComInfo.getCapitalStatename(RecordSet.getString("stateid"));	
	String purpose=RecordSet.getString("purpose");
%>

<TR CLASS=DataDark>
<%if(!type.equals("2")){%>
  <td><%=department%></td>
<%}%>
<%if(!type.equals("3")){%>
  <td><%=olddepartment%></td>
<%}%>
  <td><%=name%></td>
  <td><%=mark%></td>
  <td><%=capitalspec%></td>
  <td><%=number%></td>
  <td><%=startprice%></td>
  <td><%=state%></td>
  <td><%=purpose%></td>
</TR>
<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
}
RecordSet.executeSql("drop table "+temptable);
%>
</table>
<table align=right>
<tr>
   <td>&nbsp;</td>
   <td>
	   <%if(pagenum>1){%>
	   
	   <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",CptTransRp.jsp?pagenum="+(pagenum-1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
	   	   <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",CptTransRp.jsp?pagenum="+(pagenum+1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%> <%}%>
   </td>
   <td>&nbsp;</td>
</tr>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&weaver.Department.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	weaver.Department.value=id(0)
	else
	departmentspan.innerHtml = ""
	weaver.Department.value="0"
	end if
	end if
end sub

sub onShowOldDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&weaver.OldDepartment.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	olddepartmentspan.innerHtml = id(1)
	weaver.OldDepartment.value=id(0)
	else
	olddepartmentspan.innerHtml = ""
	weaver.OldDepartment.value="0"
	end if
	end if
end sub
</script>
</body>
</html>