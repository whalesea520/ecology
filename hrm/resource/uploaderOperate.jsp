
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%!
private void hrmResourceSave(weaver.conn.RecordSet rs, String resourceId, String scopeId, String fieldId, int docid, int userId)
{
	String imgfileid = "";
	String imgfilename = "";
	java.text.DateFormat fd = new java.text.SimpleDateFormat("yyyy-MM-dd");
	java.text.DateFormat fh = new java.text.SimpleDateFormat("hh:mm:ss");
	
	java.sql.Timestamp timestamp = new java.sql.Timestamp(System.currentTimeMillis());
	String CurrentDate = fd.format(timestamp);
	String CurrentTime = fh.format(timestamp);
	
	rs.executeSql("select imagefileid,imagefilename from imagefile where imagefileid="+docid);
	if(rs.next()){
		imgfileid = Util.null2String(rs.getString(1));
		imgfilename = Util.null2String(rs.getString(2));
	}
	
	if(imgfileid.length()>0){
		String sql = "insert into HrmResourceFile(resourceid,scopeId,fieldid,docid,docname,doccreater,createdate,createtime)"
							 + " values('"+resourceId+"','"+scopeId+"','"+fieldId+"','"+imgfileid+"','"+imgfilename+"','"+userId+"','"+CurrentDate+"','"+CurrentTime+"')"; 
		rs.executeSql(sql);
	}
}
%>
<%
  DesUtil desUtil=new DesUtil();
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//增加登录验证
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null)return;
	
	FileUpload fu = new FileUpload(request,"utf-8");
  
	String cmd=fu.getParameter("cmd");
	if(cmd.equals("delete")){
		String fileId=Util.null2String(fu.getParameter("fileId"));
		if(fileId.length()>0){
			rs.executeSql("select imagefileid,imagefilename from imagefile where imagefileid="+fileId);
			rs.executeSql("delete from HrmResourceFile where docid="+fileId);
		}
	}
	else if(cmd.equals("save")){
		int userid=Util.getIntValue(desUtil.decrypt(fu.getParameter("userid")),0);
		int language=Util.getIntValue(fu.getParameter("language"),0);
		int logintype=Util.getIntValue(fu.getParameter("logintype"),0);
		int departmentid=Util.getIntValue(fu.getParameter("departmentid"),0);
		
		String resourceId=Util.null2String(fu.getParameter("resourceId"));
		String fieldId=Util.null2String(fu.getParameter("fieldId"));
		String scopeId=Util.null2String(fu.getParameter("scopeId"));
		
		user=new User();
		user.setUid(userid);
		user.setLanguage(language);
		user.setLogintype(""+logintype);
		user.setUserDepartment(departmentid);
		
		int docid = Util.getIntValue(fu.uploadFiles("Filedata"), 0);
		hrmResourceSave(rs,  resourceId, scopeId, fieldId, docid, user.getUID());
		out.print(docid);
	}
%>
