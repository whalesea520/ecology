
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<HTML><HEAD>
<%
	int _fromURL = Util.getIntValue(request.getParameter("_fromURL"));
	String url = "";
	String navName = "";
	
	
	if(_fromURL==1){//����������
		url = "/security/sensitive/AddSensitiveWord.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==2){//�༭������
		url = "/security/sensitive/EditSensitiveWord.jsp?id="+Util.getIntValue(request.getParameter("id"));
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==4){//���д��������
		url = "/security/sensitive/SensitiveSetting.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}else if(_fromURL==3){//���д�������־
		url = "/security/sensitive/SensitiveLogs.jsp";
		navName = SystemEnv.getHtmlLabelName(131598,user.getLanguage());
	}else{//���д��б�
		url = "/security/sensitive/SensitiveWords.jsp";
		navName = SystemEnv.getHtmlLabelName(131596,user.getLanguage());
	}

	response.sendRedirect(url);
%>
</body>
</html>
