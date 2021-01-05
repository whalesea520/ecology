<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head>
<script>
function showUploadMessage(){
	try{
		//var upload_faceicoMessage = window.parent.document.getElementById("upload_faceicoMessage").innerHTML;
		alert(window.parent.message);
		//document.getElementById("showUploadMessage").innerHTML=upload_faceicoMessage;
	}catch(e){}
}
</script>
</head>
<body onload="">
	<div id="showUploadMessage" style="width: 100%"></div>
</body>
</html>