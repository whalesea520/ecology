
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String imagefilename = "/images/home_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
boolean HomepagehasRight = HrmUserVarify.checkUserRight("homepage:Maint", user);	//首页维护权限 
/*
if(!HomepagehasRight){
    response.sendRedirect("/notice/noright.jsp");
    return;
}*/
String dir = Util.null2String(request.getParameter("dir"));
String isDialog = Util.null2String(request.getParameter("isDialog"));
String isSingle = Util.null2String(request.getParameter("isSingle"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
	var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"HompepageRight.jsp";
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
		<tr><td  height=100% id="oTd1" name="oTd1" width="250px" style="padding-left: 0px;"> 
		<IFRAME name=leftframe id=leftframe src="CustomResourceLeft.jsp?isSingle=<%=isSingle %>&dir=<%=dir %>&isDialog=<%=isDialog %>" width="100%" height="100%" frameborder=no scrolling=no>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage()) %></IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent" style="padding-left: 0px;">
		<IFRAME name=contentlistframe id=name=contentlistframe src="CustomResourceTabs.jsp?isSingle=<%=isSingle %>&dir=<%=dir %>&isDialog=<%=isDialog %>" width="100%" height="100%" frameborder=no scrolling=auto>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage()) %></IFRAME>
		</td>
		</tr>
  </TBODY>
</TABLE>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</body>
</html>