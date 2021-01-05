<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
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
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
String rightStr = Util.null2String(request.getParameter("rightStr"));
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
	//这里要在SearchForm.btnok.click()前面加上document 在火狐中才可以识别 2012-08-15 ypc 修改
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<!--2012-08-15 ypc 修改 确定:btnok_onclick() 清楚:btnclear_onclick() 在此页面是vbs 在Google和火狐是调用不到的！-->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
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
<table height="100%" width=100% class="ViewForm" valign="top">
	<TR>
	<td>
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	</table>
  <input class=inputstyle type="hidden" id="groupid"  name="groupid">
	<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
  <input class=inputstyle type="hidden" name="resourceids" value="<%=resourceids %>">
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
  <input type="hidden" name="fromHrmStatusChange" id="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'>
  <input type="hidden" name="rightStr" id="rightStr" value='<%=rightStr%>'>
</FORM>
<script language="javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}

function initTree(){
	CXLoadTreeItem("", "/hrm/tree/ResourceMultiXMLByGroup.jsp");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}
	
function btnclear_onclick(){
  window.parent.parent.returnValue = {id:"",name:""};
  window.parent.parent.close();
}

function doSearch()
{
	jQuery("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
   //是否显示无账号人员 
   if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked")){
     jQuery("#isNoAccount").val("1");
   }else{
     jQuery("#isNoAccount").val("0");
   }
   document.SearchForm.submit();
}
function setGroup(id){
  jQuery("input[name=groupid]").val(id);
	jQuery("input[name=tabid]").val(1);
  doSearch();
}
function btncancel_onclick(){
	if(dialog){
  	dialog.close();
  }else{
    window.parent.parent.close();
	}   
}
</script>
</BODY>
</HTML>