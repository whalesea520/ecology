<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.templetecheck.ConfigUtil" %>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	  return;
	}
	String navName = "";
	String urlType = Util.null2String((String)request.getParameter("urlType"));
	String url = "";
	
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("checkfile")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"文件检测"
    });
}); 
</script>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
					  <ul class="tab_menu">
					  <%
					  int i=0;
					  ConfigUtil configUtil = new ConfigUtil();
					  LinkedHashMap<String,ArrayList<String>>  tabs = configUtil.getalltabs();
					  Iterator ite = tabs.entrySet().iterator();
					  while(ite.hasNext()) {
					  	Map.Entry entry = (Entry)ite.next();
					  	String key  = (String)entry.getKey();
					  	ArrayList<String> value  = (ArrayList<String>)entry.getValue();
					  	String name = value.get(0);
					  	String ishtml  = value.get(1);
					  	String tmphref = "matchrule.jsp";
					  	if("3".equals(ishtml)) {//0--流程模板 1--KB包xml配置文件 2--web.xml 3.其他 4.Properties文件  5.xml文件
					  		tmphref = "matchrule.jsp";
					  	} else  if("0".equals(ishtml)) {
					  		tmphref = "matchruleHtml.jsp";
					  	}  else {
					  		tmphref = "matchruleConfig.jsp";
					  	}
					  	if(i==0) {
					  		url = tmphref+"?tabtype="+key+"&ishtml="+ishtml;
					  	}
					  %>
					    <li <%if(i==0){ %>class='current'<%} %>>
					    	<a href="<%=tmphref %>?tabtype=<%=key %>&ishtml=<%=ishtml %>" target="tabcontentframe">
					    		<%=name %>
					    	</a>
					    </li>
					    <% i++;
					    } %>
					    </ul>
				    <div id="rightBox" class=" e8_rightBox">
				    </div>
				    </div>
		</div>
	</div>
				    
				    <div class="  tab_box">
				        <div>
				            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				        </div>
				    </div>
	</div>
</body>
</html>