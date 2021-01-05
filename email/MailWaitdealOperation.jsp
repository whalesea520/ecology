
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String method = Util.null2String(request.getParameter("Operation"));
	String mailid = Util.null2String(request.getParameter("mailid"),"0");
	String waitdeal = Util.null2String(request.getParameter("waitdealid"),"0");
	String waitdealway = Util.null2String(request.getParameter("waitdealway"),"0");   // MailReceiveRemind ids
	String waitdealtime = Util.null2String(request.getParameter("waitdealtime"),"");
	String waitdealnote = Util.null2String(request.getParameter("waitdealnote"),"");
	String wdremindtime = Util.null2String(request.getParameter("wdremindtime"),"");
	String mailids = Util.null2String(request.getParameter("mailids"),"");
	String wayWhere = " ";
	String noteWhere = " ";
		wayWhere = ", waitdealway = '"+waitdealway+"', wdremindtime = '"+wdremindtime+"'";
		noteWhere = ", waitdealnote = '"+waitdealnote+"'";
	//邮件待办 添加
	if("add".equals(method)){
		try{
			String sql = "update MailResource set waitdeal = "+waitdeal + wayWhere + noteWhere +", waitdealtime='"+waitdealtime+"' where id in (" + mailids +")";
			rs.execute(sql);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return;
	}
	//邮件待办 修改
	if("update".equals(method)){
		try{
			rs.execute("update MailResource set waitdeal = "+waitdeal + wayWhere + noteWhere + ", waitdealtime = '"+waitdealtime+"' where id = " + mailid);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return;
	}
	
	return;

%>