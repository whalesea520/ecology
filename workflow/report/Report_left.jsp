<!DOCTYPE html>
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
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
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
String rem=(String)session.getAttribute("treeleft");
if(rem==null){
     Cookie[] cks= request.getCookies();
     
     for(int i=0;i<cks.length;i++){
	     //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
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
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
%>

<BODY onload="initTree()" scroll=no>
<form name="SearchForm" STYLE="margin-bottom:0" action="ReportType_frm.jsp" method="post" target="contentframe">
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
					<span class="leftType">
						<%=SystemEnv.getHtmlLabelName(25332,user.getLanguage()) %>
						<span id="totalDoc"></span>
					</span>
					<span class="leftSearchSpan">
						<input type="text" class="leftSearchInput" style="width:110px;"/>
					</span>
				</div>
			</td>
		</tr>
		<tr>
			<td class="flowMenusTd">
				<div class="flowMenuDiv"  >
					<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
						<div class="ulDiv">
							<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="overflow:hidden;"/>
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input type="hidden" name="subcompanyid">
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
  <input type="hidden" name="isTemplate" value="<%=isTemplate%>">
</form>
<script language="javascript">
function initTree(){
	CXLoadTreeItem("", "/frameleftXML.jsp?rightStr=<%=rightStr%>&setcom=true");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

function top2(){
	<%if(nodeid!=null){%>
	deeptree.scrollTop=<%=nodeid%>.offsetTop;
	deeptree.HighlightNode(<%=nodeid%>.parentElement);
	deeptree.ExpandNode(<%=nodeid%>.parentElement);
	<%}%>
}

function setSubcompany(nodeid){ 
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    jQuery(document).find("input[name='subcompanyid']").val(subid);
    jQuery(document).find("input[name='nodeid']").val(nodeid);
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