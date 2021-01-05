<%@ page import="weaver.general.Util" %>
<%
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String message = Util.null2String(request.getParameter("message")) ;
if(message.equals("175"))		session.invalidate();
String url = "";
if(loginfile.indexOf("?")>-1){
	url = loginfile+"&message="+message;
}else{
	url = loginfile+"?message="+message;
}
%>


<script type="text/javascript" src="/js/init_wev8.js"></script>
<script>
	var language=7
	try{
		language = readCookie("languageidweaver");
	}catch(e){
		language=7
	}
//	window.top.location.href = "<%=loginfile%>&languageid="+language+"&message=<%=message%>"
window.top.location.href = "<%=url%>&languageid="+language
</script>