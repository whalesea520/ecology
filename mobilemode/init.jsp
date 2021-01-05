<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.formmode.ThreadLocalUser"%>
<%@ page import="weaver.general.BaseBean"%>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%!
private int getCheckRightSubCompanyParam(String userRightStr,User user,String mmdetachable,int subCompanyId){
	int operatelevel=0;
	if(mmdetachable.equals("1")){
	    CheckSubCompanyRight CheckSubCompanyRight = new CheckSubCompanyRight();
	    operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),userRightStr,subCompanyId);
	}else{
	    if(HrmUserVarify.checkUserRight(userRightStr, user)){
	        operatelevel=2;
	    }
	}
	return operatelevel;
}
%>
<%
int isIncludeToptitle = 0;
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
ThreadLocalUser.setUser(user);

String enableMultiLang = Util.null2String(new BaseBean().getPropValue("weaver_multi_lang", "enableMultiLang"));

boolean isUseMmManageDetach=ManageDetachComInfo.isUseMmManageDetach();
String mmdetachable="0";
String mmdftsubcomid="0";
if(isUseMmManageDetach){
   mmdetachable="1";
   mmdftsubcomid=ManageDetachComInfo.getMmdftsubcomid();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
	<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<LINK type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />	<!-- for right menu -->
	
	<link type="text/css" rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css"/>
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	
	<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js?v=2017080701"></script>
	
	<LINK type="text/css" rel="stylesheet" href="/formmode/css/pub_wev8.css?d=20140616" />
	
	<script type="text/javascript" src="/mobilemode/js/security/security_wev8.js"></script>
	
	<script type="text/javascript" >
		$.fn.selectbox = function(){}; //jNice select
		
		var _userLanguage = "<%=user.getLanguage()%>";
		var enableMultiLang = "<%=enableMultiLang%>";
		var _defaultLang;
		if(typeof enableMultiLang != "undefined" && enableMultiLang == 1){
			_defaultLang = _userLanguage;
		}

		function jionActionUrl(invoker, queryStr){
			if(!queryStr){
				queryStr = "";
			}
			if(queryStr.indexOf("&") != 0){
				queryStr = "&" + queryStr;
			}
			return "/mobilemode/Action.jsp?invoker=" + invoker + queryStr;
		}
	</script>
	<script type="text/javascript" src="/mobilemode/js/multilang/lang.js?v=2018013002"></script>
	<link rel="stylesheet" type="text/css" href="/mobilemode/js/multilang/lang.css?v=2018013001"/>
</head>
	
</html>