
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="weaver.docs.docs.ShareManageDocOperation" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>

<%

String defaultshare =  Util.null2String(request.getParameter("defaultshare"));
String nondefaultshare =  Util.null2String(request.getParameter("nondefaultshare"));
String sharingsessionkey = "sqlsharing_" + user.getLoginid() ;	
String sharingsessionkey2 = "2sqlsharing_" + user.getLoginid() ;	
String sqlwhere=Util.null2String((String)session.getAttribute(sharingsessionkey));
if(sqlwhere.equals("")){
   sqlwhere=Util.null2String((String)session.getAttribute(sharingsessionkey2));
}
//session.removeAttribute(sharingsessionkey);

	ShareManageDocOperation manager = new ShareManageDocOperation();
	manager.setRequest(request);
	manager.setSqlwhere(sqlwhere);
	//session.removeAttribute(sharingsessionkey);
	manager.setUserid(user.getUID());
	manager.setUser(user);
	manager.setDefaultshare(defaultshare);
	manager.setNondefaultshare(nondefaultshare);
	manager.runSharing();
	Thread.sleep(1000);
	//response.sendRedirect("/docs/search/DocSearchSharing.jsp?from=shareManageDoc");




%>
 
