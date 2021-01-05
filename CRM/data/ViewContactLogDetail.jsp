
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetH" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String log=Util.null2String(request.getParameter("log"));

char flag=2;
String CLogID = Util.null2String(request.getParameter("CLogID"));
RecordSet.executeProc("CRM_ContactLog_SelectByID",CLogID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_VCLD_CL");
	return;
}
RecordSet.first();

int isSub = RecordSet.getInt("issublog");
String HeadID = CLogID;
if(isSub==1)
{
	HeadID = RecordSet.getString("parentid");
}

int isProcessed = RecordSet.getInt("isprocessed");
int isfinished = RecordSet.getInt("isfinished");
int LogID = RecordSet.getInt("id");

String CustomerID = RecordSet.getString("customerid");
RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_VCLD_C"+CustomerID);
	return;
}
RecordSetC.first();

RecordSetH.executeProc("CRM_ContactLog_SelectByID",HeadID);
if(RecordSetH.getCounts()<=0)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_VCLD_CLH");
	return;
}
RecordSetH.first();

/*check right begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 canview=true;
//	 canviewlog=true;
//	 canmailmerge=true;
//	 if(RecordSetV.getString("sharelevel").equals("2")){
//		canedit=true;
//	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;
//		canapprove=true;
//	 }
//}
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

 if( useridcheck.equals(RecordSetC.getString("agent")) ) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

/*check right end*/

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6082,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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
<DIV class=BtnBar>
<% if(canedit) {
%>
<%if(isProcessed==0){%>
	<%if(isfinished==1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+",javascript:location.href='/CRM/data/ContactLogOperation.jsp?log="+log+"&CLogID="+CLogID+"&method=process',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<%}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location.href='/CRM/data/EditContactLog.jsp?log="+log+"&CLogID="+CLogID+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}
}
if(canedit) {
%>
<%if(isSub==0){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15161,user.getLanguage())+",javascript:location.href='/CRM/data/AddContactLog.jsp?log="+log+"&ParentID="+CLogID+"&CustomerID="+CustomerID+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}
}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewContactLog.jsp?log="+log+"&CustomerID="+CustomerID+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
</DIV>
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
          <TD class=Field>
			<%if( RecordSet.getInt("isfinished")==1){%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%><%} else {%>
			<%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%><%}%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
 <a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSet.getString("contacterid")%>"><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSet.getString("contacterid")),user.getLanguage())%></a></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(838,user.getLanguage())%></TD>
          <TD class=Field>
			<%if(!user.getLogintype().equals("2")) {%>
				<%if(!RecordSet.getString("resourceid").equals("") && !RecordSet.getString("resourceid").equals("0")) {%>
					  <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("resourceid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("resourceid")),user.getLanguage())%></a>
				<%}else if(!RecordSet.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}else{%>
				<%if(!RecordSet.getString("resourceid").equals("") && !RecordSet.getString("resourceid").equals("0")) {%>
					 <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("resourceid")),user.getLanguage())%>
				<%}else if(!RecordSet.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}%>
		  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("contactway")),user.getLanguage())%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(625,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="Main" value="1" <%if(RecordSet.getString("ispassive").equals("1")){%> checked <%}%>disabled></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
<%
switch(RecordSet.getInt("contacttype"))
{
	case 1: %><td  class=Field><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></td><% break;
	case 2: %><td  class=Field><%=SystemEnv.getHtmlLabelName(6079,user.getLanguage())%></td><% break;
	case 3: %><td  class=Field><%=SystemEnv.getHtmlLabelName(6080,user.getLanguage())%></td><% break;
	case 4: %><td  class=Field><%=SystemEnv.getHtmlLabelName(6081,user.getLanguage())%></td><% break;
	default: %><td  class=Field>&nbsp;</td><% break;
}
%>
        </TR><tr><td class=Line colspan=2></td></tr>
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("subject"),user.getLanguage())%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("contactdate")%>  <%=RecordSet.getString("contacttime")%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("enddate")%>  <%=RecordSet.getString("endtime")%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("contactinfo"),user.getLanguage())%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
<%	if(isProcessed!=0){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("processdate")%>  <%=RecordSet.getString("processtime")%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
<%}%>
        </TBODY>
	  </TABLE>

<hr>
  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="5%">
  		<COL width="5%">
  		<COL width="40%">
		<COL width="10%">
  		<COL width="10%">
  		<COL width="30%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(635,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(838,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	    </TR><tr class=Line ><td colspan=6></td></tr>

		<TR CLASS=DataDark>
<%
	if(RecordSetH.getInt("ispassive")==0)
	{
%>
	      <td><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></td>
<%
	}
	else
	{
%>
	      <td><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></td>
<%	}%>
<%
	switch(RecordSetH.getInt("contacttype"))
	{
	case 1: %><td><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></td><% break;
	case 2: %><td><%=SystemEnv.getHtmlLabelName(6079,user.getLanguage())%></td><% break;
	case 3: %><td><%=SystemEnv.getHtmlLabelName(6080,user.getLanguage())%></td><% break;
	case 4: %><td><%=SystemEnv.getHtmlLabelName(6081,user.getLanguage())%></td><% break;
	default: %><td>&nbsp;</td><% break;
	}
%>
<%


if(isSub==0){%>
	      <td><%=RecordSetH.getString("subject")%></td>
	      <td><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSetH.getString("contacterid")),user.getLanguage())%></td>
	      <td>
			<%if(!user.getLogintype().equals("2")) {%>
				<%if(!RecordSetH.getString("resourceid").equals("") && !RecordSetH.getString("resourceid").equals("0")) {%>
					  <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetH.getString("resourceid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetH.getString("resourceid")),user.getLanguage())%></a>
				<%}else if(!RecordSetH.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetH.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetH.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}else{%>
				<%if(!RecordSetH.getString("resourceid").equals("") && !RecordSetH.getString("resourceid").equals("0")) {%>
					 <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetH.getString("resourceid")),user.getLanguage())%>
				<%}else if(!RecordSetH.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetH.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetH.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}%>

		  </td>
<%}else{%>
	      <td><a href="/CRM/data/ViewContactLogDetail.jsp?log=<%=log%>&CLogID=<%=RecordSetH.getString("id")%>"><%=Util.toScreen(RecordSetH.getString("subject"),user.getLanguage())%></a></td>
	      <td>
	      <a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSetH.getString("contacterid")%>"><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSetH.getString("contacterid")),user.getLanguage())%></a>
	      </td>
	      <td>
			<%if(!user.getLogintype().equals("2")) {%>
				<%if(!RecordSetH.getString("resourceid").equals("") && !RecordSetH.getString("resourceid").equals("0")) {%>
					  <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetH.getString("resourceid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetH.getString("resourceid")),user.getLanguage())%></a>
				<%}else if(!RecordSetH.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetH.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetH.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}else{%>
				<%if(!RecordSetH.getString("resourceid").equals("") && !RecordSetH.getString("resourceid").equals("0")) {%>
					 <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetH.getString("resourceid")),user.getLanguage())%>
				<%}else if(!RecordSetH.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetH.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetH.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}%>

		  </td>
<%}%>
	      <td><%=RecordSetH.getString("contactdate")%>,<%=RecordSetH.getString("contacttime")%></td>
	   </tr>
<%
	RecordSetS.executeProc("CRM_ContactLog_Select",CustomerID+flag+"1"+flag+RecordSetH.getString("id"));
	while(RecordSetS.next())
	{

%>
		<TR CLASS=DataLight>
	      <td>&nbsp;</td>
		  <td>&nbsp;</td>
<%if((isSub==1)&&(RecordSetS.getString("id").equals(CLogID))){%>
	      <td><img border=0 src="/images/ArrowRightBlue_wev8.gif"></img><%=RecordSetS.getString("subject")%></td>
		  <td><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSetS.getString("contacterid")),user.getLanguage())%></td>
	      <td>
			<%if(!user.getLogintype().equals("2")) {%>
				<%if(!RecordSetS.getString("resourceid").equals("") && !RecordSetS.getString("resourceid").equals("0")) {%>
					  <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetS.getString("resourceid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetS.getString("resourceid")),user.getLanguage())%></a>
				<%}else if(!RecordSetS.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetS.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetS.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}else{%>
				<%if(!RecordSetS.getString("resourceid").equals("") && !RecordSetS.getString("resourceid").equals("0")) {%>
					 <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetS.getString("resourceid")),user.getLanguage())%>
				<%}else if(!RecordSetS.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetS.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetS.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}%>

		  </td>
<%}else{
%>
	      <td><img border=0 src="/images/ArrowRightBlue_wev8.gif"></img><a href="/CRM/data/ViewContactLogDetail.jsp?log=<%=log%>&CLogID=<%=RecordSetS.getString("id")%>"><%=Util.toScreen(RecordSetS.getString("subject"),user.getLanguage())%></a></td>
		  <td>
		  <a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSetS.getString("contacterid")%>"><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSetS.getString("contacterid")),user.getLanguage())%></a>
		  </td>
	      <td>
			<%if(!user.getLogintype().equals("2")) {%>
				<%if(!RecordSetS.getString("resourceid").equals("") && !RecordSetS.getString("resourceid").equals("0")) {%>
					  <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetS.getString("resourceid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetS.getString("resourceid")),user.getLanguage())%></a>
				<%}else if(!RecordSetS.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetS.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetS.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}else{%>
				<%if(!RecordSetS.getString("resourceid").equals("") && !RecordSetS.getString("resourceid").equals("0")) {%>
					 <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetS.getString("resourceid")),user.getLanguage())%>
				<%}else if(!RecordSetS.getString("agentid").equals("")){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetS.getString("agentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetS.getString("agentid")),user.getLanguage())%></a>
				<%}%>
			<%}%>

		  </td>
<%}%>
		  <td><%=RecordSetS.getString("contactdate")%>,<%=RecordSetS.getString("contacttime")%></td>
	   </tr>
	<%}
%>
	  </TBODY>
  </TABLE>

	<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
	 <input type="hidden" name="method1" value="add">
     <input type="hidden" name="types" value="CT">
	 <input type="hidden" name="sortid" value="<%=CLogID%>">
   <TABLE class=ListStyle cellspacing=1  >
      <TR class=header>
       <TH ><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></TH>

       <Td align=right >
		<BUTTON class=Btn accessKey=S onclick="doSave1()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
      </Td>
      </TR>
<TR class=Line><TD colSpan=2></TD></TR>

	   <TR >
    	  <TD class=Field colSpan="2">
		  <TEXTAREA class=InputStyle NAME=ExchangeInfo ROWS=3 STYLE="width:100%"></TEXTAREA>
		 </TD>
	   </TR>
       <TR>


        </TR>
	 </TABLE>

  <TABLE class=ViewForm>
     <TR>
        <COLGROUP>
        <COL width="10%">
        <COL width="90%">
          <TD class=title><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          <TD class=field  style="word-break: break-all;" >
          	<button class=Browser onclick="onShowMDoc('docidsspan','docids')"></button>
			<input type=hidden name="docids" value="">
             <span id="docidsspan"></span>
		  </TD>

        </TR>
	 </TABLE>
     </FORM>
  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">

        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>

	    </TR>
<TR class=Line><TD colSpan=3></TD></TR>
<%
boolean isLight = false;
char flag0=2;
int nLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",CLogID+flag0+"CT");
while(RecordSetEX.next())
{
nLogCount++;
if (nLogCount==4) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=ListStyle>
           <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
    <tbody>
<%}
		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetEX.getString("createDate")%></TD>
          <TD><%=RecordSetEX.getString("createTime")%></TD>
          <TD>
			<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
			<%}else{%>
			<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
			<%}%>
		  </TD>

        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3><%=Util.toScreen(RecordSetEX.getString("remark"),user.getLanguage())%></TD>
        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
<%
        String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();

            for(int i=0;i<docsnum;i++){
                docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a>" +" ";
            }
        }

 %>
     <td  colSpan=3><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>:  <%=docsname%>
         </TR>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
<% if (nLogCount>=4) { %> </div> <%}%>
        <table class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody>
          <tr>
            <td> </td>
            <td> </td>
            <% if (nLogCount>=4) { %>
            <td align=right><SPAN id=WorkFlowspan><a href='#' onClick="displaydiv_1()"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></span></td>
            <%}%>
          </tr>
<TR class=Line><TD colSpan=3></TD></TR>
         </tbody>
        </table>
      </td>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=vbs>

sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
         if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					m_docids = id1(0)
					docname = id1(1)
					sHtml = ""
					m_docids = Mid(m_docids,2,len(m_docids))
					document.all(inputename).value= m_docids
					docname = Mid(docname,2,len(docname))
					while InStr(m_docids,",") <> 0
						curid = Mid(m_docids,1,InStr(m_docids,",")-1)
						curname = Mid(docname,1,InStr(docname,",")-1)
						m_docids = Mid(m_docids,InStr(m_docids,",")+1,Len(m_docids))
						docname = Mid(docname,InStr(docname,",")+1,Len(docname))
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&m_docids&">"&docname&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub
</script>
<script language=javascript>
 function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}

function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}
</script>

</body>
</html>