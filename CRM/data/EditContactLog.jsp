
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String CLogID = Util.null2String(request.getParameter("CLogID"));
String log=Util.null2String(request.getParameter("log"));

RecordSet.executeProc("CRM_ContactLog_SelectByID",CLogID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

String CustomerID = RecordSet.getString("customerid");
RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_VCLD_C"+CustomerID);
	return;
}
RecordSetC.first();

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;
boolean canedit=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 if(RecordSetV.getString("sharelevel").equals("2") || RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;	
//	 }
//}
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;	

if(useridcheck.equals(RecordSetC.getString("agent"))){ 
	 canedit=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

/*权限判断－－End*/

if(!canedit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdreport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewContactLogDetail.jsp?log="+log+"&CLogID="+CLogID+"',_top} " ;
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

<FORM id=weaver action="/CRM/data/ContactLogOperation.jsp" method=post>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="CLogID" value="<%=CLogID%>">
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
			<option value="1" <%if( RecordSet.getInt("isfinished")==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
			<option value="0" <%if( RecordSet.getInt("isfinished")==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></option>
			</select></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectResourceID onClick="onShowContacterID()"></BUTTON> <span 
            id=ContacterIDspan><a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSet.getString("contacterid")%>"><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSet.getString("contacterid")),user.getLanguage())%></a></span> 
              <INPUT class=InputStyle type=hidden name="ContacterID" value="<%=Util.toScreen(RecordSet.getString("contacterid"),user.getLanguage())%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(838,user.getLanguage())%></TD>
          <TD class=Field>
<%if(!user.getLogintype().equals("2")) {%>		
	<%if(!RecordSet.getString("resourceid").equals("") && !RecordSet.getString("resourceid").equals("0")) {%>	
		  <BUTTON class=Browser id=SelectResourceID onClick="onShowResourceID()"></BUTTON> <span id=resourceidspan><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("resourceid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("resourceid")),user.getLanguage())%></a></span> 
              <INPUT class=InputStyle type=hidden name=ResourceID value=<%=Util.toScreen(RecordSet.getString("resourceid"),user.getLanguage())%>>
	<%}else if(!RecordSet.getString("agentid").equals("")){%>
			<span id=agentidspan><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agentid")),user.getLanguage())%></a></span> 
              <INPUT class=InputStyle type=hidden name=AgentID value=<%=Util.toScreen(RecordSet.getString("agentid"),user.getLanguage())%>>	
	<%}%>
<%}else{%>
	<%if(!RecordSet.getString("resourceid").equals("") && !RecordSet.getString("resourceid").equals("0")) {%>	
		   <span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("resourceid")),user.getLanguage())%></span> 
              <INPUT class=InputStyle type=hidden name=ResourceID value=<%=Util.toScreen(RecordSet.getString("resourceid"),user.getLanguage())%>>
	<%}else if(!RecordSet.getString("agentid").equals("")){%>
			<span id=agentidspan><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agentid")),user.getLanguage())%></a></span> 
              <INPUT class=InputStyle type=hidden name=AgentID value=<%=Util.toScreen(RecordSet.getString("agentid"),user.getLanguage())%>>	
	<%}%>
<%}%>
		  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="onShowSourceID()"></BUTTON> 
              <SPAN id=Sourcespan><%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("contactway")),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name=ContactWay value=<%=Util.toScreen(RecordSet.getString("contactway"),user.getLanguage())%>>
			  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
<%if(RecordSet.getInt("issublog")!=1){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(625,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="Main" value="1" <%if(RecordSet.getString("ispassive").equals("1")){%> checked<%}%>></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field><select class=InputStyle  size="1" name="ContactType">

			<option value="1" <%if (Util.getIntValue(RecordSet.getString("contacttype"),0) == 1 )				  { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
			<option value="2" <%if (Util.getIntValue(RecordSet.getString("contacttype"),0) == 2 )				  { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(6079,user.getLanguage())%></option>
			<option value="3" <%if (Util.getIntValue(RecordSet.getString("contacttype"),0) == 3 )				  { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(6080,user.getLanguage())%></option>
			<option value="4" <%if (Util.getIntValue(RecordSet.getString("contacttype"),0) == 4 )				  { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(6081,user.getLanguage())%></option>
			</select></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
<%}%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="Subject" onchange='checkinput("Subject","Subjectimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("subject"),user.getLanguage())%>"><SPAN id=Subjectimage></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Calendar onclick="getContactDate()"></BUTTON> 
              <SPAN id=ContactDatespan ><%=RecordSet.getString("contactdate")%></SPAN> 
              <input type="hidden" name="ContactDate" id="ContactDate" value="<%=RecordSet.getString("contactdate")%>">  
              &nbsp;&nbsp;&nbsp;
              <button class=Clock onclick="onShowTime('ContactTimespan','ContactTime')"></button>
              <span id="ContactTimespan"><%=Util.toScreen(RecordSet.getString("contacttime"),user.getLanguage())%></span>
              <INPUT type=hidden name="ContactTime" value=<%=RecordSet.getString("contacttime")%>></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Calendar onclick="getEndData()"></BUTTON> 
              <SPAN id=EndDataspan ><%=RecordSet.getString("enddate")%></SPAN> 
              <input type="hidden" name="EndData" id="EndData" value="<%=RecordSet.getString("enddate")%>">  
              &nbsp;&nbsp;&nbsp;&nbsp;
              <button class=Clock onclick="onShowTime('EndTimespan','EndTime')"></button>
              <span id="EndTimespan"><%=Util.toScreen(RecordSet.getString("endtime"),user.getLanguage())%></span>
              <INPUT type=hidden name="EndTime" value=<%=RecordSet.getString("endtime")%>></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%></TD>
          <TD class=Field><TEXTAREA class=InputStyle NAME=ContactInfo ROWS=3 STYLE="width:100%"><%=Util.toScreenToEdit(RecordSet.getString("contactinfo"),user.getLanguage())%></TEXTAREA></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="showDoc()"></BUTTON>      
      <SPAN ID=Documentname><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%></SPAN>
        <INPUT class=InputStyle type=hidden name=DocID value=<%=Util.toScreenToEdit(RecordSet.getString("documentid"),user.getLanguage())%>>
		  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
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
</TABLE>

<SCRIPT language="JavaScript" src="/js/OrderValidator_wev8.js"></SCRIPT>

<SCRIPT language=javascript >
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
        weaver.submit();
    }
}
</SCRIPT>
</BODY>
</HTML>
