
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16218,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
<p><b><u><font size=4><i>e-</i>HRM</font></u></b> </p>
<table cellspacing=1 cellpadding=1 width="100%" border=0>
  <colgroup> <col width="40%"> <col width="60%"> <tbody> 
  <tr> 
    <th>TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    <th align=left>Description</th>
  </tr>
  <tr> 
    <td valign=top>[$hrm_name]</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>[$hrm_department]</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>[$hrm_subcompany]</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>[$hrm_post]</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>[$hrm_tel]</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>[$hrm_mobile]</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>[$hrm_mail]</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></td>
  </tr>
  </tbody> 
</table>
</body>
</html>
