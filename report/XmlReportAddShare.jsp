
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>

<%
String customername = Util.null2String(request.getParameter("customername"));
String CustomerID = Util.null2String(request.getParameter("rptFlag"));
String itemtype = "2";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

/*
RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();
*/
/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment="";/*+RecordSet.getString("department") ;
boolean canedit=false;

String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

if(RecordSetV.next())
{
	 if(RecordSetV.getString("sharelevel").equals("2") || RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
		canedit=true;	
	 }
}

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}
*/
/*权限判断－－End*/
/*
if(!canedit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
*/
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'itemtype,CustomerID,relatedshareid,sharetype,rolelevel,seclevel')){
        weaver.submit();
    }
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(22377,user.getLanguage());;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if(!isfromtab){ %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/report/XmlReportSetting.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep;
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

<FORM id=weaver name=weaver action="/report/XmlReportShareOperation.jsp" method=post onsubmit='return check_form(this,"itemtype,CustomerID,relatedshareid,sharetype,rolelevel,seclevel")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="itemtype" value="<%=itemtype%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab %>">
<input type="hidden" name="sharelevel" value="1">
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD class=field>
<SELECT  class=InputStyle name=sharetype onchange="onChangeSharetype()">
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
</SELECT>
		  </TD>
          <TD class=field>
<BUTTON class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
<BUTTON class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
<BUTTON class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
 <span id=showrelatedsharename name=showrelatedsharename ><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span>
<span id=showrolelevel name=showrolelevel style="visibility:hidden">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
<SELECT class=InputStyle  name=rolelevel>
  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
</SELECT>
</span>
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<span id=showseclevel name=showseclevel>
<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
<INPUT class=InputStyle maxLength=3 size=5 
            name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
</span>
<SPAN id=seclevelimage></SPAN>

		  </TD>		
		</TR><!--tr><td class=Line colspan=2></td></tr>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT class=InputStyle  name=sharelevel>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		  </TD>		
		</TR><tr><td class=Line colspan=2></td></tr-->

		</TBODY>
	  </TABLE>

	<!--共享信息begin-->
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="60%">
  		<COL width="10%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%></TH>
			<TD align=right colspan=2></TD>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=3></TD></TR>
<%
RecordSetShare.executeProc("XmlReport_ShareInfo_SbyRid",CustomerID);
int index=0;
if(RecordSetShare.first()){
do{
	index++;
	if(RecordSetShare.getInt("sharetype")==1)	{
%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field  id="tdDel_<%=index%>">
			<a href="/report/XmlReportShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  </TD>
        </TR><tr><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field id="tdDel_<%=index%>">
			<a href="/report/XmlReportShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  </TD>
        </TR><tr><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(RolesComInfo.getRolesname(RecordSetShare.getString("roleid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			<% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			<% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field id="tdDel_<%=index%>">
			<a href="/report/XmlReportShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  </TD>
        </TR><tr><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field id="tdDel_<%=index%>">
			<a href="/report/XmlReportShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  </TD>
        </TR><tr><td class=Line colspan=3></td></tr>
	<%}%>
 <%}while(RecordSetShare.next());
}
%>
        </TBODY>
	  </TABLE>
<!--共享信息end-->

	<!--TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL>
		<COL width="20%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
		<TR>
          <TD class=field>dddd</TD>
		  <TD></TD>
		  <TD></TD>
		</TR>
	</TABLE-->

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value
	document.weaver.relatedshareid.value=""
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

	if(thisvalue==1){
 		document.all("showresource").style.display='';
		document.all("showseclevel").style.display='none';
		if(trim(document.all("seclevel").value)==''){
			document.all("seclevel").value='10';
		}
        document.all("seclevelimage").innerHTML='';
	}
	else{
		document.all("showresource").style.display='none';
		checkinput("seclevel","seclevelimage");
	}
	if(thisvalue==2){
 		document.all("showdepartment").style.display='';
	}
	else{
		document.all("showdepartment").style.display='none';
	}
	if(thisvalue==3){
 		document.all("showrole").style.display='';
		document.all("showrolelevel").style.visibility='visible';
	}
	else{
		document.all("showrole").style.display='none';
		document.all("showrolelevel").style.visibility='hidden';
    }
	if(thisvalue==4){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value="-1"
	}

}
</script>

<SCRIPT language=VBS>
sub onShowDepartment(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	    'if id(0)<> "" then
	    if id(0)<> "" and id(0)<> "0" then
		    document.all(tdname).innerHtml = id(1)
		    document.all(inputename).value=id(0)
		else
		    document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		    document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResource(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    'if id(0)<> "" then
	    if id(0)<> "" and id(0)<> "0" then
		    document.all(tdname).innerHtml = id(1)
		    document.all(inputename).value=id(0)
		else
		    document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		    document.all(inputename).value=""
		end if
	end if
end sub

sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	    'if id(0)<> "" then
	    if id(0)<> "" and id(0)<> "0" then
		    document.all(tdname).innerHtml = id(1)
		    document.all(inputename).value=id(0)
		else
		    document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		    document.all(inputename).value=""
		end if
	end if
end sub

</SCRIPT>
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
</BODY>
</HTML>