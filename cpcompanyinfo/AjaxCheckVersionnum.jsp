<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.cpcompanyinfo.ProManageUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
		String oneMoudel = Util.null2String(request.getParameter("oneMoudel"));
		String objvalue =ProManageUtil.fetchString(Util.null2String(request.getParameter("objvalue")));
		String licenseid=Util.null2String(request.getParameter("licenseid"));//证照的id
		String companyid =  Util.null2String(request.getParameter("companyid"));
		if(ProManageUtil.checkEdition(oneMoudel, licenseid, companyid, objvalue)){
				out.clear();
				out.println("1");
		}else{
				out.clear();
				out.println("0");
		}
		
%>
