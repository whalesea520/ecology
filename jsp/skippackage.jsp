<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<html>
<head>
	<title> E-cology升级程序</title>
	<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript">
	function next() {
		window.location.href="/jsp/upgradefiles.jsp";
	}
	function cancel() {
		window.location.href="/jsp/selectZip.jsp";
	}
	</script>
</head>
<%
String message = Util.null2String((String)request.getSession(true).getAttribute("message"));
String titlename="";
String checklevel = Util.null2String(baseBean.getPropValue("ecologyupdate","checklevel"));
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=2">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="系统升级" />
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if("0".equals(checklevel)) { %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402 ,user.getLanguage()) %>" class="e8_btn_top" onclick="next()"/>
		<% }%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129 ,user.getLanguage()) %>" class="e8_btn_top" onclick="cancel()"/>
		</td>
	</tr>
</table>
<%
if("0".equals(checklevel)) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:next(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp"></jsp:include>
</div>
<div style="width:75%;height:100%;float:right">
<div style="height:380px;">
			<div  style="height:370px;width:100%;float:right;margin-top:10px;">
				<div style="height:100%;width:100%;margin-left:-10px;">
                      <div style="margin-top:10px;text-align: center;" >
                       <img src="/images/ecology8/noright_wev8.png" width="162px" height="162px"/>
                      </div>
                       <div style="margin-top:10px;height:60px;text-align: center;line-height:60px;font-size: 18px;" >
                            <%=message %>
                            <% if("0".equals(checklevel)) {%>
                            	
                            <%} %>
                       </div>

				</div>
			
			</div>
</div>
</div>
<div>
</div>
</body>
</html>