
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<HTML><HEAD>
<%
	int _fromURL = Util.getIntValue(request.getParameter("_fromURL"));
	String url = "";
	String navName = "";
	
	
	if(_fromURL==1){//新增敏感字
		url = "/security/sensitive/AddSensitiveWord.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==2){//编辑敏感字
		url = "/security/sensitive/EditSensitiveWord.jsp?id="+Util.getIntValue(request.getParameter("id"));
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==4){//敏感词相关设置
		url = "/security/sensitive/SensitiveSetting.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==3){//敏感词拦截日志
		url = "/security/sensitive/SensitiveLogs.jsp";
		navName = SystemEnv.getHtmlLabelName(131598,user.getLanguage());
	}else{//敏感词列表
		url = "/security/sensitive/SensitiveWords.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}

	response.sendRedirect(url);
%>
</body>
</html>

