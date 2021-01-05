<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String navname = SystemEnv.getHtmlLabelName(128060, user.getLanguage());
	String groupname = "Excel"+SystemEnv.getHtmlLabelName(34243, user.getLanguage());
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	String nodetypesql = "select  b.workflowname,nb.nodename from workflow_nodebase nb,workflow_flownode fn,workflow_base b where b.id= fn.workflowid and nb.id = fn.nodeid and nb.id="+nodeid;
	RecordSet.executeSql(nodetypesql);
	if(RecordSet.first())
		navname += " ("+Util.null2String(RecordSet.getString("workflowname"))+"-"+Util.null2String(RecordSet.getString("nodename"))+")";
%>
<html>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	var dialog;
	jQuery(document).ready(function(){
		dialog = window.top.getDialog(window);
	});
	
	function importExcel(){
		var filename = jQuery("#filename").val();
		if(check_form(document.impExcelForm,"filename")){
			if(filename.length>5&&filename.substring(filename.length-5)==".xlsx"){
				document.impExcelForm.submit();
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(128061, user.getLanguage())%>");//选择文件格式不正确,请选择xml文件25644
				return;
			}
		}
	}
	
</script>
</head>
<body>
<%@include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=navname %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="导入" onclick="importExcel()" class="e8_btn_top" id="btnok1">
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<form id="impExcelForm" name="impExcelForm" enctype="multipart/form-data" action="importExcelCheck.jsp" method="post">
	<input type="hidden" name="wfid" value="<%=Util.null2String(request.getParameter("wfid")) %>" />
	<input type="hidden" name="nodeid" value="<%=nodeid %>" />
	<input type="hidden" name="formid" value="<%=Util.null2String(request.getParameter("formid")) %>" />
	<input type="hidden" name="isbill" value="<%=Util.null2String(request.getParameter("isbill")) %>" />
	<input type="hidden" name="layouttype" value="<%=Util.null2String(request.getParameter("layouttype")) %>" />
	<wea:layout type="twoCol">
	    <wea:group context='<%=groupname %>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(125333, user.getLanguage())%>：</wea:item>
	    	<wea:item>
				<input class="InputStyle" type="file" name="filename" id="filename" onChange="checkinpute8(this,'filenamespan')">
				<span id="filenamespan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>     	
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>：</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(128062, user.getLanguage())%></wea:item>
	    </wea:group>
	</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>      
</div>
</body>
</HTML>
