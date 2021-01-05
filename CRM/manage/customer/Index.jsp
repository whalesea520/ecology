
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	int maintype = Util.getIntValue(request.getParameter("maintype"),0);
%>
<script>
var maintype = <%=maintype%>;
if(maintype==0){
	maintype = getCookie("CRMINDEX");
	if(maintype==null || typeof(maintype)=="undefined"){
		maintype = 1;
	}
}
addCookie("CRMINDEX",maintype,1);

if(maintype==1){
	window.location="/CRM/manage/customer/Main.jsp?maintype=1";
}else if(maintype==2){
	window.location="/CRM/manage/customer/Main.jsp?maintype=2";
}else if(maintype==3){
	window.location="/CRM/manage/sellchance/Main.jsp";
}else if(maintype==4){
	window.location="/CRM/manage/report/Main.jsp";
}else{
	window.location="/CRM/manage/customer/Main.jsp?maintype=3";
}

function addCookie(objName,objValue,objHours){//添加cookie
	var str = objName + "=" + escape(objValue);
	if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
		var date = new Date();
		var ms = 10*365*24*60*60*1000;
		date.setTime(date.getTime() + ms);
		str += "; expires=" + date.toGMTString();
	}
	document.cookie = str;
}
function getCookie(objName){//获取指定名称的cookie的值
	var arrStr = document.cookie.split("; ");
	for(var i = 0;i < arrStr.length;i ++){
		var temp = arrStr[i].split("=");
		
		if(temp[0] == objName) return unescape(temp[1]);
 	}
}
</script>