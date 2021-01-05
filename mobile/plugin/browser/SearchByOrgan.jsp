<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%> 
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<script src="/js/jquery/jquery_wev8.js" type="text/javascript"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/plugin/ecology/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/plugin/ecology/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/plugin/ecology/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/plugin/ecology/css/xtree2_wev8.css" />
<%@ include file="MobileInit.jsp"%>
</HEAD>

<%
int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=null;
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
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

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
	String strtmp = "select id,lastname from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put(RecordSet.getString("id"),RecordSet.getString("lastname"));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){
		
	}
}
%>

<BODY  oncontextmenu="return false;">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">

<table width=100% class="ViewForm" valign="top" height="100%">
	
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td height=170 width="100%">
	<div id="deeptree" class="cxtree" CfgXMLSrc="/plugin/ecology/js/TreeConfig.xml" />
	<td>
	</tr>
	
	
	</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
	<!--########//Search Table End########-->
	</FORM>
 
<SCRIPT type="text/javascript">
var resourceids = "<%=resourceids%>";
function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}
function btnok_onclick(){
	 setResourceStr();
     replaceStr();
     window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
}
function btnsub_onclick(){
	setResourceStr();
    $("#resourceids").val(resourceids.substring(1));
    document.SearchForm.submit();
}
</SCRIPT>





<script language="javascript">
$(function(){
	initTree();
});
function initTree(){
//deeptree.init("/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
//added by cyril on 2008-07-31 for td:9109
//设置选中的ID
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/manager/getPage.do?pluginCode=1&page=ResourceMultiXML&<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
alert(tree);
//end by cyril on 2008-07-31 for td:9109
}
//to use xtree,you must implement top() and showcom(node) functions

function top(){
<%if(nodeid!=null){%>
try{
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
 }catch(e){

    }
<%}%>
}

function showcom(node){
}

function check(node){
}
function setResourceStr(){
	
	var resourceids1 =""
        var resourcenames1 = ""
       try{
	   var frame2;
	   
	for(var i=0;i<parent.frame2.resourceArray.length;i++){
		resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;
		
		resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
       }catch(err){
		//alert(err.message)
	 }	
	
	
}

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

function doSearch()
{
	setResourceStr();
    $("input[name=resourceids]").val(resourceids.substring(1)) ;
    
    document.SearchForm.submit();
}
function setCompany(id){
    //alert('setCompany');
    document.all("departmentid").value=""
    document.all("subcompanyid").value=""
    document.all("companyid").value=id
    document.all("tabid").value=0
    doSearch()
}
function setSubcompany(nodeid){ 
    //alert('setSubcompany');
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("subcompanyid").value=subid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}
function setDepartment(nodeid){
	//alert('setDepartment');
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=deptid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}


</script>
</BODY>
</HTML>