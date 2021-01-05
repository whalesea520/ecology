
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="page"/>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String method=Util.null2String(request.getParameter("method"));
String from=Util.null2String(request.getParameter("from"));
if(method.equals("empty"))
{
	MeetingSearchComInfo.resetSearchInfo();
}


if("monitor".equals(from)&&!HrmUserVarify.checkUserRight("meetingmonitor:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}



%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onGoSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",/meeting/search/Search.jsp?method=empty&from="+from+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver action="/meeting/search/SearchOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="destination" value="no"> 
<input type="hidden" name="from" value="<%=from%>"> 
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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width="49%">
  <TBODY>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2></TD>
  </TR>
  
  <TR>

	<TD vAlign=top colspan="2"> 
	  
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td  class=Field>
				<%
				String meetingtypes = ","+MeetingSearchComInfo.getmeetingtype()+",";
				RecordSetCT.executeProc("Meeting_Type_SelectAll","");
				while(RecordSetCT.next()){
					if(meetingtypes.indexOf(","+RecordSetCT.getString("id")+",")!=-1){%>			
								<input class=inputstyle name="meetingtype" type="checkbox" value="<%=RecordSetCT.getString("id")%>" checked><%=Util.forHtml(Util.toScreen(RecordSetCT.getString("name"),user.getLanguage()))%>
					<%}else{%>			
								<input class=inputstyle name="meetingtype" type="checkbox" value="<%=RecordSetCT.getString("id")%>"><%=Util.forHtml(Util.toScreen(RecordSetCT.getString("name"),user.getLanguage()))%>
					<%}
				}%>			
			</td>
		</tr>
		<TR class=spacing style="height:1px">
          <TD class=line colSpan=2></TD></TR>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>
			</td>
			<td class=Field>
			  <%String meetingstatus = ","+MeetingSearchComInfo.getmeetingstatus()+",";
			  %>
				<input  class=inputstyle type="checkbox" name="meetingstatus" value="0" <%if(meetingstatus.indexOf(",0,")!=-1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%> 
				<input  class=inputstyle type="checkbox" name="meetingstatus" value="1" <%if(meetingstatus.indexOf(",1,")!=-1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%> 
				<input  class=inputstyle type="checkbox" name="meetingstatus" value="2" <%if(meetingstatus.indexOf(",2,")!=-1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> 
				<input  class=inputstyle type="checkbox" name="meetingstatus" value="3" <%if(meetingstatus.indexOf(",3,")!=-1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%> 
				<input  class=inputstyle type="checkbox" name="meetingstatus" value="4" <%if(meetingstatus.indexOf(",4,")!=-1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20114,user.getLanguage())%>
				<input  class=inputstyle type="checkbox" name="meetingstatus" value="5" <%if(meetingstatus.indexOf(",5,")!=-1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>
			</td>
		</tr>
        <TR class=spacing style="height:1px">
          <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=50 size=30 name="name" value="<%=MeetingSearchComInfo.getname()%>"></TD>
        </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field>
			  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(begindatespan,begindate)></BUTTON>&nbsp;
			  <SPAN id=begindatespan ><%=MeetingSearchComInfo.getbegindate()%></SPAN>
			  <input class=inputstyle type="hidden" name="begindate" value="<%=MeetingSearchComInfo.getbegindate()%>">
			  －<BUTTON class=calendar type=button id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=MeetingSearchComInfo.getenddate()%></SPAN>
			  <input class=inputstyle type="hidden" name="enddate" value="<%=MeetingSearchComInfo.getenddate()%>">
		  
		  </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
          <TD class=Field>
              <input class=wuiBrowser id=address type=hidden name=address value="<%=MeetingSearchComInfo.getaddress()%>"
              _url="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp">
		  </TD>
        </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>
          <TD class=Field>
			<input class=wuiBrowser type=hidden name="callers" value="<%=MeetingSearchComInfo.getcallers()%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'  target='_blank' >#b{name}</a>&nbsp;"
			_trimLeftComma="yes"
			>
			<span id="callersspan">
			<%if(!MeetingSearchComInfo.getcallers().equals("")){
				ArrayList arraycallers = Util.TokenizerString(MeetingSearchComInfo.getcallers(),",");
				for(int i=0;i<arraycallers.size();i++){
			%>
						<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arraycallers.get(i)%>'  target='_blank' ><%=ResourceComInfo.getResourcename(""+arraycallers.get(i))%></a>&nbsp
			<%}}%>				
			</span> 
		  </TD>
        </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
			<input class=wuiBrowser type=hidden name="contacters" value="<%=MeetingSearchComInfo.getcontacters()%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'  target='_blank' >#b{name}</a>&nbsp;"
			_trimLeftComma="yes"
			>
			<span id="contactersspan">
			<%if(!MeetingSearchComInfo.getcontacters().equals("")){
				ArrayList arraycontacters = Util.TokenizerString(MeetingSearchComInfo.getcontacters(),",");
				for(int i=0;i<arraycontacters.size();i++){
			%>
						<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arraycontacters.get(i)%>' target='_blank' ><%=ResourceComInfo.getResourcename(""+arraycontacters.get(i))%></a>&nbsp
			<%}}%>			
			</span> 
		  </TD>
        </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>
          <TD class=Field>
			<input class=wuiBrowser type=hidden name="creaters" value="<%=MeetingSearchComInfo.getcreaters()%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'  target='_blank' >#b{name}</a>&nbsp;">
			<span id="creatersspan">
			<%if(!MeetingSearchComInfo.getcreaters().equals("")){
				ArrayList arraycreaters = Util.TokenizerString(MeetingSearchComInfo.getcreaters(),",");
				for(int i=0;i<arraycreaters.size();i++){
			%>
						<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arraycreaters.get(i)%>'  target='_blank' ><%=ResourceComInfo.getResourcename(""+arraycreaters.get(i))%></a>&nbsp
			<%}}%>				
			</span> 
		  </TD>
        </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>(HRM)</TD>
          <TD class=Field>
			<input class=wuiBrowser type=hidden name="hrmids" id="hrmids" value="<%=MeetingSearchComInfo.gethrmids()%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _callBack="onShowCommiterHrm"
			_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'  target='_blank' >#b{name}</a>&nbsp;">
			<span id="hrmidsspan">
			<%if(!MeetingSearchComInfo.gethrmids().equals("")){
				ArrayList arrayhrmids = Util.TokenizerString(MeetingSearchComInfo.gethrmids(),",");
				for(int i=0;i<arrayhrmids.size();i++){
			%>
						<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arrayhrmids.get(i)%>'  target='_blank' ><%=ResourceComInfo.getResourcename(""+arrayhrmids.get(i))%></a>&nbsp
			<%}}%>				
			</span> 
		  </TD>
        </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<%if(isgoveproj==0){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>(CRM)</TD>
          <TD class=Field>
			<input class=wuiBrowser type=hidden name="crmids" value="<%=MeetingSearchComInfo.getcrmids()%>"
			_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
			_displayTemplate="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}' target='_blank'>#b{name}</a>&nbsp;"> 
			<span id="crmidsspan">
			<%if(!MeetingSearchComInfo.gethrmids().equals("")){
				ArrayList arraycrmids = Util.TokenizerString(MeetingSearchComInfo.getcrmids(),",");
				for(int i=0;i<arraycrmids.size();i++){
			%>
						<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+arraycrmids.get(i)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+arraycrmids.get(i))%></a>&nbsp
			<%}}%>				
			</span> 
		  </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field>
	 
<span id=projectidspan><A href='/proj/data/ViewProject.jsp?ProjID=<%=MeetingSearchComInfo.getprojectid()%>'>          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(MeetingSearchComInfo.getprojectid()),user.getLanguage())%>
          </a></span> 
        	 <input class=wuiBrowser type=hidden name=projectid value="<%=MeetingSearchComInfo.getprojectid()%>"
        	 _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
        	 _displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}' target='_blank'>#b{name}</A>">  
		  </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<%}%>
        </TBODY>
	  </TABLE>
	</TD>
  </TR>
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
</FORM>
<script language=javascript>
function onGoSearch(){
weaver.destination.value="goSearch";
weaver.submit();
}

function onShowCommiterHrm(datas,e){
 if(datas.id!=""){
  jQuery("#hrmids").val(datas.id.substr(1,datas.id.length));
 } 
}

</script>

<script language=vbs>

sub onShowAddress()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	addressspan.innerHtml =id(1)
	weaver.address.value=id(0)
	else
	addressspan.innerHtml = ""
	weaver.address.value=""
	end if
	end if
end sub	

sub onShowMHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
				end if
end sub

sub onShowMCrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpids)
		if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
				end if
end sub
sub onShowProjectID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	projectidspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	weaver.projectid.value=id(0)
	else 
	if objval="2" then
				projectidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				projectidspan.innerHtml =""
			end if
	weaver.projectid.value="0"
	end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>