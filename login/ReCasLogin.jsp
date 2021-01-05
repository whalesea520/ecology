<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.interfaces.sso.cas.CasSetting" %>
<%
request.getSession(true).setAttribute("weaver_user@bean",null);
CasSetting cs = new CasSetting();

String loginUrl = cs.getCasserverurl()+cs.getCasserverloginpage();
String logoutUrl = cs.getCasserverurl()+cs.getCasserverlogoutpage();

String service = cs.getEcologyurl();
String logintype = Util.null2String(request.getParameter("logintype"));
service = URLEncoder.encode(service+"?logintype="+logintype, "UTF-8");

logoutUrl = logoutUrl+"?service="+service;
loginUrl = loginUrl+"?service="+service;

//System.out.println("loginUrl=="+loginUrl);//277481,lv,[90]集成中心－解决代码质量问题修复--不允许使用 System.out.println()
//System.out.println("logoutUrl=="+logoutUrl);//277481,lv,[90]集成中心－解决代码质量问题修复--不允许使用 System.out.println()
%>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery_wev8.js"></script>
<script language="javascript">
		alert("登录用户在OA中不存在，请重新登录。");
		top.window.location.href="<%=logoutUrl%>";
</script>