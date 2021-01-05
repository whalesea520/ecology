
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/web/workflow/request/WorkflowAddRequestTitle.jsp" %>

<form name="frmmain" method="post" action="BillOnlineRegistOperation.jsp">
    <%@ include file="/web/workflow/request/WorkflowAddRequestBody.jsp" %>
	<TABLE class=form cellpadding="0" cellspacing="0" border="1">
		  <COLGROUP> 
		  <COL width="20%"> 
		  <COL width="80%"> 
		  <tr>
		  <td>输入密码</td>		  
		  <td class=field><input type=password name="password1" onChange="checkinput('password1','password1span')">
		  <span id="password1span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
		  </td>
		  <tr>
		  <tr>
		  <td>再次输入密码</td>		  
		  <td class=field><input type=password name="password2" onChange="checkinput('password2','password2span');checkSame()">
		  <span id="password2span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
		  </td>
		  <tr>
	</table>
</form>
<script language="">
function checkSame()
{
	var pass1 = document.all("password1").value ;
	var pass2 = document.all("password2").value ;
  	if (pass1!=pass2) {
		alert("两次输入的密码不一致！") ;
		document.all("password1").value = "" ;
		document.all("password1span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>" ;
		document.all("password2").value = "" ;
		document.all("password2span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>" ;

	}
}
</script>

