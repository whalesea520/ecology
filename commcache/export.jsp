<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="java.net.URLEncoder"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,weaver.monitor.cache.monitor.*,weaver.monitor.cache.Util.*,weaver.monitor.cache.*" %>
<%
	
    String type = request.getParameter("type");
	String path = request.getSession().getServletContext().getRealPath("/");
    String fileName = ListToTxt.downloadExcel(type,path);
		response.reset();
		File file = new File(path +"\\"+fileName);
		//处理中文编码问题，IE9没有问题
		//String fileName = URLEncoder.encode(file.getName(), "GBK");
		response.setContentType("application/octet-stream; charset=GBK");
		response.addHeader("Content-disposition"," attachment; filename=" + fileName + "");
		FileInputStream fis = null;
		OutputStream os = null;

		try {
		    //out.clear();
			//可以扩展到从FTP等网络中读取
		    os = response.getOutputStream();
		    fis = new FileInputStream(file);
		    byte[] b = new byte[1024];
		    int i = 0;
		    while ((i = fis.read(b)) > 0) {
			os.write(b, 0, i);
		    }
		    os.flush();
		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
		    if (fis != null) {
			fis.close();
			fis = null;
		    }
		    if (os != null) {
			os.close();
			os = null;
		    }
		    if (out != null) {
			out.clear();
			out = pageContext.pushBody();
		    }
			ListToTxt.deleteFile(path +"\\"+fileName);
		}
   
%>