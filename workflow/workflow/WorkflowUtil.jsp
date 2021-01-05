
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response); 
%>
<%-- 
<%@ include file="/systeminfo/init_wev8.jsp" %>
--%>
<script type="text/javascript">
<%//弹出窗口%>
function onShowCommonDialogWindow(input, span, url, param, title, width, height, callback) {
	if (!title) {
		title = '<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>';
	}
	if (!width) {
		width = 600;
	}
	if (!height) {
		height = 600;
	}
	if (param && /=$/.test(param)) {
		param += jQuery(input).val();
	}
	var browserDialog = new top.Dialog();
	browserDialog.Width = width;
	browserDialog.Height = height;
	browserDialog.URL = url + escape(param);
	browserDialog.Title = title;
	browserDialog.checkDataChange = false;
	browserDialog.callback = function(data) {
		browserDialog.close();
		if (typeof(callback) === 'function') {
			callback(data);
		} else {
			var id = data.id;
			if (!!id && id.indexOf(',') == 0) {
				id = id.substring(1);
			}
			jQuery(input).val(id);
			var name = data.name;
			if (!!name && name.indexOf(',') == 0) {
				name = name.substring(1);
			}
			jQuery(span).html(name);
		}
	};
	browserDialog.show();
}
</script>