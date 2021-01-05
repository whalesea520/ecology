
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
	if(!HrmUserVarify.checkUserRight("Synergy:Maint", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	String stype = Util.null2String(request.getParameter("stype"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	jQuery(document).ready(function(){
		if(jQuery.browser.msie){
			//jQuery()
		}
	});
</script>
<!-[if !IE]>
<style type="text/css" >
	.leftframe{margin-top:4px;}
	.contentframe{margin-top:4px;}
</style>
<!-<![endif]->
</HEAD>
<body scroll="no" style="overflow-y:hidden">
<TABLE class=viewform width=100% id=oTable1 height=100% style="border-collapse: collapse; ">
  <TBODY>
		<tr><td  id="oTd1" name="oTd1" width="220px" style="background-color:#F8F8F8;padding-left:0px;height:100%"> 
		<IFRAME name=leftframe id=leftframe class="leftframe" src="/synergy/maintenance/SynergyMenuLeft.jsp?stype=<%=stype %>" width="100%" height="100%" frameborder=no scrolling=no>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage()) %></IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent" style="padding-left:0px;">
		<IFRAME name=contentframe id=contentframe class="contentframe" src="/synergy/maintenance/SynergyDesign.jsp?stype=<%=stype %>" width="100%" height="100%" frameborder=no>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage()) %></IFRAME>
		</td>
		</tr>
  </TBODY>
</TABLE>
</body>
</html>