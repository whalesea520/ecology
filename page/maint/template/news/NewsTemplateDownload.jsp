
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
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
User user = HrmUserVarify.getUser (request , response) ;
if(user==null)return;
String dirTemplate=pc.getConfig().getString("news.path");
String tempPath = GCONST.getRootPath()+dirTemplate;
String newsdir = Util.null2String(request.getParameter("newsdir"));
response.setContentType("application/x-msdownload");
response.setHeader("Content-disposition", "attachment;filename=index.htm");
File file = new File(tempPath+newsdir+"index.htm");
baseBean.writeLog(file.getAbsolutePath());
FileInputStream fis = null;
OutputStream os = null;  

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