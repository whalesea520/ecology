<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("BudgetCostCenter:maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<%
RecordSet rs = new RecordSet();

rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	boolean fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
	if(!fnaBudgetCostCenter){
		out.println("</head><body style=\"padding: 15px;\">");
		out.println(SystemEnv.getHtmlLabelNames("81545",user.getLanguage())+"<br /><br />");//请先启用预算编制维度：成本中心
		out.println("<img alt=\"\" src=\"/fna/costCenter/CostCenter_wev8.png\"></body></html>");
		return;
	}
}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript src="/js/ecology8/fna/FnaSearchInit_wev8.js?r=4"></script>
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
<tr>
<td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
	<IFRAME name=leftframe id=leftframe src="/fna/costCenter/CostCenterLeft.jsp" width="100%" height="100%" frameborder=no scrolling=no>
	//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
	<IFRAME name=optFrame id=optFrame src="/fna/costCenter/CostCenterView.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
	//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
</TBODY>
</TABLE>
</body>

</html>