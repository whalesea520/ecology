
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:useBean id="rt" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<%
	int mailid = Util.getIntValue(request.getParameter("mailid"),-1);
	rt.execute("update MailResource set receiveNeedReceipt = 2 WHERE id="+mailid);//设置回执状态为已经处理过，下次不重复提示客户处理

	
%>
<script>
	function doSubmit(state){
		parent.saveRecipt(state);
	}
	
</script>
  </head>
  
  <body>
  	<table  align="center">
  		<tr height="20px;"><td colspan="2"></td></tr>
  		<tr><td colspan="2" style="font-weight: bold;font-size:medium;text-align: center;"><%=SystemEnv.getHtmlLabelName(32473,user.getLanguage()) %></td></tr>
  		<tr height="20px;"><td colspan="2"></td></tr>
  		<tr>
  			<td style="text-align: center;">
  				<button class="btnGray" type="button" onclick="doSubmit(1)" style="width: 100px;">
  					<%=SystemEnv.getHtmlLabelName(18528, user.getLanguage())%></button>
  			</td>
  			<td style="text-align: center;">
  				<button class="btnGray" type="button" onclick="doSubmit(0)" style="width: 100px;">
  					<%=SystemEnv.getHtmlLabelName(233, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18528, user.getLanguage())%>
  				</button>
  			</td>
  		</tr>
  	</table>
     	
  </body>
</html>
