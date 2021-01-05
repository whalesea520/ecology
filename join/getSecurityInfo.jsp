<%@ page language="java" contentType="text/html; charset=UTF-8"%><%@ page import="net.sf.json.JSONObject,weaver.hrm.*,java.util.Properties,weaver.filter.ServerDetector,weaver.filter.msg.CheckSecurityUpdateInfo,weaver.security.classLoader.ReflectMethodCall" %><jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean><jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>
	<%
		ReflectMethodCall rmc = new ReflectMethodCall();
		Properties props=System.getProperties();
		//csui.getRemoteServerVersion();
		JSONObject json = new JSONObject();
		json.put("productType","ecology");
		json.put("productVersion",xssUtil.getEcDetailVersion());
		json.put("securityVersion",csui.getVersion());
		String securityEnabled = xssUtil.enableFirewall()?"1":"0";
		json.put("securityEnabled",securityEnabled);
		json.put("pageStatus",new Boolean(xssUtil.enableFirewall() && xssUtil.getMustXss()));
		json.put("dataStatus",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()));
		json.put("enableServiceCheck",new Boolean(xssUtil.enableFirewall() && xssUtil.getEnableWebserviceCheck()));
		out.println(json.toString());
	%>