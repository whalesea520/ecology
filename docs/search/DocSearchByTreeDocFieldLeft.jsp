<%response.setHeader("Cache-Control","no-store");response.setHeader("Pragrma","no-cache");response.setDateHeader("Expires",0);%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
    int dummyId=Util.getIntValue(request.getParameter("dummyId"),1);
%>

<HTML>
<HEAD>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Pragma" content="no-cache" /> 
    <meta http-equiv="Cache-Control" content="no-cache" /> 
    <meta http-equiv="Expires" content="0" />
	
    <script type="text/javascript" src="/js/xtree_wev8.js"></script>
    <script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
    <script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
	
    <link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />

    <base target="mainFrame"/>

</HEAD>

<BODY oncontextmenu="return false;" onload="onClickTreeDocField(<%=dummyId%>);">


    <table width=100% class="ViewForm" valign="top">

        <TR>
            <td>
                
				    <script type="text/javascript">
				      // XP Look
				      webFXTreeConfig.rootIcon        = "/images/treemaker/clsfld_wev8.gif";
				      webFXTreeConfig.openRootIcon    = "/images/treemaker/openfld_wev8.gif";
				      webFXTreeConfig.folderIcon      = "/images/treemaker/clsfld_wev8.gif";
				      webFXTreeConfig.openFolderIcon  = "/images/treemaker/openfld_wev8.gif";
				      webFXTreeConfig.fileIcon        = "/images/treemaker/clsfld_wev8.gif";
				      webFXTreeConfig.lMinusIcon      = "/images/treemaker/tree_Lminus_wev8.gif";
				      webFXTreeConfig.lPlusIcon       = "/images/treemaker/tree_Lplus_wev8.gif";
				      webFXTreeConfig.tMinusIcon      = "/images/treemaker/tree_Tminus_wev8.gif";
				      webFXTreeConfig.tPlusIcon       = "/images/treemaker/tree_Tplus_wev8.gif";
				      webFXTreeConfig.iIcon           = "/images/treemaker/tree_I_wev8.gif";
				      webFXTreeConfig.lIcon           = "/images/treemaker/tree_L_wev8.gif";
				      webFXTreeConfig.tIcon           = "/images/treemaker/tree_T_wev8.gif";
				  	 
				      var tree = new WebFXTree();
				      tree.add(new WebFXLoadTreeItem("", "DocSearchByTreeDocFieldLeftXML.jsp"))
				      document.write(tree);
				      tree.expandAll();
				    </script>
            <td>
        </tr>
    </table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocTreeDocFieldDsp.jsp" method=post target="contentframe">
    <input type="hidden" name="dummyId">

    </FORM>
</BODY>
</HTML>

<script type="text/javascript">
function onClickTreeDocField(id) {
    document.SearchForm.action="DocDummyRight.jsp";
	document.all("dummyId").value = id;
	document.SearchForm.submit();
}
</script>