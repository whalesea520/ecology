<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	int hassub = Util.getIntValue(request.getParameter("hassub"),1);
    int iframeset = Util.getIntValue(request.getParameter("iframeset"),0);
%>
<html> 
<head>
<title></title>
<style type="text/css">
	.frmCenterOpen{background: url('../images/fopen.png') center no-repeat;}
	.frmCenterClose{background: url('../images/fclose.png') center no-repeat;}
</style>
<script type="text/javascript">
var iframeSet = <%=iframeset%>;
function mnToggleleft(obj){
    if(iframeSet==1){
        var dLeft = $(window.parent.document).find("#dLeft");
		var dRight = $(window.parent.document).find("#dRight");
		var bodyId = $(window.parent.document).find("#bodyId");
		var dCenter = $(window.parent.document).find("#dCenter");
		if($("#showFrame").attr("show")=="true"){
				$("#showFrame").removeClass("frmCenterOpen");
				$("#showFrame").addClass("frmCenterClose");
				dLeft.width("0px");
				$("#showFrame").attr("show","false");
		}else{
				$("#showFrame").removeClass("frmCenterClose");
				$("#showFrame").addClass("frmCenterOpen");
				dLeft.width("180px");
				$("#showFrame").attr("show","true");
		}
		dRight.width(bodyId.width()-dCenter.width()-dLeft.width());
    }else{
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
}
</script>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="showFrame" <%if(hassub==1){ %>class="frmCenterOpen" show="true"<%}else{ %> class="frmCenterClose" show="false"<%} %>" 
	onclick="mnToggleleft(this)"  style="overflow: hidden;background-repeat: no-repeat;overflow: hidden;
	background-color: #D6D6D6;border: 0px;">
</body>
</html>