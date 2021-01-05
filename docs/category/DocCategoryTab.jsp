
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/tabs/expandCollapse_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        staticOnLoad:true,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("doc")%>",
        hideSelector:"#seccategorybox,#seccategoryboxright"
    });
});

</script>

<%
	String url = "";
	String isFromMonitor = Util.null2String(request.getParameter("isFromMonitor"));
	HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	if(_fromURL.equals("0")||"".equals(_fromURL)){//目录设置主页
		url = "/docs/category/DocMainCategoryList.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("1")){//目录设置--主目录基本信息
		url = "/docs/category/DocMainCategoryBaseInfoEdit.jsp?id="+kv.get("id")+"&"+request.getQueryString();
	}else if(_fromURL.equals("2")){//目录设置--分目录基本信息
		url = "/docs/category/DocSubCategoryBaseInfoEdit.jsp?id="+kv.get("id")+"&"+request.getQueryString();
	}else if(_fromURL.equals("3")){//目录设置--子目录基本信息
		url = "/docs/category/DocSecCategoryBaseInfoEdit.jsp?id="+kv.get("id")+"&"+request.getQueryString();
	}else if(_fromURL.equals("4")){//字段管理
		url = "/docs/category/DocSecCategoryCusFieldList.jsp?"+request.getQueryString();
	}
	if(isFromMonitor.equals("1")){
		_fromURL="";
		url = "/system/systemmonitor/docs/DocMonitor.jsp?hasTab=1&_fromURL=5&isDetach=3&isFromMonitor=1&secCategory="+kv.get("id")+"&"+request.getQueryString();
	
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
				    	<%if(!_fromURL.equals("4")){ %>
					        <li class="e8_tree">
					        	<a onclick="javascript:refreshTab();">
					        	</a>
					        </li>
					     <%} %>
				        <%if(_fromURL.equals("1")){ %>
				        	 <li class="current" id="baseinfo">
					        	<a href="/docs/category/DocMainCategoryBaseInfoEdit.jsp?optype=0&id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocMainCategoryRightEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li id="sublist">
					        	<a href="/docs/category/DocMainCategoryBaseInfoEdit.jsp?optype=1&id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelNames("27170,66",user.getLanguage()) %>
					        	</a>
					        </li>
				        <%}else if(_fromURL.equals("2")){ %>
				        	 <li class="current" id="baseinfo">
					        	<a href="/docs/category/DocSubCategoryBaseInfoEdit.jsp?optype=0&id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocSubCategoryRightEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li id="sublist">
					        	<a href="/docs/category/DocSubCategoryBaseInfoEdit.jsp?optype=1&id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelNames("27170,67",user.getLanguage()) %>
					        	</a>
					        </li>
				        <%}else if(_fromURL.equals("3")){ %>
				        	 <li class="current">
					        	<a onmouseover="javascript:showSecTabMenu('#seccategorybox','tabcontentframe');"  href="/docs/category/DocSecCategoryBaseInfoEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocMainCategoryList.jsp?parentid=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(33112,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a onmouseover="javascript:showSecTabMenu('#seccategoryboxright','tabcontentframe');" href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=5&id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(19174,user.getLanguage()) %>
					        	</a>
					        </li>
					         <li>
					        	<a href="/docs/category/DocSecCategoryEditionEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(19450,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocSecCategoryCodeRuleEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(19542,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocSecCategoryTempletEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(16448,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocSecCategoryDocPropertiesEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(19451,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocSecCategoryCustomSearchEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(20237,user.getLanguage()) %>
					        	</a>
					        </li>
					        <li>
					        	<a href="/docs/category/DocSecCategoryApproveWfEdit.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())+SystemEnv.getHtmlLabelName(30835,user.getLanguage()) %>
					        	</a>
					        </li>
				        <%}else{ %>
				        	<li>
					        	<a href="#" class="defaultTab" target="tabcontentframe">
					        		<%=TimeUtil.getCurrentTimeString() %>
					        	</a>
					        </li>
				        <%} %>
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

