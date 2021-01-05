
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<!--以下是显示定制组件所需的js -->
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluing_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/showcol_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	.searchImg1{
		display:inline;
		cursor:pointer;
		padding-left:5px !important;
		padding-right:5px !important;
	}
</style>		
<script type="text/javascript">
  function jsHrmSrcSearch(){
  		var container = $("#colShow");
  		var val= jQuery("#flowTitle").val();
  		var target = container.find(".e8_box_source");
  		var srcitems=container.find(".e8_box_source").find("input[type='checkbox'][name='srcitem']");

  		for(var i=0;i<srcitems.length;i++){
			var trObj = jQuery(srcitems[i]).parent().parent();
     	var titlename = jQuery(trObj).children("td:eq(1)").text();

     	if( titlename && titlename.indexOf(val)==-1){
     		trObj.hide();
     	}else{
     		trObj.show();
     	}
    }
    target.scrollTop();
		jQuery("#dest_box_middle").perfectScrollbar("update");
  }
</script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16757,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<div class="zDialog_div_content" style="overflow-x:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>



<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="dialog">
	<div id='colShow'></div>
</div>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="saveShowColInfo();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
	    </wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</BODY>
</HTML>
