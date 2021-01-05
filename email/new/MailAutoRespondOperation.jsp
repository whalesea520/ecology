
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.file.*,weaver.conn.*" %>
<%@page import="oracle.sql.CLOB"%>
<%@page import="java.io.Writer"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<%
FileUpload fu = new FileUpload(request, false);
String content = Util.null2String(fu.getParameter("content"));
int isAuto = Util.getIntValue(fu.getParameter("isAuto"),0);
String operation = Util.null2String(fu.getParameter("operation"));
int isContactReply = Util.getIntValue(fu.getParameter("isContactReply"),0);
String status = "true";

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
		int pos = content.indexOf(weaver.docs.docs.DocManager.getImgAltFlag(i));
		if (pos != -1) {
			String tmpcontent = content.substring(0, pos);
			tmpcontent += " alt=\"" + filenames[i] + "\" ";
			pos = content.indexOf("src=\"", pos);
			int endpos = content.indexOf("\"", pos + 6);
			tmpcontent += "src=\"/weaver/weaver.file.FileDownload?fileid=" + Util.getFileidOut(fileids[i]);
			tmpcontent += "\"";
			tmpcontent += content.substring(endpos + 1);
			content = tmpcontent;
		} else {
			String sqltmp = "delete from ImageFile where imagefileid=" + fileids[i];
			statement.setStatementSql(sqltmp);
			statement.executeUpdate();
		}
	}


	String sql = "INSERT INTO MailAutoRespond (userId, isAuto,isContactReply, content) VALUES (?,?,?,?)";
	try{
		if("oracle".equals(rs.getDBType())){
			sql = "INSERT INTO MailAutoRespond (userId, isAuto,isContactReply, content) VALUES (?,?,?,empty_clob())";
			statement.setStatementSql(sql);
			statement.setInt(1, user.getUID());
			statement.setString(2, isAuto+"");
			statement.setInt(3, isContactReply);
			statement.executeUpdate();

			sql = "select content from MailAutoRespond where rownum = 1 and userid = " + user.getUID() + " order by id desc for update";
			statement.setStatementSql(sql, false);
			statement.executeQuery();
			statement.next();
			CLOB theclob = statement.getClob(1);
			String doccontenttemp = content;
			char[] contentchar = doccontenttemp.toCharArray();
			Writer contentwrite = theclob.getCharacterOutputStream();
			contentwrite.write(contentchar);
			contentwrite.flush();
			contentwrite.close();
			statement.close();
		}else{
			statement.setStatementSql(sql);
			statement.setInt(1, user.getUID());
			statement.setString(2, isAuto+"");
			statement.setInt(3, isContactReply);
			statement.setString(4, content);
			
			statement.executeUpdate();
		}
	}catch(Exception e){
		BaseBean.writeLog(e);
		status = "false";
	}finally{
		try{statement.close();}catch(Exception ex){}
	}
}



if(operation.equals("update")){
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
		int pos = content.indexOf(weaver.docs.docs.DocManager.getImgAltFlag(i));
		if (pos != -1) {
			String tmpcontent = content.substring(0, pos);
			tmpcontent += " alt=\"" + filenames[i] + "\" ";
			pos = content.indexOf("src=\"", pos);
			int endpos = content.indexOf("\"", pos + 6);
			tmpcontent += "src=\"/weaver/weaver.file.FileDownload?fileid=" + Util.getFileidOut(fileids[i]);
			tmpcontent += "\"";
			tmpcontent += content.substring(endpos + 1);
			content = tmpcontent;
		} else {
			String sqltmp = "delete from ImageFile where imagefileid=" + fileids[i];
			statement.setStatementSql(sqltmp);
			statement.executeUpdate();
		}
	}

	String sql = "UPDATE MailAutoRespond SET isAuto=?, isContactReply=?, content=? WHERE userId=?";
	try{
		if("oracle".equals(rs.getDBType())){
			sql = "UPDATE MailAutoRespond SET isAuto=?, isContactReply=? , content = empty_clob()  WHERE userId=?";
			statement.setStatementSql(sql);
			statement.setString(1, isAuto+"");
			statement.setInt(2, isContactReply);
			statement.setInt(3, user.getUID());
			statement.executeUpdate();

			sql = "select content from MailAutoRespond where userId = " + user.getUID() + " for update";
			statement.setStatementSql(sql, false);
			statement.executeQuery();
			statement.next();
			CLOB theclob = statement.getClob(1);
			String doccontenttemp = content;
			char[] contentchar = doccontenttemp.toCharArray();
			Writer contentwrite = theclob.getCharacterOutputStream();
			contentwrite.write(contentchar);
			contentwrite.flush();
			contentwrite.close();
		}else{
			statement.setStatementSql(sql);
			statement.setString(1, isAuto+"");
			statement.setInt(2, isContactReply);
			statement.setString(3, content);
			statement.setInt(4, user.getUID());
			statement.executeUpdate();
		}
	}catch(Exception e){
		BaseBean.writeLog(e);
		status = "false";
	}finally{
		try{statement.close();}catch(Exception ex){}
	}

}

response.sendRedirect("MailAutoRespond.jsp?status="+status);
%>