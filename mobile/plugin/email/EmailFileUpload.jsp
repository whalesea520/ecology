
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.email.service.MailMobileService"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
FileUpload fu = new FileUpload(request); 

String uploadname = Util.null2String(fu.getParameter("uploadname"));
String uploaddata = Util.null2String(fu.getParameter("uploaddata"));
String remoteAddr=Util.null2String(fu.getRemoteAddr());
MailMobileService mobileService=new MailMobileService();
Map map = mobileService.uploadFilesToEmail(uploaddata, uploadname, user);
String docid=(String)map.get("docid");
String filename=(String)map.get("filename");
String filesize=(String)map.get("filesize");
StringBuffer linkStr=new StringBuffer();
if(!docid.equals("-1")){
	linkStr.append("<div id='"+docid+"' class=''>");
	linkStr.append("<div class='left m-t-3' style='background: url(/email/images/mailicon_wev8.png) -65px 0px  no-repeat ;width: 16px;height: 16px;'>&nbsp;</div>");
	linkStr.append("<div class='left fileName p-b-3'  >"+filename+"</div>");
	linkStr.append("<div class='left fileSize p-l-15' >"+Math.round(Util.getIntValue(filesize)/1000)+"KB</div>");
	linkStr.append("<div class='left p-l-15' ><a class='del'  href='javascript:doDelAcc("+docid+")'>"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"</a></div>");
	linkStr.append("<div class='clear'></div>");
	linkStr.append("</div>");
}	
out.println("<div id='linkStr'>"+linkStr+"</div>");
out.println("<script>parent.callback("+docid+")</script>");

%>