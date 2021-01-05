
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));
String log = Util.null2String(request.getParameter("log"));
String Version = Util.null2String(request.getParameter("version"));
int MaxVersion = 0 ;
int CurrentVersion = 0 ;
String isActived = "" ;
String isCurrentActived = "" ;
int MinLenWbscoding = 0 ;
RecordSet.executeProc("Prj_TaskInfo_SelectMaxVersion",ProjID);
if(RecordSet.next()){
	MaxVersion = RecordSet.getInt("version");
	isActived = RecordSet.getString("isactived"); 
}

if(MaxVersion==0){
	MaxVersion = 1;
}
if(Version.equals("")){
	Version = ""+MaxVersion ;
}
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(407,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/plan/ViewPlan.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=weaver method=post action="PlanDspMember.jsp">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
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

<table class=viewform>
  <tr>
     <td width="60"><%=SystemEnv.getHtmlLabelName(1333,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select   name=version size=1 class=inputstyle   onChange="weaver.submit()">
		 <%for(int i=1;i<=MaxVersion;i++){%>
			 <option value="<%=i%>" <%if(Version.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>	 
	 </td>
  </tr><TR><TD class=Line1 colSpan=2></TD></TR> 
</table>
</form>

<TABLE class=liststyle cellspacing=1 >
<TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%></th>
	    </TR><TR class=Line><Th colspan="5" ></Th></TR> 
<%
ProcPara = ProjID + flag + Version ;
RecordSet.executeProc("Prj_Member_SumPlan",ProcPara);
boolean isLight = false;

while(RecordSet.next()){
%>
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>>

          <TD class=fontred><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("relateid")%>"><%=ResourceComInfo.getResourcename(RecordSet.getString("relateid"))%></a></TD>
          <TD class=fontred><%=RecordSet.getString("workday")%></TD>
          <TD class=fontred><%if(!RecordSet.getString("begindate").equals("x")){%><%=RecordSet.getString("begindate")%><%}%></TD>
          <TD class=fontred><%if(!RecordSet.getString("enddate").equals("-")){%><%=RecordSet.getString("enddate")%>		  <%}%></TD>
          <TD class=fontred><%=RecordSet.getString("cost")%></TD>

    </TR>
<%
			isLight = !isLight;
	ProcPara = ProjID + flag + Version + flag + RecordSet.getString("relateid");
	RecordSet2.executeProc("Prj_Member_SelectAllPlan",ProcPara);
	while(RecordSet2.next()){
%>
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>>

          <TD>
				<%for(int i=1;i<RecordSet2.getString("wbscoding").length();i++){%>&nbsp&nbsp<%}%>
			<img src="/images/project_rank_wev8.gif" alt="<%=RecordSet2.getString("wbscoding")%>"><a href="/proj/plan/ViewTask.jsp?taskrecordid=<%=RecordSet2.getString("taskrecordid")%>" title="<%=RecordSet2.getString("wbscoding")%>"><%=RecordSet2.getString("subject")%></a></TD>
          <TD><%=RecordSet2.getString("workday")%></TD>
          <TD><%if(!RecordSet2.getString("begindate").equals("x")){%><%=RecordSet2.getString("begindate")%><%}%></TD>
          <TD><%if(!RecordSet2.getString("enddate").equals("-")){%><%=RecordSet2.getString("enddate")%>		  <%}%></TD>
          <TD><%=(RecordSet2.getFloat("cost")*RecordSet2.getFloat("workday"))%></TD>

    </TR>
<%
}
		isLight = !isLight;
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
