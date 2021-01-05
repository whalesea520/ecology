<%@page language="java" contentType="application/x-msdownload" pageEncoding="gb2312"%><%@ page import="java.io.FileInputStream"%><%@ page import="java.net.URLEncoder"%><%@ include file="/systeminfo/init_wev8.jsp" %><%
	
//qc:271653日志监测
	
	//关于文件下载时采用文件流输出的方式处理：  
	//加上response.reset()，并且所有的％>后面不要换行，包括最后一个；  
	
	String module = request.getParameter("module");
if(!HrmUserVarify.checkUserRight("tail:log",user) || 
		(HrmUserVarify.checkUserRight("tail:log",user)  && !"sysadmin".equals(user.getLoginid().toLowerCase())) ||
				("".equals(module) || null == module)
		) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String seldate = request.getParameter("seldate");
	String basePath = request.getRealPath("/");//取得当前目录的路径

	String path = basePath + "/log/" + module
			+ ("".equals(seldate) ? "" : "_" + seldate + ".log");

	response.reset();
	response.setContentType("application/x-download");

	String filenamedownload = path;
	String filedisplay = "";
	if (path.lastIndexOf("/") > 0) {
		filedisplay = path.substring(path.lastIndexOf("/") + 1);
	} else if (path.lastIndexOf("\\") > 0) {
		filedisplay = path.substring(path.lastIndexOf("\\") + 1);
	}

	filedisplay = URLEncoder.encode(filedisplay, "UTF-8");
	response.addHeader("Content-Disposition", "attachment;filename="
			+ filedisplay);

	java.io.OutputStream outp = null;
	java.io.FileInputStream in = null;
	try {
		outp = response.getOutputStream();
		in = new FileInputStream(filenamedownload);

		byte[] b = new byte[1024];
		int i = 0;
		while ((i = in.read(b)) > 0) {
			outp.write(b, 0, i);
		}
		outp.flush();
		//要加以下两句话，否则会报错  
		//java.lang.IllegalStateException: getOutputStream() has already been called for //this response    
		out.clear();
		out = pageContext.pushBody();
	} catch (Exception e) {
		//System.out.println("Error!");//277481,lv,[90]集成中心－解决代码质量问题修复--不允许使用 System.out.println()
		e.printStackTrace();
	} finally {
		if (in != null) {
			in.close();
			in = null;
		}
		//这里不能关闭    
		//if(outp != null)  
		//{  
		//outp.close();  
		//outp = null;  
		//}  
	}
%>  
