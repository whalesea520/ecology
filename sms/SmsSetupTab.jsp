
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%
if(!HrmUserVarify.checkUserRight("Sms:Set", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String method = Util.null2String(request.getParameter("method"));
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
        objName:"<%=SystemEnv.getHtmlLabelName(32949,user.getLanguage()) %>"
    });
    
  
});


</script>

<%
	String url = "/sms/SmsSetup.jsp";
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
		       
			        <li class="current">
			        	<a href="/sms/SmsSetup.jsp"  target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(16484,user.getLanguage()) %>
			        	</a>
			        </li>
		        	 <li>
			        	<a href="/sms/SmsSetupReminder.jsp" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(21946,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a href="/sms/SmsService.jsp?method=<%=method %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage()) %>
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
