
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.convert.tools.FileType" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="weaver.hrm.*,java.io.*,weaver.file.multipart.*,weaver.docs.docreader.*,weaver.docs.docpreview.*,org.json.*,weaver.file.*" %>
<%@ page import="weaver.general.DesUtil"%>	
<jsp:useBean id="imgManger" class="weaver.docs.docs.DocImageManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%!
	/**
	 * 检测文件格式是否合法
	 * @param filename  文件名，如rename.bat
	 * @return
	 */
	private boolean validateFileExt(String filename){
		String[] allowTypes  = new String[]{"doc","docx"};
		if(filename!=null && allowTypes!=null){
			for(int i=0;i<allowTypes.length;i++){
				if(filename.toLowerCase().endsWith(allowTypes[i].toLowerCase())){
					return true;
				}
			}
			return false;
		}else{
			return false;
		}
	}
%>
<%
    /*用户验证*/
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null) {
	    response.sendRedirect("/login/Login.jsp");
	    return;
	}
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	FileUpload fu = new FileUpload(request,"utf-8",false,true);

	File file = fu.getFile("Filedata");
	
	InputStream in = new FileInputStream(file);
	InputStream ips = new FileInputStream(file);
	String fileTypeTemp = FileType.getFileType(ips);
	TransformManager transmanager = TransformManager.getInstance(request);
	ByteArrayOutputStream bos = new ByteArrayOutputStream();
	
	String filename = fu.getFileOriginalFileName("Filedata");
	String filextname = filename.substring(filename.lastIndexOf(".")+1);
	if(fileTypeTemp!=null&&fileTypeTemp.equals("wps")){
		fileTypeTemp=filextname;
	}
	try{
		if(validateFileExt(filename)) {
			if(fileTypeTemp.equals("doc")){
			   bos = (ByteArrayOutputStream)transmanager.docToHtml(in,new ISaveImageFileImpl(){
				   public String saveImage(byte[] bytes,Map<String,String>  imgparams) {
					   if(bytes.length<=0){
							return "0";
						}
						String extname=Util.null2String((String)imgparams.get("extname"));
						if(!extname.equals("")){
							extname="."+extname;
						}
						ImageFileManager imageFileManager=new ImageFileManager();
						imageFileManager.setImagFileName(""+UUID.randomUUID().toString()+"_"+extname);
						imageFileManager.setData(bytes);
						int picFileId=imageFileManager.saveImageFile();	
						return picFileId+"";
				   }
			   });
			}else if(fileTypeTemp.equals("docx")){
			   bos = (ByteArrayOutputStream)transmanager.docxToHtml(in,new ISaveImageFileImpl(){
				   public String saveImage(byte[] bytes,Map<String,String>  imgparams) {
						if(bytes.length<=0){
							return "0";
						}
						String extname=Util.null2String((String)imgparams.get("extname"));
						if(!extname.equals("")){
							extname="."+extname;
						}
						ImageFileManager imageFileManager=new ImageFileManager();
						imageFileManager.setImagFileName(""+UUID.randomUUID().toString()+"_"+extname);
						imageFileManager.setData(bytes);
						int picFileId=imageFileManager.saveImageFile();	
						return picFileId+"";
				   }
			   });
			}
			Map<String,String>  datas = new HashMap<String,String>();
			String htmlStr = " ";
			if(filextname.equals("doc")){
			htmlStr = new String(bos.toByteArray(),"GBK");
			}else{
			htmlStr = new String(bos.toByteArray(),"utf-8");
			}
			Pattern p = Pattern.compile("<!--[\\w\\W\r\\n]*?-->");
			Matcher matcher = p.matcher(htmlStr);
			htmlStr = matcher.replaceAll("");
			
			Pattern p1 = Pattern.compile("<\\?[\\w\\W\r\\n]*\\?>");
			Matcher matcher1 = p1.matcher(htmlStr);
			htmlStr = matcher1.replaceAll("");
	
			Pattern p2 = Pattern.compile("<!DOCTYPE[\\w\\W\r\\n]*?>");
			Matcher matcher2 = p2.matcher(htmlStr);
			htmlStr = matcher2.replaceAll("");
	
			datas.put("html",htmlStr);
			datas.put("state","SUCCESS");
			JSONObject obj = new JSONObject(datas);
			out.println("<div id='wordcontent'>"+htmlStr+"</div><input type='hidden' name='state' value='SUCCESS'><script>var data = "+obj.toString()+"; </script>");	
		}else{
			out.println("file type is not valid!");
		}
	}catch(Exception e){
		//e.printStackTrace();
		new weaver.general.BaseBean().writeLog(e);
		out.println("error!");
	}finally{
		try{
			file.delete();
		}catch(Exception e){
			//e.printStackTrace();
			new weaver.general.BaseBean().writeLog(e);
		}
	}

%>





