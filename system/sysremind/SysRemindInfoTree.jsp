<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<link type="text/css" rel="stylesheet"  href="/css/Weaver_wev8.css"/>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css"/>
<link type="text/css" rel="stylesheet"  href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css"/>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<script type="text/javascript" src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(document.body).height());
	});
}
window.__hideExpandOrCollapseDiv = true;

function initTree(){
	CXLoadTreeItem("", "SysRemindInfoTreeRealize.jsp");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}
</script>
</head>


<body onload="initTree();">
	<form name=SearchForm style="margin-bottom: 0" action="" method=post target="contentframe">
		<table cellspacing="0" cellpadding="0" class="flowsTable" style="width: 100%; height: 100%;">
			<tr>
				<td style="width: 23%;" class="flowMenusTd">
					<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="background-color: #f8f8f8; width: 220px; margin-top: 10px; overflow: hidden;" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>