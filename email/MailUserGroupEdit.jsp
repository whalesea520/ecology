
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdCrmaccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(633,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(71,user.getLanguage())
+SystemEnv.getHtmlLabelName(2026,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",MailUserGroup.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<DIV>
<%String mailgroupid=Util.null2String(request.getParameter("mailgroupid"));
int message=Util.getIntValue(request.getParameter("message"));
int resourceid=Util.getIntValue(request.getParameter("resourceid"));
%>

<form id=MailUserGroupEdit method=post name=MailUserGroupEdit action="MailUserGroupOperation.jsp" >
<input type=hidden name=operationType value="Update">
<input type=hidden name=mailgroupid value="<%=mailgroupid%>">
</DIV>
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
		<col width='15%'>
		<col width='35%'>
		<col width='15%'>
		<col width='35%'>

		<TR class=Title><TD COLSPAN=4><B><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%>
		<%=Util.toScreen("组",user.getLanguage(),"0")%></B></TD></TR>
		<TR class=Title><TD COLSPAN=4 class=Line1></TD></TR>

		<%
		String idname="";
		String  description="";
		RecordSet.executeProc("MailUserGroup_SelectNameById",mailgroupid);
		if(RecordSet.next()){
			idname=RecordSet.getString("mailgroupname");
			description=RecordSet.getString("operatedesc");
		}%>
		<TR><TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><TD CLASS=FIELD>
				<INPUT TYPE=TEXT class=InputStyle NAME=idname SIZE=15 MAXLENGTH=30 VALUE="<%=Util.toScreen(idname,user.getLanguage())%>" onChange="checkinput('idname','idnamespan')">
				<span id=idnamespan><%if(idname.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
			</td>
		</TR>
		<TR><TD class=Line colSpan=4></TD></TR> 
		<TR><TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><TD CLASS=FIELD colspan=3>
				<INPUT TYPE=TEXT class=InputStyle NAME=description SIZE=60 MAXLENGTH=60 VALUE="<%=Util.toScreen(description,user.getLanguage())%>"  		onChange="checkinput('description','descspan')">
				<span id=descspan><%if(description.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
			</TD>
		</TR>
		<TR><TD class=Line colSpan=4></TD></TR> 
		</TABLE>
		<BR>
		<TABLE class=ViewForm cellspacing="1">
		<colgroup>
		<col width="25%"><col width="25%"><col width="25%"><col width="25%">
		 <TBODY>
		 <tr >    <td><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%><%=Util.toScreen("组",user.getLanguage(),"0")%><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%>
		 </td>
		 <TD class=Field ><BUTTON class=Browser id=SelectResourceID   onClick="onShowResourceID()"></BUTTON> 
			  <span id=resourceidspan> <a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+resourceid),user.getLanguage())%></a></span> 
			  <INPUT class=InputStyle id=resourceid type=hidden name=resourceid>
		  </TD>
		  <td colspan=2>
			<BUTTON class=BtnNew id=AddNew accessKey=N type=button onClick="doAddUser()"><U>N</U> <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
			<input type=hidden name=mailgroupid value="<%=mailgroupid%>">
		  <td>
		</tr>
		<TR><TD class=Line colSpan=4></TD></TR> 
		<tr>
			<td colspan=3>
				<table >
				<tr >
				<td>Email<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>: <input type=text name="mailaddress" size="20" class="InputStyle"></td>
				<TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>: <input type=text name="maildesc" size="20" class="InputStyle"></TD>
				</tr>
				</table>
			</td>
			<td>
				<BUTTON class=BtnNew id=AddNew accessKey=N type=button onClick="doAddMail()"><U>N</U> <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
			</td>
		</tr>
		<TR><TD class=Line colSpan=4></TD></TR> 
		</TBODY>
		</Table>
		<BR>
		<TABLE class=ListStyle cellspacing="1">
		<colgroup>
		<col width="25%"><col width="25%"><col width="25%"><col width="25%"> 
		<TR class=Header>
		 <th><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%><%=Util.toScreen("组",user.getLanguage(),"0")
		  %></th>
		  <th colspan=3><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></th>
		  
		  </tr>
		  <TR class=Line><TD colspan="4" ></TD></TR>
		<%
		boolean isLight = false;
			if(message==2){
		%><tr><font color=red><%=SystemEnv.getHtmlLabelName(2028,user.getLanguage())%></font></tr><%}
			RecordSet.executeProc("MailUser_SelectAllById",mailgroupid);
			while(RecordSet.next()){
				if(isLight = !isLight)
				{%>	
			<TR CLASS=DataDark>
			 <%}else{%>
			<TR CLASS=DataLight>
			<%}%>
			<TD><%=Util.toScreen(idname,user.getLanguage())%></a></TD>		
			<TD colspan=2><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("resourceid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("resourceid")),user.getLanguage())%></a></TD>
			<TD class=Field align=right>
			<a href="MailUserGroupOperation.jsp?operationType=DelUser&resourceid=<%=RecordSet.getString("resourceid")%>&mailgroupid=<%=mailgroupid%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 		
			</TD>
			</TR>
		<%
			}
			RecordSet.executeProc("MailUserAddress_SelectAllById",mailgroupid);
			while(RecordSet.next()){
				if(isLight = !isLight)
				{%>	
			<TR CLASS=DataDark>
			 <%}else{%>
			<TR CLASS=DataLight>
			<%}%>
			<TD><%=Util.toScreen(idname,user.getLanguage())%></a></TD>		
			<TD colspan=2><%=Util.toScreen(RecordSet.getString("mailaddress"),user.getLanguage())%>&nbsp;&nbsp;<%=Util.toScreen(RecordSet.getString("maildesc"),user.getLanguage())%></TD>
			<TD class=Field align=right>
			<a href="MailUserGroupOperation.jsp?operationType=DelMail&mailaddress=<%=RecordSet.getString("mailaddress")%>&mailgroupid=<%=mailgroupid%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 		
			</TD>
			</TR>
		<%
			}
		%>
		 </TBODY>
		 </tbody>
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
<SCRIPT language=VBS>
sub onShowResourceID()
	
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if id1(0)<> "" then
		resourceids = id1(0)
		resourcename = id1(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		MailUserGroupEdit.resourceid.value= resourceids
		resourcename = Mid(resourcename,2,len(resourcename))
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
		resourceidspan.innerHtml = sHtml
	else
		resourceidspan.innerHtml =""
		MailUserGroupEdit.resourceid.value=""
	end if
	
end sub
</script>
<script language=javascript>
function doAddUser() {
    if(check_form(document.MailUserGroupEdit,'resourceid')){
    	MailUserGroupEdit.operationType.value='AddUser';
    	document.MailUserGroupEdit.submit();
    }
}
function doAddMail() {
    if(check_form(document.MailUserGroupEdit,'mailaddress')){
    	MailUserGroupEdit.operationType.value='AddMail';
    	document.MailUserGroupEdit.submit();
	}
}
</script>
</SCRIPT>
</BODY>
<script language="javascript">
function onSubmit()
{
	if (check_form(MailUserGroupEdit,"idname,description"))
	MailUserGroupEdit.submit();
}
function onDelete()
{
	if(isdel()) {
	document.all("operationType").value="Delete";	
	MailUserGroupEdit.submit();	
	}
}
</script>
</HTML>
