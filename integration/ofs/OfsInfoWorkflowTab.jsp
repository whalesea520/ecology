
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
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
	String navName = "";
	String urlType = Util.null2String((String)request.getParameter("urlType"));
	String id = Util.null2String((String)request.getParameter("id"));
	String queryString=request.getQueryString();
	if("".equals(urlType)){
	urlType="1";
	}
	String url = "/integration/ofs/OfsInfoDetailAdd.jsp?"+queryString;
	if("1".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("16579,127023",user.getLanguage());//流程类型注册信息
		url = "/integration/ofs/OfsInfoWorkflowAdd.jsp?"+queryString;
	}else if("2".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("16579,127023",user.getLanguage());//编辑异构系统注册信息
		url = "/integration/ofs/OfsInfoWorkflowEdit.jsp?"+queryString;
	}else if("3".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("22244,361,563",user.getLanguage());//流程详细数据
		url = "/integration/ofs/OfsToDodataView.jsp?"+queryString;
	}else if("4".equals(urlType)){
	    navName = SystemEnv.getHtmlLabelNames("16579,527",user.getLanguage());//流程类型查询
		url = "/integration/ofs/OfsWorkflowBrowser.jsp?"+queryString;
	}

%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("integration")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"<%=navName%>"
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
						<li class='current'>
					    	<a href="<%=url%>" target="tabcontentframe">
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