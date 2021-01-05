<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page"/>
<jsp:useBean id="RpTrainPeoNumByTypeManager" class="weaver.hrm.report.RpTrainPeoNumByTypeManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(834,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
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
String traintypeid=Util.fromScreen(request.getParameter("traintypeid"),user.getLanguage());
String startdate=Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String direction=Util.fromScreen(request.getParameter("direction"),user.getLanguage());
if(direction.equals("")){
	direction="1";
}
%>
<form name=frmmain method=post action="HrmRpTrainPeoNumByType.jsp">
    <table class=viewFORM>
    <col width=10%> <col width=30%> <col width=10%> <col width=30%> <col width=10%> <col width=10%> 
    <tr class=title> 
      <th colspan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th>
    </tr>
    <tr class= Spacing> 
      <td class=line1 colspan=6></td>
    </tr>
    <tr> 
      <TD><%=SystemEnv.getHtmlLabelName(807,user.getLanguage())%></TD>
      <TD class=Field> 
        <BUTTON class=Browser id=selecttraintypeid onClick="onShowTrainTypeID()"></BUTTON> 
        <SPAN class=inputstyle id=traintypeidspan><%=Util.toScreen(TrainTypeComInfo.getTrainTypename(traintypeid),user.getLanguage())%></SPAN> 
        <INPUT class=inputstyle id=traintypeid type=hidden name=traintypeid value="<%=traintypeid%>">
      </TD>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class="field"><button class=calendar id=SelectDate onClick=getStartDate()></button>&nbsp; 
        <span id=startdatespan > 
        <%=startdate%> 
        </span> -&nbsp;&nbsp;<button class=calendar id=SelectDate2 onClick="getEndDate()"></button>&nbsp; 
        <span id=enddatespan " > 
        <%=enddate%> 
        </span> 
        <input type="hidden" name="startdate" value="<%=startdate%>">
        <input type="hidden" name="enddate" value="<%=enddate%>">
	  </td>
	   <TD class="field"> 
        <INPUT  type=radio <%if (direction.equals("1")) {%>CHECKED<%}%> value=1 name=direction>
        <%=SystemEnv.getHtmlLabelName(1892,user.getLanguage())%></TD>
     <TD class="field"> 
        <INPUT  type=radio <%if (direction.equals("2")) {%>CHECKED<%}%> value=2 name=direction>
        <%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
    </tr>
  </table>
</form>

<table class=ListStyle cellspacing=1 >
 <TR class=Header> 
<th colspan=4 align=left><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></th>
 
<COL WIDTH=20%>
<COL WIDTH=60%>
<COL WIDTH=10% ALIGN=RIGHT>
<COL WIDTH=10% ALIGN=RIGHT>
<%
  int linecolor=0;
  int hasresult=0;
  ArrayList trainpeonumtotals=new ArrayList();
  ArrayList departmentids=new ArrayList();

  int total=0;
  RpTrainPeoNumByTypeManager.resetParameter();
  RpTrainPeoNumByTypeManager.setTrainTypeid(Util.getIntValue(traintypeid,0));
  RpTrainPeoNumByTypeManager.setStartdate(startdate);
  RpTrainPeoNumByTypeManager.setEnddate(enddate);
  RpTrainPeoNumByTypeManager.setDirection(direction);
  RpTrainPeoNumByTypeManager.selectRpTrainPeoNumByType();

  while(RpTrainPeoNumByTypeManager.next()){
  	hasresult=1;
  	trainpeonumtotals.add(RpTrainPeoNumByTypeManager.getTrainPeoNumTotal()+"");
	departmentids.add(RpTrainPeoNumByTypeManager.getDepartmentid()+"");
  }
  RpTrainPeoNumByTypeManager.closeStatement();
%>
<%
	if(hasresult==0){
%>
  <tr><td colspan=4><%=SystemEnv.getHtmlNoteName(19,user.getLanguage())%></td></tr>
</table>
<%	}
	else{
		for(int i=0;i<trainpeonumtotals.size();i++){
			total+=Util.getIntValue((String)trainpeonumtotals.get(i),0);
		}
%>
  <tr class=header>
  	<td><%=SystemEnv.getHtmlLabelName(834,user.getLanguage())%></td>
  	<td>&nbsp;</td>
  	<td><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></td>
  	<td>%</td>
  </tr>
    <TR class=Line><TD colspan="4" ></TD></TR> 
<%
for(int i=0;i<trainpeonumtotals.size();i++){
%>
  <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%>>
  	<td><%=Util.toScreen(DepartmentComInfo.getDepartmentname((String)departmentids.get(i)),user.getLanguage())%></td>
  	<td>
		<TABLE height="100%" cellSpacing=0 width="100%">
	        <TBODY><TR>
<%
		int temptrainpeonumtotals=Util.getIntValue((String) trainpeonumtotals.get(i),0);
		float resultpercent=0;
		resultpercent=(float)temptrainpeonumtotals*100/(float)total;
		resultpercent=(float)((int)(resultpercent*100))/100;
		float tempother = 1-resultpercent;
%>
	          <TD class=redgraph width="<%=resultpercent%>%">&nbsp;</TD>
			 <TD width="<%=tempother%>%">&nbsp;</TD>
	        </TR></TBODY></TABLE>
	</td>
	<td><%=temptrainpeonumtotals%></td>
	<td><%=resultpercent%></td>
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
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>

<script language=vbs>
sub onShowTrainTypeID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/tools/TrainTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	traintypeidspan.innerHtml = id(1)
	frmmain.traintypeid.value=id(0)
	else 
	traintypeidspan.innerHtml = ""
	frmmain.traintypeid.value="" 
	end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
