<%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@page import="wscheck.*,java.util.*,weaver.general.*,java.io.*,java.util.zip.*"%><%response.setHeader("cache-control", "no-cache")
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)
	return ;
if(user.getUID()!=1)
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operation =Util.null2String(request.getParameter("operation"));
String[] checkbhs = request.getParameterValues("checkbh");
String message = "";
if("pack".equals(operation))
{
	List bhSelectList = new ArrayList();
	if(null!=checkbhs&&checkbhs.length>0)
	{
		for(int i = 0;i<checkbhs.length;i++)
		{
			String checkbh = checkbhs[i];
			bhSelectList.add(checkbh);
		}
		String updateinfofile = SystemUpdateInfo.getSystemUpdateInfo();
		if(!"".equals(updateinfofile))
		{
			bhSelectList.add(updateinfofile);
		}
		File ecologyzip = new File(GCONST.getRootPath()+"filesystem"+File.separatorChar+"ecology"+".zip");
		if(ecologyzip.exists())
		{
			ecologyzip.delete();
		}
		ZipUtils PackFileUtil = new ZipUtils();
		ZipUtils.execute(bhSelectList, GCONST.getRootPath()+"filesystem"+File.separatorChar+"ecology"+".zip",GCONST.getRootPath(),"ecology");
		File newecologyzip = new File(GCONST.getRootPath()+"filesystem"+File.separatorChar+"ecology"+".zip");
		if(newecologyzip.exists()){
			InputStream ins=null;
	        BufferedInputStream bins=null;
	        OutputStream outs=null;
		    BufferedOutputStream bouts=null;
		    try
		    {
		      response.reset();
		      ins=new FileInputStream(newecologyzip);
		      bins=new BufferedInputStream(ins);//放到缓冲流里面 
		      outs=response.getOutputStream();//获取文件输出IO流 
		      bouts=new BufferedOutputStream(outs);
		      response.setBufferSize(0);
              response.setContentType("application/x-download");//设置response内容的类型 
              response.setHeader("Content-disposition","attachment;filename=\"ecology.zip");//设置头部信息 
              //response.addHeader("Content-Length", "" + newecologyzip.length());
              int bytesRead = 0; 
              byte[] buffer = new byte[1024]; 
              //开始向网络传输文件流 
              while ((bytesRead = bins.read(buffer, 0, 1024)) != -1) { 
             	bouts.write(buffer, 0, bytesRead); 
             	//bouts.flush();
              } 
	          bouts.flush();//这里一定要调用flush()方法 
	          outs.flush();
	          ins.close(); 
	          bins.close(); 
	          outs.close(); 
	          bouts.close(); 
		   }
		   catch (Exception ef)
		   {
			   ef.printStackTrace();
		   }
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
			response.sendRedirect("/keygenerator/getNoCheckFiles.jsp?message="+message);
			return;
		}
	}
}
%>
