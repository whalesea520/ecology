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
<img src="/mobilemode/images/mec/DemoChart2_wev8.png?123" style="width: 420px;height: 250px;margin:0 auto;display:block;">
</div>
<div style="padding-left: 15px;">
<%=SystemEnv.getHtmlLabelName(127612,user.getLanguage())%><!-- 以上图中的左边第一个折线图为例，其SQL返回的数据如下： -->
<table class="dataTable">
	<tr class="header">
		<td>value</td>
		<td>15</td>
		<td>25</td>
		<td>40</td>
		<td>30</td>
		<td>45</td>
		<td>40</td>
		<td>35</td>
		<td>55</td>
		<td>37</td>
		<td>50</td>
		<td>60</td>
		<td>45</td>
		<td>70</td>
		<td>78</td>
	</tr>
</table>
<div style="line-height: 20px;">
<%=SystemEnv.getHtmlLabelName(127613,user.getLanguage())%><!-- 书写SQL语句时需要注意value为数字。如： --><br/>
select count(id) as <b>value</b> from table<br/>
<%=SystemEnv.getHtmlLabelName(127614,user.getLanguage())%><!-- 如果没有明确指明value列，将使用查询结果的第1列作为value列。 --><br/>
<%=SystemEnv.getHtmlLabelName(127615,user.getLanguage())%><!-- 所以下面的查询SQL也是可以的: --><br/>
select count(id) from table
</div>
<div style="padding-top: 15px;">
<%=SystemEnv.getHtmlLabelName(127616,user.getLanguage())%><!-- 以上图中的左边第一个圆形图为例，其SQL返回的数据如下： -->
<table class="dataTable">
	<tr class="header">
		<td>count</td>
		<td>num</td>
	</tr>
	<tr>
		<td>100</td>
		<td>77</td>
	</tr>
</table>
<div style="line-height: 20px;float:left;">
<%=SystemEnv.getHtmlLabelName(127617,user.getLanguage())%><!-- 书写SQL语句时需要注意count和num为数字。如： --><br/>
select total as <b>count</b>, finished as <b>num</b> from table<br/>
<%=SystemEnv.getHtmlLabelName(127618,user.getLanguage())%><!-- 如果没有明确指明count列，将使用查询结果的第1列作为count列。 --><br/>
<%=SystemEnv.getHtmlLabelName(127619,user.getLanguage())%><!-- 如果没有明确指明num列，将使用查询结果的第1列作为num列。 --><br/>
<%=SystemEnv.getHtmlLabelName(127615,user.getLanguage())%><!-- 所以下面的查询SQL也是可以的: --><br/>
select total, finished from table<br/>
<b style="color:red;"><%=SystemEnv.getHtmlLabelName(127620,user.getLanguage())%><!-- 注意：如果查询结果有多列，默认取第一列! --></b><br/>
</div>
</div>
</body>
</html>
