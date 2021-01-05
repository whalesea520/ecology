<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	int hassub = Util.getIntValue(request.getParameter("hassub"),1);
%>
<html> 
<head>
<title></title>
<style type="text/css">
	.frmCenterOpen{background: url('../images/fopen.png') center no-repeat;}
	.frmCenterClose{background: url('../images/fclose.png') center no-repeat;}
</style>
<script type="text/javascript">
function mnToggleleft(obj){
	var frameSet = window.parent.document.getElementById("MainFrameSet");
	if($("#showFrame").attr("show")=="true"){
			$("#showFrame").removeClass("frmCenterOpen");
			$("#showFrame").addClass("frmCenterClose");
			frameSet.cols = "0,8,*";
			$("#showFrame").attr("show","false");
	}else{
			$("#showFrame").removeClass("frmCenterClose");
			$("#showFrame").addClass("frmCenterOpen");
			frameSet.cols = "180,8,*";
			$("#showFrame").attr("show","true");
	}
}
</script>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="showFrame" <%if(hassub==1){ %>class="frmCenterOpen" show="true"<%}else{ %> class="frmCenterClose" show="false"<%} %>" 
	onclick="mnToggleleft(this)"  style="overflow: hidden;background-repeat: no-repeat;overflow: hidden;
	background-color: #D6D6D6;border: 0px;">
</body>
</html>