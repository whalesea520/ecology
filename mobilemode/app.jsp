
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager"%>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo"%>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager" %>
<%@ page import="com.weaver.formmodel.util.NumberHelper"%>
<%@ page import="weaver.hrm.*" %>
<%
int appid =NumberHelper.string2Int(request.getParameter("appid"),0);
List<MobileAppModelInfo> appModelList = MobileAppModelManager.getInstance().getAllFormByAppid(appid);
MobileAppBaseInfo appBaseInfo = MobileAppBaseManager.getInstance().get(appid);
String appName = appBaseInfo.getAppname();
if(appName == null ) {
   appName = "应用信息";
}
 %>

<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title></title>
    <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,700">
	<link rel="stylesheet" href="/mobilemode/jqmobile4/css/themes/default/jquery.mobile-1.4.0.min_wev8.css">
	<link rel="stylesheet" href="/mobilemode/jqmobile4/_assets/css/jqm-demos_wev8.css">
	<script src="/mobilemode/jqmobile4/js/jquery_wev8.js"></script>
	<script src="/mobilemode/jqmobile4/_assets/js/index_wev8.js"></script>
	<script src="/mobilemode/jqmobile4/js/jquery.mobile-1.4.0.min_wev8.js"></script>
	
</HEAD>
<body >
<div data-role="page" id="myPage" data-dom-cache="true">
<div data-role="header" data-theme="b">
    <h1><%=appBaseInfo.getAppname()%></h1>
    <a href="#" data-shadow="false" data-iconshadow="false" data-icon="arrow-l" data-iconpos="notext" data-rel="back">返回</a>
</div>
<%
if(appid == 0 || appBaseInfo.getIsdelete() == 1) {
    out.println("该应用不存在!");
    return;
} else {
 %>
<ul data-role="listview" data-inset="true">
    <%
  for(MobileAppModelInfo appmodel : appModelList) {
     %>
       <li data-icon="plus"><a href="/mobilemode/formbaseview.jsp?appid=<%=appid%>&modelid=<%=appmodel.getModelId()%>&uitype=2"><%=appmodel.getEntityName() %></a></li>
       <li data-icon="grid"><a href="/mobilemode/formbaseview.jsp?appid=<%=appid%>&modelid=<%=appmodel.getModelId()%>&uitype=3"><%=appmodel.getEntityName() %>列表</a></li>
<% }} %>
    </ul>
    </div>
</body>
</html>