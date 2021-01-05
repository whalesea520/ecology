
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="VerifyPower" class="weaver.proj.VerifyPower" scope="page" />

<%
char flag = 2;
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String recordid = Util.null2String(request.getParameter("recordid"));
RecordSet.executeProc("Prj_Find_MemberProcessbyid",recordid);
String prjid="";
String taskid="";
String relateid="";
String begindate="";
String enddate="";
String workday="";
String cost="";
if(RecordSet.next()){
	prjid = RecordSet.getString("prjid");
	taskid = RecordSet.getString("taskid");
	relateid = RecordSet.getString("relateid");
	begindate = RecordSet.getString("begindate");
	enddate = RecordSet.getString("enddate");
	workday=RecordSet.getString("workday");
	cost=RecordSet.getString("cost");
}
String ProjID = RecordSet.getString("prjid");

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

VerifyPower.init(request,response,ProjID);
if(logintype.equals("1")){
	iscreater = VerifyPower.isCreater();
	ismanager = VerifyPower.isManager();
	if(!iscreater && !ismanager){
		ismanagers = VerifyPower.isManagers();
	}
	if(!iscreater && !ismanager && !ismanagers){
		isrole = VerifyPower.isRole();
	}
}

if(iscreater || ismanager || ismanagers || isrole){
	canedit = true;
}

if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

RecordSet2.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet2.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData_VP");
RecordSet2.first();

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdPRJ_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(431,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",ProjMemberProcessOperation.jsp?taskrecordid="+taskrecordid+"&recordid="+recordid+"&method=delete,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver action="ProjMemberProcessOperation.jsp" method=post>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="recordid" value="<%=recordid%>">
<input type="hidden" name="prjid" value="<%=prjid%>">
<input type="hidden" name="taskid" value="<%=taskid%>">
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
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
          <TD class=Field>
		  <BUTTON class=Browser id=Selectrelateid onClick="onShowrelateid()"></BUTTON><span 
            id=Prjrelateidspan><A href="/hrm/resource/HrmResource.jsp?id=<%=relateid%>">
          <%=Util.toScreen(ResourceComInfo.getResourcename(relateid),user.getLanguage())%>
          </a></span> 
              <INPUT class=inputstyle type=hidden name="relateid" value=<%=relateid%>>
		  </TD>
        </TR> <TR class=spacing>
          <TD class=line colSpan=2></TD></TR>
 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(617,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(BDatePspan,begindate)"></BUTTON> 
              <SPAN id=BDatePspan >
			  	  <%if(!begindate.equals("x")){%>
						<%=begindate%>
				  <%}%>  
			  </SPAN> 
              <input type="hidden" name="begindate" id="BDateP" value="<%=begindate%>">-<BUTTON class=Calendar onclick="getDate(EDatePspan,enddate)"></BUTTON> 
              <SPAN id=EDatePspan >
			  	  <%if(!enddate.equals("-")){%>
						<%=enddate%>
				  <%}%>  			  
			  </SPAN> 
              <input type="hidden" name="enddate" id="EDateP" value="<%=enddate%>"></TD>
        </TR> <TR class=spacing>
          <TD class=line colSpan=2></TD></TR>
<TR>
         <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" value="<%=workday%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday")'><SPAN id=workdayimage></SPAN></TD>
        </TR> <TR class=spacing>
          <TD class=line colSpan=2></TD></TR>
<TR>
         <TD><%=SystemEnv.getHtmlLabelName(1327,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=10 size=10 name="cost" value="<%=cost%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("cost")'> <span 
            id=costspan></span> </TD>
		</TR> <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
        
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


</form>
<script language=vbs>

sub onShowrelateid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Prjrelateidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.relateid.value=id(0)
	else 
	Prjrelateidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.relateid.value=""
	end if
	end if
end sub
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>