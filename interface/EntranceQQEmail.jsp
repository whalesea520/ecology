<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="EntranceQQEmail" class="weaver.interfaces.email.EntranceQQEmail" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp"%>
<%

String sysid = Util.null2String(request.getParameter("id"));//系统标识
RecordSet.execute("select  * from hrmresource where id = "+user.getUID());
RecordSet.next();
String email = Util.null2String(RecordSet.getString("email"));
if(!"".equals(email)){
	String url = EntranceQQEmail.getSingleUrl(email,sysid);
	response.sendRedirect(url);
}
%>