
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
    <meta http-equiv="Pragma" content="no-cache" /> 
    <meta http-equiv="Cache-Control" content="no-cache" /> 
    <meta http-equiv="Expires" content="0" />
    
    <script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
    <script type="text/javascript" src="/js/xtree1_wev8.js"></script>
    <script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
	
	<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
	<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree_wev8.css">

    <base target="mainFrame"/>

</HEAD>
<%
String displayUsage=Util.null2o(request.getParameter("displayUsage"));
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));

String selectArr = "";
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectArr = selectedContent;
}
selectArr+="|";
%>
<BODY oncontextmenu="return false;">
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

    <table width=100% class="ViewForm" valign="top">

        <TR>
            <td>
                
				    <script type="text/javascript">
				      // XP Look
				      webFXTreeConfig.rootIcon        = "/images/xp/folder_wev8.png";
				      webFXTreeConfig.openRootIcon    = "/images/xp/openfolder_wev8.png";
				      webFXTreeConfig.folderIcon      = "/images/xp/folder_wev8.png";
				      webFXTreeConfig.openFolderIcon  = "/images/xp/openfolder_wev8.png";
				      webFXTreeConfig.fileIcon        = "/images/xp/folder_wev8.png";
				      webFXTreeConfig.lMinusIcon      = "/images/xp/Lminus_wev8.png";
				      webFXTreeConfig.lPlusIcon       = "/images/xp/Lplus_wev8.png";
				      webFXTreeConfig.tMinusIcon      = "/images/xp/Tminus_wev8.png";
				      webFXTreeConfig.tPlusIcon       = "/images/xp/Tplus_wev8.png";
				      webFXTreeConfig.iIcon           = "/images/xp/I_wev8.png";
				      webFXTreeConfig.lIcon           = "/images/xp/L_wev8.png";
				      webFXTreeConfig.tIcon           = "/images/xp/T_wev8.png";
				  	  
				  	  var rti;
				      var tree = new WebFXTree('Root');
				      tree.setBehavior('explorer');
				      tree.add(rti = new WebFXLoadTreeItem("", "DocSummaryTreeLeftXML.jsp?fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"));
				
				      document.write(tree);
				      
				      rti.expand();
				    </script>
            <td>
        </tr>
    </table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocSummaryList.jsp" method=post target="contentframe">
    <input type="hidden" name="displayUsage" value="<%=displayUsage%>">
    <input type="hidden" name="fromadvancedmenu" value="<%=fromAdvancedMenu%>">
    <input type="hidden" name="selectedContent" value="<%=selectedContent%>">
    <input type="hidden" name="infoId" value="<%=infoId%>">
    <input type="hidden" name="isNew" value="">
    <input type="hidden" name="maincategory" value="">
    <input type="hidden" name="subcategory" value="">
    <input type="hidden" name="seccategory" value="">
    <input type="hidden" name="showDocs" value="">
    </FORM>
    
<script type="text/javascript">
function onClickCategory(id,level) {
	document.all("maincategory").value = "";
	document.all("subcategory").value = "";
	document.all("seccategory").value = "";
	document.all("showDocs").value = "";
	if(level==0){
		document.all("maincategory").value = id;
		document.SearchForm.submit();
	} else if(level==1) {
		document.all("subcategory").value = id;
		document.SearchForm.submit();
	} else if(level==2) {
		document.all("seccategory").value = id;
		document.SearchForm.submit();
	}
}	
function onClickDocNumber(id,level) {
	document.all("maincategory").value = "";
	document.all("subcategory").value = "";
	document.all("seccategory").value = "";
	document.all("showDocs").value = "";
	document.all("isNew").value = "";
	if(level==0){
		document.all("showDocs").value = 1;
		document.all("maincategory").value = id;
		document.SearchForm.submit();
	} else if(level==1) {
		document.all("showDocs").value = 1;
		document.all("subcategory").value = id;
		document.SearchForm.submit();
	} else if(level==2) {
		document.all("showDocs").value = 1;
		document.all("seccategory").value = id;
		document.SearchForm.submit();
	}
}
function onOverNewDocNumber(obj) {
	obj.style.color="#FF0000";
}
function onOutNewDocNumber(obj) {
	obj.style.color="#0000FF";
}
function onClickNewDocNumber(id,level) {
	document.all("maincategory").value = "";
	document.all("subcategory").value = "";
	document.all("seccategory").value = "";
	document.all("showDocs").value = "";
	document.all("isNew").value = "yes";
	if(level==0){
		document.all("showDocs").value = 1;
		document.all("maincategory").value = id;
		document.SearchForm.submit();
	} else if(level==1) {
		document.all("showDocs").value = 1;
		document.all("subcategory").value = id;
		document.SearchForm.submit();
	} else if(level==2) {
		document.all("showDocs").value = 1;
		document.all("seccategory").value = id;
		document.SearchForm.submit();
	}
}
</script>
</BODY>
</HTML>