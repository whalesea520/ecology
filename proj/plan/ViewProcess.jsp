
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="VerifyPower" class="weaver.proj.VerifyPower" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

VerifyPower.init(request,response,ProjID);
if(logintype.equals("1")){
	iscreater = VerifyPower.isCreater();
	ismanager = VerifyPower.isManager();
	if(!ismanager){
		ismanagers = VerifyPower.isManagers();
	}
	if(!ismanagers){
		isrole = VerifyPower.isRole();
	}
	if(!iscreater && !ismanager && !ismanagers && !isrole){
		ismember = VerifyPower.isMember();
	}
	if(!iscreater && !ismanager && !ismanagers && !isrole && !ismember){
		isshare = VerifyPower.isShare();
	}
}else if(logintype.equals("2")){
	iscustomer = VerifyPower.isCustomer();
}
if(iscreater || ismanager || ismanagers || isrole || ismember || isshare || iscustomer.equals("2")){
	canview = true;
}

if(iscreater || ismanager || ismanagers || isrole){
	canedit = true;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

String log = Util.null2String(request.getParameter("log"));
int MinLenWbscoding = 0 ;

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1338,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

ProcPara = ProjID ;
RecordSet.executeProc("Prj_TaskProcess_SelectAll",ProcPara);

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/plan/ViewPlan.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%if(RecordSet.getCounts()>0){%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1349,user.getLanguage())+",/proj/plan/ProcessDspMember.jsp?ProjID="+ProjID+"&version="+RecordSet.getString("version")+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1350,user.getLanguage())+",/proj/plan/ProcessDspTool.jsp?ProjID="+ProjID+"&version="+RecordSet.getString("version")+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1351,user.getLanguage())+",/proj/plan/ProcessDspMaterial.jsp?ProjID="+ProjID+"&version="+RecordSet.getString("version")+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(259,user.getLanguage())+",/proj/plan/ProcessDspRequest.jsp?ProjID="+ProjID+"&version=1000,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",/proj/plan/ProcessDspDoc.jsp?ProjID="+ProjID+"&version=1000,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1295,user.getLanguage())+",/proj/plan/ViewPlan.jsp?log=n&ProjID="+ProjID+"&version=1000,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1297,user.getLanguage())+",/proj/report/PlanAndProcess.jsp?log=n?ProjID="+ProjID+"&version=1000,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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


<TABLE class=liststyle cellspacing=1 >
<TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%></th>
	    </TR><TR class=Line><Th colspan="6" ></Th></TR>
<%
float cost = 0;
float fixedcost = 0;
float membercost = 0;
float toolcost = 0;
float materialcost = 0;
int workday = 0;
int finish = 0;
ProcPara = ProjID + flag + "";
RecordSet2.executeProc("Prj_TaskProcess_Sum",ProcPara);
if(RecordSet2.next() && !RecordSet2.getString("workday").equals("")){
	workday = Util.getIntValue(RecordSet2.getString("workday"),0);
	finish = Util.getIntValue(RecordSet2.getString("finish"),0);
	if(!(workday==0)) finish=finish/workday;

	fixedcost = Util.getFloatValue(RecordSet2.getString("fixedcost"),0);

	RecordSet3.executeProc("Prj_Process_SumCostMember",ProcPara);
	if(RecordSet3.next()){
		membercost =  Util.getFloatValue(RecordSet3.getString("cost"),0);
	}
	RecordSet3.executeProc("Prj_Process_SumCostTool",ProcPara);
	if(RecordSet3.next()){
		toolcost =  Util.getFloatValue(RecordSet3.getString("cost"),0);
	}
	RecordSet3.executeProc("Prj_Process_SumCostMaterial",ProcPara);
	if(RecordSet3.next()){
		materialcost =  Util.getFloatValue(RecordSet3.getString("cost"),0);
	}
	cost = fixedcost + membercost + toolcost + materialcost ;
%>
	    <TR class=fontred>
	      <TD>Total</TD>
		  <TD><%=finish%>%</TD>
		  <TD><%=RecordSet2.getString("workday")%></TD>
		  <TD><%if(!RecordSet2.getString("begindate").equals("x")){%><%=RecordSet2.getString("begindate")%><%}%></TD>
          <TD><%if(!RecordSet2.getString("enddate").equals("-")){%><%=RecordSet2.getString("enddate")%>		  <%}%></TD>
		  <TD><%=cost%></TD>
	    </TR>
<%}%>
<%
boolean isLight = false;
if(RecordSet.first()){
do{
	ProcPara = ProjID + flag + RecordSet.getString("wbscoding");
	RecordSet2.executeProc("Prj_TaskProcess_Sum",ProcPara);
	RecordSet2.next();
	workday = Util.getIntValue(RecordSet2.getString("workday"),0);
	finish = Util.getIntValue(RecordSet2.getString("finish"),0);
	if(!(workday==0)) finish=finish/workday;

	fixedcost = Util.getFloatValue(RecordSet2.getString("fixedcost"),0);

	RecordSet3.executeProc("Prj_Process_SumCostMember",ProcPara);
	if(RecordSet3.next()){
		membercost =  Util.getFloatValue(RecordSet3.getString("cost"),0);
	}
	RecordSet3.executeProc("Prj_Process_SumCostTool",ProcPara);
	if(RecordSet3.next()){
		toolcost =  Util.getFloatValue(RecordSet3.getString("cost"),0);
	}
	RecordSet3.executeProc("Prj_Process_SumCostMaterial",ProcPara);
	if(RecordSet3.next()){
		materialcost =  Util.getFloatValue(RecordSet3.getString("cost"),0);
	}
	cost = fixedcost + membercost + toolcost + materialcost ;
%>
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>>

          <TD>
				<%for(int i=1;i<RecordSet.getString("wbscoding").length()-1;i++){%>&nbsp&nbsp<%}%>
			<img src="/images/project_rank_wev8.gif" alt="<%=RecordSet.getString("wbscoding")%>"><a href="/proj/plan/ViewTaskProcess.jsp?taskrecordid=<%=RecordSet.getString("id")%>" title="<%=RecordSet.getString("wbscoding")%>"><%=RecordSet.getString("subject")%></a>
              <%
                String prefinish= RecordSet.getString("prefinish");
                if(!prefinish.equals("0")){%> 
                    <img src="/images/ArrowUpGreen_wev8.gif" width="7" height="10">
                 <%}%>             
            </TD>
		  <TD><%=finish%>%</TD>
          <TD><%=RecordSet2.getString("workday")%></TD>
          <TD><%if(!RecordSet2.getString("begindate").equals("x")){%><%=RecordSet2.getString("begindate")%><%}%></TD>
          <TD><%if(!RecordSet2.getString("enddate").equals("-")){%><%=RecordSet2.getString("enddate")%>		  <%}%></TD>
          <TD><%=cost%></TD>

    </TR>
<%
	isLight = !isLight;
}while(RecordSet.next());
}
%>
</TBODY>
</TABLE>
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

</BODY>
</HTML>
