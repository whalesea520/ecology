
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/tabs/expandCollapse_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />


<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String url = "/web/webmagazine/WebMagazineTypeList.jsp";
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String navName = "";
	if(_fromURL.equals("1") || _fromURL.equals("")){//期刊设置列表
		url = "/web/webmagazine/WebMagazineTypeList.jsp";
		navName = SystemEnv.getHtmlLabelName(19099,user.getLanguage());
	}else if(_fromURL.equals("2")){//刊名
		url = "/web/webmagazine/WebMagazineList.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("3")){//刊号
		url = "/web/webmagazine/WebMagazineEdit.jsp?"+request.getQueryString();
	}
%>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
         mouldID:"<%= MouldIDConst.getID("doc")%>",
         staticOnLoad:true
    });
	setTabObjName("<%= navName %>");
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
		        	<a onclick="javascript:refreshTab();"></a>
		        </li>
		        <%if(_fromURL.equals("2")){ %>
		        	<li class="current" id="baseinfo">
			        	<a href="/web/webmagazine/WebMagazineList.jsp?optype=0&typeID=<%=kv.get("typeID") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li id="sublist">
			        	<a href="/web/webmagazine/WebMagazineList.jsp?optype=1&typeID=<%=kv.get("typeID") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("32869",user.getLanguage()) %>
			        	</a>
			        </li>
		        <%}else if(_fromURL.equals("3")){ %>
		        	<li class="current" id="baseinfo">
			        	<a href="/web/webmagazine/WebMagazineEdit.jsp?optype=0&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li id="sublist">
			        	<a href="/web/webmagazine/WebMagazineEdit.jsp?optype=1&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("31516,33368",user.getLanguage()) %>
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
	            <iframe onload="update();" src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

