
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
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
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
	String navName = "";
	String urlType = Util.null2String((String)request.getParameter("urlType"));
	String id = Util.null2String(request.getParameter("id"));
	String queryString=request.getQueryString();
	if("".equals(urlType)){
	urlType="1";
	}
	String url = "/interface/outter/outter_encryptclassAdd.jsp?"+queryString;
	if("1".equals(urlType)){
		navName =SystemEnv.getHtmlLabelName(125409,user.getLanguage());
		url = "/interface/outter/outter_encryptclassAdd.jsp?"+queryString;
	}else if("2".equals(urlType)){
		if(!id.equals("")){
			rs.executeSql("select * from outter_encryptclass where id="+id+"");
			if(rs.next()){
				navName = Util.toScreenToEdit(rs.getString("encryptname"),user.getLanguage());
				//QC293709 [80]集成登录-加密算法设置页面，名称内含的符号未反转义
				navName = HtmlUtils.htmlUnescape(navName);
				navName = navName.replace("\\","\\\\");
				navName = navName.replace("\"","\\\"");
			}
		}else{
			navName =SystemEnv.getHtmlLabelName(125409,user.getLanguage());
		}
		url = "/interface/outter/outter_encryptclassEdit.jsp?"+queryString;
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
        objName:"<xmp><%=navName%></xmp>"
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
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
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