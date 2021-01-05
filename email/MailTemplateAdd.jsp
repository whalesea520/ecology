
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
String showTop = Util.null2String(request.getParameter("showTop"));
%>

<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<%@ include file="/cowork/uploader.jsp" %>
<jsp:include page="MailUtil.jsp"></jsp:include>
<script language="javascript" type="text/javascript">
var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
$(document).ready(function(){
	highEditor("mouldtext");
});
</script>
<script type="text/javascript">
function doSubmit(){
	if(check_form(fMailTemplate,'templateName')){
	with(document.getElementById("fMailTemplate")){
	
		changeImgToEmail("mouldtext");
		var remarkValue=getRemarkHtml("mouldtext");
		$("textarea[name=mouldtext]").val(remarkValue);
		
		submit();
	}}
}

</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:CkeditorExt.switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16218,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<form method="post" action="MailTemplateOperation.jsp" id="fMailTemplate" name="fMailTemplate">
<input type="hidden" name="operation" value="add" />
<input type="hidden" name="userid" value="<%=user.getUID()%>" />
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="templateNameSpan" required="true">
				<input type="text" name="templateName" class="inputstyle" style="width:30%" 
					onChange="checkinput('templateName','templateNameSpan')" />
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="templateDescription" class="inputstyle" style="width:30%" />
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19853,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="templateSubject" class="inputstyle" style="width:30%" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></wea:item>
		<wea:item>
			<div style="width:98%">
			 	<textarea id="mouldtext" _editorid="mouldtext" _editorName="mouldtext" style="width:100%;height:300px;border:1px solid #C7C7C7;"></textarea>
			</div>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
</html>
