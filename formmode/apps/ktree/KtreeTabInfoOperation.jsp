
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.apps.ktree.KtreeFunction"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	KtreeFunction ktreeFunction = new KtreeFunction();
	String versionid = StringHelper.null2String(request.getParameter("versionId"));
	String functionid = StringHelper.null2String(request.getParameter("functionId"));
	String tabid = StringHelper.null2String(request.getParameter("tabId"));
	String index = StringHelper.null2String(request.getParameter("index"));
	User user = HrmUserVarify.getUser(request,response);
	boolean isnew = ktreeFunction.isnew(versionid,functionid,user.getUID(),tabid);
	out.print(isnew);
%>
