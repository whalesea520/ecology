<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;
%>

<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16641,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2212">
<base target="mainFrame">
<link rel="stylesheet" href="/css/frame_wev8.css" type="text/css">
</head>
<body style="background:#333;overflow:hidden">
<script type="text/javascript">
	parent.mainFrame.location.href="/docs/news/NewsDsp.jsp";
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" >
  <tr> 
    <td width="100%" style="background-color:#333" valign="top"><BR> 
	<BR> 
	<div style="font-size: 14px;color: rgb(161, 158, 158);padding-left:10px;height:40px;line-height: 40px;">
		<div style="line-height: 30px;height:30px;padding-top:5px;">首页</div>
	</div>
      <table width="100%" height="40" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr > 
          <td width="40" height="40" class='icon_right' style="line-height:40px;"><img alt="公司新闻" style="padding-top:12px;" src="/wui/theme/ecology8/page/images/menuicon/bright/118_wev8.png"></td><!-- <i class="iconfont">&#xe60b;</i> -->
          <td width="80" align="center"><a href="/docs/news/NewsDsp.jsp" class="zlm" target="mainFrame"><%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%></a></td>
          <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
