
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*,java.text.SimpleDateFormat,java.util.Date" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="deu" class="weaver.messager.UploadUtil" scope="page"/>
<%
int docid=0;
String filename="";
try{
	FileUpload fu = new FileUpload(request,"utf-8");
	String clientkey = Util.null2String(fu.getParameter("clientkey"));
	if(!("".equals(clientkey))){
		int userid = -1;
		String sql = "select id from   HrmResource  where lower(loginid) in (select loginid  from ofClientKey where clientKey ='"+ clientkey+"')";
		rs.executeSql(sql);
		while(rs.next()){
			userid = rs.getInt("id");
		}
		UserManager um = new UserManager();
		User user = um.getUserByUserIdAndLoginType(userid,"1");
		docid=deu.uploadToImagefile(fu,user,"Filedata");

		SimpleDateFormat dateformat1=new SimpleDateFormat("yyyy-MM-dd");
		String datestr=dateformat1.format(new Date());
		SimpleDateFormat dateformat2=new SimpleDateFormat("HH:ss");
		String timestr=dateformat2.format(new Date());
		if(docid>0){
			sql = "insert into ofdocupload(imageFileId,uploaddate,uploadtime) values ("+docid+",'"+datestr+"','"+timestr+"')";
			rs.executeSql(sql);
		}
	}
	filename= fu.getFileName();
}catch(Exception e ){
	e.printStackTrace();
}
System.out.println(docid);

out.println(docid+":"+filename);
%>

	

