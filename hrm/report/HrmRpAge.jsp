<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RpAgeManager" class="weaver.hrm.report.RpAgeManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(671,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15353,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<%
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String[] resourcetypes=request.getParameterValues("resourcetype");
String resourcetype="";
if(resourcetypes!=null){
	for(int a=0;a<resourcetypes.length;a++){
		if(a!=resourcetypes.length-1)	resourcetype+=resourcetypes[a]+",";
		else	resourcetype+=resourcetypes[a];
	}
}
//if(departmentid.equals(""))	departmentid=user.getUserDepartment()+"";
char separator = Util.getSeparator() ;
%>
<form name=frmmain method=post action="HrmRpAge.jsp">
<table class=viewform>
  <TR CLASS=title><TH colspan=8><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
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
</table>
</form>
<table class=ListStyle cellspacing=1 >
  <COL WIDTH=10%>
  <COL WIDTH=70%>
  <COL WIDTH=10% ALIGN=RIGHT>
  <COL WIDTH=10% ALIGN=RIGHT>
  <TR CLASS=Header>
  <TH colspan=4><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH></TR>
 <%
  int linecolor=0;
  int hasresult=0;
  ArrayList agenums=new ArrayList();
  ArrayList yearorders=new ArrayList();
  int total=0;
  int tempnum=0;
  RpAgeManager.resetParameter();
  if(Util.contains(resourcetypes,"2"))	RpAgeManager.setResourcetype1("2");
  if(Util.contains(resourcetypes,"1"))	RpAgeManager.setResourcetype2("1");
  if(Util.contains(resourcetypes,"3"))	RpAgeManager.setResourcetype3("3");
  if(Util.contains(resourcetypes,"4"))	RpAgeManager.setResourcetype4("4");
  RpAgeManager.setDepartmentid(Util.getIntValue(departmentid,0));
  RpAgeManager.selectRpAge();
  while(RpAgeManager.next()){
  	hasresult=1;
  	agenums.add(RpAgeManager.getAgenum()+"");
  	yearorders.add(RpAgeManager.getYearorder()+"");
  }
  RpAgeManager.closeStatement();
%>
<%
	if(hasresult==0){
%>
  <tr><td colspan=4><%=SystemEnv.getHtmlNoteName(19,user.getLanguage())%></td></tr>
</table>
<%	}
	else{
for(int a=0;a<agenums.size();a++){
	total+=Util.getIntValue((String)agenums.get(a),0);
}
%>
  <tr class=header>
  	<td><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></td>
  	<td>&nbsp;</td>
  	<td><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></td>
  	<td>%</td>
    <TR class=Line><TD colspan="4" ></TD></TR> 
  </tr>
  <tr class=datalight>
  	<td><20</td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)<4)	tempnum+=Util.getIntValue((String)agenums.get(a),0);
	}
	float resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=19&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>">
	          <TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=19&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datadark>
  	<td>20 - 24</td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)==4)	tempnum=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=20&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=20&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datalight>
  	<td>25-29</td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)==5)	tempnum+=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=25&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=25&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datadark>
  	<td>30 - 34</td>
<%	
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)==6)	tempnum=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=30&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=30&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datalight>
  	<td>35 - 39</td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)==7)	tempnum=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=35&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=35&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datadark>
  	<td>40 - 44</td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)==8)	tempnum=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=40&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=40&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datalight>
  	<td>45 - 49</td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)==9)	tempnum=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=45&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=45&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datadark>
  	<td>50 - 54</td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)==10)	tempnum=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=50&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=50&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datalight>
  	<td> >=55 </td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)>10&&Util.getIntValue((String)yearorders.get(a),0)<400)	
			tempnum+=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?year=55&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?year=55&departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr>
  <tr class=datadark>
  	<td><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%></td>
<%
	tempnum=0;
	for(int a=0;a<yearorders.size();a++){
		if( Util.getIntValue((String)yearorders.get(a),0)>=400)	
			tempnum+=Util.getIntValue((String)agenums.get(a),0);
	}
	resultpercent=(float)tempnum*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/100;
%>
	<td><%if(tempnum!=0){%>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
	          <a href="HrmRpAgeTemp.jsp?departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><TD class=redgraph style="CURSOR:HAND" width="<%=resultpercent%>%">&nbsp;</TD></a>
	          <TD>&nbsp;</TD>
	        </TR></TBODY></TABLE>
	    <%} else {%>&nbsp;<%}%>
	</td>
	<td><%if(tempnum!=0){%><a href="HrmRpAgeTemp.jsp?departmentid=<%=departmentid%>&resourcetype=<%=resourcetype%>"><%}%>
	<%=tempnum%><%if(tempnum!=0){%></a><%}%></td>
	<td><%=resultpercent%></td>
  </tr> 
  <TR CLASS=Total STYLE=COLOR:RED;FONT-WEIGHT:BOLD>
     <TD><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TD>
     <TD></TD>
     <TD><%=total%></TD>
     <TD>100.00</TD>
  </TR>
</table>
<%	}
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

<SCRIPT language=javascript>
function onSearch(){
	document.frmmain.action="HrmRpAgeResult.jsp";
	frmmain.submit();
}
</SCRIPT>
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
</body>
</html>