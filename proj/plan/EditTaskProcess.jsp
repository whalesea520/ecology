
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="VerifyPower" class="weaver.proj.VerifyPower" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();
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
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="/proj/plan/TaskProcessOperation.jsp" method=post >
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
  <input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
  
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
  <COL width="10">
  <COL width="49%">
  <TBODY>
  <TR class=spacing>
    <TD class=line1 colSpan=3></TD>
  </TR>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("wbscoding")%><span 
            id=wbscodingspan></span> </TD>
		</TR><TR class=spacing>
    <TD class=line colSpan=3></TD>
  </TR>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("subject")%><span 
            id=subjectspan></span> </TD>
         </TR>        
         <TR class=spacing>
    <TD class=line colSpan=3></TD>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(begindatespan,begindate)"></BUTTON> 
              <SPAN id=begindatespan >
				  <%if(!RecordSet.getString("begindate").equals("x")){%>
						<%=RecordSet.getString("begindate")%>
				  <%}%>  			  
			  </SPAN> 
              <input type="hidden" name="begindate" id="begindate" value="<%=RecordSet.getString("begindate")%>">
              
          </TD>
        </TR><TR class=spacing>
    <TD class=line colSpan=3></TD>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
              <SPAN id=enddatespan >
				  <%if(!RecordSet.getString("enddate").equals("-")){%>
						<%=RecordSet.getString("enddate")%>
				  <%}%>			  
			  </SPAN> 
              <input type="hidden" name="enddate" id="enddate" value="<%=RecordSet.getString("enddate")%>">
              
          </TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=3></TD>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" value="<%=RecordSet.getString("workday")%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday")'><SPAN id=workdayimage></SPAN></TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=3></TD>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1325,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=10 size=10 name="fixedcost" value="<%=RecordSet.getString("fixedcost")%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")'> <span 
            id=fixedcostspan></span> </TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=3></TD>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=3 size=10 name="finish" value="<%=RecordSet.getString("finish")%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("finish")'> %<span 
            id=fixedcostspan></span> </TD>
         </TR><TR class=spacing>
    <TD class=line1 colSpan=3></TD>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
		 </TR>
		 <TR>
           <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=9 STYLE="width:100%"><%=RecordSet.getString("content")%></TEXTAREA></TD>
         </TR>
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
 <script language="javascript">
function submitData()
{if (check_form(weaver,'material'))
		weaver.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
