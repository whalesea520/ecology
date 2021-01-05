
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String imagefilename = "/images/home_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("ProductList:View", user);	//产品列表

if(!HeadMenuhasRight){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function refreshTreeMain(id,parentid,needrefresh)
	{
		document.leftframe.window.refreshTreeMain(id,parentid,needrefresh);
	}
	function refreshTreeNum(ids,isadd)
	{
		document.leftframe.window.refreshTreeNum(ids,isadd);
	}
</script>
</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <TBODY>
		<tr><td  height=100% id="oTd1" name="oTd1" width="250px" style="background-color:#F8F8F8;padding-left:0px;"> 
		<IFRAME name=leftframe id=leftframe src="/lgc/search/LgcProductMenuLeft.jsp" width="100%" height="100%" frameborder=no scrolling=no>
		浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent" style="padding-left:0px;">
		<IFRAME name=contentframe id=contentframe src="/lgc/search/LgcProductList.jsp" width="100%" height="100%" frameborder=no scrolling=no>
		浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		</td>
		</tr>
  </TBODY>
</TABLE>
</body>
</html>
