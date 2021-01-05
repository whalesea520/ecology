<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<!-- end by cyril on 2008-07-31 for td:9109 -->
<style>
#divTree { overflow: scroll; height: 170; width: 100%; }
</style>


</HEAD>

<BODY onload="" oncontextmenu="return false;">
<%
int uid=user.getUID();
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
rem="1"+rem.substring(1);
Cookie ck = new Cookie("resourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}
nodeid = ""+Util.getIntValue(nodeid, -2);
//List grouplist=GroupAction.getGroupTree(user);
//System.out.println("nodes"+grouplist.size());
//request.setAttribute("grouplist",grouplist);
String publicid = Util.null2String(request.getParameter("publicid"));

%>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
<table height="100%" width=100% class="ViewForm" valign="top">
	
	<!--######## Search Table Start########-->
	<TR>
	<td>
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	</table>
  <input class=inputstyle type="hidden" name="publicid" value='<%=publicid%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="groupid" value="<%=Util.null2String(nodeid)%>">
  <input class=inputstyle type="hidden" name="nodeid" >
	<!--########//Search Table End########-->
	</FORM>


  
<script language="javascript">
$(function(){
	initTree();
});
function initTree(){
//added by cyril on 2008-07-31 for td:9109
//设置选中的ID
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceMultiXMLByGroup.jsp");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}
</script>

<script language="javascript">
$(document).ready(function(){
	if(typeof(parent.frame2) != "undefined"){
		parent.frame2.resetSearchCondition(2,false);
	}
});
	 
function setGroup(id){
    parent.frame2.setSearchCondition2(id);
}

</script>
</BODY>
</HTML>