
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
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

<%
	String navName = "";
	int favouriteid = Util.getIntValue(Util.null2String(request.getParameter("id")),-1);
	String url = "/favourite/FavouriteList.jsp?favouriteid="+favouriteid;
	if(favouriteid>0)
	{
		String sql = " select * from favourite where id="+favouriteid;
		//System.out.println("select sql : "+sql);
		rs.executeSql(sql);
		if(rs.next())
		{
			navName = rs.getString("favouritename");
		}
	}
	else
	{
		navName = SystemEnv.getHtmlLabelName(18030 ,user.getLanguage());//"默认收藏";
	}
%>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("favourite")%>",
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
				    	<li class="e8_tree">
				        	<a href="#"></a>
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

