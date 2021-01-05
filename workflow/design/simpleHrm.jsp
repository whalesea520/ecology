
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>


<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

int hrmid = Util.getIntValue(request.getParameter("hrmid"), 0);
%>

<!DOCTYPE>
<html>
  <head>
    <base href="<%=basePath%>">
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type="text/javascript" src="../../js/jquery/jquery-1.4.2.min_wev8.js"></script>
	<style type="text/css">
	#closetext {
		display:none!important;
	}
	html{
		overflow:hidden;
	}
	</style>
	<script type="text/javascript">
	var hrmid = <%=hrmid %>;
	$(document).ready(function () {
		bodySize[0] = 0;
     	bodySize[1] = 0;
     	clickSize[0] = 0;
     	clickSize[1] = 0;
		$("#hrmElement").trigger("click");
		//去掉iframe父级滚动条
		$("#iframe_0", parent.document).parent("div#0").css("overflow", "hidden");
	});
	
	function setClickPoint() {
		bodySize[0] = 0;
     	bodySize[1] = 0;
     	clickSize[0] = 0;
     	clickSize[1] = 0;
     	clickSize[2] = 0;
	}
	</script>
  </head>
  <body style="width:463px;height:300px;overflow:hidden;" scroll="no">
  		<div id="hrmElement" onClick="setClickPoint();openhrm(<%=hrmid %>);"></div>
  </body>
</html>
