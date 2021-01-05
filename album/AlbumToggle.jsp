
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN"> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript">
Event.observe(window, "load", function(){
	var o = $("imgToggle");
	Event.observe(o, "click", function(){
		var frameSet = window.parent.document.getElementById("albumFrameSet");
		if(o.src.indexOf("Show") != -1){
			o.src = "/images/HomePageHidden_wev8.gif";
			frameSet.cols = "0,6,*";
		}else{
			o.src = "/images/HomePageShow_wev8.gif";
			frameSet.cols = "200,6,*";
		}
	});
});
</script>
<style type="text/css">
body{
	margin:0;
	background-color:#B3B3B3;
}
#imgToggle{
	cursor:hand;
	position:absolute;
	top:45%;
	left:0;
}
</style>
</head>
<body>
<img id="imgToggle" src="/images/HomePageShow_wev8.gif">
</body>
</html>