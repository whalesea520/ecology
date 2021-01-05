
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/frame_wev8.css" type="text/css">

<SCRIPT language=javascript>
function mnToggleleft(){
	var f=jQuery(window.parent.document).find("#oTd1")[0].style.display;
	if (f != null) {
		if (f=='')
			{jQuery(window.parent.document).find("#oTd1")[0].style.display='none'; LeftHideShow.src = "/cowork/images/hide_wev8.gif"; LeftHideShow.title = '<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>'}
		else
			{jQuery(window.parent.document).find("#oTd1")[0].style.display=''; LeftHideShow.src = "/cowork/images/show_wev8.gif"; LeftHideShow.title = '<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>'}
	}
	window.parent.contentframe.iframes.setFirstDivHeight();
}  

</SCRIPT>
</head>

<body bgcolor="white">
<script>
document.body.oncontextmenu=""
document.body.onclick=mnToggleleft
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <td width="6" align=left valign=center >
    <IMG id=LeftHideShow name=LeftHideShow title=<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%> style="CURSOR: hand"  src="/cowork/images/show_wev8.gif" width=6>
    </td>
</table>
</body>
</html>
