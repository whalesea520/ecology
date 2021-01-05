
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfUserRef" class="weaver.workflow.workflow.WfUserRef" scope="page" />
<%
	String src = Util.null2String(request.getParameter("src"));
	if("save".equals(src)){
		int keyid=Util.getIntValue(Util.null2String(request.getParameter("keyid")),0);
		String name=Util.null2String(request.getParameter("name"));
		int usertype=Util.getIntValue(Util.null2String(request.getParameter("usertype")),0);
		String ids="";
		if(usertype==2){
			ids=Util.null2String(request.getParameter("subcompanyids"));
		}else if(usertype==3){
			ids=Util.null2String(request.getParameter("departmentids"));
			if(ids.startsWith(","))		ids=ids.substring(1);
		}else if(usertype==4){
			ids=Util.null2String(request.getParameter("userids"));
		}
		WfUserRef.saveUserRef(keyid,name,usertype,ids);
		response.sendRedirect("UserEdit.jsp?isclose=1");
	}else if("del".equals(src)){
		int keyid=Util.getIntValue(Util.null2String(request.getParameter("keyid")),0);
		WfUserRef.delUserRef(keyid);
	}
%>
