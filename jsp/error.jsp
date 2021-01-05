<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%
String message = Util.null2String((String)request.getSession(true).getAttribute("message"));
request.getSession(true).removeAttribute("message");

String classbean = request.getParameter("type");
String titlename= "";
 %>
<html>
<head>
	<title> E-cology升级程序</title>
<script type="text/javascript" >
var type = "<%=classbean%>";
function doback() {
	if("classbean"==type) {
		window.location.href="/jsp/check.jsp?next=1";
	} else {
		window.history.go(-1);
	}
	
	
}
</script>
</head>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="错误信息" />
</jsp:include>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1256 ,user.getLanguage())+",javascript:doback(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<body style="height:100%;width:100%;">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1256 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doback()"/>
		</td>
	</tr>
</table>
		<div  style="height:380px;">
			<div  style="height:370px;width:100%;float:right;margin-top:10px;">
				<div style="height:100%;width:100%;margin-left:-10px;">
                      
                       <div style="margin-top:140px;height:60px;text-align: center;line-height:60px;font-size: 18px;" >
                       <img src="/images/ecology8/noright_wev8.png" width="162px" height="162px"/><br>
                              错误提示：<%=message %>
                       </div>

				</div>
			
			</div>
	</div>
</body>
</html>
