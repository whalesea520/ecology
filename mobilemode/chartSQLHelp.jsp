<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<html>
<head>
	<title></title>
	<style>
	*{
		font-family: 'Microsoft YaHei', Arial;
	}
	html,body{
		height: 100%;
		margin: 0px;
		padding: 0px;
	}
	.dataTable{
		border-collapse: collapse;
		margin: 5px 0px; 
	}
	.dataTable td{
		border: 1px solid #ccc;
		padding: 3px 10px;
	}
	.dataTable tr.header td{
		font-weight: bold;
		background-color: #f8f8f8;
	}
	</style>
<script type="text/javascript">
function onClose(){
	if(top && top.closeTopDialog){
		top.closeTopDialog();
	}else{
		window.close();
	}
}
</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_top} " ;  //关闭
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div>
<img src="/mobilemode/images/mec/DemoChart_wev8.png?123" style="width: 420px;height: 201px;">
</div>
<div style="padding-left: 15px;">
<%=SystemEnv.getHtmlLabelName(127606,user.getLanguage())%><!-- 以上图中的图标为例，其SQL返回的数据如下： -->
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>value</td>
		<td>color</td>
	</tr>
	<tr>
		<td>IE</td>
		<td>35.75</td>
		<td>#bc6666</td>
	</tr>
	<tr>
		<td>Chrome</td>
		<td>29.84</td>
		<td>#cbab4f</td>
	</tr>
	<tr>
		<td>Firefox</td>
		<td>24.88</td>
		<td>#76a871</td>
	</tr>
	<tr>
		<td>Safari</td>
		<td>6.77</td>
		<td>#9f7961</td>
	</tr>
	<tr>
		<td>Opera</td>
		<td>2.02</td>
		<td>#2ba5a4</td>
	</tr>
	<tr>
		<td>Other</td>
		<td>0.73</td>
		<td>#6f83a5</td>
	</tr>
</table>
<div style="line-height: 20px;">
<%=SystemEnv.getHtmlLabelName(127607,user.getLanguage())%><!-- 书写SQL语句时需要指明name列，value列和color列。如： --><br/>
select browsername as <b>name</b>, browservalue as <b>value</b>, browsercolor as <b>color</b> from browserinfo<br/>
<%=SystemEnv.getHtmlLabelName(127608,user.getLanguage())%><!-- 如果没有明确指明name列，将使用查询结果的第1列作为name列。 --><br/>
<%=SystemEnv.getHtmlLabelName(127609,user.getLanguage())%><!-- 如果没有明确指明value列，将使用查询结果的第2列作为value列。 --><br/>
<%=SystemEnv.getHtmlLabelName(127610,user.getLanguage())%><!-- 如果没有明确指明color列，将由系统自行分配颜色值。 --><br/>
<%=SystemEnv.getHtmlLabelName(127611,user.getLanguage())%><!-- 所以下面的查询SQL也是可以的，只是颜色值会由系统指定: --><br/>
select browsername, browservalue from browserinfo
</div>
</div>
</body>
</html>
