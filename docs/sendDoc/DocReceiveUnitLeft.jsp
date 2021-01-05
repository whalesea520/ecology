
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
String rightStr = "SRDoc:Edit";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String receiveUnitId=Util.null2String(request.getParameter("receiveUnitId"));
String nodeid=null;
String isWfDoc = Util.null2String(request.getParameter("isWfDoc"));
%>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>


	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocReceiveUnitRight.jsp" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility = "hidden";
</script>	

<table height="100%" width=100% class="LayoutTable e8_Noborder" valign="top">
	
	<!--######## Search Table Start########-->
	<TR>
	<td height="100%" valign="top">
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	</td>
	</tr>
	</table>

	<input class=inputstyle type="hidden" id="id" name="id" >
	<input class=inputstyle type="hidden" id="subcompanyid" name="subcompanyid" >

	<!--########//Search Table End########-->
	</FORM>

<script language="javascript">
function initTree(){
   /* webFXTreeConfig.lMinusIcon      = "/images/xp2/Lminus_wev8.png";
    webFXTreeConfig.lPlusIcon       = "/images/xp2/Lplus_wev8.png";
    webFXTreeConfig.tMinusIcon      = "/images/xp2/Tminus_wev8.png";
    webFXTreeConfig.tPlusIcon       = "/images/xp2/Tplus_wev8.png";
    webFXTreeConfig.iIcon           = "/images/xp2/I_wev8.png";
    webFXTreeConfig.lIcon           = "/images/xp2/L_wev8.png";
    webFXTreeConfig.tIcon           = "/images/xp2/T_wev8.png";*/

	cxtree_id = '<%=Util.null2String(nodeid)%>';
	CXLoadTreeItem("", "/docs/sendDoc/DocReceiveUnitXML.jsp?isWfDoc=<%=isWfDoc%>&rightStr=<%=rightStr%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	//document.write(tree);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

//to use xtree,you must implement top() and showcom(node) functions

function top1(){
<%
	if(subcompanyid!=null&&!subcompanyid.equals("")&&!subcompanyid.equals("0")){
%>
	deeptree.scrollTop=com_<%=subcompanyid%>.offsetTop;
	deeptree.HighlightNode(com_<%=subcompanyid%>.parentElement);
	com_<%=subcompanyid%>.click();
	deeptree.ExpandNode(com_<%=subcompanyid%>.parentElement);
<%
	}else if(receiveUnitId!=null&&!receiveUnitId.equals("")&&!receiveUnitId.equals("0")){
%>
    deeptree.scrollTop=unit_<%=receiveUnitId%>.offsetTop;
    deeptree.HighlightNode(unit_<%=receiveUnitId%>.parentElement);
    unit_<%=receiveUnitId%>.click();
    deeptree.ExpandNode(unit_<%=receiveUnitId%>.parentElement);
<%
	}
%>
}

function showcom(node){
}

function check(node){
}

function setReceiveUnit(nodeid){
    var receiveUnitId = nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("id").value = receiveUnitId;

	if(receiveUnitId=="0"||receiveUnitId==0){
		document.SearchForm.action = "DocReceiveUnitTab.jsp?isWfDoc=<%=isWfDoc%>";
	}else{
		document.SearchForm.action = "DocReceiveUnitTab.jsp?_fromURL=2&isWfDoc=<%=isWfDoc%>";
	}

    document.SearchForm.submit();
}
function setSubcompany(nodeid){
    var subcompanyid = nodeid.substring(nodeid.lastIndexOf("_")+1);

    document.getElementById("subcompanyid").value = subcompanyid;

	document.SearchForm.action = "DocReceiveUnitTab.jsp?isWfDoc=<%=isWfDoc%>";

    document.SearchForm.submit();
}

function btnclear_onclick(){
	window.parent.returnvalue = {id:"",name:""};
	window.parent.close
}

	initTree();

</script>
