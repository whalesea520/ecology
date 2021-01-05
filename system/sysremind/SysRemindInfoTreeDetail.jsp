
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragrma","no-cache");
    response.setDateHeader("Expires",0);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
  <head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" /> 
    <meta http-equiv="Cache-Control" content="no-cache" /> 
    <meta http-equiv="Expires" content="0" />
    
    <script type="text/javascript" src="/js/xtree_wev8.js"></script>
    <script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
    <script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
    <link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
    <base target="mainFrame"/>
  </head>

  <body oncontextmenu="return false;">
    <script type="text/javascript">
      /// XP Look
      webFXTreeConfig.rootIcon        = "/images/xp/folder_wev8.png";
      webFXTreeConfig.openRootIcon    = "/images/xp/openfolder_wev8.png";
      webFXTreeConfig.folderIcon      = "/images/xp/folder_wev8.png";
      webFXTreeConfig.openFolderIcon  = "/images/xp/openfolder_wev8.png";
      webFXTreeConfig.fileIcon        = "/images/xp/file_wev8.png";
      webFXTreeConfig.lMinusIcon      = "/images/xp/Lminus_wev8.png";
      webFXTreeConfig.lPlusIcon       = "/images/xp/Lplus_wev8.png";
      webFXTreeConfig.tMinusIcon      = "/images/xp/Tminus_wev8.png";
      webFXTreeConfig.tPlusIcon       = "/images/xp/Tplus_wev8.png";
      webFXTreeConfig.iIcon           = "/images/xp/I_wev8.png";
      webFXTreeConfig.lIcon           = "/images/xp/L_wev8.png";
      webFXTreeConfig.tIcon           = "/images/xp/T_wev8.png";
  
      var rti;
      var tree = new WebFXTree();
      
      tree.add(rti = new WebFXLoadTreeItem("", "SysRemindInfoTreeRealize.jsp"));
      document.write("<tr valign='bottom'><td><img src='/images/treeimages/global_wev8.gif' width='16' height='16'><span class='webfx-tree-item'><%= SystemEnv.getHtmlLabelName(19090,user.getLanguage()) %></span></td></tr>");
      
      document.write("<table width=100% cellspacing='0' cellpadding='0'>");
     document.write("<tr><td>"); 

      document.write(tree);
      
      document.write("</td></tr>");
      document.write("</table>");
      
      rti.expand();
    </script>
	<style type="text/css">
		
		
		#webfx-tree-object-4{
			display: none!important;
		}
		body {
			margin-top: 5px!important;
			margin-left: 2px;
			overflow: hidden;
		}
		table {
			margin-top: -18;
			*margin-top: 0!important;
		}
		
	</style>
  </body>
</html>
