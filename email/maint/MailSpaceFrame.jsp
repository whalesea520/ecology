
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.CompanyComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML>
<HEAD>
<title></title>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />

<%
if(! HrmUserVarify.checkUserRight("email:spaceSetting", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

</HEAD>
<%


String rightStr=Util.null2String(request.getParameter("rightStr"));
rightStr="HrmResourceAdd:Add";
int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=(String)session.getAttribute("treeleft");
if(rem==null){
	Cookie[] cks= request.getCookies();
	
	for(int i=0;i<cks.length;i++){
		if(cks[i].getName().equals("treeleft"+uid)){
			rem=cks[i].getValue();
			break;
		}
	}
}
if(rem!=null){
	rem=tabid+rem.substring(1);
	session.setAttribute("treeleft",rem);
	Cookie ck = new Cookie("treeleft"+uid,rem);  
	ck.setMaxAge(30*24*60*60);
	response.addCookie(ck);
	
	String[] atts=Util.TokenizerString2(rem,"|");
	if(atts.length>1){
		nodeid=atts[1];
	}	
}

boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("com")>-1){
	exist=SubCompanyComInfo.getSubCompanyname(nodeid.substring(nodeid.lastIndexOf("_")+1)).equals("")?false:true;
}else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
	String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
	String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}        
if(!exist){
	nodeid=null;
}

%>	
<BODY onload="initTree()">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >

	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle">
				<span class="leftType">组织结构<span id="totalDoc"></span></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
			</div>
		</td>
		
		<td rowspan="2">
			<iframe id='ifmBlogItemContent' src="MailSpaceListFrame.jsp" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div id="deeptree" class="cxtree" style="overflow:hidden;" CfgXMLSrc="/css/TreeConfig.xml" />
		</td>
	</tr>
</table>


</body>
<script>

window.notExecute = true;
function initTree(){
	CXLoadTreeItem("", "/hrm/tree/HrmCompany_XML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

function initTreeold(){
	CXLoadTreeItem("", "/hrm/tree/HrmCompany_XML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}



function setCompany(nodeid){
	var arr = nodeid.split("_");
	 var companyId = arr[1];
	 jQuery(".flowFrame").attr("src","MailSpaceListFrame.jsp");
	
}

function setSubcompany(nodeid){ 
	 var arr = nodeid.split("_");
	 var subcompanyid = arr[1];
	jQuery(".flowFrame").attr("src","MailSpaceListFrame.jsp?subcompanyid="+subcompanyid);
}

function setDepartment(nodeid){
  var arr = nodeid.split("_");
  var subcompanyid = arr[1];
  var departmentid = arr[2];
  jQuery(".flowFrame").attr("src","MailSpaceListFrame.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid);
}

/*收缩左边栏*/
function mnToggleleft(obj){
	if(jQuery("#itmeList").is(":hidden")){
	        jQuery("#frmCenterImg").removeClass("frmCenterImgClose");
	        jQuery("#frmCenterImg").addClass("frmCenterImgOpen");
			jQuery("#itmeList").show();
	}else{
	        jQuery("#frmCenterImg").removeClass("frmCenterImgOpen");
	        jQuery("#frmCenterImg").addClass("frmCenterImgClose"); 
			jQuery("#itmeList").hide();
	}
}
</script>
