<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Date" %>
<%@page import="weaver.page.maint.layout.PageLayoutUtil"%>
<%@page import="weaver.homepage.cominfo.HomepageBaseLayoutCominfo"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
String tempPath = GCONST.getRootPath();
String type = Util.null2String(request.getParameter("type"));
String styleid = Util.null2String(request.getParameter("styleid"));
if("menuh".equals(type)){
	tempPath += pc.getConfig().getString("menuh.conf");
}else if("menuv".equals(type)){
	tempPath += pc.getConfig().getString("menuv.conf");
}else{
	tempPath += pc.getConfig().getString("style.conf");
}
response.setContentType("application/x-msdownload");
response.setHeader("Content-disposition", "attachment;filename="+styleid+".xml");
File file = new File(tempPath+styleid+".xml");
baseBean.writeLog(file.getAbsolutePath());
FileInputStream fis = null;
OutputStream os = null;  
out.clearBuffer();
byte[] bos = new byte[1024];
int length = 0;
try {
 
 fis = new FileInputStream(file);
 os = response.getOutputStream();
 while((length=fis.read(bos))!=-1){
  os.write(bos, 0, length);
//  os.flush();
 }
} catch (Exception e) {
 e.printStackTrace();
}finally{
 try {
  if(os!=null)
   os.close();
  if(fis!=null)
   fis.close();
 } catch (Exception e) {
  e.printStackTrace();
 }
}
%>