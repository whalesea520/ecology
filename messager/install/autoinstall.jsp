
<%@ page language="java" pageEncoding="UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String emessageurl=request.getParameter("emessageurl");
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Adobe AIR Application Installer Page</title>
<style type="text/css">
<!--
#AIRDownloadMessageTable {
	width: 217px;
	height: 180px;
	border: 1px solid #999;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
}
#AIRDownloadMessageRuntime {
	font-size: 12px;
	color: #333;
}
-->
</style>
<script language="JavaScript" type="text/javascript">
<!--
// -----------------------------------------------------------------------------
// Globals
// Major version of Flash required
var requiredMajorVersion = 9;
// Minor version of Flash required
var requiredMinorVersion = 0;
// Minor version of Flash required
var requiredRevision = 115;		// This is Flash Player 9 Update 3
// -----------------------------------------------------------------------------
// -->
</script>
</head>
<body bgcolor="#ffffff" style="margin:0px; padding:0px;">

<script src="AC_RunActiveContent_wev8.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript">
<!--
// Version check based upon the values entered above in "Globals"
var hasReqestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);

// Check to see if the version meets the requirements for playback
if (hasReqestedVersion) {
	// if we've detected an acceptable version
	// embed the Flash Content SWF when all tests are passed

	AC_FL_RunContent(
		'codebase','http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab',
		'width','217',
		'height','180',
		'id','badge',
		'wmode','transparent',
		'align','top',
		'src','badge',
		'quality','high',
		'bgcolor','#FFFFFF',
		'name','badge',
		'allowscriptaccess','always',
		'pluginspage','http://www.macromedia.com/go/getflashplayer',
		'flashvars','appname=E-Message&appurl=<%=emessageurl%>&airversion=2.5&imageurl=imgs/top_autobtn_wev8.gif',
		'movie','badge' ); //end AC code

} else {  // Flash Player is too old or we can't detect the plugin
	document.write('<table id="AIRDownloadMessageTable"><tr><td>鐜板湪涓嬭浇 <a href="<%=emessageurl%>">E-Message</a>.<br /><br /><span id="AIRDownloadMessageRuntime">璇ュ簲鐢ㄧ▼搴忛渶瑕?<a href="');
	
	var platform = 'unknown';
	if (typeof(window.navigator.platform) != undefined)
	{
		platform = window.navigator.platform.toLowerCase();
		if (platform.indexOf('win') != -1)
			platform = 'win';
		else if (platform.indexOf('mac') != -1)
			platform = 'mac';
	}
	
	if (platform == 'win')
		document.write('http://airdownload.adobe.com/air/win/download/latest/AdobeAIRInstaller.exe');
	else if (platform == 'mac')
		document.write('http://airdownload.adobe.com/air/mac/download/latest/AdobeAIR.dmg');
	else
	document.write('http://www.adobe.com/go/getair/');

		
	document.write('">Adobe&#174;&nbsp;AIR&#8482; 杩愯鐜</a>.</span></td></tr></table>');
}
// -->
</script>
<noscript>
<table id="AIRDownloadMessageTable">
<tr>
	<td>
	Download <a href="<%=emessageurl%>">E-Message</a> now.<br /><br /><span id="AIRDownloadMessageRuntime">璇ュ簲鐢ㄧ▼搴忛渶瑕?Adobe&#174;&nbsp;AIR&#8482; 鍩轰簬 <a href="http://airdownload.adobe.com/air/mac/download/latest/AdobeAIR.dmg">Mac OS</a> or <a href="http://airdownload.adobe.com/air/win/download/latest/AdobeAIRInstaller.exe">Windows</a>.</span>
	</td>
</tr>
</table>
</noscript>

</body>
</html>
