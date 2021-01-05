
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp =""; 


String type = Util.null2String(request.getParameter("type"));
String menuflag = Util.null2String(request.getParameter("menuflag"));//表单建模新增菜单地址


%>


<%
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
#treeSwitch{
 	background-color: #fff;
    background-image: url("/images/ecology8/openTree_wev8.png");
    border: medium none;
    cursor: pointer;
    height: 48px;
    left: 242px;
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
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"templateList.jsp";
//alert(contentUrl);
if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}

    
function expandOrCollapse(){
	var treeSwitch = $("#treeSwitch");
	var leftFrameTd = $("#oTd1");
	var isexpand = treeSwitch.attr("isexpand");
	if(isexpand==1){
		treeSwitch.addClass("collapse");
		treeSwitch.attr("isexpand","0");
		treeSwitch.css("left","0px");
	}else{
		treeSwitch.removeClass("collapse");
		treeSwitch.attr("isexpand","1");
		treeSwitch.css("left","242px");
	}
	leftFrameTd.toggle();
}


function closeDialogAndRefreshWin(isrefresh,selectids){
	var contentframe = document.getElementById("contentframe");
	var win = contentframe.contentWindow;
	var twin = win.document.getElementById("tabcontentframe").contentWindow;
	if(twin.closeDialogAndRefreshWin){
		twin.closeDialogAndRefreshWin(isrefresh,selectids);
	}
}

function onCancel(){
	closeDialogAndRefreshWin(false,"");
}

</script>
</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 height=100%>

  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 style="width:240px;">
<IFRAME name=leftframe id=leftframe src="/formmode/menu/MenuMaintenanceTreeLeft.jsp?type=<%=type%>&menuflag=<%=menuflag%>" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%><!-- 浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。 --></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding-left: 5px;">
<IFRAME name=contentframe id=contentframe src="/formmode/menu/MenuMaintenanceList.jsp?type=<%=type%>&resourceType=1&resourceId=1&menuflag=<%=menuflag%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%><!-- 浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。 --></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
<div  id="treeSwitch" style="left:242px; top: 13px;" onclick="expandOrCollapse();" isexpand="1"></div>
 </body>

</html>

