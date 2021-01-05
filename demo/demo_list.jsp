<!DOCTYPE html>
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
<!-- 引入弹出窗口的相关js -->
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<%
	String navName = "分页组件Demo";
	int _fromURL = Util.getIntValue(request.getParameter("_fromURL"),0);

	String url = "";
	if(_fromURL==0){
	    url = "/demo/demo_listdb.jsp";
	}else if(_fromURL==1){
	    url = "/demo/demo_listds.jsp";
	}else if(_fromURL==2){
	    url = "/demo/demo_listot.jsp";
	}else if(_fromURL==3){
	    url = "/demo/demo_listall.jsp";
	}else if(_fromURL==4){
	    url = "/demo/demo_dialog.jsp";
	}
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 

jQuery(document).ready(function(){ setTabObjName("<%=navName%>"); });//设置名称
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
			        <li <%if(_fromURL==0){%> class="current"<%} %>>
				        <a href="/demo/demo_listdb.jsp?_fromURL=0" target="tabcontentframe">查询数据库分页</a>
				    </li>
				    <li <%if(_fromURL==1){%> class="current"<%} %>>
					  	<a href="/demo/demo_listds.jsp?_fromURL=1" target="tabcontentframe">查询外部数据分页</a>
					</li>
					<li <%if(_fromURL==2){%> class="current"<%} %>>
					  	<a href="/demo/demo_listot.jsp?_fromURL=2" target="tabcontentframe">分页控件数据汇总</a>
					</li>
					<li <%if(_fromURL==3){%> class="current"<%} %>>
                    	<a href="/demo/demo_listall.jsp?_fromURL=3" target="tabcontentframe">表单布局+分页</a>
                    </li>
                    <li <%if(_fromURL==4){%> class="current"<%} %>>
                        <a href="/demo/demo_listall.jsp?_fromURL=4" target="tabcontentframe">弹出窗口实例</a>
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
<script type="text/javascript">
	function mnToggleleft(){
		var f = window.parent.oTd1.style.display;
		if (f != null) {
			if(f==''){
				window.parent.oTd1.style.display='none';
			}else{ 
				window.parent.oTd1.style.display='';
				var divHeght = window.parent.wfleftFrame.setHeight();
			}
		}
	}
</script>
</html>
