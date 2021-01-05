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
<%
int i=0;
String checkDate=request.getParameter("checkDate");
String cycle=request.getParameter("cycle");
String checkType=request.getParameter("checkType");
String objId=request.getParameter("objId");
String id=request.getParameter("id");

String type_c="1111";
//得到分数
String point1="";
String point2="";
String point3="";
String point4="";
String point6="";
String point8="";
String pointId="";
rs1.execute("select * from HrmPerformanceCheckPoint where id="+id);
if (rs1.next())
{
pointId=rs1.getString("id");
point1=rs1.getString("point1");
point2=rs1.getString("point2");
point3=rs1.getString("point3");
point4=rs1.getString("point4");
point8=rs1.getString("point8");
point6=rs1.getString("point6");
}
String pointMethod=""; //评分方式 0：依据评分标准 1：手工评分
//评分模式 If pointMethod=0 (1:允许调整，0：不允许调整)If pointMethod=1(0;不用总分评定模式1：起用总分评定模式)
String pointModul=""; 

rs2.execute("select * from HrmPerformancePointRule");
if (rs2.next())
{
pointMethod=rs2.getString("pointMethod");
pointModul=rs2.getString("pointModul");
}
ArrayList point=Util.TokenizerString(point8,",");
//pointModul="0";
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

 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
  <th align="center"><%=checkDate.substring(0,4)%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=checkDate.substring(4)%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6106,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
  </TBODY></TABLE>
    <!--个人报告-->
  <%
  boolean isLight = false;
  RecordSet.execute("select workPlan.* ,a.planName ,f.id as reportId,f.pointSelf,f.status as statusr,f.percent_n as perp,g.point1 as pointDown from workPlan  left join HrmPerformanceReport f on workPlan.id=f.planId  left join HrmPerformanceBeforePoint g on g.planId=workPlan.id  join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where workPlan.objId="+objId+" and workPlan.cycle='"+cycle+"' and workPlan.planDate='"+checkDate+"' and workPlan.type_n='6' and workPlan.planType='"+checkType+"'  ");

  %>
  <div id="showmb">
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
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
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
		<td><%if (point.size()>0) {%><%=Util.round(""+point.get(i),1)%><%}%></td>
		<%}
		if (pointMethod.equals("1")&&pointModul.equals("1"))  //总分评定模式只有一个得分
		{ if (i==0){%>
		<td rowspan=1><%=Util.round(point1,1)%></td>
		<%}}%>
		
		
	</TR>
<%
	i++;}

%>
  <TR class=title><th colspan="11"><%=SystemEnv.getHtmlLabelName(17955,user.getLanguage())%>: <%=Util.getPointValue(point1,1,point1)%></th></TR>
 </TABLE>
</div>
 <!--个人计划结束-->

<!--综合素质考核-->
<%
rs1.execute("select * from HrmPerformanceDiyCheckPoint where nodePointId="+pointId);
if (rs1.next())
{
String points="";
String item=request.getParameter("item");
rs2.execute("update HrmPerformanceDiyCheckPoint set targetIndex='-1'  where nodePointId="+pointId+" and checkId="+item);
pointtree.setUser(user);
%> 
<div id="showzh">

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="10%">
  <COL width="50%">
  <COL width="10%">
  <TBODY>
   <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18061,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=4></TD>
          </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(18086,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="4"></TD></TR> 
<%out.print(pointtree.getViewEndPointListStr(Util.getIntValue(item),pointId));
%>
<TR class=title><th  colspan="4"><%=SystemEnv.getHtmlLabelName(17955,user.getLanguage())%>: <%=Util.getPointValue(point3,1,point3)%></th></TR> 
</div>
<%}%>
<!--综合素质考核结束-->
<br>
<!--述职总结-->
 <%
 String docIds="";
  
 rs2.execute("select * from HrmPerformanceReport where reportType='"+checkType+"' and cycle='"+cycle+"' and objId="+objId+" and reportDate='"+checkDate+"' and reportTypep='1' ");

 if (rs2.next()) 
  {docIds=rs2.getString("docId");
  %>
  <div id="showsz">
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
 
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>
  <div id="showobjs">
  <table><tr><td>
 
	  <SPAN id="docspan">
	  <%
		if (!docIds.equals("")) {
			ArrayList docs = Util.TokenizerString(docIds, ",");
			for (int j = 0; j < docs.size(); j++) {
				%>
				<A style="cursor:hand" onclick=openFullWindow('/docs/docs/DocDsp.jsp?isrequest=1&id=<%=""+docs.get(j)%>')><%=docComInfo.getDocname("" + docs.get(j))%></A>&nbsp;
		<%
			}
		}%>
	  </SPAN>
  </td></tr>
  <TR class=title><th colspan="11"><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%>: <%=Util.getPointValue(point4,1,point4)%></th></TR>
  </table></div>
  <%
  i++;
  }%>
 
</td>
</tr>
<TR class=title><th colspan="11"><%=SystemEnv.getHtmlLabelName(16434,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17955,user.getLanguage())%>: <%=Util.getPointValue(point6,1,point6)%></th></TR>
 </TABLE>
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
</BODY>

