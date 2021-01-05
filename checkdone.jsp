
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,java.util.*,java.io.*,java.util.regex.*,java.util.concurrent.*,weaver.hrm.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>xmltable-dongping </title>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%!
	public List getFiles(String filepath){
		List files = new Vector();
		//System.out.println(TimeUtil.getCurrentTimeString()+":开始得到项目 "+project+" 文件列表...");
		listFiles(files,filepath);
		//System.out.println(TimeUtil.getCurrentTimeString()+":项目 "+project+" 文件列表获取完成..."+files.size());
		return files;
	}

	public void listFiles(List files,String dirName){
		try{
			File dirFile = new File(dirName);
			 if(!dirFile.exists() || (!dirFile.isDirectory())){
			 }else{
				 File[] tmpfiles = dirFile.listFiles();
				 for(int i=0;i<tmpfiles.length;i++){
					 File f = tmpfiles[i];
					 if(f.isFile()){

						 if(f.getName().toLowerCase().endsWith(".jsp")){
							files.add(f.getAbsolutePath().replaceAll("\\\\", "/"));
						 }
					 }else if(f.isDirectory()){
						 listFiles(files,f.getAbsolutePath().replaceAll("\\\\", "/"));
					 }
				 }
			 }
		}catch(Exception e){}
	}

	public String checkCode(String code,int line){
		if(code==null)return null;
		Pattern p = null;
		Matcher m = null;
		p = Pattern.compile("GC\\(|connect\\(\\)",Pattern.CASE_INSENSITIVE);
		m = p.matcher(code);
		if(m.find()){
			//new weaver.filter.XssUtil().writeLog(code+"======"+m.group(),true);
			//找到，有问题，接下来检查是否是例外
				return "0";
		}
		return null;
	}

	public List checkFiles(List files){
		String readline = "";
		List resultList = new Vector();
		int i=0;
		weaver.filter.XssUtil xss = new weaver.filter.XssUtil();
		for(int j=0;j<files.size();j++){
			String file = ""+files.get(i);
			i++;
			//xss.writeLog(file,true);
			if(i%50==0){
				try{
					xss.writeLog("已完成："+(i*1.0/files.size()*100)+"%...",true);
				}catch(Exception e){}
				//System.out.println("已完成："+(i*1.0/files.size()*100)+"%...");
			}
			
			File f = new File(file);
			if(!f.exists())continue;
			if(f.getName().indexOf("MonitorMem.jsp")!=-1 
				||f.getName().indexOf("MailAccountCheckInfoOperation.jsp")!=-1
				||f.getName().indexOf("HrmSalaryOperation.jsp")!=-1
				||f.getName().indexOf("HrmDataCollect.jsp")!=-1
				||f.getName().indexOf("testsapcon.jsp")!=-1
				||f.getName().indexOf("wmForWeb.jsp")!=-1
				||f.getName().indexOf("messager.jsp")!=-1
				||f.getName().indexOf("locationaddress.jsp")!=-1
				||f.getName().indexOf("MailOperationGet.jsp")!=-1
				||f.getName().indexOf("SocialIMClient.jsp")!=-1
			)continue;
			BufferedReader is = null;
			boolean isComment = false;
			try {
				is = new BufferedReader(new InputStreamReader(new FileInputStream(f),"GBK"));
				int lineno=0;
				//System.out.println("正在检查第"+i+"个文件，总共"+files.size()+"个文件...");
				long spaceCount = 0;
				long totalCount = 0;
				boolean inKeyword = false;
				while ((readline = is.readLine()) != null)   {
					//readline = readline.trim() ;
					lineno++;
					if(readline!=null){
						//if(readline.indexOf("//")!=-1)continue;
						//totalCount+=readline.length();
						/*for(int c=0;c<readline.length();c++){
							if(readline.charAt(c)==32){
								spaceCount++;
							}else if(readline.charAt(c)==9){
								spaceCount+=4;
							}
						}*/
						String res = checkCode(readline,lineno);
						if(res==null){//正常
						}else if(res.equals("0")){//非例外
							//resultList.add(f.getPath());
							inKeyword = true;
							break;
						}
					}
				}
				if(inKeyword){
					resultList.add(f.getPath());
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally{
				try{
					is.close();
				}catch(Exception e){}
			}
		}
		return resultList;
	}

	

%>
<body>
<div style="margin:0 auto;width:300px;margin-top:50px;">
<%
	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null)return;

	if(!"sysadmin".equals(user.getLoginid()))return;
	try{
		xssUtil.initRules(true);
	}catch(Exception e){
		out.println(e.toString());
	}
	//out.println(xssUtil.getRule().get("status")+"===="+xssUtil.getIsInitSuccess());
	out.println("公司名称：<span style='color:red;'><b>"+xssUtil.getCompanyname()+"</b></span><p></p>");

	if(xssUtil.null2String(xssUtil.getRule().get("status")).equals("1") && xssUtil.getIsInitSuccess()){
		try{
			out.println("登录保护："+(xssUtil.isLoginCheck()?"<span style='color:red;'><b>开启</b></span><p></p>":"<span style='color:red;'><b>未开启</b></span><p></p>"));
		}catch(Exception e){}
		try{
			out.println("数据库保护："+(!xssUtil.getIsSkipRule()?"<span style='color:red;'><b>开启</b></span><p></p>":"<span style='color:red;'><b>未开启</b></span><p></p>"));
		}catch(Exception e){}
		try{
			out.println("页面保护："+(xssUtil.getMustXss()?"<span style='color:red;'><b>开启</b></span><p></p>":"<span style='color:red;'><b>未开启</b></span><p></p>"));
		}catch(Exception e){}
	}else{
		try{
			out.println("登录验证：<span style='color:red;'><b>未开启</b></span><p></p>");
		}catch(Exception e){}
		try{
			out.println("数据库保护：<span style='color:red;'><b>未开启</b></span><p></p>");
		}catch(Exception e){}
		try{
			out.println("页面保护：<span style='color:red;'><b>未开启</b></span><p></p>");
		}catch(Exception e){}
	}

	out.println("<p></p><p></p>");
	List exceptionFiles = checkFiles(getFiles(request.getRealPath("/")));
	//System.out.println(exceptionFiles);
	out.println("疑似异常文件列表：<p></p>");
	out.println("<div style='color:red;'><b>");
	for(int i=0;i<exceptionFiles.size();i++){
		String ef = xssUtil.null2String(exceptionFiles.get(i));
		out.println("<p>"+ef.substring(ef.indexOf("ecology"),ef.length())+"</p>");
	}
	out.println("</b></div>");
%>
</div>
</body>
</html>
