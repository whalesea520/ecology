<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<jsp:useBean id="companyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

int goalType = Util.getIntValue((String)SessionOper.getAttribute(session,"goalType"));
String cycle = (String)SessionOper.getAttribute(session,"cycle");
int rootObjId = ((Integer)SessionOper.getAttribute(session,"objId")).intValue();
String companyName = companyComInfo.getCompanyname("1");
String subCompanyName = "";
String subCompanyId = "";
String departmentName = "";
String departmentId = "";

HashMap hm = GoalUtil.getOrgIdName(goalType,rootObjId);
if(goalType==1){
	subCompanyName = (String)hm.get("objOrgName");
	subCompanyId = (String)hm.get("objOrgId");
}else if(goalType==2){
	subCompanyName = (String)hm.get("parentOrgName");
	subCompanyId = (String)hm.get("parentOrgId");
	departmentName = (String)hm.get("objOrgName");
	departmentId = (String)hm.get("objOrgId");
}
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/xloadtree/xtree4objBrowser.js"></script>
<script type="text/javascript" src="/js/xloadtree/xmlextras.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree.css" />
<base target="mainFrame"/>
</head>
<body>
<input type="hidden" id="a" name="a" value="<%=Util.null2String(request.getParameter("selected"))%>"/>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:ok(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:100%;height:100%;" border="0" cellspacing="0" cellpadding="0">
<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td></td>
	<td valign="top">
		<table class="Shadow">
		<tr>
			<td valign="top">
<!--=================================-->
<script type="text/javascript">
/// XP Look
webFXTreeConfig.rootIcon		= "/images/treeimages/global16.gif";
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder.png";
webFXTreeConfig.fileIcon		= "/images/xp2/file.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp2/I.png";
webFXTreeConfig.lIcon			= "/images/xp2/L.png";
webFXTreeConfig.tIcon			= "/images/xp2/T.png";

var rti;

<%if(goalType==0){%>
	<%if(cycle.equals("0")){%>
		var tree = new WebFXLoadTree("<%=companyName%>","objTree.jsp","","","/images/treeimages/global16.gif","/images/treeimages/global16.gif");
	<%}else{%>
		var tree = new WebFXLoadTree("<%=companyName%>","objTree.jsp","","","/images/treeimages/global16.gif","/images/treeimages/global16.gif");
	<%}%>
	document.write(tree);
	tree.expandAll();
<%}else if(goalType==1){%>
	var tree = new WebFXTree("<%=companyName%>","","","/images/treeimages/global16.gif","/images/treeimages/global16.gif");
	<%if(cycle.equals("0")){%>
		var rti = new WebFXLoadTreeItem("<%=subCompanyName%>", "objTree.jsp","","","/images/treeimages/home16.gif","/images/treeimages/home16.gif");
	<%}else{%>
		var rti = new WebFXLoadTreeItem("<%=subCompanyName%>", "objTree.jsp","","","/images/treeimages/home16.gif","/images/treeimages/home16.gif");
	<%}%>
	tree.add(rti);
	document.write(tree);
	rti.expandAll();
	tree.expandAll();
<%}else if(goalType==2){%>
	var tree = new WebFXTree("<%=companyName%>","","","/images/treeimages/global16.gif","/images/treeimages/global16.gif");
	var treeItem = new WebFXTreeItem("<%=subCompanyName%>","","","/images/treeimages/home16.gif","/images/treeimages/home16.gif");
	<%if(cycle.equals("0")){%>
		var rti = new WebFXLoadTreeItem("<%=departmentName%>", "objTree.jsp","","","/images/treeimages/dept16.gif","/images/treeimages/dept16.gif");
	<%}else{%>
		var rti = new WebFXLoadTreeItem("<%=departmentName%>", "objTree.jsp","","","/images/treeimages/dept16.gif","/images/treeimages/dept16.gif");
	<%}%>
	treeItem.add(rti);
	tree.add(treeItem);
	document.write(tree);
	treeItem.expandAll();
	rti.expandAll();
	tree.expandAll();
<%}%>

var param = "";
function setObj(p){
	param += p + "|";
	//window.parent.returnValue = param.split(",");
	//window.close();
}
function ok(){
	var html = new Array(3);
	html[0] = "";
	html[1] = "";
	html[2] = "";
	var str = document.getElementById("a").value;
	var items = str.split("|");
	for(var i=0;i<items.length;i++){
		if(items[i]!=""){
			var subitems = items[i].split(",");
			if(subitems[2]==1){ 
				html[0] += "<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+subitems[0]+"'>"+subitems[1]+"</a> ";
			}else if(subitems[2]==2){
				html[0] += "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+subitems[0]+"'>"+subitems[1]+"</a> ";
			}else if(subitems[2]==3){
				html[0] += "<a href='/hrm/resource/HrmResource.jsp?id="+subitems[0]+"'>"+subitems[1]+"</a> ";
			}
			html[1] += subitems[0] + "," + subitems[2] + "|";
			html[2] += subitems[0] + "," + subitems[1] + "," + subitems[2] + "|";
		}
	}
	window.parent.returnValue = html;
	window.close();
}
function f(p){
	var o = document.getElementById("a");
	if(event.srcElement.checked){
		o.value += p + "|";
	}else{
		o.value = o.value.replace(p+"|", "");
	}
}
</script>
<!--=================================-->
			</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>