<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="DBstep.iMsgServer2000"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="weaver.file.ImageFileManager"%>
<jsp:useBean id="log" class="weaver.general.BaseBean" scope="page" />
<style>
body {
    font-size :12px;
}
</style>
<%
String fileid=Util.null2String(request.getParameter("fileid"),"0");
String filename=Util.null2String(request.getParameter("filename"),"0").toLowerCase();

String contenttype="";

InputStream inputStream=ImageFileManager.getInputStreamById(Util.getIntValue(fileid));

if(filename.endsWith(".doc")||filename.endsWith(".docx")||filename.endsWith(".xls")||filename.endsWith(".xlsx")){
	
	response.setContentType("text/html");
	
	SocialIMService imService=new SocialIMService();
	ByteArrayOutputStream bout=imService.doFileConvert("",fileid);  
	byte[] fileBody = bout.toByteArray();
	
	iMsgServer2000 MsgObj = new DBstep.iMsgServer2000();
	MsgObj.MsgFileBody(fileBody);			//将文件信息打包
	fileBody = MsgObj.ToDocument(MsgObj.MsgFileBody());    //通过iMsgServer200 将pgf文件流转化为普通Office文件流
	inputStream = new ByteArrayInputStream(fileBody);
	
}else if(filename.endsWith(".gif")||filename.endsWith(".png")||filename.endsWith(".jpg")||filename.endsWith(".bmp")){
	response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+fileid) ;
	return;	  
}else if(filename.endsWith(".txt")) {
	boolean  isAnsi = SocialUtil.isANSI(Util.getIntValue(fileid));
	String isGbK = SocialUtil.getTxtCharsetById(Util.getIntValue(fileid));
	if(isAnsi&&isGbK.equals("GBK")){
	    try{
	    HttpServletResponse res=response;
	    ServletOutputStream output = res.getOutputStream();
	    BufferedReader bufr = new BufferedReader(new InputStreamReader(inputStream,"GBK"));
	    BufferedWriter bufw = new BufferedWriter(new OutputStreamWriter(output,"GBK"));
	    String lineWriter = null;
	    while ((lineWriter = bufr.readLine()) != null) {
	        //log.writeLog("===lineWriter="+lineWriter);
	        bufw.write(lineWriter+"<br/>");
	        //log.writeLog("===lineWriter="+new String(lineWriter.getBytes("GBK"),"GBK"));
	        //log.writeLog("===lineWriter="+new String(lineWriter.getBytes("GBK"),"UTF-8"));
	        //log.writeLog("===lineWriter="+new String(lineWriter.getBytes("UTF-8"),"GBK"));
	        bufw.newLine();
	        bufw.flush();
	    }
	    bufr.close();
	    bufw.close();
	   } catch(Exception e) {
	    e.printStackTrace();
	    response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+fileid) ;
	   }
	   return;
	}else{
	    response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+fileid) ;
	    return;
	}
}else if(filename.endsWith(".pdf")) 
	contenttype = "application/pdf";
else if(filename.endsWith(".html")||filename.endsWith(".htm")||filename.endsWith(".sql")||filename.endsWith(".jsp")||filename.endsWith(".java")){ 
	contenttype = "text/html";
}
try { 
	
	HttpServletResponse res=response;
	ServletOutputStream output = res.getOutputStream(); 
	
	res.setContentType(contenttype);
	res.setHeader("content-disposition", "inline; filename=\"" + URLEncoder.encode(filename,"UTF-8")+"\"");
	
	int byteread;
	byte data[] = new byte[1024];
	
	while ((byteread = inputStream.read(data)) != -1) {
		output.write(data, 0, byteread);					
		output.flush();
	}
	
	if (output != null)
		output.close();
	if (output != null)
		output.flush();
	
} catch (Exception ecode) {
}
%>