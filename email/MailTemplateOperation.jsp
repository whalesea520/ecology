
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.file.*,weaver.conn.*" %>
<%@ page import="java.io.Writer,oracle.sql.CLOB,weaver.conn.ConnStatement" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
FileUpload fu = new FileUpload(request, false);
int id = Util.getIntValue(fu.getParameter("id"));
int userId = Util.getIntValue(fu.getParameter("userid"));
if(userId==-1){
	userId = user.getUID();
}
int languageId = user.getLanguage();

String sql = "";
String operation = Util.null2String(fu.getParameter("operation"));
String templateName = Util.null2String(fu.getParameter("templateName"));
String templateDescription = Util.null2String(fu.getParameter("templateDescription"));
String templateSubject = Util.null2String(fu.getParameter("templateSubject"));
String templateContent = Util.null2String(fu.getParameter("mouldtext"));
int defaultMailTemplateId = Util.getIntValue(request.getParameter("defaultTemplateId"));
String templateType = Util.null2String(request.getParameter("templateType"));

String showTop = Util.null2String(fu.getParameter("showTop"));

if(operation.equals("add")){
	ConnStatement statement = new ConnStatement();

	int docimages_num = Util.getIntValue(fu.getParameter("docimages_num"), 0);
	String[] needuploads = new String[docimages_num];

	for (int i = 0; i < docimages_num; i++) {
		needuploads[i] = "docimages_" + i;
	}
	String[] filenames;
	String[] fileids;
	fileids = fu.uploadFiles(needuploads);
	filenames = fu.getFileNames();

	for (int i = 0; i < docimages_num; i++) {
		int pos = templateContent.indexOf(weaver.docs.docs.DocManager.getImgAltFlag(i));
		if (pos != -1) {
			String tmpcontent = templateContent.substring(0, pos);
			tmpcontent += " alt=\"" + filenames[i] + "\" ";
			pos = templateContent.indexOf("src=\"", pos);
			int endpos = templateContent.indexOf("\"", pos + 6);
			tmpcontent += "src=\"/weaver/weaver.file.FileDownload?fileid=" + Util.getFileidOut(fileids[i]);
			tmpcontent += "\"";
			tmpcontent += templateContent.substring(endpos + 1);
			templateContent = tmpcontent;
		} else {
			String sqltmp = "delete from ImageFile where imagefileid=" + fileids[i];
			statement.setStatementSql(sqltmp);
			statement.executeUpdate();
		}
	}

	rs.executeSql("INSERT INTO MailResourceInfo (filename,filetype,filerealpath,iszip,isencrypt,isfileattrachment,fileContentId,isEncoded,filesize) VALUES SELECT imagefilename,imagefiletype,filerealpath,'0','0','0','img0@www.weaver.com.cn','0',0");

	sql = "INSERT INTO MailTemplate (userId, templateName, templateDescription, templateSubject, templateContent) VALUES (?,?,?,?,?)";
	try{
			statement.setStatementSql(sql);
			statement.setInt(1, user.getUID());
			statement.setString(2, templateName);
			statement.setString(3, templateDescription);
			statement.setString(4, templateSubject);
			statement.setCharacterStream(5, templateContent);
			statement.executeUpdate();
	}catch(Exception e){
	}finally{
		try{statement.close();}catch(Exception ex){}
	}
	
	out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
	return;
//===================================================================================================================
//===================================================================================================================
}else if(operation.equals("update")){
	ConnStatement statement = new ConnStatement();

/*
	int tmppos = templateContent.indexOf("/weaver/weaver.file.FileDownload?fileid=");
	while (tmppos != -1) {
		int startpos = templateContent.lastIndexOf("\"", tmppos+10);
		String tmpcontent = templateContent.substring(0, startpos + 1);
		tmpcontent += templateContent.substring(tmppos);
		templateContent = tmpcontent;
		tmppos = templateContent.indexOf("/weaver/weaver.file.FileDownload?fileid=", tmppos);
	}
*/
	int olddocimagesnum = Util.getIntValue(fu.getParameter("olddocimagesnum"), 0);
	for (int i = 0; i < olddocimagesnum; i++) {
		String tmpid = Util.null2String(fu.getParameter("olddocimages" + i));
		String tmpid1 = "/weaver/weaver.file.FileDownload?fileid=" + tmpid + "\"";
		if (templateContent.indexOf(tmpid1) == -1) {
			String sqltmp = "delete from ImageFile where imagefileid=" + tmpid;
			statement.setStatementSql(sqltmp);
			statement.executeUpdate();
		}
	}

	int docimages_num = Util.getIntValue(fu.getParameter("docimages_num"), 0);
	String[] needuploads = new String[docimages_num];

	for (int i = 0; i < docimages_num; i++) {
		needuploads[i] = "docimages_" + i;
	}
	String[] filenames;
	String[] fileids;
	fileids = fu.uploadFiles(needuploads);
	filenames = fu.getFileNames();

	for (int i = 0; i < docimages_num; i++) {
		int pos = templateContent.indexOf(weaver.docs.docs.DocManager.getImgAltFlag(i));
		if (pos != -1) {
			String tmpcontent = templateContent.substring(0, pos);
			tmpcontent += " alt=\"" + filenames[i] + "\" ";
			pos = templateContent.indexOf("src=\"", pos);
			int endpos = templateContent.indexOf("\"", pos + 6);
			tmpcontent += "src=\"/weaver/weaver.file.FileDownload?fileid=" + Util.getFileidOut(fileids[i]);
			tmpcontent += "\"";
			tmpcontent += templateContent.substring(endpos + 1);
			templateContent = tmpcontent;
		} else {
			String sqltmp = "delete from ImageFile where imagefileid=" + fileids[i];
			statement.setStatementSql(sqltmp);
			statement.executeUpdate();
		}
	}

	sql = "UPDATE MailTemplate SET templateName=?, templateDescription=?, templateSubject=?, templateContent=? WHERE id=?";
	try{
			statement.setStatementSql(sql);
			statement.setString(1, templateName);
			statement.setString(2, templateDescription);
			statement.setString(3, templateSubject);
			statement.setCharacterStream(4, templateContent);
			statement.setInt(5, id);
			statement.executeUpdate();
	}catch(Exception e){
	}finally{
		try{statement.close();}catch(Exception ex){}
	}
	out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
	return;
//===================================================================================================================
//===================================================================================================================
}else if(operation.equals("default")){
	sql = "DELETE FROM MailTemplateUser WHERE userId="+user.getUID()+"";
	rs.executeSql(sql);
	if(Util.getIntValue(request.getParameter("isclear"))!=1 && defaultMailTemplateId!=-1){
		sql = "INSERT INTO MailTemplateUser (userId, templateId, templateType) VALUES ("+user.getUID()+", "+defaultMailTemplateId+", '"+templateType+"')";
		rs.executeSql(sql);
	}

//===================================================================================================================
//===================================================================================================================
}else{
	sql = "DELETE FROM MailTemplate WHERE id="+id+"";
	rs.executeSql(sql);
}

if(showTop.equals("")) {
	response.sendRedirect("MailTemplate.jsp?userid="+userId+"");
} else if(showTop.equals("show800")) {
	response.sendRedirect("MailTemplate.jsp?showTop=show800&userid="+userId+"");
}

%>