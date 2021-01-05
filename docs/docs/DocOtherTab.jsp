
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<%String navName = ""; %>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = kv.get("_fromURL");
	String url = "";
	String mouldid = "doc";
	if(_fromURL.equals("1")){//签章设置
		navName = SystemEnv.getHtmlLabelName(16473,user.getLanguage());
		url = "/docs/docs/SignatureList.jsp";
		mouldid = "resource";
	}else if(_fromURL.equals("2")){//图片上传
		url = "/docs/tools/DocPicUpload.jsp";
		navName = SystemEnv.getHtmlLabelName(32480,user.getLanguage());
	}else if(_fromURL.equals("3")){//应用设置
		url = "/docs/search/DocProp.jsp";
		navName = SystemEnv.getHtmlLabelName(31811,user.getLanguage());
	}else if(_fromURL.equals("4")){//批量上传
		url = "/docs/docupload/MultiDocMaint.jsp";
		navName = SystemEnv.getHtmlLabelName(21400,user.getLanguage());
	}
	
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID(mouldid)%>",
        staticOnLoad:true,
        objName:"<%=navName %>"
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
		    	<%if(_fromURL.equals("2")){//图片上传 %>
		    		<li class="current">
		    			<a href="/docs/tools/DocPicUpload.jsp" id="imgAll" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>
		    		</li>
		    		<li>
		    			<a href="/docs/tools/DocPicUpload.jsp?imagetype=1" id="newImg" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(2009,user.getLanguage())%></a>
		    		</li>
		    		<li>
		    			<a href="/docs/tools/DocPicUpload.jsp?imagetype=3" id="newBg" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(2010,user.getLanguage())%></a>
		    		</li>
		    		<li>
		    			<a href="/docs/tools/DocSysDefaults.jsp" target="tabcontentframe" id="imgSet"><%=SystemEnv.getHtmlLabelName(22923,user.getLanguage())%></a>
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

