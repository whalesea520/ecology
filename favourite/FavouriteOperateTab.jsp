
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%if(user.getLanguage()==7) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-cn-gbk_wev8.js'></script>
<%
}
else if(user.getLanguage()==8) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-en-gbk_wev8.js'></script>
<%
}
else if(user.getLanguage()==9) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-tw-gbk_wev8.js'></script>
<%
}
%>
<%
	int favouriteid = Util.getIntValue(Util.null2String((String)request.getParameter("favouriteid")),0);
	String url = "/favourite/FavouriteOperate.jsp?"+request.getQueryString();
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("favourite")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
       	objName:"<%=SystemEnv.getHtmlLabelNames("28111,92",user.getLanguage())%>"
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
				    	<li class="defaultTab">
							<a href="#" onclick="return false;" target="tabcontentframe">
						        <%=TimeUtil.getCurrentTimeString() %>
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
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>
</body>
</html>