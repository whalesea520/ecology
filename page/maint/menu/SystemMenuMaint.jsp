
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />

<%
String imagefilename = "/images/home_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  

if(!HeadMenuhasRight && !SubMenuRight){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=0;
boolean isUsePortalManageDetach = ManageDetachComInfo.isUsePortalManageDetach();
if(isUsePortalManageDetach){
	session.setAttribute("portaldetachable","1");
}else{
	session.setAttribute("portaldetachable","0");
}

String type = Util.null2String(request.getParameter("type"));// top left
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
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
		<tr><td  height=100% id="oTd1" name="oTd1" width="250px" style="background-color:#F8F8F8;padding-left:0px;"> 
		<IFRAME name=leftframe id=leftframe src="SystemMenuLeft.jsp?rightStr=SubMenu:Maint&type=<%=type %>" width="100%" height="100%" frameborder=no scrolling=no>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage()) %></IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent" style="padding-left:0px;">
		<IFRAME name=contentframe id=contentframe src="/homepage/maint/HomepageTabs.jsp?_fromURL=hpMenu&type=<%=type %>&resourceType=1&resourceId=1&subCompanyId=<%=subCompanyId%>" width="100%" height="100%" frameborder=no scrolling=no>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage()) %></IFRAME>
		</td>
		</tr>
  </TBODY>
</TABLE>
</body>
</html>
