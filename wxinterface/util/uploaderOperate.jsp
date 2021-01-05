<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.DocImageManager" %>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="DesUtil" class="weaver.general.DesUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	FileUpload fu = new FileUpload(request,"utf-8");
	
	int userid=Util.getIntValue(DesUtil.decrypt(fu.getParameter("userid")),0);
	int language=Util.getIntValue(fu.getParameter("language"),0);
	int logintype=Util.getIntValue(fu.getParameter("logintype"),0);
	int departmentid=Util.getIntValue(fu.getParameter("departmentid"),0);
	int docid=Util.getIntValue(fu.getParameter("docid"),0);
	User user=new User();
	user.setUid(userid);
	user.setLanguage(language);
	user.setLogintype(""+logintype);
	user.setUserDepartment(departmentid);

	String fileId = Util.null2String(fu.uploadFiles("Filedata"));
	DocImageManager imgManger = new DocImageManager();
	rs.executeSql("select * from ImageFile where imagefileid = "+fileId);
	if(rs.next()){
		String filename =Util.null2String(rs.getString("imagefilename"));
		imgManger.resetParameter();
		imgManger.setImagefilename(filename);
		String ext = getFileExt(filename);
		if (ext.equalsIgnoreCase("doc")) {
			imgManger.setDocfiletype("3");
		} else if (ext.equalsIgnoreCase("xls")) {
			imgManger.setDocfiletype("4");
		} else if (ext.equalsIgnoreCase("ppt")) {
			imgManger.setDocfiletype("5");
		} else if (ext.equalsIgnoreCase("wps")) {
			imgManger.setDocfiletype("6");
		} else if (ext.equalsIgnoreCase("docx")) {
			imgManger.setDocfiletype("7");
		} else if (ext.equalsIgnoreCase("xlsx")) {
			imgManger.setDocfiletype("8");
		} else if (ext.equalsIgnoreCase("pptx")) {
			imgManger.setDocfiletype("9");
		} else if (ext.equalsIgnoreCase("et")) {
			imgManger.setDocfiletype("10");
		} else {
			imgManger.setDocfiletype("2");
		}
		imgManger.setDocid(docid);
		imgManger.setImagefileid(Util.getIntValue(fileId, 0));
		imgManger.setIsextfile("1");
		imgManger.AddDocImageInfo();
	}
	out.println(fileId);
%>

<%! 
public String getFileExt(String file) {
	if (file == null || file.trim().equals("")){
		return "";
	} else {
		int idx = file.lastIndexOf(".");
		if (idx == -1) {
			return "";
		} else {
			if (idx + 1 >= file.length()) {
				return "";
			} else {
				return file.substring(idx + 1);
			}
		}
	}
}
%>