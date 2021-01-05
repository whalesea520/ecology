
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String navName = "";
	String url = "";
	if(_fromURL.equals("1")){//发文字号
		url = "/docs/sendDoc/docNumber.jsp";
		navName = SystemEnv.getHtmlLabelName(16980,user.getLanguage());
	}else if(_fromURL.equals("2")){//秘密等级
		url = "/docs/sendDoc/docSecretLevel.jsp";
		navName = SystemEnv.getHtmlLabelName(16972,user.getLanguage());
	}else if(_fromURL.equals("3")){//公文种类
		url = "/docs/sendDoc/docKind.jsp";
		navName = SystemEnv.getHtmlLabelName(16973,user.getLanguage());
	}else if(_fromURL.equals("4")){//紧急程度
		url = "/docs/sendDoc/docInstancyLevel.jsp";
		navName = SystemEnv.getHtmlLabelName(15534,user.getLanguage());
	}
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:0,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("offical")%>",
        objName:"<%=navName %>",
        staticOnLoad:true
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
		    	<%-- <li class="<%=_fromURL.equals("1")?"current":"" %>">
		        	<a href="/docs/sendDoc/DocNumber.jsp" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16980,user.getLanguage()) %></a>
		        </li>
		        <li class="<%=_fromURL.equals("2")?"current":"" %>">
		        	<a href="/docs/sendDoc/docSecretLevel.jsp" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16972,user.getLanguage()) %></a>
		        </li>
		        <li class="<%=_fromURL.equals("3")?"current":"" %>">
		        	<a href="/docs/sendDoc/docKind.jsp" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16973,user.getLanguage()) %></a>
		        </li>
		        <li class="<%=_fromURL.equals("4")?"current":"" %>">
		        	<a href="/docs/sendDoc/docInstancyLevel.jsp" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage()) %></a>
		        </li>--%>
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

