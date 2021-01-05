<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.admincenter.homepage.ElementRegisterUpload"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="org.apache.commons.fileupload.*,org.apache.commons.configuration.XMLConfiguration"%>
<%@ page import="java.util.zip.*"%>
<%@ page import="java.io.*,net.sf.json.JSONObject"%>
<%@ page import="java.util.Date,java.util.Enumeration"%>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.file.AESCoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String _op = Util.null2String(request.getParameter("op")).trim();
String errorInfo = "";
int fileid = -1;
if(!"sysadmin".equals(user.getLoginid())){
	return;
}
if("2Db".equals(_op)){
	fileid = Util.getIntValue(request.getParameter("fileid"),0);
	errorInfo = ElementRegisterUpload.saveElementRegister(fileid, "tmpFileName.zip", user.getLanguage(), false);
}else{
	FileUpload fu = new FileUpload(request,false);
	fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
	String filename = fu.getFileName();
	errorInfo = ElementRegisterUpload.saveElementRegister(fileid, filename, user.getLanguage(), true);
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  	<script type="text/javascript">
<%
if("2Db".equals(_op)){
	if("".equals(errorInfo)){
%>
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33843,user.getLanguage()) %>", 
			function(){document.location.href = "/admincenter/portalEngine/ElementRegister.jsp";}, 
			function(){parent.document.location.href = "/homepage/maint/HomepageTabs.jsp?_fromURL=pElement";});
<%
	}else{
%>
		top.Dialog.alert("<%=errorInfo %>",
			function(){document.location.href = "/admincenter/portalEngine/ElementRegister.jsp";});
<%
	}
}else{
	if("".equals(errorInfo)){
%>
		document.location.href = "/admincenter/portalEngine/ElementRegisterUpload.jsp?op=2Db&fileid=<%=fileid %>"; 
<%
	}else if("Confirm EbaseId".equals(errorInfo)){
%>
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(20303,user.getLanguage()) %>", 
			function(){document.location.href = "/admincenter/portalEngine/ElementRegisterUpload.jsp?op=2Db&fileid=<%=fileid %>";}, 
			function(){parent.document.location.href = "/homepage/maint/HomepageTabs.jsp?_fromURL=ElementRegister";});
<%
	}else{
%>
		top.Dialog.alert("<%=errorInfo %>",
			function(){document.location.href = "/admincenter/portalEngine/ElementRegister.jsp";});
<%
	}
}
%>
  	</script>
</head>
<body></body>
</html>