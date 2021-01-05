
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html> 
<head>
<title></title>
<script type="text/javascript">
function mnToggleleft(obj){
	var frameSet = window.parent.document.getElementById("mailFrameSet");
	var mailFrameLefttd = window.parent.document.getElementById("mailFrameLefttd");
	
	if($("#showFrame").attr("show")=="true"){
			$("#showFrame").removeClass("frmCenterOpen");
			$("#showFrame").addClass("frmCenterClose");
			//frameSet.cols = "0,8,*";
			$(mailFrameLefttd).css("display","none");
			$("#showFrame").attr("show","false");
	}else{
			$("#showFrame").removeClass("frmCenterClose");
			$("#showFrame").addClass("frmCenterOpen");
			//frameSet.cols = "160,8,*";
			$(mailFrameLefttd).css("display","");
			$("#showFrame").attr("show","true");
	}
}
</script>
</head>
<body id="showFrame" class="frmCenterOpen" onclick="mnToggleleft(this)" show="true" >
</body>
</html>