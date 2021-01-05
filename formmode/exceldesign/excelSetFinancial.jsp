<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script type="text/javascript" src="/formmode/exceldesign/js/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/formmode/exceldesign/js/jquery-ui-1.9.1.custom.min_wev8.js"></script>
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
   <jsp:param name="navName" value="财务格式设置"/>
</jsp:include> 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    	RCMenu += "{确定,javascript:confirmFun(),_top} " ;
    	RCMenuHeight += RCMenuHeightStep;
    	RCMenu += "{取消,javascript:cancelFun(),_top} " ;
    	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" id="zDialog_div_content" style="overflow:hidden;">
	<div class="slider_div">
		<div id="slider-range-max"></div>
	</div>
	<div class="financial_div">
		<span style="padding-right:20px">十</span>
		<span style="color:red">亿</span>
		<span>千</span>
		<span style="padding-right:22px">百</span>
		<span>十</span>
		<span style="color:red">万</span>
		<span>千</span>
		<span style="padding-right:22px">百</span>
		<span>十</span>
		<span style="color:red">元</span>
		<span>角</span>
		<span style="padding-right:0px;">分</span>
	</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="确定" class="zd_btn_submit" onclick="javascript:confirmFun()">
				<input type="button" value="取消" class="zd_btn_submit" onclick="javascript:cancelFun()">	    	
			</wea:item>
		</wea:group>
	</wea:layout>      
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>	
</BODY>
</HTML>