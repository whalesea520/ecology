<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<!--以下是显示定制组件所需的js -->
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluing_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/showcol_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<body scroll="no">
<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
        <div>
        		<!-- <IFRAME name=frame1 id=frame1 width="100%" onload="update();" height="160px" frameborder=no scrolling=no></IFRAME>
         -->
           	<div class="zDialog_div_content" style="overflow-x:hidden;">
			<div id="dialog">
				<div id='colShow'></div>
			</div>
			</div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align: center;">
				<wea:layout needImportDefaultJsAndCss="false">
						<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
							<wea:item type="toolbar">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="saveShowColInfo();">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
				    </wea:item>
						</wea:group>
					</wea:layout>
			</div>
	    </div>
	</div>
</body>
</HTML>
<script type="text/javascript">
jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"frame1",
    mouldID:"<%=MouldIDConst.getID("hrm") %>",
    objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(32535, user.getLanguage())) %>,
	staticOnLoad:true
});
jQuery(document).ready(function(){
	resizeDialog(document);
	//document.getElementById("frame1").src = "/formmode/search/CustomSearchShowCol.jsp";
});
</script>