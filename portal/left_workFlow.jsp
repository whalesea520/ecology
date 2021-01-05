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
	parent.mainFrame.location.href="/workflow/request/RequestView.jsp";
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" >
  <tr> 
    <td width="100%" style="background-color:#333" valign="top"><BR> 
	<BR>
	<div style="font-size: 14px;color: rgb(161, 158, 158);padding-left:10px;height:40px;line-height: 40px;">
		<div style="line-height: 30px;height:30px;padding-top:5px;">流程</div>
	</div>
		<!-- 待办 -->
      <table width="100%" height="40" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="40" height="40" style="line-height:40px;" class='icon_right'><img alt="待办事宜" style="padding-top:12px;" src="/wui/theme/ecology8/page/images/menuicon/bright/13_wev8.png"></td><!-- <i class="iconfont">&#xe60b;</i> -->
          <td width="80" align="center"><a href="/workflow/request/RequestView.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></a></td>
          
          <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
        </tr>
      </table>
      <!-- 新建 -->
      <table width="100%" height="40" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="40" height="40" style="line-height:40px;" class='icon_right'><img alt="新建流程" style="padding-top:12px;" src="/wui/theme/ecology8/page/images/menuicon/bright/12_wev8.png"></td><!-- <i class="iconfont">&#xe60b;</i> -->
          <td width="80" align="center"><a href="/workflow/request/RequestType.jsp?needPopupNewPage=true" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%></a></td>
          
          <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
        </tr>
      </table>
      <!-- 已办 -->
      <table width="100%" height="40" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="40" height="40" style="line-height:40px;" class='icon_right'><img alt="已办事宜" style="padding-top:12px;" src="/wui/theme/ecology8/page/images/menuicon/bright/90_wev8.png"></td><!-- <i class="iconfont">&#xe60b;</i> -->
          <td width="80" align="center"><a href="/workflow/request/RequestHandled.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(17991,user.getLanguage())%></a></td>
          
          <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
        </tr>
      </table>
		<!-- 我的请求 -->
      <table width="100%" height="40" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="40" height="40" style="line-height:40px;" class='icon_right'><img alt="我的请求" style="padding-top:12px;" src="/wui/theme/ecology8/page/images/menuicon/bright/14_wev8.png"></td>
          <!--<img alt="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>" src="/images_frame/icon_request1_wev8.gif" border="0"> -->
          <td width="80" align="center"><a href="/workflow/request/MyRequestView.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(1210,user.getLanguage())%></a></td>
          
          <td ><a href="/workflow/search/WFSearch.jsp"  target="mainFrame" title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>"></a></td>
          <!-- <img alt="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>" src="/images_frame/search_dot1_wev8.gif" border="0"> -->
        </tr>
      </table>
      <!-- 查询 -->
      <table width="100%" height="40" border="0" cellspacing="0" cellpadding="0" class="onmouseout" onmouseover="this.className='onmouseover'"  onmouseout="this.className='onmouseout'">
        <tr> 
          <td width="40" height="40" style="line-height:40px;" class='icon_right'><img alt="查询流程" style="padding-top:12px;" src="/wui/theme/ecology8/page/images/menuicon/bright/15_wev8.png"></td><!-- <i class="iconfont">&#xe60b;</i> -->
          <td width="80" align="center"><a href="/workflow/search/WFSearch.jsp" class="zlm"  target="mainFrame"><%=SystemEnv.getHtmlLabelName(16393,user.getLanguage())%></a></td>
          
          <td ><img src="/images_frame/blank_wev8.gif" width=14></td>
        </tr>
      </table>
    </td>

  </tr>
 
</table>
</body>
</html>
