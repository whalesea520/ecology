
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id"));
	String method = Util.null2String(request.getParameter("method"));
	String name=SystemEnv.getHtmlLabelName(32689,user.getLanguage());
	RecordSet.execute("select name from wechat_platform where id="+id);
	if(RecordSet.next()){
		name=RecordSet.getString("name");
	}
	
	String from = Util.null2String(request.getParameter("from"));
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("communicate")%>",
        objName:"<%=name%>"
    });
    
  
});


</script>

<%
	int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
	String url = "/wechat/platformEdit.jsp";
	if("menu".equals(method)){
		url = "/wechat/platformMenu.jsp";
	}else if("event".equals(method)){
		url = "/wechat/eventList.jsp";
	}else if("used".equals(method)){
		url = "/wechat/platformShareList.jsp";
	}else if("setup".equals(method)){
		url = "/wechat/platformSetup.jsp";
	}
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
	}
%>

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
		        	 <li  <%	if ("edit".equals(method) || "".equals(method)) {%> class="current" <%} %>>
			        	<a href="/wechat/platformEdit.jsp?dialog=1&id=<%=id %>&method=edit&from=<%=from %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li <%	if ("menu".equals(method)) {%> class="current" <%} %>>
			        	<a href="/wechat/platformMenu.jsp?dialog=1&id=<%=id %>&method=menu&from=<%=from %>"  target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li <%	if ("event".equals(method)) {%> class="current" <%} %>>
			        	<a href="/wechat/eventList.jsp?dialog=1&id=<%=id %>&method=event&from=<%=from %>"  target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(32693,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li <%	if ("used".equals(method)) {%> class="current" <%} %>>
			        	<a href="/wechat/platformShareList.jsp?dialog=1&id=<%=id %>&method=used&from=<%=from %>"  target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(19910,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li <%	if ("setup".equals(method)) {%> class="current" <%} %>>
			        	<a href="/wechat/platformSetup.jsp?dialog=1&id=<%=id %>&method=shangeShare&from=<%=from %>"  target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(18166,user.getLanguage()) %>
			        	</a>
			        </li>
				    </ul>
				    <div id="rightBox" class="e8_rightBox">
				    </div>
			    </div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>