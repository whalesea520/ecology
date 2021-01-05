<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	int mailid = Util.getIntValue(request.getParameter("mailid"),0);
	String menuid=Util.null2String(request.getParameter("menuid"));
	String sql = "select * from mailresource where (id="+mailid
			+" and (originalMailId is null or originalMailId = '')"
			+" and (isInternal is null or isInternal=''))"
			+" or (originalMailId="+mailid+" and resourceid="+user.getUID()+")";
	//System.out.println("转换邮件IDSQL： \n"+sql);
	rs.executeSql(sql);
	if(rs.next()){
		mailid = rs.getInt("id");
	}
%>
<script>
	window.location.href="/mobile/plugin/email/EmailView.jsp?mailid=<%=mailid%>&menuid=<%=menuid%>";
</script>