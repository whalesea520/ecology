<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String objId=Util.null2String(request.getParameter("objId")); 
String type_d="3"; 
String type=Util.null2String(request.getParameter("cycle")); 
String planDate=Util.null2String(request.getParameter("planDate")); 
String years=Util.null2String(request.getParameter("years"));
String months=Util.null2String(request.getParameter("months"));
String weeks=Util.null2String(request.getParameter("weeks"));
String quarters=Util.null2String(request.getParameter("quarters"));

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
/**
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
if(detachable==0){
    response.sendRedirect("manageform.jsp");
    return;
}
*/
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"manageform.jsp";
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
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HEAD>
<body scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
<IFRAME name=leftframe id=leftframe src="/hrm/performance/organizationTree2.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width="10px" style=’padding:0px’>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
<IFRAME name=contentframe id=contentframe src="MyPlanMain.jsp?objId=<%=objId%>&type_d=<%=type_d%>&months=<%=months%>&years=<%=years%>&type=<%=type%>&planDate=<%=planDate%>&quarters=<%=quarters%>&weeks=<%=weeks%>" width="100%" height="100%" frameborder=no scrolling=yes>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>