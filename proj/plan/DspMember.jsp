
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));
String level = Util.null2String(request.getParameter("level"));
String subject= Util.fromScreen2(request.getParameter("subject"),user.getLanguage());
String begindate01= Util.null2String(request.getParameter("begindate01"));
String begindate02= Util.null2String(request.getParameter("begindate02"));
String enddate01= Util.null2String(request.getParameter("enddate01"));
String enddate02= Util.null2String(request.getParameter("enddate02"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
if(level.equals("")){
	level = "10" ;
}
String log = Util.null2String(request.getParameter("log"));

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1349,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

//modify by dongping for td729
ProcPara = ProjID + flag + "0" ;
RecordSetHrm.executeProc("Prj_Member_SumProcess",ProcPara);

String CurrentUser = ""+user.getUID();
int usertype = 0;
if(user.getLogintype().equals("2"))
	usertype= 1;

ArrayList requesttaskids=new ArrayList();
ArrayList requesttaskcounts=new ArrayList();
ArrayList doctaskids=new ArrayList();
ArrayList doctaskcounts=new ArrayList();

String sqlstr="";
sqlstr="select t3.taskid, count(distinct t3.requestid) from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" group by t3.taskid ";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		requesttaskids.add(RecordSetC.getString(1));
		requesttaskcounts.add(RecordSetC.getString(2));
}

sqlstr="SELECT t3.taskid, count(distinct t3.docid) FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3  where t1.id = t2.sourceid  and t1.id = t3.docid  and t3.prjid = "+ProjID+" group by t3.taskid ";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		doctaskids.add(RecordSetC.getString(1));
		doctaskcounts.add(RecordSetC.getString(2));
}


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/plan/NewPlan.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=weaver method=post action="/proj/plan/DspMember.jsp">
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

<table class=liststyle cellspacing=1 >
  <tr class=datadark>
     <td width="60"><%=SystemEnv.getHtmlLabelName(2099,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=level size=1 class=inputstyle   onChange="weaver.submit()">
		 <%for(int i=1;i<=10;i++){%>
			 <option value="<%=i%>" <%if(level.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>	 
	 </td>
     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></td>
     <td class=field>&nbsp
		<input name=subject size=15 class="InputStyle" value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>">	 
	 </td>
     <TD align=right><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate01span,begindate01)></BUTTON>&nbsp;
			  <SPAN id=begindate01span ><%=begindate01%></SPAN>
			  <input type="hidden" name="begindate01" value="<%=begindate01%>">
			  －	<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate02span,begindate02)></BUTTON>&nbsp;
			  <SPAN id=begindate02span ><%=begindate02%></SPAN>
			  <input type="hidden" name="begindate02" value="<%=begindate02%>">
		  
	</TD>
     <TD align=right><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate01span,enddate01)></BUTTON>&nbsp;
			  <SPAN id=enddate01span ><%=enddate01%></SPAN>
			  <input type="hidden" name="enddate01" value="<%=enddate01%>">
			  －	<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate02span,enddate02)></BUTTON>&nbsp;
			  <SPAN id=enddate02span ><%=enddate02%></SPAN>
			  <input type="hidden" name="enddate02" value="<%=enddate02%>">
		  
	</TD>
     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=hrmid size=1 class=inputstyle   onChange="weaver.submit()">
			 <option value="" <%if(hrmid.equals("")){%>selected<%}%>></option>
		 <%while(RecordSetHrm.next()){%>
			 <option value="<%=RecordSetHrm.getString("hrmid")%>" <%if(RecordSetHrm.getString("hrmid").equals(""+hrmid)){%>selected<%}%>><%=ResourceComInfo.getResourcename(RecordSetHrm.getString("hrmid"))%></option>
		 <%}%>
		 </select>	 
	 </td>
  </tr>
</table>
</form>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(2238,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></th>
	    </TR>
		<TR class=Line><td class="Line1"></th>
		<td class="Line1"></th>
		<td class="Line1"></th>
		<td class="Line1"></th>
		<td class="Line1"></th>
		<td class="Line1"></th></TR> 
<%
ProcPara = ProjID + flag + hrmid ;
RecordSet.executeProc("Prj_Member_SumProcess",ProcPara);
boolean isLight = false;

while(RecordSet.next()){
%>
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>>

          <TD class=fontred><%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>"><%if(RecordSet.getString("hrmid").equals(""+user.getUID())){ %><font class=fontred><%}}%><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%><%if(user.getLogintype().equals("1")){%><%if(RecordSet.getString("hrmid").equals(""+user.getUID())){ %></font></a><%}}%></TD>
          <TD class=fontred nowrap></TD>
          <TD class=fontred nowrap></TD>
          <TD class=fontred nowrap></TD>
          <TD class=fontred nowrap><%if(!RecordSet.getString("begindate").equals("x")){%><%=RecordSet.getString("begindate")%><%}%></TD>
          <TD class=fontred nowrap><%if(!RecordSet.getString("enddate").equals("-")){%><%=RecordSet.getString("enddate")%>		  <%}%></TD>

    </TR>
<%
			isLight = !isLight;

String sqlwhere="";
sqlwhere=" where prjid = "+ProjID+" and  parenthrmids like '%,"+RecordSet.getString("hrmid")+"|%' and  level_n <= "+level+" and isdelete<>'1' ";
if(!subject.equals("")){
	sqlwhere+=" and subject like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and begindate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and begindate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and enddate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and enddate<='"+enddate02+"'";
}

sqlstr = " SELECT * FROM Prj_TaskProcess " +sqlwhere+ " order by parentids";
RecordSet2.executeSql(sqlstr);


	while(RecordSet2.next()){
%>
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>>

          <TD>
				<%for(int i=1;i<RecordSet2.getInt("level_n");i++){%>&nbsp&nbsp&nbsp&nbsp<%}%>
			<img src="/images/project_rank_wev8.gif"><a href="/proj/plan/ViewTask.jsp?taskrecordid=<%=RecordSet2.getString("id")%>" ><%=RecordSet2.getString("subject")%></a></TD>
          <TD nowrap>
<%
		String temptaskid="";
		String temprequestcount="0";
		String tempdoccount="0";
		for(int i=0;i<requesttaskids.size();i++){
			temptaskid=(String) requesttaskids.get(i);
			if(temptaskid.equals(RecordSet2.getString("id"))) {
				temprequestcount=(String) requesttaskcounts.get(i);
				break;
			}
		}
		for(int i=0;i<doctaskids.size();i++){
			temptaskid=(String) doctaskids.get(i);
			if(temptaskid.equals(RecordSet2.getString("id"))) {
				tempdoccount=(String) doctaskcounts.get(i);
				break;
			}
		}
%>
			<%if(!temprequestcount.equals("0")){%>
				<a href="/proj/plan/ViewTask.jsp?taskrecordid=<%=RecordSet2.getString("id")%>" ><img src="/images/prj_request_wev8.gif" border=0 alt="工作流"></a><%=temprequestcount%> 
			<%}%>
			<%if(!tempdoccount.equals("0")){%>
				<a href="/proj/plan/ViewTask.jsp?taskrecordid=<%=RecordSet2.getString("id")%>" ><img src="/images/prj_doc_wev8.gif" border=0 alt="文档"></a><%=tempdoccount%>
			<%}%>
		  </TD>
          <TD nowrap><%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet2.getString("hrmid")%>"><%if(RecordSet2.getString("hrmid").equals(""+user.getUID())){ %><font class=fontred><%}}%><%=ResourceComInfo.getResourcename(RecordSet2.getString("hrmid"))%><%if(user.getLogintype().equals("1")){%><%if(RecordSet2.getString("hrmid").equals(""+user.getUID())){ %></font></a><%}}%></TD>
          <TD nowrap><%=RecordSet2.getString("workday")%></TD>
          <TD nowrap><%if(!RecordSet2.getString("begindate").equals("x")){%><%=RecordSet2.getString("begindate")%><%}%></TD>
          <TD nowrap><%if(!RecordSet2.getString("enddate").equals("-")){%><%=RecordSet2.getString("enddate")%>		  <%}%></TD>

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
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
