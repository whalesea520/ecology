<%@ page contentType="text/html; charset=UTF-8"%>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(18363, user.getLanguage()) + ",javascript:toFirstPage(),_self}";//首页
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(1258, user.getLanguage()) + ",javascript:toPrevPage(),_self}";//上一页
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(1259, user.getLanguage()) + ",javascript:toNextPage(),_self}";//下一页
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(18362, user.getLanguage()) + ",javascript:toLastPage(),_self}";//尾页
	RCMenuHeight += RCMenuHeightStep;
%>
<style>
input{outline:none}
.pagination{
	text-align: center;
}
.pagination span{
	padding: 0px 2px;
}
.pagination a{
	padding: 0px 2px;
	text-decoration: underline;
	color: #0072C6;
}
</style>
<script type="text/javascript">
jQuery(document).ready(function ($) {	//先隐藏，页面布局完成之后再显示，规避在页面没渲染完成之前的样式错乱(比如开始显示很宽突然变得很窄)
	$("#leftPart").show();
});
</script>
<div id="leftPart" style="display: none;">
	<div class="e8_left_top">
		<table class="e8_searchTable">
			<tr>
				<td style="padding:0 0 0 5px;position: relative;"><input type="text" class="e8_searchText" value=""/><div class="e8_searchText_tip">Search...</div></td>
				<td width="18" style="padding:0px 2px 0 0;line-height:5px;"><img src="/formmode/images/btnSearch_wev8.png" /></td>
			</tr>
		</table>
		
	</div>
	
	<div class="e8_left_center">
		<div class="e8_title">
			<span></span>
		</div>
		<ul>
		</ul>
	</div>
	
	<div class="e8_left_bottom">
		<div id="pagination" style=""></div>

	</div>
	
	<div class="e8_module">
		<div class="e8_module_title">
			<span><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%><!-- 应用 --></span>
		</div>
	</div>
</div>