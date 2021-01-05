<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />


<%
User user = HrmUserVarify.getUser (request , response) ;
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
int uid=user.getUID();
int tabid=0;


String nodeid=null;
String rem=(String)session.getAttribute("resourcesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("resourcesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
session.setAttribute("resourcesingle",rem);
Cookie ck = new Cookie("resourcesingle"+uid,rem);  
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
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="DocSearchTab.jsp?urlType=6" method=post target="flowFrame">
<div id="deeptree" class="cxtree cxtreeMargin" CfgXMLSrc="/css/TreeConfig.xml" ></div>
  <input class=inputstyle type="hidden" id="sqlwhere" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" id="tabid" name="tabid" >
  <input class=inputstyle type="hidden" id="companyid" name="companyid" >
  <input class=inputstyle type="hidden" id="creatersubcompanyid" name="creatersubcompanyid" >
  <input class=inputstyle type="hidden" id="departmentid" name="departmentid" >
  <input class=inputstyle type="hidden" id="nodeid" name="nodeid" >
  <input class=inputstyle type="hidden" id="ishow" name="ishow" value="false" >
  <input class=inputstyle type=hidden id=seclevelto name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden id=needsystem name=needsystem value="<%=needsystem%>">
  <input class=inputstyle type=hidden name=fromadvancedmenu value="<%=fromAdvancedMenu%>">
  <input class=inputstyle type=hidden name=infoId value="<%=infoId%>">
  <input class=inputstyle type="hidden" id="urlType" name="urlType" value="6" >
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
CXLoadTreeItem("", "/hrm/tree/ResourceSingleXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}

//to use xtree,you must implement top() and showcom(node) functions

function top1(){
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
	var url = "DocSearchTab.jsp?urlType=6&companyid="+id;
	document.SearchForm.action = url;
    document.getElementById("departmentid").value="";
    document.getElementById("creatersubcompanyid").value="";
    document.getElementById("companyid").value=id;
    document.getElementById("tabid").value=0;
    document.SearchForm.submit();
}
function setSubcompany(nodeid){ 
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.getElementById("companyid").value="";
    document.getElementById("departmentid").value="";
    document.getElementById("creatersubcompanyid").value=subid;
    document.getElementById("tabid").value=0;
    document.getElementById("nodeid").value=nodeid;
    var url = "DocSearchTab.jsp?urlType=6&creatersubcompanyid="+subid+"&nodeid="+nodeid;
	document.SearchForm.action = url;
    document.SearchForm.submit();
}
function setDepartment(nodeid){
    
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.getElementById("creatersubcompanyid").value="";
    document.getElementById("companyid").value="";
    document.getElementById("departmentid").value=deptid;
    document.getElementById("tabid").value=0;
    document.getElementById("nodeid").value=nodeid;
    var url = "DocSearchTab.jsp?urlType=6&departmentid="+deptid+"&nodeid="+nodeid;
	document.SearchForm.action = url;
    document.SearchForm.submit();
}

initTree();

</script>
 

