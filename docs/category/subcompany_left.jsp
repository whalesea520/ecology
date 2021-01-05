

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>


<%
User user = HrmUserVarify.getUser (request , response) ;
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));

String url = Util.null2String(request.getParameter("url"));
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
if(!Util.null2String(request.getParameter("isDetach")).equals("")){
url+="&isDetach="+Util.null2String(request.getParameter("isDetach"));
}
if(isWorkflowDoc.equals("1")){
url+="&isWorkflowDoc="+isWorkflowDoc;
}
String rightStr=Util.null2String(request.getParameter("rightStr"));

int uid=user.getUID();
int tabid=0;
if(url.indexOf("?")<0){
url+="?1=1";
}

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
String isFromMonitor = Util.null2String(request.getParameter("isFromMonitor"));
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

	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="managestruabbr_help.jsp" method=post target="outcontentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	

<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>

<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	

<table height="100%" width=100% class="LayoutTable e8_Noborder" valign="top">
	
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td height="100%">
	<div id="deeptree"  class="cxtree cxtreeMargin" CfgXMLSrc="/css/TreeConfig.xml" style="overflow:hidden;"/>
	</td>
	</tr>
	
	
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" id="tabid" >
  <input class=inputstyle type="hidden" name="companyid" id="companyid" >
  <input class=inputstyle type="hidden" name="subCompanyId" id="subCompanyId" >
  <input class=inputstyle type="hidden" name="departmentid" id="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" id="nodeid" >
  <input class=inputstyle type=hidden name=seclevelto id=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem id=needsystem value="<%=needsystem%>">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
CXLoadTreeItem("", "/docs/category/subcompany_leftXML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
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

    document.getElementById("departmentid").value="";
    document.getElementById("subCompanyId").value="";
    document.getElementById("companyid").value=id;
    document.getElementById("tabid").value=0;
<%
if("sysadmin".equals(user.getLoginid())){
%>
   document.SearchForm.action="<%=url%>";
<%
}else{
%>
    document.SearchForm.action="<%=url%>";
<%
}
%>
    document.SearchForm.submit();

}
function setSubcompany(nodeid){ 
    
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.getElementById("companyid").value="";
    document.getElementById("departmentid").value="";
    document.getElementById("subCompanyId").value=subid;
    document.getElementById("tabid").value=0;
    document.getElementById("nodeid").value=nodeid;
    document.SearchForm.action="<%=url%>&subcompanyIdShare="+subid;
    document.SearchForm.submit();
}

function btnclear_onclick(){
	window.parent.returnvalue = {id:"",name:""};
	window.parent.close
}

	initTree();

</script>
 
 
