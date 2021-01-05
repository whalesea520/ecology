<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String url="";
	String offical="";
	String urlType=Util.null2String(request.getParameter("urlType"));
	String secid=Util.null2String(request.getParameter("secid"));
	if("".equals(urlType)){
		urlType = "1";
	}
	if("1".equals(urlType)){
		url="/docs/remindfornew/remindInfoForEmail.jsp";
	}
	if("2".equals(urlType)){
		url="/docs/remindfornew/remindInfoForMessage.jsp";
	}
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString()+"&secid="+secid;
	}else{
		url += "?secid="+secid;
	}
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
        mouldID:"<%= MouldIDConst.getID(offical.equals("1")?"offical":"doc")%>",
        staticOnLoad:true,
        objName:"提醒内容"
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
						<li id="settingforemail" class="<%=urlType.equals("1")?"current":"" %>">
							<a href="/docs/remindfornew/remindInfoForEmail.jsp?secid=<%=secid%>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(18845,user.getLanguage()) %>
							</a>
						</li>
						<li id="settingformessage" class="<%=urlType.equals("2")?"current":"" %>">
							<a href="/docs/remindfornew/remindInfoForMessage.jsp?secid=<%=secid%>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage()) %>
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
