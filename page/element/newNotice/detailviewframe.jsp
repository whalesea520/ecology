<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.PageIdConst"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>

<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page"/>
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";



int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));
int id = Util.getIntValue(Util.null2String(request.getParameter("id")), -1);
String noticeconent= "";

RecordSet rs = new RecordSet();
if (id > 0) {
	rs.executeSql("select * from hpElement_notice where id=" + id);
    if (rs.next()) {
	    noticeconent = Util.null2String(rs.getString("content"));
    }
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
	
	<style type="text/css">
		* {
			font-size:12px;
		}
	</style>
	
	
  </head>
  <body style="margin:0px;">
 
	<div style="margin:0px 10px;">
	<%=noticeconent %>
	</div>
	
  </body>
</html>
