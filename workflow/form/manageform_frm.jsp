
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=0;
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
if(isUseWfManageDetach){
	detachable = 1;
	session.setAttribute("detachable","1");
}else{
    session.setAttribute("detachable","0");
}

if(detachable==0){
    response.sendRedirect("manageformTab.jsp");
    return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"manageformTab.jsp";
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

<body scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1  style="padding:0px;display:none;width:247px;">
<IFRAME name=leftframe id=leftframe src="manageform_left.jsp?rightStr=FormManage:All" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px">
<IFRAME name=contentframe id=contentframe src="manageformTab.jsp" width="100%" height="100%" frameborder=no scrolling=auto>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>