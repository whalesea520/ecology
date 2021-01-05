
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="meetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);
String allUser=MeetingShareUtil.getAllUser(user);
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String software = (String)staticobj.getObject("software") ;
if(software == null) software="ALL";

String ProcPara = "";
char flag=Util.getSeparator() ;

String meetingid = Util.null2String(request.getParameter("meetingid"));
boolean canJueyi = Util.str2bool(Util.null2String(request.getParameter("canJueyi")));
String isdecision = Util.null2String(request.getParameter("isdecision"));
String othermembers = Util.null2String(request.getParameter("othermembers"));
boolean ismanager = Util.str2bool(Util.null2String(request.getParameter("ismanager")));

String othersremark = "";
String enddate="";
String endtime="";

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);

String sqlstr="select othersremark,enddate,endtime from meeting where id="+meetingid;
RecordSet.executeSql(sqlstr);
if(RecordSet.next()){
	othersremark = RecordSet.getString("othersremark");
	enddate=RecordSet.getString("enddate");
	endtime=RecordSet.getString("endtime");
}

int hrmnum=0;
int crmnum=0;
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
int reduceCol=7;
%>
	<TABLE  class="ListStyle" cellspacing=1>
        <TBODY>
        <TR class="header">
          <TH  align=left style="min-width:140px;"><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%> <%=RecordSet.getCounts()%> <%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>)</TH>
          <TH  align=left style="min-width:30px;"><%=SystemEnv.getHtmlLabelName(2195,user.getLanguage())%></TH>
          <%if(meetingSetInfo.getRecArrive()==1){reduceCol=reduceCol-1;%>
          <TH  align=left style="min-width:70px;"><%=SystemEnv.getHtmlLabelName(2196,user.getLanguage())%></TH>
          <%} if(meetingSetInfo.getRecBook()==1){reduceCol=reduceCol-2;%>
          <TH  align=left style="min-width:30px;"><%=SystemEnv.getHtmlLabelName(2197,user.getLanguage())%></TH>
          <TH  align=left style="min-width:50px;"><%=SystemEnv.getHtmlLabelName(2198,user.getLanguage())%></TH>
          <%}if(meetingSetInfo.getRecReturn()==1){reduceCol=reduceCol-3;%>
          <TH  align=left style="min-width:50px;"><%=SystemEnv.getHtmlLabelName(2199,user.getLanguage())%></TH>
          <TH  align=left style="min-width:70px;"><%=SystemEnv.getHtmlLabelName(2200,user.getLanguage())%></TH>
          <TH  align=left style="min-width:60px;"><%=SystemEnv.getHtmlLabelName(2182,user.getLanguage())%></TH>
          <%}if(meetingSetInfo.getRecRemark()==1){reduceCol=reduceCol-1;%>
          <TH  align=left style="min-width:40px;"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          <%} %>
          <TH  align=left style="width:20px;"></TH>
		</TR>
<%
while(RecordSet.next()){

%>
        <TR class="DataDark">
          <TD class="Field"> 
			<input class="inputstyle" type=checkbox  checked disabled/>
			<a href=javaScript:openhrm(<%=RecordSet.getString("memberid")%>); onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%></a>
		  </TD>
          <TD class="Field"> 
			<%if(RecordSet.getString("isattend").equals("1")){hrmnum+=1;%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("3")){%><%=SystemEnv.getHtmlLabelName(2188,user.getLanguage())%><%}%>
		  </TD>
		  <%if(meetingSetInfo.getRecArrive()==1){ %>
          <TD class="Field"> 
			<%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%>
		  </TD>
		  <%} if(meetingSetInfo.getRecBook()==1){%>
          <TD class="Field"> 
			<%if(RecordSet.getString("bookroom").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookroom").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class="Field"> 
			<%=RecordSet.getString("roomstander")%>
		  </TD>
		  <%}if(meetingSetInfo.getRecReturn()==1){%>
          <TD class="Field"> 
			<%if(RecordSet.getString("bookticket").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookticket").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class="Field"> 
			<%=RecordSet.getString("enddate")%> <%=RecordSet.getString("endtime")%>
		  </TD>
          <TD class="Field"> 
			<%if(RecordSet.getString("ticketstander").equals("1")){%><%=SystemEnv.getHtmlLabelName(2201,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("2")){%><%=SystemEnv.getHtmlLabelName(2202,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("3")){%><%=SystemEnv.getHtmlLabelName(2203,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("4")){%><%=SystemEnv.getHtmlLabelName(2204,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("5")){%><%=SystemEnv.getHtmlLabelName(2205,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("6")){%><%=SystemEnv.getHtmlLabelName(2206,user.getLanguage())%><%}%>
		  </TD>
		  <%}if(meetingSetInfo.getRecRemark()==1){%>
		  <TD class="Field"> 
			<%=RecordSet.getString("recRemark")%>
		  </TD>
		  <%} %>
		  <td class="Field">
			<% if((canJueyi || MeetingShareUtil.containUser(allUser,RecordSet.getString("membermanager"))) && (!isdecision.equals("1") && !isdecision.equals("2"))&&(enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)>0){%><button type="button" onClick="onShowReHrm(<%=RecordSet.getString("id")%>,<%=meetingid%>)" class=e8_btn_cancel  style="padding-left:3px !important;padding-right:3px !important;width:60px"><%=SystemEnv.getHtmlLabelName(2108,user.getLanguage())%></button><%}%>
		  </td>

        </TR>
		<%if(!RecordSet.getString("othermember").equals("")){%>
        <TR class="DataLight">
          
    <TD class="Field" colspan=9> <img border=0 src="/images/ArrowRightBlue_wev8.gif" align=middle />&nbsp;
      <%
				ArrayList arrayothermember = Util.TokenizerString(RecordSet.getString("othermember"),",");
				for(int i=0;i<arrayothermember.size();i++){
					hrmnum+=1;
			%>
	  <a href=javaScript:openhrm(<%=""+arrayothermember.get(i)%>); onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(""+arrayothermember.get(i))%></a>&nbsp;
      <%}%>
    </TD>
		</TR>
		<%}%>	
<%}%>
<%if(software.equals("ALL") || software.equals("CRM")){%>

<%
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"2");
int cnt = 0;
while(RecordSet.next()){
%>
	<%if(cnt == 0) {%>
		<TR class="header">
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2167,user.getLanguage()) %> (<%=SystemEnv.getHtmlLabelName(32591,user.getLanguage())%> <%=RecordSet.getCounts()%>)</TH>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2195,user.getLanguage())%></TH>
			 <%if(meetingSetInfo.getRecArrive()==1){ %>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2196,user.getLanguage())%></TH>
			 <%}if(meetingSetInfo.getRecBook()==1){ %>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2197,user.getLanguage())%></TH>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2198,user.getLanguage())%></TH>
			 <%}if(meetingSetInfo.getRecReturn()==1){ %>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2199,user.getLanguage())%></TH>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2200,user.getLanguage())%></TH>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(2182,user.getLanguage())%></TH>
			 <%}if(meetingSetInfo.getRecRemark()==1){ %>
			 <TH  align=left><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
			 <%} %>
			 <TH  align=left></TH>
		</TR>
	<%
		cnt++;
	}
	%>
		  <TR class="DataDark">
          <TD class="Field">
			<input class="inputstyle" type=checkbox  checked disabled><A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("memberid")%>' target=\'_blank\'><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%></a>(<a href=javaScript:openhrm(<%=RecordSet.getString("membermanager")%>); onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(RecordSet.getString("membermanager"))%></a>)
		  </TD>
          <TD class="Field"> 
			<%if(RecordSet.getString("isattend").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("3")){%><%=SystemEnv.getHtmlLabelName(2188,user.getLanguage())%><%}%>
		  </TD>
		  <%if(meetingSetInfo.getRecArrive()==1){ %>
          <TD class="Field"> 
			<%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%>
		  </TD>
		  <%}if(meetingSetInfo.getRecBook()==1){ %>
          <TD class="Field"> 
			<%if(RecordSet.getString("bookroom").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookroom").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class="Field"> 
			<%=RecordSet.getString("roomstander")%>
		  </TD>
		  <%}if(meetingSetInfo.getRecReturn()==1){ %>
          <TD class="Field"> 
			<%if(RecordSet.getString("bookticket").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookticket").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class="Field"> 
			<%=RecordSet.getString("enddate")%> <%=RecordSet.getString("endtime")%>
		  </TD>
          <TD class="Field"> 
			<%if(RecordSet.getString("ticketstander").equals("1")){%><%=SystemEnv.getHtmlLabelName(2201,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("2")){%><%=SystemEnv.getHtmlLabelName(2202,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("3")){%><%=SystemEnv.getHtmlLabelName(2203,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("4")){%><%=SystemEnv.getHtmlLabelName(2204,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("5")){%><%=SystemEnv.getHtmlLabelName(2205,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("6")){%><%=SystemEnv.getHtmlLabelName(2206,user.getLanguage())%><%}%>
		  </TD>
		  <%}if(meetingSetInfo.getRecRemark()==1){ %>
		  <TD class="Field"> 
			<%=RecordSet.getString("recRemark")%>
		  </TD>
		  <%}%>
		  <td class="Field">
			<%
                //System.out.println("canJueyi:"+canJueyi+"    membermanager:"+RecordSet.getString("membermanager")+"   userid:"+userid);
                if((canJueyi || RecordSet.getString("membermanager").equals(userid)) && (!isdecision.equals("1") && !isdecision.equals("2"))&&(enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)>0){%><button type="button" onClick="onShowReCrm(<%=RecordSet.getString("id")%>,<%=meetingid%>)" class=e8_btn_cancel  style="padding-left:3px !important;padding-right:3px !important;width:60px"><%=SystemEnv.getHtmlLabelName(2108,user.getLanguage())%><%}%>
		  </td>
        </TR>
	<%
	RecordSet2.executeProc("Meeting_MemberCrm_SelectAll",RecordSet.getString("id"));
	if(RecordSet2.getCounts() > 0){
		%>
		<TR class="DataLight">
			<TD class="Field" colspan=<%=10-reduceCol %>> <img border=0 src="/images/ArrowRightBlue_wev8.gif" align=middle />&nbsp;
		<%
		while(RecordSet2.next()){
			crmnum+=1;
		%>		
			<a id="nomal" href="#" onclick="return false;" title="<%=meetingUtil.getMeetingOthersMbrDesc(RecordSet2.getString("name"), RecordSet2.getString("sex"), RecordSet2.getString("occupation"), RecordSet2.getString("tel"), RecordSet2.getString("handset"), RecordSet2.getString("desc_n"), user)%>" ><%=RecordSet2.getString("name")%></a>&nbsp;
		
				  
		<%}%>
		</TD>
		</TR>
	<%}%>
<%}%>	
<%}%>
			<tr class="DataLight" style="height: 1px">
				<td style="height: 1px" colspan=<%=10-reduceCol %>></td>
			</tr>
			<tr class="DataLight">
                <td><%=SystemEnv.getHtmlLabelName(2168,user.getLanguage())%>:<%=Util.toScreen(othermembers,user.getLanguage())%></td>
                <td colspan=<%=8-reduceCol %>><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>:<%=Util.toScreen(othersremark,user.getLanguage())%></td>
                <td><%if(ismanager && !isdecision.equals("1") && !isdecision.equals("2")){%><button type="button"  onClick="onShowReOthers(<%=meetingid%>)" class="e8_btn_cancel"  style="padding-left:3px !important;padding-right:3px !important;width:60px"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></button><%}%></td>
            </tr>
			  <TR class="DataDark">
			  <TD class="Field" colspan=<%=10-reduceCol %>>
				<%=SystemEnv.getHtmlLabelName(2207,user.getLanguage())%><font class="fontred"><%=hrmnum+crmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(2208,user.getLanguage())%><font class="fontred"><%=hrmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(2209,user.getLanguage())%><font class="fontred"><%=crmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
			  </TD>
			</TR>
        </TBODY>
	  </TABLE>
