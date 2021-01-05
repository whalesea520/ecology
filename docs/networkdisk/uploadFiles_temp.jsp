<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.GCONST,weaver.system.SystemComInfo" %>
<%@ page import="weaver.docs.networkdisk.server.UploadFileServer" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ page import="java.util.regex.Pattern,java.util.regex.Matcher" %>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	FileOutputStream outputStream = null;
	InputStream inputStream = null;
	File file = null;
	String filesize = "-1";
	String startSize = "-2";
	try
	{
	 // 登录用户ID
		String loginid = request.getHeader("loginid");
		// 上传文件uid
		String uploadfileguid = request.getHeader("uploadfileguid");
		// 上传文件路径uid
		String filepathmd5 = request.getHeader("filepathmd5");
		//起始大小
		String startsize = request.getHeader("startsize");
		
		// 文件大小
		filesize = request.getHeader("filesize");
		// 文件存储根目录
		SystemComInfo syscominfo = new SystemComInfo() ;
		String rootPath = syscominfo.getFilesystem();
		if(rootPath == null || rootPath.isEmpty()){
			rootPath = GCONST.getRootPath();
		}
		
		// 文件存放目录
		String filePath = rootPath+"networkuploadtemp";
		
        File _file = new File(filePath);
        //如果文件夹不存在则创建  
        if (!_file.exists() && !_file.isDirectory()) {
            _file.mkdir();
        }
        
        //验证filepathmd5是否合法
        String reg = "^(\\d|[a-z]){32}$";
        Pattern pattern = Pattern.compile(reg);
        Matcher matcher = pattern.matcher(filepathmd5);
        if(!matcher.matches()){
        	response.setHeader("returnstatus", "-1");
        	return ;
        }
        
        
		filePath += File.separator+filepathmd5+loginid+".temp";
		file = new File(filePath);
		
		
		// 文件流
		inputStream = request.getInputStream();
		if("0".equals(startsize) && file.exists()){
			outputStream = new FileOutputStream(filePath);
		}else{
			outputStream = new FileOutputStream(filePath,true);
		}

		int byteCount = 0;
		byte[] bytes = new byte[1024];
		int aa = 0;
		while ((byteCount = inputStream.read(bytes)) != -1)
		{
			outputStream.write(bytes, 0, byteCount);
			aa += byteCount;
		}
		
		startSize = String.valueOf(file.length());
		if(startSize.equals(filesize))
		{
		 // 文件上传接口
			UploadFileServer uploadFileServer = new UploadFileServer();
			boolean b = uploadFileServer.finallyUpload(filePath,filepathmd5);
			if(b){
				response.setHeader("returnstatus", "0");
			}else{
				response.setHeader("returnstatus", "-1");
			}
		}
		else
		{
			//startSize,filepathmd5
			String updateSql = "update imagefilereftemp set uploadsize = ? where filepathmd5 = ?" ;
			
			ConnStatement stat = new ConnStatement();
			try{
				stat.setStatementSql(updateSql);
				stat.setString(1, startSize);
				stat.setString(2,filepathmd5);
				stat.executeUpdate();
			}catch(Exception e){
			}finally{
				stat.close();
			}
			
			response.setHeader("startsize", startSize);
			response.setHeader("returnstatus", "1");
		}
	}
	catch(Exception ex)
	{
	    ex.printStackTrace();
	}
	finally
	{
	    if(outputStream != null)
	    {
			outputStream.close();
	    }
	    if(inputStream != null)
	    {
	        inputStream.close();
	    }
	    if(startSize.equals(filesize))
		{
	        if(file.exists())
		    {
		        file.delete();
		    } 
		}
	}
%>
