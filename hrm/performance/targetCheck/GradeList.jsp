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
<jsp:useBean id="pointtree" class="weaver.hrm.performance.maintenance.TargetList" scope="page" />
<jsp:useBean id="ck" class="weaver.hrm.performance.targetcheck.CheckInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="kpi" class="weaver.hrm.performance.goal.KPIComInfo" scope="page" />
<%
int i=0;
String checkDate="";
String cycle="";
String type="";
String checkType="";
String type_c=""; //0:目标考核；1：综合素质 2:述职报告
String item="";   //0工作计划 1:月汇总
String gradeName="";
String objId="";
String id=request.getParameter("id");
String pointIds=ck.getMaxID("nodepointid");//得到HrmPerformanceNodePointid,供新增时用
int requestid=0;
int nodeid=0;
int groupid=0;
rs1.execute("select * from GradeGroup where id="+id);
if (rs1.next())
{
 checkDate=rs1.getString("checkDate");
 cycle=rs1.getString("cycle");
 checkType=rs1.getString("checkType");
 type_c=rs1.getString("type_c"); 
 item=rs1.getString("item");
 gradeName=rs1.getString("gradeName");
 objId=rs1.getString("objId");
 requestid=rs1.getInt("requestId");
}
 
rsf.execute("select currentnodeid,d.id as groupids  from workflow_requestbase left join workflow_currentoperator on workflow_requestbase.requestid=workflow_currentoperator.requestid  left join workflow_nodegroup d on d.nodeid=workflow_currentoperator.nodeid where workflow_currentoperator.userid="+user.getUID()+" and workflow_requestbase.requestid="+requestid);
//out.print("select currentnodeid,d.groupid as groupids  from workflow_requestbase left join workflow_currentoperator on workflow_requestbase.requestid=workflow_currentoperator.requestid  left join workflow_nodegroup d on d.nodeid=workflow_currentoperator.nodeid where workflow_currentoperator.userid="+user.getUID()+" and workflow_requestbase.requestid="+requestid);
 if (rsf.next())
			 {
			 nodeid=rsf.getInt("currentnodeid");
			 groupid=rsf.getInt("groupids");
			 }
			 
//得到评分标准中可评分的最低和最高分
String minPoint="0";
String maxPoint="100" ;
String pointMethod=""; //评分方式 0：依据评分标准 1：手工评分
//评分模式 If pointMethod=0 (1:允许调整，0：不允许调整)If pointMethod=1(0;不用总分评定模式1：起用总分评定模式)
String pointModul=""; 
// 操作的用户信息
int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
int isremark = -1 ;  
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

char flags = Util.getSeparator() ;

RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flags+usertype+flags+requestid+"");
while(RecordSet.next())	{
    int tempisremark = Util.getIntValue(RecordSet.getString("isremark"),0) ;
    isremark = tempisremark ;
}

if(isremark !=1&&isremark!= 0)
{
rsf.execute("select workflow_currentoperator.nodeid,d.id as groupids  from  workflow_currentoperator  left join workflow_nodegroup d on d.nodeid=workflow_currentoperator.nodeid where workflow_currentoperator.userid="+user.getUID()+" and workflow_currentoperator.isremark='2' and workflow_currentoperator.requestid="+requestid);

 if (rsf.next())
			 {
			 nodeid=rsf.getInt("nodeid");
			 groupid=rsf.getInt("groupids");
			 }
}
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
String pointId="";
rs1.execute("select * from HrmPerformanceNodePoint where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeid+" and operationId="+groupid);

if (rs1.next())
{
pointId=rs1.getString("id");
point1=rs1.getString("point1");
point2=rs1.getString("point2");
point3=rs1.getString("point3");
point4=rs1.getString("point4");
}

ArrayList point=new ArrayList();
if (!point1.equals("")) {
point = Util.TokenizerString(point1, ",");
}
//pointModul="1";
//pointMethod="1";
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>


<%
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%



RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(isremark == 0)
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+SystemEnv.getHtmlLabelName(15489,user.getLanguage())+",javaScript:OnSubmits(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

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
<input type="hidden" name="cycle" value=<%=cycle%>>
<input type="hidden" name="id" value=<%=id%>>
<input type="hidden" name="item" value=<%=item%>>
<input type="hidden" name="objId" value=<%=objId%>>
<input type="hidden" name="requestid" value=<%=requestid%>>
<input type="hidden" name="groupid" value=<%=groupid%>>
<input type="hidden" name="nodeid" value=<%=nodeid%>>
<input type="hidden" name="checkType" value=<%=checkType%>>
<input type="hidden" name="type_c" value=<%=type_c%>>
<input type="hidden" name="pointMethod" value=<%=pointMethod%>>
<input type="hidden" name="pointModul" value=<%=pointModul%>>
<input type="hidden" name="operationType">
<% if (pointId.equals("")){%>
<input type="hidden" name="pointId" value=<%=pointIds%>>
<%}
else {%>
<input type="hidden" name="pointId" value=<%=pointId%>>
<%}
%>
<input type="hidden" name="checkDate" value=<%=checkDate%>>


 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
  <th align="center"><%=gradeName%></th>
  </tr>
  </TBODY></TABLE>
    <!--个人报告-->
  <%
  boolean isLight = false;
  if (type_c.equals("0")&&item.equals("0")) {
  RecordSet.execute("select workPlan.* ,a.planName ,f.id as reportId,f.pointSelf,f.status as statusr,f.percent_n as perp,g.point1 as pointDown from workPlan  left join HrmPerformanceReport f on workPlan.id=f.planId  left join HrmPerformanceBeforePoint g on g.planId=workPlan.id  left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where workPlan.objId="+objId+" and workPlan.cycle='"+cycle+"' and workPlan.planDate='"+checkDate+"' and workPlan.type_n='6' and workPlan.planType='"+checkType+"' order by workPlan.id ");
 // out.print("select workPlan.* ,a.planName ,f.id as reportId,f.pointSelf,f.status as statusr,f.percent_n as perp,g.point1 as pointDown from workPlan  left join HrmPerformanceReport f on workPlan.id=f.planId  left join HrmPerformanceBeforePoint g on g.planId=workPlan.id  join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where workPlan.objId="+objId+" and workPlan.cycle='"+cycle+"' and workPlan.planDate='"+checkDate+"' and workPlan.type_n='6' and workPlan.planType='"+checkType+"'  ");
  %>
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%>
  </th>
 <th></th>
  </TR>
   <TR class=spacing style="height:1px;"> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="13%">
  <col width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="5%">
  <COL width="10%">
  <COL width="10%">
  <COL width="3%">
  <COL width="7%">
  <COL width="6%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18191,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18242,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%></th>
  
  </tr>
 <TR class=Line style="height:1px;">
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
		<%//==============================================
		  //TD4941.计划.5
		  //added by hubo, 2006-09-06%>
		<td>
			<a href="/hrm/performance/goal/myGoalView.jsp?id=<%=RecordSet.getString("oppositeGoal")%>">
			<%=kpi.getName(RecordSet.getString("oppositeGoal"))%>
			</a>
		</td>
		<%//==============================================%>
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
      <TD name='downPrincipal'><%
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
      <td  name='pointDown'>
		<%=Util.round(RecordSet.getString("pointDown"),1)%>
		</td>
		<input type="hidden" name="reportId_<%=i%>" id="reportId_<%=i%>" value=<%=RecordSet.getString("reportId")%>>
		<%if (pointMethod.equals("0")) {
		String goal=RecordSet.getString("oppositeGoal");
		%><td>
		<BUTTON type="button" class="Browser" id="SelectSTD" onclick="onShowSTD('point_<%=i%>','<%=goal%>')"></BUTTON>
		<input class="inputstyle"  <%if (point.size()>0) {%> value="<%=point.get(i)%>" <%}%> name="point_<%=i%>" id="point_<%=i%>" onchange="checkint('point_<%=i%>')" maxlength="3" size="3" <%if (pointModul.equals("0")) {%> readonly <%}%> >
		</td>
		<%}%>
		<%if (pointMethod.equals("1")&&pointModul.equals("0")) {%>
		<td>
		<input class="inputstyle"  <%if (point.size()>0) {%> value="<%=point.get(i)%>" <%}%> name="point_<%=i%>" id="point_<%=i%>" maxlength="3" size="3" onchange="checkint('point_<%=i%>')">
		</td>
		<%}
		if (pointMethod.equals("1")&&pointModul.equals("1"))  //总分评定模式只有一个输入
		{ if (i==0){%>
		<td rowspan=1>
		<input class="inputstyle" <%if (point.size()>0) {%> value="<%=point.get(i)%>" <%}%> name="point_0"  id="point_0"  maxlength="3" size="3" onchange="checkint('point_0')">
		</td><%}
		}%>
		
	</TR>
<%
	i++;}
if (pointMethod.equals("1")&&pointModul.equals("1")) i=1;	//总分评定模式只有一个输入
%>
<input type="hidden" name="len" id="len" value=<%=i%>>
 </TABLE>
 <%}%>
 <!--个人计划结束-->
 
 <%if (type_c.equals("0")&&item.equals("1")) {%>
  <!--个人报告汇总-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18247,user.getLanguage())%>
  </th>
 <th></th>
  </TR>
   <TR class=spacing style="height:1px;"> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>


<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="75%">
  <COL width="10%">

  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%></th>
  
  </tr>
 <TR class=Line style="height:1px;"><TD colspan="3" ></TD></TR> 
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
		<a href="#"   onclick="openFullWindow('CheckViewMonth.jsp?id=<%=rs1.getString("id")%>&cycle=<%=rs1.getString("cycle")%>&checkDate=<%=rs1.getString("checkDate")%>&checkType=<%=rs1.getString("checkType")%>&objId=<%=rs1.getString("objId")%>&item=<%=item%>')">
		<%=rs1.getString("checkDate").substring(4)%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6106,user.getLanguage())%></a></TD>
		<TD><%=Util.round(rs1.getString("point6"),1)%></TD>
		
		<%if (j==0) {%>
		<TD rowspan="1">
		<input class="inputstyle"  value="<%=point2%>" name="point_0"  maxlength="3" id="point_0" size="3" onchange="checkint('point_0')">
        </TD> <%}%>

	

		
	</TR>
<%
	j++;}
	
%>
 </TABLE>

 <!--个人报告汇总结束-->
   <%i++;}
%>
 
<!--综合素质考核-->
<%if (type_c.equals("1"))
{
String points="";
if (!pointId.equals(""))
{ points=pointId;
  rs2.execute("select * from HrmPerformanceCheckPointDetail where nodePointId="+pointId);
  if (!rs2.next())
  {
  rsf.execute("insert into HrmPerformanceCheckPointDetail SELECT id,checkId,targetName,percent_n,stdName, crmCode, parentId, levels, depath,targetIndex,0,"+pointId+" FROM HrmPerformanceCheckDetail where checkId="+item);
  
  }
//插入综合素质明细
}
else
{
//插入综合素质明细
  rsf.execute("insert into HrmPerformanceCheckPointDetail SELECT id,checkId,targetName,percent_n,stdName, crmCode, parentId, levels, depath,targetIndex,0,"+pointIds+" FROM HrmPerformanceCheckDetail where checkId="+item);
  points=pointIds;
}
rs2.execute("update HrmPerformanceCheckPointDetail set targetIndex='-1'  where nodePointId="+points+" and checkId="+item);
pointtree.setUser(user);
%>
<TABLE class=viewform>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="10%">
  <COL width="50%">
  <COL width="10%">
      </colgroup>
  <TBODY>
   <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18094,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=4 style="padding:0"></TD>
          </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(18086,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%></th>
  </tr>
 <TR class=Line  style="height:1px;"><TD colspan="4" style="padding:0"></TD></TR> 
<%out.print(pointtree.getViewTargetPointListStr(Util.getIntValue(item),points));
%>
<%}%>
<!--综合素质考核结束-->

<!--述职总结-->
<%if (type_c.equals("2")) {%>
<TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
  <%=SystemEnv.getHtmlLabelName(18062,user.getLanguage())%></th>
  <th></th>
  </TR>
 
   <TR class=spacing style="height:1px;"> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
  <div id="showobjs">
  <table><tr><td>
  <%String docIds="";
  String cycle1=cycle;
  if (cycle1.equals("3")) cycle1="4";
  rs2.execute("select * from HrmPerformanceReport where reportType='"+checkType+"' and cycle='"+cycle1+"' and objId="+objId+" and reportDate='"+checkDate+"' and reportTypep='1' ");
  //out.print("select * from HrmPerformanceReport where reportType='"+checkType+"' and cycle='"+cycle1+"' and objId="+objId+" and reportDate='"+checkDate+"' and reportTypep='1' ");
  if (rs2.next()) docIds=rs2.getString("docId");
  %>  
	  <SPAN id="docspan">
	  <%
		if (!docIds.equals("")) {
			ArrayList docs = Util.TokenizerString(docIds, ",");
			for (int j = 0; j < docs.size(); j++) {
				%><A style="cursor:hand" onclick=openFullWindow('/docs/docs/DocDsp.jsp?isrequest=1&id=<%=""+docs.get(j)%>')><%=docComInfo.getDocname("" + docs.get(j))%></A>&nbsp;
		<%
			}
		}%>
	  </SPAN>
	  <%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%>:
	  <input class="inputstyle"  value="<%=point4%>" name="point_0" id="point_0" maxlength="3" size="3" onchange="checkint('point_0')">
  </td></tr></table></div>
  <%
  i++;
  }%>
 
</td>
</tr>
</TABLE>

</FORM>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<SCRIPT language="VBS" src="/js/browser/GoalSTDBrowser.vbs"></SCRIPT>
<script language="javascript">
    String.prototype.trim = function () {
        return this .replace(/^\s\s*/, '' ).replace(/\s\s*$/, '' );
    }
function OnSubmit()
{var type=<%=type_c%>;
if (type=="1")
{
if (!getPoint())
{
return;
}
}
if (checkPoint())
{
document.planform.operationType.value="save";
document.planform.submit();
enablemenu();
}
}
function OnSubmits()
{
    var checkd =false;
    $("input[name*='point_']").each(function(){
        if($(this).val()=="" || $(this).val()==null){
            checkd = true;
        } else{
            if($(this).parent().parent().find("td[name='downPrincipal']").html()=="" || $(this).parent().parent().find("td[name='downPrincipal']").html()==null ){
            }   else{
                if($(this).parent().parent().find("td[name='pointDown']").html()==null||
                        $(this).parent().parent().find("td[name='pointDown']").html().trim()=="" ||
                        $(this).parent().parent().find("td[name='pointDown']").html()<0 ){
                    checkd = true;
                }
            }
        }
    });
    if(checkd){
        alert("<%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21695,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15127,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%>!");
        return false;
    }
if (checkPoint())
{
document.planform.operationType.value="confirm";
document.planform.submit();
enablemenu();
}
}

function checkPoint()
{

var l=<%=i%>;
for (k=0;k<l;k++)
{
if (document.all("point_"+k).value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18243,user.getLanguage())%>');
document.all("point_"+k).focus();
return false;
}
else if  ((parseInt(document.all("point_"+k).value)<=<%=minPoint%>)||(parseInt(document.all("point_"+k).value)><%=maxPoint%>))
{
alert('<%=SystemEnv.getHtmlLabelName(18232,user.getLanguage())%>(<%=minPoint%>-<%=maxPoint%>)');
document.all("point_"+k).focus();
return false;
}
}

return true;
}
function getPoint()
{
var obj=document.planform.elements; // 列出表单中所有元素放入数组
for(i = 10; i < obj.length; i++)	
{ 
if ((obj[i].tagName.toLowerCase()=="input")&&(obj[i].name.indexOf("points_")>=0))
{
if (obj[i].value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18243,user.getLanguage())%>');
obj[i].focus();
return false;
}
else if  ((parseInt(obj[i].value)<=<%=minPoint%>)||(parseInt(obj[i].value)><%=maxPoint%>))
{
alert('<%=SystemEnv.getHtmlLabelName(18232,user.getLanguage())%>(<%=minPoint%>-<%=maxPoint%>)');
obj[i].value.focus();
return false;
}

}
}
return true;
} 
</script>


</BODY>

