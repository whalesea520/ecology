<!DOCTYPE HTML>
<!-- Added by wcd 2014-12-18 -->
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*"%>
<html>
	<head>
		<style type="text/css">
			html{height:100%;}
		</style>
		<% // 增加参数判断缓存 
			int isIncludeToptitle = 0;
			response.setHeader("cache-control", "no-cache");
			response.setHeader("pragma", "no-cache");
			response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT"); 
		%>
		<meta http-equiv=Content-Type content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
		<script language="javascript" type="text/javascript"
			src="/FCKEditor/swfobject_wev8.js"></script>
		<!-- IE下专用vbs（临时） -->
		<script language="vbs" src="/js/string2VbArray.vbs"></script>
		<!-- js 整合到 init_wev8.js -->
		<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
		<script language="javascript" src="/js/wbusb_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>


		<script type="text/javascript" src="/js/ecology8/wTooltip/wTooltip_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>

		<script type="text/javascript" src="/js/ecology8/browserCommon_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/js/select/script/selectForK13_wev8.js"></script>

		<!--radio美化框-->
		<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
		<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>


		<!-- 下拉框美化组件-->
		<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

		<!-- 移除 -->

		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

		<!-- init.css, 所有css文件都在此文件中引入 -->
		<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/wui/theme/ecology8/templates/default/css/default_wev8.css" />
		<link type="text/css" rel="stylesheet" href="/js/tabs/css/e8tabs1_wev8.css" />
		<link type="text/css" rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
		<link type="text/css" rel="stylesheet" href="/wui/theme/ecology8/templates/default/css/default_wev8.css" />

		<script language=javascript>
			var ieVersion = 6;//ie版本
			
			jQuery(document).ready(function(){
				jQuery(".addbtn").hover(function(){
					jQuery(this).addClass("addbtn2");
				},function(){
					jQuery(this).removeClass("addbtn2");
				});
				
				jQuery(".delbtn").hover(function(){
					jQuery(this).addClass("delbtn2");
				},function(){
					jQuery(this).removeClass("delbtn2");
				});
				
				jQuery(".downloadbtn").hover(function(){
					jQuery(this).addClass("downloadbtn2");
				},function(){
					jQuery(this).removeClass("downloadbtn2");
				});
				var isNewPlugisSelect = jQuery("#isNewPlugisSelect");
				if(isNewPlugisSelect.length>0&&isNewPlugisSelect.val()!="1"){
					// do nothing
				}else{
					beautySelect();
				}
				
				jQuery("input[type=checkbox]").each(function(){
					if(jQuery(this).attr("tzCheckbox")=="true"){
						jQuery(this).tzCheckbox({labels:['','']});
					}
				});
				
				jQuery(window).resize(function(){
					resizeDialog();
				});
				
			});
			/**
			*清空搜索条件
			*/
			function resetCondtion(selector){
				resetCondition(selector);
			}
			
			function resetCondition(selector){
				if(!selector)selector="#advancedSearchDiv";
				//清空文本框
				jQuery(selector).find("input[type='text']").val("");
				//清空浏览按钮及对应隐藏域
				jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
				jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
				//清空下拉框
				jQuery(selector).find("select").selectbox("detach");
				jQuery(selector).find("select").val("");
				jQuery(selector).find("select").trigger("change");
				beautySelect(jQuery(selector).find("select"));
				//清空日期
				jQuery(selector).find(".calendar").siblings("span").html("");
				jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
				
				jQuery(selector).find("input[type='checkbox']").each(function(){
					changeCheckboxStatus(this,false);
				});
			}
			
			function resizeDialog(_document){
				if(!_document)_document = document;
				var bodyheight = jQuery(window).height();//_document.body.offsetHeight;
				var bottomheight = jQuery(".zDialog_div_bottom").css("height");
				var paddingBottom = jQuery(".zDialog_div_bottom").css("padding-bottom");
				var paddingTop = jQuery(".zDialog_div_bottom").css("padding-top");
				var headHeight = 0;
				var e8Box = jQuery(".zDialog_div_content").closest(".e8_box");
				if(e8Box.length>0){
					headHeight = e8Box.children(".e8_boxhead").height();
				}
				if(!!bottomheight && bottomheight.indexOf("px")>0){
					bottomheight = bottomheight.substring(0,bottomheight.indexOf("px"));
				}
				if(!!paddingBottom && paddingBottom.indexOf("px")>0){
					paddingBottom = paddingBottom.substring(0,paddingBottom.indexOf("px"));
				}
				if(!!paddingTop && paddingTop.indexOf("px")>0){
					paddingTop = paddingTop.substring(0,paddingTop.indexOf("px"));
				}
				if(isNaN(bottomheight)){
					bottomheight = 0;
				}else{
					bottomheight = parseInt(bottomheight);
				}
				if(isNaN(paddingBottom)){
					paddingBottom = 0;
				}else{
					paddingBottom = parseInt(paddingBottom);
				}
				if(isNaN(paddingTop)){
					paddingTop = 0;
				}else{
					paddingTop = parseInt(paddingTop);
				}
				if(document.documentMode!=5){
					jQuery(".zDialog_div_content").css("height",bodyheight-bottomheight-paddingTop-headHeight-7);
				}else{
					jQuery(".zDialog_div_content").css("height",bodyheight-bottomheight-paddingBottom-paddingTop-headHeight-7);
				}
			}
		</script>
	</head>
</html>
<!--For wui-->
<link type='text/css' rel='stylesheet' href='/wui/theme/ecology8/skins/default/wui_wev8.css' />

<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet' href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<script language="javascript"> 
/*
if (jQuery.client.version< 6) {
	document.getElementById('FONT2SYSTEMF').href = "/wui/common/css/notW7AVFont_wev8.css";
}
*/
</script>
<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 End -->
<script language="javascript">
//------------------------------
// the folder of current skins 
//------------------------------
//当前使用的主题
var GLOBAL_CURRENT_THEME = "ecology8";
//当前主题使用的皮肤
var GLOBAL_SKINS_FOLDER = "default";
</script>

<!--For wuiForm-->
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
	wuiform.init();
});
</script>