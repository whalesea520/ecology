
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp =""; 


String type = Util.null2String(request.getParameter("type"));


%>


<%
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"templateList.jsp";
//alert(contentUrl);
if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 height=100%>

  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 style="width:240px;">
<IFRAME name=leftframe id=leftframe src="MenuMaintenanceTreeLeft.jsp?type=<%=type%>" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(83722, user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width="8px">
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(83722, user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*">
<IFRAME name=contentframe id=contentframe src="MenuMaintenanceList.jsp?type=<%=type%>&resourceType=1&resourceId=1" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(83722, user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>

