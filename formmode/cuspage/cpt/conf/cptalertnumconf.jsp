<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        staticOnLoad:true
    });
}); 
</script>

<%
	String queryString=Util.null2String(request.getQueryString());
	String from=Util.null2String(request.getParameter("from"));
	String url = "/formmode/cuspage/cpt/conf/cptalertnumconftab.jsp?"+queryString;
	String title = SystemEnv.getHtmlLabelName(125633,user.getLanguage());
	
	//是否分权系统，如不是，则不显示框架，直接转向到列表页面
//	rs.executeSql("select cptdetachable from SystemSet");
//	int detachable=0;
//
//	if(rs.next()){
//		detachable=rs.getInt("cptdetachable");
//		session.setAttribute("cptdetachable",String.valueOf(detachable));
//	}
//	if(detachable==1&&"".equals(from)){
//		response.sendRedirect("/cpt/maintenance/CptDetachableFrame.jsp?from=cptalertnumconf");
//		return;
//	}
	
	
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
		    <%--<%--%>
		    <%--if(detachable==1){--%>
		    	<%--%>--%>
		    	<%--<li class="e8_tree">--%>
		        	<%--<a id="togglelink" onclick="">&lt;&lt;结构</a>--%>
		        <%--</li>--%>
		    	<%--<%--%>
		    <%--}--%>
		    <%--%>--%>
		       	<li><a href="#" onclick="return false" class="defaultTab" target="tabcontentframe"><%=title %></a></li>
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
</BODY>
</HTML>
