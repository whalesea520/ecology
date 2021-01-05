<%@ page language="java" import="java.util.*,java.text.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE html 
PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null) return;
String id = user.getUID()+"";

%>

<body>
<%
rs.executeSql("select * from sysPhrase where hrmId = '" + id + "'");
String phraseShort = null, phraseId = null, phraseDesc = null;
int count = rs.getCounts();
%>
<% 
if(count<=0){%>
	<span class="noneText"><%=SystemEnv.getHtmlLabelName(130586, user.getLanguage())%></span>
<%}
while(rs.next()){
	phraseShort = rs.getString("phraseShort");
	phraseId = rs.getString("id");
	phraseDesc = rs.getString("phraseDesc");
%>
	<div class="itemBlock" onclick="QuickReplyUtil.doItemClick(this, event)" phraseId="<%=phraseId %>" title="<%=phraseShort %>"><%=phraseShort %></div>
	<input type='hidden' id='<%=phraseId %>' value='<%=phraseDesc %>'/>
<%} %>

</body>
</html>