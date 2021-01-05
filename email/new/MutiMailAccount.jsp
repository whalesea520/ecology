<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 


<div class="bold  p-t-3 hand m-l-30" id="linkGetMail"
				onclick="setMailAccountId()" 
				onmouseover="showAccountBox()"> <%=SystemEnv.getHtmlLabelName(19823,user.getLanguage())%><img src="/images/ql_wev8.gif">
<div id="accountBox" style="display:none" onmouseout="hideAccountBox()">

<%
	mas.setUserid(user.getUID()+"");
	mas.selectMailAccount();
	while(mas.next()){
		%>
		<div style="padding:1px 25px 0 1px;border:1px solid #FFF"
			onmouseover="this.style.border='1px solid #FFF';this.style.backgroundColor='#B6BDD2'"
			onmouseout="this.style.border='1px solid #FFF';this.style.backgroundColor='#FFF'">
		<a href="javascript:getMailSingleAccount(<%=mas.getId()%>)"><%=mas.getAccountname()%></a>
		</div>
		<%
		
	}
%>
</div>
</div>
