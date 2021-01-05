
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
/*
if(!HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user) || !HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}*/
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
if(detachable==0){
    response.sendRedirect("HrmRpContract.jsp");
    return;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"HrmScheduleDiff.jsp";
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
<body  scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100%  cellpadding="0px" cellspacing="0px">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
<IFRAME name=leftframe id=leftframe src="HrmRpContract_left.jsp" width="100%" height="100%" frameborder=no scrolling="auto">
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width="10px" style=’padding:0px’>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
<IFRAME name=contentframe id=contentframe src="HrmRpContract.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>