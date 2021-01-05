
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.sysadmin.*"%>
<% 
if(!HrmUserVarify.checkUserRight("SysadminRight:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
	HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
	List list = dao.getHrmResourceManagerList(user.getUID());
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17870,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",addSysadmin.jsp,_self} " ;
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
<td></td>
<td valign="top">
	<TABLE class=Shadow>
	<tr>
	<td valign="top">
	<table class=ListStyle cellspacing=1>
		<colgroup>
		<col width="40%">
		<col width="60%">
		<tbody>
		<tr class=spacing>
			<td class=Sep1 colSpan=7 ></td></tr>
		<tr class=Header>
			<th><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></th>
		</tr>
		<%
		boolean isLight = false;
		for(int i=0;i<list.size();i++){
			HrmResourceManagerVO vo = (HrmResourceManagerVO)list.get(i);
		if(isLight)
		{%>	
			<tr CLASS=DataDark>
		<%}else{%>
			<tr CLASS=DataLight>
		<%}%>
			<td><a href="sysadminEdit.jsp?id=<%=vo.getId()%>"><%=Util.forHtml(Util.null2String(vo.getLoginid()).replaceAll("'","\\'"))%></a></td>
			<td><%=Util.forHtml(Util.null2String(vo.getDescription()).replaceAll("'","\\'"))%></td>
		</tr>
		<%
		isLight = !isLight;
		}%>
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
</body>
</html>