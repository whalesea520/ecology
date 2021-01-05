
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
/*
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}*/
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
if(isUseHrmManageDetach){
	 session.setAttribute("detachable","1");
  session.setAttribute("hrmdetachable","1");
}else{
	 session.setAttribute("detachable","0");
  session.setAttribute("hrmdetachable","0");
}
String from = Util.null2String(request.getParameter("from"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
if (window.jQuery.client.browser == "Firefox"||window.jQuery.client.browser == "Chrome") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height()-5);
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height()-5);
			};
		});
	}
	
</script>
</HEAD>
<body  scroll="no">
<TABLE width="100%" id=oTable1 height="100%" cellpadding="0px" cellspacing="0px">
  <TBODY> 
	<tr>
		<td  height=100% id=oTd1 name=oTd1 width="246px" style="border-right:0px;display: none">
			<IFRAME name=leftframe id=leftframe src="HrmResourceSearch_left.jsp?rightStr=showAllSubCompany" width="100%" height="100%" frameborder=no scrolling=no></IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
			<IFRAME name=contentframe id=contentframe src="/hrm/HrmTab.jsp?_fromURL=<%=from.equals("QuickSearch")?"HrmResourceSearchResult":"HrmResourceSearch" %>&from=<%=from %>" width="100%" height="100%" frameborder=no scrolling=no></IFRAME>
		</td>
	</tr>
  </TBODY>
</TABLE>
 </body>
</html>