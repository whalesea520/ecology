<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RpSeclevelManager" class="weaver.hrm.report.RpSeclevelManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(683,user.getLanguage());
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
String[] resourcetypes=request.getParameterValues("resourcetype");
String[] activestatuses=request.getParameterValues("activestatus");
String resourcetype="";
if(resourcetypes!=null){
	for(int a=0;a<resourcetypes.length;a++){
		if(a!=resourcetypes.length-1)	resourcetype+=resourcetypes[a]+",";
		else	resourcetype+=resourcetypes[a];
	}
}
int activestatus=0;
if(activestatuses!=null)
	if(activestatuses.length==1)	activestatus=Util.getIntValue((String)activestatuses[0]);	
//if(departmentid.equals(""))	departmentid=user.getUserDepartment()+"";
char separator = Util.getSeparator() ;
%>
<form name=frmmain method=post action="HrmRpSeclevel.jsp">
<table class=viewform>
  <TR CLASS=title><TH colspan=8><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
  <TR CLASS=spacing><TD CLASS=line1 colspan=8></TD></TR>
  <tr>
  <td width="15%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td width="25%" class=field><button class=Browser onClick="onShowDepartment();frmmain.submit()"></button>
  <span id=departmentname><%=Util.toScreen((DepartmentComInfo.getDepartmentmark(departmentid)+" - "+DepartmentComInfo.getDepartmentname(departmentid)),user.getLanguage())%></span>
  <input type=hidden id=departmentid name=departmentid value="<%=departmentid%>">
  </td>

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
<tr>
  <td colspan=2>&nbsp;</td>
  <td width="10%" align="right"><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
  <td width="10%"><input type=checkbox name=activestatus value="1" onClick="frmmain.submit()" <%if(Util.contains(activestatuses,"1")){%> checked <%}%>>
  <%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></td>
  <td width="10%"><input type=checkbox name=activestatus value="2" onClick="frmmain.submit()" <%if(Util.contains(activestatuses,"2")){%> checked <%}%>>
  <%=SystemEnv.getHtmlLabelName(415,user.getLanguage())%></td>
  <td colspan=3>&nbsp;</td>
  
</tr>
</table>
</form>
<table class=ViewForm>
  <TR class=title>
  <th width="40%"><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></th>
  <TD ALIGN=RIGHT width="10%"><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%>&nbsp;</TD>
  <TD CLASS="redgraph" width="5%">&nbsp;</TD>
  <TD ALIGN=RIGHT width="10%"><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%>&nbsp;</TD>
  <TD CLASS="bluegraph" width="5%">&nbsp;</TD>
  <TD ALIGN=RIGHT width="10%"><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%>&nbsp;</TD>
  <TD CLASS="greengraph" width="5%">&nbsp;</TD>
  <TD ALIGN=RIGHT width="10%"><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%>&nbsp;</TD>
  <TD CLASS="yellowgraph" width="5%">&nbsp;</TD>
  </TR>
</table>
<table class=ListStyle cellspacing=1 >
<COL WIDTH=10%>
<COL WIDTH=70%>
<COL WIDTH=10% ALIGN=RIGHT>
<COL WIDTH=10% ALIGN=RIGHT>
<%
  int linecolor=0;
  int hasresult=0;
  ArrayList resultcounts=new ArrayList();
  ArrayList resultids=new ArrayList();
  ArrayList resulttypes=new ArrayList();
  int total=0;
  int maxnum=0;
  RpSeclevelManager.resetParameter();
  if(Util.contains(resourcetypes,"2"))	RpSeclevelManager.setResourcetype1("2");
  if(Util.contains(resourcetypes,"1"))	RpSeclevelManager.setResourcetype2("1");
  if(Util.contains(resourcetypes,"3"))	RpSeclevelManager.setResourcetype3("3");
  if(Util.contains(resourcetypes,"4"))	RpSeclevelManager.setResourcetype4("4");
  RpSeclevelManager.setDepartmentid(Util.getIntValue(departmentid,0));
  RpSeclevelManager.setActivestatus(activestatus);
  RpSeclevelManager.selectRpSeclevel();
  while(RpSeclevelManager.next()){
  	hasresult=1;
  	resultcounts.add(RpSeclevelManager.getResultcount()+"");
  	resultids.add(RpSeclevelManager.getResultid()+"");
  	resulttypes.add(RpSeclevelManager.getResulttype());
  }
  RpSeclevelManager.closeStatement();
%>
<%
	if(hasresult==0){
%>
  <tr><td colspan=4><%=SystemEnv.getHtmlNoteName(19,user.getLanguage())%></td></tr>
</table>
<%	}
	else{
	for(int a=0;a<resultcounts.size();a++){
		if(Util.getIntValue((String)resultcounts.get(a),0)>maxnum){
			maxnum=Util.getIntValue((String)resultcounts.get(a),0);
		}
		total+=Util.getIntValue((String)resultcounts.get(a),0);
	}

%>
  <tr class=header>
  	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
  	<td>&nbsp;</td>
  	<td><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></td>
  	<td>%</td>
  </tr>
    <TR class=Line><TD colspan="4" ></TD></TR> 
<%
String tempid="";
int tempcount=0;
String temptype="";
for(int a=0;a<resultids.size();a++){
	if(!tempid.equals((String)resultids.get(a))){
		tempid=(String)resultids.get(a);
		tempcount=0;
		
%>
  <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%>>
  	<td><%=Util.toScreen(tempid,user.getLanguage())%></td>
  	<td>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
<%
	}
		int resultcount=Util.getIntValue((String) resultcounts.get(a),0);
		tempcount+=resultcount;
		float resultpercent=0;
		float basepercent=0;
		resultpercent=(float)resultcount*100/(float)maxnum;
		resultpercent=(float)((int)(resultpercent*100))/100;
		temptype=(String)resulttypes.get(a);
		basepercent=(float)tempcount*100/(float)total;
		basepercent=(float)((int)(basepercent*100))/100;
%>
	        <a href="HrmRpSeclevelTemp.jsp?seclevel=<%=tempid%>&departmentid=<%=departmentid%>&resourcetype=<%=temptype%>&activestatus=<%=activestatus%>">
	          <TD <%if(temptype.equals("2")){%>class=redgraph <%}%>
	              <%if(temptype.equals("1")){%>class=bluegraph <%}%>
	              <%if(temptype.equals("3")){%>class=greengraph <%}%>
	              <%if(temptype.equals("4")){%>class=yellowgraph <%}%> style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
<%
	if(a<(resultids.size()-1))
		if(tempid.equals((String)resultids.get(a+1)))	continue;
%>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	</td>
	<td><a href="HrmRpSeclevelTemp.jsp?seclevel=<%=tempid%>&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>&activestatus=<%=activestatus%>">
	<%=tempcount%></a></td>
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