<%@ page import="weaver.general.Util,java.io.File,org.apache.commons.io.FileUtils" %>
<%@ page import="weaver.file.FileUploadToPath,weaver.general.GCONST,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%

FileUploadToPath fu = new FileUploadToPath(request);
String excelName = fu.uploadFiles("customTemplate") ;
String fname = Util.null2String(fu.getParameter("fileName"));

boolean result = weaver.file.FileType.validateFileExt(fname);

if(fname.indexOf("./")!=-1 || !result){
	out.print("上传失败:"+excelName);
	return;
}

fname = fname.replaceAll("\0","");

String saveFileName = GCONST.getRootPath()+"datacenter" + File.separatorChar + "inputexcellfile" + File.separatorChar + fname+".xls";
File srcFile=new File(excelName);
File destFile=new File(saveFileName);
if(destFile.exists()) FileUtils.forceDelete(destFile);
FileUtils.copyFile(srcFile,destFile);
FileUtils.forceDelete(srcFile);
out.print("上传成功:"+excelName);
%>