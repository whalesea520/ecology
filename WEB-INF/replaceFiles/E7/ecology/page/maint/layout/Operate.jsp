<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.*,weaver.file.FileType" %>
<%@page import="weaver.page.maint.layout.PageLayoutUtil"%>
<%@page import="weaver.homepage.cominfo.HomepageBaseLayoutCominfo"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="hbc" class="weaver.homepage.cominfo.HomepageBaseLayoutCominfo" scope="page" />
<%
BaseBean baseBean = new BaseBean();
String dirLayout=pc.getConfig().getString("layout.path");
String tempPath = GCONST.getRootPath()+dirLayout+"/temp";
String message="0";
DiskFileUpload fu = new DiskFileUpload();
//fu.setSizeMax(4194304);				//4MB
fu.setSizeThreshold(4096);			//缓冲区大小4kb
fu.setRepositoryPath(tempPath);


String method="",layoutname="", layoutdesc="";
String id = "";
String zipName="";
String zipTmp="";
File targetFile=null;
if(request.getParameter("method")!=null){
	method = Util.null2String(request.getParameter("method"));
	id=Util.null2String(request.getParameter("layoutid"));
}else{
	
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();
	try{
		FileItem zipItem =null;
		while(i.hasNext()) {
			FileItem item = (FileItem)i.next();
			if(!item.isFormField()){
				String name = item.getName();
				List<String> allowTypes = new ArrayList<String>();
				allowTypes.add(".zip");
				if(Util.isExcuteFile(name) || !FileType.validateFileExt(name,allowTypes)) continue;
				long size = item.getSize();
				if((name==null || name.equals("")) || size==0)	continue;
				
				zipName=name;
				int pos=zipName.lastIndexOf(File.separatorChar);
				if(pos==-1){
					pos=zipName.lastIndexOf("\\");
				}
				if(pos!=-1) zipName=zipName.substring(pos+1);
				zipItem = item;
				//targetFile = new File( GCONST.getRootPath()+dirLayout+"/zip/"+zipName);
				//item.write(targetFile);
				//item.delete();			
			}else{
				
				if(item.getFieldName().equals("method")) method=Util.null2String(item.getString("GBK"));
				if(item.getFieldName().equals("layoutname")) layoutname=Util.null2String(item.getString("GBK"));
				if(item.getFieldName().equals("layoutdesc")) layoutdesc=Util.null2String(item.getString("GBK"));
				if(item.getFieldName().equals("layoutid")) id= Util.null2String(item.getString("GBK"));
			}
		}
		if(zipItem!=null){
			if("add".equals(method)){
				Date currentDate = new Date();
				long currentTime = currentDate.getTime();
				zipTmp = currentTime+"";
			}else{
				rs.execute("select layoutdir from pagelayout where id="+id);
				if(rs.next()){
					String tempdir = Util.null2String(rs.getString("layoutdir"));
					zipTmp = tempdir;
					if(!"".equals(tempdir)&&tempdir.indexOf("/")!=-1)
						zipTmp = tempdir.substring(0,tempdir.indexOf("/"));
				}
			}

			File zipFileDir  = new File(GCONST.getRootPath()+dirLayout+"/zip/"+zipTmp+"/");
			zipFileDir.mkdirs();
			//FileUtils.cleanDirectory(zipFileDir);
			targetFile = new File( GCONST.getRootPath()+dirLayout+"/zip/"+zipTmp+"/"+zipName);
			zipItem.write(targetFile);
			zipItem.delete();	
		}
	}catch(java.io.FileNotFoundException e){
		message ="1";
		baseBean.writeLog(e);
	}
}
layoutdesc = layoutdesc.replaceAll("\n","<br/>");
//System.out.println("huanhang:::::"+layoutdesc.indexOf("\n"));
List<String> allowTypes = new ArrayList<String>();
allowTypes.add(".htm");
allowTypes.addAll(FileType.FILE_TYPE_LIST);
if("add".equals(method)){
	String rarPath = GCONST.getRootPath()+dirLayout+"/";
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
					if(!FileType.validateFileExt(entryName,allowTypes)) continue;
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
			if(plu.replaceLayoutTemplate(dirLayout,dir)){
				rs.execute("insert into pagelayout (layoutname,layoutdesc,layouttype,layoutdir,zipname) values ('"+layoutname+"','"+layoutdesc+"','cus','"+dir+"','"+zipTmp+"/"+zipName+"')");
				int maxId =0;
				rs.execute("select max(id) as maxId from pagelayout");
				if(rs.next()){
					maxId=Util.getIntValue(rs.getString("maxId"),0);
				}
				//TODO 是否存在验证
				rs.execute("select id from hpbaselayout where id = "+maxId);
				if(!rs.next()){
					rs.execute("insert into hpbaselayout (id,layoutname,layoutdesc,layoutimage,layoutcode,allowArea,ftl) values ("+maxId+",'"+layoutname+"','"+layoutdesc+"',' ',' ','"+plu.getAllowArea()+" ','"+dir+"index.htm')");
				}else{
					rs.execute("update hpbaselayout set layoutname='"+layoutname+"', layoutdesc='"+layoutdesc+"',allowArea='"+plu.getAllowArea()+"', ftl='"+dir+"index.htm' where id="+maxId);
				}
			}else{
				message="1";
			}
		}
		} catch (Exception e) {
			message ="1";
			baseBean.writeLog(e);
		}
	}
	
}else if("edit".equals(method)){
	String rarPath = GCONST.getRootPath()+dirLayout+"/";
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
				if(!FileType.validateFileExt(entryName,allowTypes)) continue;
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
			if(plu.replaceLayoutTemplate(dirLayout,dir)){
				String sqlStr = "update pagelayout set layoutname='"+layoutname+"', layoutdesc='"+layoutdesc+"',layoutdir='"+dir+"', zipname='"+zipTmp+"/"+zipName+"' where id="+id;
				rs.execute(sqlStr);
				sqlStr = "update hpbaselayout set layoutname='"+layoutname+"', layoutdesc='"+layoutdesc+"',allowArea='"+plu.getAllowArea()+"', ftl='"+dir+"index.htm' where id="+id;
				rs.execute(sqlStr);
			}else{
				message="1";
			}
		}
		} catch (Exception e) {
			message ="1";
			baseBean.writeLog(e);
		}
	}else{
		String sqlStr = "update pagelayout set layoutname='"+layoutname+"', layoutdesc='"+layoutdesc+"' where id="+id;
		rs.execute(sqlStr);
		sqlStr = "update hpbaselayout set layoutname='"+layoutname+"', layoutdesc='"+layoutdesc+"' where id="+id;
		rs.execute(sqlStr);
	}
}else if("del".equals(method)){
	
	rs.executeSql("select count(*) from hpinfo where layoutid='"+id+"'");
	rs.next();
	boolean isUsed=rs.getInt(1)==0?false:true;
	if(!isUsed){
		rs.executeSql("select * from pagelayout where id="+id);
		String dir="";
		String zipNameTemp="";
		if(rs.next()){
				dir=rs.getString("layoutdir");
				zipNameTemp=rs.getString("zipname");
		}
		
		if(!"".equals(dir)){
			//删除文件夹
			File dirFile=new File( GCONST.getRootPath()+dirLayout+dir.substring(0,dir.indexOf("/")));
			try{
				FileUtils.deleteDirectory(dirFile);
			}catch(Exception e){
				//message ="1";
				baseBean.writeLog(e);
			}
		}
		
		if(!"".equals(zipNameTemp)){
			//删除文件夹
			File zipFile=new File( GCONST.getRootPath()+dirLayout+"zip/"+zipNameTemp.substring(0,zipNameTemp.indexOf("/")));
			try{
			  FileUtils.deleteDirectory(zipFile);
			}catch(Exception e){
				//message ="1";
				baseBean.writeLog(e);
			}
		}
		rs.execute("delete from pagelayout where id="+id);
		rs.execute("delete from hpbaselayout where id="+id);
	}else{
		response.sendRedirect("LayoutList.jsp?message=isused");
		return;
	}
}
try{
	hbc.updateHomepageLayoutCache();
}catch(Exception ex){
	message ="1";
	baseBean.writeLog(ex);
}
response.sendRedirect("LayoutList.jsp?message="+message);
%>