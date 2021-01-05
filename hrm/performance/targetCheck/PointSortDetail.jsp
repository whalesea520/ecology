<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsf" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsAdjust" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pointtree" class="weaver.hrm.performance.maintenance.TargetList" scope="page" />
<jsp:useBean id="ck" class="weaver.hrm.performance.targetcheck.CheckInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<%



String CurrentUser = ""+user.getUID();
String currentMonth=String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek=String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentQuarter="";
String years=Util.null2String(request.getParameter("years"));
String months=Util.null2String(request.getParameter("months"));
String quarters=Util.null2String(request.getParameter("quarters"));
String weeks=Util.null2String(request.getParameter("weeks"));
String monthss=Util.null2String(request.getParameter("monthss"));
String quarterss=Util.null2String(request.getParameter("quarterss"));
String weekss=Util.null2String(request.getParameter("weekss"));
String type=Util.null2String(request.getParameter("type")); //周期
String type_d=Util.null2String(request.getParameter("type_d")); //考核类型 分部/部门/个人
String planDate="";
String deptId=Util.null2String(request.getParameter("deptId"));
String branchId=Util.null2String(request.getParameter("branchId"));
String hrmId=Util.null2String(request.getParameter("hrmId"));
String requested=Util.null2String(request.getParameter("requested"));

if (weeks.equals(""))
{ 
if (weekss.equals(""))
weeks=currentWeek;
else
weeks=weekss;

}
if (months.equals(""))
{
if (monthss.equals("")) 
months=currentMonth;
else
months=monthss;
}

if ( 1<=Integer.parseInt(months)&& Integer.parseInt(months)<=3) currentQuarter="1";
if ( 4<=Integer.parseInt(months)&& Integer.parseInt(months)<=6) currentQuarter="2";
if ( 7<=Integer.parseInt(months)&& Integer.parseInt(months)<=9) currentQuarter="3";
if ( 10<=Integer.parseInt(months)&& Integer.parseInt(months)<=12) currentQuarter="4";
if (quarters.equals(""))
{
if (quarterss.equals(""))
quarters=currentQuarter;
else
quarters=quarterss;
}

if (type.equals("0"))
{
planDate=years;
}
else if (type.equals("2"))
{
planDate=years+months;
}
else if (type.equals("1"))
{
planDate=years+quarters;
}
else if (type.equals("3"))
{
planDate=years+"0";
}
else if (type.equals("4"))
{
planDate=years+"0";
}

String pName1="";
pName1=years+SystemEnv.getHtmlLabelName(445,user.getLanguage());
if (type.equals("1")) {pName1+=quarters+SystemEnv.getHtmlLabelName(17495,user.getLanguage());}
else if (type.equals("2")){pName1+=months+SystemEnv.getHtmlLabelName(6076,user.getLanguage());}
else if (type.equals("3")){pName1+=SystemEnv.getHtmlLabelName(18059,user.getLanguage());}
else if (type.equals("4")){pName1+=SystemEnv.getHtmlLabelName(18059,user.getLanguage());}
pName1+=SystemEnv.getHtmlLabelName(18267,user.getLanguage());

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:left;padding:0 2px 0 2px;color:#333}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>


<%
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javaScript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="planform" method="post" action="PointSortDetail.jsp" >
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="0">
<col width="">
<col width="5">

<tr>
<td ></td>
<td valign="top">

<TABLE class=ListStyle  cellspacing="0" cellpadding="0">
<tr>
<td valign="top">
<form name="planform" method="post" action="CheckOperation.jsp">
<input type="hidden" name="operationType">
<input type="hidden" name="monthss" value=<%=months%>>
<input type="hidden" name="weekss" value=<%=weeks%>>
<input type="hidden" name="quarterss" value=<%=quarters%>>
<input type="hidden" name="years" value=<%=years%>>
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="type_d" value=<%=type_d%>>
<input type="hidden" name="requested" value=1>
<%
if (type.equals("3")) type="4";
if (!type.equals("0")&&!type.equals("3")&&!type.equals("4")){%>
<TABLE  class=ListStyle cellspacing=1 id='monthHtmlTbl'>
  <COLGROUP>
  <COL width="100%">

  <TBODY>
  <TR>
  <td>
  <%
  if (type.equals("2"))
  {
  for (int a=1;a<=12;a++)
  {%>
  <a href="PointSortDetail.jsp?type=<%=type%>&type_d=<%=type_d%>&years=<%=years%>&months=<%=a%>">
  <%=a%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
  </a>&nbsp;
  <%}
  }
  else if (type.equals("1"))
  {
  for (int a=1;a<=4;a++)
  {%>
  <a href="PointSortDetail.jsp?type=<%=type%>&type_d=<%=type_d%>&years=<%=years%>&quarters=<%=a%>">
  <%=a%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%>
  </a>&nbsp;
  <%}
  }
   else if (type.equals("3"))
  {
 
  %>
 <select class=inputStyle id="weeks" name="weeks" onchange="javascript:location.href='PointSortDetail.jsp?type=<%=type%>&type_d=<%=type_d%>&years=<%=years%>&weeks='+this.value">
  <%for (int a=1;a<=56;a++)
  {%>
  <option value="<%=a%>" <%if (weeks.equals(String.valueOf(a))) {%>selected<%}%>><%=a%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></option>
  <%}%>
  </select><%}%>
  
  </td>
  
  </tr>
 <TR class=Line><TD colspan="3" ></TD></TR> 
 </TBODY></TABLE>
 <%}%>
  <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <!--tr><td>
  <%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><span class="spanSwitch1" style="cursor:hand"  onclick="doSwitchx('query')"><img src='/images/up.jpg'></span>
  </td></tr-->
  
  <TR>
  <td>
  <div id="query">
  <TABLE  class=ViewForm>
  <COLGROUP>
  
  <COL width=5%> <COL width=15%>
  <COL width=5%> <COL width=20%>
  <COL width=8%> <COL width=15%>
  <COL width=30%>
  <TBODY>
  <TR>
  <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
  <TD class=Field> 
    <input type="hidden" class="wuiBrowser" name="branchId" id="branchId" value="<%=branchId%>"
     _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
     _displayText="<%=SubCompanyComInfo.getSubCompanyname(branchId)%>"
     _displayTemplate="<A href='/hrm/company/HrmSubCompanyDsp.jsp?id=#b{id}' target='_blank'>#b{name}</A>"
    >
   </TD>
    <%
 
  if (type_d.equals("2")||type_d.equals("3")) {%>
  <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  <TD class=Field> 
    <input type="hidden" class="wuiBrowser" name="deptId" id="deptId" value="<%=deptId%>"
     _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
     _displayText="<%=DepartmentComInfo.getDepartmentname(deptId)%>"
     _displayTemplate="<A href='/hrm/company/HrmDepartmentDsp.jsp?id=#b{id}' target='_blank'>#b{name}</A>"
    >
   </TD>
   <%}%>
   <%if (type_d.equals("3")) {%>
  <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
  <TD class=Field> 
    <input type="hidden" class="wuiBrowser" name="hrmId" id="hrmId" value="<%=hrmId%>"
     _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
     _displayText="<%=ResourceComInfo.getLastname(hrmId)%>"
     _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}' target='_blank'>#b{name}</A>"
    >
   </TD>  <%}%>
   <%if (type_d.equals("1")) {%>
    <td></td> <td></td>
   <%}%>
   <%if (type_d.equals("2")) {%>
   <td></td>
   <%}%>
   <td></td>
  </tr>
  <TR class=Spacing style="height: 1px;">
 <TD class=Line1 colspan="9" style="padding: 0px;">
 </TD>
 </TR> 
  </TBODY></TABLE>
  </div>
  </td>
  </tr>
  </TBODY></TABLE>
  
  <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
  <th align="center">
  <%=pName1%>
  </th>
  </tr>
  </TBODY></TABLE>
 <%int i=1;
 boolean isLight = false;
 String sqlquery="";
 if (type_d.equals("1")) {
 if (branchId.equals("")||branchId.equals("0")) sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"'   order by point6 desc";
  else sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"'  and objId="+branchId+" order by point6 desc";
 
 rs1.execute(sqlquery);
 %>
 <TABLE class=ListStyle cellspacing=1 width="60%">
  <COLGROUP>
  <COL width="5%">
  <COL width="30%">
  <COL width="15%">
  
  <TBODY>
  <TR class=Header>
  <th></th>
  <th><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
 <TR class=Line>
 <TD colspan="11" >
 </TD>
 </TR> 
 <%
 while(rs1.next())  
	{   
	    String point=Util.null2String(rs1.getString("point6"));
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
    <%		}else{%>
	<TR CLASS=DataDark>
	<%}%>
	<td><%=i%></td>
	<td><%=SubCompanyComInfo.getSubCompanyname(DepartmentComInfo.getSubcompanyid1(rs1.getString("objId")))%></td>
	<td><%=Util.getPointValue(point,1,point)%></td>
<%i++;}%>
 </TBODY></TABLE>
 <%}%>
<%
 if (type_d.equals("2")) {
 if (deptId.equals("")||deptId.equals("0")) 
 {if (branchId.equals("")||branchId.equals("0"))
 sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"'   order by point6 desc";
 else   sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"'  and exists (select 'x' from HrnDepartment where subcompanyid1="+branchId+" and id=HrmPerformanceCheckPoint.objId) order by point6 desc";
 }
 else sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"'  and objId="+deptId+" order by point6 desc";
 
 rs1.execute(sqlquery);%>
 <TABLE class=ListStyle cellspacing=1 width="60%">
  <COLGROUP>
  <COL width="5%">
  <COL width="30%">
  <COL width="15%">
  
  <TBODY>
  <TR class=Header>
  <th></th>
  <th><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
 <TR class=Line>
 <TD colspan="11" >
 </TD>
 </TR> 
 <%i=1;
 while(rs1.next())  
	{   
	
	    String point=Util.null2String(rs1.getString("point6"));
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
    <%		}else{%>
	<TR CLASS=DataDark>
	<%}%>
	<td><%=i%></td>
	<td><%=DepartmentComInfo.getDepartmentname(rs1.getString("objId"))%></td>
	<td><%=Util.getPointValue(point,1,point)%></td>
<%i++;}%>
 </TBODY></TABLE>
 <%}%>
 <%
 if (type_d.equals("3")) {
 if (!hrmId.equals(""))
 { 
 sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"' and objId="+hrmId+" order by point6 desc";
 }
 else
 {
   if (!deptId.equals("")&&!deptId.equals("0")) sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"' and exists (select 'X' from HrmResource where HrmResource.departmentid="+deptId+" and HrmResource.id=HrmPerformanceCheckPoint.objId) order by point6 desc";
   else
   { 
   if  (!branchId.equals("")) sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"' and exists (select 'X' from HrmResource where HrmResource.subcompanyid1="+branchId+" and HrmResource.id=HrmPerformanceCheckPoint.objId) order by point6 desc";
   else   sqlquery="select * from HrmPerformanceCheckPoint where cycle='"+type+"' and checkType='"+type_d+"' and checkDate='"+planDate+"'  order by point6 desc";
   }
 }
 
 rs1.execute(sqlquery);
 %>
 <TABLE class=ListStyle cellspacing=1 width="60%">
  <COLGROUP>
  <COL width="5%">
  <COL width="10%">
  <COL width="20%">
  <COL width="10%">
  
  <TBODY>
  <TR class=Header>
  <th></th>
  <th><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
 <TR class=Line>
 <TD colspan="11" >
 </TD>
 </TR> 
 <%i=1;
 while(rs1.next())  
	{   
	
	    String point=Util.null2String(rs1.getString("point6"));
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
    <%		}else{%>
	<TR CLASS=DataDark>
	<%}%>
	<td><%=i%></td>
	<td><%=ResourceComInfo.getLastname(rs1.getString("objId"))%></td>
	<td><%=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(rs1.getString("objId")))%></td>
	<td><a style="cursor:hand" onclick=openFullWindow("MyCheckView.jsp?type=<%=type%>&type_d=<%=type_d%>&objId=<%=rs1.getString("objId")%>&months=<%=months%>&weeks=<%=weeks%>&years=<%=years%>&quarters=<%=quarters%>")><%=Util.getPointValue(point,1,point)%></a></td>
<%i++;}%>
 </TBODY></TABLE>
 <%}%>

 </td>
 </tr>
 </TABLE>
 <SCRIPT>
 function onSubmit()
 {
 document.planform.requested.value="2";
 document.planform.submit();
 enablemenu();
 }
 </SCRIPT>
  </form>
</BODY>
