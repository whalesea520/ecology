
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>


<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String log=Util.null2String(request.getParameter("log"));

RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_VCLD_C"+CustomerID);
	return;
}
RecordSetC.first();

String ParentID = Util.null2String(request.getParameter("ParentID"));

String isSub = "0";
String CancelURL = "/CRM/data/ViewContactLog.jsp?log="+log+"&CustomerID="+CustomerID;
if(ParentID.equals(""))
{
	ParentID = "0";
}
else
{
	isSub = "1";
	CancelURL = "/CRM/data/ViewContactLogDetail.jsp?CLogID="+ParentID;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HEAD>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='"+CancelURL+"&canedit=true',_top} " ;
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
		<TABLE class="Shadow">
		<tr>
		<td valign="top">

<FORM id="weaver" name="weaver" action="/CRM/data/ContactLogOperation.jsp" method="post">
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="ParentID" value="<%=ParentID%>">
<input type="hidden" name="isSub" value="<%=isSub%>">
<input type="hidden" name="log" value="<%=log%>">

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field><select class=InputStyle  size="1" name="isfinished">
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
			<option value="0"><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></option>
			</select></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectResourceID onClick="onShowContacterID()"></BUTTON> <span 
            id=ContacterIDspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
              <INPUT class=InputStyle type=hidden name="ContacterID"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(838,user.getLanguage())%></TD>
          <TD class=Field>
<%if(!user.getLogintype().equals("2")) {%>			  
		  <BUTTON class=Browser id=SelectResourceID onClick="onShowResourceID()"></BUTTON> <span 
            id=resourceidspan><%=user.getUsername()%></span> 
              <INPUT class=InputStyle type=hidden name=ResourceID value="<%=user.getUID()%>">
<%}else{%>	
			<span 
            id=agentidspan><%=user.getUsername()%></span> 
              <INPUT class=InputStyle type=hidden name=AgentID value="<%=user.getUID()%>">
<%}%>
			  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="onShowSourceID()"></BUTTON> 
              <SPAN id=Sourcespan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
              <INPUT type=hidden name=ContactWay></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
<%if(isSub.equals("0")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(625,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="isPassive" value="1"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field><select  class=InputStyle size="1" name="ContactType">
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(6079,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(6080,user.getLanguage())%></option>
			<option value="4"><%=SystemEnv.getHtmlLabelName(6081,user.getLanguage())%></option> 
			</select></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
<%}%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="Subject" onchange='checkinput("Subject","Subjectimage")'><SPAN id=Subjectimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Calendar onclick="getContactDate()"></BUTTON> 
              <SPAN id=ContactDatespan ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
              <input type="hidden" name="ContactDate" id="ContactDate">  
              &nbsp;&nbsp;&nbsp;
              <button class=Clock onclick="onShowTime('ContactTimespan','ContactTime')"></button>
              <span id="ContactTimespan"></span><INPUT type=hidden name="ContactTime"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Calendar onclick="getEndData()"></BUTTON> 
              <SPAN id=EndDataspan ></SPAN> 
              <input type="hidden" name="EndData" id="EndData">  
              &nbsp;&nbsp;&nbsp;&nbsp;
              <button class=Clock onclick="onShowTime('EndTimespan','EndTime')"></button>
              <span id="EndTimespan"></span><INPUT type=hidden name="EndTime"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%></TD>
          <TD class=Field><TEXTAREA class=InputStyle NAME=ContactInfo ROWS=3 STYLE="width:100%"></TEXTAREA></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="showDoc()"></BUTTON>      
      <SPAN ID=Documentname></SPAN>
        <INPUT class=InputStyle type=hidden name=DocID></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>
</FORM>
		</td>
		</TR><tr><td class=Line colspan=2></td></tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</TABLE>

<SCRIPT language="JavaScript" src="/js/OrderValidator_wev8.js"></SCRIPT>

<SCRIPT language="javascript">
function checkSubmit(){
    if (check_form(weaver,'ContacterID,ContactWay,Subject,ContactDate')) {
		//added by lupeng 2004.05.21 for TD493.
		if (!checkOrderValid("ContactDate", "EndData")) {
			alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
			return;
		}

		var dateStart = document.all("ContactDate").value;
		var dateEnd = document.all("EndData").value;

		if (dateStart == dateEnd && !checkOrderValid("ContactTime", "EndTime")) {
			alert("<%=SystemEnv.getHtmlNoteName(55,user.getLanguage())%>");
			return;
		}
		//end
        document.weaver.submit();
    }
}
</SCRIPT>
</BODY>
</HTML>
