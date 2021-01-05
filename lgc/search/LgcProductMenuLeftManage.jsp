<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css">
<base target="mainFrame"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
String searchName = URLDecoder.decode(Util.null2String(request.getParameter("searchName")),"UTF-8");
rs.executeSql(" select count(0) as s from LgcAsset t1,LgcAssetCountry t2 where t1.id=t2.assetid ");
rs.first();
int num = rs.getInt(1);
%>           
 <script type="text/javascript">
  var rti;
  var tree = new WebFXTree('');
  tree.setBehavior("explorer");
	tree.add(rti = new WebFXLoadTreeItem("<%=SystemEnv.getHtmlLabelName(15106,user.getLanguage())%>", "LgcProductMenuXML.jsp?searchName="+encodeURI(encodeURI("<%=searchName%>"))));
	rti.icon = webFXTreeConfig.rootIcon;
	rti.openIcon = webFXTreeConfig.openRootIcon;
	document.getElementById('deeptree').innerHTML = tree;
	$(".e8_num_xtree:first").html("<%=num %>");
	var roottree = $(".ulDiv").find("div[_id=div_root]");
	roottree.bind("click",function(){onClickCustomField("")});
	rti.expand();
 </script>
 <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" ></div>
 <FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcProductMenuXML.jsp" method=post target="contentframe">
 	<input type="hidden" name="id" id="id" value="">
 </FORM>   
<script type="text/javascript">
function onClickCustomField(id) {
	document.getElementById("id").value = id;
	document.SearchForm.action = "/lgc/search/LgcProductList.jsp?assortmentid="+id;
	document.SearchForm.submit();
}
</script>
