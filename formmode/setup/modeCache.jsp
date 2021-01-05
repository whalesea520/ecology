<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.excel.ModeCacheManager"%>
<%
	User user = HrmUserVarify.getUser(request, response);
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	ModeCacheManager modeCacheManager = ModeCacheManager.getInstance();
	Map<String,String> baseInfoMap = modeCacheManager.getBaseInfoMap();
	boolean loading  = modeCacheManager.isLoading();
	String time = "";
	String t = "";
	String status = "";
	if(loading){
		status = "正在加载";
	}
	String end = "";
	if(baseInfoMap.containsKey("end")){
		String start = baseInfoMap.get("start");
		end = baseInfoMap.get("end");
		time = start + " -- "+end;
		t = baseInfoMap.get("t")+"秒";
		if(!loading){
			status = "加载完毕";
		}
	}else{
		if(!loading){
			status = "未加载";
		}
	}
	String modeid = Util.null2String(request.getParameter("modeid"));
	String customid = Util.null2String(request.getParameter("customid"));
	String browserid = Util.null2String(request.getParameter("browserid"));
	List<Map<String,String>>  list = modeCacheManager.getCacheAllInfoList(modeid,customid,browserid);
	int count = list.size();
	String cycleTime = modeCacheManager.getCACHE_REFISH_TIME()+"分钟";


%>
<html>
	<head>
<style type="text/css">
/* CSS Document */

body {
 font: normal 11px auto "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
 color: #4f6b72;
 background: #E6EAE9;
}
div.topDiv{
	padding: 15px;
	line-height: 22px;
}
a {
 color: #110704;
}

#mytable {
 width: 80%;
 padding: 0;
 margin: 15px auto;
 border-collapse: collapse;
}

caption {
 padding: 0 0 5px 0;
 width: 700px;  
 font: italic 11px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
 text-align: right;
}

th {
	text-align: center;
	font: bold 11px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
	color: #4f6b72;
	border: 1px solid #C1DAD7;
	letter-spacing: 2px;
	text-transform: uppercase;
	padding: 6px 6px 6px 12px;
	background: #CAE8EA no-repeat;
}

td {
 border: 1px solid #C1DAD7;
 font-size:11px;
 padding: 6px 6px 6px 12px;
}

#mytable tr:nth-of-type(odd) td{  background: #F5FAFA; color: #797268;}/*奇数行  */
#mytable tr:nth-of-type(even) td{ background: #fff; color: #4f6b72;}/*偶数行  */

</style>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>	  
</head>
	<body>
		
		<table id="mytable" cellspacing="0" >
			<colgroup>
				<col style="width:10%"/>
				<col style="width:22%"/>
				<col style="width:22%"/>
				<col style="width:22%"/>
				<col style="width:22%"/>
			</colgroup>
			<tr>
					<th scope="col" abbr="Dual 1.8" colspan="4">基本信息</th>
			</tr>
			<tr>
					<td scope="col" abbr="Dual 1.8" colspan="4">
						<div class="topDiv">
								对象：<%=count%>个<br>
								上次缓存加载时间：<%=time%> 
						</div>
					</td>
			</tr>
			<%if(list.size()>0){%>
			  <tr>
				<th scope="col" abbr="Dual 1.8">序号</th>
				<th scope="col" abbr="Dual 1.8">标识</th>
				<th scope="col" abbr="Dual 1.8">缓存元素个数</th>
				<th scope="col" abbr="Dual 2">上次加载时间</th>
			  </tr>
			<%}%>
			  <%
			  boolean f = false;
			  int noCacheNum = 0;
			  int index = 0;
			  for (int i = 0; i < list.size(); i++) {
				index++;
				Map<String,String> map = list.get(i);
				String key = map.get("key");
				String size = map.get("size");
				String loadTime = map.get("loadTime");
				if(key.equals("workflow_selectitem")){%>
					<tr>
						<th scope="col" abbr="Dual 1.8" style="text-align:left" colspan="4">选择框缓存</th>
					</tr>
				<%}
				if(!f&&size.equals("未缓存")){
					noCacheNum++;
					f  = true;
				%>
					<tr>
						<th scope="col" abbr="Dual 1.8" style="text-align:left" colspan="4">未缓存浏览按钮<span id="noCacheNum"></span></th>
					</tr>
				<%}%>
					<tr>
						<td><%=index%></td>
						<td><%=key%></td>
						<td><%=size%></td>
						<td><%=loadTime%></td>
					</tr>
				<%

			}%>
			</table>
	</body>
</html>