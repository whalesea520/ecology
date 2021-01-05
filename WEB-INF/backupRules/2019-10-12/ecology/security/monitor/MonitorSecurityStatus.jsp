
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,java.io.*,weaver.security.classLoader.ReflectMethodCall,java.util.regex.*,java.util.concurrent.*,weaver.hrm.*,weaver.filter.SecurityCheckList" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>安全功能开启一览</title>

<style type="text/css">
	*{
		font-family: 微软雅黑; 
		mso-hansi-font-family: 微软雅黑
	}
	.listTable{
		width:100%;
		border:1px solid #dcdcdc;
		border-collapse:collapse;
	}
	.listTable th{
		height:40px;
		background-color:#f0f3f4;
	}
	.listTable th, .listTable td{
		border:1px solid #dcdcdc;
		font-size:12px;
		color:#384049;
	}
	.listTable td{
		height:50px;
		text-align:left;
		padding-left:10px;
		padding-right:10px;
	}
</style>
<script type="text/javascript">

	function checkSecurityList(obj){
		document.getElementById("msg").innerHTML="正在执行安全功能开启检查...";
		document.getElementById("shadow").style.display = "block";
		setTimeout(function(){
			location.href="MonitorSecurityStatus.jsp?src=refresh";
		},1000);
	}
	function fixMethod(i){
		document.getElementById("msg").innerHTML="正在启用...";
		document.getElementById("shadow").style.display = "block";
		setTimeout(function(){
			location.href="MonitorSecurityStatus.jsp?src=fix&i="+i;
		},500);
	}
</script>
</head>
<body style="margin:0;">
<div id="shadow" style="display:none;background-color:#eaeaea;filter:alpha(opacity=70); -moz-opacity:0.7; opacity:0.7;position:absolute;width:100%;height:100%;text-align:center;line-height:100%;">
	<div id="msg" style="margin-top:40px;width:180px;line-height:30px;height:30px;color:#0B84E0;font-size:14px;margin-right:auto;margin-left:auto;"></div>
</div>
<div style="width:100%;height:36px;">&nbsp;</div>
<div style="margin-left:auto;margin-right:auto;width:80%;margin-top:36px;min-height:400px;text-align:center;">
	<div style="height:52px;border-bottom:1px solid #dcdcdc;">
		<span onclick="javacript:checkSecurityList(this);" style="display:inline-block;height:32px;width:82px;cursor:pointer;background-color:#52be7f;color:white;color:white;line-height:32px;" onclick="checkSecurityList(this)">刷新</span>
	</div>

<%
	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null){
		response.sendRedirect("/login/Login.jsp");
		return;
	}

	if(!"sysadmin".equals(user.getLoginid())){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String operation = xssUtil.null2String(request.getParameter("src"));
	SecurityCheckList scl = new SecurityCheckList();
	if(operation.equals("refresh")){
		xssUtil.initRules(true);
	}else if(operation.equals("fix")){
		int i = xssUtil.getIntValue(xssUtil.null2String(request.getParameter("i")));
		ReflectMethodCall rmc = new ReflectMethodCall();
		rmc.call("weaver.security.core.SecurityCore","fixSecurityConfig",new Class[]{int.class},new Object[]{new Integer(i)});
	}
	int no = 1;
%>
<div style="margin-top:20px;max-height:600px;overflow:auto;">
	<table class="listTable">
		<colgroup>
			<col width="5%"/>
			<col width="30%"/>
			<col width="25%"/>
			<col width="30%"/>
			<col width="5%"/>
			<col width="5%"/>
		</colgroup>
		<thead>
			<th>序号</th>
			<th>检查项</th>
			<th>说明</th>
			<th>启用方式</th>
			<th>状态</th>
			<th>启用</th>
		</thead>
		<tbody>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了安全防火墙</td>
				<td>检查WEB-INF/weaver_security_config.xml中的status是否为1</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;status>为1<br/>
					<code><i><font color="red">
					&lt;status>1&lt;/status>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='isLoginCheck' id='isLoginCheck' onclick='fixMethod(0)'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了登录保护</td>
				<td>检查WEB-INF/weaver_security_config.xml中的is-login-check是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;is-login-check>为true<br/>
					<code><i><font color="red">
					&lt;is-login-check>true&lt;/is-login-check>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isLoginCheck()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isLoginCheck()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='isLoginCheck' id='isLoginCheck' onclick='fixMethod(1)'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了数据库保护</td>
				<td>检查WEB-INF/weaver_security_config.xml中的skip-rule是否为false</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;skip-rule>为false<br/>
					<code><i><font color="red">
					&lt;skip-rule>false&lt;/skip-rule>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='getIsSkipRule' id='getIsSkipRule' onclick='fixMethod(2)'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了ESAPI提供的数据库保护功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的esapi-sql是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;esapi-sql>为true<br/>
					<code><i><font color="red">
					&lt;esapi-sql>true&lt;/esapi-sql>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isUseESAPISQL()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;">
					<%=xssUtil.enableFirewall() && xssUtil.isUseESAPISQL()?"":"可能对功能有一定影响，请谨慎开启，需修改配置文件手动启用"%>
				</td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了页面保护</td>
				<td>检查WEB-INF/weaver_security_config.xml中的must-xss是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;must-xss>为true<br/>
					<code><i><font color="red">
					&lt;must-xss>true&lt;/must-xss>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getMustXss()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.getMustXss()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='getMustXss' id='getMustXss' onclick='fixMethod(3)' value='启用'>启用</span>"%></td>
			</tr>
			<!--<tr>
				<td><%=no++%></td>
				<td>是否开启了ESAPI提供的页面保护功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的esapi-xss是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;esapi-xss>为true<br/>
					<code><i><font color="red">
					&lt;esapi-xss>true&lt;/esapi-xss>
				   </font></i></code>
				</td>
				<td><%=xssUtil.enableFirewall() && xssUtil.isUseESAPIXSS()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td><%=xssUtil.isUseESAPIXSS()?"":"<input type='button' name='isUseESAPIXSS' id='isUseESAPIXSS' onclick='fixMethod(31)' value='启用'></input>"%></td>
			</tr>-->
			<tr>
				<td style="text-align:center;"><%=no++%></td>
				<td>是否配置了500错误页面</td>
				<td>检查WEB-INF/weaver_security_config.xml中的sys-debug是否为false</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;sys-debug>为false<br/>
					<code><i><font color="red">
					&lt;sys-debug>false&lt;/sys-debug>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall()&&scl.is500PageConfig()?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"%></td>
				<td style="text-align:center;"><%=scl.is500PageConfig()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='isResetCookie' id='isResetCookie' onclick='fixMethod(14)'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了cookie过期功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的is-reset-cookie是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;is-reset-cookie>为true<br/>
					<code><i><font color="red">
					&lt;is-reset-cookie>true&lt;/is-reset-cookie>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isResetCookie()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.isResetCookie()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='isResetCookie' id='isResetCookie' onclick='fixMethod(4)'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了cookie的httpOnly功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的httponly是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;httponly>为true<br/>
					<code><i><font color="red">
					&lt;httponly>true&lt;/httponly>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getHttpOnly()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.getHttpOnly()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='getHttpOnly' id='getHttpOnly' onclick='fixMethod(5)' value='启用'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了防host伪造功能（防钓鱼功能）</td>
				<td>检查WEB-INF/weaver_security_config.xml中的skip-host是否为false</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;skip-host>为false<br/>
					<code><i><font color="red">
					&lt;skip-host>false&lt;/skip-host>
				   </font></i></code><br/>
				   开启了该项功能后，需要配置服务器允许的所有访问方式，包括服务器内网地址、外网地址、域名、代理服务器地址到配置文件中，具体方法如下：<br/>
				   添加IP到指定列表的方式如下，修改WEB-INF/securityXML/weaver_security_customer_rules_1.xml文件，添加以下代码<br/>
					<code><i><font color="red">
					&lt;host-list><br/>
						&lt;host>test.genomics.cn&lt;/host><br/>
						&lt;host>test.genomics.cn:80&lt;/host><br/>
					&lt;/host-list><br/>
				   </font></i></code><br/>
				   其中<br/>
				   &lt;host>就是服务器允许的访问方式，包括内网地址、外网地址、域名、代理服务器地址，可以配置多个&lt;host节点；<br/>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && !xssUtil.getIsSkipHost()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && !xssUtil.getIsSkipHost()?"":"需修改配置文件手动启用"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了防跨站请求攻击功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的skip-ref是否为false</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;skip-ref>为false<br/>
					<code><i><font color="red">
					&lt;skip-ref>false&lt;/skip-ref><br/>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && !xssUtil.getIsRefAll()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=!xssUtil.getIsRefAll()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='getIsRefAll' id='getIsRefAll' onclick='fixMethod(7)' value='启用'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了WEBSERVICE限制IP访问功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的enable-service-check是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;enable-service-check>为true<br/>
					<code><i><font color="red">
					&lt;enable-service-check>true&lt;/enable-service-check><br/>
				   </font></i></code>
				   开启了该项功能后，需要配置允许调用webservice的所有IP地址或者网段（默认包含了内网网段可以访问调用）到配置文件中，具体方法如下：<br/>
				   添加IP到指定列表的方式如下，修改WEB-INF/securityXML/weaver_security_customer_rules_1.xml文件，添加以下代码<br/>
					<code><i><font color="red">
					&lt;webservice-ip-list><br/>
						&lt;ip>80.123.40.12&lt;/ip><br/>
						&lt;ip>192.168.&lt;/ip><br/>
					&lt;/webservice-ip-list><br/>
				   </font></i></code><br/>
				   其中<br/>
				   &lt;ip>就是允许调用webservice的IP地址，可以是一个网段，也可以是一个完整的IP地址，可以配置多个&lt;ip>节点；<br/>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getEnableWebserviceCheck()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getEnableWebserviceCheck()?"":"需修改配置文件手动启用"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了防HTTP拆分响应漏洞功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的http-sep是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;http-sep>为true<br/>
					<code><i><font color="red">
					&lt;http-sep>true&lt;/http-sep>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getHttpSep()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getHttpSep()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='getHttpSep' id='getHttpSep' onclick='fixMethod(9)' value='启用'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了系统超时功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的is-check-session-timeout是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;is-check-session-timeout>为true<br/>
					<code><i><font color="red">
					&lt;is-check-session-timeout>true&lt;/is-check-session-timeout>
				   </font></i></code>
				   <br/><br/>
				   超时时间配置方法：<br/>
				   添加或者修改WEB-INF/weaver_security_config.xml中的&lt;session-timeout>为指定时间（单位为分钟，默认为30分钟）<br/>
					<code><i><font color="red">
					&lt;session-timeout>30&lt;/session-timeout>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isCheckSessionTimeout()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isCheckSessionTimeout()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='isCheckSessionTimeout' id='isCheckSessionTimeout' onclick='fixMethod(10)' value='启用'>启用</span>"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了拦截攻击源IP的功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的enable-forbidden-ip是否为2或者3</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&lt;enable-forbidden-ip>为2或者3<br/>
					<code><i><font color="red">
					&lt;enable-forbidden-ip>2&lt;/enable-forbidden-ip>
				   </font></i></code>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isEnableForbiddenIp()>1?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.isEnableForbiddenIp()>1?"":"可能有一定的误报，请谨慎开启，需修改配置文件手动启用"%></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了log文件、数据库连接访问权限控制的功能</td>
				<td>默认开启，不可关闭。可以添加指定的资源到控制列表中。</td>
				<td>
					添加资源到指定列表的方式如下，修改WEB-INF/securityXML/weaver_security_customer_rules_1.xml文件，添加以下代码<br/>
					<code><i><font color="red">
					&lt;forbidden-url><br/>
						&lt;allow-users><br/>
							&lt;user>sysadmin&lt;/user><br/>
						&lt;/allow-users><br/>
						&lt;urls><br/>
							&lt;url>^/{1,}log/.*&lt;/url><br/>
							&lt;url>^/{1,}admin$&lt;/url><br/>
						&lt;/urls><br/>
					&lt;/forbidden-url><br/>
				   </font></i></code><br/>
				   其中<br/>
				   &lt;user>配置可以访问这些资源的用户账号，可以配置多个&lt;user节点；<br/>
				   &lt;url>节点是配置受控的URL链接地址，可以是URL的一段，也可以是一个完整的URL，也可以使用正则表达式。

				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"></td>
			</tr>
			<tr>
				<td><%=no++%></td>
				<td>是否开启了安全包更新自动提醒功能</td>
				<td>检查WEB-INF/weaver_security_config.xml中的auto-remind是否为true</td>
				<td>
					添加或者修改WEB-INF/weaver_security_config.xml中的&ltauto-remind>为true<br/>
					<code><i><font color="red">
					&lt;auto-remind>true&lt;/auto-remind><br/>
				   </font></i></code>
					<br/>
					<font color='red'><b>注：只有服务器具备访问https://update.e-cology.cn/时该功能才能生效</b></font>
				</td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getAutoRemind()?"<font style='color:#52be7f;font-weight:bold;'>开启</font>":"<font style='color:#e84c4c;font-weight:bold;'>未开启</font>"%></td>
				<td style="text-align:center;"><%=xssUtil.enableFirewall() && xssUtil.getAutoRemind()?"":"<span style='display:inline-block;margin-left:auto;margin-right:auto;text-align:center;cursor:pointer;border:1px solid #d6d6d6;color:#2c91e6;width:54px;height:26px;line-height:26px;' name='getAutoRemind' id='getAutoRemind' onclick='fixMethod(13)' value='启用'>启用</span>"%></td>
			</tr>
		</tbody>
	</table>
</div>
</div>
</body>
</html>
