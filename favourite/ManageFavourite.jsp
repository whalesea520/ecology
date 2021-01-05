
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+",javascript:_treeRightClick.editItem(),_self} " ;   //编辑
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:_treeRightClick.deleteItem(),_self} " ;   //删除
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML><HEAD>

<style type="">
.leftTypeSearch
{
	display:table-cell;
}
</style>
<%if(user.getLanguage()==7) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-cn-gbk_wev8.js'></script>
<%
}
else if(user.getLanguage()==8) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-en-gbk_wev8.js'></script>
<%
}
else if(user.getLanguage()==9) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-tw-gbk_wev8.js'></script>
<%
}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function refreshTreeMain(id,parentId,options){
		var options = jQuery.extend({
			idPrefix:"field_"
		},options);
		refreshTree(id,parentId,options);
	}
</script>
</HEAD>
<body scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck-3.5_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit-3.5_wev8.js"></script>

<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
				<span style='padding-top:4px;'><%=SystemEnv.getHtmlLabelNames("332,92" ,user.getLanguage()) %></span><span id="totalDoc" style="width: 130px;vertical-align: middle;padding-top: 10px;float: right;" title='<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage())+SystemEnv.getHtmlLabelName(2081 ,user.getLanguage()) %>'><img style='float: right;' alt="" src="/favourite/images/add_wev8.png" title='<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage())+SystemEnv.getHtmlLabelName(2081 ,user.getLanguage()) %>' onclick='add();'></span></span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
			<iframe src="" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:242px;height:100%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			e8_initTree("FavouriteTreeLeft.jsp");
			document.oncontextmenu = function(){return false;};    //屏蔽右键菜单
		});
		var dialog = null;
		function closeDialog(){
			if(dialog)
				dialog.close();
		}
		//新建子目录
		function openDialog(url,title,width,height){
			dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			var url = url;
			dialog.Title = title;
			dialog.Width = width;
			dialog.Height = height;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.show();
		}
		function add()
		{
			var url = "/favourite/FavouriteOperateTab.jsp?isdialog=1";
			var title = '<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage())+SystemEnv.getHtmlLabelNames("28111,92",user.getLanguage()) %>';
			openDialog(url,title,500,250);
		}
	</script>
 </body>
</html>