
<%@ page language="java" contentType="charset=UTF-8" %><%@ page import="weaver.hrm.*,weaver.general.*,weaver.conn.*,java.io.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /><%
User user = HrmUserVarify.getUser(request, response);
if(user == null)  return ;
String mailId = Util.null2String(request.getParameter("mailId"));
String subject = Util.null2String(request.getParameter("subject"));
String emlName = "";
String _emlPath = "";

rs.executeSql("SELECT subject,emlName,emlpath FROM mailresource WHERE id="+mailId+"");
if(rs.next()){
	//subject = rs.getString("subject");
	emlName = rs.getString("emlName");
	_emlPath = Util.null2String(rs.getString("emlPath"));
}

subject = Util.replace(subject, ":|\\?|\\*|\\||/|\\\\|\"|<|>", "", 0);
String emlPath = GCONST.getRootPath() + "email" + File.separatorChar + "eml" + File.separatorChar;

response.setContentType("application/vnd.ms-outlook;charset=UTF-8");
response.setHeader("Content-disposition","attachment;filename="+subject+".eml");


java.lang.String strFileName; //文件名 
java.io.File objFile; //文件对象 
java.io.FileReader objFileReader; //读文件对象 
char[] chrBuffer = new char[10]; //缓冲 
int intLength; //实际读出的字符数(一个中文为一个字符) 

//设置待读文件名 
strFileName = emlPath+emlName+".eml"; 
if(!_emlPath.equals("")) strFileName = _emlPath;

//创建文件对象 
objFile = new java.io.File(strFileName); 

//判断文件是否存在 
if(objFile.exists()){//文件存在 
	//创建读文件对象 
	objFileReader = new java.io.FileReader(objFile); 

	//读文件内容 
	while((intLength=objFileReader.read(chrBuffer))!=-1){ 
		//输出 
		out.write(chrBuffer,0,intLength); 
	} 

	//关闭读文件对象 
	objFileReader.close(); 
}
%>