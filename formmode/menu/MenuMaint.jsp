
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String imagefilename = "/images/home_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String menuflag = Util.null2String(request.getParameter("menuflag"));//表单建模新增菜单地址
boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  

if(!HeadMenuhasRight && !SubMenuRight){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
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
    left: 252px;
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
	var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"HompepageRight.jsp";
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
		treeSwitch.css("left","252px");
	}
	leftFrameTd.toggle();
}

function closeDialogAndRefreshWin(){
	var contentframe = document.getElementById("contentframe");
	var win = contentframe.contentWindow;
	var twin = win.document.getElementById("tabcontentframe").contentWindow;
	if(twin.closeDialogAndRefreshWin){
		twin.closeDialogAndRefreshWin();
	}
}
</script>
</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 height=98%>
  <TBODY>
		<tr><td  height=100% id="oTd1" name="oTd1" width="250px"> 
		<IFRAME name=leftframe id=leftframe src="/formmode/menu/MenuLeft.jsp?rightStr=SubMenu:Maint&menuflag=<%=menuflag%>" width="100%" height="100%" frameborder=no scrolling=no>
		<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%><!-- 浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。 --></IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent" style="padding-left: 5px;">
		<IFRAME name=contentframe id=contentframe src="/formmode/menu/MenuCenter.jsp?menutype=2&menuflag=<%=menuflag%>" width="100%" height="100%" frameborder=no scrolling=auto>
		<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%><!-- 浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。 --></IFRAME>
		</td>
		</tr>
  </TBODY>
</TABLE>
<div  id="treeSwitch" style="left:252px; top: 13px;" onclick="expandOrCollapse();" isexpand="1"></div>
</body>
</html>
