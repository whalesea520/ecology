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
    
    for(int i=0;i<cks.length;i++)
    {
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CustomQueryType_frm.jsp" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	

<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(25332,user.getLanguage()) %><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2"></td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv">
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml"/>
					</div>
				</div>
			</div>
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
  <input type="hidden" name="isTemplate" value="<%=isTemplate%>">
  <input type="hidden" name="rightStr" value="<%=rightStr%>">
    <!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
CXLoadTreeItem("", "/frameleftXML.jsp?rightStr=<%=rightStr%>&setcom=true");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}

//to use xtree,you must implement top() and showcom(node) functions

function top2(){
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

function setCompany(id){
	    document.all("departmentid").value="";
	    document.all("subcompanyid").value="";
	    document.all("companyid").value=id;
	    document.all("tabid").value=0;
	    document.SearchForm.submit();
}
function setSubcompany(nodeid){ 
    
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("companyid").value="";
    document.all("departmentid").value="";
    document.all("subcompanyid").value=subid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.submit();
}
function setDepartment(nodeid){
    
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("subcompanyid").value="";
    document.all("companyid").value="";
    document.all("departmentid").value=deptid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
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