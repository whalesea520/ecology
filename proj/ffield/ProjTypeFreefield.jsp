
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
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("proj")%>",
        staticOnLoad:true
    });
});

function refreshTab(){
	jQuery('.flowMenusTd',parent.document).toggle();
	jQuery('.leftTypeSearch',parent.document).toggle();
} 


</script>
<!-- 自定义设置tab页 -->
<%
	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String url = "";
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	int parentid =Util.getIntValue( Util.null2String((String)kv.get("paraid")),0);
	
	url = "/proj/ffield/editPrjTypeFieldBatch.jsp?ajax=1";//批量添加字段
	//url = "/proj/ffield/prjTypeCusFieldList.jsp?1=1";
	if(parentid>0){
		url+="&proTypeId="+parentid;
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
		    
		    	<li class="e8_tree">
			        	<a onclick="">&lt;&lt;结构</a>
			    </li>
		       	<li class="current">
					<a target="tabcontentframe" href="/proj/ffield/editPrjTypeFieldBatch.jsp?1=1&proTypeId=<%=parentid %>"><%=SystemEnv.getHtmlLabelName(21903 ,user.getLanguage()) %></a>
				</li>
				<li>
					<a target="tabcontentframe" href="/proj/ffield/addprjtypeFieldlabel.jsp?ajax=1&proTypeId=<%=parentid %>"><%=SystemEnv.getHtmlLabelName(32815,user.getLanguage()) %></a>
				</li>
				<li><a target="tabcontentframe" href="/proj/ffield/editPrjFieldGroup.jsp?ajax=1" >分组设置</a></li>
						
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

