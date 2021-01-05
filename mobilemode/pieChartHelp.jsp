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

</head>
<body>

<div>
<img src="/mobilemode/images/mec/pieChartHelp_wev8.png" style="width: 450px;">
</div>
<%if(user.getLanguage() == 7){ %>
<div style="padding-left: 15px;">
以上图中的图表为例，其SQL返回的数据如下：
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>value</td>
	</tr>
	<tr>
		<td>搜索引擎</td>
		<td>35.75</td>
	</tr>
	<tr>
		<td>直接访问</td>
		<td>710.84</td>
	</tr>
	<tr>
		<td>...</td>
		<td>...</td>
	</tr>
</table>
<div style="line-height: 20px;">
其中第一列为图表的类别名称<br/>
第二列为具体的数据值<br/>
图例会使用第一列的数据
</div>
</div>
<%}else if(user.getLanguage() == 8){ %>
<div style="padding-left: 15px;">
In the above chart, for example, the data returned by SQL is as follows:
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>value</td>
	</tr>
	<tr>
		<td>搜索引擎</td>
		<td>35.75</td>
	</tr>
	<tr>
		<td>直接访问</td>
		<td>710.84</td>
	</tr>
	<tr>
		<td>...</td>
		<td>...</td>
	</tr>
</table>
<div style="line-height: 20px;">
The first column is the category name of the chart<br/>
The second column is the specific data value<br/>
The legend will use the first column of data
</div>
</div>
<%}else if(user.getLanguage() == 9){ %>
<div style="padding-left: 15px;">
以上圖中的圖表為例，其SQL返回的數據如下：
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>value</td>
	</tr>
	<tr>
		<td>搜索引擎</td>
		<td>35.75</td>
	</tr>
	<tr>
		<td>直接访问</td>
		<td>710.84</td>
	</tr>
	<tr>
		<td>...</td>
		<td>...</td>
	</tr>
</table>
<div style="line-height: 20px;">
其中第壹列為圖表的類別名稱<br/>
第二列為具體的數據值<br/>
圖例會使用第壹列的數據
</div>
</div>
<%} %>
</body>
</html>
