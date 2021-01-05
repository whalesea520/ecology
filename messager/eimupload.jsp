
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*,java.text.SimpleDateFormat,java.util.Date" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="deu" class="weaver.messager.UploadUtil" scope="page"/>
<%

	FileUpload fu = new FileUpload(request,"utf-8");
	String clientkey = Util.null2String(fu.getParameter("clientkey"));
	String roomid = Util.null2String(fu.getParameter("roomid"));
	if(!("".equals(clientkey))&&!("".equals(roomid))){
		int userid = -1;
		String sql = "select id from   HrmResource  where lower(loginid) in (select loginid  from ofClientKey where clientKey ='"+ clientkey+"')";
		rs.executeSql(sql);
		while(rs.next()){
			userid = rs.getInt("id");
		}
		UserManager um = new UserManager();
		User user = um.getUserByUserIdAndLoginType(userid,"1");
		int docid=deu.uploadToImagefile(fu,user,"Filedata");
		SimpleDateFormat dateformat1=new SimpleDateFormat("yyyy-MM-dd");
		String datestr=dateformat1.format(new Date());
		if(docid>0){
			sql = "insert into ofmucroomfiles(roomid,imagefileid,loginid,createtime) values ('"+roomid+"','"+docid+"','"+user.getLoginid().toLowerCase()+"','"+datestr+"')";
			rs.executeSql(sql);
		}
	}
	
	//int docid=deu.uploadDocToImg(fu,user, "Filedata",mainId,subId,secId,"","");
	//String uploadType=Util.null2String(fu.getParameter("uploadType"));
	
	//int docid=deu.uploadDocToImg(fu,user, "Filedata",mainId,subId,secId,"","");
	//out.println(docid);
%>

	

