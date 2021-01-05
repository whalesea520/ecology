
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="weaver.general.*,weaver.system.*,weaver.hrm.resource.*,weaver.hrm.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String sessionId = request.getParameter("sid");
	weaver.messager.SessionContext myc= weaver.messager.SessionContext.getInstance();
	HttpSession sess = myc.getSession(sessionId);
	if(sess!=null){
		session = sess;
	}
	User user = (User)session.getAttribute("weaver_user@bean");
	if(user==null){
		out.print("null");
		return;
	}
	String loginid = user.getLoginid();
	String uploadPath = GCONST.getRootPath() + "messager"
			+ File.separatorChar + "usericon";
	//自动创建目录：
	if (!new File(uploadPath).isDirectory())
		new File(uploadPath).mkdirs();
		
	String iconName="loginid"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+".jpg";
	String targetUrl = uploadPath+ File.separatorChar +iconName;
	
	InputStream inputStream = request.getInputStream();
	FileOutputStream outputStream = new FileOutputStream(new File(targetUrl));
    int BUFFER_SIZE = 1024; 
    byte[] buf = new byte[BUFFER_SIZE];    
    int size = 0;  
	while ( (size = inputStream.read(buf)) != -1)     
    outputStream.write(buf, 0, size);   
    outputStream.close();    
    inputStream.close(); 
    //保存进数据库
	String strSql="update hrmresource set messagerurl='/messager/usericon/"+iconName+"' where loginid='"+loginid+"'";		
	rs.executeSql(strSql);   
	ResourceComInfo rci = new ResourceComInfo();
	rci.updateResourceInfoCache(user.getUID()+"");
%>

	

