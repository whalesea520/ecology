<%@ page language="java"    pageEncoding="UTF-8"  import="weaver.system.SysUpgradeCominfo,weaver.general.*,java.io.*,java.net.*,weaver.conn.RecordSet,weaver.file.FileManage"%>
<%
RecordSet rs = new RecordSet();
String rootpath = GCONST.getRootPath() ;
String currentDate = TimeUtil.getCurrentDateString();
SysUpgradeCominfo suc = new SysUpgradeCominfo();
String opdate  = suc.getOpdate();
if(!"".equals(opdate)) {
	currentDate = opdate;
}
String alllog = request.getParameter("alllog");
//rs.executeSql("select operationdate from ecologyuplist where operationdate is not null order by operationdate desc");
//if(rs.next()) {
//	currentDate = rs.getString("operationdate");
//}
String logfile = rootpath + "sysupgradelog" + File.separatorChar+currentDate+".log" ;
FileManage.createDir(rootpath + "sysupgradelog") ;
String infofile = rootpath + "sysupgradelog" + File.separatorChar+"UpgradeInfo-"+currentDate+".log";
FileOutputStream fileOutputStream = new FileOutputStream(infofile);
OutputStreamWriter outputStreamWriter = new OutputStreamWriter(fileOutputStream,"UTF-8");
PrintWriter outtext = new PrintWriter(outputStreamWriter);
if("1".equals(alllog)) {
	outtext.println("升级成功，请查看此次升级的信息！");
	outtext.println("");
}

outtext.println("升级中的错误信息如下：");
try {
	File log = new File(logfile);
	if(log.exists()) {
		BufferedReader input=new BufferedReader(new FileReader(logfile));
		String line  = "";
		while((line=input.readLine())!=null){
			outtext.println("  "+line);
		}
	}
} catch(Exception e) {
	e.printStackTrace();
}
//判断是否输出其他日志文件
if("1".equals(alllog)) {
	rs.executeSql("select versionNo,content from ecologyuplist where operationdate='"+currentDate+"' order by label");
	outtext.println("升级内容:");
	while(rs.next()) {
		outtext.println("升级包编号："+rs.getString("versionNo")+"");
		String content = rs.getString("content");
		content = content.replaceAll("<br>","\n");
		content = content.replaceAll("<p>","");
		content = content.replaceAll("</p>","");
		content = content.replaceAll("&lt;","<");
		content = content.replaceAll("&gt;",">");
		content = content.replaceAll("&quot;","\"");
		content = content.replaceAll("&apos;","\'");
		outtext.println("内容："+content);
	}
	outtext.println("");//换行
	outtext.println("升级配置信息：");
	rs.executeSql("select versionNo,configContent from ecologyuplist where operationdate='"+currentDate+"' order by label");
	while(rs.next()) {
		outtext.println("升级包编号："+rs.getString("versionNo")+"");
		
		String configContent = rs.getString("configContent");
		configContent = configContent.replaceAll("<br>","\n");
		configContent = configContent.replaceAll("<p>","");
		configContent = configContent.replaceAll("</p>","");
		configContent = configContent.replaceAll("&lt;","<");
		configContent = configContent.replaceAll("&gt;",">");
		configContent = configContent.replaceAll("&quot;","\"");
		configContent = configContent.replaceAll("&apos;","\'");	
		outtext.println("配置："+configContent);
	}
}

outtext.flush();
fileOutputStream.close();
outputStreamWriter.close();
outtext.close();

try {
    // path是指欲下载的文件的路径。
    File file = new File(infofile);
    // 取得文件名。
    String filename = file.getName();

    // 以流的形式下载文件。
    InputStream fis = new BufferedInputStream(new FileInputStream(infofile));
    byte[] buffer = new byte[fis.available()];
    fis.read(buffer);
    // 清空response
    //int byteread;
	//byte data[] = new byte[1024];
    response.reset();
    // 设置response的Header
    response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(filename,"UTF-8"));
    response.addHeader("Content-Length", "" + file.length());
   
    response.setContentType("application/octet-stream;charset=UTF-8");
    
    BufferedOutputStream toClient = new BufferedOutputStream(response.getOutputStream());
    
    //while((byteread = fis.read(data)) != -1) {
    	//toClient.write(data, 0, byteread) ;
    //	toClient.flush() ;
    //}

    toClient.write(buffer);
    toClient.flush() ;
    fis.close();
    toClient.close();
    response.flushBuffer();
} catch (IOException ex) {
    ex.printStackTrace();
}
%>