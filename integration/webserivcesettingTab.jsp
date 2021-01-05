
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
if(!HrmUserVarify.checkUserRight("intergration:webserivcesetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}

	String navName = "";
	String urlType = Util.null2String((String)request.getParameter("urlType"));
	String id = Util.null2String((String)request.getParameter("id"));
	String queryString=request.getQueryString();
	if("".equals(urlType)){
		urlType="1";
	}
	String url = "/integration/webserivcesetting.jsp";
	if("1".equals(urlType)){
		navName =SystemEnv.getHtmlLabelName(33717 ,user.getLanguage());
		url = "/integration/webserivcesetting.jsp?"+request.getQueryString();
	}else if("2".equals(urlType)){
		String sql = "";
		if(!"".equals(id)){
			sql = "select * from wsregiste where id="+id;
			rs.executeSql(sql);
			if(rs.next()){
				navName = Util.null2String(rs.getString("customname"));
			}
		}else{
			navName = SystemEnv.getHtmlLabelName(33717 ,user.getLanguage());
		}
		url = "/integration/webserivcesetting.jsp?"+request.getQueryString();
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