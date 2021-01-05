<!-- 
|last modified by cyril on 2008-07-31
|改写人力资源树
|将deepTree改成xtree,取消HTC控件
 -->
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<!-- end by cyril on 2008-07-31 for td:9109 -->
</HEAD>

<%

int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=null;
        Cookie[] cks= request.getCookies();
        for(int i=0;i<cks.length;i++){
        if(cks[i].getName().equals("resourcemulti"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
Cookie ck = new Cookie("resourcemulti"+uid,rem);  
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

<BODY  oncontextmenu="return false;">
<FORM NAME="SearchForm" STYLE="margin-bottom:0" method="post" action="MultiSelect.jsp" target="frame2">
	<table width="100%" class="ViewForm" valign="top" height="100%">
	<TR>
	<td height=170 width="100%">
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	</table>
  	<input class=inputstyle type="hidden" name="tabid" id="tabid">
  	<input class=inputstyle type="hidden" name="nodeid" id="nodeid">
  	<input class=inputstyle type="hidden" name="companyid" id="companyid">
  	<input class=inputstyle type="hidden" name="subcompanyid" id="subcompanyid">
  	<input class=inputstyle type="hidden" name="departmentid" id="departmentid">
</FORM>
<script language="javascript">
function initTree(){
//deeptree.init("/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
//added by cyril on 2008-07-31 for td:9109
//设置选中的ID
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}
//to use xtree,you must implement top() and showcom(node) functions

function top111(){
<%if(nodeid!=null){%>
try{
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
 }catch(e){

    }
<%}%>
}
</script>
</body>
</html>
<!-- 一下js代码是从body体 里面挪出来的 2012-8-06  ypc 修改 start -->
<script language="javascript">
	$(function(){
		initTree();
		 
	});
$(document).ready(function(){
	if(typeof(parent.frame2) != "undefined"){
		parent.frame2.resetCondition(1,true);
	}
});

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

function setCompany(id){
    $("#companyid").val(id);
    $("#subcompanyid").val("");
    $("#departmentid").val("");
    parent.frame2.setSearchCondition1($("#companyid").val(),$("#subcompanyid").val(),$("#departmentid").val());
}
function setSubcompany(nodeid){ 
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    $("#companyid").val("");
    $("#subcompanyid").val(subid);
    $("#departmentid").val("");
    $("#nodeid").val(nodeid);
    parent.frame2.setSearchCondition1($("#companyid").val(),$("#subcompanyid").val(),$("#departmentid").val());
}
function setDepartment(nodeid){
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    $("#companyid").val("");
    $("#subcompanyid").val("");
    $("#departmentid").val(deptid);
    $("#nodeid").val(nodeid);
    parent.frame2.setSearchCondition1($("#companyid").val(),$("#subcompanyid").val(),$("#departmentid").val());
}
</script>
<!-- 一下js代码是从body体 里面挪出来的 2012-8-06  ypc 修改 end -->