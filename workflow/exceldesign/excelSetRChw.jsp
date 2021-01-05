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
	String noticeinfo = "r".equals(isrc)?SystemEnv.getHtmlLabelName(23208, user.getLanguage()):SystemEnv.getHtmlLabelName(19509, user.getLanguage());
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
			$("[name=rchwval]").trigger("change");
		});
		$("[name=rchwval]").bind("change",function(){
			var val = jQuery.trim($(this).val());
			if(val === "*" && $("[name=rchwselect]:checked").val() == "2"){
			}else if(isNaN(val) || parseInt(val) <= 0)
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
		<input type="text" style="width:130px;" name="rchwval" id="rchwval" value="<%=defaultvar %>"/>
		<img src="/images/BacoError_wev8.gif" align=absmiddle style="<%="".equals(defaultvar)?"":"display:none" %>" />
		<span id="rchwfh">px</span>
		<%if(isrc.equals("c")) {%>
			<div style="padding: 10px;padding-left: 0px;">
				<input type="radio" name="rchwselect" checked value="1" > <%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%></input>
				&nbsp;
				<input type="radio" name="rchwselect" value="2" > <%=SystemEnv.getHtmlLabelName(1464, user.getLanguage())%></input>
			</div>
		<%} %>
		<p>
			<%if(isrc.equals("r")){ %>
				<span style="color:red;position:relative;top:35px;"><%=SystemEnv.getHtmlLabelName(128986, user.getLanguage())%></span>
			<%}else{ %>
				<span style="color:red;"><%=SystemEnv.getHtmlLabelName(128987, user.getLanguage())%></span>
			<%} %>
		</p>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="nextStepBtn"  class="zd_btn_cancle" onclick="setRChw();">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" id="cancelBtn"  class="zd_btn_cancle" onclick="dialog.close()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
</body>
</html>