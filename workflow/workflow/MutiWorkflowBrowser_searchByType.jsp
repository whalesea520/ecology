
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
	String needfav = "1";
	String needhelp = "";

	String moduleManageDetach = Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
%>

<BODY  oncontextmenu="return false;">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())
		
		+",javascript:document.SearchForm.btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())
		
		+",javascript:document.SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btncancel.click(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
		}
		%>
	<button type="button" class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display: none" id=btncancel onclick="btncancel_onclick()">
				<U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
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
	<table width=100% class="ViewForm" valign="top" height="100%">
		<!--######## Search Table Start########-->
		<TR>
		<td height=170 width="100%">
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
		<td>
		</tr>
	</table>
	<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
	<input class=inputstyle type="hidden" name="workflowids">
	<input class=inputstyle type="hidden" name="tabid">
	<input class=inputstyle type="hidden" name="typeid">
	<input class=inputstyle type="hidden" name="moduleManageDetach" id="moduleManageDetach">
	<!--########//Search Table End########-->
	</FORM>
</body>
</html>

<script language="javascript">
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(ex1){}

	function btnclear_onclick() {
		var returnjson = {id:"",name:""};
		if (dialog){
			try {
		    	dialog.callback(returnjson);
		    } catch(e) {}
			try {
		  		dialog.close(returnjson);
		 	} catch(e) {}
		} else {
			window.parent.parent.returnValue = returnjson;
	    	window.parent.parent.close();
		}
	}
	function btncancel_onclick(){
		if(dialog) {
		  	dialog.close();
		} else {
		   window.parent.parent.close();
		}
	}
	function btnok_onclick() {
		window.parent.frame2.btnok.click();
	}

	function initTree() {
		CXLoadTreeItem("", "/workflow/workflow/WorkflowXML.jsp?init=true&operatelevel=0&type=multiworkflowtype");
		var tree = new WebFXTree();
		tree.add(cxtree_obj);
		document.getElementById('deeptree').innerHTML = tree;
		cxtree_obj.expand();
	}
	//to use xtree,you must implement top() and showcom(node) functions

	function top111() {
	}
	function showcom(node) {
	}

	function doSearch() {
		jQuery("input[name=workflowids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
	    jQuery("#moduleManageDetach").val("<%=moduleManageDetach%>");
	    document.SearchForm.submit();
	}

	function setWorkflowType(nodeid) {
		document.all("tabid").value = 0;
	    var typeid = nodeid.substring(nodeid.lastIndexOf("_") + 1);
	    document.all("typeid").value = typeid;
	    doSearch();
	}

	jQuery(document).ready(function() {
		initTree();
	});
</script>