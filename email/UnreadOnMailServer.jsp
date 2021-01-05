
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*, javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>
<%@ page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.email.*" %>
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
int mailAccountId = Util.getIntValue(request.getParameter("mailAccountId"));
int receivedMailNumber=0;

WeavermailUtil weavermailUtil=new WeavermailUtil();
Map result=weavermailUtil.receiveMailNumber(mailAccountId,user.getUID()+""); 
int flag=(Integer)result.get("flag");
receivedMailNumber=(Integer)result.get("number");

/*	
int tempcount = 0;
String sql = "select count(*) from mailresource where folderid = '0' and status=0 and canview=1 and mailAccountId = " + mailAccountId;
rs2.executeSql(sql);
rs2.next();
tempcount = rs2.getInt(1);
if(tempcount < 0 ) tempcount = 0;	
*/
out.print(receivedMailNumber);
	
%>
