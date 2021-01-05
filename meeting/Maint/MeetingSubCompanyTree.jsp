<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
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

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));

String rightStr=Util.null2String(request.getParameter("rightStr"));

int uid=user.getUID();
int tabid=0;


String nodeid=null;
String rem=(String)session.getAttribute("MeetingRoomleft");
        if(rem==null){
        Cookie[] cks= request.getCookies();

        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("MeetingRoomleft"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
session.setAttribute("MeetingRoomleft",rem);
Cookie ck = new Cookie("MeetingRoomleft"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
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
if(!exist)
nodeid=null;

%>

<BODY onload="initTree()" style="overflow-y: hidden;" scroll=no>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table height="100%" width=100% cellspacing="0" cellpadding="0" class="flowsTable" valign="top">

	<!--######## Search Table Start########-->

	<tr>
		<td class="leftTypeSearch" style="display:block;">
			<div>
				<span class="leftType" onclick="clearCompany();">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span><span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2"></td>
	</tr>

	<TR>
	<td height="100%" style="width:23%;" class="flowMenusTd" style="display:block;">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv">
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="width:245px;" />
					</div>
				</div>
			</div>
	
	</td>
	</tr>
	</table>
<script language="javascript">
function setHeight(height){
	$(".ulDiv").height($("#deeptree .ulDiv").height());
	$("#deeptree .ulDiv").parent().height($("#deeptree .ulDiv").height());
	$("#overFlowDiv").height(height);
}
function initTree(){
CXLoadTreeItem("", "MeetingRoomXML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
jQuery('.flowMenusTd').css("display","block");
jQuery('.flowMenusTd').css("width","100%");
}

function clearCompany(){
	e8InitTreeSearch({ifrms:'',formID:'',conditions:''});
    try{
    parent.setSubcompany("");
	}catch(e){}
}

//to use xtree,you must implement top() and showcom(node) functions

function top2(){
<%if(nodeid!=null){%>
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
<%}%>
}
$(document).ready(function(){
	$("a[id^='webfx-tree-object-']").live("click", function(){
			var href = jQuery(this).attr("href");
			if(href != null && href != undefined && href.indexOf("setSubcompany") ==-1 ){
				selectRoot();
			}
		});
});

function showcom(node){
}

function selectRoot(){
	try{
		parent.selectRoot();
	}catch(e){}
}

function check(node){
}

function setSubcompany(nodeid){
	try{
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    parent.setSubcompany(subid);
	}catch(e){}

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