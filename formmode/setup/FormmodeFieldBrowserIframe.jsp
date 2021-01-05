
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
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/FormmodeFieldBrowser_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16757,user.getLanguage());//文档监控
String needfav ="1";
String needhelp ="";

String modeid = Util.null2String(request.getParameter("modeId"));
String type = Util.null2String(request.getParameter("type"));
String selfieldid = Util.null2String(request.getParameter("selfieldid"));
String fieldids = Util.null2String(request.getParameter("fieldids"));
String rownum = Util.null2String(request.getParameter("rownum"));
%>
<BODY>
<div class="zDialog_div_content" style="overflow-x:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>



<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<input type="hidden" id="modeid" name="modeid" value="<%=modeid %>" />
<input type="hidden" id="type" name="type" value="<%=type %>" />
<input type="hidden" id="selfieldid" name="selfieldid" value="<%=selfieldid %>" />
<input type="hidden" id="fieldids" name="fieldids" value="<%=fieldids %>" />
<input type="hidden" id="rownum" name="rownum" value="<%=rownum %>" />
<table id="topTitle" cellpadding="0" cellspacing="0"
				style="display: none;">
				<tr>
					<td></td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"
							id="zd_btn_submit" class="e8_btn_top" onclick="certain_click();">
						<!-- 保存 -->
						<span
							title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>"
							class="cornerMenu"></span>
					</td>
				</tr>
</table>
<div id="dialog">
	<div id='colShow'></div>
</div>
</div>
	
<script type="text/javascript">
var i = 0;
var dialog = null;
try{
	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(e){}
jQuery(document).ready(function(){
	resizeDialog(document);	
});

function certain_click(){
    var dest = $("#colShow").find("table.e8_box_target tbody tr");
    var ids = $("#colShow").find("#systemIds").val();
    var names = "";
    if(!!ids){
     dest.each(function(){
     	var name = jQuery(this).children("td").eq(1).text();
     	if(names==""){
     		names = name;
     	}else{
     		names=names + ","+name;
     	}
     });
    }
    var rownum = $("#rownum").val();
    if(dialog){
		try{
			dialog.callback({id:ids,name:names});
		}catch(e){}
		try{
			dialog.callbackfunParam = {rownum:rownum};
			dialog.close({id:ids,name:names});
		}catch(e){}
	}else{
		if(config.parentWin){
			config.parentWin.returnValue = {id:ids,name:names};
			config.parentWin.close();
		}else{
			window.parent.returnValue = {id:ids,name:names};
			window.parent.close();
		}
	}
}
</script>
	</BODY>
</HTML>






