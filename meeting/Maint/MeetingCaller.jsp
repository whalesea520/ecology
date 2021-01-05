
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)) {
	canedit=true;
   }
String meetingtype = Util.null2String(request.getParameter("meetingtype"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(2152,user.getLanguage()),user.getLanguage(),"0") ;
String needfav ="1";
String needhelp ="";
int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"),user.getUserSubCompany1());
String DD = ""+user.getUserDepartment();
if(DD.equals("0")){
	DD = "";
} 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/meeting/Maint/MeetingType_left.jsp?subCompanyId="+subcompanyid+",_self} " ;
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

<FORM id=weaver name=weaver action="/meeting/Maint/MeetingCallerOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="add">
<input class=inputstyle type="hidden" name="meetingtype" value="<%=meetingtype%>">
<INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
<DIV>
<%if(canedit){%>
	  <TABLE class=Form>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Section>
            <TH colSpan=2></TH>
          </TR>
        <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
        <TR>
          <TD class=field>
<select class=inputstyle name=sharetype onchange="onChangeSharetype()">
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
</SELECT>
		  </TD>
          <TD class=field>
<BUTTON type=button  class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
<BUTTON type=button  class=Browser style="" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
<BUTTON type=button  class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
 <input class=inputstyle type=hidden name=relatedshareid value="<%=DD%>">
 <span id=showrelatedsharename name=showrelatedsharename ><%if(!DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()).equals("")){%><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%><%}else{%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
<span id=showrolelevel name=showrolelevel style="visibility:hidden">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
<SELECT class=inputstyle name=rolelevel>
  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
</SELECT>
</span>
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<span id=showseclevel name=showseclevel>
<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
<INPUT class=inputstyle maxLength=3 size=5 
            name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
</span>
<SPAN id=seclevelimage></SPAN>

		  </TD>		
		</TR>

		</TBODY>
	  </TABLE>
<%}%>
	  <TABLE class=Form>
        <COLGROUP>
		<COL width="20%">
  		<COL width="60%">
  		<COL width="20%">
        <TBODY>
        <TR class=separator>
          <TD class=Sep1 colSpan=3></TD></TR>
<%
RecordSet.executeProc("MeetingCaller_SByMeeting",meetingtype);
if(RecordSet.first()){
do{
	if(RecordSet.getInt("callertype")==1)	{
%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>
		  </TD>
		  <TD class=Field>
<%if(canedit){%>
			<a href="/meeting/Maint/MeetingCallerOperation.jsp?method=delete&meetingtype=<%=meetingtype%>&id=<%=RecordSet.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
<%}%>
		  </TD>
        </TR>
	<%}else if(RecordSet.getInt("callertype")==2)	{%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD class=Field>
		<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
		  </TD>
		  <TD class=Field>
<%if(canedit){%>
			<a href="/meeting/Maint/MeetingCallerOperation.jsp?method=delete&meetingtype=<%=meetingtype%>&subcompanyid=<%=subcompanyid%>&id=<%=RecordSet.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
<%}%>
		  </TD>
        </TR>
	<%}else if(RecordSet.getInt("callertype")==3)	{%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
		  </TD>
		  <TD class=Field>
<%if(canedit){%>
			<a href="/meeting/Maint/MeetingCallerOperation.jsp?method=delete&meetingtype=<%=meetingtype%>&id=<%=RecordSet.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
<%}%>
		  </TD>
        </TR>
	<%}else if(RecordSet.getInt("callertype")==4)	{%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
		  </TD>
		  <TD class=Field>
<%if(canedit){%>
			<a href="/meeting/Maint/MeetingCallerOperation.jsp?method=delete&meetingtype=<%=meetingtype%>&id=<%=RecordSet.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
<%}%>
		  </TD>
        </TR>
	<%}%>
 <%}while(RecordSet.next());
}			
%>
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
function submitData() {
thisvalue=document.weaver.sharetype.value;
if (thisvalue==1)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==2)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==3)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==4)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else
	document.weaver.submit();
}
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value
	document.weaver.relatedshareid.value=""
	$GetEle("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

	if(thisvalue==1){
 		$GetEle("showresource").style.display='';
		$GetEle("showseclevel").style.display='none';
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		seclevelimage.innerHTML = ""
		if($GetEle("seclevel").value==""){
			$GetEle("seclevel").value=10;
		}
		//End TD33012
	}
	else{
		$GetEle("showresource").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showdepartment").style.display='';
	}
	else{
		$GetEle("showdepartment").style.display='none';
	}
	if(thisvalue==3){
 		$GetEle("showrole").style.display='';
		$GetEle("showrolelevel").style.visibility='visible';
	}
	else{
		$GetEle("showrole").style.display='none';
		$GetEle("showrolelevel").style.visibility='hidden';
    }
	if(thisvalue==4){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value="-1"

	}
	//TD33012 切换时，增加对安全级别为空的提示；人力资源没有安全级别
	if($GetEle("seclevel").value==""&&thisvalue!=1){
		seclevelimage.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	}
	//End TD33012
}
</script>

<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowResource(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}

function onShowDepartment(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $GetEle(inputename).value
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}

function onShowRole(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}
</script>
</BODY>
</HTML>
