<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
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
        mouldID:"<%= MouldIDConst.getID("assest")%>",
        hideSelector:"#cptassortmenttree2box",
        staticOnLoad:true
    });
});

window.notExecute = true;
</script>
<!-- 自定义设置tab页 -->
<%
	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String url = "";
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	int parentid =Util.getIntValue( Util.null2String((String)kv.get("paraid")),0);//
	String isdata=Util.null2String( request.getParameter("isdata")) ;
	String from=Util.null2String( request.getParameter("from")) ;
	
	if("1".equals(isdata)){
		url = "/cpt/search/SearchOperation.jsp?from=cptsearch&type=searchcptdata1&isdata=1";
	}else{
		url = "/cpt/search/SearchOperation.jsp?from=cptsearch&type=searchcptdata2&isdata=2";
	}
	
	//首次进入跳转到查询条件页面
	String initDisplayCptSearchCondition= Util.null2String( (String)session.getAttribute("initDisplayCptSearchCondition"));
	session.removeAttribute("initDisplayCptSearchCondition");
	
	if("1".equals(initDisplayCptSearchCondition) ){
		if("1".equals(isdata)){
			url = "/cpt/search/CptSearchCondition.jsp?from=cptsearch&type=searchcptdata1&isdata=1";
		}else{
			url = "/cpt/search/CptSearchCondition.jsp?from=cptsearch&type=searchcptdata2&isdata=2";
		}
	}
	
	if("quick".equalsIgnoreCase(from)){//快速搜索
		url="/cpt/search/CptSearchResult.jsp?from=quick";
	}
	
	if(parentid>0){
		url+="&capitalgroupid="+parentid;
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
		    <ul class="tab_menu" id="cptseachtab_ul">
		        <%--
		        	<li class='e8_tree' >
			        	<a onclick='javascript:void(0);'>&lt;&lt;结构</a>
			        </li>
		         --%>
					<li class="" isdata='<%=isdata %>' >
						<a target="tabcontentframe" class="defaultTab" onclick='return false' href="<%=url %>"></a>
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

