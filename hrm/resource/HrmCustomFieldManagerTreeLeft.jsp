
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">

<base target="mainFrame"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
%>           
 <script type="text/javascript">
  var rti;
  var tree = new WebFXTree('');
  tree.setBehavior("explorer");
	tree.add(rti = new WebFXLoadTreeItem("<%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%>", "HrmCustomFieldManagerTreeLeftXML.jsp"));
	rti.icon = webFXTreeConfig.rootIcon;
	rti.openIcon = webFXTreeConfig.openRootIcon;
	document.getElementById('deeptree').innerHTML = tree;
	rti.expand();
 </script>
 <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" ></div>
 <FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmCustomFieldManagerTreeLeftXML.jsp" method=post target="contentframe">
 	<input type="hidden" name="id" id="id" value="">
 </FORM>   
<script type="text/javascript">
function onClickCustomField(id) {
	document.getElementById("id").value = id;
	document.SearchForm.action = "/hrm/HrmTab.jsp?_fromURL=HrmCustomFieldManager&id="+id;
	document.SearchForm.submit();
}
</script>
