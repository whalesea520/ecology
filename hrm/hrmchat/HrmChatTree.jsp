
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="chatCompInfo" class="weaver.hrm.chat.ChatHrmListTree" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String companyIcon = "/images/treeimages/global16_wev8.gif";
%>

<HTML>
<HEAD>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree_wev8.css">
<style>
TABLE.Shadow A {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:hover {
	COLOR: #333; TEXT-DECORATION: none
}

TABLE.Shadow A:link {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: none
}
</style>
<script type="text/javascript" src="/js/chathrm/xtree4goal_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4goal_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
</head>
<body style="padding:5px">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
webFXTreeConfig.blankIcon		= "/images/xp2/blank_wev8.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus_wev8.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus_wev8.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus_wev8.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus_wev8.png";
webFXTreeConfig.iIcon			= "/images/xp2/I_wev8.png";
webFXTreeConfig.lIcon			= "/images/xp2/L_wev8.png";
webFXTreeConfig.tIcon			= "/images/xp2/T_wev8.png";

var tree = new WebFXTree('<%=compInfo.getCompanyname("1")%>','setCompany(0);','','<%=companyIcon%>','<%=companyIcon%>');
<%out.println(chatCompInfo.getSubCompanyTreeJSByChat());%>
document.write(tree);
tree.expand();
</script>
</body>
</html>

<script type="text/javascript">
function setCompany(id){
    
}
function setSubcompany(nodeid){ 

}
function setDepartment(nodeid){

}

function setHrm(nodeid){
     objid = nodeid.substring(nodeid.indexOf("_")+1,nodeid.length);
     showHrmChat(objid);
}

</script>