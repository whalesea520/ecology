<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

%>

<%
/*
if(!HrmUserVarify.checkUserRight("SystemTemplate:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
*/
//==============================================================================================
//TD4028
//added by hubo,2006-03-23
String goalType = Util.null2String(request.getParameter("goalType"));
int objId = Util.getIntValue(request.getParameter("objId"));
String goalDate = Util.null2String(request.getParameter("goalDate"));
String cycle = Util.null2String(request.getParameter("cycle"));
//==============================================================================================
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"myGoalList.jsp";
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
<script language="javascript" defer="defer" src="/js/datetime.js"></script>
<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<body style="overflow:hidden" scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  <TBODY>
<tr>
	<td  height=100% id=oTd1 name=oTd1 width="220px" style=¡¯padding:0px¡¯>
	<IFRAME name=leftframe id=leftframe src="/hrm/performance/organizationTree2.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
	<td height=100% id=oTd0 name=oTd0 width="10px" style=¡¯padding:0px¡¯>
	<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
	<td height=100% id=oTd2 name=oTd2 width="*" style=¡¯padding:0px¡¯>
	<IFRAME name=contentframe id=contentframe src="myGoalList.jsp?goalDate=<%=goalDate%>&cycle=<%=cycle%>&goalType=<%=goalType%>&objId=<%=objId%>" width="100%" height="100%" frameborder=no scrolling=yes>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>