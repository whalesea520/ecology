<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONObject,weaver.security.classLoader.ReflectMethodCall,java.io.File,weaver.general.*,java.text.*,java.util.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"></jsp:useBean>
<%
	JSONObject json = new JSONObject();
	json.put("result",true);
	try{
		File f = new File(GCONST.getRootPath()+"WEB-INF/securityRule/securityUpdateInfo.xml");
		if(f.exists()){
			 DateFormat df=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			json.put("lastModified",df.format(new Date(f.lastModified())));
		}
	}catch(Exception e){}
	/*String info = (String)rmc.call("weaver.security.file.AESCoder",null,"encrypt",
		            		new Class[]{String.class,String.class},
		            		json.toString(),null);*/
	out.println(json.toString());
%>