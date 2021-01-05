<%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@page import="wscheck.*,java.util.*,weaver.general.*,java.io.*,java.util.zip.*"%><%User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
if(user.getUID()!=1)
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation =Util.null2String(request.getParameter("operation"));
String projectpath =Util.null2String(request.getParameter("projectpath"));
if(projectpath==null||projectpath.trim().equals("")){
	projectpath = GCONST.getRootPath();
}
String systemInfo = Util.null2String(request.getParameter("systemInfo"));
systemInfo = java.net.URLDecoder.decode(systemInfo,"UTF-8");
// String systemInfo = new String (Util.null2String(request.getParameter("systemInfo")).getBytes("iso-8859-1"), "UTF-8");
String message = "";
Map fileMap = null;
List classList = null;
if(operation.equals("pack"))
{
	fileMap = (Map)session.getAttribute("fileMap");
	classList = (List)session.getAttribute("classList");
	String[] checkbhs = request.getParameterValues("checkbh");
	//包含客户环境文件时间比总部备案环境文件时间比较老的文件
	List bhSelectList = new ArrayList();
	//过滤掉客户环境文件时间比总部备案环境文件时间比较老的文件
	List bhSelectList1 = new ArrayList();
	if(null!=checkbhs&&checkbhs.length>0)
	{
		for(int i = 0;i<checkbhs.length;i++)
		{
			String checkbh = Util.null2String(checkbhs[i]).trim();
			if(!"".equals(checkbh))
			{
				 if(checkbh.indexOf("==older")>0){
					 bhSelectList.add(checkbh.replace("==older", ""));
				 }else{
					 bhSelectList.add(checkbh);
					 bhSelectList1.add(checkbh);
				 }
			}
		}
		String updateinfofile = SystemUpdateInfo.getSystemUpdateInfo(projectpath);

		if(!"".equals(updateinfofile))
		{
			bhSelectList.add(updateinfofile);
			bhSelectList1.add(updateinfofile);
		}
		String filelistinfo = SystemUpdateInfo.getModifyAll(fileMap,systemInfo,true,projectpath);
		if(!"".equals(filelistinfo))
		{
			bhSelectList.add(filelistinfo);
		}
		String filelistinfo1 = SystemUpdateInfo.getModifyAll(fileMap,systemInfo,false,projectpath);
		bhSelectList1.add(filelistinfo1);
// 		String tempprojectpath = GCONST.getRootPath();
//     	if(!projectpath.equals(""))
//     	{
//     		tempprojectpath = projectpath;
//     	}
		wscheck.ZipUtils PackFileUtil = new wscheck.ZipUtils();
		wscheck.ZipUtils.execute(bhSelectList, GCONST.getRootPath()+"ecology_all"+".zip",projectpath,"ecology");
		wscheck.ZipUtils.execute(bhSelectList1, GCONST.getRootPath()+"ecology_filtrate"+".zip",projectpath,"ecology");
		wscheck.ZipUtils.execute(classList, GCONST.getRootPath()+"ecology_class"+".zip",projectpath,"ecology");
		List outFileList = new ArrayList();
		outFileList.add(GCONST.getRootPath()+"ecology_all"+".zip");
		outFileList.add(GCONST.getRootPath()+"ecology_filtrate"+".zip");
		outFileList.add(GCONST.getRootPath()+"ecology_class"+".zip");
		wscheck.ZipUtils.execute(outFileList, GCONST.getRootPath()+"filesystem"+File.separatorChar+"allecologyzip"+".zip", GCONST.getRootPath(),"allecologyzip");

		File allecologyzip = new File(GCONST.getRootPath()+"filesystem"+File.separatorChar+"allecologyzip"+".zip");
		new File(GCONST.getRootPath()+"ecology_all"+".zip").delete();
		new File(GCONST.getRootPath()+"ecology_filtrate"+".zip").delete();
		new File(GCONST.getRootPath()+"ecology_class"+".zip").delete();
		new File(filelistinfo).delete();
		new File(filelistinfo1).delete();
		if(allecologyzip.exists())
		{
			InputStream ins=null;
	        BufferedInputStream bins=null;
	        OutputStream outs=null;
		    BufferedOutputStream bouts=null;
		    try
		    {
		      response.reset();
		      ins=new FileInputStream(allecologyzip); 
		      bins=new BufferedInputStream(ins);//放到缓冲流里面
		      outs=response.getOutputStream();//获取文件输出IO流 
		      bouts=new BufferedOutputStream(outs); 
		      response.setBufferSize(0);
              response.setContentType("application/x-download");//设置response内容的类型 
              response.setHeader("Content-disposition","attachment;filename=\"allecologyzip.zip");//设置头部信息 
              //response.addHeader("Content-Length", "" + newecologyzip.length());
              int bytesRead = 0; 
              byte[] buffer = new byte[8192]; 
              //开始向网络传输文件流 
              while ((bytesRead = bins.read(buffer, 0, 8192)) != -1) { 
               	bouts.write(buffer, 0, bytesRead); 
               	bouts.flush();
                }
	          bouts.flush();//这里一定要调用flush()方法 
	          outs.flush();
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
	}
	
}
%>