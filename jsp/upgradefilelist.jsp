<%@ page language="java"    pageEncoding="UTF-8"  import="weaver.general.*,java.io.*,java.net.*,weaver.hrm.*"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String downloadtype = request.getParameter("downloadtype");
String label = request.getParameter("label");
String logfile = "";
if(downloadtype.equals("add")) {
	logfile = GCONST.getRootPath()+"sysupgradelog"+File.separatorChar+"filedetail"+File.separatorChar+"add"+label+".txt";
} else {
	logfile = GCONST.getRootPath()+"sysupgradelog"+File.separatorChar+"filedetail"+File.separatorChar+"update"+label+".txt";
}
//rs.executeSql("select operationdate from ecologyuplist where operationdate is not null order by operationdate desc");
//if(rs.next()) {
//	currentDate = rs.getString("operationdate");
//}

    // path是指欲下载的文件的路径。
    File file = new File(logfile);
    if(file.exists()) {
        // 取得文件名。
        try {
	        String filename = file.getName();
	
	        // 以流的形式下载文件。
	        InputStream fis = new BufferedInputStream(new FileInputStream(logfile));
	        byte[] buffer = new byte[fis.available()];
	        fis.read(buffer);
	        response.reset();
	        // 设置response的Header
	        response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(filename,"UTF-8"));
	        response.addHeader("Content-Length", "" + file.length());
	       
	        response.setContentType("application/octet-stream;charset=UTF-8");
	        BufferedOutputStream toClient = new BufferedOutputStream(response.getOutputStream());
	        
	        toClient.write(buffer);
	        toClient.flush() ;
	        fis.close();
	        toClient.close();
	        response.flushBuffer();
	    } catch (IOException ex) {
	        ex.printStackTrace();
	    }
    }

%>