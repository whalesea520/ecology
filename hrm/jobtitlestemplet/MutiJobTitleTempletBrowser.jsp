<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/hrm/MutiJobTitleTempletBrowser_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("82662",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
</script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	var btnok_onclick = function(){
		jQuery("#btnok").click();
	}

	var btnclear_onclick = function(){
		jQuery("#btnclear").click();
	}
	
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>
</HEAD>
<%
String selectedids = Util.null2String(request.getParameter("selectedids"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82662 , user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY scroll="no" style="overflow-x: hidden;overflow-y:hidden">
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiDocBrowser.jsp" onsubmit="btnOnSearch();return false;" method=post>
<input type="hidden" name="pagenum" value=''>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
</DIV>
<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>
    <wea:item>
     	<brow:browser viewType="0" name="jobgroup" browserValue="" 
       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
       completeUrl="/data.jsp?type=jobgroup" browserSpanValue="">
     	</brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15855,user.getLanguage())%></wea:item>
    <wea:item>
     	<brow:browser viewType="0" name="jobactivity" browserValue="" 
       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
       completeUrl="/data.jsp?type=jobactivity" browserSpanValue="">
     	</brow:browser>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("6086,399",user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name="jobtitlemark" id="jobtitlemark" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("6086,15767",user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name="jobtitlename" id="jobtitlename" ></wea:item>
	</wea:group>
</wea:layout>
</div>
<div id="dialog">
	<div id='colShow' ></div>
</div>

<div style="width:0px;height:0px;overflow:hidden;">
	<button accessKey=T id=myfun1   type=button onclick="resetCondtion();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type=submit></BUTTON>
</div>
		</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0px!important;">
<div style="padding:5px 0px;">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
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
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
jQuery(document).ready(function(){
	showMultiDocDialog("<%=selectedids%>");
});
</SCRIPT>
</BODY>
</HTML>
