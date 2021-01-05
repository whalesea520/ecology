
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
        mouldID:"<%= MouldIDConst.getID("offical")%>",
        staticOnLoad:true
    });
 
 }); 
</script>

<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String url = "";
	if(_fromURL.equals("1")||_fromURL.equals("")){//分部代字
		url = "/docs/sendDoc/DocReceiveUnitRight.jsp?isWfDoc="+kv.get("isWfDoc")+"&refresh="+kv.get("refresh")+"&subcompanyid="+kv.get("subcompanyid");
	}else if(_fromURL.equals("2")){//部门代字
		url = "/docs/sendDoc/DocReceiveUnitEdit.jsp?isWfDoc="+kv.get("isWfDoc")+"&refresh="+kv.get("refresh")+"&id="+kv.get("id")+"&subcompanyid="+kv.get("subcompanyid");
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
		        <li class="defaultTab" >
		        	<a href="#" target="tabcontentframe">
						<%=TimeUtil.getCurrentTimeString() %>
					</a>
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

