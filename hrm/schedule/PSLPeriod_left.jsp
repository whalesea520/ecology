<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(document.body).height());
	});
}
</script>
</HEAD>


<%
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());

String rightStr=Util.null2String(request.getParameter("rightStr"));

int right = Util.getIntValue(HrmUserVarify.getRightLevel(rightStr, user),0);


%>

<BODY onload="initTree()">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/HrmTab.jsp?_fromURL=PSLPeriodView" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(16455, user.getLanguage())%><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div id="deeptree" class="cxtree" style="overflow:hidden;" CfgXMLSrc="/css/TreeConfig.xml" />
		</td> 
	</tr>
</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
	/*
	var rti;
	var tree = new WebFXTree('');
	tree.setBehavior("explorer");
	tree.add(rti = new WebFXLoadTreeItem("", "/hrm/schedule/PSLLeftXML.jsp?rightStr=<%=rightStr%>"));
	rti.icon = webFXTreeConfig.rootIcon;
	rti.openIcon = webFXTreeConfig.openRootIcon;
	document.getElementById('deeptree').innerHTML = tree;
	rti.expand();
	*/
	CXLoadTreeItem("", "/hrm/schedule/PSLLeftXML.jsp?rightStr=<%=rightStr%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	//document.write(tree);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

function initTreeOld(){
CXLoadTreeItem("", "/hrm/schedule/PSLLeftXML.jsp?rightStr=<%=rightStr%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}

//to use xtree,you must implement top() and showcom(node) functions
function showcom(node){
}

function check(node){
}

function setCompany(id){
    if("<%=right%>"==2){
       document.all("departmentid").value="";
       document.all("subcompanyid").value="";
       document.all("companyid").value=0;
       document.all("tabid").value=0;
       document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=PSLPeriodView&companyid="+0;
       document.SearchForm.submit();
    }
}
function setSubcompany(nodeid){ 

    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("companyid").value="";
    document.all("departmentid").value="";
    document.all("subcompanyid").value=subid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=PSLPeriodView&subcompanyid="+subid;
    document.SearchForm.submit();
}
function setDepartment(nodeid){
    
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("subcompanyid").value="";
    document.all("companyid").value="";
    document.all("departmentid").value=deptid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=PSLPeriodView&departmentid="+deptid;
    document.SearchForm.submit();
}


</script>
 
 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
</SCRIPT>
</BODY>
</HTML>
