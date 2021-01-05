
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
/*以下几个可能来自docdsp.jsp或dodshareoperation.jsp*/
String mailgroupname=Util.null2String(request.getParameter("mailgroupname"));
int mailgroupid = Util.getIntValue(request.getParameter("mailgroupid"),0);
//int canapprove=Util.getIntValue(request.getParameter("canapprove"),0); 
//int doccreaterid=Util.getIntValue(request.getParameter("doccreaterid"),0);
//out.print("user.getUID():"+user.getUID());
//out.print("mailgroupid:"+mailgroupid);

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdCrmaccount_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(119,user.getLanguage())+
"_"+SystemEnv.getHtmlLabelName(71,user.getLanguage())
+ SystemEnv.getHtmlLabelName(2026,user.getLanguage()) +":"+mailgroupname ;
String needfav ="1";
String needhelp ="";
mailgroupname = Util.toScreen(mailgroupname,user.getLanguage(),"0");

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",MailUserGroupEdit.jsp?mailgroupid="+mailgroupid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="MailShareOperation.jsp" method=post onsubmit='return check_form(this,"userid,subcompanyid,departmentid,roleid,sharetype,rolelevel,seclevel,sharelevel")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="mailgroupid" value="<%=mailgroupid%>">
<input type=hidden name="mailgroupname" value="<%=mailgroupname%>">
<%
boolean canEdit = true;
%>
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
				<TR>
				  <TD >
		 <%
			String isdisable = "";
			if(!canEdit) isdisable ="disabled";
		%>
		  <SELECT name=sharetype onchange="onChangeSharetype()" <%=isdisable%>>
		  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
		  <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
		  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
		  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
		  <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%>
		  <%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
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
			 <%
						String ordisplay="";
						if(!canEdit) ordisplay = " style='display:none' ";
						%>
				  <TD class=field <%=ordisplay%>>
		<BUTTON class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
		<BUTTON class=Browser style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name=showsubcompany></BUTTON> 
		<BUTTON class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
		<BUTTON class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
		 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
		 <span id=showrelatedsharename name=showrelatedsharename><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
		<span id=showrolelevel name=showrolelevel style="visibility:hidden">
		&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
		<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
		<SELECT name=rolelevel  <%=isdisable%>>
		  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
		  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
		  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
		</SELECT>
		</span>
		&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
		<span id=showseclevel name=showseclevel>
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
		<INPUT type=text name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' <%=isdisable%> class="InputStyle">
		</span>
		<SPAN id=seclevelimage></SPAN>

				  </TD>		
				</TR>
				<TR><TD class=Line colSpan=2></TD></TR> 
				  <TD >
					<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
				  </TD>
				  <TD class=field>
					<SELECT name=sharelevel <%=isdisable%>>
					  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					</SELECT>
				  </TD>		
				</TR>
				<TR><TD class=Line colSpan=2></TD></TR> 	
				</TBODY>
			  </TABLE>
			  
		<!--默认共享-->
				<table class=ViewForm>
				  <colgroup> 
				  <col width="30%"> 
				  <col width="50%">
				  <col width="20%">
				  <tr class=Title>					<th><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				  </th>
				  <tr class=Spacing> 
					<td class=Line1 colspan=3></td>
				  </tr>
		<%
			//查找已经添加的默认共享
			RecordSet.executeProc("MailShare_SelectByMailgroupid",""+mailgroupid);
			while(RecordSet.next()){
				if(RecordSet.getInt("sharetype")==1){%>
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					  </TD>
					  <TD class=Field align=right>
						<%if(canEdit){%>
				<a href="MailShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&mailgroupid=<%=mailgroupid%>&mailgroupname=<%=mailgroupname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </TD>
					</TR>
					<TR><TD class=Line colSpan=3></TD></TR> 
				<%}else if(RecordSet.getInt("sharetype")==2){%>
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					  </TD>
					  <TD class=Field align=right>
						<%if(canEdit){%>
						<a href="MailShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&mailgroupid=<%=mailgroupid%>&mailgroupname=<%=mailgroupname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </TD>
					</TR>
					<TR><TD class=Line colSpan=3></TD></TR> 
				<%}else if(RecordSet.getInt("sharetype")==3)	{%>
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					  </TD>
					  <TD class=Field align=right>
						<%if(canEdit){%>
						<a href="MailShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&mailgroupid=<%=mailgroupid%>&mailgroupname=<%=mailgroupname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>  
						<%}%>
					  </TD>
					</TR>
					<TR><TD class=Line colSpan=3></TD></TR> 
				<%}else if(RecordSet.getInt("sharetype")==4)	{%>
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					  </TD>
					  <TD class=Field align=right>
						<%if(canEdit){%>
						<a href="MailShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&mailgroupid=<%=mailgroupid%>&mailgroupname=<%=mailgroupname%>" onclick="return isdel()">
						 <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </TD>
					</TR>
					<TR><TD class=Line colSpan=3></TD></TR> 
				<%}else if(RecordSet.getInt("sharetype")==5)	{%>
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					  </TD>
					  <TD class=Field align=right>
						<%if(canEdit){%>
						<a href="MailShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&mailgroupid=<%=mailgroupid%>&mailgroupname=<%=mailgroupname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </TD>
					</TR>
					<TR><TD class=Line colSpan=3></TD></TR> 
				<%}else if(RecordSet.getInt("sharetype")==6)	{
						String crmtype=RecordSet.getString("sharedcrm");
						String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
						%>
					<TR>
					  <TD><%=Util.toScreen(crmtypename,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					  </TD>
					  <TD class=Field align=right>
						<%if(canEdit){%>
						<a href="MailShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&mailgroupid=<%=mailgroupid%>&mailgroupname=<%=mailgroupname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </TD>
					</TR>
					<TR><TD class=Line colSpan=3></TD></TR> 
				<%}%>
		<%	}%>
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
else if (thisvalue==3)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
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
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value="0"
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
		document.all(inputename).value="0"
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
		document.all(inputename).value="0"
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
		document.all(inputename).value="0"
		end if
	end if
end sub

</SCRIPT>
</BODY>
</HTML>
