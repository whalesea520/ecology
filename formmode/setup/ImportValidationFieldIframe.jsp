
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
<!-- <script type="text/javascript" src="/formmode/js/FormmodeFieldBrowser_wev8.js"></script> -->
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16757,user.getLanguage());//文档监控
String needfav ="1";
String needhelp ="";

String modeid = Util.null2String(request.getParameter("modeid"));
String formid = Util.null2String(request.getParameter("formid"));
String rownum = Util.null2String(request.getParameter("rownum"));
String selfieldid = Util.null2String(request.getParameter("fieldids"));
String selectid = Util.null2String(request.getParameter("selectid"));

%>
<BODY>
<div class="zDialog_div_content" style="overflow-x:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<input type="hidden" id="modeid" name="modeid" value="<%=modeid %>" />
<input type="hidden" id="formid" name="formid" value="<%=formid %>" />
<input type="hidden" id="selfieldid" name="selfieldid" value="<%=selfieldid %>" />
<input type="hidden" id="fieldids" name="fieldids" value="<%=selectid %>" />
<input type="hidden" id="fieldids" name="fieldids" value="<%=selectid %>" />
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
<script>
var parentWin = null;
var dialog = null;
var pageId = null;
var config = null;
jQuery(document).ready(function(){
	dialog = parent.parent.getDialog(parent);
	parentWin = parent.parent.getParentWindow(parent);
	showColDialog();
});

function showColDialog(){
	var modeid = document.getElementById("modeid").value;
	var formid = document.getElementById("formid").value;
	var selfieldid = document.getElementById("selfieldid").value;
	var fieldids = document.getElementById("fieldids").value;
	var rownum = document.getElementById("rownum").value;
	
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["列名"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.srcLabel = SystemEnv.getHtmlNoteName(3503,readCookie("languageidweaver"));
    config.targetLabel = SystemEnv.getHtmlNoteName(3504,readCookie("languageidweaver"));
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.saveurl= "/weaver/weaver.formmode.setup.ImportValidationFieldServlet?action=save";
    config.desturl = "/weaver/weaver.formmode.setup.ImportValidationFieldServlet?action=selected&fieldids="+selfieldid;
    config.srcurl = "/weaver/weaver.formmode.setup.ImportValidationFieldServlet?action=select&modeid="+modeid+"&formid="+formid+"&selfieldid="+selfieldid+"&fieldids="+fieldids;
    config.delteurl="/weaver/weaver.formmode.setup.ImportValidationFieldServlet?action=del";
    config.pagesize = 10;
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
}

/* function saveShowColInfo(){
	if(!!pageId){}else{
		pageId = jQuery("#pageId",parentWin.document).val();
	}
	function addItem(data){
		if(data.result=="1"){
			if(jQuery("span#searchblockspan",parentWin.parent.document).find("img:first").length>0){
					jQuery("span#searchblockspan",parentWin.parent.document).find("img:first").click();
				}else{
					parentWin.location.reload();
				}
			dialog.close();
		}else{
			parentWin.top.Dialog.alert(data.msg);
		}
	}
	 var saveurl = config.saveurl + "&systemIds="+jQuery("#systemIds").val();
	 ajaxHandler(saveurl, "", addItem, "json", false);
} */
</script>
	</BODY>
</HTML>