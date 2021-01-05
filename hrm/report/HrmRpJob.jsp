<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RpJobManager" class="weaver.hrm.report.RpJobManager" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(432,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
<%
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String resourcetype=Util.null2String(request.getParameter("linktype"));
String linktype="";
String[] resourcetypes=new String[4];
if(resourcetype.equals("")){
	resourcetypes=request.getParameterValues("resourcetype");	
	if(resourcetypes!=null){
		for(int a=0;a<resourcetypes.length;a++){
			if(a!=resourcetypes.length-1)	linktype+=resourcetypes[a]+",";
			else	linktype+=resourcetypes[a];
		}
	}
}
else{
	resourcetypes=Util.TokenizerString2(resourcetype,",");
}
//if(departmentid.equals(""))	departmentid=user.getUserDepartment()+"";
char separator = Util.getSeparator() ;
String action=Util.fromScreen(request.getParameter("action"),user.getLanguage());
if(action.equals(""))	action="jobgroup";
int actionid=Util.getIntValue(request.getParameter("actionid"),0);
%>
<form name=frmmain method=post action="HrmRpJob.jsp">
<input type=hidden name=action value="<%=action%>">
<input type=hidden name=actionid value="<%=actionid%>">
<table class=viewform>
  <TR CLASS=title><TH colspan=8><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
  <TR CLASS=spacing><TD CLASS=line1 colspan=8></TD></TR>
  <tr>
  <td width="15%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td width="25%" class=field><button class=Browser onClick="onShowDepartment();frmmain.submit()"></button>
  <span id=departmentname><%=Util.toScreen((DepartmentComInfo.getDepartmentmark(departmentid)+" - "+DepartmentComInfo.getDepartmentname(departmentid)),user.getLanguage())%></span>
  <input type=hidden id=departmentid name=departmentid value="<%=departmentid%>">
  </td>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		departmentname.innerHtml = id(1)
		frmmain.departmentid.value=id(0)
		else
		departmentname.innerHtml = empty
		frmmain.departmentid.value="0"
		end if
	end if
end sub
</script>
  <td width="10%" align="right"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
  <td width="10%"><input type=checkbox name=resourcetype value="2" onClick="frmmain.submit()" <%if(Util.contains(resourcetypes,"2")){%> checked <%}%>>
  <%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></td>
  <td width="10%"><input type=checkbox name=resourcetype value="1" onClick="frmmain.submit()" <%if(Util.contains(resourcetypes,"1")){%> checked <%}%>>
  <%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></td>
  <td width="10%"><input type=checkbox name=resourcetype value="3" onClick="frmmain.submit()" <%if(Util.contains(resourcetypes,"3")){%> checked <%}%>>
  <%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></td>
  <td width="10%"><input type=checkbox name=resourcetype value="4" onClick="frmmain.submit()" <%if(Util.contains(resourcetypes,"4")){%> checked <%}%>>
  <%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></td>
  <td width="10%">&nbsp;</td></tr>
</table>
</form>
<table class=ListStyle cellspacing=1>
  <COL WIDTH=10%>
  <COL WIDTH=70%>
  <COL WIDTH=10% ALIGN=RIGHT>
  <COL WIDTH=10% ALIGN=RIGHT>
  <TR CLASS=header><TH colspan=4><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH></TR>
<%
  int linecolor=0;
  int hasresult=0;
  int maxnum=0;
  ArrayList resultcounts=new ArrayList();
  ArrayList resultids=new ArrayList();
  int total=0;
  RpJobManager.resetParameter();
  if(Util.contains(resourcetypes,"2"))	RpJobManager.setResourcetype1("2");
  if(Util.contains(resourcetypes,"1"))	RpJobManager.setResourcetype2("1");
  if(Util.contains(resourcetypes,"3"))	RpJobManager.setResourcetype3("3");
  if(Util.contains(resourcetypes,"4"))	RpJobManager.setResourcetype4("4");
  RpJobManager.setDepartmentid(Util.getIntValue(departmentid,0));
  RpJobManager.setAction(action);
  RpJobManager.setActionid(actionid);
  
  RpJobManager.selectRpJob();
  while(RpJobManager.next()){
  	hasresult=1;
  	resultcounts.add(RpJobManager.getResultcount()+"");
  	resultids.add(RpJobManager.getResultid()+"");
  }
  RpJobManager.closeStatement();
%>
<%
	if(hasresult==0){
%>
  <tr><td colspan=4><%=SystemEnv.getHtmlNoteName(19,user.getLanguage())%></td></tr>
</table>
<%	}else{
for(int a=0;a<resultcounts.size();a++){
	if(a==0)	maxnum=Util.getIntValue((String)resultcounts.get(a),0);
	total+=Util.getIntValue((String)resultcounts.get(a),0);
}
%>
  <tr class=header>
  	<td>
  	<%if(action.equals("jobgroup")){%><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%><%}%>
  	<%if(action.equals("jobactivity")){%><%=SystemEnv.getHtmlLabelName(518,user.getLanguage())%><%}%>
  	<%if(action.equals("jobtitle")){%><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%><%}%>
  	</td>
  	<td>&nbsp;</td>
  	<td><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></td>
  	<td>%</td>
  </tr>  
<%
	for(int a=0;a<resultids.size();a++){
		int resultcount=Util.getIntValue((String) resultcounts.get(a),0);
		String resultid=(String) resultids.get(a);
		float resultpercent=0;
		float basepercent=0;
		if(a==0)	resultpercent=100;
		else{
			resultpercent=(float)resultcount*100/(float)maxnum;
			resultpercent=(float)((int)(resultpercent*100))/100;
		}
		basepercent=(float)resultcount*100/(float)total;
		basepercent=(float)((int)(basepercent*100))/100;
%>
  <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%>>
  	<td>
  	<%if(action.equals("jobgroup")){%>
  		<a href="HrmRpJob.jsp?action=jobactivity&actionid=<%=resultid%>&departmentid=<%=departmentid%>&linktype=<%=linktype%>">
  		<%=Util.toScreen(JobGroupsComInfo.getJobGroupsname(resultid),user.getLanguage())%></a><%}%>
  	<%if(action.equals("jobactivity")){%>
  		<a href="HrmRpJob.jsp?action=jobtitle&actionid=<%=resultid%>&departmentid=<%=departmentid%>&linktype=<%=linktype%>">
  		<%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(resultid),user.getLanguage())%></a><%}%>
  	<%if(action.equals("jobtitle")){%>
  		<a href="HrmRpJobTemp.jsp?action=jobtitle&actionid=<%=resultid%>&departmentid=<%=departmentid%>&linktype=<%=linktype%>">
  		<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(resultid),user.getLanguage())%></a><%}%>
  	</td>
  	<td><%if(resultcount!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR><%if(action.equals("jobtitle")){%>
	        <a href="HrmRpJobTemp.jsp?action=jobtitle&actionid=<%=resultid%>&departmentid=<%=departmentid%>&linktype=<%=linktype%>"><%}%>
	          <TD <%if(action.equals("jobgroup")){%>class=redgraph <%}%>
	          <%if(action.equals("jobactivity")){%>class=bluegraph <%}%><%if(action.equals("jobtitle")){%>class=greengraph style="CURSOR:HAND"<%}%>
	          width="<%=resultpercent%>%">&nbsp;</TD><%if(action.equals("jobtitle")){%></a><%}%>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(resultcount!=0){%>
	<%if(action.equals("jobgroup")){%>
	<a href="HrmRpJobTemp.jsp?action=jobgroup&actionid=<%=resultid%>&departmentid=<%=departmentid%>&linktype=<%=linktype%>">
	<%}%><%if(action.equals("jobactivity")){%>
	<a href="HrmRpJobTemp.jsp?action=jobactivity&actionid=<%=resultid%>&departmentid=<%=departmentid%>&linktype=<%=linktype%>">
	<%}%><%if(action.equals("jobtitle")){%>
	<a href="HrmRpJobTemp.jsp?action=jobtitle&actionid=<%=resultid%>&departmentid=<%=departmentid%>&linktype=<%=linktype%>">
	<%}%>
	<%}%>
	<%=resultcount%><%if(resultcount!=0){%></a><%}%></td>
	<td><%=basepercent%></td>
  </tr>
<%
	if(linecolor==0)	linecolor=1;
	else linecolor=0;
	}
%>
  <TR CLASS=Total STYLE=COLOR:RED;FONT-WEIGHT:BOLD>
     <TD><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TD>
     <TD></TD>
     <TD><%=total%></TD>
     <TD>100.00</TD>
  </TR>
</table>
<%
}	
%>
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
</body>
</html>