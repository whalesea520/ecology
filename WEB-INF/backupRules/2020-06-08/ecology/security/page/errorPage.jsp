
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
  <head>
    <title>系统提醒</title>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
    <div style="width: 800px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
    <div style="float:left; ">
    	<div style=" height:80px; width:80px;background: url(/security/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
	<div style="height:260px; width:610px; float:left; line-height:25px;">
		

	
			<p style=" font-weight:normal;color:#fe9200;">
	                <%
					weaver.filter.XssUtil xssUtil = new weaver.filter.XssUtil();
					String msgStr = xssUtil.null2String(request.getParameter("msgStr"));
					String gopage = xssUtil.null2String(request.getParameter("gopage"));
					if(msgStr.equals("forgetPassword")){
					%>
						忘记密码功能已被禁用,请联系系统管理员!")
					<%}
					if(msgStr.equals("isLogin")){
					%>
						<script type='text/javascript'>try{top.location.href='/login/Login.jsp?gopage="+gopage+"&_token_=<%=java.util.UUID.randomUUID().toString()%>';}catch(e){window.location.href='/login/Login.jsp?gopage="+gopage+"&_token_=<%=java.util.UUID.randomUUID().toString()%>';}</script>
					<%}
					if(msgStr.equals("isWhiteIp")){
					%>
						非法IP，禁止访问系统!")
					<%}
					if(msgStr.equals("isCookieMatchIp")){
					%>
						您无权访问该资源,请联系系统管理员!
					<%}
					if(msgStr.equals("hostCheck")){
					%>
						服务器主机伪造,阻断该请求!
					<%}
					if(msgStr.equals("forbbidenUrl")){
					%>
						您无权访问该资源,请联系系统管理员!
					<%}
					if(msgStr.equals("checkUrlCheatPass")){
					%>
						疑似钓鱼欺骗,阻断该请求!
					<%}
					if(msgStr.equals("referCheck")){
					%>
						疑似跨站点请求攻击,阻断该请求!
					<%}
					if(msgStr.equals("referEmpty")){
					%>
						疑似跨站点请求攻击,阻断该请求!
					<%}
					if(msgStr.equals("webservice")){
					%>
						非法IP调用webservice,阻断该请求!
					<%}
					if(msgStr.equals("isAllowIp")){
					%>
						非法IP,禁止访问系统!
					<%}
					if(msgStr.equals("checkSpecialRule")){
					%>
						提示:系统错误.
					<%
					}
					%><br/>
					 <a href="#" onclick="javascript:window.history.go(-1);" target="_self">返回上一页面</a>
            </p>
			
		</div>
    </div>
    
</div>
</body>
</html>    
  
