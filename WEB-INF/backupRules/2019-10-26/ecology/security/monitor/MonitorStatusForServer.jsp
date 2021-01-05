<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONObject,weaver.security.classLoader.ReflectMethodCall,weaver.filter.SecurityCheckList" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>
<%
	ReflectMethodCall rmc = new ReflectMethodCall();
	Boolean isJoinSystemSecurity = (Boolean)rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{},null);
	if(isJoinSystemSecurity==null)isJoinSystemSecurity = new Boolean(true);
	JSONObject json = new JSONObject();
	if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){
		String sysid = (String)rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"uuid",
								new Class[]{},null);
		json.put("sysid",sysid);
		json.put("companyName",xssUtil.getCompanyname());
		json.put("ecVersion",xssUtil.getEcDetailVersion());
		json.put("firewallStatus",new Boolean(xssUtil.enableFirewall()));
		json.put("autoUpdateStatus",new Boolean(xssUtil.isAutoUpdateRules()));
		json.put("softwareVersion",csui.getVersion());
		json.put("ruleVersion",csui.getRuleVersion());
		json.put("loginStatus",new Boolean(xssUtil.enableFirewall() && xssUtil.isLoginCheck()));
		json.put("pageStatus",new Boolean(xssUtil.enableFirewall() && xssUtil.getMustXss()));
		json.put("dataStatus",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()));
		json.put("enableServiceCheck",new Boolean(xssUtil.enableFirewall() && xssUtil.getEnableWebserviceCheck()));
		json.put("isUseESAPISQL",new Boolean(xssUtil.enableFirewall() && xssUtil.isUseESAPISQL()));
		json.put("isUseESAPIXSS",new Boolean(xssUtil.enableFirewall() && xssUtil.isUseESAPIXSS()));
		json.put("isResetCookie",new Boolean(xssUtil.enableFirewall() && xssUtil.isResetCookie()));
		json.put("httpOnly",new Boolean(xssUtil.enableFirewall() && xssUtil.getHttpOnly()));
		json.put("hostStatus",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsSkipHost()));
		json.put("isRefAll",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsRefAll()));
		json.put("httpSep",new Boolean(xssUtil.enableFirewall() && xssUtil.getHttpSep()));
		json.put("isCheckSessionTimeout",new Boolean(xssUtil.enableFirewall() && xssUtil.isCheckSessionTimeout()));
		json.put("isEnableForbiddenIp",new Boolean(xssUtil.enableFirewall() && xssUtil.isEnableForbiddenIp()>1));
		json.put("autoRemind",new Boolean(xssUtil.enableFirewall() && xssUtil.getAutoRemind()));
		SecurityCheckList scl = new SecurityCheckList();
		json.put("isConfigFirewall",new Boolean(scl.isConfigFirewall()));
		json.put("isEnableAccessLog",new Boolean(scl.isEnableAccessLog()));
		json.put("checkSocketTimeout",new Boolean(scl.checkSocketTimeout()));
		json.put("isResinAdmin",new Boolean(!scl.isResinAdmin()));
		json.put("is404PageConfig",new Boolean(scl.is404PageConfig()));
		json.put("is500PageConfig",new Boolean(scl.is500PageConfig()));
		json.put("isDisabledHttpMethod",new Boolean(scl.isDisabledHttpMethod()));
		json.put("joinSystemSecurity",isJoinSystemSecurity);
		Boolean testServer = (Boolean)rmc.call("weaver.security.core.SecurityCheckList","testNetwork",
		            		new Class[]{},null);
		if(testServer==null)testServer=new Boolean(false);
		json.put("isWlanNetwork",testServer);
		
	}else{
		json.put("result", false);
	}
	//System.out.println(json);
	String info = (String)rmc.call("weaver.security.file.AESCoder",null,"encrypt",
								new Class[]{String.class,String.class},
								new String[]{json.toString(),null});
	out.println(info);
%>