
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16218,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body scroll="yes" bgcolor="#FFFFFF" text="#000000">
<p><b><u><font size=4><i>e-</i>CRM</font></u></b> </p>
<table cellspacing=1 cellpadding=1 width="100%" border=0>
  <colgroup> <col width="40%"> <col width="60%"> <tbody> 
  <tr> 
    <th>TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    <th align=left>Description</th>
  </tr>
  <%
  String sql = "select * from CRM_CustomizeOption";
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
  String tagfix = "Cust_";
  if(RecordSet.getString("tabledesc").equals("2"))
  	tagfix = "Cont_";
  String tagbody = RecordSet.getString("fieldname");	
  String tagname = RecordSet.getString("labelname");  
  %>
  <tr> 
    <td valign=top>$<%=tagfix%><%=tagbody%></td>
    <td valign=top><%=tagname%></td>
  </tr>
  <%}%>
  </tbody>
  </table>
    <br>
  <table>
  <td><font color=red><b><%=SystemEnv.getHtmlLabelName(15168,user.getLanguage())%>:</b></font><%=SystemEnv.getHtmlLabelName(16219,user.getLanguage())%></td> 
  </tr>
</table>
<p><b><u><font size=4><i>e-</i>HRM</font></u></b> </p>
<table cellspacing=1 cellpadding=1 width="100%" border=0>
  <colgroup> <col width="40%"> <col width="60%"> <tbody> 
  <tr> 
    <th>TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    <th align=left>Description</th>
  </tr>
  <tr> 
    <td valign=top>$HRM_Loginid</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Name</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Title</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Birthday</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(1964,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Telephone</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Email</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16220,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Startdate</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16221,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Enddate</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16222,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Contractdate</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Jobtitle</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Jobgroup</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16223,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Jobactivity</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(382,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Jobactivitydesc</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Joblevel</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Seclevel</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Department</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Costcenter</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16224,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$HRM_Manager</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$$HRM_Assistant</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></td>
  </tr>
  </tbody> 
</table>
</frame>
</body>
</html>
