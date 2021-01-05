<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));//返回类型
String backto = Util.null2String(request.getParameter("backto"));//返回类型
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String sysid = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String sql = "";
out.clear();
if(operation.equals("checkinput")){
	String field = Util.fromScreen(request.getParameter("field"),user.getLanguage());
	String values = Util.fromScreen(request.getParameter("values"),user.getLanguage());
	if("".equals(sysid)){
		sql = "select 1 from ofs_sysinfo where "+field+" = '"+values+"'";
	}else{
		sql = "select 1 from ofs_sysinfo where "+field+" = '"+values+"' and sysid !='"+sysid+"'";
	}
	rs.execute(sql);
	if(rs.next()){
		if("syscode".equals(field)){
			out.println(SystemEnv.getHtmlLabelName(127233,user.getLanguage()));
		}
		if("sysshortname".equals(field)){
			out.println(SystemEnv.getHtmlLabelName(127234,user.getLanguage()));
		}
		if("sysfullname".equals(field)){
			out.println(SystemEnv.getHtmlLabelName(127235,user.getLanguage()));
		}
	}
}else if(operation.equals("checkinputwf")){
    String field = Util.fromScreen(request.getParameter("field"),user.getLanguage());
	String values = Util.fromScreen(request.getParameter("values"),user.getLanguage());
	String systemid = Util.null2String(request.getParameter("systemid"));
	sql = "select 1 from ofs_workflow where "+field+" = '"+values+"'";
	if(!"".equals(sysid))
	    sql += " and workflowid != '"+sysid+"'";
	if(!"".equals(systemid))
	    sql += " and sysid = "+systemid;
	rs.execute(sql);
	if(rs.next()){
	    if("workflowname".equals(field))
			out.println(SystemEnv.getHtmlLabelNames("16579,81869",user.getLanguage()));
	}
}
%>