
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@page import="com.weaver.formmodel.ui.manager.*"%>
<%@page import="com.weaver.formmodel.ui.model.*"%>
<%@page import="com.weaver.formmodel.ui.base.*"%>
<%@page import="com.weaver.formmodel.ui.types.*"%>
<%@page import="com.weaver.formmodel.util.NumberHelper" %>
<%@page import="com.weaver.formmodel.ui.base.model.WebUIResouces" %>
<%@page import="weaver.hrm.*" %>
<%
int appid =NumberHelper.string2Int(request.getParameter("appid"),8);
int billid = NumberHelper.string2Int(request.getParameter("billid"),0);
int modelid = NumberHelper.string2Int(request.getParameter("modelid"),2);
int uitype = NumberHelper.string2Int(request.getParameter("uitype"),3);
User user = new User();//HrmUserVarify.getUser (request , response) ;
WebUIContext uiContext = new WebUIContext();
uiContext.setClient(ClientType.CLIENT_TYPE_MOBILE);
uiContext.setBusinessid(billid);
uiContext.setModelid(modelid);
uiContext.setUIType(uitype);
uiContext.setAppid(appid);
uiContext.setCurrentUser(user);
WebUIView uiview = WebUIManager.getInstance().getViewContent(uiContext);
if( uiview == null) {
    out.println("参数错误!");
    return;
}
Integer id = uiContext.getEntityid();
id = id == null?0:id;
boolean isShowtabs = !uiview.getAllPageResources().isEmpty();
String pagerole = "page";
if(isShowtabs) {
    pagerole = "tabs";
}
 %>

<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><%=uiview.getUiTitle() %></title>
	<link rel="stylesheet" href="/mobilemode/jqmobile4/css/themes/default/jquery.mobile-1.4.0.min_wev8.css">
	<script src="/mobilemode/jqmobile4/js/jquery_wev8.js"></script>
	<script src="/mobilemode/jqmobile4/js/jquery.mobile-1.4.0.min_wev8.js"></script>
	
</HEAD>
<body >
<%
if(isShowtabs) { 
    
%>
<div data-role="navbar">
    <ul>
    <%
  List<WebUIResouces> uiresouces =  uiview.getAllPageResources();
  String activestr = "class=\"ui-btn-active\"";
  for(WebUIResouces uires : uiresouces) {
     %>
      <li><a href="<%=uires.getResourceContent() %>" target="content" <%=activestr %>><%=uires.getResourceName() %></a></li>
<% activestr="";} %>
    </ul>
  </div>
<iframe name="content" src="<%=uiresouces.get(0).getResourceContent()%>" width="100%" height="768px"></iframe>
<%

}
 %>
 
</body>
</html>