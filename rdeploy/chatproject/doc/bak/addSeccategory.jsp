<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String categoryname = Util.null2String(request.getParameter("categoryname"));
	String foldertype = Util.null2String(request.getParameter("foldertype"));
	String parentid = Util.null2String(request.getParameter("parentid"));
	String result = "";
	if(foldertype.equals("publicAll"))
	{
	     result = multiAclManager.createSeccategory(user,categoryname,parentid,0);
	}
	else if(foldertype.equals("privateAll"))
	{
	    result = multiAclManager.createSeccategory(user,categoryname,parentid,1);
	}
	out.println(result);
%>
