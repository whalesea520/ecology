<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

String selectedids = Util.null2String(request.getParameter("selectedids"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
if(selectedids.length()==0)selectedids = resourceids;
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
%>
<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/hrm/MultiJobtitlesBrowser_wev8.js"></script>
	<style>
	.e8_box_middle{
		height: 320px;
	}
	</style>
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("6086",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
		
	jQuery(document).ready(function(){
		showMultiDocDialog("<%=selectedids%>");
	});
	function btnOnSearch(){
	  jQuery("#btn_Search").trigger("click");
	}
	</script>
</HEAD>
<body scroll="no">
<div class="zDialog_div_content">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="cmd" value='HrmJobTitlesMultiSelect'>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="selectedids" id="selectedids" value='<%=selectedids%>'>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>		
		<%
		RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(197, user.getLanguage())
				+ ",javascript:document.SearchForm.btnsearch.click(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		%>
		<DIV align=right style="display: none">
		<button type="button" class=btnSearch accessKey=S type=submit
			id=btnsearch onclick="javascript:btnOnSearch(),_self">
			<U>S</U>-<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>
		</DIV>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:document.SearchForm.btnsearch.click()">
			  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="jobgroupid" browserValue='' 
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobgroups/JobGroupsBrowser.jsp?selectedids="
	      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=jobgroup"
	      browserSpanValue=''>
	      </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15855,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="jobactivitieid" browserValue='' 
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
	      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=jobactivity"
	      browserSpanValue=''>
	      </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("6086,15767",user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle name="jobtitlename" id="jobtitlename" ></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("6086,399",user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle name="jobtitlemark" id="jobtitlemark" ></wea:item>
		</wea:group>
	</wea:layout>
		<div id="dialog" style="height: 225px;">
			<div id='colShow'></div>
		</div>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
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
</html>