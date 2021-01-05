
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String id=Util.null2String(request.getParameter("id"));
String searchkeyname=Util.null2String(request.getParameter("searchkeyname"));
String isExpand = Util.null2String(request.getParameter("isExpand"),"1");
String fieldname = Util.null2String(request.getParameter("fieldname"),"");
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />

<style type="text/css">
#treeSwitch{
 	background-color: #fff;
    background-image: url("/images/ecology8/openTree_wev8.png");
    border: medium none;
    cursor: pointer;
    height: 48px;
    left: 221px;
    line-height: 32px;
    position: absolute;
    text-align: center;
    top: 10px;
    height: 39px;
    width: 10px;
}

#treeSwitch:hover{
    background-image: url("/images/ecology8/openTree_hover_wev8.png");
}

#treeSwitch.collapse{
	background-image: url("/images/ecology8/closeTree_wev8.png");
}

#treeSwitch.collapse:hover{
	background-image: url("/images/ecology8/closeTree_hover_wev8.png");
}
</style>
<script language="JavaScript">
if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}

$(function(){
	if("0"=="<%=isExpand%>"){
	   var treeSwitch = $("#treeSwitch");
	   var leftFrameTd = $("#leftFrameTd");
	   treeSwitch.attr("isexpand","0");
	   treeSwitch.addClass("collapse");
	   treeSwitch.css("left","0px");
	   leftFrameTd.toggle();
	}
})

function expandOrCollapse(){
	var treeSwitch = $("#treeSwitch");
	var leftFrameTd = $("#leftFrameTd");
	var isexpand = treeSwitch.attr("isexpand");
	if(isexpand==1){
		treeSwitch.addClass("collapse");
		treeSwitch.attr("isexpand","0");
		treeSwitch.css("left","0px");
	}else{
		treeSwitch.removeClass("collapse");
		treeSwitch.attr("isexpand","1");
		treeSwitch.css("left","221px");
	}
	leftFrameTd.toggle();
}
</script>
</HEAD>
<body scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  
  <TBODY>
<tr><td id="leftFrameTd"  height=100% id=oTd1 name=oTd1 width="220px" style="padding:0px; background-color: rgb(245, 245, 245) !important;border-right: 1px solid #bdbdbd;">
<IFRAME name=leftframe id=leftframe src="/formmode/tree/CustomTreeLeft.jsp?id=<%=id%>&searchkeyname=<%=URLEncoder.encode(searchkeyname,"utf-8") %>" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME><!-- 浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。 -->
</td>

<td height=100% id=oTd2 name=oTd2 width="*" style="padding-left:10px">
<IFRAME name=contentframe id=contentframe src="/formmode/tree/CustomTreeRight.jsp?mainid=<%=id%>&searchkeyname=<%=URLEncoder.encode(searchkeyname,"utf-8") %>&pid=0<%=CustomTreeData.Separator%>0&fieldname=<%=fieldname %>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME><!-- 浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。 -->

<div  id="treeSwitch" style="left:221px; top: 11px;" onclick="expandOrCollapse();" isexpand="1"></div>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>
