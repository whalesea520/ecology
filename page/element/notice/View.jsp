
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.apache.commons.lang.StringUtils" %>
<%@page import="weaver.docs.docs.DocManager"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">
<%
String noticeImg = (String)valueList.get(nameList.indexOf("noticeimg"));
String noticeTitle = (String)valueList.get(nameList.indexOf("noticetitle"));
String noticeContent = (String) valueList.get(nameList.indexOf("noticecontent"));
String direction = (String) valueList.get(nameList.indexOf("direction"));
int scrollDelay =Util.getIntValue((String) valueList.get(nameList.indexOf("scrollDelay")),0);
String onlytext = (String) valueList.get(nameList.indexOf("onlytext"));

DocManager dcm=new DocManager();
dcm.setId(Util.getIntValue(noticeContent,-1));
dcm.getDocInfoById();
noticeContent =dcm.getDoccontent();
int tmppos = noticeContent.indexOf("!@#$%^&*");
if(tmppos!=-1)	{
	noticeContent = noticeContent.substring(tmppos+8);
}
if(noticeContent.indexOf("<script>")!=-1){
	//noticeContent = noticeContent.substring(0,noticeContent.indexOf("<script>"))+noticeContent.substring(noticeContent.indexOf("</script>")+8,noticeContent.length());
}
noticeContent = noticeContent.replaceAll("<[/]?p[^>]*>","").replaceAll("<[/]?div[^>]*>","");
//ie中有p、div标签，第一轮流转不显示
%>

	<style>
	td{
		margin: 0px;
	}
	table {
		margin: 0px;
	}  
</style>
	<table width=100%>
		<TR>
			<%if(!noticeImg.equals("")&&!noticeImg.equals("none")) {%>
			<TD width='20'>
				<img src=<%=noticeImg%> />
			</TD>
			<%} %>
			<%if(!noticeTitle.trim().equals("")) {%>
			<TD width='20%'>
				<font class='font'><%=noticeTitle%></font>
			</TD>
			<%} %>
			<TD class="field" width='*' valign="bottom">
			<marquee id="notice_marq<%=eid %>" align=bottom  direction=<%= direction%>  onmouseout='this.start();'   onmouseover='this.stop();'   scrollAmount=<%=scrollDelay  >1000 || scrollDelay  ==0 ?1:1000/scrollDelay%> scrollDelay=<%=scrollDelay <=1000 ?0:scrollDelay/100 %>   scrollleft='0'   scrolltop='0'>
				<font class='font'>
				<li style="display:inline-block;" >
				<%
				if(direction.equals("right")&&false){
					out.print(StringUtils.reverse(noticeContent));
				}else{
					out.print(noticeContent);
				}
	
				%>
				</li>
				</font>
			</marquee>
			</TD>
		</TR>		
		
	</TABLE>
<% if("yes".equals(onlytext)){%>
	<div id="hidDiv<%=eid %>" style="display:none">
		<%=noticeContent%>
	</div>
	<script>
	$("#notice_marq<%=eid %>").html("<font class='font'><li style='display:inline-block;' >"+$("#hidDiv<%=eid %>").text()+"</li></font>");
	</script>
<%}%>