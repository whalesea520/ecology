
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add", user)){
	 response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String departmentid = Util.null2String(request.getParameter("departmentid"));
//(老的分权管理)
/*
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
*/

//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
String hrmdetachable="0";
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
if(isUseHrmManageDetach){
   hrmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("hrmdetachable",hrmdetachable);
}else{
   hrmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("hrmdetachable",hrmdetachable);
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
if (window.jQuery.client.browser == "Firefox"||window.jQuery.client.browser == "Chrome") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</HEAD>
<body  scroll="no">
<TABLE width="100%" id=oTable1 height="100%" cellpadding="0px" cellspacing="0px" style="border: 0">
  <TBODY> 
	<tr>
		<td height=100% id=oTd1 name=oTd1 width="246px" style="border-right:0px;display: none;">
			<IFRAME name=leftframe id=leftframe width="100%" src="HrmResource_left.jsp?rightStr=HrmResourceAdd:Add" height="100%" frameborder=no scrolling=no style="border: 0px">
			<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
			<IFRAME name=contentframe id=contentframe src="/hrm/HrmTab.jsp?_fromURL=HrmResourceAdd&departmentid=<%=departmentid %>" width="100%" height="100%" frameborder=no scrolling=no>
			<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
		</td>
	</tr>
  </TBODY>
</TABLE>
 </body>
</html>