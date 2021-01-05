
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Date" %>
<%@page import="weaver.page.maint.layout.PageLayoutUtil"%>
<%@page import="weaver.homepage.cominfo.HomepageBaseLayoutCominfo"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%

String dirTemplate=pc.getConfig().getString("news.path");
String tempPath = GCONST.getRootPath()+dirTemplate;
String message ="0";

DiskFileUpload fu = new DiskFileUpload();
//fu.setSizeMax(4194304);				//4MB
fu.setSizeThreshold(4096);			//缓冲区大小4kb
fu.setRepositoryPath(tempPath);


String method="",templatename="", templatedesc="";
String templatetype="";
String id = "";
String zipName="";
String zipTmp = "";
File targetFile=null;

if(request.getParameter("method")!=null){
	method = Util.null2String(request.getParameter("method"));
	id=Util.null2String(request.getParameter("templateid"));
}else{
	
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();
	try{
		FileItem zipItem = null;
		while(i.hasNext()) {
			FileItem item = (FileItem)i.next();
			if(!item.isFormField()){
				String name = item.getName();
				if(Util.isExcuteFile(name)) continue;
				long size = item.getSize();
				if((name==null || name.equals("")) || size==0)	continue;
				
				zipName=name;
				int pos=zipName.lastIndexOf(File.separatorChar);
				if(pos==-1){
					pos=zipName.lastIndexOf("\\");
				}
				if(pos!=-1) zipName=zipName.substring(pos+1);
				//targetFile = new File( GCONST.getRootPath()+dirTemplate+"/zip/"+zipName);
				//item.write(targetFile);
				zipItem = item;
				//item.delete();			
			}else{
				
				if(item.getFieldName().equals("method")) method=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("templatename")) templatename=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("templatedesc")) templatedesc=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("templateid")) id= Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("templatetype")) templatetype= Util.null2String(item.getString("UTF-8"));
			}
			if(zipItem!=null){
				if("add".equals(method)){
					Date currentDate = new Date();
					long currentTime = currentDate.getTime();
					zipTmp = currentTime+"";
				}else{
					rs.execute("select templatedir from pagenewstemplate where id="+id);
					if(rs.next()){
						String tempdir = Util.null2String(rs.getString("templatedir"));
						zipTmp = tempdir;
						if(!"".equals(tempdir)&&tempdir.indexOf("/")!=-1)
							zipTmp = tempdir.substring(0,tempdir.indexOf("/"));
					}
				}

				File zipFileDir  = new File(GCONST.getRootPath()+dirTemplate+"/zip/"+zipTmp+"/");
				zipFileDir.mkdirs();
				//FileUtils.cleanDirectory(zipFileDir);
				targetFile = new File( GCONST.getRootPath()+dirTemplate+"/zip/"+zipTmp+"/"+zipName);
				zipItem.write(targetFile);
				zipItem.delete();	
			}
			
		}
	}catch(java.io.FileNotFoundException e){
		baseBean.writeLog(e);
		message="1";
		response.sendRedirect("NewsTemplateImport.jsp?closeDialog=close&message="+message);
		return;
	}
}
templatedesc = templatedesc.replaceAll("\n","<br/>");
if("add".equals(method)){
	String rarPath = GCONST.getRootPath()+dirTemplate+"/";
	String dir="";
	if(targetFile!=null){
		try {		
			ZipInputStream in = new ZipInputStream(new FileInputStream(targetFile));
			ZipEntry entry = null;
			boolean isFirst=true;
			while ((entry = in.getNextEntry()) != null) {
				String entryName = entry.getName();
				
				if(entryName.indexOf(zipTmp)==-1){
					entryName = zipTmp+"/"+entryName;
				}
				if(entryName.indexOf("index.htm")!=-1){
					dir=entryName.substring(0,entryName.indexOf("index.htm")-1);
					isFirst=false;
				}				
				if (entry.isDirectory()) {
					
					File file = new File(rarPath + entryName);
					
					file.mkdirs();					
				} else {
					File file = new File(rarPath + entryName);
					if(!file.getParentFile().exists())
						file.getParentFile().mkdir();
					
					FileOutputStream os = new FileOutputStream(rarPath+entryName);
					byte[] buf = new byte[1024];
	
					int len;
					while ((len = in.read(buf)) > 0) {
						os.write(buf, 0, len);
					}
					os.close();
					in.closeEntry();
				}
			}
		
		
		//将数据插入数据库并得到此数据的ID做为目录名。
		
		if(!"".equals(dir)){
			PageLayoutUtil plu = new PageLayoutUtil();
			if(!dir.endsWith("/"))dir = dir+"/";
			if(plu.replaceLayoutTemplate(dirTemplate,dir)){
				String allowArea = plu.getAllowArea();
				rs.execute("insert into pagenewstemplate (templatename,templatedesc,templatetype,templatedir,zipname,allowArea) values ('"+templatename+"','"+templatedesc+"','"+templatetype+"','"+dir+"','"+zipTmp+"/"+zipName+"','"+allowArea+"')");
				int maxId =0;
				rs.execute("select max(id) as maxId from pagenewstemplate");
				if(rs.next()){
					maxId=Util.getIntValue(rs.getString("maxId"),0);
				}
				ArrayList aryArea = Util.TokenizerString(allowArea,",");
				for(int i=0;i<aryArea.size();i++){
					rs.execute("insert into pagenewstemplatelayout (templateid,areaFlag,areaElements) values ('"+maxId+"','"+aryArea.get(i)+"','')");
				}
			}else{
				message="1";
			}
		}
		} catch (Exception e) {
			baseBean.writeLog(e);
			message="1";
		}
	}
	response.sendRedirect("NewsTemplateImport.jsp?closeDialog=close&message="+message);
	return;
}else if("edit".equals(method)){
	String rarPath = GCONST.getRootPath()+dirTemplate+"/";
	String dir="";
	if(targetFile!=null){
		try {			
			ZipInputStream in = new ZipInputStream(new FileInputStream(targetFile));
			ZipEntry entry = null;
			boolean isFirst=true;
			while ((entry = in.getNextEntry()) != null) {
			String entryName = entry.getName();
			if(entryName.indexOf(zipTmp)==-1){
				entryName = zipTmp+"/"+entryName;
			}
			if(entryName.indexOf("index.htm")!=-1){
				dir=entryName.substring(0,entryName.indexOf("index.htm")-1);
				isFirst=false;
			}				
			if (entry.isDirectory()) {
				File file = new File(rarPath + entryName);
				file.mkdirs();					
			} else {
				FileOutputStream os = new FileOutputStream(rarPath+entryName);
				byte[] buf = new byte[1024];

				int len;
				while ((len = in.read(buf)) > 0) {
					os.write(buf, 0, len);
				}
				os.close();
				in.closeEntry();
				}
			}
		
		
		if(!dir.equals("")){
			
			PageLayoutUtil plu = new PageLayoutUtil();
			if(!dir.endsWith("/"))dir = dir+"/";
			if(plu.replaceLayoutTemplate(dirTemplate,dir)){
				String allowArea = plu.getAllowArea();
				String sqlStr = "update pagenewstemplate set templatename='"+templatename+"', templatedesc='"+templatedesc+"',templatedir='"+dir+"', zipname='"+zipTmp+"/"+zipName+"', templatetype='"+templatetype+"', allowArea='"+allowArea+"' where id="+id;
				rs.execute(sqlStr);
				rs.execute("delete from pagenewstemplatelayout where templateid="+id);
				ArrayList aryArea = Util.TokenizerString(allowArea,",");
				for(int i=0;i<aryArea.size();i++){
					rs.execute("insert into pagenewstemplatelayout (templateid,areaFlag,areaElements) values ('"+id+"','"+aryArea.get(i)+"','')");
				}
			}else{
				message="1";
			}
		}
		} catch (Exception e) {
			baseBean.writeLog(e);
			message="1";
		}
	}else{
		String sqlStr = "update pagenewstemplate set templatename='"+templatename+"', templatedesc='"+templatedesc+"', templatetype='"+templatetype+"' where id="+id;
		rs.execute(sqlStr);
	}
	response.sendRedirect("NewsTemplateImport.jsp?closeDialog=close&message="+message);
	return;
}else if("del".equals(method)){
	rs.executeSql("select * from pagenewstemplate where id="+id);
	String dir="";
	String zipNameTemp="";
	if(rs.next()){
			dir=rs.getString("templatedir");
			zipNameTemp=rs.getString("zipname");
	}
	if(!"".equals(dir)){
		//删除文件夹
		try{
			File dirFile=new File( GCONST.getRootPath()+dirTemplate+dir.substring(0,dir.indexOf("/")));
			FileUtils.deleteDirectory(dirFile);
		}catch(Exception ex){
			//message="1";
		}
	}
	
	if(!"".equals(zipNameTemp)){
		//删除文件夹
		try{
			File zipFile=new File( GCONST.getRootPath()+dirTemplate+"zip/"+zipNameTemp.substring(0,zipNameTemp.indexOf("/")));
			FileUtils.deleteDirectory(zipFile);
		}catch(Exception ex){
			//message="1";
		}
	}
	rs.execute("delete from pagenewstemplate where id="+id);
	rs.execute("delete from pagenewstemplatelayout where templateid="+id);
}
response.sendRedirect("NewsTemplateList.jsp?message="+message);
%>