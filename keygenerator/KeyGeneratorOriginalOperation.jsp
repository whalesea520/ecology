<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.*,java.io.*,weaver.file.FileUpload" %><%weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser (request , response);

if(user == null)  
	return ;
if(user.getUID()!=1)
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
FileUpload fu = new FileUpload(request);
String projectpath = Util.null2String(fu.getParameter("projectpath"));

if(projectpath==null||projectpath.equals("")){
	projectpath = GCONST.getRootPath();
}

wscheck.CheckScanAllFile KeyGenerator = new wscheck.CheckScanAllFile();
KeyGenerator.setIscontentdate(true);
// String keypath = KeyGenerator.getMD5File(GCONST.getRootPath(),GCONST.getRootPath());
String keypath = KeyGenerator.getMD5File(projectpath,projectpath);

if(!keypath.equals("")){
	File newfile = new File(keypath);
	if(newfile.exists())
	{
		InputStream ins=null;
        BufferedInputStream bins=null;
        OutputStream outs=null;
	    BufferedOutputStream bouts=null;
	    try
	    {
		
	      ins=new FileInputStream(newfile); 
	      bins=new BufferedInputStream(ins);//放到缓冲流里面 
	      outs=response.getOutputStream();//获取文件输出IO流 
	      bouts=new BufferedOutputStream(outs); 
             response.setContentType("application/x-download");//设置response内容的类型 
             response.setHeader("Content-disposition","attachment;filename=\"ecology.key");//设置头部信息 
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
	   catch (Exception ef)
	   {}
	   finally 
	   {
   			if(ins!=null) ins.close();
   			if(bins!=null) bins.close();
   			if(outs!=null) outs.close();
			if(bouts!=null) bouts.close();
   	   }
	}
	else
	{
		response.sendRedirect("/keygenerator/KeyGeneratorOriginal.jsp?keypath="+keypath+"&message=-1");
		return;
	}
}
else
{
	response.sendRedirect("/keygenerator/KeyGeneratorOriginal.jsp?keypath="+keypath+"&message=-1");
	return;
}
%>