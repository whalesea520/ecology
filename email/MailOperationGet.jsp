
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />

<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%


int mailAccountId = Util.getIntValue(request.getParameter("mailAccountId"));
String info = WeavermailUtil.receiveMail(mailAccountId,user,request);
out.println(info);
%>
