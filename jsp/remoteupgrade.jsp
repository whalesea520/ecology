<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
 <head>
	<title> E-cology升级程序</title>
	<script type="text/javascript" src="/js/jquery_wev8.js"></script>
	<script type="text/javascript" src="/js/updateclient/remoteupgrade.js"> </script>
	<link rel="stylesheet" href="/css/main_wev8.css" type="text/css">
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
 </head>
<%
String titlename="";
%>
<body style="height:100%;width:100%;"> 
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(127350 ,user.getLanguage()) %>" />
</jsp:include>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402 ,user.getLanguage())+",javascript:next(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body style="height:100%;width:100%;">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402 ,user.getLanguage()) %>" class="e8_btn_top" onclick="next()"/>
		</td>
	</tr>
</table>
		<div  style="height:380px;">
			<div  style="height:370px;width:100%;float:right;margin-top:10px;">
				<div style="height:100%;width:100%;background:white;margin-left:-10px;">
					<div style="width:100%;height:100%;font-size:18px;" >
			           	<div style="width:100%;height:40px;margin-top:120px;" align="center" >
			           	    <div id="message" style="width:40%;font-size:19px;text-align:center;">                                                                                                    
			      
			           	    </div>  
			           	</div> 
			           	<div style="width:100%;height:40px;margin-top:20px;" align="center" >
			           		<div style="width:22%;height:32px;" align="center"  ><img src="/img/download.png" id="download"></div> 	
			            </div> 
					</div>
				</div>
			</div>
		</div>
</body>
</html>
