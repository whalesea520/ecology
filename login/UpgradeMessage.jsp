
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>

<%
String imagefilename = "/images/hdNoAccess_wev8.gif";
String titlename = "";
String needfav ="";
String needhelp ="";
String error = request.getParameter("error");
%>
<script type="text/javascript">
function changemessage(){
	var error = "<%=error%>";
	if("resin" == error) {
		document.getElementById("message").innerHTML="Resin版本必须高于Resin3.1;请联系泛微项目人员或者客服升级Resin。";
	} else if("dbcharset" == error) {
		document.getElementById("message").innerHTML="E7及以下版本数据库字符集必须是GBK，请修改数据库字符集，重新还原数据库。";
	} else if("clustermain" == error) {
		document.getElementById("message").innerHTML="请确认当前节点是否是集群主节点，集群子节点不执行脚本.<br>子节点/ecology/sqlupgrade目录下脚本需要手动剪切到/ecology/data目录下.";
	} else if("dbversion" == error) {
		document.getElementById("message").innerHTML="数据库版本过低（SQLServer2000），升级逻辑无法执行，也无法登录系统；请先升级数据库版本。";
	}

}
</script>
<BODY onload="changemessage()">

<div style="width:100%;position:absolute;top:20%;text-align:center;vertical-align:middle;">
	<img src="/images/ecology8/noright_wev8.png" width="162px" height="162px"/>
	<div style="color:rgb(255,187,14);" id="message">系统正在升级,暂时无法访问...</div>
</div>

</BODY>
</HTML>