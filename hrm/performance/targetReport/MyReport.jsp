<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ include file="/hrm/performance/common.jsp" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsg" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="check" class="weaver.hrm.performance.targetcheck.CheckInfo" scope="page" />
<%



String CurrentUser = ""+user.getUID();
String currentMonth=String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek=String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentQuarter="";
String years=Util.null2String(request.getParameter("years"));
String months=Util.null2String(request.getParameter("months"));
String quarters=Util.null2String(request.getParameter("quarters"));
String weeks=Util.null2String(request.getParameter("weeks"));
String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type=Util.null2String(request.getParameter("type")); //周期
String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
String objName=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String reportId="";
String planDate="";
String logs="";
String status="";
//得到评分标准中可评分的最低和最高分
String minPoint="0";
String maxPoint="100" ;
rs2.execute("select * from HrmPerformancePointRule");
if (rs2.next())
{
minPoint=rs2.getString("minPoint");
maxPoint=rs2.getString("maxPoint");
}

if (objId.equals("")) 
{
objId=CurrentUser;
type="0";
type_d="3";

}

if (weeks.equals(""))
{
weeks=currentWeek;
}
if (months.equals(""))
{
months=currentMonth;
}

if ( 1<=Integer.parseInt(months)&& Integer.parseInt(months)<=3) currentQuarter="1";
if ( 4<=Integer.parseInt(months)&& Integer.parseInt(months)<=6) currentQuarter="2";
if ( 7<=Integer.parseInt(months)&& Integer.parseInt(months)<=9) currentQuarter="3";
if ( 10<=Integer.parseInt(months)&& Integer.parseInt(months)<=12) currentQuarter="4";
if (quarters.equals(""))
{
quarters=currentQuarter;
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
planDate=years+weeks;
}
else if (type.equals("4"))
{
planDate=years+"0";
}
//当不是周/月报告时，根据考核方案确定是否需要述职报告
String deptId=ResourceComInfo.getDepartmentID(objId);
String postId=ResourceComInfo.getJobTitle(objId);
boolean flags=false;
String cycle=type;
if (cycle.equals("4")) cycle="3";
if (type_d.equals("3"))
{
if (rs2.getDBType().equals("oracle")||rs2.getDBType().equals("db2"))
{
rs2.execute("select * from HrmPerformanceCheckScheme a left join HrmPerformanceSchemeContent b on a.id=b.schemeId where b.type_c='2' and b.cycle='"+cycle+"' and (','||a.checkHrmId||',' like '%,"+objId+",%' or ','||checkpostId||',' like '%,"+postId+",%')");
}
else
{
rs2.execute("select * from HrmPerformanceCheckScheme a left join HrmPerformanceSchemeContent b on a.id=b.schemeId where b.type_c='2' and b.cycle='"+cycle+"' and (','+a.checkHrmId+',' like '%,"+objId+",%' or ','+checkpostId+',' like '%,"+postId+",%')");
}
if (rs2.next())
{
flags=true;
}
}
//if (Rights.getRights(CurrentUser,"","",""))
{//权限判断
if (type.equals("0"))  //年度报告（月汇总）
{

if (rs1.getDBType().equals("oracle")||rs1.getDBType().equals("db2"))
{
rs1.execute("select workPlan.*,b.planName,a.pointSelf,a.status as statusr,a.percent_n as perp from HrmPerformanceReport a left join workPlan on a.planId=workPlan.id left join HrmPerformancePlanKindDetail b on b.id=workPlan.planProperty where SubStr(a.reportDate,1,4)='"+planDate.substring(0,4)+"' and a.cycle='2' and a.reportType='"+type_d+"' and a.reportTypep='0' and a.objId="+objId);
}
else
{
rs1.execute("select workPlan.*,b.planName,a.pointSelf,a.status as statusr,a.percent_n as perp from HrmPerformanceReport a left join workPlan on a.planId=workPlan.id left join HrmPerformancePlanKindDetail b on b.id=workPlan.planProperty where SubString(a.reportDate,1,4)='"+planDate.substring(0,4)+"' and a.cycle='2' and a.reportType='"+type_d+"' and a.reportTypep='0' and a.objId="+objId);
}
}
if (type.equals("4"))  //年中报告（月汇总）
{
int minm=1;
int maxm=6;
if (rs1.getDBType().equals("oracle")||rs1.getDBType().equals("db2"))
{
rs1.execute("select workPlan.*,b.planName,a.pointSelf,a.status as statusr,a.percent_n as perp from HrmPerformanceReport a left join workPlan on a.planId=workPlan.id left join HrmPerformancePlanKindDetail b on b.id=workPlan.planProperty where SubStr(a.reportDate,1,4)='"+years+"'  and (substr(a.reportDate,5)>="+minm+" and substr(a.reportDate,5)<="+maxm+") and a.cycle='2' and a.reportType='"+type_d+"' and a.reportTypep='0' and a.objId="+objId);
}
else
{
rs1.execute("select workPlan.*,b.planName,a.pointSelf,a.status as statusr,a.percent_n as perp from HrmPerformanceReport a left join workPlan on a.planId=workPlan.id left join HrmPerformancePlanKindDetail b on b.id=workPlan.planProperty where SubString(a.reportDate,1,4)='"+years+"' and (substring(a.reportDate,5,2)>="+minm+" and substring(a.reportDate,5,2)<="+maxm+") and a.cycle='2' and a.reportTypep='0' and a.reportType='"+type_d+"' and a.objId="+objId);

}
}
if (type.equals("1"))  //季度报告（月汇总）
{
int minm=Integer.parseInt(quarters)*3-2;
int maxm=Integer.parseInt(quarters)*3;
if (rs1.getDBType().equals("oracle")||rs1.getDBType().equals("db2"))
{
rs1.execute("select workPlan.*,b.planName,a.pointSelf,a.status as statusr,a.percent_n as perp from HrmPerformanceReport a left join workPlan on a.planId=workPlan.id left join HrmPerformancePlanKindDetail b on b.id=workPlan.planProperty where SubStr(a.reportDate,1,4)='"+planDate.substring(0,4)+"'  and (substr(a.reportDate,5)>="+minm+" and substr(a.reportDate,5)<="+maxm+") and a.cycle='2' and a.reportType='"+type_d+"' and a.reportTypep='0' and a.objId="+objId);
}
else
{
rs1.execute("select workPlan.*,b.planName,a.pointSelf,a.status as statusr,a.percent_n as perp from HrmPerformanceReport a left join workPlan on a.planId=workPlan.id left join HrmPerformancePlanKindDetail b on b.id=workPlan.planProperty where SubString(a.reportDate,1,4)='"+planDate.substring(0,4)+"' and (substring(a.reportDate,5,2)>="+minm+" and substring(a.reportDate,5,2)<="+maxm+") and a.cycle='2' and a.reportTypep='0' and a.reportType='"+type_d+"' and a.objId="+objId);
//out.print("select workPlan.*,b.planName,a.pointSelf,a.status as statusr,a.percent_n as perp from HrmPerformanceReport a left join workPlan on a.planId=workPlan.id left join HrmPerformancePlanKindDetail b on b.id=workPlan.planProperty where SubString(a.reportDate,1,4)='"+planDate.substring(0,4)+"' and (substring(a.reportDate,5,2)>="+minm+" and substring(a.reportDate,5,2)<="+maxm+") and a.cycle='2' and a.reportTypep='0' and a.reportType='"+type_d+"' and a.objId="+objId);
}
}

RecordSet.execute("select workPlan.* ,a.planName ,f.id as reportId,f.pointSelf,e.reportLog,f.status as statusr,f.percent_n as perp from workPlan left join (select id,status from workPlanGroup) g on g.id=workPlan.groupId left join HrmPerformanceReport f on workPlan.id=f.planId   left join HrmPerformanceReportLog e on f.reportGroupId=e.id left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where workPlan.objId="+objId+" and workPlan.cycle='"+type+"' and workPlan.planDate='"+planDate+"' and workPlan.type_n='6' and workPlan.planType='"+type_d+"' and g.status='6' order by workPlan.id ");
//out.print("select workPlan.* ,a.planName ,f.id as reportId from workPlan left join (select id,status from workPlanGroup) g on g.id=workPlan.groupId left join HrmPerformanceReport f on workPlan.id=f.planId left join HrmPerformanceReportLog e on f.reportGroupId=e.id left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where workPlan.objId="+objId+" and workPlan.cycle='"+type+"' and workPlan.planDate='"+planDate+"' and workPlan.type_n='6' and workPlan.planType='"+type_d+"' and g.status='6' ");
 String pName1="";
 pName1=years+SystemEnv.getHtmlLabelName(445,user.getLanguage());
  if (type.equals("1")) {pName1+=quarters+SystemEnv.getHtmlLabelName(17495,user.getLanguage());}
  else if (type.equals("2")){pName1+=months+SystemEnv.getHtmlLabelName(6076,user.getLanguage());}
  else if (type.equals("3")){pName1+=weeks+SystemEnv.getHtmlLabelName(1926,user.getLanguage());}
  else if (type.equals("4")){pName1+=SystemEnv.getHtmlLabelName(18059,user.getLanguage());}
  String rName=objName+pName1;
  pName1+=SystemEnv.getHtmlLabelName(351,user.getLanguage());
  String pName=objName+pName1; 
  boolean flag=false;
  flag=RecordSet.next();
  //判断是否可以提交报告 
  if (flag) {
  logs=Util.null2String(RecordSet.getString("reportLog"));
  reportId=Util.null2String(RecordSet.getString("reportId"));
  } 
  else{
  //如果只有汇总没有月工作计划,则有汇总也可以递交报告，如果只需要述职报告也可以提交
  reportId="无";
  rsg.execute("select * from HrmPerformanceReportLog where objId="+objId+" and cycle='"+type+"' and reportDate='"+planDate+"' and reportType='"+type_d+"'");
  //out.print("select * from HrmPerformanceReportLog where objId="+objId+" and cycle='"+type+"' and reportDate='"+planDate+"' and reportType='"+type_d+"'");
  if (rsg.next())
  {
  logs=Util.null2String(rsg.getString("reportLog"));
  reportId=Util.null2String(rsg.getString("id"));

  }
  else
  {
  if (!check.getCheckType(type_d,objId,type,postId,user,"0","0"))
  { if (check.getCheckType(type_d,objId,type,postId,user,"0","1")||check.getCheckType(type_d,objId,type,postId,user,"2","0")||check.getCheckType(type_d,objId,type,postId,user,"1","0"))
  reportId="";
  }
  }
  }
 //补充下游打分 
boolean flagds=false; 
if (!type.equals("3")&&type_d.equals("3")&&!type.equals("4")) {//取消and workPlan.planType='"+type_d+"'
RecordSetu.execute("select WorkPlan.*, a.planName , WorkPlan.status AS statusu, b.id AS downid,c.point1, f.status as statusr,f.percent_n as perp FROM HrmPerformancePlanDown b LEFT OUTER JOIN WorkPlan ON WorkPlan.id = b.planId left join HrmPerformanceBeforePoint c on c.planId=WorkPlan.id left join HrmPerformanceReport f on workPlan.id=f.planId  LEFT OUTER JOIN HrmPerformancePlanKindDetail a ON a.id = WorkPlan.planProperty where b.objId="+objId+" and workPlan.cycle='"+type+"' and planDate='"+planDate+"' and type_n='6'  and WorkPlan.status='6' ");
//out.print("select WorkPlan.*, a.planName , WorkPlan.status AS statusu, b.id AS downid,c.point1, f.status as statusr,f.percent_n as perp FROM HrmPerformancePlanDown b LEFT OUTER JOIN WorkPlan ON WorkPlan.id = b.planId left join HrmPerformanceBeforePoint c on c.planId=WorkPlan.id left join HrmPerformanceReport f on workPlan.id=f.planId  LEFT OUTER JOIN HrmPerformancePlanKindDetail a ON a.id = WorkPlan.planProperty where b.objId="+objId+" and workPlan.cycle='"+type+"' and planDate='"+planDate+"' and type_n='6'  and WorkPlan.status='6' ");
  if (RecordSetu.next())
  {flagds=true;}
  }
  
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
<script language=javascript>
function confirms(id,cycle,planDate)
{
 document.planform.planId.value=id;
 document.planform.type.value=cycle;
 document.planform.planDate.value=planDate;
 document.planform.operationType.value="confirm";
 document.planform.submit();
}
function doScrolls()
  {  

   if (document.all("h1").style.display=="")
    {
    document.all("h1").style.display="none";
    document.all("h21").style.display="";
    document.all("h41").style.display="none";
    }
    else
    {
     document.all("h1").style.display="";
     document.all("h21").style.display="none";
     document.all("h41").style.display="none";
    }
    
  }
</script>
<%
String needfav ="1";
String needhelp ="";
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(330,user.getLanguage())+SystemEnv.getHtmlLabelName(351,user.getLanguage());

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//个人menu
if (reportId.equals("")&&(objId.equals(CurrentUser)))
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(18108,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

//部门menu
if ((reportId.equals(""))&&type_d.equals("2")&&Rights.getRights(user,objId,type_d,"DepartmentReport:Performance","2"))
{RCMenu += "{"+SystemEnv.getHtmlLabelName(18108,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
 RCMenuHeight += RCMenuHeightStep ;
}

//分部menu
if (reportId.equals("")&&type_d.equals("1")&&Rights.getRights(user,objId,type_d,"BranchReport:Performance","2"))
{RCMenu += "{"+SystemEnv.getHtmlLabelName(18108,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
 RCMenuHeight += RCMenuHeightStep ;
}
if (flagds&&objId.equals(CurrentUser)) //上游计划打分
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(18183,user.getLanguage())+SystemEnv.getHtmlLabelName(407,user.getLanguage())+SystemEnv.getHtmlLabelName(6072,user.getLanguage())+",javaScript:OnSubmitDown(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenuWidth=130;
}
titlename=pName;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="5">
<col width="">
<col width="5">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=ListStyle  cellspacing="0" cellpadding="0">
<tr>
<td valign="top">
<form name="planform" method="post" action="ReportOperation.jsp">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="importType" value="0" >
<input type="hidden" name="planDate" value=<%=planDate%>>
<input type="hidden" name="pName1" value=<%=pName1%>>
<input type="hidden" name="rName" value=<%=rName%>>
<%if (!type.equals("0")&&!type.equals("4")){%>
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
  <a href="MyReport.jsp?type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=a%>">
  <%=a%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
  </a>&nbsp;
  <%}
  }
  else if (type.equals("1"))
  {
  for (int a=1;a<=4;a++)
  {%>
  <a href="MyReport.jsp?type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&quarters=<%=a%>">
  <%=a%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%>
  </a>&nbsp;
  <%}
  }
   else if (type.equals("3"))
  {
  %>
  <select class=inputStyle id="weeks" name="weeks" onchange="javascript:location.href='MyReport.jsp?type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&weeks='+this.value">
  <%for (int a=1;a<=56;a++)
  {%>
  <option value="<%=a%>" <%if (weeks.equals(String.valueOf(a))) {%>selected<%}%>><%=a%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></option>
  <%}%>
  </select>
  <%}%>
  </td>
  </tr>
 <TR class=Line><TD colspan="3" ></TD></TR> 
 </TBODY></TABLE>
 <%}%>
 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
  <th align="center">
  
  <%=objName%><%=years%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%if (type.equals("1")) {%><%=quarters%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%><%}
  else if (type.equals("2")){%><%=months%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%}
   else if (type.equals("3")){%><%=weeks%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><%}
     else if (type.equals("4")){%><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%><%}%><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%>
  </th>
  <input type="hidden" name="pName" value=<%=pName%>>
  
  </tr>
  </TBODY></TABLE>
    <!--个人报告-->
  <%
  boolean isLight = false;
  if (!type.equals("4")) {%>
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%>
  </th>
 <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding: 0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>

<div id="showobj" style="display:">  
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="8%">
  <COL width="15%">
  <COL width="15%">
  <COL width="5%">
  <COL width="8%">
  <COL width="5%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18229,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="11" ></TD></TR> 
<%

    if (flag)
    {
	do 
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
    <%		}else{%>
	<TR CLASS=DataDark>
    <%		}%>

		<TD>
		<a href="#"   onclick="openFullWindow('/hrm/performance/targetPlan/PlanView.jsp?id=<%=RecordSet.getString("id")%>')">
		<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("planName"),user.getLanguage())%></TD>
		
		<TD><%=Util.toScreen(RecordSet.getString("rbeginDate"),user.getLanguage())%> <%=Util.toScreen(RecordSet.getString("rbeginTime"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("rendDate"),user.getLanguage())%> <%=Util.toScreen(RecordSet.getString("rendTime"),user.getLanguage())%></TD>
		<TD>
		<%if (!RecordSet.getString("principal").equals("")) {
				  String hrmName="";
				  ArrayList hrmIda=Util.TokenizerString(RecordSet.getString("principal"),",");
				  for (int k=0;k<hrmIda.size();k++)
				  {
				  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
				  }
				  out.print(hrmName);
				}%>
         </TD>
		<TD>
		<%
		String upHrm=RecordSet.getString("upPrincipal");
		if (!upHrm.equals("")) {
		String upHrms="";
		String upHrmTemp="";
		 ArrayList hrmIds=Util.TokenizerString(upHrm,",");
		 for (int j=0;j<hrmIds.size();j++)
		 {
		 upHrmTemp=(String)hrmIds.get(j);
		 int upL=upHrmTemp.indexOf("/");
		 upHrms=upHrms+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+upHrmTemp.substring(0,upL)+">" +DepartmentComInfo.getDepartmentname(""+upHrmTemp.substring(0,upL))+"</a>/"+"<a href=/hrm/resource/HrmResource.jsp?id="+upHrmTemp.substring(upL+1,upHrmTemp.length())+">" +ResourceComInfo.getResourcename(""+upHrmTemp.substring(upL+1,upHrmTemp.length()))+"</a>"+" ";
		 }
		 out.print(upHrms);
		}
		
		
		%>
		</TD>
		<TD><%
		String dnHrm=RecordSet.getString("downPrincipal");
		if (!dnHrm.equals("")) {
		String dnHrms="";
		String dnHrmTemp="";
		 ArrayList hrmIds=Util.TokenizerString(dnHrm,",");
		 for (int j=0;j<hrmIds.size();j++)
		 {
		 dnHrmTemp=(String)hrmIds.get(j);
		 int upL=dnHrmTemp.indexOf("/");
		 dnHrms=dnHrms+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+dnHrmTemp.substring(0,upL)+">" +DepartmentComInfo.getDepartmentname(""+dnHrmTemp.substring(0,upL))+"</a>/"+"<a href=/hrm/resource/HrmResource.jsp?id="+dnHrmTemp.substring(upL+1,dnHrmTemp.length())+">" +ResourceComInfo.getResourcename(""+dnHrmTemp.substring(upL+1,dnHrmTemp.length()))+"</a>"+" ";
		 }
		 out.print(dnHrms);
		}
		%></TD>
		<TD>
		<%=RecordSet.getString("percent_n")%>
		</TD>
		<TD>
		<input type="hidden" name="planIds" value="<%=RecordSet.getString("id")%>">
		<select name="status" onchange="showjd()">
		<option value="0" <% if (Util.null2String(RecordSet.getString("statusr")).equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18230,user.getLanguage())%></option>
		<option value="1" <% if (Util.null2String(RecordSet.getString("statusr")).equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%></option>
		<option value="2" <% if (Util.null2String(RecordSet.getString("statusr")).equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></option>
		<option value="3" <% if (Util.null2String(RecordSet.getString("statusr")).equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></option>
		</select>
		<% if (Util.null2String(RecordSet.getString("statusr")).equals("1")) {%>
		<div id="pers"  style="display:">
		<% }else {%>
		<div id="pers"  style="display:none">
		<%}%>
		<%=SystemEnv.getHtmlLabelName(847,user.getLanguage())%><input type="text" maxlength=4 size=4 onchange="checkin(this)" value="<%=Util.null2String(RecordSet.getString("perp"))%>" class="inputstyle" name="percent_n">%
		</div>
		</TD>
		<TD>
		<input type="text" class="inputstyle" name="pointSelf"  maxlength=4 size=4 onchange="checkin(this)" value=<%=Util.null2String(RecordSet.getString("pointself"))%> >
		</TD>
	</TR>
<%
	}while(RecordSet.next());
	}
%>
 </TABLE>
 </div>
 <%}%>
 <!--个人计划结束-->
 <%if (!type.equals("3")&&!type.equals("2")) {%>
  <!--个人报告汇总-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18236,user.getLanguage())%>
  </th>
 <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobjh','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding: 0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>

<div id="showobjh" style="display:">  
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="8%">
  <COL width="15%">
  <COL width="15%">
  <COL width="5%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  
  </tr>
 <TR class=Line><TD colspan="11" ></TD></TR> 
<%

    
	while(rs1.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
    <%		}else{%>
	<TR CLASS=DataDark>
    <%		}%>

		<TD>
		<a href="#"   onclick="openFullWindow('/hrm/performance/targetPlan/PlanView.jsp?id=<%=rs1.getString("id")%>')">
		<%=Util.toScreen(rs1.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(rs1.getString("planName"),user.getLanguage())%></TD>
		
		<TD><%=Util.toScreen(rs1.getString("rbeginDate"),user.getLanguage())%> <%=Util.toScreen(rs1.getString("rbeginTime"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(rs1.getString("rendDate"),user.getLanguage())%> <%=Util.toScreen(rs1.getString("rendTime"),user.getLanguage())%></TD>
		<TD>
		<%if (!rs1.getString("principal").equals("")) {
				  String hrmName="";
				  ArrayList hrmIda=Util.TokenizerString(rs1.getString("principal"),",");
				  for (int k=0;k<hrmIda.size();k++)
				  {
				  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
				  }
				   out.print(hrmName);
				}%>
         </TD>
		<TD>
		<%
		String upHrm=rs1.getString("upPrincipal");
		if (!upHrm.equals("")) {
		String upHrms="";
		String upHrmTemp="";
		 ArrayList hrmIds=Util.TokenizerString(upHrm,",");
		 for (int j=0;j<hrmIds.size();j++)
		 {
		 upHrmTemp=(String)hrmIds.get(j);
		 int upL=upHrmTemp.indexOf("/");
		 upHrms=upHrms+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+upHrmTemp.substring(0,upL)+">" +DepartmentComInfo.getDepartmentname(""+upHrmTemp.substring(0,upL))+"</a>/"+"<a href=/hrm/resource/hrmResource.jsp?id="+upHrmTemp.substring(upL+1,upHrmTemp.length())+">" +ResourceComInfo.getResourcename(""+upHrmTemp.substring(upL+1,upHrmTemp.length()))+"</a>"+" ";
		 }
		 out.print(upHrms);
		}
		
		
		%>
		</TD>
		<TD><%
		String dnHrm=rs1.getString("downPrincipal");
		if (!dnHrm.equals("")) {
		String dnHrms="";
		String dnHrmTemp="";
		 ArrayList hrmIds=Util.TokenizerString(dnHrm,",");
		 for (int j=0;j<hrmIds.size();j++)
		 {
		 dnHrmTemp=(String)hrmIds.get(j);
		 int upL=dnHrmTemp.indexOf("/");
		 dnHrms=dnHrms+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+dnHrmTemp.substring(0,upL)+">" +DepartmentComInfo.getDepartmentname(""+dnHrmTemp.substring(0,upL))+"</a>/"+"<a href=/hrm/resource/hrmResource.jsp?id="+dnHrmTemp.substring(upL+1,dnHrmTemp.length())+">" +ResourceComInfo.getResourcename(""+dnHrmTemp.substring(upL+1,dnHrmTemp.length()))+"</a>"+" ";
		 }
		 out.print(dnHrms);
		}
		%></TD>
		<TD>
		<%=rs1.getString("percent_n")%>
		</TD>
		<TD>
	<% if (Util.null2String(rs1.getString("statusr")).equals("0")) {%><%=SystemEnv.getHtmlLabelName(18230,user.getLanguage())%><%}%>
	<% if (Util.null2String(rs1.getString("statusr")).equals("1")) {%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><%}%>
	<% if (Util.null2String(rs1.getString("statusr")).equals("2")) {%><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%><%}%>
	<% if (Util.null2String(rs1.getString("statusr")).equals("3")) {%><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%><%}%>
		<% if (Util.null2String(rs1.getString("statusr")).equals("1")) {%>
		<%=SystemEnv.getHtmlLabelName(847,user.getLanguage())%><%=Util.null2String(rs1.getString("perp"))%>%
		<%}%>
		</TD>
		
	</TR>
<%
	}
	
%>
 </TABLE>
 </div>
 <!--个人报告汇总结束-->
   <%}
%>
  <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobjb','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding: 0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>
  <div id="showobjb">
  <table width="100%"><tr><td>
  <textarea rows="4" style="width:100%" name="reportLog"><%=logs%></textarea>
  </td></tr></table>
  </div>

<!--述职总结-->
<%if ((type.equals("0")||type.equals("1")||type.equals("4"))&&flags) {%>
<TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18062,user.getLanguage())%></th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobjs','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding: 0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>
  <div id="showobjs">
  <table><tr><td>
  <%String docIds="";
  
  rs2.execute("select * from HrmPerformanceReport where reportType='"+type_d+"' and cycle='"+type+"' and objId="+objId+" and reportDate='"+planDate+"' and reportTypep='1' ");
  if (rs2.next()) docIds=rs2.getString("docId");
  %>
  <BUTTON type="button" class="Browser" id="SelectMultiDoc" onclick="onShowMultiDocsNeeded('docid','docspan')"></BUTTON>    
	  <SPAN id="docspan">
	  <%
		if (!docIds.equals("")) {
			ArrayList docs = Util.TokenizerString(docIds, ",");
			for (int i = 0; i < docs.size(); i++) {
				%><A href='/docs/docs/DocDsp.jsp?id=<%=""+docs.get(i)%>' target="mainFrame"><%=docComInfo.getDocname("" + docs.get(i))%></A>&nbsp;
		<%
			}
		}
		else
		{
		%>
		<IMG src='/images/BacoError.gif' align=absMiddle>
		<%}%>
	  </SPAN>
	  <INPUT type="hidden" name="docid" value="<%=docIds%>" >
	  <INPUT type="hidden" name="reports" value="1" >
  </td></tr></table></div>
  <%}
  else
  {%>
  <INPUT type="hidden" name="reports" value="0" >
  <%}%>
</td>
</tr>
</TABLE>

<!--上游计划打分-->
<%if (!type.equals("3")&&type_d.equals("3")&&!type.equals("4")) {
//RecordSetu.execute("select WorkPlan.*, a.planName , WorkPlan.status AS statusu, b.id AS downid,c.point1 FROM HrmPerformancePlanDown b LEFT OUTER JOIN WorkPlan ON WorkPlan.id = b.planId left join HrmPerformanceBeforePoint c on c.planId=WorkPlan.id LEFT OUTER JOIN HrmPerformancePlanKindDetail a ON a.id = WorkPlan.planProperty where b.objId="+objId+" and workPlan.cycle='"+type+"' and planDate='"+planDate+"' and type_n='6' and workPlan.planType='"+type_d+"' and WorkPlan.statu='6' ");

%>
<TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6072,user.getLanguage())%></th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobjsd','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding: 0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>
  <div id="showobjsd">
  <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="17%">
  <COL width="15%">
  <COL width="8%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(18188,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="9" ></TD></TR> 
<%
 isLight = false;
 
    if (flagds)
    {
	do
	{   
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="#"  onclick="openFullWindow('/hrm/performance/targetPlan/PlanView.jsp?id=<%=RecordSetu.getString("id")%>')"><%=Util.toScreen(RecordSetu.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSetu.getString("planName"),user.getLanguage())%></TD>
		
		<TD><%=Util.toScreen(RecordSetu.getString("rbeginDate"),user.getLanguage())%> <%=Util.toScreen(RecordSetu.getString("rbeginTime"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSetu.getString("rendDate"),user.getLanguage())%> <%=Util.toScreen(RecordSetu.getString("rendTime"),user.getLanguage())%></TD>
		<TD>
		<%if (!RecordSetu.getString("cowork").equals("")) {
				  String hrmName="";
				  ArrayList hrmIda=Util.TokenizerString(RecordSetu.getString("cowork"),",");
				  for (int k=0;k<hrmIda.size();k++)
				  {
				  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
				  }
				   out.print(hrmName);
				}%>
         </TD>
		<TD>
		<%
		String upHrm=RecordSetu.getString("upPrincipal");
		if (!upHrm.equals("")) {
		String upHrms="";
		String upHrmTemp="";
		 ArrayList hrmIds=Util.TokenizerString(upHrm,",");
		 for (int j=0;j<hrmIds.size();j++)
		 {
		 upHrmTemp=(String)hrmIds.get(j);
		 int upL=upHrmTemp.indexOf("/");
		 upHrms=upHrms+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+upHrmTemp.substring(0,upL)+">" +DepartmentComInfo.getDepartmentname(""+upHrmTemp.substring(0,upL))+"</a>/"+"<a href=/hrm/resource/hrmResource.jsp?id="+upHrmTemp.substring(upL+1,upHrmTemp.length())+">" +ResourceComInfo.getResourcename(""+upHrmTemp.substring(upL+1,upHrmTemp.length()))+"</a>"+" ";
		 }
		 out.print(upHrms);
		}
		
		
		%>
		</TD>
		<TD>
	   <% if (Util.null2String(RecordSetu.getString("statusr")).equals("0")) {%><%=SystemEnv.getHtmlLabelName(18230,user.getLanguage())%><%}%>
	   <% if (Util.null2String(RecordSetu.getString("statusr")).equals("1")) {%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><%}%>
	   <% if (Util.null2String(RecordSetu.getString("statusr")).equals("2")) {%><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%><%}%>
	   <% if (Util.null2String(RecordSetu.getString("statusr")).equals("3")) {%><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%><%}%>
		
		<% if (Util.null2String(RecordSetu.getString("statusr")).equals("1")) {%>
		<div id="pers"  style="display:">
		<% }else {%>
		<div id="pers"  style="display:none">
		<%}%>
		<%=SystemEnv.getHtmlLabelName(847,user.getLanguage())%>:<%=Util.null2String(RecordSetu.getString("perp"))%>%
		</div></TD>
		<TD>
		<input class="inputstyle" maxlength=4 size=4 value="<%=RecordSetu.getString("point1")%>" name="pointDown" id="pointDown" onchange="checkin(this)">
		<input type="hidden" name="planIdDown" value="<%=RecordSetu.getString("id")%>">
		</TD>
		
	</TR>
<%
	} while(RecordSetu.next());
	}
	
%>

 </TABLE>
  </div>
  <%}%>
</td>
</tr>
</TABLE>
</form>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</BODY>
<SCRIPT language="VBS" src="/js/browser/DocsMultiBrowser.vbs"></SCRIPT>
<script>
function OnSubmit()
{
if (checkpoint())
{
if (document.planform.reports.value=="1")
{
if (document.planform.docid.value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18235,user.getLanguage())%>');
return ;
}
}
document.planform.operationType.value="check";
document.planform.submit();
enablemenu();
}
}
function OnSubmitDown()
{
if(checkDown())
{
document.planform.operationType.value="checkDown";
document.planform.submit();
enablemenu();
}
}
function showjd()
{
var lenn=document.getElementsByName("status").length;
if (lenn==1)
{
 if (document.planform.status.value=="1")
 {
 document.all("pers").style.display="";
 }
 else
 {
  document.all("pers").style.display="none";
 }
 }
 if (lenn>1)
 { 
 for (i=0;i<lenn;i++)
 {
 if (document.planform.status[i].value=="1")
 {
 document.all("pers")[i].style.display="";
 }
 else
 {
  document.all("pers")[i].style.display="none";
 }
 }
 }
}

function checkpoint()
{
var lenn=document.getElementsByName("pointSelf");

var  len=lenn.length;
if (len>1)
{
for(i=0;i<len;i++)
{
if (document.planform.pointSelf[i].value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18233,user.getLanguage())%>');
document.planform.pointSelf[i].focus();
return false;
}
else if  ((parseInt(document.planform.pointSelf[i].value)<=<%=minPoint%>)||(parseInt(document.planform.pointSelf[i].value)><%=maxPoint%>))
{
alert('<%=SystemEnv.getHtmlLabelName(18232,user.getLanguage())%>(<%=minPoint%>-<%=maxPoint%>)');
document.planform.pointSelf[i].focus();
return false;
}

}
}
if (len==1)
{
if (document.planform.pointSelf.value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18233,user.getLanguage())%>');
document.planform.pointSelf.focus();
return false;
}
else if  ((parseInt(document.planform.pointSelf.value)<=<%=minPoint%>)||(parseInt(document.planform.pointSelf.value)><%=maxPoint%>))
{
alert('<%=SystemEnv.getHtmlLabelName(18232,user.getLanguage())%>(<%=minPoint%>-<%=maxPoint%>)');
document.planform.pointSelf.focus();
return false;
}
}
var stlen=document.getElementsByName("status").length;
if (stlen>1)
{
for(i=0;i<stlen;i++)
if ((document.planform.status[i].value=="1"))
{
if (document.planform.percent_n[i].value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18234,user.getLanguage())%>');
document.planform.percent_n[i].focus();
return false;
}
}
}

if (stlen==1)
{
if ((document.planform.status.value=="1"))
if (document.planform.percent_n.value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18234,user.getLanguage())%>');
document.planform.percent_n.focus();
return false;
}
}
return true;


}

function checkin(obj)
{
    valuechar = obj.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) obj.value = "" ;
}
function checkDown()
{
var len=document.getElementsByName("pointDown").length;
if (len>1)
{
for(i=0;i<len;i++)
{
if (document.planform.pointDown[i].value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18243,user.getLanguage())%>');
document.planform.pointDown[i].focus();
return false;
}
else if  ((parseInt(document.planform.pointDown[i].value)<=<%=minPoint%>)||(parseInt(document.planform.pointDown[i].value)><%=maxPoint%>))
{
alert('<%=SystemEnv.getHtmlLabelName(18232,user.getLanguage())%>');
document.planform.pointDown[i].focus();
return false;
}

}
}
if (len==1)
{
if (document.planform.pointDown.value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18243,user.getLanguage())%>');
document.planform.pointDown.focus();
return false;
}
else if  ((parseInt(document.planform.pointDown.value)<=<%=minPoint%>)||(parseInt(document.planform.pointDown.value)><%=maxPoint%>))
{
alert('<%=SystemEnv.getHtmlLabelName(18232,user.getLanguage())%>');
document.planform.pointDown.focus();
return false;
}
}
return true;
}
</script>
</HTML>
    <%}
%>
