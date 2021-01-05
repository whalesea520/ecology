<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-20[排班设置] Generated from 长东设计 www.mfstyle.cn -->
<%
	String rightStr = strUtil.vString(request.getParameter("rightStr"));
	String xmlPath = "/frameleftXML.jsp?rightStr="+rightStr+"&setcom=true";
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<link rel="stylesheet" type="text/css" href="/css/xtree2_wev8.css">
		<script type="text/javascript" src="/js/xtree_wev8.js"></script>
		<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
		<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
		<script type="text/javascript">
			if (window.jQuery.client.browser == "Firefox") {
				jQuery(document).ready(function () {
					jQuery("#deeptree").css("height", jQuery(document.body).height());
				});
			}
		</script>
	</head>
	<body onload="initTree()">
		<form id="weaver" name="SearchForm" style="margin-bottom:0" action="/hrm/schedule/hrmScheduleSet/tab.jsp?topage=list" method="post" target="contentframe">
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<script>rightMenu.style.visibility='hidden';</script>
			<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
			<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;">
				<tr>
					<td class="leftTypeSearch">
						<div>
							<span class="leftType"><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%><span id="totalDoc"></span></span>
							<span class="leftSearchSpan">&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/></span>
						</div>
					</td>
				</tr>
				<tr>
					<td style="width:23%;" class="flowMenusTd">
						<div id="deeptree" class="cxtree" style="overflow:hidden;" CfgXMLSrc="/css/TreeConfig.xml"/>
					</td>
				</tr>
			</table>
			<input type="hidden" name="tabid">
			<input type="hidden" name="companyid">
			<input type="hidden" name="subcompanyid">
			<input type="hidden" name="departmentid">
			<input type="hidden" name="nodeid">
		</form>
		<script type="text/javascript">
			function initTree() {
				CXLoadTreeItem("", "<%=xmlPath%>");
				var tree = new WebFXTree();
				tree.add(cxtree_obj);
				document.getElementById('deeptree').innerHTML = tree;
				cxtree_obj.expand();
			}

			function showcom(node) {
				
			}

			function check(node) {
				
			}

			function setCompany(nodeid) {
				$GetEle("subcompanyid").value = "0";
				document.SearchForm.action = getAction();
				document.SearchForm.submit();
			}

			function setSubcompany(nodeid) {
				subid = nodeid.substring(nodeid.lastIndexOf("_")+1);
				$GetEle("departmentid").value = "";
				$GetEle("subcompanyid").value = subid;
				document.SearchForm.action = getAction();
				document.SearchForm.submit();
			}

			function setDepartment(nodeid) {
				deptid = nodeid.substring(nodeid.lastIndexOf("_")+1);
				$GetEle("departmentid").value = deptid;
				$GetEle("subcompanyid").value = "";
				document.SearchForm.action = getAction();
				document.SearchForm.submit();
			}
			function getAction() {
				return "/hrm/schedule/hrmScheduleSet/tab.jsp?topage=list&"+$("#weaver").serialize();
			}

		</script>
	</body>
</html>
