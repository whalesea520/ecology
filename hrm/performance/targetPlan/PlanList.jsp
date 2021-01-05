<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>

<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%

String groupId=Util.null2String(request.getParameter("id"));
String requestid="";
boolean flag=false;
String objId="";
String type_d="";
String type="";
String planDate="";
RecordSet.execute("select workPlan.* ,a.planName,c.requestId as  requestIds from workPlan  left join workPlanGroup c on c.id=workPlan.groupId  left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where  workPlan.groupId="+groupId); 
//out.print("select workPlan.* ,a.planName,c.requestId  from workPlan  left join workPlanGroup c on c.id=workPlan.groupId  left join HrmPerformancePlanKindDetail a on a.id=workPlan.planProperty where  workPlan.groupId="+groupId); 

if (RecordSet.next())
{
flag=true;
requestid=RecordSet.getString("requestIds");
objId=RecordSet.getString("objId");
type_d=RecordSet.getString("planType");
type=RecordSet.getString("cycle");
planDate=RecordSet.getString("planDate");
}
int nodeid=0;
String isreject="";

RecordSetu.executeProc("workflow_Requestbase_SByID",requestid);
if(RecordSetu.next()){
	nodeid = Util.getIntValue(RecordSetu.getString("currentnodeid"),0);
}

RecordSetd.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSetd.next()){
	isreject=RecordSetd.getString("isreject");
}
// 操作的用户信息
int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
int isremark = -1 ;  
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

char flags = Util.getSeparator() ;
RecordSetd.executeProc("workflow_currentoperator_SByUs",userid+""+flags+usertype+flags+requestid+"");
while(RecordSetd.next())	{
int tempisremark = Util.getIntValue(RecordSetd.getString("isremark"),0) ;
    isremark = tempisremark ;
    if (isremark==2||isremark==4) break;
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
if(isremark == 0)
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doSubmit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
if( isreject.equals("1") ){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doReject(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;

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
<form name="planform" method="post" action="PlanOperation.jsp">

<input type="hidden" name="operationType" value="process">
<input type="hidden" name="src">
<input type="hidden" name="from" value="list">
<input type="hidden" name="requestId" value=<%=requestid%> >
<input type="hidden" name="objId" value=<%=objId%>>
 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="100%">
  <TBODY>
 
  </TBODY></TABLE>
 <!--审批计划-->
 <TABLE class=viewform >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
  <TR class=title> 
  <th>
 <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
  </th>
  <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
  </TR>
   <TR class=spacing> 
            <TD class=line1 colspan=2></TD>
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
  <COL width="5%">
  <COL width="15%">
  <COL width="15%">
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
  <th><%=SystemEnv.getHtmlLabelName(18063,user.getLanguage())%></th>
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
		<TD>
		<a href="PlanEdit.jsp?id=<%=RecordSet.getString("id")%>&from=list&type_d=<%=type_d%>&type=<%=type%>&planDate=<%=planDate%>&groupId=<%=groupId%>">
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
		<TD><%=Util.toScreen(RecordSet.getString("percent_n"),user.getLanguage())%></TD>
		
		
	</TR>
<%
	}while(RecordSet.next());
	}
	
%>
 </TABLE>
 <table width=100%><tr><td><%=SystemEnv.getHtmlLabelName(1007,user.getLanguage())%>
  <textarea class=Inputstyle name=remark rows=4 cols=40 style="width=80%" class=Inputstyle></textarea>
 </td></tr></table>
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
function doSubmit(){
        document.planform.src.value="submit";
		document.planform.submit();
		enablemenu();
	
	}

function doReject(){
         document.planform.src.value="reject";
		document.planform.submit();
		enablemenu();
	
	}

</script>
</HTML>
    
