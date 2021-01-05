<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
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

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String subcomid=Util.null2String(request.getParameter("subcomid"));
String deptid=Util.null2String(request.getParameter("deptid"));
String rightStr=Util.null2String(request.getParameter("rightStr"));
String zxnodeid = Util.null2String(request.getParameter("nodeid"));
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
}
if(!exist)
nodeid=null;



%>

<BODY >
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/tools/Hrmdsporder.jsp" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>



<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table height="100%" width=100% class="ViewForm" valign="top">

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
  <input class=inputstyle type="hidden" name="subCompanyId" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="id" >
   <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
jQuery(document).ready(function(){
	initTree;
	
});
function initTree(){
//设置选中的ID
cxtree_id = '<%=zxnodeid%>';
CXLoadTreeItem("", "/hrm/tree/HrmCompany_XML.jsp?rightStr=<%=rightStr%>&showdept=false<%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}


function top(){
<%if(nodeid!=null){%>
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
<%}%>

<%if(deptid!=null&&!deptid.equals("")&&!deptid.equals("0")){%>
deeptree.scrollTop=dept_<%=subcomid%>_<%=deptid%>.offsetTop;
deeptree.HighlightNode(dept_<%=subcomid%>_<%=deptid%>.parentElement);
dept_<%=subcomid%>_<%=deptid%>.click();
deeptree.ExpandNode(dept_<%=subcomid%>_<%=deptid%>.parentElement);
<%}else if(subcomid!=null&&!subcomid.equals("")&&!subcomid.equals("0")){%>
deeptree.scrollTop=com_<%=subcomid%>.offsetTop;
deeptree.HighlightNode(com_<%=subcomid%>.parentElement);
com_<%=subcomid%>.click();
deeptree.ExpandNode(com_<%=subcomid%>.parentElement);
<%}%>
}

function showcom(node){
}

function check(node){
}

function setCompany(nodeid){

    comid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("departmentid").value="";
    document.all("subCompanyId").value="";
    document.all("id").value=comid;
    document.all("tabid").value=0;
    document.SearchForm.submit();
}
function setSubcompany(nodeid){

    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("companyid").value="";
    document.all("departmentid").value="";
    document.all("subCompanyId").value=subid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.all("id").value=subid;
    document.SearchForm.submit();
}
function setDepartment(nodeid){

    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("subCompanyId").value="";
    document.all("companyid").value="";
    document.all("departmentid").value=deptid;
    document.all("tabid").value=0;
    document.all("id").value=deptid;
    document.all("nodeid").value=nodeid;
    document.SearchForm.action="/hrm/company/HrmDepartmentDsp.jsp";
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