<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocTypeManager" class="weaver.docs.type.DocTypeManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";

String msg= Util.null2String(request.getParameter("msg"));
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
<%
if(HrmUserVarify.checkUserRight("DocTypeAdd:add", user)){
%>
<DIV class=BtnBar style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocTypeAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' language=VBS class=BtnNew id=button1 accessKey=N name=button1 onclick="location='DocTypeAdd.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
<%
}
if(HrmUserVarify.checkUserRight("DocMainCategory:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where operateitem =4")+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=BtnLog id=button2 accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=<%=xssUtil.put("where operateitem =4")%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON> </DIV>
<%}
%>

<UL>
<%
DocTypeManager.resetParameter();
DocTypeManager.selectTypeInfo();
while(DocTypeManager.next()) {
	int id=DocTypeManager.getId();
	String name = DocTypeManager.getTypename();
%>
  <LI><A href="DocTypeEdit.jsp?id=<%=id%>"><%=name%></A> 
<%
}
%>
 
 
 </LI>
 </UL>
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
 </BODY></HTML>
