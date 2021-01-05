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
<div style="padding-left: 15px;padding-top: 15px;">
<%=SystemEnv.getHtmlLabelName(127675,user.getLanguage())%><!-- 举例，SQL返回的数据如下： -->
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>value</td>
	</tr>
	<tr>
		<td>IE</td>
		<td>35.75</td>
	</tr>
	<tr>
		<td>Chrome</td>
		<td>29.84</td>
	</tr>
	<tr>
		<td>Firefox</td>
		<td>24.88</td>
	</tr>
	<tr>
		<td>Safari</td>
		<td>6.77</td>
	</tr>
	<tr>
		<td>Opera</td>
		<td>2.02</td>
	</tr>
	<tr>
		<td>Other</td>
		<td>0.73</td>
	</tr>
</table>
<div style="line-height: 20px;">
<%=SystemEnv.getHtmlLabelName(127676,user.getLanguage())%><!-- 书写SQL语句时需要指明name列和value列。如： --><br/>
select browsername as <b>name</b>, browservalue as <b>value</b> from browserinfo<br/>
<%=SystemEnv.getHtmlLabelName(127608,user.getLanguage())%><!-- 如果没有明确指明name列，将使用查询结果的第1列作为name列。 --><br/>
<%=SystemEnv.getHtmlLabelName(127609,user.getLanguage())%><!-- 如果没有明确指明value列，将使用查询结果的第2列作为value列。 --><br/>
<%=SystemEnv.getHtmlLabelName(127615,user.getLanguage())%><!-- 所以下面的查询SQL也是可以的: --><br/>
select browsername, browservalue from browserinfo<br/>
<%=SystemEnv.getHtmlLabelName(127577,user.getLanguage())%><!-- 可使用变量： --><br/>
<%=SystemEnv.getHtmlLabelName(127677,user.getLanguage())%><!-- 用户:{curruser}，部门:{currdept}，日期:{currdate}，时间:{currtime}，日期时间:{currdatetime},或者页面上的参数 --><br/>
<%=SystemEnv.getHtmlLabelName(127578,user.getLanguage())%><!-- 示例： --><br/>
select browsername, browservalue form browserinfo where col1 = '{curruser}' and col2 = '{paramName}'
</div>
</div>
</body>
</html>
