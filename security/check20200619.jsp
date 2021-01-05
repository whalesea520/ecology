
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.security.classLoader.*,weaver.general.Util,java.util.*,java.io.*,java.util.regex.*,java.util.concurrent.*,weaver.hrm.*,org.apache.commons.lang.StringUtils,java.text.DateFormat" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null){
		response.sendRedirect("/login/Login.jsp");
		return;
	}
	if(user.getUID()!=1){
		out.println("请使用sysadmin登录系统后访问该页面。");
		return;
	}
	//检测指定的文件是否存在，存在则表示安全
	File file = new File(xssUtil.getRootPath()+File.separatorChar+"WEB-INF"+File.separatorChar+"myclasses"+File.separatorChar+"weaver"+File.separatorChar+"security"+File.separatorChar+"rules"+File.separatorChar+"ruleImp"+File.separatorChar+"SecurityRuleDataSel053.class");
	boolean result = false;
	String message = "";
	String version = xssUtil.null2String(csui.getVersion()).toLowerCase();
	String url = "https://www.weaver.com.cn/cs/securityDownload.html";
	String packageName = "点击此处";
	if(file.exists() && xssUtil.enableFirewall()){
		
		if(("E8".equals(xssUtil.getEcVersion()) || "E9".equals(xssUtil.getEcVersion()))){
			url = "https://www.weaver.com.cn/cs/package/Ecology_security_20200619_v10.26.zip";
			if(version.startsWith("v10.") && version.compareTo("v10.26")>=0){
				result = true;
				message = "系统安全！";
			}else{
				message = "系统不安全！<p>原因：系统安全补丁包版本太低，当前版本为："+version+"</p>";
			}
		}else{
			url = "https://www.weaver.com.cn/cs/package/Ecology_security_20200619_v6.35.zip";
			if(version.compareTo("v6.35")>=0){
				result = true;
				message = "系统安全！";
			}else{
				message = "系统不安全！<p>原因：系统安全补丁包版本太低，当前版本为："+version+"</p>";
			}
		}
		//ClassLoaderManager.newClassLoader(xssUtil.getRootPath());
		//new weaver.filter.msg.CheckSecurityUpdateInfo();
		//new weaver.filter.XssUtil().initRules(true);
	}else{
		if("E8".equals(xssUtil.getEcVersion()) || "E9".equals(xssUtil.getEcVersion())){
			url = "https://www.weaver.com.cn/cs/package/Ecology_security_20200619_v10.26.zip";
			packageName = "《EC8.0及以上版本安全补丁》";
		}else{
			url = "https://www.weaver.com.cn/cs/package/Ecology_security_20200619_v6.35.zip";
			packageName = "《EC7.0及以下版本安全补丁》";
		}
		if(!xssUtil.enableFirewall()){
			message = "系统不安全！<p>原因：安全补丁包未生效。</p>";
		}else if(("E8".equals(xssUtil.getEcVersion()) || "E9".equals(xssUtil.getEcVersion()))){
			message = "系统不安全！";
		}else{
			result = true;
			message = "系统安全！";
		}
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>安全补丁检查</title>

</head>
<body>
<div style="margin:0 auto;width:800px;margin-top:50px;">
<h1><b>
	<%if(result){%>
		<font style="color:green;">系统安全！</font>
	<%}else{%>
		<font style="color:red;"><%=message%><p><a href="<%=url%>" target="_blank">点击此处</a>下载最新安全补丁升级！</p></font>
	<%}%>
</b></h1>
</div>
</body>
</html>
