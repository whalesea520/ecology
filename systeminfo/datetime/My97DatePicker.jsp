<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,weaver.general.Util" %>
<html>
<head>
<title>My97DatePicker</title>

<%
 User user = HrmUserVarify.getUser (request , response) ;
 int languageId = user.getLanguage();
%>

<script type="text/javascript" src="config_wev8.js"></script>
<script>

if(parent==window)
	location.href = '';

var $d, $dp, $pdp = parent.$dp, $dt, $tdt, $sdt, $lastInput, $IE=$pdp.ie, $FF = $pdp.ff,$OPERA=$pdp.opera, $ny, $cMark = false;

if ($pdp.eCont) {
	$dp = {};
	for (var p in $pdp) {
		$dp[p] = $pdp[p];
	}
}
else{
	$dp = $pdp;
}
$dp.realLang = getCurr(langList, $dp.lang);

<%if(languageId == 8){%>
  document.write("<script src='lang/en_wev8.js' charset='" + $dp.realLang.charset + "'><\/script>");
<%}else{%>
  document.write("<script src='lang/" + $dp.realLang.name + ".js' charset='" + $dp.realLang.charset + "'><\/script>");
<%}%>
for (var i = 0; i < skinList.length; i++) {
	var browser=navigator.appName  
	var b_version=navigator.appVersion  
	var version=b_version.split(";");  
	var trim_Version=version[1].replace(/[ ]/g,"");  
	if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE7.0")  
	{  
	document.write('<link rel="stylesheet" type="text/css" href="skin/' + skinList[i].name + '/datepicker7_wev8.css" title="' + skinList[i].name + '" charset="' + skinList[i].charset + '" disabled="true"/>'); 
	}  
	else if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0")  
	{  
	document.write('<link rel="stylesheet" type="text/css" href="skin/' + skinList[i].name + '/datepicker6_wev8.css" title="' + skinList[i].name + '" charset="' + skinList[i].charset + '" disabled="true"/>'); 
	} else {
	document.write('<link rel="stylesheet" type="text/css" href="skin/' + skinList[i].name + '/datepicker7_wev8.css" title="' + skinList[i].name + '" charset="' + skinList[i].charset + '" disabled="true"/>'); 
	}
	  
}
function getCurr(arr, name){
	var isFound = false;
	var item = arr[0];
	for (var i = 0; i < arr.length; i++) {
		if (arr[i].name == name) {
			item = arr[i];
			break;
		}
	}
	return item;
}
</script>
<script type="text/javascript" src="calendar_wev8.js"></script>
</head>
<body leftmargin="0" topmargin="0" onload="$c.autoSize()">
</body>
</html>
<script>
new My97DP(<%=languageId%>);
</script>