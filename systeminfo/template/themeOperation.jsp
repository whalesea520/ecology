
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page import="org.apache.commons.fileupload.*" %>

<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String method = Util.null2String(request.getParameter("method"));
	String id = Util.null2String(request.getParameter("id"));
	String leftcolor = Util.null2String(request.getParameter("leftcolor"));
	String topcolor = Util.null2String(request.getParameter("topcolor"));
	String hrmcolor = Util.null2String(request.getParameter("hrmcolor"));
	String logocolor = Util.null2String(request.getParameter("logocolor"));

	if(method.equals("save")){
		String updateSql = "update ecology8theme set logocolor='"+logocolor+"', hrmcolor='"+hrmcolor+"', leftcolor='"+leftcolor+"', topcolor='"+topcolor+"',lastdate='"+TimeUtil.getCurrentDateString()+"',lasttime='"+TimeUtil.getOnlyCurrentTimeString()+"' where id="+id;
		rs.execute(updateSql);
	}else if(method.equals("saveas")){
		String name = Util.null2String(request.getParameter("name"));
		String updateSql = "insert into ecology8theme (name,type,cssfile,logocolor,hrmcolor,leftcolor,topcolor,lastdate,lasttime,style)	 select '"+name+"','cus',cssfile, '"+logocolor+"','"+hrmcolor+"','"+leftcolor+"','"+topcolor+"','"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"',style from ecology8theme  where id="+id;
		//System.out.print(updateSql);
		rs.execute(updateSql);
	}else if(method.equals("commit")){
		
	}else if(method.equals("del")){
		String updateSql = "delete from ecology8theme where id="+id;
		rs.execute(updateSql);
	}
%>


