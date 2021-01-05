<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="weaver.general.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String imagefileid = Util.null2String(request.getParameter("imagefileid"));
    String urltype = Util.null2String(request.getParameter("urltype"));
%>
<script type="text/javascript" src="/messager/jquery_wev8.js"></script>
<link rel="stylesheet" type="text/css"
	href="/messager/imgareaselect/css/imgareaselect-default_wev8.css" />
<script type="text/javascript"
	src="/messager/imgareaselect/scripts/jquery.imgareaselect.pack_wev8.js"></script>
</head>
<body>
	<div id="divContent">
		<img style="float: left; margin-right: 10px;"  id='ferret'/>
	</div>
</body>
</html>
<script LANGUAGE="JavaScript">
	var widthImg=1;
	var heightImg=1;
  
	$(document).ready( function() {
		$("#ferret").load(function(){
	   	if($('#ferret').width()>477) $('#ferret').width(477);
	   	if($('#ferret').height()>287) $('#ferret').height(300);
	   	widthImg=parseInt($('#ferret').width());
		heightImg=parseInt($('#ferret').height());
		});
		
		if("<%=urltype%>" == "1"){
			ferret.src='/weaver/weaver.file.FileDownload?fileid=<%=imagefileid%>';
			$(parent.document.body).find("#imagefileid").val("<%=imagefileid%>");
		}else{
		    ferret.src=window.parent.document.getElementById("urlbrowser").value; 
		}
	});
		
	
</script>