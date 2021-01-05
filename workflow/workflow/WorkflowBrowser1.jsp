
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkFlowTree" class="weaver.workflow.workflow.WorkFlowTree" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
</HEAD>

<BODY>
<%
int uid=user.getUID();
int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0);
List grouplist=WorkFlowTree.getWrokflowTree(user,isTemplate);
String isWorkflowDoc=Util.null2String(request.getParameter("isWorkflowDoc"));
//System.out.println("nodes"+grouplist.size());
request.setAttribute("grouplist",grouplist);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String iswfec = Util.null2String(request.getParameter("iswfec"));
%>
<form name="SearchForm" style="margin-bottom:0" action="/workflow/workflow/WorkflowSelect.jsp" method="post" target="frame2">
  <table width=100% class="ViewForm" valign="top" height="100%">
		<!--######## Search Table Start########-->
		<TR>
		<td height=170 width="100%">
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
		<td>
		</tr>
	</table>

  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="typeid" >
  <input class=inputstyle type="hidden" name="isTemplate">
  <input class="inputstyle" type="hidden" id="iswfec" name="iswfec" value="<%=iswfec %>" />
  <input class=inputstyle type="hidden" name="isWorkflowDoc" value="<%=isWorkflowDoc %>">
</form>

<script language="javascript">
  
	function setGroup(id){
	    document.all("isTemplate").value=id
	    document.all("tabid").value=1
	    document.all("typeid").value=""
	    document.SearchForm.submit();
	}

	function setWorkflowType(template,id){
	    document.all("isTemplate").value=template
	    document.all("typeid").value=id
	    document.all("tabid").value=1
	    document.SearchForm.submit();
	}
	
	function initTree() {
		CXLoadTreeItem("", "/workflow/workflow/WorkflowXML.jsp?init=true&operatelevel=0&type=multiworkflowtype");
		var tree = new WebFXTree();
		tree.add(cxtree_obj);
		document.getElementById('deeptree').innerHTML = tree;
		cxtree_obj.expand();
	}
	//to use xtree,you must implement top() and showcom(node) functions

	function top111() {
	}
	function showcom(node) {
	}

	function setWorkflowType(nodeid) {
		document.all("tabid").value = 1;
	    var typeid = nodeid.substring(nodeid.lastIndexOf("_") + 1);
	    document.all("typeid").value = typeid;
	    document.SearchForm.submit();
	}

	function setSubCompany() {
	}

	jQuery(document).ready(function() {
		initTree();
	});
</script>
 
</BODY>
</HTML>