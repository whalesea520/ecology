<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="DesUtil" class="weaver.general.DesUtil" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	//User user = HrmUserVarify.getUser (request , response) ;
	//if(user == null)  return ;

	FileUpload fu = new FileUpload(request,"utf-8");
	int mainId=Util.getIntValue(fu.getParameter("mainId"),0);
	int subId=Util.getIntValue(fu.getParameter("subId"),0);
	int secId=Util.getIntValue(fu.getParameter("secId"),0);
	
	int userid=Util.getIntValue(DesUtil.decrypt(fu.getParameter("userid")),0);
	int language=Util.getIntValue(fu.getParameter("language"),0);
	int logintype=Util.getIntValue(fu.getParameter("logintype"),0);
	int departmentid=Util.getIntValue(fu.getParameter("departmentid"),0);
	User user=new User();
	user.setUid(userid);
	user.setLanguage(language);
	user.setLogintype(""+logintype);
	user.setUserDepartment(departmentid);

	if(secId!=0){	
		int docid=deu.uploadDocToImg(fu,user, "Filedata",mainId,subId,secId,"","");
		out.println(docid);
		//System.out.println("docid:"+docid);
	} 
%>





