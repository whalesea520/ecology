<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="weaver.general.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String imagefileid = Util.null2String(request.getParameter("imagefileid"));



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
	   	if($('#ferret').height()>287) $('#ferret').height(287);
	   	widthImg=parseInt($('#ferret').width());
			heightImg=parseInt($('#ferret').height());
		});
		ferret.src='/weaver/weaver.file.FileDownload?fileid=<%=imagefileid%>';
		
		$(parent.document.body).find("#imagefileid").val("<%=imagefileid%>");
		$(parent.document.getElementById('divTargetImg')).append(
				'<div style="float:\'left\';position:\'relative\';overflow:\'hidden\';width:\'100px\';height:\'100px\'">'+
				'<img src="/weaver/weaver.file.FileDownload?fileid=<%=imagefileid%>" style="position: relative;width:477px;height:287px" /><div>');

		$('#ferret').imgAreaSelect( { 
			aspectRatio : '1:1.27',
			onSelectChange : preview,
			x1 : 0,
			y1 : 0,
			x2 : 100,
			y2 : 127,
			maxWidth : 200,
			maxHeight : 254,
			onSelectEnd: function (img, selection) {
	            $(parent.document.body).find('input[name=x1]').val(selection.x1);
	            $(parent.document.body).find('input[name=y1]').val(selection.y1);
	            $(parent.document.body).find('input[name=x2]').val(selection.x2);
	            $(parent.document.body).find('input[name=y2]').val(selection.y2);            
	        }			
		});		
	});
	
	function preview(img, selection) {
		var scaleX = 100 / (selection.width || 1);
		var scaleY = 100 / (selection.height || 1);		
		$(parent.document.getElementById('divTargetImg')).find('img').css( {
			width : Math.round(scaleX * widthImg) + 'px',
			height : Math.round(scaleY * heightImg) + 'px',
			marginLeft : '-' + Math.round(scaleX * selection.x1) + 'px',
			marginTop : '-' + Math.round(scaleY * selection.y1) + 'px'
		});
	}
	
	
</script>