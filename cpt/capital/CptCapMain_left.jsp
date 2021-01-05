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
String from = Util.null2String(request.getParameter("from"));
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String rightStr = "";
if(HrmUserVarify.checkUserRight("Capital:Maintenance", user)){
	rightStr="Capital:Maintenance";
}
%>
<BODY onload="initTree()">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch" >
			<div>
				<span class="leftType" onclick="reload()">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
				<span><%=SystemEnv.getHtmlLabelName(33553,user.getLanguage())%></span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
		</td>
	</tr>
	<tr>
		<td style="width:220px;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<table height="100%" width="100%" cellspacing="0" cellpadding="0">
					    <FORM NAME=SearchForm STYLE="margin-bottom:0" action="CptCapitalMaintenance.jsp" method=post target="contentframe">
	
	
					<table height="100%" width=100% class="LayoutTable e8_Noborder" valign="top">
						
						<!--######## Search Table Start########-->
						
						
						
						<TR>
						<td height="100%">
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="width:216px;overflow:scroll;" />
						<td>
						</tr>
						
						
						</table>
					  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
					  <input class=inputstyle type="hidden" name="tabid" >
					  <input class=inputstyle type="hidden" name="companyid" >
					  <input class=inputstyle type="hidden" name="subcompanyid1" >
					  <input class=inputstyle type="hidden" name="departmentid" >
					  <input class=inputstyle type="hidden" name="nodeid" >
					  <input class=inputstyle type="hidden" name="from" value="tree" >
					  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
					  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
						<!--########//Search Table End########-->
					</FORM>
				</table>
			</div>
		</td>
	</tr>
</table>





<script language="javascript">
function initTree(){
//CXLoadTreeItem("", "/frameleftXML.jsp?rightStr=<%=rightStr%>");
CXLoadTreeItem("", "/cpt/maintenance/CptSubcomTreeXML.jsp?rightStr=<%=rightStr%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}

function showcom(node){
}

function check(node){
}

function setCompany(id){
    document.all("departmentid").value="";
    document.all("subcompanyid1").value="";
    document.all("companyid").value=id;
    document.all("tabid").value=0;
    document.SearchForm.submit();
}
function reload(){
	initTree();
	//setSubcompany("com_0");
	//window.location.reload(true);
}

function setSubcompany(nodeid){ 
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("companyid").value="";
    document.all("departmentid").value="";
    document.all("subcompanyid1").value=subid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    
    //tagtag
    var from='<%=from %>';
   	var targetIframe=null;
   	if(from=="cptalertnumconf"||from=="cptmodify"){//资产数量预警设置
   		targetIframe=$("#contentframe",parent.document);
   	}else{
	   	targetIframe=$("#contentframe",parent.document).contents()
	   	.find("iframe[name=optFrame]").contents()
	   	.find("iframe[name=tabcontentframe]");
   		
   	}
   	var treeIframe=null;
   	if(from=="cptalertnumconf"||from=="cptmodify"){//资产数量预警设置
   		treeIframe=$("#leftframe",parent.document);
   	}else{
   		treeIframe=$("#contentframe",parent.document).contents().find("iframe[name=leftframe]");
   		var treesrc= treeIframe.attr("src");
   	   	if(treesrc.indexOf("&subcompanyid1=")>-1){
   	   		treesrc= treesrc.substring(0,treesrc.indexOf("&subcompanyid1="))+"&subcompanyid1="+subid;
   		}else{
   			treesrc=treesrc+"&subcompanyid1="+subid;
   		}
   	   	treeIframe.attr("src",treesrc);
   	}
   	
   	
   	
   	var targetsrc= targetIframe.attr("src");
   	if( from==='cptassortment'||from==='cptalertnumconf'||from==='cptmodify'){
   		if(targetsrc.indexOf("&subcompanyid1=")>-1){
   			targetsrc= targetsrc.substring(0,targetsrc.indexOf("&subcompanyid1="))+"&subcompanyid1="+subid;
   		}else{
   			targetsrc=targetsrc+"&subcompanyid1="+subid;
   		}
   		//console.log("targetframe src:"+targetsrc);
   		targetIframe.attr("src",targetsrc);
   	}else{
   		targetIframe.contents().find("input[name=subcompanyid1]").val(subid);
   	   	targetIframe.contents().find("input[type=submit]").trigger("click");
   	}
   	
}
function setDepartment(nodeid){
    
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("subcompanyid1").value="";
    document.all("companyid").value="";
    document.all("departmentid").value=deptid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.submit();
}


</script>
 
 
</BODY>
</HTML>