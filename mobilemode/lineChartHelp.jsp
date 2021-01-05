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
<img src="/mobilemode/images/mec/lineChartHelp_wev8.png" style="width: 450px;">
</div>
<%if(user.getLanguage() == 7){ %>
<div style="padding-left: 15px;">
以上图中的图表为例，其SQL返回的数据如下：
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>最高气温</td>
		<td>最低气温</td>
	</tr>
	<tr>
		<td>周一</td>
		<td>11</td>
		<td>1</td>
	</tr>
	<tr>
		<td>周二</td>
		<td>7</td>
		<td>6</td>
	</tr>
	<tr>
		<td>...</td>
		<td>...</td>
		<td>...</td>
	</tr>
</table>
<div style="line-height: 20px;">
其中第一列为x轴的类别名称<br/>
第二列开始到第N列为数据列，就是显示的折线图的点数据<br/>
图例会使用各数据列的列名称
</div>
</div>
<%}else if(user.getLanguage() == 8){ %>
<div style="padding-left: 15px;">
In the above chart, for example, the data returned by SQL is as follows:
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>最高气温</td>
		<td>最低气温</td>
	</tr>
	<tr>
		<td>周一</td>
		<td>11</td>
		<td>1</td>
	</tr>
	<tr>
		<td>周二</td>
		<td>7</td>
		<td>6</td>
	</tr>
	<tr>
		<td>...</td>
		<td>...</td>
		<td>...</td>
	</tr>
</table>
<div style="line-height: 20px;">
The first column is the x-axis category name<br/>
The second column from the beginning to the N column is the data column, which is the point data of line chart displayed<br/>
The legend uses column names for each data column
</div>
</div>
<%}else if(user.getLanguage() == 9){ %>
<div style="padding-left: 15px;">
以上圖中的圖表為例，其SQL返回的數據如下：
<table class="dataTable">
	<tr class="header">
		<td>name</td>
		<td>最高气温</td>
		<td>最低气温</td>
	</tr>
	<tr>
		<td>周一</td>
		<td>11</td>
		<td>1</td>
	</tr>
	<tr>
		<td>周二</td>
		<td>7</td>
		<td>6</td>
	</tr>
	<tr>
		<td>...</td>
		<td>...</td>
		<td>...</td>
	</tr>
</table>
<div style="line-height: 20px;">
其中第壹列為x軸的類別名稱<br/>
第二列開始到第N列為數據列，就是顯示的折線圖的點數據<br/>
圖例會使用各數據列的列名稱
</div>
</div>
<%} %>
</body>
</html>
