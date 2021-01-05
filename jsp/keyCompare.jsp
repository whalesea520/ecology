<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<HTML><head>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
        notRefreshIfrm:true,
        objName:"<%=SystemEnv.getHtmlLabelName(127698,user.getLanguage())%>"
    });
    
}); 
</script>
</head>
<BODY>

<% 
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(127698,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean isoracle = (rs.getDBType()).equals("oracle") ;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
			</ul>
			 <div id="rightBox" class="e8_rightBox">
				    </div>
			</div>
			
		</div>
	</div>
    <div class="tab_box" style="width:100%!important">
        <div style="height:100%!important">
            <iframe src="/jsp/keyGeneratorCompare2.jsp" class="flowFrame" style="width:100%;height:100%;border:0;" frameborder="0" scrolling="auto" marginwidth="0" marginheight="0"></iframe>
        </div>
    </div>
        </div>
    </div>
	</div>
</body>
</html>