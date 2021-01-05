<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String categoryname = Util.null2String(request.getParameter("categoryname"));
	String foldertype = Util.null2String(request.getParameter("foldertype"));
	String result = "";
	if(foldertype.equals("publicAll"))
	{
	    result = multiAclManager.getPermittedTree(user,categoryname);
	}
	else if(foldertype.equals("privateAll"))
	{
	    result = multiAclManager.getPermittedTreeForPrivate(user,categoryname);
	}
	out.println(result);
%>
