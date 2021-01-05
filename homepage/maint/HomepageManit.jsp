
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />

<%
String imagefilename = "/images/home_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
	if( pu.getUserMaintHpidListPublic(user.getUID()).size()>0){
		response.sendRedirect("/homepage/maint/HomepageTabs.jsp?subCompanyId=0&_fromURL=hpManit&loginview=0");
		 return;
	}else{
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
}

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
//rs.executeSql("select detachable from SystemSet");
boolean isUsePortalManageDetach = ManageDetachComInfo.isUsePortalManageDetach();
if(isUsePortalManageDetach){
	 session.setAttribute("portaldetachable","1");
}else{
	 session.setAttribute("portaldetachable","0");
}


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
<body scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  <TBODY>
  		
		<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style="padding:0px;padding-left: 0px;">
		<IFRAME name=leftframe id=leftframe src="homepageLeft.jsp?rightStr=homepage:Maint" width="100%" height="100%" frameborder=no scrolling=no>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage())%></IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent" style="padding:0px;padding-left: 0px;">
		<IFRAME name=contentframe id=contentframe src="HomepageTabs.jsp?subCompanyId=0&_fromURL=hpManit&loginview=0" width="100%" height="100%" frameborder=no scrolling=auto>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage())%></IFRAME>
		</td>
		</tr>
  </TBODY>
</TABLE>
</body>
</html>