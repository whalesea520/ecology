<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int modelInfoId = Util.getIntValue(request.getParameter("id"), 0);
int formId = 0;
/*
EntityInfoManager eiManager = EntityInfoManager.getInstance();
FormUIManager uiManager = FormUIManager.getInstance();
FormUI uiView = null;
FormUI uiCreate = null;
FormUI uiEdit = null;
FormUI uiMonitor = null;
FormUI uiPrint = null;
if(entityInfoId!=0){
	EntityInfo ei = eiManager.getEntityInfo(entityInfoId);
	formId = ei.getFormid();
	if(ei!=null){
		uiCreate = uiManager.getCreateFormUI(formId);
		uiView = uiManager.getViewFormUI(formId);
		uiEdit = uiManager.getEditFormUI(formId);
		uiMonitor = uiManager.getMonitorFormUI(formId);
		uiPrint = uiManager.getPrintFormUI(formId);
	}
}
*/
%>
<html>
<head>
	<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	
	<style>
	*{
		font: 12px Microsoft YaHei;
	}
	.e8_formmode_btn{
	}
	.e8_tblForm{
		width: 100%;
		margin: 0 0;
		border-collapse: collapse;
	}
	.e8_tblForm .e8_tblForm_label{
		vertical-align: top;
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 2px;
	}
	.e8_tblForm .e8_tblForm_field{
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
	}
	.e8_label_desc{
		color: #aaa;
	}
	</style>
<script>

</script>
</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form>
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82135,user.getLanguage())%><!-- 新建布局 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82194,user.getLanguage())%><!-- 新建时默认使用的布局 --></div></td>
	<td class="e8_tblForm_field">
		<select style="width:200px">
		<option><% %></option>
		</select>
		<img src="/formmode/images/add10_wev8.png" style="margin:2px 0 0 2px;" />
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%><!-- 编辑布局 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82195,user.getLanguage())%><!-- 编辑时默认使用的布局 --></div></td>
	<td class="e8_tblForm_field">
		<select style="width:200px">
		<option><% %></option>
		</select>
		<img src="/formmode/images/add10_wev8.png" style="margin:2px 0 0 2px;" />
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82134,user.getLanguage())%><!-- 显示布局 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82196,user.getLanguage())%><!-- 显示时默认使用的布局 --></div></td>
	<td class="e8_tblForm_field">
		<select style="width:200px">
		<option><% %></option>
		</select>
		<img src="/formmode/images/add10_wev8.png" style="margin:2px 0 0 2px;" />
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82137,user.getLanguage())%><!-- 监控布局 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82197,user.getLanguage())%><!-- 监控时默认使用的布局 --></div></td>
	<td class="e8_tblForm_field">
		<select style="width:200px">
		<option><% %></option>
		</select>
		<img src="/formmode/images/add10_wev8.png" style="margin:2px 0 0 2px;" />
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82138,user.getLanguage())%><!-- 打印布局 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82198,user.getLanguage())%><!-- 打印时默认使用的布局 --></div></td>
	<td class="e8_tblForm_field">
		<select style="width:200px">
		<option><% %></option>
		</select>
		<img src="/formmode/images/add10_wev8.png" style="margin:2px 0 0 2px;" />
	</td>
</tr>
</table>
</form>
</body>
</html>
