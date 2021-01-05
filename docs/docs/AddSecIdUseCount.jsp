
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

	int userid = user.getUID();
	String secid = Util.null2String(request.getParameter("secid"));
	if(secid.equals("")){
		return;
	}
	rs.execute("select COUNT(*) as count from DocCategoryUseCount where secid="+secid+" and userid="+userid);
	if(rs.next()){
		if(rs.getInt("count")>0){
			rs.execute("update DocCategoryUseCount set count=count+1 where secid="+secid+" and userid="+userid);
		}else{
			rs.execute("insert into DocCategoryUseCount (secid,userid,count) values("+secid+","+userid+",1)");
		}
	}
	
%>
