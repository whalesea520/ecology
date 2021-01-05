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
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
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

String planDate="";

String status="";
String strStatus = "";

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


//if (Rights.getRights(CurrentUser,"","",""))
{//权限判断

//个人计划
RecordSet.execute("select workPlan.* ,a.planName,g.status as statuss  from workPlan left join (select id,status from workPlanGroup) g on g.id=workPlan.groupId left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where workPlan.objId="+objId+" and workPlan.cycle='"+type+"' and workPlan.planDate='"+planDate+"' and workPlan.type_n='6' and workPlan.planType='"+type_d+"' order by workPlan.id ");

//out.print("select workPlan.* ,a.planName,g.status as statuss  from workPlan left join workPlanGroup g on g.id=workPlan.groupId left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where objId="+objId+" and cycle='"+type+"' and planDate='"+planDate+"' and type_n='6'");
String tobjId="/"+objId;
//上游部门的计划 //and workPlan.planType='"+type_d+"'取消
RecordSetu.execute("select WorkPlan.*, a.planName , b.status AS statusu, b.id AS downid FROM HrmPerformancePlanDown b LEFT OUTER JOIN WorkPlan ON WorkPlan.id = b.planId LEFT OUTER JOIN HrmPerformancePlanKindDetail a ON a.id = WorkPlan.planProperty where b.objId="+objId+" and workPlan.cycle='"+type+"' and planDate='"+planDate+"' and type_n='6'  and (workPlan.status!='3' and workPlan.status!='7') order by workPlan.id ");
//out.print("select WorkPlan.*, a.planName , b.status AS statusu, b.id AS downid FROM HrmPerformancePlanDown b LEFT OUTER JOIN WorkPlan ON WorkPlan.id = b.planId LEFT OUTER JOIN HrmPerformancePlanKindDetail a ON a.id = WorkPlan.planProperty where b.objId="+objId+" and workPlan.cycle='"+type+"' and planDate='"+planDate+"' and type_n='6'  and (workPlan.status!='3' or workPlan.status!='7') ");
//下游部门的计划  and workPlan.planType='"+type_d+"' 取消
if (RecordSetd.getDBType().equals("oracle")||RecordSetd.getDBType().equals("db2"))
{
RecordSetd.execute("select workPlan.* ,a.planName from workPlan left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where (upPrincipal like '%"+tobjId+",%' or ','||cowork||',' like '%,"+objId+",%') and cycle='"+type+"' and planDate='"+planDate+"' and type_n='6' order by workPlan.id ");
}
else
{
RecordSetd.execute("select workPlan.* ,a.planName from workPlan left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where (upPrincipal like '%"+tobjId+",%' or ','+cowork+',' like '%,"+objId+",%') and cycle='"+type+"' and planDate='"+planDate+"' and type_n='6' order by workPlan.id ");
}

boolean flag=false;
  flag=RecordSet.next();
   
  if (flag) {
  status=Util.null2String(RecordSet.getString("statuss"));
 }
 String pName1="";
 pName1=years+SystemEnv.getHtmlLabelName(445,user.getLanguage());
  if (type.equals("1")) {pName1+=quarters+SystemEnv.getHtmlLabelName(17495,user.getLanguage());}
  else if (type.equals("2")){pName1+=months+SystemEnv.getHtmlLabelName(6076,user.getLanguage());}
  else if (type.equals("3")){pName1+=weeks+SystemEnv.getHtmlLabelName(1926,user.getLanguage());}
  pName1+=SystemEnv.getHtmlLabelName(407,user.getLanguage());
 String pName=objName+pName1; 
  
  
   //有部门权限的人，可以从已审批计划中选择成为部门计划（部门计划必须还没有审批）
   //有分部权限的人，可以从已审批计划中选择成为分部计划（分部计划必须还没有审批）
     String depId="";
     String braId=""; 
     boolean flag1=false;
     boolean flag2=false;
   if (type_d.equals("3")) {
      depId=ResourceComInfo.getDepartmentID(objId);
      rs1.execute("select status from workPlanGroup where objId="+depId+" and cycle='"+type+"' and planDate='"+planDate+"' and type_d='2'");
      rs1.next();
     
      if (rs1.getString(1).equals("")||rs1.getString(1).equals("3")||rs1.getString(1).equals("7"))
      { 
        if (Rights.getRights(user,depId,"2","DepartmentPlan:Performance","1"))
        {
        flag1=true;
        }
      }
   }
   if (type_d.equals("2")) {
      braId=DepartmentComInfo.getSubcompanyid1(objId);
       rs1.execute("select status from workPlanGroup where objId="+depId+" and cycle='"+type+"' and planDate='"+planDate+"' and type_d='2'");
      rs1.next();
      if (rs1.getString(1).equals("")||rs1.getString(1).equals("3")||rs1.getString(1).equals("7"))
      {
        if (Rights.getRights(user,braId,"1","BranchPlan:Performance","1"))
        {
        flag2=true;
        }
      }
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
 enablemenu();
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
String titlename = SystemEnv.getHtmlLabelName(18181,user.getLanguage());
String imagefilename = "/images/hdHRM.gif";
%>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

//个人menu
if ((status.equals("3")||status.equals("")||status.equals("7"))&&(objId.equals(CurrentUser)))
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",PlanAdd.jsp?pName="+pName+"&type="+type+"&planDate="+planDate+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if ((status.equals("3")||status.equals("7"))&&(objId.equals(CurrentUser)))
{

RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18225,user.getLanguage())+",javaScript:OnSubmit1(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:del(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//部门menu
if ((status.equals("3")||status.equals("")||status.equals("6")||status.equals("7"))&&type_d.equals("2")&&Rights.getRights(user,objId,type_d,"DepartmentPlan:Performance","1"))
{RCMenuWidth=140;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",PlanAdd.jsp?pName="+pName+"&type="+type+"&planDate="+planDate+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18213,user.getLanguage())+",ImportPlan.jsp?pName="+pName+"&years="+years+"&type="+type+"&planDate="+planDate+"&months="+months+"&weeks="+weeks+"&quarters="+quarters+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(216,user.getLanguage())+",javaScript:unites(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:del(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if ((status.equals("3")||status.equals("7"))&&type_d.equals("2")&&Rights.getRights(user,objId,type_d,"DepartmentPlan:Performance","1"))
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18225,user.getLanguage())+",javaScript:OnSubmit1(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

}

//分部menu
if ((status.equals("3")||status.equals("")||status.equals("7"))&&type_d.equals("1")&&Rights.getRights(user,objId,type_d,"BranchPlan:Performance","1"))
{RCMenuWidth=140;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",PlanAdd.jsp?pName="+pName+"&type="+type+"&planDate="+planDate+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18217,user.getLanguage())+",ImportPlan.jsp?pName="+pName+"&years="+years+"&type="+type+"&planDate="+planDate+"&months="+months+"&weeks="+weeks+"&quarters="+quarters+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(216,user.getLanguage())+",javaScript:unites(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:del(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if ((status.equals("3")||status.equals("7"))&&type_d.equals("1")&&Rights.getRights(user,objId,type_d,"BranchPlan:Performance","1"))
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18225,user.getLanguage())+",javaScript:OnSubmit1(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

//直接倒入成上级部门计划menu
if ((type_d.equals("3")&&flag1&&status.equals("6"))) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(18218,user.getLanguage())+",javaScript:imports(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//直接倒入成上级分部计划menu
if ((type_d.equals("2")&&flag2&&status.equals("6"))) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(18219,user.getLanguage())+",javaScript:imports(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<TABLE class=ListStyle  cellspacing="0" cellpadding="0" >
<tr>
<td valign="top">
<form name="planform" method="post" action="PlanOperation.jsp">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="importType" value="0" >
<input type="hidden" name="depId" value=<%=depId%> >
<input type="hidden" name="braId" value=<%=braId%>>
<input type="hidden" name="planDate" value=<%=planDate%>>
<input type="hidden" name="pName1" value=<%=pName1%>>
<%if (!type.equals("0")){%>
<TABLE  class=ListStyle cellspacing=1 id='monthHtmlTbl'>
  <COLGROUP>
  <COL width="100%">

  <TBODY>
  <TR >
  <td align="left">
  <%
  if (type.equals("2"))
  {
  for (int a=1;a<=12;a++)
  {%>
  <a href="MyPlan.jsp?type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=a%>">
  <%=a%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
  </a>&nbsp;
  <%}
  }
  else if (type.equals("1"))
  {
  for (int a=1;a<=4;a++)
  {%>
  <a href="MyPlan.jsp?type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&quarters=<%=a%>">
  <%=a%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%>
  </a>&nbsp;
  <%}
  }
   else if (type.equals("3"))
  {
  %>
  <select class=inputStyle id="weeks" name="weeks" onchange="javascript:location.href='MyPlan.jsp?type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&weeks='+this.value">
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
   else if (type.equals("3")){%><%=weeks%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><%}%><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%>
  </th>
  <input type="hidden" name="pName" value=<%=pName%>>
  
  </tr>
   <%
  
   if (flag) {%>
  <TR>
  <th align="center">(<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>:
  <%if (status.equals("3")) {%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>
  <%}
   else if (status.equals("4")||status.equals("5")){%><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%>
   <%}
   else if (status.equals("6")){%><%=SystemEnv.getHtmlLabelName(1009,user.getLanguage())%>
   <%}
   else if (status.equals("7")){%><%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%>
   <%}%>)
  </th>
  </tr>
  <%}%>
  </TBODY></TABLE>
    <!--个人计划-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%if (type_d.equals("3")){%><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%><%}%><%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
  </th>
  <th style="text-align:right;cursor:hand">
  <%if (type_d.equals("3")){%><span class="spanSwitch1" onclick="doSwitchx('showobj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span>
  <%}%>
  </th>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding: 0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>

<div id="showobj" style="display:">  
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
   <%if ((status.equals("3")||status.equals("7"))) {%>
   <COL width="5%">
   <%}%>
   <!--有部门权限的人，可以从已审批计划中选择成为部门计划（部门计划必须还没有审批）-->
   <!--有分部权限的人，可以从已审批计划中选择成为分部计划（分部计划必须还没有审批）-->
  
   <%if ((type_d.equals("3")&&flag1&&status.equals("6"))||(type_d.equals("2")&&flag2&&status.equals("6"))) {%>
   <COL width="5%">
   <%}%>
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="5%">
  <COL width="15%">
  <COL width="15%">
  <COL width="5%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
   <%if ((status.equals("3")||status.equals("7"))) {%>
    <th></th>
   <%}%>
   <!--有部门权限的人，可以从已审批计划中选择成为部门计划（部门计划必须还没有审批）-->
   <!--有分部权限的人，可以从已审批计划中选择成为分部计划（分部计划必须还没有审批）-->
   <%if ((type_d.equals("3")&&flag1&&status.equals("6"))||(type_d.equals("2")&&flag2&&status.equals("6"))) {%>
   <th></th>
   <%}%>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18185,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1008,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="10" ></TD></TR> 
<%
boolean isLight = false;
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
         <!--合并计划/删除计划-->
		<%if ((status.equals("3")||status.equals("7"))) {%>
 		<TD>
		<INPUT type="checkbox"  name="checkplan" value="<%=RecordSet.getString("id")%>">
		</TD>
		<%}%>
		<!--有部门权限的人，可以从已审批计划中选择成为部门计划（部门计划必须还没有审批）-->
        <!--有分部权限的人，可以从已审批计划中选择成为分部计划（分部计划必须还没有审批）-->
		<%if ((type_d.equals("3")&&flag1&&status.equals("6"))||(type_d.equals("2")&&flag2&&status.equals("6"))) {%>
	   <TD>
		<INPUT type="checkbox"  name="checkplan" value="<%=RecordSet.getString("id")%>">
		</TD>
	   <%}%>
		<TD>
		<%
		//TD
		//added by hubo, 2006-10-16
		String modifyStatus = Util.null2String(RecordSet.getString("modifyStatus"));
		String modifyUser = Util.null2String(RecordSet.getString("modifyUser"));
		int modifyUserManager = Util.getIntValue(ResourceComInfo.getManagerID(modifyUser));
		if(modifyStatus.equals("1")){
			strStatus = "(" + SystemEnv.getHtmlLabelName(2242,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage()) +")";
		}else if(modifyStatus.equals("2")){
			strStatus = "(" + SystemEnv.getHtmlLabelName(2242,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage()) +")";
		}else if(modifyStatus.equals("3")){
			strStatus = "(" + SystemEnv.getHtmlLabelName(2242,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(91,user.getLanguage()) +")";
		}else{
			strStatus = "";
		}
		if (((status.equals("3")||status.equals("6")||status.equals("7"))&&objId.equals(CurrentUser)&&modifyStatus.equals(""))||(((status.equals("3")||status.equals("")||status.equals("6")||status.equals("7"))&&type_d.equals("2")&&Rights.getRights(user,objId,type_d,"DepartmentPlan:Performance","1"))&&modifyStatus.equals(""))||(((status.equals("3")||status.equals("")||status.equals("6")||status.equals("7"))&&type_d.equals("1")&&Rights.getRights(user,objId,type_d,"BranchPlan:Performance","1"))&&modifyStatus.equals(""))){%>
		<a href="PlanEdit.jsp?id=<%=RecordSet.getString("id")%>&type=<%=type%>&planDate=<%=planDate%>">
		<%}else {%>
		<a href="#"   onclick="openFullWindow('PlanView.jsp?id=<%=RecordSet.getString("id")%>')">
		<%}
		%>
		<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a>
		<%if(user.getUID()==modifyUserManager){%>
		<div style="color:red;cursor:hand;text-decoration:underline" onclick="location.href='PlanRevision.jsp?id=<%=RecordSet.getString("id")%>&years=<%=years%>&months=<%=months%>&quarters=<%=quarters%>&weeks=<%=weeks%>&type=<%=type%>'"><%=strStatus%></div>
		<%}else{%>
		<div style="color:red"><%=strStatus%></div>
		<%}%>
		</TD>
		<TD><%=Util.toScreen(RecordSet.getString("planName"),user.getLanguage())%></TD>
		
		<TD><%=Util.toScreen(RecordSet.getString("rbeginDate"),user.getLanguage())%> <%=Util.toScreen(RecordSet.getString("rbeginTime"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("rendDate"),user.getLanguage())%> <%=Util.toScreen(RecordSet.getString("rendTime"),user.getLanguage())%></TD>
		<TD>
		<%
		if (!RecordSet.getString("principal").equals("")) {
				  String hrmName="";
				  ArrayList hrmIda=Util.TokenizerString(RecordSet.getString("principal"),",");
				  for (int k=0;k<hrmIda.size();k++)
				  {
				  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
				  }
				  out.print(hrmName);
				}
				%>
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
		 upHrms=upHrms+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+upHrmTemp.substring(0,upL)+">" +DepartmentComInfo.getDepartmentname(""+upHrmTemp.substring(0,upL))+"</a>/"+"<a href=/hrm/resource/hrmResource.jsp?id="+upHrmTemp.substring(upL+1,upHrmTemp.length())+">" +ResourceComInfo.getResourcename(""+upHrmTemp.substring(upL+1,upHrmTemp.length()))+"</a>"+" ";
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
		 dnHrms=dnHrms+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+dnHrmTemp.substring(0,upL)+">" +DepartmentComInfo.getDepartmentname(""+dnHrmTemp.substring(0,upL))+"</a>/"+"<a href=/hrm/resource/hrmResource.jsp?id="+dnHrmTemp.substring(upL+1,dnHrmTemp.length())+">" +ResourceComInfo.getResourcename(""+dnHrmTemp.substring(upL+1,dnHrmTemp.length()))+"</a>"+" ";
		 }
		 out.print(dnHrms);
		}
		%></TD>
		<TD>
		<%
		if (((status.equals("3")||status.equals("7"))&&objId.equals(CurrentUser))||(((status.equals("3")||status.equals("")||status.equals("7"))&&type_d.equals("2")&&Rights.getRights(user,objId,type_d,"DepartmentPlan:Performance","1")))||(((status.equals("3")||status.equals("")||status.equals("7"))&&type_d.equals("1")&&Rights.getRights(user,objId,type_d,"BranchPlan:Performance","1")))){%>
		<input type="text" class="inputstyle"  value="<%=RecordSet.getString("percent_n")%>" maxlength=3 size=3 name="percent_n" onchange="checkin(this);"><span id="pimage"></span>
		<input type="hidden" name="pId" value=<%=RecordSet.getString("id")%>>
		<%}else {%>
		<%=RecordSet.getString("percent_n")%>
		<%}%>
		</TD>
		<TD>
		<% if (!RecordSet.getString("downPrincipal").equals(""))
		  {if (!RecordSet.getString("status").equals("3")) {
		  if ((RecordSet.getString("status").equals("5"))||(RecordSet.getString("status").equals("6")))
		  {%>
		  <%=SystemEnv.getHtmlLabelName(18186,user.getLanguage())%>
		  <%}
		  else if (RecordSet.getString("status").equals("4")){
		  %>
		  <%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%>
		<%}}
		}%>
		</TD>
		
	</TR>
<%
	}while(RecordSet.next());
	}
%>
 </TABLE>
 </div>
 <!--个人计划结束-->
 <%if (type_d.equals("3")) {%>
  <!--上游计划-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18187,user.getLanguage())%>
  </th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch2" onclick="doSwitchx('showobjs','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding: 0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>

<div id="showobjs" style="display:">  
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="17%">
  <COL width="18%">
  <COL width="5%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(18188,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  
  <th></th>
  </tr>
 <TR class=Line><TD colspan="9" ></TD></TR> 
<%
 isLight = false;
    
	while(RecordSetu.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="#"  onclick="openFullWindow('PlanView.jsp?id=<%=RecordSetu.getString("id")%>')"><%=Util.toScreen(RecordSetu.getString("name"),user.getLanguage())%></a></TD>
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
		<TD><%
		String dnHrm=RecordSetu.getString("downPrincipal");
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
		<%
		if (RecordSetu.getString("statusu").equals("0")) {  
		//只有登录人是计划下游人才可以操作
		if (objId.equals(CurrentUser)) {%>
		<button type="button" id="addc" name="addc" class=AddDoc onclick="confirms('<%=RecordSetu.getString("id")%>','<%=RecordSetu.getString("downid")%>')"><%=SystemEnv.getHtmlLabelName(16634,user.getLanguage())%></button>
		<%}
		}
		if (RecordSetu.getString("statusu").equals("1")) {  
		%>
		  <%=SystemEnv.getHtmlLabelName(18189,user.getLanguage())%>
		  <%}%>
		</TD>
		
	</TR>
<%
	}
	
%>
 </TABLE>
 </div>
<!--上游计划-->
<!--下游计划-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
 <%=SystemEnv.getHtmlLabelName(18190,user.getLanguage())%>
  </th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch3" onclick="doSwitchx('showobjd','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing style="height: 1px;"> 
            <TD class=line1 colspan=2 style="padding:0px;"></TD>
          </TR>
  </TBODY>
  </TABLE>

<div id="showobjd" style="display:">  
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="17%">
  <COL width="18%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(18188,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  
  
  </tr>
 <TR class=Line><TD colspan="9" ></TD></TR> 
<%
 isLight = false;
    
	while(RecordSetd.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="#"  onclick="openFullWindow('PlanView.jsp?id=<%=RecordSetd.getString("id")%>')"><%=Util.toScreen(RecordSetd.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSetd.getString("planName"),user.getLanguage())%></TD>
		
		<TD><%=Util.toScreen(RecordSetd.getString("rbeginDate"),user.getLanguage())%> <%=Util.toScreen(RecordSetd.getString("rbeginTime"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSetd.getString("rendDate"),user.getLanguage())%> <%=Util.toScreen(RecordSetd.getString("rendTime"),user.getLanguage())%></TD>
		<TD>
		<%if (!RecordSetd.getString("principal").equals("")) {
				  String hrmName="";
				  ArrayList hrmIda=Util.TokenizerString(RecordSetd.getString("principal"),",");
				  for (int k=0;k<hrmIda.size();k++)
				  {
				  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
				  }
				  out.print(hrmName);
				}%>
         </TD>
		<TD>
		<%if (!RecordSetd.getString("cowork").equals("")) {
				  String hrmName="";
				  ArrayList hrmIda=Util.TokenizerString(RecordSetd.getString("cowork"),",");
				  for (int k=0;k<hrmIda.size();k++)
				  {
				  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
				  }
				  out.print(hrmName);
				}%>
         </TD>
		<TD>
		<%
		String upHrm=RecordSetd.getString("upPrincipal");
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
		String dnHrm=RecordSetd.getString("downPrincipal");
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
	</TR>
<%
	}
	
%>
 </TABLE>
 </div>
<!--下游计划-->
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
<script>
function OnSubmit()
{
document.planform.operationType.value="check";
document.planform.submit();
enablemenu();

}

function confirms(id,did)
{

document.all("addc").disabled=true;
location.href="PlanOperation.jsp?did="+did+"&id="+id+"&operationType=confirm&type=<%=type%>&planDate=<%=planDate%>";


}
function unites()
{
    var ch=0;
    var hnname = document.getElementsByName("checkplan"); 
    
    if (hnname.length>1)
    {
      for(i=0;i<hnname.length;i++)
      {
        if (document.planform.checkplan[i].checked==true)
        {
        ch++;
        }
      }
    } 
    if (hnname.length==1)
    {
    if (document.planform.checkplan.checked==true) ch++;
    }
    
    if(ch>0)
	{	document.planform.operationType.value="unite";
		document.planform.submit();
		enablemenu();
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
	else
	{
	alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>");
	return;
	}
}

function imports()
{
    var ch=0;
    var hnname = document.getElementsByName("checkplan"); 
    
    if (hnname.length>1)
    {
      for(i=0;i<hnname.length;i++)
      {
        if (document.planform.checkplan[i].checked==true)
        {
        ch++;
        }
      }
    } 
    if (hnname.length==1)
    {  
    if (document.planform.checkplan.checked==true) ch++;
    }
    
    if(ch>0)
	{	document.planform.operationType.value="choosePlan";
	    document.planform.importType.value="1";
		document.planform.submit();
		enablemenu();
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
	else
	{
	alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>");
	return;
	}
}


function OnSubmit1()
{

if (checkpercent())
{
document.planform.operationType.value="checkpercent";
document.planform.submit();
enablemenu();
}
}
function checkpercent()
{
per=0;

var lenn=document.getElementsByName("percent_n")

var  len=lenn.length;
if (len>1)
{
for(i=0;i<len;i++)
{
if (document.planform.percent_n[i].value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>');
return false;
}
else
{
per=per+parseInt(document.planform.percent_n[i].value);
}
}
}
if (len==1)
{
if (document.planform.percent_n.value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>');
return false;
}
else
{
per=parseInt(document.planform.percent_n.value);
}
}
if (per!=100)
{
alert('<%=SystemEnv.getHtmlLabelName(18212,user.getLanguage())%>');
return false;
}

return true;
}

function checkin(obj)
{
    valuechar = obj.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") isnumber = true ;}
	if(isnumber) obj.value = "" ;
}
function del()
{
    var ch=0;
    var hnname = document.getElementsByName("checkplan"); 
    
    if (hnname.length>1)
    {
      for(i=0;i<hnname.length;i++)
      {
        if (document.planform.checkplan[i].checked==true)
        {
        ch++;
        }
      }
    } 
    if (hnname.length==1)
    {
    if (document.planform.checkplan.checked==true) ch++;
    }
    
    if(ch>0)
	{	if (isdel())
        {
	    document.planform.operationType.value="del";
		document.planform.submit();
		enablemenu();
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	   }
	}
	else
	{
	alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>");
	return;
	}
}
</script>
</HTML>
    <%}
%>
