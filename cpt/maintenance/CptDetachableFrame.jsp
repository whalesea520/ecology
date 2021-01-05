
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String queryString=request.getQueryString();
String url="";
String from=Util.null2String(request.getParameter("from"));
if("cptassortment".equalsIgnoreCase(from)){
	url="/cpt/maintenance/CptAssortment.jsp?from="+from;
}else if("cptalertnumconf".equalsIgnoreCase(from)){
	url="/cpt/conf/cptalertnumconf.jsp?"+queryString;
}else if("cptmodify".equalsIgnoreCase(from)){
	url="/cpt/maintenance/cptmodify.jsp?"+queryString;
}

%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" defer="defer" src='/js/datetime_wev8.js?rnd="+Math.random()+"'></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"/hrm/search/HrmResourceSearchTmp.jsp";
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
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
<IFRAME name=leftframe id=leftframe src="/cpt/capital/CptCapMain_left.jsp?from=<%=from %>" width="100%" height="100%" frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>

<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
<IFRAME name=contentframe id=contentframe src="<%=url %>" width="100%" height="100%" frameborder=no scrolling=yes>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>




  </TBODY>
</TABLE>
 </body>

</html>