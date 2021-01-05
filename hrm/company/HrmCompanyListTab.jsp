
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
        iframe:"subtabcontentframe",
        staticOnload:true
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
	String url = "";
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	if(_fromURL.equals("HrmSubCompanyList")){
		//下级机构 部门
		title = 0;
		String id=Util.null2String((String)kv.get("id"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmSubCompanyList.jsp?id="+id;
	} else if(_fromURL.equals("HrmDepartList")){
		//下级 部门 部门人员
		title = 0;
		String id=Util.null2String((String)kv.get("id"));
		if(id.length()==0)id="0";
		url = "/hrm/company/HrmDepartmentList.jsp?cmd=department&id="+id;
	}
%>
</head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
		    <ul class="tab_menu">
		        <li class="e8_tree">
		        	<a onclick="javascript:refreshTab();"><%=title==0?"":SystemEnv.getHtmlLabelName(title,user.getLanguage()) %></a>
		        </li>
						<%if(_fromURL.equals("HrmSubCompanyList")){ 
							String id=Util.null2String((String)kv.get("id"));
						%>
						<li class="current">
							<a target="subtabcontentframe" href="/hrm/company/HrmSubCompanyList.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(17898,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="subtabcontentframe" href="/hrm/company/HrmDepartmentList.jsp?cmd=subcompany&id=<%=id%>"><%=SystemEnv.getHtmlLabelName(27511 ,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("HrmDepartList")){
							String id=Util.null2String((String)kv.get("id"));
						%>
						<li class="current">
							<a target="subtabcontentframe" href="/hrm/company/HrmDepartmentList.jsp?cmd=department&id=<%=id%>"><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="subtabcontentframe" href="/hrm/company/HrmResourceList.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(179 ,user.getLanguage()) %></a>
						</li>
						<%} %> 
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe onload="update()" src="<%=url %>" id="subtabcontentframe" name="subtabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

