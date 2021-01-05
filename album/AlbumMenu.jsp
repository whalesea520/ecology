
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="companyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String companyName = companyComInfo.getCompanyname("1");
%>
<!--
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
-->
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<base target="contentframe" />
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript" src="/js/album/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/album/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/album/xloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<style>body{margin:0px;}</style>
</head>
<script type="text/javascript">
  jQuery(document).ready(function(){
    jQuery("#mailTreeMenu").height(jQuery("#treeBody").height());
    jQuery("#treeBody").width(jQuery("#mailTreeMenu").width());
  }); 
  window.onresize=function(){ 
    jQuery("#mailTreeMenu").height(jQuery("#treeBody").height());
  }
</script>
<body id="treeBody" style="overflow: hidden" scroll="no">
<div id="mailTreeMenu" style="overflow: auto;">
<script type="text/javascript">
//====================================================================
// WebFxTree (sText, sAction, sBehavior, sIcon, sOpenIcon)
//====================================================================
webFXTreeConfig.rootIcon		= "/images/treeimages/global16_wev8.gif";
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder_wev8.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder_wev8.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder_wev8.png";
webFXTreeConfig.fileIcon		= "/images/xp2/file_wev8.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus_wev8.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus_wev8.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus_wev8.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus_wev8.png";
webFXTreeConfig.iIcon			= "/images/xp2/I_wev8.png";
webFXTreeConfig.lIcon			= "/images/xp2/L_wev8.png";
webFXTreeConfig.tIcon			= "/images/xp2/T_wev8.png";

var rti;
var tree = new WebFXLoadTree("<%=companyName%>","AlbumMenuTree.jsp","","","/images/treeimages/global16_wev8.gif","/images/treeimages/global16_wev8.gif");
document.write(tree);
//tree.expandAll();

// Refresh TreeMenu
function refrehMailTreeMenu(){
	$("mailTreeMenu").innerHTML = tree.toString();
}
</script>
</div>

</script>
</body>
</html>

<%!

%>