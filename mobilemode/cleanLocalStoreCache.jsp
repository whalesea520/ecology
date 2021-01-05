<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<script>
try{
	var wevCachePrefix = "MobilemodeCache";
	for (var i = localStorage.length - 1; i >= 0; i--) {
		var name = localStorage.key(i);
		if (name.indexOf(wevCachePrefix) == 0) {
			localStorage.removeItem(name);
		}
	}
	document.write("缓存清理成功")
}catch(e){
	alert(e);
}

</script>
</head>
<body>
</body>
</html>