<%@page language="java" contentType="text/html;charset=UTF-8"%> 
<%@page import="weaver.formmode.exttools.impexp.common.StringUtils" %>
<%@page import="javax.servlet.http.*"%>
<%@page import="weaver.file.FileManage"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="ln.LN" %>
<%@page import="com.weaver.formmodel.mobile.appio.imports.services.MobileAppDataManager"%>

<%
	PrintWriter pw;
	String appNo = StringUtils.null2String(request.getParameter("appNo"));
	String uploadfilepath = GCONST.getRootPath() + "cloudstore"
			+ File.separator + "app" + File.separator + appNo
			+ File.separator + "resource" + File.separator
			+ appNo + "mobileapp.zip";
	MobileAppDataManager mobileAppDataManager = new MobileAppDataManager();
	mobileAppDataManager.importMobileApp(uploadfilepath, request, response);
	String exceptionMsg=mobileAppDataManager.getExceptionMsg();
	StringBuffer resultMsg=new StringBuffer();
	resultMsg.append("<script>try{parent.enabledBtn();}catch(e){}</script>");
	resultMsg.append("<body style=\"margin: 0px; padding: 0px;font-family: 'Microsoft YaHei', Arial;font-size: 12px;color:red;\">");
	resultMsg.append(exceptionMsg);
	resultMsg.append("</body>");
	try {
		pw=response.getWriter();
		pw.print(resultMsg.toString());
	} catch (IOException e) {
		e.printStackTrace();
	}
%>