
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.sysadmin.*"%>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id"));
	String result = Util.null2String(request.getParameter("result"));
	HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
	HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(id);
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</head>
<% 
if(!HrmUserVarify.checkUserRight("SysadminRight:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17870,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String passwordComplexity = settings.getPasswordComplexity();
int minpasslen=settings.getMinPasslen();
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM name="frmmain" action="/systeminfo/sysadmin/sysadminOperation.jsp" method="post">
<INPUT type="hidden" name="method" value="changepwd">
<INPUT type="hidden" name="id" value="<%=vo.getId()%>">
<INPUT type="hidden" name="password" value="<%=vo.getPassword()%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
	<TABLE class=Shadow>
	<tr>
	<td valign="top">
	<table class="viewform">
		<colgroup>
		<col width="20%">
		<col width="80%">
		<tbody>
		
        <TR class="Title">
			<TH><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TH>
		</TR>
		<TR class="Spacing" style="height:1px;"><TD class="Line1" colSpan=2></TD></TR>
        <%if(String.valueOf(user.getUID()).equals(id)){%>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(502,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
			<td class=Field><INPUT type="password" class=Inputstyle maxLength=100 size=20 name="oldpassword" value="" onchange='checkinput("oldpassword","oldpasswordimage")'><SPAN id="oldpasswordimage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%if(result.equals("false")){%><div style="color:#FF0000 "><%=SystemEnv.getHtmlNoteName(17,user.getLanguage())%></div><%}%></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>	
        <%}%>
        <tr>
        	<td><%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
			<td class=Field><INPUT type="password" class=Inputstyle maxLength=100 size=20 name="newpassword" value="" onchange='checkinput("newpassword","newpasswordimage")'><SPAN id="newpasswordimage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(501,user.getLanguage())%></td>
			<td class=Field><INPUT type="password" class=Inputstyle maxLength=100 size=20 name="newpasswordagain" value="" onchange='checkinput("newpasswordagain","newpasswordagainimage")'><SPAN id="newpasswordagainimage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
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
</FORM>
</body>
<SCRIPT language="JavaScript">
function doSave(obj){
	var newpassword = document.frmmain.newpassword.value;
	var newpasswordagain = document.frmmain.newpasswordagain.value;
	if (check_form(frmmain,"oldpassword,newpassword,newpasswordagain")) {
		if(newpassword.length<<%=minpasslen%>){
        	alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");   
        	return ;                
        }
		if(newpassword!=newpasswordagain){
			alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
			return;
		}
		var checkpass = CheckPasswordComplexity();
		if(checkpass)
		{
			document.frmmain.submit();	
		}
	}
}
function CheckPasswordComplexity()
{
	var ins = document.getElementById("newpassword");
	var ics = document.getElementById("newpasswordagain");
	var cs = "";
	if(ics)
	{
		cs = ics.value;
	}
	//alert(cs);
	var checkpass = true;
	<%
	if("1".equals(passwordComplexity))
	{
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!="")
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(31863, user.getLanguage())%>");
			ins.value = "";
			ics.value = "";
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!="")
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(83716, user.getLanguage())%>");
			ins.value = "";
			ics.value = "";
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}
</SCRIPT>
</html>