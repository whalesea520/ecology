<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<!-- Added by wcd 2015-04-29[调休管理-左侧树] -->
<%
	String cmd = strUtil.vString(request.getParameter("cmd"), "set");
	String xmlPath = cmd.equals("set") ? "/frameleftXML.jsp?rightStr=HrmPaidLeave:setting&setcom=true" : "/hrm/tree/HrmCompany_XML.jsp?rightStr=HrmPaidLeaveTime:search";
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<script type="text/javascript" src="/js/xtree_wev8.js"></script>
		<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
		<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
		<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
		<script type="text/javascript">
			if (window.jQuery.client.browser == "Firefox") {
				jQuery(document).ready(function () {
					jQuery("#deeptree").css("height", jQuery(document.body).height());
				});
			}
		</script>
	</HEAD>
	<BODY onload="initTree()">
		<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/HrmTab.jsp?_fromURL=paidLeave" method=post target="contentframe">
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<script>rightMenu.style.visibility='hidden';</script>
			<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
			<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
				<tr>
					<td class="leftTypeSearch">
						<div>
							<span class="leftType"><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%><span id="totalDoc"></span></span>
							<span class="leftSearchSpan">
								&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<td style="width:23%;" class="flowMenusTd">
						<div id="deeptree" class="cxtree" style="overflow:hidden;" CfgXMLSrc="/css/TreeConfig.xml" />
					</td> 
				</tr>
			</table>
			<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(strUtil.vString(request.getParameter("sqlwhere")))%>'>
			<input type="hidden" name="tabid" >
			<input type="hidden" name="companyid" >
			<input type="hidden" name="subcompanyid" >
			<input type="hidden" name="departmentid" >
			<input type="hidden" name="nodeid" >
			<input type="hidden" name="cmd" value="<%=cmd%>">
		</FORM>
		<script language="javascript">
			function initTree(){
				CXLoadTreeItem("", "<%=xmlPath%>");
				var tree = new WebFXTree();
				tree.add(cxtree_obj);
				document.getElementById('deeptree').innerHTML = tree;
				cxtree_obj.expand();
			}

			function showcom(node){}

			function check(node){}
			
			function setCompany(nodeid){
				if(nodeid == "com_1") return;
				document.all("departmentid").value = "";
				document.all("subcompanyid").value = "0";
				document.SearchForm.submit();
			}
			
			function setSubcompany(nodeid){
				subid = nodeid.substring(nodeid.lastIndexOf("_")+1);
				document.all("departmentid").value = "";
				document.all("subcompanyid").value = subid;
				document.SearchForm.submit();
			}

			function setDepartment(nodeid){
				deptid = nodeid.substring(nodeid.lastIndexOf("_")+1);
				document.all("departmentid").value = deptid;
				document.all("subcompanyid").value = "";
				document.SearchForm.submit();
			}
		</script>
	</BODY>
</HTML>