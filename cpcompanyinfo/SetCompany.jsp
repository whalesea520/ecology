<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<html>
<head>
</head>
<%
	if(!HrmUserVarify.checkUserRight("License:manager", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
<body>

<TABLE class=viewform width=100% id=oTable1  cellpadding="0px" cellspacing="0px" height="100%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="246px">
<IFRAME name=leftframe id=leftframe src="/cpcompanyinfo/CommanagerTreeLeft2.jsp?urlType=templateList" width="100%" height="100%" frameborder=no scrolling=no >
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px">
<IFRAME name=optFrame id=optFrame src="/cpcompanyinfo/SetCompanyTab.jsp?1=1" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>


</body>
</html>
