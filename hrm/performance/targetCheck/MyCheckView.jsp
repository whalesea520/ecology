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
String objId=Util.null2String(request.getParameter("objId"));
String type=Util.null2String(request.getParameter("type")); //周期
String type_d=Util.null2String(request.getParameter("type_d")); //计划所有者类型
String objName=ResourceComInfo.getLastname(objId);
String reportId="";
String planDate="";
String logs="";
String status="";
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
planDate=years+"0";
}
else if (type.equals("4"))
{
planDate=years+"0";
}


int i=0;
String checkDate=planDate;
String cycle=type;
String checkType=type_d;
String type_c=""; //0:目标考核；1：综合素质 2:述职报告
String item="";   //0工作计划 1:月汇总
String gradeName="";
String postId=""+ResourceComInfo.getJobTitle(""+user.getUID()); //得到登陆用户的岗位id
String postIdo=""+ResourceComInfo.getJobTitle(objId); //得到考核用户的岗位id
String pName1="";
pName1=years+SystemEnv.getHtmlLabelName(445,user.getLanguage());
if (type.equals("1")) {pName1+=quarters+SystemEnv.getHtmlLabelName(17495,user.getLanguage());}
else if (type.equals("2")){pName1+=months+SystemEnv.getHtmlLabelName(6076,user.getLanguage());}
else if (type.equals("3")){pName1+=SystemEnv.getHtmlLabelName(18059,user.getLanguage());}
else if (type.equals("4")){pName1+=SystemEnv.getHtmlLabelName(18059,user.getLanguage());}
pName1+=SystemEnv.getHtmlLabelName(15703,user.getLanguage());
gradeName=objName+pName1; 
//判断是否有查看权限（根据考核方案）
String ckeckId=""+ck.getCheckMId(checkType,objId,postIdo);
if (objId.equals(""+user.getUID())||ck.getViewCheck(ckeckId,postId,CurrentUser,objId,checkType))
{	
String pointIds="";
	 
//得到评分标准中可评分的最低和最高分
String minPoint="0";
String maxPoint="100" ;
String pointMethod=""; //评分方式 0：依据评分标准 1：手工评分
//评分模式 If pointMethod=0 (1:允许调整，0：不允许调整)If pointMethod=1(0;不用总分评定模式1：起用总分评定模式)
String pointModul=""; 

rs2.execute("select * from HrmPerformancePointRule");
if (rs2.next())
{
minPoint=rs2.getString("minPoint");
maxPoint=rs2.getString("maxPoint");
pointMethod=rs2.getString("pointMethod");
pointModul=rs2.getString("pointModul");
}

//得到分数
String point1="";
String point2="";
String point3="";
String point4="";
String point5="";
String point6="";
String point8="";
String pointId="";
String memo="";
ArrayList percent_n=new ArrayList();
ArrayList percent_ns=new ArrayList();
ArrayList items=new ArrayList();
ArrayList type_cs=new ArrayList();
//得到所有考核项的权重
String cyclex=cycle;
if (cycle.equals("4")) cyclex="3";

String sql1="select a.percent_n,b.percent_n,a.type_c,b.item from HrmPerformanceSchemeContent a left join HrmPerformanceSchemeDetail b on a.id=b.contentId where a.cycle='"+cyclex+"' and a.schemeId="+ckeckId;
rs2.execute(sql1);
while (rs2.next())
{
percent_n.add(rs2.getString(1));
percent_ns.add(rs2.getString(2));
items.add(rs2.getString(4));
type_cs.add(rs2.getString(3));
}
if (cycle.equals("3")) cycle="4";
boolean flagend=false;
rs1.execute("select * from HrmPerformanceCheckPoint where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"'" );
//out.print("select * from HrmPerformanceCheckPoint where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"'" );
if (rs1.next())
{flagend=true;
pointId=rs1.getString("id");
point1=rs1.getString("point1");
point2=rs1.getString("point2");
point3=rs1.getString("point3");
point4=rs1.getString("point4");
point8=rs1.getString("point8");
point6=rs1.getString("point6");
point5=rs1.getString("point5");
memo=rs1.getString("memo");
}


ArrayList point=Util.TokenizerString(point8,",");

//pointModul="1";
//pointMethod="1";
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type="text/javascript">
function modifyPoint(){
	location.href = "modifyPoint.jsp?id=<%=pointId%>";
}
</script>
</HEAD>


<%
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javaScript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;



%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="1">
<col width="">
<col width="1">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=ListStyle>
<tr>
<td valign="top">
<form name="planform" method="post" action="CheckOperation.jsp">
<input type="hidden" name="operationType">
<input type="hidden" name="id" value=<%=pointId%>>

 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
  <th align="center">
  <%=gradeName%>
  </th>
  </tr>
  </TBODY></TABLE>
    <!--个人报告-->
  <%if (flagend) {
  boolean isLight = false;
  String  flagss=Util.getIntValues(Util.null2String(point1));
  String  flags2=Util.getIntValues(Util.null2String(point2));
  if ((!flagss.equals("")&&!flagss.equals("0"))||(!flags2.equals("")&&!flags2.equals("0")))
  {%> <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18060,user.getLanguage())%>
  (<%for (int k=0;k<percent_n.size();k++)
  {
     if ((""+type_cs.get(k)).equals("0"))
     out.print(percent_n.get(k)+"%");
     break;
     
  }
  %>)
  </th>
  <th></th>
  </TR>
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
  <%}
  if (!flagss.equals("")&&!flagss.equals("0"))
  {
  if (ck.getCheckType(checkType,objId,cycle,postIdo,user,"0","0")) {
  
  RecordSet.execute("select workPlan.* ,a.planName ,f.id as reportId,f.pointSelf,f.status as statusr,f.percent_n as perp,g.point1 as pointDown from workPlan  left join HrmPerformanceReport f on workPlan.id=f.planId  left join HrmPerformanceBeforePoint g on g.planId=workPlan.id  join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where workPlan.objId="+objId+" and workPlan.cycle='"+cycle+"' and workPlan.planDate='"+checkDate+"' and workPlan.type_n='6' and workPlan.planType='"+checkType+"'  ");
 
  %>
   <div id="showmb">
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>　　<%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6106,user.getLanguage())%>
  (<%for (int k=0;k<percent_n.size();k++)
  {
     if ((""+type_cs.get(k)).equals("0")&&(""+items.get(k)).equals("0"))
     {out.print(percent_ns.get(k)+"%");
     break;
     }
  }
  %>)
  </th>
 <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
  <div id="showobj">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="12%">
  <COL width="10%">
  <COL width="10%">
  <COL width="5%">
  <COL width="12%">
  <COL width="12%">
  <COL width="3%">
  <COL width="8%">
  <COL width="7%">
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
  <th><%=SystemEnv.getHtmlLabelName(18242,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
 <TR class=Line>
 <TD colspan="11" >
 </TD>
 </TR> 
<%

    
	while(RecordSet.next())  
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
		<% if (Util.null2String(RecordSet.getString("statusr")).equals("0")) {%><%=SystemEnv.getHtmlLabelName(18230,user.getLanguage())%><%}%>
	    <% if (Util.null2String(RecordSet.getString("statusr")).equals("1")) {%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><%}%>
	    <% if (Util.null2String(RecordSet.getString("statusr")).equals("2")) {%><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%><%}%>
	    <% if (Util.null2String(RecordSet.getString("statusr")).equals("3")) {%><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%><%}%>
		<% if (Util.null2String(RecordSet.getString("statusr")).equals("1")) {%>
		<%=SystemEnv.getHtmlLabelName(847,user.getLanguage())%><%=Util.null2String(RecordSet.getString("perp"))%>%
		<%}%></TD>
		<td>
		<%=Util.round(RecordSet.getString("pointDown"),1)%>
		</td>
		
		<%if ((pointMethod.equals("1")&&pointModul.equals("0"))||pointMethod.equals("0")) {%>
		<td><%if (point.size()>0) {%><%out.print(Util.round(""+point.get(i),1));%><%}%></td>
		<%}
		if (pointMethod.equals("1")&&pointModul.equals("1"))  //总分评定模式只有一个得分
		{ if (i==0){%>
		<td rowspan=1><%=Util.round(point1,1)%></td>
		<%}}%>
		
		
	</TR>
<%
	i++;}

%>
  <TR class=title><th colspan="11"><%=SystemEnv.getHtmlLabelName(17955,user.getLanguage())%>: <%=Util.round(point1,1)%></th></TR>
 </TABLE>
</div>
<%}
}%>
 <!--个人计划结束-->
 <br>
 <% 
  flagss=Util.getIntValues(Util.null2String(point2));
  if (!flagss.equals("")&&!flagss.equals("0"))
  {
 if (!cycle.equals("2")&&ck.getCheckType(checkType,objId,cycle,postIdo,user,"0","1")) {
 String itemds="";
 
 for (int k=0;k<percent_n.size();k++)
  {
     if ((""+type_cs.get(k)).equals("1"))
    {itemds=""+items.get(k);
     
     break;
     }
  }
 %>
  <!--个人报告汇总-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>　　<%=SystemEnv.getHtmlLabelName(18137,user.getLanguage())%>
  (<%for (int k=0;k<percent_n.size();k++)
  {
     if ((""+type_cs.get(k)).equals("0")&&(""+items.get(k)).equals("1"))
     {out.print(percent_ns.get(k)+"%");
     break;
     }
  }
  %>)
  </th>
 <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showohz','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>

<div id="showohz">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="75%">
  <COL width="10%">

  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  
  </tr>
 <TR class=Line><TD colspan="3" ></TD></TR> 
<%  int minm=0;
    int maxm=0;
    int j=0;
    if (cycle.equals("0"))
    {
    if (rs1.getDBType().equals("oracle")||rs1.getDBType().equals("db2"))
      {
       rs1.execute("select * from HrmPerformanceCheckPoint where cycle='2' and SubStr(checkDate,1,4)='"+checkDate.substring(0,4)+"' and objId="+objId+" and checkType='"+checkType+"' order by checkDate"); 
      }
      else
      { 
      rs1.execute("select * from HrmPerformanceCheckPoint where cycle='2' and SubString(checkDate,1,4)='"+checkDate.substring(0,4)+"' and objId="+objId+" and checkType='"+checkType+"' order by checkDate"); 
      }
     }
    if (cycle.equals("1"))
    {
     minm=Integer.parseInt(checkDate.substring(4))*3-2;
     maxm=Integer.parseInt(checkDate.substring(4))*3;
    if (rs1.getDBType().equals("oracle")||rs1.getDBType().equals("db2"))
      {
       rs1.execute("select * from HrmPerformanceCheckPoint where cycle='2' and SubStr(checkDate,1,4)='"+checkDate.substring(0,4)+"' and (substr(checkDate,5)>="+minm+" and substr(checkDate,5)<="+maxm+") and objId="+objId+" and checkType='"+checkType+"' order by checkDate"); 
      }
      else
      { 
      rs1.execute("select * from HrmPerformanceCheckPoint where cycle='2' and SubString(checkDate,1,4)='"+checkDate.substring(0,4)+"' and (substring(checkDate,5,2)>="+minm+" and substring(checkDate,5,2)<="+maxm+") and objId="+objId+" and checkType='"+checkType+"' order by checkDate"); 

      }
     }
     if (cycle.equals("4"))
    { minm=1;
      maxm=6;
    if (rs1.getDBType().equals("oracle")||rs1.getDBType().equals("db2"))
      {
       rs1.execute("select * from HrmPerformanceCheckPoint where cycle='2' and SubStr(checkDate,1,4)='"+checkDate.substring(0,4)+"' and (substr(checkDate,5)>="+minm+" and substr(checkDate,5)<="+maxm+") and objId="+objId+" and checkType='"+checkType+"' order by checkDate"); 
      }
      else
      { 
      rs1.execute("select * from HrmPerformanceCheckPoint where cycle='2' and SubString(checkDate,1,4)='"+checkDate.substring(0,4)+"' and (substring(checkDate,5,2)>="+minm+" and substring(checkDate,5,2)<="+maxm+") and objId="+objId+" and checkType='"+checkType+"' order by checkDate"); 
      }
     }
   
	while(rs1.next())
	{ 
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
    <%		}else{%>
	<TR CLASS=DataDark>
    <%		}%>

		<TD>
		<a href="#"   onclick="openFullWindow('CheckViewMonth.jsp?id=<%=rs1.getString("id")%>&cycle=<%=rs1.getString("cycle")%>&checkDate=<%=rs1.getString("checkDate")%>&checkType=<%=rs1.getString("checkType")%>&objId=<%=rs1.getString("objId")%>&item=<%=itemds%>')">
		<%=rs1.getString("checkDate").substring(4)%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6106,user.getLanguage())%></a></TD>
		<TD><%=rs1.getFloat("point6")%></TD>
		<TD>
		<%if (j==0) {%>
		<%=Util.round(point2,1)%>
         <%}%>

	

		
	</TR>
<%j++;}	
%>
<TR class=title><th colspan="11"><%=SystemEnv.getHtmlLabelName(17955,user.getLanguage())%>: <%=Util.round(point2,1)%></th></TR>
 </TABLE>

 <!--个人报告汇总结束-->
   <%i++;}}
   
%>
</div>
<br>
<!--综合素质考核-->
<% 
flagss=Util.getIntValues(Util.null2String(point3));
if (!flagss.equals("")&&!flagss.equals("0"))
  {
if (ck.getCheckType(checkType,objId,cycle,postIdo,user,"1","1")) 
{
rs1.execute("select * from HrmPerformanceDiyCheckPoint where nodePointId="+pointId);
if (rs1.next())
{
 String points="";
 String itemid="";
%>
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18263,user.getLanguage())%>
  (<%for (int k=0;k<percent_n.size();k++)
  {
     if ((""+type_cs.get(k)).equals("1"))
    {itemid=""+items.get(k);
     out.print(percent_n.get(k)+"%");
     break;
     }
  }
 
 rs2.execute("update HrmPerformanceDiyCheckPoint set targetIndex='-1'  where nodePointId="+pointId+" and checkId="+itemid);
 pointtree.setUser(user);
  %>)
  </th>
 <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showzh','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
<div id="showzh">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="10%">
  <COL width="50%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(18086,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="4"></TD></TR> 
<%
out.print(pointtree.getViewEndPointListStr(Util.getIntValue(itemid),pointId));
%>
<TR class=title><th  colspan="4"><%=SystemEnv.getHtmlLabelName(17955,user.getLanguage())%>: <%=Util.round(point3,1)%></th></TR> 
</TBODY></TABLE>
</div>
<%}
}
}%>
<!--综合素质考核结束-->
<br>
<!--述职总结-->
<%
flagss=Util.getIntValues(Util.null2String(point4));
if (!flagss.equals("")&&!flagss.equals("0"))
  {
if (ck.getCheckType(checkType,objId,cycle,postIdo,user,"2","1")) {
%>
<TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18062,user.getLanguage())%>
 (<%for (int k=0;k<percent_n.size();k++)
  {
     if ((""+type_cs.get(k)).equals("2"))
     {out.print(percent_n.get(k)+"%");
     break;
     }
  }
  %>)
  </th>
  <th></th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobjsz','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
 
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
  <div id="showobjsz">
  <table><tr><td>
  <%String docIds="";
  String cycle1="";
  if (cycle1.equals("3")) cycle1="4";   //考核中年中考核周期是3，报告中年中报告周期是4 
  rs2.execute("select * from HrmPerformanceReport where reportType='"+checkType+"' and cycle='"+cycle1+"' and objId="+objId+" and reportDate='"+checkDate+"' and reportTypep='1' ");

  if (rs2.next()) docIds=rs2.getString("docId");
  %>  
	 
	  <%
		if (!docIds.equals("")) {
			ArrayList docs = Util.TokenizerString(docIds, ",");
			for (int j = 0; j < docs.size(); j++) {
				%><A style="cursor:hand" onclick=openFullWindow('/docs/docs/DocDsp.jsp?isrequest=1&id=<%=""+docs.get(j)%>')>
				<%=docComInfo.getDocname("" + docs.get(j))%></A>&nbsp;
		<%
			}
		}%>
	 
  </td></tr>
  <TR class=title><th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%>: <%=Util.round(point4,1)%></th></TR>
  </table>
</div>
  <%
  i++;
  }
  }%>
</td>
</tr>
</TABLE>
<% if (flagend) 
{%>
<TABLE class=viewform >
<TR class=title>
	<th>
	<%=SystemEnv.getHtmlLabelName(16434,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17955,user.getLanguage())%>: <%=Util.round(point5,1)%>
	</th>
</TR>
<TR class=title>
	<th>
	<%=SystemEnv.getHtmlLabelName(16434,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18264,user.getLanguage())%>: <%=Util.round(point6,1)%>
	</th>
</TR>
<TR class=title>
	<th>
	<%rs1.execute("select a.grade from HrmPerformanceGradeDetail a left join HrmPerformanceGrade b on a.gradeId=b.id where b.source='0' and a.condition1<="+Util.round(point6,1)+" and a.condition2>="+Util.round(point6,1)+" ");
	String grade="";
	if (rs1.next())
	{
	grade=rs1.getString(1);
	}
	%>
	<%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%>: <%=grade%>
	</th>
</TR>
</TABLE>
<%}
}%>
</FORM>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

<SCRIPT language="VBS" src="/js/browser/GoalSTDBrowser.vbs"></SCRIPT>
<SCRIPT language="javascript">
function onSubmit()
{
document.planform.operationType.value="saveInterview";
document.planform.submit();
enablemenu();
}
</SCRIPT>
</BODY>
   <%}
else{
response.sendRedirect("/notice/noright.jsp");
    		return;
	}%>

