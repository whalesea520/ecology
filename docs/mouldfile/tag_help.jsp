
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<p><b><u><font size=4><i>e-</i>Documents</font></u></b> </p>
<table cellspacing=1 cellpadding=1 width="100%" border=0>
  <colgroup> <col width="40%"> <col width="60%"> <tbody> 
  <tr> 
    <th>TAG&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    <th align=left>Description</th>
  </tr>
  <tr> 
    <td valign=top>$DOC_MainCategory</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></td>
  </tr>
  <!--
  <TR>
    <TD valign=top>[BACO_DOC Buttonbar]</TD>
    <TD valign=top>A complete buttonbar. (as in a normal
      view)</TD></TR>
      -->
  <tr> 
    <td valign=top>$DOC_SubCategory</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_SecCategory</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Department</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16227,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Content</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16228,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_CreatedBy</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%>. (short name)</td>
  </tr>
  <tr> 
    <td valign=top>$DOC_CreatedByLink</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16230,user.getLanguage())%>. (full name with link). </td>
  </tr>
  <tr> 
    <td valign=top>$DOC_CreatedByFull</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%>. (full name)</td>
  </tr>
  <tr> 
    <td valign=top>$DOC_CreatedDate</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top width=220>$DOC_DocId</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>ID</td>
  </tr>
  <tr> 
    <td valign=top>$DOC_ModifiedBy</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16231,user.getLanguage())%>. (short name)</td>
  </tr>
  <tr> 
    <td valign=top>$DOC_ModifiedDate</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16232,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Language</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16233,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_ParentId</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16234,user.getLanguage())%>ID</td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Security</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16239,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Status</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16235,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Subject</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16236,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Type</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16240,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_Publish</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16237,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top height="19">$DOC_ViewDate</td>
    <td valign=top height="19"><%=SystemEnv.getHtmlLabelName(16238,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>$DOC_ApproveDate</td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%></td>
  </tr>
  <tr> 
    <td valign=top>&nbsp;</td>
    <td valign=top>&nbsp;</td>
  </tr>
  </tbody> 
</table>
</body>
</html>
