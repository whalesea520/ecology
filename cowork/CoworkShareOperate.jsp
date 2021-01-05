
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page"/>
<%
	String method=Util.null2String(request.getParameter("method"));
	int coworkid=Util.getIntValue(request.getParameter("coworkid"),0);
	
	String type=Util.null2String(request.getParameter("type"));
	String content=Util.null2String(request.getParameter("content"));
	String seclevel=Util.null2String(request.getParameter("seclevel"));
	if("add".equals(method)){
		String strSql="insert into coworkshare (sourceid,type,content,seclevel,sharelevel,srcfrom) values ("+coworkid+","+type+",'"+content+"',"+seclevel+",1,1)";
		rs.executeSql(strSql);
		strSql="select max(id) as shareid from coworkshare where sourceid="+coworkid;
		rs.executeSql(strSql);
		if(rs.next()){
			out.println(Util.null2String(rs.getString("shareid")));
		}
		csm.deleteCache("parter",""+coworkid);
	}else if("delete".equals(method)){
		int shareid=Util.getIntValue(request.getParameter("shareid"),0);
		String strSql="delete coworkshare where id="+shareid;
		rs.executeSql(strSql);
		csm.deleteCache("parter",""+coworkid);
	}
	
%>