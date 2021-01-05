<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<html>
<head>
<title></title>

<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
<base target="mainFrame"/>
</head>
<body oncontextmenu="return false;">
<script type="text/javascript">
/// XP Look
webFXTreeConfig.rootIcon		= "/images/xp/folder_wev8.png";
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder_wev8.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder_wev8.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder_wev8.png";
//webFXTreeConfig.fileIcon		= "/images/xp/file_wev8.png";
webFXTreeConfig.fileIcon		= "/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif";
webFXTreeConfig.lMinusIcon		= "/images/xp/Lminus_wev8.png";
webFXTreeConfig.lPlusIcon		= "/images/xp/Lplus_wev8.png";
webFXTreeConfig.tMinusIcon		= "/images/xp/Tminus_wev8.png";
webFXTreeConfig.tPlusIcon		= "/images/xp/Tplus_wev8.png";
webFXTreeConfig.iIcon			= "/images/xp/I_wev8.png";
webFXTreeConfig.lIcon			= "/images/xp/L_wev8.png";
webFXTreeConfig.tIcon			= "/images/xp/T_wev8.png";

var rti;
var tree = new WebFXTree();
<%if(Util.null2String(request.getParameter("extra")).equals("myReport")){%>
tree.add(rti = new WebFXLoadTreeItem("", "SysSettingTree.jsp?parentid=10"));
<%}else{%>
tree.add(rti = new WebFXLoadTreeItem("", "SysSettingTree.jsp"));
<%}%>
document.write(tree);
rti.expand();
</script>

</body>
</html>
