
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
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("offical")%>",
        staticOnLoad:true
    });
 
 }); 
</script>

<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String url = "";
	if(_fromURL.equals("1")||_fromURL.equals("")){//主题词列表
		url = "/docs/sendDoc/WorkflowKeyword.jsp?refresh="+kv.get("refresh")+"&keywordId="+kv.get("keywordId");
	}else if(_fromURL.equals("2")){//主题词编辑
		url = "/docs/sendDoc/WorkflowKeywordEdit.jsp?optype="+kv.get("optype")+"&refresh="+kv.get("refresh")+"&id="+kv.get("id");
	}else if(_fromURL.equals("3")){//主题词编辑
		url = "/docs/sendDoc/WorkflowKeywordEdit.jsp?optype="+kv.get("optype")+"&refresh=1&id="+kv.get("id");
	}
%>

</head>
<BODY scroll="no">
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
		    	<li class="e8_tree">
		        	<a href="#"></a>
		        </li>
		        <%if(_fromURL.equals("2")||_fromURL.equals("3")){%>
		        	 <li class="current" id="baseinfo">
			        	<a href="/docs/sendDoc/WorkflowKeywordEdit.jsp?optype=0&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li id="sublist">
			        	<a href="/docs/sendDoc/WorkflowKeywordEdit.jsp?optype=1&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("27170,16978",user.getLanguage()) %>
			        	</a>
			        </li>
		        <%}else{ %>
			       <li class="defaultTab" >
			        	<a href="#" target="tabcontentframe">
							<%=TimeUtil.getCurrentTimeString() %>
						</a>
			        </li>
			     <%} %>
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

