<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.weaver.update.PackageUtil"%>
<%@ page import="weaver.conn.*"%>
<% 

	String type = Util.null2String(request.getParameter("type"));
	String path  = "";
	//System.out.println("--------path--------:"+path);
	//path = java.net.URLDecoder.decode(path);
	String packagename ="";
	if("0".equals(type)) {
		packagename = "内容";
	} else if("1".equals(type)) {
		packagename = "配置";
	} else {
		packagename = "文件";
	}
	//System.out.println("--------path--------:"+path);
    
   

//String path=GCONST.getRootPath()+ "downloadBatch"+File.separatorChar+str; 
//String path="E:/bjls_ecology4.1_5.0/ecology/downloadBatch/"+str; 
if(!"".equals(path)){ 
 File file=new File(path); 
 if(file.exists()){ 
  InputStream ins=null;
  BufferedInputStream bins=null;
  OutputStream outs=null;
  BufferedOutputStream bouts=null;
  try
  {
	
  ins=new FileInputStream(path); 
  bins=new BufferedInputStream(ins);//放到缓冲流里面 
  outs=response.getOutputStream();//获取文件输出IO流 
  bouts=new BufferedOutputStream(outs); 
       response.setContentType("application/x-download");//设置response内容的类型 
       response.setHeader("Content-disposition","attachment;filename=\""+ new String("4343.txt".getBytes("GBK"), "ISO8859_1")+"\"");//设置头部信息 
       int bytesRead = 0; 
       byte[] buffer = new byte[8192]; 
       //开始向网络传输文件流 
       while ((bytesRead = bins.read(buffer, 0, 8192)) != -1) { 
           bouts.write(buffer, 0, bytesRead); 
       } 
       bouts.flush();//这里一定要调用flush()方法 
       ins.close(); 
       bins.close(); 
       outs.close(); 
       bouts.close(); 
   }
  catch (Exception ef){}
  finally {
				
		if(ins!=null) ins.close();
		if(bins!=null) bins.close();
		if(outs!=null) outs.close();
		if(bouts!=null) bouts.close();
			}

 } 
 else{ 
  response.sendRedirect("/login/BatchDownloadsEror.jsp"); 
 } 
} else{ 
 response.sendRedirect("/login/BatchDownloadsEror.jsp"); 

//注;这里面不要用到PrintWriter out=response.getWriter();这里调用了response对象，后面下载调用时就会出错。这里要是想都用，希望大家找到解决办法。 
} 

%>


