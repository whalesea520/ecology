<%@page import="java.util.Iterator"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="com.mortennobel.imagescaling.ResampleOp"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.zip.ZipInputStream"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.file.AESCoder"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java"%>
<%

response.resetBuffer();
String fileid = Util.null2String(request.getParameter("fileid")).trim();
int sIndex;
if((sIndex = fileid.indexOf("/weaver/weaver.file.FileDownload?fileid=")) != -1){
	int eIndex = fileid.indexOf("&", sIndex);
	if(eIndex == -1){
		eIndex = fileid.length();
	}
	fileid = fileid.substring(sIndex + "/weaver/weaver.file.FileDownload?fileid=".length(), eIndex);
}
boolean isID = fileid.matches("^[-+]?(([0-9]+)([.]([0-9]+))?|([.]([0-9]+))?)$");
boolean isUrl = !isID && !fileid.equals("");
InputStream inStream = null;
String filename = "";
long filesize = -1;
String imagefiletype = "";
if(isID){
	String sql = "select t1.imagefilename,t1.filerealpath,t1.iszip,t1.isencrypt,t1.imagefiletype , t1.imagefileid, t1.imagefile,t1.isaesencrypt,t1.aescode,t2.imagefilename as realname,t1.TokenKey,t1.StorageStatus,t1.comefrom,t1.fileSize as filesize from ImageFile t1 left join DocImageFile t2 on t1.imagefileid = t2.imagefileid where t1.imagefileid = "+fileid;
	RecordSet rs = new RecordSet();
	rs.execute(sql);
	if(rs.next()){
		filename = Util.null2String(rs.getString("realname"));
		if(filename.equals("")){
			filename = Util.null2String(rs.getString("imagefilename"));
		}
		String filerealpath = Util.null2String(rs.getString("filerealpath"));
		String iszip = Util.null2String(rs.getString("iszip"));
		String isaesencrypt = Util.null2o(rs.getString("isaesencrypt"));
		String aescode = Util.null2String(rs.getString("aescode"));
		imagefiletype = Util.null2String(rs.getString("imagefiletype"));
		
		try{
			filesize = Long.parseLong(rs.getString("filesize"));
		}catch(Exception ex){
			filesize = -1;
			ex.printStackTrace();
		}
		
		ZipInputStream zin = null;
		File thefile = new File(filerealpath);
		if (iszip.equals("1")) {
			zin = new ZipInputStream(new FileInputStream(thefile));
			if (zin.getNextEntry() != null) inStream = new BufferedInputStream(zin);
			
		} else{
			inStream = new BufferedInputStream(new FileInputStream(thefile));
			
		}
		
		if(isaesencrypt.equals("1")){
			inStream = AESCoder.decrypt(inStream, aescode); 
		}
		
	}
}else if(isUrl){
	String realPath = request.getSession().getServletContext().getRealPath(fileid);
	File file = new File(realPath);
	if(!file.exists() || !file.isFile()){
		return;
	}
	inStream = new BufferedInputStream(new FileInputStream(file));
	filename = file.getName();
	filesize = file.length();
}


String extName = "";
if(filename.indexOf(".") > -1){
	int bx = filename.lastIndexOf(".");
	if(bx>=0){
		extName = filename.substring(bx+1, filename.length());						
	}
}

String contenttype = "";
if(filename.toLowerCase().endsWith(".gif")) {
	contenttype = "image/gif";  
	response.addHeader("Cache-Control", "private, max-age=8640000"); 
}else if(filename.toLowerCase().endsWith(".png")) {
	contenttype = "image/png";
	response.addHeader("Cache-Control", "private, max-age=8640000"); 
}else if(filename.toLowerCase().endsWith(".jpg")) {
	contenttype = "image/jpg";
	response.addHeader("Cache-Control", "private, max-age=8640000"); 
}else if(filename.toLowerCase().endsWith(".bmp")) {
	contenttype = "image/bmp";
	response.addHeader("Cache-Control", "private, max-age=8640000"); 
}else {					
	contenttype = imagefiletype;
}
response.setContentType(contenttype);
try {
	response.setHeader("content-disposition", "inline; filename=\"" + URLEncoder.encode(filename,"UTF-8")+"\"");
} catch (Exception ecode) {}

ServletOutputStream outStream = null;
try {
	double ratio;
	String ratioStr = Util.null2String(request.getParameter("ratio"));
	if(!ratioStr.trim().equals("")){
		try{
			ratio = Double.parseDouble(ratioStr);
		}catch(Exception ex){
			ex.printStackTrace();
			ratio = 1;
		}
	}else{
		ratio = 1;
		String ratioRule = Util.null2String(request.getParameter("ratioRule"));
		if(ratioRule.trim().equals("")){
			if(extName.equalsIgnoreCase("png")){
				ratioRule = "{20:0.7, 40:0.6, 60:0.5, 80:0.4, 100:0.3}";
			}else{
				ratioRule = "{20:0.9, 50:0.8, 100:0.7, 150:0.6, 200:0.5, 500:0.4, 1024:0.3}";
			}
		}
		JSONObject ratioRuleObj = JSONObject.fromObject(ratioRule);
		long filesizeKb = filesize / 1024;
		Iterator iterator = ratioRuleObj.keys();
		while(iterator.hasNext()){
			Object rKey = iterator.next();
			int rk = NumberHelper.getIntegerValue(rKey);
			if(filesizeKb >= rk){
				double rv;
				try{
					rv = Double.parseDouble(ratioRuleObj.get(rKey).toString());
				}catch(Exception ex){
					ex.printStackTrace();
					rv = 1;
				}
				if(rv < ratio){
					ratio = rv;
				}
			}
		}
	}
	BufferedImage inputBufImage = ImageIO.read(inStream);
	int width = (int)(inputBufImage.getWidth() * ratio);
	int height = (int)(inputBufImage.getHeight() * ratio);
	ResampleOp resampleOp = new ResampleOp(width, height);
	BufferedImage rescaledTomato = resampleOp.filter(inputBufImage,null);
	if(extName.equals("")){
		extName = "jpg";
	}
	outStream = response.getOutputStream();
	ImageIO.write(rescaledTomato, extName, outStream);
	
}
catch(Exception e) {
	e.printStackTrace();
}
finally {
	if(inStream!=null) inStream.close();
	if(outStream!=null) outStream.flush();
	if(outStream!=null) outStream.close();
}
%>
