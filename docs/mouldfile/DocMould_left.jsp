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

function setCompany(id){
    document.all("departmentid").value="";
    document.all("subcompanyid1").value="";
    document.all("companyid").value=id;
    document.all("tabid").value=0;
    document.SearchForm.action= "/hrm/HrmTab.jsp?_fromURL=DocMould";
    document.SearchForm.submit();
}

function setSubcompany(nodeid){
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("companyid").value="";
    document.all("departmentid").value="";
    document.all("subcompanyid1").value=subid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=DocMould&from=tree";
    document.SearchForm.submit();
}

function setDepartment(nodeid){
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("subcompanyid1").value="";
    document.all("companyid").value="";
    document.all("departmentid").value=deptid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=DocMould&from=tree";
    document.SearchForm.submit();
}
</script>
</HEAD>


<%
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String rightStr = "";
if(HrmUserVarify.checkUserRight("DocMouldAdd:add", user)){
	rightStr="DocMouldAdd:add";
}
if(HrmUserVarify.checkUserRight("DocMould:log", user)){
	rightStr="DocMould:log";
}
%>
<BODY onload="initTree()">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/HrmTab.jsp?_fromURL=DocMould" method=post target="contentframe">
	
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	
	<!--######## Search Table Start########-->
	
	
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType">组织结构<span id="totalDoc"></span></span>
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
  <input class=inputstyle type="hidden" name="subcompanyid1" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="urlfrom" value = "hr" >
  <input class=inputstyle type="hidden" name="isFirst" value="new" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
CXLoadTreeItem("", "/frameleftXML.jsp?rightStr=<%=rightStr%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}

//to use xtree,you must implement top() and showcom(node) functions

function top(){

}

function showcom(node){
}

function check(node){
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