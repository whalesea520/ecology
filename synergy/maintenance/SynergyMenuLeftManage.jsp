
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css">
<base target="mainFrame"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
String stype = Util.null2String(request.getParameter("stype"));
String pagetype = Util.null2String(request.getParameter("pagetype"));
%>           
 <script type="text/javascript">
  var rti;
  var tree = new WebFXTree('');
  tree.setBehavior("explorer");
	tree.add(rti = new WebFXLoadTreeItem("", "/synergy/maintenance/SynergyMenuLeftXML.jsp?stype=<%=stype%>&pagetype=<%=pagetype%>"));
	rti.icon = webFXTreeConfig.rootIcon;
	rti.openIcon = webFXTreeConfig.openRootIcon;
	//console.log(tree);
	document.getElementById('deeptree').innerHTML = tree;
	var roottree = $(".ulDiv").find("div[_id=div_root]");
	roottree.bind("click",function(){onClickCustomField("")});
	rti.expand();
 </script>
 <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" ></div>
 <FORM NAME=SearchForm STYLE="margin-bottom:0" action="/synergy/maintenance/SynergyMenuLeftXML.jsp" method=post target="contentframe">
 	<input type="hidden" name="id" id="id" value="">
 	
 </FORM>   
<script type="text/javascript">
function onClickCustomField(id,wfid,stype,pagetype,isSynergypage) {
	if(id==="0")
	{
		document.getElementById("id").value = wfid;
		document.SearchForm.action = "/synergy/maintenance/SynergyDesign.jsp?wfid="+wfid+"&stype="+stype+"&pagetype="+pagetype;
	}
	else
	{
		document.getElementById("id").value = id;
		document.SearchForm.action = "/synergy/maintenance/SynergyDesign.jsp?hpid="+id+"&stype="+stype+"&pagetype="+pagetype;
	}
	if(pagetype === "operat" && (isSynergypage==="0" || isSynergypage === "1") )
	{
		document.SearchForm.action = "/synergy/maintenance/SynergyDesign.jsp?wfid="+wfid+"&stype="+stype;
	}
	document.SearchForm.submit();
}
</script>
