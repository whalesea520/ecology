<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String navname = "导入Excel模板";
	String groupname = "Excel模板导入";
	int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int layoutid = Util.getIntValue(request.getParameter("layoutid"), 0);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"));
	int isdefault = Util.getIntValue(request.getParameter("isdefault"), 0);
	String modenamesql = "select modename from modeinfo where id="+modeid;
	RecordSet.executeSql(modenamesql);
	if(RecordSet.first())
		navname += " ("+Util.null2String(RecordSet.getString("modename"))+")";
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
				alert("选择文件格式不正确,请选择.xlsx文件");//选择文件格式不正确,请选择xml文件25644
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
	<input type="hidden" name="modeid" value="<%=modeid %>" />
	<input type="hidden" name="formid" value="<%=formid %>" />
	<input type="hidden" name="layoutid" value="<%=layoutid %>" />
	<input type="hidden" name="layouttype" value="<%=layouttype %>" />
	<input type="hidden" name="isdefault" value="<%=isdefault %>" />
	<wea:layout type="twoCol">
	    <wea:group context='<%=groupname %>'>
	    	<wea:item>选择文件：</wea:item>
	    	<wea:item>
				<input class="InputStyle" type="file" name="filename" id="filename" onChange="checkinpute8(this,'filenamespan')">
				<span id="filenamespan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>     	
	    	</wea:item>
	    	<wea:item>说明：</wea:item>
	    	<wea:item>请上传小于或等于5M的以.xlsx结尾的Excel文件</wea:item>
	    </wea:group>
	</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
		    	<input type="button" value="关闭" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</HTML>
