<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

String rightStr = Util.null2String(request.getParameter("rightStr"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
%>
<BODY onload="initTree()">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelectByRight.jsp" method=post target="frame2">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	BaseBean baseBean_self = new BaseBean();
	int userightmenu_self = 1;
	try{
		userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
	if(userightmenu_self == 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	%>
	<!-- 2012-08-15 ypc 修改 添加了btnok_onclick() 事件 -->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<!-- 2012-08-15 ypc 修改 添加了btnclear_onclick() 事件 -->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table width=100% class="ViewForm" valign="top">
	<!--######## Search Table Start########-->
	<TR>
	<td height=170>
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	</table>
	<!--########//Search Table End########-->
	<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
	<input class=inputstyle type="hidden" name="resourceids" id="resourceids" value='<%=resourceids%>'>
  <input class=inputstyle type="hidden" name="selectedids" id="selectedids" value='<%=selectedids%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount"> 
  <input class=inputstyle type="hidden" name="alllevel" id="alllevel" value="1"/>
  <input type="hidden" name="fromHrmStatusChange" id="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'>
  <input type="hidden" name="rightStr" id="rightStr" value='<%=rightStr%>'>
	</FORM>
</BODY>
</HTML>

<SCRIPT type="text/javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
    	dialog.callback(returnjson);
    }catch(e){}

		try{
	  	dialog.close(returnjson);
	 	}catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
    window.parent.parent.close();
	}
}

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}

function initTree(){
	CXLoadTreeItem("", "/hrm/tree/HrmCompany_XML.jsp?rightStr=<%=rightStr%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

function doSearch()
{
	jQuery("#selectedids").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
  //是否显示无账号人员
  if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked")){
    jQuery("#isNoAccount").val("1");
  }else{
    jQuery("#isNoAccount").val("0");
 	}
  
  //是否包含下级机构  
 	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel_c").attr("checked")){
    jQuery("#alllevel").val("1");
  }else{
    jQuery("#alllevel").val("0");
  }
  document.SearchForm.submit();
}
function setCompany(id){
  document.all("departmentid").value=""
  document.all("subcompanyid").value=""
  document.all("companyid").value=id
  document.all("tabid").value=0
  doSearch();
}
function setSubcompany(nodeid){
   subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
   document.all("companyid").value=""
   document.all("departmentid").value=""
   document.all("subcompanyid").value=subid
   document.all("tabid").value=0
   document.all("nodeid").value=nodeid
   doSearch()
}
function setDepartment(nodeid){
   deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
   document.all("subcompanyid").value=""
   document.all("companyid").value=""
   document.all("departmentid").value=deptid
   document.all("tabid").value=0
   document.all("nodeid").value=nodeid
   doSearch()
}
</script>
