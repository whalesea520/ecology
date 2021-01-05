
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*, javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.email.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.system.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.file.multipart.*" %>

<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
int folderId = Util.getIntValue(request.getParameter("folderId"));
int id = Util.getIntValue(request.getParameter("id"));
int mailId = id;
String emlName = "";
String _emlpath = "";
if(id>0){
	HashMap displayname = new HashMap();
	String sql = "select * from MailUserAddress where userid = '"+user.getUID()+"'";
	rs.executeSql(sql);
	while(rs.next()){
		displayname.put(rs.getString("mailaddress"),rs.getString("mailusername"));
	}

	rs.executeSql("SELECT emlName,emlpath FROM mailresource WHERE id="+id+"");
	if(rs.next()){
		emlName = rs.getString("emlName");
		_emlpath= rs.getString("emlpath");
	}

	Properties props = System.getProperties();
	props.put("mail.host", "smtp.dummydomain.com");
	props.put("mail.transport.protocol", "smtp");
	Session mailSession = Session.getDefaultInstance(props, null);

	String emlPath = GCONST.getRootPath() + "email" + File.separatorChar + "eml" + File.separatorChar;
	String emlrealPath = emlPath + emlName + ".eml";
	File eml = new File(_emlpath);
	if(!eml.exists()){
		eml = new File(emlrealPath);
	}
	if(eml.exists()){
		InputStream is = new FileInputStream(eml);
		MimeMessage m = new MimeMessage(mailSession, is);
	
		Weavermail w = new Weavermail();
		w.setDisplayname(displayname);
		w.setUserid(user.getUID()+"");
		WeavermailComInfo wmc = w.parseMail(m, true);
	
		w.parseEML(m, wmc, user, id);
	}else{
		new weaver.general.BaseBean().writeLog("eml文件不存在，邮件id="+id);	
	}
}

response.sendRedirect("MailView.jsp?id="+id+"&folderId="+folderId+"");
%>
