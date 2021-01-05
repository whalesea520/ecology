<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<link href="/css/deepTree.css" rel="stylesheet" type="text/css">
</HEAD>


<%

int uid=user.getUID();
int tabid=0;
String nodeid=null;
%>

<BODY onload="initTree()">
	
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/performance/targetPlan/myPlanMain.jsp" method=post target="contentframe">
<table width=100% class="ViewForm" valign="top" height=100%>
	
	<!--######## init tree########-->
	
	
	
	<TR>
	<td height=100%>
	<div id="deeptree" class="deeptree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	
	
	</table>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="hrmid" >
  <input class=inputstyle type="hidden" name="objId">
  <input class=inputstyle type="hidden" name="type_d" >
	<!--########//init tree########-->
</FORM>
<script language="javascript">
function initTree(){
deeptree.init("/hrm/performance/ResourceHrmXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
}

//to use xtree,you must implement top() and showcom(node) functions

function top(){
<%if(nodeid!=null){%>
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
<%}%>
}

function showcom(node){
}

function check(node){
}


function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

function doSearch(id)
{
	//setResourceStr();
    //document.all("resourceids").value = resourceids.substring(1) ;
    var iframeSrc = parent.document.getElementById("contentframe").src;
	if(iframeSrc=="myGoalList.jsp"){
		document.SearchForm.action = "/hrm/performance/goal/"+iframeSrc;
	}
	else if (iframeSrc=="MyPlanMain.jsp")
	{
	document.SearchForm.action = "/hrm/performance/targetPlan/"+iframeSrc;
	}
	else if (iframeSrc=="MyReportMain.jsp")
	{
	document.SearchForm.action = "/hrm/performance/targetReport/"+iframeSrc;
	}
	else if (iframeSrc=="MyCheckMain.jsp")
	{
	document.SearchForm.action = "/hrm/performance/targetCheck/"+iframeSrc;
	}
	//setResourceStr();
    //document.all("resourceids").value = resourceids.substring(1) ;
    //alert(id);
 
     document.SearchForm.submit();
}
function setCompany(id){
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
</BODY>
</HTML>