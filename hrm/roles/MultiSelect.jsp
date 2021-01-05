<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	String selectids = Util.null2String(request.getParameter("selectids"));
	String resourceids = Util.null2String(request.getParameter("resourceids"));
	if(selectids.length()==0)selectids = resourceids;
	String rolesmark = Util.null2String(request.getParameter("rolesmark"));
	String rolesname = Util.null2String(request.getParameter("rolesname"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
	<script type="text/javascript">
		function showMultiDocDialog(selectids){
			var config = null;
			config= rightsplugingForBrowser.createConfig();
			config.srchead=["<%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(81710,user.getLanguage())%>"];
			config.container =$("#colShow");
			config.searchLabel="";
			config.hiddenfield="id";
			config.saveLazy = true;//取消实时保存
			config.srcurl = "/hrm/roles/MultiRolesAjax.jsp?src=src";
			config.desturl = "/hrm/roles/MultiRolesAjax.jsp?src=dest";
			config.pagesize = 10;
			config.parentWin = window.parent.parent;
			config.formId = "SearchForm";
			config.selectids = selectids;
			config.searchAreaId = "e8QuerySearchArea";
			config.dialog = dialog;
			jQuery("#colShow").html("");
			rightsplugingForBrowser.createRightsPluing(config);
			jQuery("#btnok").bind("click",function(){
				rightsplugingForBrowser.system_btnok_onclick(config);
			});
			jQuery("#btnclear").bind("click",function(){
				rightsplugingForBrowser.system_btnclear_onclick(config);
			});
			jQuery("#btncancel").bind("click",function(){
				rightsplugingForBrowser.system_btncancel_onclick(config);
			});
			jQuery("#btnsearch").bind("click",function(){
				rightsplugingForBrowser.system_btnsearch_onclick(config);
			});
		}

		function reset_onclick(){
			document.all("rolesname").value="";
			document.all("rolesmark").value="";
		}
	</script>

</head>
<body scroll="no">
<div class="zDialog_div_content">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			BaseBean baseBean_self = new BaseBean();
			int userightmenu_self = 1;
			try{
				userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
			}catch(Exception e){}	
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsearch.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<BUTTON class=btnSearch accessKey=S style="display:none" type="button" onclick="btnsearch_onclick()"  id="btnsearch" ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
		<BUTTON class=btnReset accessKey=T style="display:none" id=reset type="reset"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
		<input type="hidden" name="selectids" id="selectids" value='<%=selectids%>'>
		<input class=inputstyle type="hidden" name="resourceids" >
		<input type="hidden" name="isinit" value="1"/>
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				<wea:item> 
				  <input class=inputstyle id=rolesmark name=rolesmark value="">
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
				<wea:item> 
				  <input class=inputstyle id=rolesname name=rolesname value="">
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
	</div>
	<div id="dialog">
			<div id='colShow'></div>
		</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
</div>

</body>
<SCRIPT language="javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}
function reBindCornerEvent(){
	var corner = jQuery("span.cornerMenu",parent.document);
	if(corner.length==0){
		window.setTimeout(function(){reBindCornerEvent();},500);
	}else{
		window.setTimeout(function(){
			var e8_head = jQuery(".e8_box",parent.document).find("div.e8_boxhead");
			if(e8_head.length==0){
				e8_head = jQuery(".e8_box",parent.document).find("div#rightBox");
			}
			var contentWindow = jQuery("#frame1",parent.document).get(0).contentWindow;
			corner.unbind("click",parent.initBindEvent).bind("click",function(){
				parent.bindCornerMenuEvent(e8_head,contentWindow,null);
			});
		},1000);
	}
	jQuery("#btnsearch").hide();
}
jQuery(document).ready(function(){
	showMultiDocDialog("<%=selectids%>");
});
</script>
</html>
