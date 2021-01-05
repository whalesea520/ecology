
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.workflow.request.WorkflowSpeechAppend"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.mobile.webservices.common.HtmlUtil"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
FileUpload fu = new FileUpload(request); 

BlogDao blogDao=new BlogDao();
String attachmentDir=blogDao.getSysSetting("attachmentDir"); //附件上传目录
String attachmentDirs[]=Util.TokenizerString2(attachmentDir,"|");

int[] docCategory={Util.getIntValue(attachmentDirs[0]),Util.getIntValue(attachmentDirs[1]),Util.getIntValue(attachmentDirs[2])};

String uploadname = Util.null2String(fu.getParameter("uploadname"));
String uploaddata = Util.null2String(fu.getParameter("uploaddata"));
String remoteAddr=Util.null2String(fu.getRemoteAddr());
int docid = WorkflowSpeechAppend.uploadAppdix(uploaddata, uploadname, user, docCategory, remoteAddr);

String linkStr="";
if(docid!=-1){
	linkStr=blogDao.getAttachmentLink(docid,user);
	linkStr=HtmlUtil.formatHtmlBlog(linkStr, true);
}	

out.println("<div id='linkStr'>"+linkStr+"</div>");
out.println("<script>parent.callback()</script>");

%>