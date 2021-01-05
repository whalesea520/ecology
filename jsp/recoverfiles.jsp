<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%> 
<%@ page import="weaver.general.*,com.weaver.entity.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
List list = (List)request.getSession(true).getAttribute("list");
String titlename ="";
 %>
<html>
<head>
<title> E-cology升级程序</title>
<script type="text/javascript" src="/js/jquery_wev8.js"></script>
<script type="text/javascript" src="/js/updateclient/recover.js"></script>
<link rel="stylesheet" href="/css/main_wev8.css" type="text/css">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
</head>
<body style="height:100%;width:100%;"> 
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="还原" />
</jsp:include>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(589 ,user.getLanguage())+",javascript:backup(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body style="height:100%;width:100%;">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(589 ,user.getLanguage()) %>" class="e8_btn_top" onclick="backup()"/>
		</td>
	</tr>
</table>
<form>
<wea:layout  type="4col">
<wea:group context="选择已备份文件">
			         	<%
			         	if(null!=list)
			         	{
				         	for(int i = 0;i<list.size();i++)
				         	{
				         		ZipInfo zipinfo = (ZipInfo)list.get(i);
			         	 %>
			         	 	<wea:item><span style="text-align:center;width:100%;display:inline-block;"><%=i+1 %></span></wea:item>
			          		<wea:item attributes="{'colspan':'3'}"><input type="radio" id="file<%=zipinfo.getId() %>" class="selected" name="zipname" value="<%=zipinfo.getName() %>"/><img src="/img/zip.png"><%=zipinfo.getName() %></wea:item>
			          		
			         	<%
			         		}
			         	}
			         	%>
</wea:group>
</wea:layout>



</form>
</body>
</html>
