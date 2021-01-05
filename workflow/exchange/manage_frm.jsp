<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.workflow.exchange.ExchangeUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight(ExchangeUtil.WFEC_SETTING_RIGHTSTR, user))
{
	response.sendRedirect("/notice/noright.jsp");    	
	return;
}
%>
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
}
if(detachable==0){
    response.sendRedirect("manage_frm1.jsp");
    return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"managelist.jsp";
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
<TABLE class=viewform width=100% id=oTable1  cellpadding="0px" cellspacing="0px" height="100%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style="padding:0px;display:none;">
<IFRAME name=leftframe id=leftframe src="org_left.jsp?detachable=<%=detachable %>" width="100%" height="100%" frameborder=no scrolling=no >
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px">
<IFRAME name=contentframe id=contentframe src="manage_frm1.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>
</html>
