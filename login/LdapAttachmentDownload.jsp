<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>

<HTML>
<HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css" />

<style type="text/css">

.inner_tab {
	margin:auto;
	width:720px;
	font-size:14px;
	text-align:center;
}

.trInfo {
	height:50px;
	font-size:16px;
	vertical-align:middle;
}

a:link {
 color:#008ef8;
 text-decoration:none;
}

.btn_downloadDriver {
	background-color:#008ef5;
	cursor:pointer;
    -webkit-border-radius:30px;
    -moz-border-radius:30px;
    border-radius:30px;
}

.big {
	border:none;
    padding-top:6px;
    padding-bottom:8px;
    padding-left:15px;
    padding-right:22px;
    height:40px;
    
}

.big font {
	vertical-align:text-top;
	font-size:13px;
}

.download_Img {
	vertical-align:text-top;
}

</style>

<script>
function downloadDriverFile(url) {
	window.location.href = url;
}
</script>

</HEAD>

<BODY>

<div style="width:100%;position:absolute;top:12%;text-align:center;vertical-align:middle;">
	<img src="/images/ecology8/noright_wev8.png" width="180px" height="180px"/>
	<div>
		<table class="inner_tab">
			<tr class="trInfo">
				<td style="color:rgb(255,187,14);"><%=SystemEnv.getHtmlLabelName(128724,7) %></td>
			</tr>
			<tr class="trInfo">
				<td>
					<span>
						<a style='cursor:pointer;' href='/resource/nlsetup.exe'>nlsetup.exe</a>
					</span>
					<span class="btn_downloadDriver big" style="margin-left:45px;" onclick="downloadDriverFile('/resource/nlsetup.exe')" >
						<img src="/integration/images/drv_download_wev8.png" class="download_Img"/>
						<font style="color:#fff">&nbsp;<%=SystemEnv.getHtmlLabelName(31156,7) %></font>
					</span>
				</td>
			</tr>
		</table>
	</div>
</div>

</BODY>
</HTML>

