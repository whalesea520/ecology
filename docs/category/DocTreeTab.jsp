
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("doc")%>",
        staticOnLoad:true
    });

}); 

</script>

<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String url = "/docs/category/DocTreeDocFieldRight.jsp";
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String tempUrl = url;
	if(_fromURL.equals("1") || _fromURL.equals("")){//根目录
		url = "/docs/category/DocTreeDocFieldRight.jsp";
	}else if(_fromURL.equals("2")){//子目录
		url = "/docs/category/DocTreeDocFieldEdit.jsp?id="+kv.get("id");
		tempUrl = "/docs/category/DocTreeDocFieldEdit.jsp?id="+kv.get("id");
	}else if(_fromURL.equals("3")){//子目录
		url = "/docs/category/DocTreeDocFieldEdit.jsp?optype="+kv.get("optype")+"&refresh=1&id="+kv.get("id");
		tempUrl = "/docs/category/DocTreeDocFieldEdit.jsp?id="+kv.get("id");
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
				        	<a href="#"></a>
				        </li>
				        <%if(_fromURL.equals("1") || _fromURL.equals("")){//根目录 %>
				        	<li class="current" id="baseinfo">
					        	<a href="/docs/category/DocTreeDocFieldRight.jsp?optype=0" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(1478,user.getLanguage())%>
					        	</a>
					        </li>
					        <li id="sublist">
					        	<a href="/docs/category/DocTreeDocFieldRight.jsp?optype=1" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(33112,user.getLanguage())%>
					        	</a>
					        </li>
				        <%}else if(_fromURL.equals("2")||_fromURL.equals("3")){ %>
				        	<li class="current" id="baseinfo">
					        	<a href="<%=tempUrl+"&optype=0" %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(1478,user.getLanguage())%>
					        	</a>
					        </li>
					        <li id="sublist">
					        	<a href="<%=tempUrl+"&optype=1" %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(33112,user.getLanguage())%>
					        	</a>
					        </li>
					        <li id="adminlist">
					        	<a href="/docs/category/DocTreeDocFieldAdmin.jsp?id=<%=kv.get("id") %>" target="tabcontentframe">
					        		<%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>
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

