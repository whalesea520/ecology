
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<%
String categoryname = Util.null2String(request.getParameter("categoryname"));
String secid = Util.null2String(request.getParameter("secid"));

RecordSet.executeProc("Doc_SecCategory_SelectByID",secid);
if(RecordSet.getCounts()<=0){
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}

/*权限判断*/
MultiAclManager am = new MultiAclManager();
int parentId = Util.getIntValue(SecCategoryComInfo.getParentId(""+secid));
boolean hasSecManageRight = false;
if(parentId>0){
	hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
}
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !hasSecManageRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
    String imagefilename = "/images/hdCRMAccount_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(67,user.getLanguage())+" : "+Util.toScreen(categoryname,user.getLanguage(),"0");
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='DocSecCategoryEdit.jsp?id="+secid+"',_top} ";
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %><DIV class=HdrProps></DIV>

<FORM id=weaver name=weaver action="ShareOperation.jsp" method=post onsubmit='return check_form(this,"userid,subcompanyid,departmentid,roleid,sharetype,rolelevel,seclevel,sharelevel")'>
    <input type="hidden" name="method" value="add">
    <input type="hidden" name="secid" value="<%=secid%>">
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



	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD class=field>
<SELECT class=InputStyle  name=sharetype onchange="onChangeSharetype()">
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
  <!-- option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option -->
  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
  <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
<%while(CustomerTypeComInfo.next()){
	String curid=CustomerTypeComInfo.getCustomerTypeid();
	String curname=CustomerTypeComInfo.getCustomerTypename();
	String optionvalue="-"+curid;
%>
	<option value="<%=optionvalue%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
<%
}%>
</SELECT>
		  </TD>
          <TD class=field>
<BUTTON type='button' class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON>

<BUTTON type='button' class=Browser style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name=showsubcompany></BUTTON>

<BUTTON type='button' class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON>

<BUTTON type='button' class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>

 <INPUT type=hidden name=relatedshareid value="">
 <span id=showrelatedsharename name=showrelatedsharename></span>
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
<INPUT type=text name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")'>
</span>
<SPAN id=seclevelimage></SPAN>

		  </TD>
		</TR>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT class=InputStyle  name=sharelevel>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
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
<script language=javascript>
function doSave() {
thisvalue=document.weaver.sharetype.value;
if (thisvalue==1)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==2)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
/* else if (thisvalue==3)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();} */
else if (thisvalue==4)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else
	document.weaver.submit();
}
</script>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
	document.weaver.relatedshareid.value="";
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

	if(thisvalue==1){
 		document.all("showresource").style.display='';
		document.all("showseclevel").style.display='none';
	}
	else{
		document.all("showresource").style.display='none';
	}
	if(thisvalue==2){
 		document.all("showsubcompany").style.display='';
 		document.weaver.seclevel.value=10;

	}
	else{
		document.all("showsubcompany").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
 		document.all("showdepartment").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showdepartment").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
 		document.all("showrole").style.display='';
		document.all("showrolelevel").style.visibility='visible';
		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showrole").style.display='none';
		document.all("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
	}
	if(thisvalue<0){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}
</script>

<SCRIPT language=VBS>
sub onShowDepartment(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> "0" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowSubcompany(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> "" then
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
	        if id(0)<> "" then
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
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

</SCRIPT>

</BODY>
</HTML>
