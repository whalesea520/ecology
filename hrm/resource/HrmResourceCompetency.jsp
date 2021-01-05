<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(408,user.getLanguage());
String needfav ="1";
String needhelp ="";
String resourceid = Util.null2String(request.getParameter("id"));
ArrayList  competencyids = new ArrayList();
ArrayList  lastgrades = new ArrayList();
ArrayList  currentgrades = new ArrayList();
ArrayList  averagegrades = new ArrayList();
String lastdate = "" ;
String currentdate = "" ;
float lastgradecount = 0;
float currentgradecount = 0;
float averagegradecount = 0;

RecordSet.executeProc("HrmResource_SelectByID",resourceid);
RecordSet.next();
String firstname = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage()) ;			/*名*/
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓*/
String jobtitle = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage()) ;
String jobactivity= Util.toScreen(RecordSet.getString("jobactivity"),user.getLanguage()) ;
String joblevel = Util.toScreen(RecordSet.getString("joblevel"),user.getLanguage()) ;
String managerid = Util.toScreen(RecordSet.getString("managerid"),user.getLanguage()) ;

RecordSet.executeProc("HrmActivitiesCompetency_Select",jobactivity);
while(RecordSet.next()) {
	competencyids.add(RecordSet.getString("competencyid"));
	lastgrades.add("");currentgrades.add("");averagegrades.add("");
}
RecordSet.executeProc("HrmResourceCompetency_SByID",resourceid);
while(RecordSet.next())  {
	String competencyid = RecordSet.getString("competencyid");
	float lastgrade = Util.getFloatValue(RecordSet.getString("lastgrade"),0);
	float currentgrade = Util.getFloatValue(RecordSet.getString("currentgrade"),0);
	float countgrade = Util.getFloatValue(RecordSet.getString("countgrade"),0);
	float counttimes = Util.getFloatValue(RecordSet.getString("counttimes"),0);
	lastdate=RecordSet.getString("lastdate");
	currentdate=RecordSet.getString("currentdate");
	int indexid = competencyids.indexOf(competencyid) ;
	if(indexid!=-1) {
		lastgrades.set(indexid,""+lastgrade);
		currentgrades.set(indexid,""+currentgrade);
		float averagegrade = counttimes==0?0:countgrade/counttimes ;
		averagegrades.set(indexid,""+averagegrade);
		
		lastgradecount += lastgrade ;
		currentgradecount += currentgrade ;
		averagegradecount += averagegrade ;
	}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceCompetencyEdit:Edit",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/hrm/resource/HrmResourceCompetencyEdit.jsp?resourceid="+resourceid+"&jobactivity="+jobactivity+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResourceCompetencyAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(193,user.getLanguage())+",/hrm/resource/HrmResourceCompetencyAdd.jsp?resourceid="+resourceid+"&jobactivity="+jobactivity+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<FORM id=BACO name=BACO action=EPCompetency.asp?EmployeeID=17 method=post> 
  <TABLE class=viewFORM width="100%" border=0>
    <COLGROUP> <COL width="15%"> 
    <COL width="33%"> 
    <COL width=24> 
    <COL width="15%"> 
    <COL width="33%"> <TBODY> 
    <TR> 
      <TH align=left colSpan=5><%=SystemEnv.getHtmlLabelName(384,user.getLanguage())%> 
      </TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=5> 
      <TD></TD>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
      <TD class=Field><BUTTON class=Browser id=selectresourceid onClick="onShowResourceID()"></BUTTON> 
        <SPAN class=Small id=resourceidspan NAME="resourceidspan"><A 
      href="HrmResource.jsp?id=<%=resourceid%>"><%=firstname%> <%=lastname%></A></SPAN> 
      </TD>
      <TD>&nbsp;</TD>
      <TD><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%></TD>
      <TD class=Field><a href="HrmResourceComponent.jsp?resourceid=<%=resourceid%>"'><%=SystemEnv.getHtmlLabelName(503,user.getLanguage())%></a> </TD>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 
	<TR>
      <td><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></td>
      <td class=Field><%=jobtitle%>, <%=joblevel%></td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(2120,user.getLanguage())%></td>
      <td class=Field><a 
     href="HrmResource.jsp?id=<%=managerid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage())%></a> 
      </td>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <TR>
      <td><%=SystemEnv.getHtmlLabelName(525,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=Field><%=lastdate%></td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=Field><%=currentdate%>
      </td>
    </TR>
   <TR><TD class=Line colSpan=6></TD></TR> 

    <TR class=spacing> 
      <TD class=Sep1 colSpan=5></TD>
    </TR>
    <TR height=500> 
      <TD colSpan=2 height="19">&nbsp;</TD>
      <TD height="19"></TD>
      <TD colSpan=2 height="19">&nbsp;</TD>
    </TR>
    </TBODY> 
  </TABLE>
</FORM>
<table class=ListStyle cellspacing=1 >
  <colgroup> 
  <col width="30%"> 
  <col width=23%> 
  <col width="23%"> 
  <col width=23%>
  <tbody> 
  <tr class=Header> 
    <th><%=SystemEnv.getHtmlLabelName(408,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%></th>
	<th><%=SystemEnv.getHtmlLabelName(525,user.getLanguage())%></th>
	<th><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
int colorid = 0 ;
for(int j=0 ; j<competencyids.size();j++) {
if(colorid==0){	
	colorid=1;
%>
  <tr class=datadark> 
    <%}
else{
	colorid=0;
%>
  <tr class=datalight> 
    <%}
%>
    <td><a href="#"><%=Util.toScreen(CompetencyComInfo.getCompetencyname((String)competencyids.get(j)),user.getLanguage())%></a> </td>
    <td><%=(String)currentgrades.get(j)%></td>
	<td><%=(String)lastgrades.get(j)%></td>
	<td><%=(String)averagegrades.get(j)%></td>
  </tr>
  <%
}
%>
<TR class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
    <TD><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TD>
    <TD><%=currentgradecount%></TD>
    <TD class=FIELD><%=lastgradecount%></TD>
	<TD class=FIELD><%=averagegradecount%></TD>	
  </tr>
</table>
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
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		window.location = "HrmResourceCompetency.jsp?id="&id(0)
		end if
	end if
end sub
</script>
</BODY>
</HTML>