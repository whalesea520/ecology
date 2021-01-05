<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.company.*" %>
<%@ page import="weaver.hrm.performance.goal.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(18041,user.getLanguage()) + " - " + SystemEnv.getHtmlLabelName(18043,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>

<%
String companyIcon = "/images/treeimages/global16.gif";
String flowName = GoalUtil.getCheckFlow(0,"0");
%>

<HTML>
<HEAD>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css">
<link type="text/css" rel="stylesheet" href="/css/xtree2.css" />
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
<script type="text/javascript" src="/js/xloadtree/xtree4goal.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4goal.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
</head>
<body style="padding:5px">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>





<script type="text/javascript">
webFXTreeConfig.blankIcon		= "/images/xp2/blank.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp2/I.png";
webFXTreeConfig.lIcon			= "/images/xp2/L.png";
webFXTreeConfig.tIcon			= "/images/xp2/T.png";

var tree = new WebFXTree('<%=compInfo.getCompanyname("1")%>','setCompany(0);','','<%=companyIcon%>','<%=companyIcon%>');
<%out.println(subCompInfo.getSubCompanyTreeJSByComp2());%>
document.write(tree);
tree.expand();
</script>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="" method=post target="contentframe">
<input class=inputstyle type="hidden" name="resourceids" >
<input class=inputstyle type="hidden" name="tabid" >
<input class=inputstyle type="hidden" name="nodeid" >
<input class=inputstyle type="hidden" name="companyid" >
<input class=inputstyle type="hidden" name="subcompanyid" >
<input class=inputstyle type="hidden" name="departmentid" >
<input class=inputstyle type="hidden" name="hrmid" >
<input class=inputstyle type="hidden" name="objId">
<input class=inputstyle type="hidden" name="type_d" >
</FORM>
</body>
</html>


<script type="text/javascript">
function doSearch(id)
{
	//setResourceStr();
    //document.all("resourceids").value = resourceids.substring(1) ;
    var iframeSrc = parent.document.getElementById("contentframe").src;
	if(iframeSrc.indexOf("Goal")!=-1){
		document.SearchForm.action = "/hrm/performance/goal/myGoalList.jsp";
	}
	else if (iframeSrc.indexOf("Plan")!=-1)
	{
	document.SearchForm.action = "/hrm/performance/targetPlan/MyPlanMain.jsp";
	}
	else if (iframeSrc.indexOf("Report")!=-1)
	{
	document.SearchForm.action = "/hrm/performance/targetReport/MyReportMain.jsp";
	}
	else if (iframeSrc.indexOf("Check")!=-1)
	{
	document.SearchForm.action = "/hrm/performance/targetCheck/MyCheckMain.jsp";
	}
	//setResourceStr();
    //document.all("resourceids").value = resourceids.substring(1) ;
    //alert(id);
 
     document.SearchForm.submit();
}
function setCompany(id){
	//===================================================================================added by hubo,TD3830
	var iframeSrc = parent.document.getElementById("contentframe").src;
	if(iframeSrc=="MyPlanMain.jsp" || iframeSrc=="MyReportMain.jsp" || iframeSrc=="MyCheckMain.jsp"){
		if(id=="0")	return false;
	}
	//===================================================================================
    document.all("type_d").value="0" //集团
    document.all("departmentid").value=""
    document.all("subcompanyid").value=""
    document.all("companyid").value=id
    document.all("objId").value=id
    document.all("tabid").value=0
    doSearch(id)
}
function setSubcompany(nodeid){ 
    document.all("type_d").value="1" //分部
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("subcompanyid").value=subid
    document.all("objId").value=subid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch(subid)
}
function setDepartment(nodeid){
     document.all("type_d").value="2" //部门
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=deptid
    document.all("objId").value=deptid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch(deptid)
}

function setHrm(nodeid){
     document.all("type_d").value="3" //人力资源
    hrmid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("hrmid").value=hrmid
    document.all("objId").value=hrmid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch(hrmid)
}
</script>