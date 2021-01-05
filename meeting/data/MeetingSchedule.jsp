
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />

<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(request.getParameter("meetingid"));

RecordSet.executeProc("Meeting_SelectByID",meetingid);
RecordSet.next();
String meetingtype=RecordSet.getString("meetingtype");
String meetingname=RecordSet.getString("name");
String caller=RecordSet.getString("caller");
String contacter=RecordSet.getString("contacter");
String address=RecordSet.getString("address");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String desc=RecordSet.getString("desc_n");
String creater=RecordSet.getString("creater");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String approver=RecordSet.getString("approver");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");
String isapproved=RecordSet.getString("isapproved");
String projectid=RecordSet.getString("projectid");//获得项目id
String totalmember=RecordSet.getString("totalmember");
String othermembers=RecordSet.getString("othermembers");
String addressdesc=RecordSet.getString("addressdesc");

if(address.equals("0")) address="" ;
boolean canschedule=false;

/***检查是否会议室管理员****/
rs.executeSql("select resourceid from hrmrolemembers where roleid=11 and resourceid="+userid) ;
if(rs.next()&& isapproved.equals("2")){
    canschedule=true;
}

if(!canschedule){
	response.sendRedirect("/notice/noright.jsp") ;
	return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2103,user.getLanguage())+":"+meetingname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<B><%=SystemEnv.getHtmlLabelName(401,user.getLanguage())%>:</B><%=createdate%><B> <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</B><%if(user.getLogintype().equals("1")){%><A href="/hrm/resource/HrmResource.jsp?id=<%=creater%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></A><%}%>  <B><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>:</B><%=approvedate%><B> <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</B><%if(user.getLogintype().equals("1")){%><A href="/hrm/resource/HrmResource.jsp?id=<%=approver%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(approver),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></A><%}%></DIV>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2190,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onreturn(),_self} " ;
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

<FORM id=weaver name=weaver action="/meeting/data/MeetingOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="schedule">
<input class=inputstyle type="hidden" name="meetingid" value="<%=meetingid%>">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
	<TD vAlign=top>
	
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TD>
          <TD class=Field><%=meetingname%></TD>
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>
          <TD class=Field><A href='/hrm/resource/HrmResource.jsp?id=<%=caller%>'><%=ResourceComInfo.getResourcename(caller)%></a></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field><A href='/hrm/resource/HrmResource.jsp?id=<%=contacter%>'><%=ResourceComInfo.getResourcename(contacter)%></a></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field>
          
          <A href='/proj/data/ViewProject.jsp?ProjID=<%=projectid%>'>
          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%>
          </a></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        </TBODY>
	  </TABLE>
	</TD>

	<TD></TD>

	<TD vAlign=top>
      
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=titel>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
          <TD class=Field> <BUTTON class=Calendar onclick="onShowDate(BeginDatespan,begindate)"></BUTTON> <SPAN id=BeginDatespan ><%=begindate%></SPAN> <input class=inputstyle type="hidden" name="begindate" value="<%=begindate%>"></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
          <TD class=Field><button class=Clock onclick="onShowTime(BeginTimespan,begintime)"></button><span id="BeginTimespan"><%=begintime%></span><input class=inputstyle type=hidden name="begintime" value="<%=begintime%>"></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field> <BUTTON class=Calendar onclick="onShowDate(EndDatespan,enddate)"></BUTTON> <SPAN id=EndDatespan ><%=enddate%></SPAN> <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>"></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
          <TD class=Field><button class=Clock onclick="onShowTime(EndTimespan,endtime)"></button><span id="EndTimespan"><%=endtime%></span><input class=inputstyle type=hidden name="endtime" value="<%=endtime%>"></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
          <TD class=Field>
          <%if(addressdesc.equals("1")){%><%=SystemEnv.getHtmlLabelName(2163,user.getLanguage())%> <%}%>
          <%if(addressdesc.equals("0")){%><%=SystemEnv.getHtmlLabelName(2164,user.getLanguage())%> <%}%>
			  <BUTTON class=Browser id=SelectAddress onclick="onShowAddress()"></BUTTON> 
              <SPAN id=addressspan><img src="/images/BacoError_wev8.gif" align=absmiddle></SPAN> 
              <input class=inputstyle id=address type=hidden name=address value="<%=address%>">
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        </TBODY>
	  </TABLE>
	</TD>
        </TR>
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%> <%=totalmember%> <%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>)</TH>
          </TR>
        <TR class=spacing>
          <TD class=line1></TD></TR>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>:  

<%
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
while(RecordSet.next()){
%>
			<input class=inputstyle type=checkbox  checked disabled><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("memberid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%></a>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2167,user.getLanguage())%>: 
<%
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"2");
while(RecordSet.next()){
%>
			<input class=inputstyle type=checkbox  checked disabled><A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("memberid")%>'><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%></a>(<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("membermanager")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("membermanager"))%></a>)&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td class=field><%=SystemEnv.getHtmlLabelName(2168,user.getLanguage())%>: 
          <%=Util.toScreen(othermembers,user.getLanguage())%>
          <td>
        <tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
        </TBODY>
	  </TABLE>

<%
RecordSet.executeProc("Meeting_Service2_SelectAll",meetingid);
if(RecordSet.getCounts()>0){
%>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(2107,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=line1 colspan=2></TD></TR>
<%
while(RecordSet.next()){
%>
        <TR>
		  <td><%=RecordSet.getString("name")%>(<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%></a>)</td>
          <TD> 
	  <TABLE class=Form>
        <TBODY>
        <TR>
          <TD class=Field>
<%
	ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
	for(int i=0;i<serviceitems.size();i++){
%>
		  <input class=inputstyle type=checkbox checked disabled><%=serviceitems.get(i)%>&nbsp&nbsp
<%
	}
%>&nbsp
		  </TD>
        </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
<%
}
%>
        </TBODY>
	  </TABLE>
<%}%>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=line1 colspan=2></TD></TR>
        <TR>
		  <td  class=Field>
		  <%=desc%>
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
</FORM>
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
 if(check_form(weaver,'address,begindate,begintime,enddate,endtime')
 weaver.submit();
}
}
function onreturn(){
    window.history.back();
}
</script>

<script language=vbs>
sub onShowAddress()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	addressspan.innerHtml ="<A href='/meeting/Maint/MeetingRoom.jsp'>"&id(1)&"</A>"
	weaver.address.value=id(0)
	else
	addressspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.address.value=""
	end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>