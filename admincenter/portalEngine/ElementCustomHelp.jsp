
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   
    <title>元素开发指南</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
  </head>
<body>
<pre>
	基本信息:
	1.元素标识只能为数字或字母
	
	2.元素类别
		1).登录前元素:只能在登录前页面中使用;
		2).登录后元素:只能在登录后门户中使用;
		3).元素:登录前、登录后都可使用;
		
	3.链接方式
		1).无:只显示数据,不能点击跳转;
		2).默认窗口:显示在OA的内容显示区域;
		3).弹出窗口:新打开一个窗口显示;
		
	4.元素图标(图片大小:16*16)
	
	显示字段:
	1.多个显示字段,字段名称不能相同
	2.显示顺序从1开始,只能为整数数字
	
	设置地字段(暂时只能添加一种数据来源):
	1.外部数据源 + 数据库+SQL语句 
		注:查询语句字段的顺序必须与显示字段的顺序保持一致
	2.外部数据页 + XML	
		注:XML中必须包含 <item><显示-字段名称1>value1</显示-字段名称1>...</item>
	3.外部数据页 + JSON	
		注:JSON中必须包含 {"item":[{"显示-字段名称1":value1,"显示-字段名称2":value2}]}
	
</pre>
</body>
</html>
<script type="text/javascript">

</script>