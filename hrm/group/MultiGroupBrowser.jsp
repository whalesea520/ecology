<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld"  prefix="wea"%>
<%
boolean cansave = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
String _type = Util.null2String(request.getParameter("type"));
if(selectedids.length()==0)selectedids = resourceids;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(81554,user.getLanguage());
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
	<script type="text/javascript" src="/js/ecology8/hrm/MultiGroupBrowser_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("81554",user.getLanguage())%>");
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
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
</HEAD>
<BODY>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>&nbsp;
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span style="font-size: 12px;">
				<button style="BORDER-RIGHT: medium none;BORDER-TOP: medium none;OVERFLOW: hidden;  BACKGROUND-IMAGE: url(/images/ecology8/workflow/setting_wev8.png);WIDTH: 18px; CURSOR: pointer; BORDER-BOTTOM: 	medium none;BACKGROUND-REPEAT: no-repeat; HEIGHT: 18px;BACKGROUND-COLOR: transparent;position:relative;top: 3px; " 
						onclick='javascript:window.open("/systeminfo/menuconfig/CustomSetting.jsp?_fromURL=2");' ></button>
				<%=SystemEnv.getHtmlLabelName(126252,user.getLanguage()) %>
				</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:document.SearchForm.btnsearch.click()">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="btnOnSearch();return false;" method=post>
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
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item><input type="text" name="groupname" value=""></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
			<wea:item>
					<span>
						<select class=inputstyle id="type" name="type">
						<%
							if(cansave){
							%>
							<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<%
							}
							 %>
							<option value="0" <%=_type.equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(17618,user.getLanguage())%></option>
							<%
							if(cansave){
							%>
							<option value="1" <%=_type.equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(17619,user.getLanguage())%></option>
							<%
							}
							 %>
						</select>
					</span>
			</wea:item>
		</wea:group>
	</wea:layout>
	<div id="dialog" style="height: 225px;">
		<div id='colShow'></div>
	</div>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok  value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
			<input type="button" class=zd_btn_cancle accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
      <input type="button" class=zd_btn_submit accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>
</HTML>
