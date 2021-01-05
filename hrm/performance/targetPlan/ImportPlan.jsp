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

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%

String years=Util.null2String(request.getParameter("years"));
String months=Util.null2String(request.getParameter("months"));
String quarters=Util.null2String(request.getParameter("quarters"));
String weeks=Util.null2String(request.getParameter("weeks"));
String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type=Util.null2String(request.getParameter("type")); //周期
String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
String objName=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String planDate=Util.null2String(request.getParameter("planDate"));
String pName=Util.null2String(request.getParameter("pName"));
if (type_d.equals("2"))
{
RecordSet.execute("select workPlan.* ,a.planName  from workPlan  left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where  EXISTS (select 'X' from  HrmResource where departmentid="+objId+" and HrmResource.id=workPlan.objId) and  workPlan.cycle='"+type+"' and workPlan.planDate='"+planDate+"' and workPlan.type_n='6' and workPlan.planType='3' and status='6'"); 
//and status='6' 暂时不用
}
else
{
RecordSet.execute("select workPlan.* ,a.planName  from workPlan  left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where  EXISTS (select 'X' from  HrmDepartment where subcompanyid1="+objId+" and HrmDepartment.id=workPlan.objId) and  workPlan.cycle='"+type+"' and workPlan.planDate='"+planDate+"' and workPlan.type_n='6' and workPlan.planType='2' and status='6'"); 
//and status='6' 暂时不用
//out.print("select workPlan.* ,a.planName  from workPlan  left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where  EXISTS (select 'X' from  HrmDepartment where subcompanyid1="+objId+" and HrmDepartment.id=workPlan.objId) and  workPlan.cycle='"+type+"' and workPlan.planDate='"+planDate+"' and workPlan.type_n='6' and workPlan.planType='2' ");
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
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
</script>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
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
<form name="planform" method="post" action="PlanOperation.jsp">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType" value="choosePlan">
<input type="hidden" name="planDate" value=<%=planDate%>>
<input type="hidden" name="pName" value=<%=pName%>>
 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
  <th align="center">
  
  <%=objName%><%if (type_d.equals("2")) {%><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%><%}%><%=years%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%if (type.equals("1")) {%><%=quarters%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%><%}
  else if (type.equals("2")){%><%=months%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%}
   else if (type.equals("3")){%><%=weeks%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><%}%><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%>
  </th>
  </tr>
  </TBODY></TABLE>
    <!--个人计划-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
 <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
  </th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobj')"><img src='/images/up.jpg'></span></th>
  </TR>
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
          </TR>
  </TBODY>
  </TABLE>

<div id="showobj" style="display:">  
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="10%">
  <COL width="15%">
  <COL width="15%">
  <COL width="10%">
  <COL width="10%">
  <COL width="5%">
  <COL width="15%">
  <COL width="15%">
  <COL width="5%">
 
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></th>
   <th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="10" ></TD></TR> 
<%
boolean isLight = false;
    
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
         <TD>
		<INPUT type="checkbox"  name="checkplan" value="<%=RecordSet.getString("id")%>">
		</TD>
		<TD>
		
		<a href="#"   onclick="openFullWindow('PlanView.jsp?id=<%=RecordSet.getString("id")%>')">
		
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
		<TD><%=Util.toScreen(RecordSet.getString("percent_n"),user.getLanguage())%></TD>
		
		
	</TR>
<%
	}
	
%>
 </TABLE>
 </div>
 <!--个人计划结束-->
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
function OnSubmit(){
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
	{	
		document.planform.submit();
		enablemenu()
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
	else
	{
	alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>");
	return;
	}
}
</script>
</HTML>
    
