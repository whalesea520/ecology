<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<%
	String isrc = Util.null2String(request.getParameter("isrc"));
	String defaultvar = Util.null2String(request.getParameter("defaultvar"),"");
	if("0".equals(defaultvar) || "-1".equals(defaultvar))
		defaultvar = "";
	String iscolpercent = Util.null2String(request.getParameter("iscolpercent"));
	String noticeinfo = "r".equals(isrc)?"行高":"列宽";
%>
<head>

<script type="text/javascript">
	var dialog = window.top.getDialog(window);
	function setRChw(){
		var rchwval = jQuery.trim($('#rchwval').val());
		if(rchwval === ""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage()) %>");
			return;
		}
		var isrc = "<%=isrc%>";
		var djson;
		if(isrc === "r")
			djson = {value:$('#rchwval').val()};
		else
			djson = {value:$('#rchwval').val(),type:$("[name=rchwselect]:checked").val()};
		dialog.close(djson);
	}
	
	$(document).ready( function() {
		$("[name=rchwselect]").bind("click",function(){
			if($(this).val() === "1")	
				$("#rchwfh").text("px");
			else 
				$("#rchwfh").text("%");
		});
		$("[name=rchwval]").bind("blur",function(){
			var val = jQuery.trim($(this).val());
			if(isNaN(val) || parseInt(val) <= 0)
				$(this).val("");
			if(jQuery.trim($(this).val()) === "")
				$(this).parent().find("img").show();
			else
				$(this).parent().find("img").hide();
		});
		var iscolpercent = "<%=iscolpercent%>";
		if(iscolpercent === "true"){
			$("#rchwfh").text("%");
			$("input[name=rchwselect][value=1]").attr("checked",false).next().removeClass("jNiceChecked");
			$("input[name=rchwselect][value=2]").attr("checked",true).next().addClass("jNiceChecked");
		}
	});
</script>
</head>
<body style='OVERFLOW: hidden' scroll='no'>
	<div style="font-size:9pt;margin:10px;">
		<span><%=noticeinfo %>: </span>
		<input type="text" name="rchwval" id="rchwval" value="<%=defaultvar %>"/>
		<img src="/images/BacoError_wev8.gif" align=absmiddle style="<%="".equals(defaultvar)?"":"display:none" %>" />
		<span id="rchwfh">px</span>
		<%if(isrc.equals("c")) {%>
			<div style="padding: 10px;padding-left: 0px;">
				<input type="radio" name="rchwselect" checked value="1" > 像素</input>
				&nbsp;
				<input type="radio" name="rchwselect" value="2" > 百分比</input>
			</div>
		<%} %>
		<p>
			<%if(isrc.equals("r")){ %>
				<span style="color:red;position:relative;top:35px;">注：行高值不能为零或负数！</span>
			<%}else{ %>
				<span style="color:red;">注：列宽值不能为零或负数！</span>
			<%} %>
		</p>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="确定" id="nextStepBtn"  class="zd_btn_cancle" onclick="setRChw();">
			    	<input type="button" value="取消" id="cancelBtn"  class="zd_btn_cancle" onclick="dialog.close()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
</body>
</html>