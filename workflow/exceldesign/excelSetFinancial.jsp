<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script type="text/javascript" src="/workflow/exceldesign/js/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/workflow/exceldesign/js/jquery-ui-1.9.1.custom.min_wev8.js"></script>
<HTML><HEAD>
<%
	String fvalue = Util.null2String(request.getParameter("financial"));
	int _fvalue = 3;
	if(!"".equals(fvalue)){
		if(fvalue.indexOf("-")>=0){
			_fvalue = Util.getIntValue(fvalue.split("-")[1],3);
		}
	}
%>
	<script type="text/javascript">
	    var dialog = window.top.getDialog(window);
		jQuery(document).ready(function(){
			$( "#slider-range-max" ).slider({
		      	range: "max",
		      	min: -12,
		      	max: -1,
		      	value: -<%=_fvalue%>,
		      	slide: function(event, ui) {
		      		//console.log("UI"+ui.value);
				}
		    });
		});
		
		function confirmFun(){
			var slider_val = $("#slider-range-max").slider("value");
			if(slider_val>-3)	slider_val=-3;
			dialog.close(slider_val);
		}
		
		function cancelFun(){
			dialog.close();
		}
	</script>
	<style type="text/css">
		.slider_div{padding:30px 25px 2px 25px;}
		.financial_div{padding:2px 20px 2px 22px;}
		.financial_div span{
			padding-right:21px;
			font-size:12px;
		}
	</style>
</HEAD>
<BODY style="overflow:hidden">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(128008, user.getLanguage())%>"/>
</jsp:include> 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(826, user.getLanguage())+",javascript:confirmFun(),_top} " ;
    	RCMenuHeight += RCMenuHeightStep;
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javascript:cancelFun(),_top} " ;
    	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" id="zDialog_div_content" style="overflow:hidden;">
	<div class="slider_div">
		<div id="slider-range-max"></div>
	</div>
	<div class="financial_div">
		<span style="padding-right:20px"><%=SystemEnv.getHtmlLabelName(82517, user.getLanguage())%></span>
		<span style="color:red"><%=SystemEnv.getHtmlLabelName(128009, user.getLanguage())%></span>
		<span><%=SystemEnv.getHtmlLabelName(128010, user.getLanguage())%></span>
		<span style="padding-right:22px"><%=SystemEnv.getHtmlLabelName(128011, user.getLanguage())%></span>
		<span><%=SystemEnv.getHtmlLabelName(82517, user.getLanguage())%></span>
		<span style="color:red"><%=SystemEnv.getHtmlLabelName(84393, user.getLanguage())%></span>
		<span><%=SystemEnv.getHtmlLabelName(128010, user.getLanguage())%></span>
		<span style="padding-right:22px"><%=SystemEnv.getHtmlLabelName(128011, user.getLanguage())%></span>
		<span><%=SystemEnv.getHtmlLabelName(82517, user.getLanguage())%></span>
		<span style="color:red"><%=SystemEnv.getHtmlLabelName(15279, user.getLanguage())%></span>
		<span><%=SystemEnv.getHtmlLabelName(128012, user.getLanguage())%></span>
		<span style="padding-right:0px;"><%=SystemEnv.getHtmlLabelName(18928, user.getLanguage())%></span>
	</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" class="zd_btn_submit" onclick="javascript:confirmFun()">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="zd_btn_submit" onclick="javascript:cancelFun()">	    	
			</wea:item>
		</wea:group>
	</wea:layout>      
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>	
</BODY>
</HTML>